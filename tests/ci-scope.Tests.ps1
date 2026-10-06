$ErrorActionPreference = "Stop"

Describe "hosted validation scope" {
    BeforeAll {
        $script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        $script:Workflow = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot ".github/workflows/validate.yml")
        $script:ReferenceAudit = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "tests/skill-content.Tests.ps1")
        $script:Validator = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "scripts/validate-repo.ps1")
    }

    It "keeps exact installed-reference assertions in an opt-in audit" {
        $script:ReferenceAudit | Should -Match 'Describe\s+"installed V21 reference audit"\s+-Tag\s+"ReferenceAudit"'
    }

    It "excludes reference audits from hosted Pester validation" {
        $script:Workflow | Should -Match 'Invoke-Pester\s+-Path\s+\./tests\s+-ExcludeTagFilter\s+ReferenceAudit\s+-CI'
    }

    It "runs the portable certified API baseline validator" {
        $script:Validator | Should -Match 'Test-TiaApiBaselineRepository'
    }
}

Describe "cross-client plugin packaging" {
    BeforeAll {
        $script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        $script:PortablePlugin = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "plugin.json") | ConvertFrom-Json
        $script:ClaudePlugin = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot ".claude-plugin/plugin.json") | ConvertFrom-Json
        $script:CodexPlugin = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot ".codex-plugin/plugin.json") | ConvertFrom-Json
        $script:PortableMcp = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "mcp.json") | ConvertFrom-Json
        $script:LegacyMcp = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot ".mcp.json") | ConvertFrom-Json
    }

    It "declares the portable schemas recognized by VS Code and Copilot" {
        $script:PortablePlugin.'$schema' | Should -BeExactly "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json"
        $script:PortableMcp.'$schema' | Should -BeExactly "https://agent-plugins.org/schemas/1.0.0/mcp.schema.json"
    }

    It "keeps plugin identity and release versions synchronized" {
        $script:PortablePlugin.name | Should -BeExactly $script:ClaudePlugin.name
        $script:PortablePlugin.name | Should -BeExactly $script:CodexPlugin.name
        $script:PortablePlugin.version | Should -BeExactly $script:ClaudePlugin.version
        $script:PortablePlugin.version | Should -BeExactly $script:CodexPlugin.version
    }

    It "uses portable component conventions rather than legacy manifest fields" {
        $allowedFields = @('$schema', 'name', 'version', 'description', 'author', 'homepage', 'repository', 'license', 'keywords', 'extensions')
        foreach ($property in $script:PortablePlugin.PSObject.Properties) {
            $property.Name | Should -BeIn $allowedFields
        }
        $script:ClaudePlugin.skills | Should -BeExactly "./skills/"
        $script:CodexPlugin.skills | Should -BeExactly "./skills/"
        $script:ClaudePlugin.mcpServers | Should -BeExactly "./.mcp.json"
        $script:CodexPlugin.mcpServers | Should -BeExactly "./.mcp.json"
    }

    It "exposes the same MCP servers and commands to every client" {
        $portableNames = @($script:PortableMcp.mcpServers.PSObject.Properties.Name | Sort-Object)
        $legacyNames = @($script:LegacyMcp.mcpServers.PSObject.Properties.Name | Sort-Object)
        $portableNames.Count | Should -BeGreaterThan 0
        ($portableNames -join ',') | Should -BeExactly ($legacyNames -join ',')
        foreach ($serverName in $legacyNames) {
            $server = $script:PortableMcp.mcpServers.PSObject.Properties[$serverName].Value
            $legacyServer = $script:LegacyMcp.mcpServers.PSObject.Properties[$serverName].Value
            $server.type | Should -BeExactly "stdio"
            $serverConfig = $server | Select-Object -Property * -ExcludeProperty type | ConvertTo-Json -Depth 20 -Compress
            $legacyConfig = $legacyServer | ConvertTo-Json -Depth 20 -Compress
            $serverConfig | Should -BeExactly $legacyConfig
        }
    }

    It "makes each shared skill discoverable by its directory name" {
        $skillDirs = @(Get-ChildItem -LiteralPath (Join-Path $script:RepoRoot "skills") -Directory)
        $skillDirs.Count | Should -BeGreaterThan 0
        foreach ($skillDir in $skillDirs) {
            $content = Get-Content -Raw -LiteralPath (Join-Path $skillDir.FullName "SKILL.md")
            $content | Should -Match ('\A---\r?\nname:\s*' + [regex]::Escape($skillDir.Name) + '\r?\n')
            $skillDir.Name | Should -Match '^[a-z0-9]+(?:-[a-z0-9]+)*$'
        }
    }
}
