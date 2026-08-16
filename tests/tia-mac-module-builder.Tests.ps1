$ErrorActionPreference = "Stop"

Describe "TIA MAC Module Builder skill contract" {
    BeforeAll {
        $script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        $script:SkillRoot = Join-Path $script:RepoRoot "skills/tia-mac-module-builder"
        $script:ReadOptionalText = {
            param([string]$Path)

            if (Test-Path -LiteralPath $Path) {
                return Get-Content -Raw -LiteralPath $Path
            }

            return ""
        }
    }

    It "publishes the skill and focused references" {
        $requiredFiles = @(
            "SKILL.md",
            "references/architecture-and-lifecycle.md",
            "references/project-and-dependencies.md",
            "references/resources-packaging-and-trust.md",
            "references/testing-and-qualification.md"
        )

        foreach ($relativePath in $requiredFiles) {
            $path = Join-Path $script:SkillRoot $relativePath
            (Test-Path -LiteralPath $path) | Should -BeTrue -Because "$relativePath is part of the public MAC skill contract"
        }

        $skill = & $script:ReadOptionalText (Join-Path $script:SkillRoot "SKILL.md")
        $skill | Should -Match '(?m)^name:\s*tia-mac-module-builder\s*$'

        foreach ($relativePath in $requiredFiles | Where-Object { $_ -ne "SKILL.md" }) {
            $skill | Should -Match ([regex]::Escape($relativePath.Replace('\', '/')))
        }
    }

    It "documents the supported baseline, ownership model, lifecycle, and proof boundary" {
        $content = @(
            & $script:ReadOptionalText (Join-Path $script:SkillRoot "SKILL.md")
            & $script:ReadOptionalText (Join-Path $script:SkillRoot "references/architecture-and-lifecycle.md")
            & $script:ReadOptionalText (Join-Path $script:SkillRoot "references/project-and-dependencies.md")
            & $script:ReadOptionalText (Join-Path $script:SkillRoot "references/resources-packaging-and-trust.md")
            & $script:ReadOptionalText (Join-Path $script:SkillRoot "references/testing-and-qualification.md")
        ) -join "`n"

        $requiredPatterns = @(
            'MAC\s+V21\.0\.5',
            'TIA Portal V21',
            '\.NET Framework 4\.8',
            'TiaEquipmentModule',
            '\bCleanUp\b',
            '\bInit\b',
            '\bPostInit\b',
            '\bBuild\b',
            '\bRefine\b',
            '\bComplete\b',
            'Base\*GeneratedItems\.cs',
            'TiaImports/ResourceManagement\.cs',
            'TiaImports/GeneratedClasses',
            'Model/UseCases',
            'CustomLibraryClasses',
            'tia-csharp-common',
            'explicit live-operation authorization',
            'do not prove live TIA behavior',
            'MacFunctionTest',
            'MacGenerationTest'
        )

        foreach ($pattern in $requiredPatterns) {
            $content | Should -Match $pattern
        }

    }

    It "resolves the PublicAPI version from the target before applying the V21 baseline" {
        $projectDependencies = & $script:ReadOptionalText (Join-Path $script:SkillRoot "references/project-and-dependencies.md")
        $projectDependencies | Should -Match 'target TIA Portal PublicAPI major/version'
        $projectDependencies | Should -Match 'registered PublicAPI location that matches the established target\s+version'
    }

    It "guards MAC GUI and CLI execution without inventing a command surface" {
        $qualification = & $script:ReadOptionalText (Join-Path $script:SkillRoot "references/testing-and-qualification.md")
        $qualification | Should -Match 'MAC GUI/CLI execution'
        $qualification | Should -Match 'Do not invent MAC CLI commands or switches'
    }

    It "routes MAC as a distinct implementation path" {
        $roadmap = & $script:ReadOptionalText (Join-Path $script:RepoRoot "skills/tia-openness-roadmap/SKILL.md")

        $roadmap | Should -Match '### MAC Module Builder path'
        $roadmap | Should -Match '`tia-mac-module-builder`'
        $roadmap | Should -Match 'skills/tia-mac-module-builder/SKILL\.md'
        $roadmap | Should -Match 'Implementation path:\s*MAC Module Builder'
        $roadmap | Should -Match 'If MAC Module Builder'
    }

    It "exposes MAC in pool documentation and plugin metadata" {
        $readme = & $script:ReadOptionalText (Join-Path $script:RepoRoot "README.md")
        $site = & $script:ReadOptionalText (Join-Path $script:RepoRoot "docs/index.html")
        $codexManifestText = & $script:ReadOptionalText (Join-Path $script:RepoRoot ".codex-plugin/plugin.json")
        $claudeManifestText = & $script:ReadOptionalText (Join-Path $script:RepoRoot ".claude-plugin/plugin.json")
        $marketplaceText = & $script:ReadOptionalText (Join-Path $script:RepoRoot ".claude-plugin/marketplace.json")

        $readme | Should -Match 'tia-mac-module-builder'
        $site | Should -Match 'tia-mac-module-builder'

        foreach ($manifestText in @($codexManifestText, $claudeManifestText, $marketplaceText)) {
            $manifestText | Should -Match 'Modular Application Creator'
        }

        $codexManifest = $codexManifestText | ConvertFrom-Json
        $claudeManifest = $claudeManifestText | ConvertFrom-Json
        $codexManifest.keywords | Should -Contain 'modular-application-creator'
        $codexManifest.keywords | Should -Contain 'module-builder'
        $claudeManifest.keywords | Should -Contain 'modular-application-creator'
        $claudeManifest.keywords | Should -Contain 'module-builder'
    }
}
