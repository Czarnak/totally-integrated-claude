$ErrorActionPreference = "Stop"

$script:Failures = New-Object System.Collections.Generic.List[string]
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

function Add-Failure {
    param([string] $Message)
    $script:Failures.Add($Message)
}

function Test-CertifiedTiaApiBaseline {
    $validationRepoRoot = [string] $RepoRoot
    $validatorPath = Join-Path $validationRepoRoot "scripts/api-baseline.ps1"
    $baselineRoot = Join-Path $validationRepoRoot "api-baselines/v21"

    try {
        . $validatorPath -RepoRoot $validationRepoRoot -BaselineRoot $baselineRoot
        $result = Test-TiaApiBaselineRepository -BaselineRoot $baselineRoot -RepoRoot $validationRepoRoot
        foreach ($errorMessage in @($result.errors)) {
            Add-Failure "TIA API baseline: $errorMessage"
        }
    } catch {
        Add-Failure "TIA API baseline validation failed: $($_.Exception.Message)"
    }
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
        ".codex-plugin/plugin.json"
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
    $matches = [regex]::Matches($content, "skills/[A-Za-z0-9._/-]+\.md")
    $seen = @{}
    foreach ($match in $matches) {
        if ($seen.ContainsKey($match.Value)) {
            continue
        }
        $seen[$match.Value] = $true
        Test-ExistingPath -Owner "skills/tia-openness-roadmap/SKILL.md" -RelativePath $match.Value
    }
}

function Test-OrphanedSkills {
    $roadmapPath = Resolve-RepoPath "skills/tia-openness-roadmap/SKILL.md"
    $content = Get-Content -Raw -LiteralPath $roadmapPath

    # Skills intentionally not reachable through roadmap routing.
    $standalone = @("tia-openness-roadmap", "plc-code-analysis")

    $skillDirs = Get-ChildItem -LiteralPath (Resolve-RepoPath "skills") -Directory
    foreach ($dir in $skillDirs) {
        if ($standalone -contains $dir.Name) {
            continue
        }
        if ($content -notmatch [regex]::Escape($dir.Name)) {
            Add-Failure "skills/tia-openness-roadmap/SKILL.md does not route to skill '$($dir.Name)' (orphaned - add a route or add it to the standalone allowlist)"
        }
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

function Test-TiaPortalMcpSkillSurface {
    $skillPath = Resolve-RepoPath "skills/tia-portal-mcp/SKILL.md"
    if (-not (Test-Path -LiteralPath $skillPath)) {
        Add-Failure "Expected TIA Portal MCP skill at 'skills/tia-portal-mcp/SKILL.md'"
        return
    }

    $content = Get-Content -Raw -LiteralPath $skillPath
    $currentTools = @(
        "execute_read_batch",
        "preview_write_batch",
        "apply_write_batch",
        "get_project_status",
        "open_project",
        "create_project",
        "save_project",
        "save_project_as",
        "archive_project",
        "close_project"
    )

    foreach ($tool in $currentTools) {
        if ($content -notmatch [regex]::Escape($tool)) {
            Add-Failure "skills/tia-portal-mcp/SKILL.md must document current public tool '$tool'"
        }
    }

    foreach ($stalePreviewTool in @(
        "preview_update_block_logic",
        "preview_create_tag_table",
        "preview_delete_tag_table",
        "preview_create_tag",
        "preview_update_tag",
        "preview_delete_tag",
        "preview_add_network_device",
        "preview_configure_network_device",
        "preview_open_project",
        "preview_create_project",
        "preview_save_project",
        "preview_save_project_as",
        "preview_archive_project",
        "preview_close_project"
    )) {
        if ($content -match [regex]::Escape($stalePreviewTool)) {
            Add-Failure "skills/tia-portal-mcp/SKILL.md must not document obsolete preview-per-tool name '$stalePreviewTool'"
        }
    }

    foreach ($requiredDescription in @(
        "read-only and non-binding",
        'Use `open_project` for deliberate session switching',
        "rebind:true",
        "validation_error",
        "binding_conflict",
        "state_changed",
        "worker_operation_failed",
        "worker_timeout",
        "worker_crashed",
        "postcondition_failed",
        "warnings"
    )) {
        if ($content -notmatch [regex]::Escape($requiredDescription)) {
            Add-Failure "skills/tia-portal-mcp/SKILL.md must document '$requiredDescription'"
        }
    }
}

$manifestChecks = @(
    @{
        Manifest = ".claude-plugin/plugin.json"
        RequiredFields = @("name", "version", "description", "author", "license", "keywords", "skills", "mcpServers")
        ExpectedTypes = @{
            name = "string"; version = "string"; description = "string"; author = "object";
            license = "string"; keywords = "array"; skills = "string";
            mcpServers = "string";
        }
    },
    @{
        Manifest = ".codex-plugin/plugin.json"
        RequiredFields = @("name", "version", "description", "author", "license", "keywords", "skills", "hooks", "mcpServers", "interface")
        ExpectedTypes = @{
            name = "string"; version = "string"; description = "string"; author = "object";
            license = "string"; keywords = "array"; skills = "string"; hooks = "string";
            mcpServers = "string"; interface = "object"
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
Test-OrphanedSkills
Test-SkillFrontmatter
Test-TiaPortalMcpSkillSurface
Test-CertifiedTiaApiBaseline

if ($script:Failures.Count -gt 0) {
    Write-Error ("Repository validation failed:`n - " + ($script:Failures -join "`n - "))
    exit 1
}

Write-Host "Repository validation passed."
