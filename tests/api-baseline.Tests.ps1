$ErrorActionPreference = "Stop"

Describe "portable V21 API baseline tooling" -Tag "ApiBaseline" {
    BeforeAll {
        $script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        $script:ToolPath = Join-Path $script:RepoRoot "scripts/api-baseline.ps1"
        $script:FixtureXml = Join-Path $PSScriptRoot "fixtures/api-baseline/Sample.xml"
        $script:BaselineRoot = Join-Path $script:RepoRoot "api-baselines/v21"
    }

    It "ships the portable baseline validator and maintainer extractor" {
        (Test-Path -LiteralPath $script:ToolPath) | Should -BeTrue
    }

    It "extracts a deterministic documented API surface from XML" {
        if (-not (Test-Path -LiteralPath $script:ToolPath)) {
            Set-ItResult -Skipped -Because "The baseline tool has not been implemented yet."
            return
        }

        . $script:ToolPath
        $surface = Get-TiaApiXmlSurface -XmlPath $script:FixtureXml

        @($surface.types) | Should -Be @(
            "Siemens.Engineering.Sample.Mode",
            "Siemens.Engineering.Sample.Widget"
        )
        @($surface.namespaces) | Should -Be @(
            "Siemens.Engineering",
            "Siemens.Engineering.Sample"
        )
        $surface.documentedMemberCounts.types | Should -Be 2
        $surface.documentedMemberCounts.methods | Should -Be 1
        $surface.documentedMemberCounts.properties | Should -Be 1
        $surface.documentedMemberCounts.fields | Should -Be 1
        $surface.documentedMemberCounts.events | Should -Be 1
        $surface.documentedMembersSha256 | Should -Be "3b23ffe9aeeb89a053f5f9fee657e484ce3b83d2021086815f147c5341067139"
    }

    It "reports exact type additions removals and member-surface changes" {
        if (-not (Test-Path -LiteralPath $script:ToolPath)) {
            Set-ItResult -Skipped -Because "The baseline tool has not been implemented yet."
            return
        }

        . $script:ToolPath
        $baseline = [pscustomobject]@{
            types = @("Example.A", "Example.B")
            documentedMembersSha256 = "old"
        }
        $candidate = [pscustomobject]@{
            types = @("Example.B", "Example.C")
            documentedMembersSha256 = "new"
        }

        $difference = Compare-TiaApiAssemblySurface -Baseline $baseline -Candidate $candidate

        $difference.matches | Should -BeFalse
        @($difference.addedTypes) | Should -Be @("Example.C")
        @($difference.removedTypes) | Should -Be @("Example.A")
        $difference.memberSurfaceChanged | Should -BeTrue
    }

    It "reports matching baseline directories without synthetic changes" {
        if (-not (Test-Path -LiteralPath $script:ToolPath)) {
            Set-ItResult -Skipped -Because "The baseline tool has not been implemented yet."
            return
        }

        . $script:ToolPath
        $baselineRoot = Join-Path $TestDrive "compare-baseline"
        $candidateRoot = Join-Path $TestDrive "compare-candidate"
        $null = New-Item -ItemType Directory -Path $baselineRoot, $candidateRoot
        $configuration = [pscustomobject]@{
            schemaVersion = 1
            tiaVersion = "V21"
            modules = @(
                [pscustomobject]@{
                    id = "sample"
                    required = $true
                    assemblies = @("Sample.Api.dll")
                }
            )
        }
        $assembly = [pscustomobject]@{
            name = "Sample.Api.dll"
            assemblyVersion = "1.0.0.0"
            fileVersion = "1.0.0.0"
            dllSha256 = "a" * 64
            xmlSha256 = "b" * 64
            types = @("Example.Widget")
            documentedMembersSha256 = "c" * 64
        }
        $moduleBaseline = [pscustomobject]@{
            assemblies = @($assembly)
        }
        $manifest = [pscustomobject]@{
            modules = @(
                [pscustomobject]@{
                    moduleId = "sample"
                    status = "installed"
                    blocking = $false
                }
            )
        }
        $configuration | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $baselineRoot "modules.json") -Encoding utf8
        $moduleBaseline | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $baselineRoot "sample.json") -Encoding utf8
        $moduleBaseline | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $candidateRoot "sample.json") -Encoding utf8
        $manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $candidateRoot "extraction-manifest.json") -Encoding utf8

        $result = Compare-TiaApiBaselineDirectories -BaselineRoot $baselineRoot -CandidateRoot $candidateRoot

        $result.status | Should -Be "pass"
        @($result.errors).Count | Should -Be 0
        @($result.changes).Count | Should -Be 0
    }

    It "does not make an absent optional module a blocking extraction failure" {
        if (-not (Test-Path -LiteralPath $script:ToolPath)) {
            Set-ItResult -Skipped -Because "The baseline tool has not been implemented yet."
            return
        }

        . $script:ToolPath
        $optional = [pscustomobject]@{
            id = "optional"
            required = $false
            assemblies = @("Optional.Api.dll")
        }
        $required = [pscustomobject]@{
            id = "core"
            required = $true
            assemblies = @("Required.Api.dll")
        }

        $optionalState = Get-TiaApiModuleInstallationState -Module $optional -PublicApiPath $TestDrive
        $requiredState = Get-TiaApiModuleInstallationState -Module $required -PublicApiPath $TestDrive

        $optionalState.status | Should -Be "not_installed"
        $optionalState.blocking | Should -BeFalse
        $requiredState.status | Should -Be "not_installed"
        $requiredState.blocking | Should -BeTrue
    }

    It "writes an extraction manifest when every absent module is optional" {
        if (-not (Test-Path -LiteralPath $script:ToolPath)) {
            Set-ItResult -Skipped -Because "The baseline tool has not been implemented yet."
            return
        }

        . $script:ToolPath
        $baselineRoot = Join-Path $TestDrive "baseline"
        $publicApiPath = Join-Path $TestDrive "public-api"
        $candidateRoot = Join-Path $TestDrive "candidate"
        $null = New-Item -ItemType Directory -Path $baselineRoot, $publicApiPath
        [pscustomobject]@{
            schemaVersion = 1
            tiaVersion = "V21"
            modules = @(
                [pscustomobject]@{
                    id = "optional"
                    displayName = "Optional module"
                    required = $false
                    documentationCoverage = "partial"
                    assemblies = @("Optional.Api.dll")
                    cataloguePaths = @()
                }
            )
        } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $baselineRoot "modules.json") -Encoding utf8

        $result = Invoke-TiaApiBaselineExtraction `
            -BaselineRoot $baselineRoot `
            -PublicApiPath $publicApiPath `
            -CandidateRoot $candidateRoot

        $result.status | Should -Be "pass"
        (Test-Path -LiteralPath (Join-Path $candidateRoot "extraction-manifest.json")) | Should -BeTrue
        $manifest = Get-Content -Raw -LiteralPath (Join-Path $candidateRoot "extraction-manifest.json") | ConvertFrom-Json
        $manifest.modules[0].status | Should -Be "not_installed"
    }

    It "emits valid CLI output without phantom errors for optional-only extraction" {
        if (-not (Test-Path -LiteralPath $script:ToolPath)) {
            Set-ItResult -Skipped -Because "The baseline tool has not been implemented yet."
            return
        }

        $baselineRoot = Join-Path $TestDrive "cli-baseline"
        $publicApiPath = Join-Path $TestDrive "cli-public-api"
        $jsonCandidateRoot = Join-Path $TestDrive "cli-json-candidate"
        $humanCandidateRoot = Join-Path $TestDrive "cli-human-candidate"
        $null = New-Item -ItemType Directory -Path $baselineRoot, $publicApiPath
        [pscustomobject]@{
            schemaVersion = 1
            tiaVersion = "V21"
            modules = @(
                [pscustomobject]@{
                    id = "optional"
                    displayName = "Optional module"
                    required = $false
                    documentationCoverage = "partial"
                    assemblies = @("Optional.Api.dll")
                    cataloguePaths = @()
                }
            )
        } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $baselineRoot "modules.json") -Encoding utf8

        $pwsh = Join-Path $PSHOME "pwsh.exe"
        $commonArguments = @(
            "-NoProfile",
            "-File", $script:ToolPath,
            "-Mode", "Extract",
            "-BaselineRoot", $baselineRoot,
            "-PublicApiPath", $publicApiPath
        )

        $jsonText = & $pwsh @commonArguments -CandidateRoot $jsonCandidateRoot -JsonOutput
        $jsonExitCode = $LASTEXITCODE
        $json = $jsonText | ConvertFrom-Json
        $humanText = (& $pwsh @commonArguments -CandidateRoot $humanCandidateRoot) -join "`n"
        $humanExitCode = $LASTEXITCODE

        $jsonExitCode | Should -Be 0
        $json.status | Should -Be "pass"
        $humanExitCode | Should -Be 0
        $humanText | Should -Match '\[WARN\] optional: not_installed'
        $humanText | Should -Not -Match '\[(?:ERROR|CHANGE)\]'
    }

    It "distinguishes invented documentation symbols from missing complete coverage" {
        if (-not (Test-Path -LiteralPath $script:ToolPath)) {
            Set-ItResult -Skipped -Because "The baseline tool has not been implemented yet."
            return
        }

        . $script:ToolPath
        $comparison = Compare-TiaApiDocumentationSurface `
            -BaselineTypes @("Example.Mode", "Example.Widget") `
            -BaselineNamespaces @("Example") `
            -DocumentedHeadings @("Example", "Example.Widget", "Example.Invented") `
            -Coverage "complete"

        @($comparison.invalidHeadings) | Should -Be @("Example.Invented")
        @($comparison.missingTypes) | Should -Be @("Example.Mode")
        $comparison.matches | Should -BeFalse
    }

    It "validates committed baselines without requiring a TIA installation" {
        if (-not (Test-Path -LiteralPath $script:ToolPath)) {
            Set-ItResult -Skipped -Because "The baseline tool has not been implemented yet."
            return
        }

        . $script:ToolPath
        $result = Test-TiaApiBaselineRepository -BaselineRoot $script:BaselineRoot -RepoRoot $script:RepoRoot

        $result.status | Should -Be "pass"
        $result.tiaInstallationRequired | Should -BeFalse
        $result.moduleCount | Should -Be 9
        @($result.errors).Count | Should -Be 0
    }
}
