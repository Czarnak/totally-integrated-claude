$ErrorActionPreference = "Stop"

$script:Failures = New-Object System.Collections.Generic.List[string]
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Add-Failure {
    param([string] $Message)
    $script:Failures.Add($Message)
}

function Resolve-RepoPath {
    param([string] $RelativePath)

    $clean = $RelativePath -replace "^[.][\\/]", ""
    return Join-Path $RepoRoot $clean
}

function Read-JsonFile {
    param([string] $Path)

    try {
        return Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json
    } catch {
        Add-Failure "$Path is not valid JSON: $($_.Exception.Message)"
        return $null
    }
}

function Test-ManifestRequiredFields {
    param(
        [string] $ManifestPath,
        [string[]] $RequiredFields,
        [hashtable] $ExpectedTypes
    )

    $manifest = Read-JsonFile -Path $ManifestPath
    if ($null -eq $manifest) {
        return
    }

    foreach ($required in $RequiredFields) {
        if ($null -eq $manifest.PSObject.Properties[$required]) {
            Add-Failure "$ManifestPath missing required property '$required'"
            continue
        }

        $expectedType = $ExpectedTypes[$required]
        if ([string]::IsNullOrWhiteSpace($expectedType)) {
            continue
        }

        $value = $manifest.PSObject.Properties[$required].Value
        if ($expectedType -eq "string" -and $value -isnot [string]) {
            Add-Failure "$ManifestPath property '$required' must be a string"
        } elseif ($expectedType -eq "object" -and ($value -is [string] -or $value -is [array])) {
            Add-Failure "$ManifestPath property '$required' must be an object"
        } elseif ($expectedType -eq "array" -and $value -isnot [array]) {
            Add-Failure "$ManifestPath property '$required' must be an array"
        }
    }
}

function Test-ExistingPath {
    param(
        [string] $Owner,
        [string] $RelativePath
    )

    $candidate = Resolve-RepoPath -RelativePath $RelativePath
    if (-not (Test-Path -LiteralPath $candidate)) {
        Add-Failure "$Owner references missing path '$RelativePath'"
    }
}

function Test-ManifestPathReferences {
    param(
        [string] $ManifestPath,
        [object] $Manifest
    )

    foreach ($propertyName in @("skills", "hooks", "lspServers", "mcpServers", "contextFileName")) {
        $property = $Manifest.PSObject.Properties[$propertyName]
        if ($null -ne $property -and $property.Value -is [string]) {
            Test-ExistingPath -Owner $ManifestPath -RelativePath $property.Value
        }
    }

    if ($Manifest.PSObject.Properties["plugins"]) {
        foreach ($plugin in $Manifest.plugins) {
            if ($plugin.PSObject.Properties["source"]) {
                Test-ExistingPath -Owner $ManifestPath -RelativePath ([string] $plugin.source)
            }
        }
    }
}

function Test-VersionSync {
    $paths = @(
        ".claude-plugin/plugin.json",
        ".codex-plugin/plugin.json",
        "gemini-extension.json"
    )
    $versions = @{}
    foreach ($path in $paths) {
        $manifest = Read-JsonFile -Path (Resolve-RepoPath $path)
        if ($null -ne $manifest -and $manifest.PSObject.Properties["version"]) {
            $versions[$path] = [string] $manifest.version
        }
    }

    if (($versions.Values | Select-Object -Unique).Count -gt 1) {
        $versionSummary = ($versions.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" } | Sort-Object) -join ", "
        Add-Failure "Manifest versions are not in sync: $versionSummary"
    }
}

function Test-RoadmapReferences {
    $roadmapPath = Resolve-RepoPath "skills/tia-openness-roadmap/SKILL.md"
    $content = Get-Content -Raw -LiteralPath $roadmapPath
    $matches = [regex]::Matches($content, "skills/[A-Za-z0-9._/-]+/SKILL[.]md")
    foreach ($match in $matches) {
        Test-ExistingPath -Owner "skills/tia-openness-roadmap/SKILL.md" -RelativePath $match.Value
    }
}

function Test-SkillFrontmatter {
    $skillFiles = Get-ChildItem -LiteralPath (Resolve-RepoPath "skills") -Filter "SKILL.md" -Recurse
    foreach ($skillFile in $skillFiles) {
        $lines = Get-Content -LiteralPath $skillFile.FullName
        if ($lines.Count -lt 4 -or $lines[0] -ne "---") {
            Add-Failure "$($skillFile.FullName) missing YAML frontmatter"
            continue
        }

        $end = -1
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -eq "---") {
                $end = $i
                break
            }
        }
        if ($end -lt 0) {
            Add-Failure "$($skillFile.FullName) has unterminated YAML frontmatter"
            continue
        }

        $frontmatter = $lines[1..($end - 1)] -join "`n"
        if ($frontmatter -notmatch "(?m)^name:\s*\S+") {
            Add-Failure "$($skillFile.FullName) frontmatter missing name"
        }
        if ($frontmatter -notmatch "(?m)^description:\s*\S+") {
            Add-Failure "$($skillFile.FullName) frontmatter missing description"
        }
    }
}

$manifestChecks = @(
    @{
        Manifest = ".claude-plugin/plugin.json"
        RequiredFields = @("name", "version", "description", "author", "license", "keywords", "skills", "lspServers", "mcpServers", "hooks")
        ExpectedTypes = @{
            name = "string"; version = "string"; description = "string"; author = "object";
            license = "string"; keywords = "array"; skills = "string"; lspServers = "string";
            mcpServers = "string"; hooks = "string"
        }
    },
    @{
        Manifest = ".codex-plugin/plugin.json"
        RequiredFields = @("name", "version", "description", "author", "license", "keywords", "skills", "hooks", "lspServers", "mcpServers", "interface")
        ExpectedTypes = @{
            name = "string"; version = "string"; description = "string"; author = "object";
            license = "string"; keywords = "array"; skills = "string"; hooks = "string";
            lspServers = "string"; mcpServers = "string"; interface = "object"
        }
    },
    @{
        Manifest = "gemini-extension.json"
        RequiredFields = @("name", "version", "description", "author", "license", "keywords", "contextFileName", "mcpServers")
        ExpectedTypes = @{
            name = "string"; version = "string"; description = "string"; author = "object";
            license = "string"; keywords = "array"; contextFileName = "string"; mcpServers = "object"
        }
    },
    @{
        Manifest = ".claude-plugin/marketplace.json"
        RequiredFields = @("name", "description", "owner", "plugins")
        ExpectedTypes = @{
            name = "string"; description = "string"; owner = "object"; plugins = "array"
        }
    }
)

foreach ($check in $manifestChecks) {
    $manifestPath = Resolve-RepoPath $check.Manifest
    Test-ExistingPath -Owner "manifest check" -RelativePath $check.Manifest
    if (Test-Path -LiteralPath $manifestPath) {
        Test-ManifestRequiredFields -ManifestPath $manifestPath -RequiredFields $check.RequiredFields -ExpectedTypes $check.ExpectedTypes
        $manifest = Read-JsonFile -Path $manifestPath
        if ($null -ne $manifest) {
            Test-ManifestPathReferences -ManifestPath $check.Manifest -Manifest $manifest
        }
    }
}

Test-VersionSync
Test-RoadmapReferences
Test-SkillFrontmatter

if ($script:Failures.Count -gt 0) {
    Write-Error ("Repository validation failed:`n - " + ($script:Failures -join "`n - "))
    exit 1
}

Write-Host "Repository validation passed."
