$ErrorActionPreference = "Stop"

Describe "portable safety invariants" {
    BeforeAll {
        $script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        $script:CSharpSkill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-csharp-common/SKILL.md")
        $script:PythonSkill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-python/SKILL.md")
    }

    It "documents C# destructive-operation safety" {
        $script:CSharpSkill | Should -Match 'Destructive-operation safety'
        $script:CSharpSkill | Should -Match 'Never bare `\.Delete\(\)`'
        $script:CSharpSkill | Should -Match 'Transaction'
        $script:CSharpSkill | Should -Match 'ExclusiveAccess'
        $script:CSharpSkill | Should -Match 'compile_check'
    }

    It "documents Python destructive-operation safety" {
        $script:PythonSkill | Should -Match 'Destructive-operation safety'
        $script:PythonSkill | Should -Match 'delete\(\)'
        $script:PythonSkill | Should -Match 'start_transaction\(\)'
        $script:PythonSkill | Should -Match 'end_transaction\(\)'
        $script:PythonSkill | Should -Match 'compile_check'
        $script:PythonSkill | Should -Match 'C# Openness or MCP'
    }
}
