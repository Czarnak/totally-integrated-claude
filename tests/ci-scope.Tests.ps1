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
