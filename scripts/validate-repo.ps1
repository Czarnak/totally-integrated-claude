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
        ".codex-plugin/plugin.json",
        "plugin.json"
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

function Test-AgentPluginConfiguration {
    $manifest = Read-JsonFile -Path (Resolve-RepoPath "plugin.json")
    if ($null -ne $manifest) {
        if ($manifest.'$schema' -ne "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json") {
            Add-Failure "plugin.json must declare the Agent Plugins 1.0 schema"
        }
        if ($manifest.name -cnotmatch '^[a-z0-9](?:[a-z0-9.-]{0,62}[a-z0-9])?$' -or $manifest.name -match '--|\.\.') {
            Add-Failure "plugin.json has an invalid Agent Plugins name"
        }
        $allowedFields = @('$schema', 'name', 'version', 'description', 'author', 'homepage', 'repository', 'license', 'keywords', 'extensions')
        foreach ($property in $manifest.PSObject.Properties) {
            if ($property.Name -notin $allowedFields) {
                Add-Failure "plugin.json contains unsupported Agent Plugins field '$($property.Name)'"
            }
        }
        $claude = Read-JsonFile -Path (Resolve-RepoPath ".claude-plugin/plugin.json")
        if ($null -ne $claude -and $manifest.name -cne $claude.name) {
            Add-Failure "plugin.json and .claude-plugin/plugin.json must use the same plugin name"
        }
    }

    $portableMcp = Read-JsonFile -Path (Resolve-RepoPath "mcp.json")
    $legacyMcp = Read-JsonFile -Path (Resolve-RepoPath ".mcp.json")
    if ($null -eq $portableMcp -or $null -eq $legacyMcp) {
        return
    }
    if ($portableMcp.'$schema' -ne "https://agent-plugins.org/schemas/1.0.0/mcp.schema.json") {
        Add-Failure "mcp.json must declare the Agent Plugins 1.0 MCP schema"
    }
    foreach ($property in $portableMcp.PSObject.Properties) {
        if ($property.Name -notin @('$schema', 'mcpServers')) {
            Add-Failure "mcp.json contains unsupported top-level field '$($property.Name)'"
        }
    }
    $portableNames = @($portableMcp.mcpServers.PSObject.Properties.Name | Sort-Object)
    $legacyNames = @($legacyMcp.mcpServers.PSObject.Properties.Name | Sort-Object)
    if ($portableNames.Count -eq 0 -or ($portableNames -join ',') -cne ($legacyNames -join ',')) {
        Add-Failure "mcp.json and .mcp.json must declare the same MCP servers"
    }
    foreach ($serverName in $legacyNames) {
        $server = $portableMcp.mcpServers.PSObject.Properties[$serverName].Value
        $legacyServer = $legacyMcp.mcpServers.PSObject.Properties[$serverName].Value
        if ($null -eq $server) {
            continue
        }
        if ($server.type -ne "stdio") {
            Add-Failure "mcp.json server '$serverName' must declare the stdio transport"
        }
        $serverConfig = $server | Select-Object -Property * -ExcludeProperty type | ConvertTo-Json -Depth 20 -Compress
        $legacyConfig = $legacyServer | ConvertTo-Json -Depth 20 -Compress
        if ($serverConfig -cne $legacyConfig) {
            Add-Failure "mcp.json server '$serverName' must match .mcp.json apart from its transport type"
        }
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
        } elseif ($frontmatter -cmatch '(?m)^name:\s*([a-z0-9]+(?:-[a-z0-9]+)*)\s*$') {
            if ($Matches[1] -cne $skillFile.Directory.Name) {
                Add-Failure "$($skillFile.FullName) skill name must match its directory name"
            }
        } else {
            Add-Failure "$($skillFile.FullName) skill name must be plain kebab-case for Copilot discovery"
        }
        if ($frontmatter -notmatch "(?m)^description:\s*\S+") {
            Add-Failure "$($skillFile.FullName) frontmatter missing description"
        }
    }
}

function Test-TiaPythonSkillSurface {
    $skillRoot = Resolve-RepoPath "skills/tia-python"
    $requiredFiles = @(
        "SKILL.md",
        "references/global_portal.md",
        "references/plc.md",
        "references/hmi.md",
        "references/library.md",
        "references/project.md"
    )

    $contents = @{}
    foreach ($relativePath in $requiredFiles) {
        $path = Join-Path $skillRoot $relativePath
        if (-not (Test-Path -LiteralPath $path)) {
            Add-Failure "skills/tia-python is missing required file '$relativePath'"
            continue
        }
        $contents[$relativePath] = Get-Content -Raw -LiteralPath $path
    }

    if (-not $contents.ContainsKey("SKILL.md")) {
        return
    }

    $entrypoint = $contents["SKILL.md"]
    $packageContent = ($requiredFiles | ForEach-Object {
        if ($contents.ContainsKey($_)) { $contents[$_] }
    }) -join "`n"

    foreach ($requiredEntrypointFact in @(
        'Library: `siemens_tia_scripting` (v1.4.3)',
        'Python 3.12.x, 3.13.x, or 3.14.x',
        'TIA Portal V15.1',
        'V18-V21',
        'GeneralExportFormats',
        'GeneralExportOptions',
        'GeneralImportOptions',
        'ExecutionResult'
    )) {
        if ($entrypoint -notmatch [regex]::Escape($requiredEntrypointFact)) {
            Add-Failure "skills/tia-python/SKILL.md must document '$requiredEntrypointFact'"
        }
    }

    foreach ($requiredApi in @(
        'set_umac_credentials_by_config',
        'set_log_level',
        'get_devices',
        'get_modules',
        'get_download_configuration',
        'get_system_constants',
        'export_cfc_charts',
        'import_cfc_charts',
        'get_master_copies',
        'create_master_copy',
        'export_project_texts',
        'import_project_texts',
        'import_application_tests',
        'import_system_tests',
        'import_rule_sets',
        'login_to_safety'
    )) {
        if ($packageContent -notmatch [regex]::Escape($requiredApi)) {
            Add-Failure "skills/tia-python must document V1.4.3 API '$requiredApi'"
        }
    }

    foreach ($requiredReturnContract in @(
        'get_supported_export_format() -> List[str]',
        'commit_and_close(commit_message: str) -> int'
    )) {
        if ($packageContent -notmatch [regex]::Escape($requiredReturnContract)) {
            Add-Failure "skills/tia-python must document V1.4.3 return contract '$requiredReturnContract'"
        }
    }

    foreach ($fabricatedNoneContract in @(
        'get_supported_export_format() -> None',
        'commit_and_close(commit_message: str) -> None'
    )) {
        if ($packageContent -match [regex]::Escape($fabricatedNoneContract)) {
            Add-Failure "skills/tia-python must not fabricate return contract '$fabricatedNoneContract'"
        }
    }

    foreach ($requiredSafetyFact in @(
        'explicit live-operation authorization',
        'exact target',
        'project.end_transaction(rollback=True)',
        'pc_interface_type',
        'pc_interface_name',
        'target_interface'
    )) {
        if ($packageContent -notmatch [regex]::Escape($requiredSafetyFact)) {
            Add-Failure "skills/tia-python must document safety contract '$requiredSafetyFact'"
        }
    }

    foreach ($staleClaim in @(
        '(v1.1.0)',
        'ts.Enums.ExportFormats',
        'ts.Enums.ExportOptions',
        'ts.Enums.CleanUpMode',
        'ts.Enums.HarmonizeOptions',
        'ts.Enums.DependenciesMode',
        'LibraryTypeFolder',
        'pci_interface',
        'Password123',
        'Password!123',
        'mySecret'
    )) {
        if ($packageContent -match [regex]::Escape($staleClaim)) {
            Add-Failure "skills/tia-python must not retain stale or unsafe claim '$staleClaim'"
        }
    }

    foreach ($bareDestructiveExample in @(
        '(?m)^\s*project\.delete\(\)\s*(?:#.*)?$',
        '(?m)^\s*server\.delete\(\)\s*(?:#.*)?$',
        '(?m)^\s*(?:global_lib|project_lib)\.delete_folder\('
    )) {
        if ($packageContent -match $bareDestructiveExample) {
            Add-Failure "skills/tia-python contains an unguarded destructive example matching '$bareDestructiveExample'"
        }
    }
}

$manifestChecks = @(
    @{
        Manifest = "plugin.json"
        RequiredFields = @('$schema', "name", "version", "description", "author", "license", "keywords")
        ExpectedTypes = @{
            '$schema' = "string"; name = "string"; version = "string"; description = "string";
            author = "object"; license = "string"; keywords = "array"
        }
    },
    @{
        Manifest = "mcp.json"
        RequiredFields = @('$schema', "mcpServers")
        ExpectedTypes = @{ '$schema' = "string"; mcpServers = "object" }
    },
    @{
        Manifest = ".claude-plugin/plugin.json"
        RequiredFields = @("name", "version", "description", "author", "license", "keywords", "skills")
        ExpectedTypes = @{
            name = "string"; version = "string"; description = "string"; author = "object";
            license = "string"; keywords = "array"; skills = "string"
        }
    },
    @{
        Manifest = ".codex-plugin/plugin.json"
        RequiredFields = @("name", "version", "description", "author", "license", "keywords", "skills", "interface")
        ExpectedTypes = @{
            name = "string"; version = "string"; description = "string"; author = "object";
            license = "string"; keywords = "array"; skills = "string"; interface = "object"
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
Test-AgentPluginConfiguration
Test-RoadmapReferences
Test-OrphanedSkills
Test-SkillFrontmatter
Test-TiaPythonSkillSurface
Test-CertifiedTiaApiBaseline

if ($script:Failures.Count -gt 0) {
    Write-Error ("Repository validation failed:`n - " + ($script:Failures -join "`n - "))
    exit 1
}

Write-Host "Repository validation passed."
