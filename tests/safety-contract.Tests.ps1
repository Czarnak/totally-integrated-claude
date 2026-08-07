$ErrorActionPreference = "Stop"

Describe "portable safety contracts" {
    BeforeAll {
        $script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        $script:CSharp = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-csharp-common/SKILL.md")
        $script:Plc = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/SKILL.md")
        $script:PlcLive = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/references/download-upload.md")
        $script:ImportExport = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-import-export/SKILL.md")
        $script:Devices = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-devices-general/SKILL.md")
        $script:Hmi = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-hmi-operations/SKILL.md")
        $script:Networks = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-networks/SKILL.md")
        $script:NetworkConnections = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-networks/references/communication-connections.md")
        $script:Drives = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-simatic-drives/SKILL.md")
        $script:DriveOverview = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-simatic-drives/references/drives-overview.md")
    }

    It "requires guarded C# destructive operations" {
        $script:CSharp | Should -Match '(?s)Never bare `\.Delete\(\)`.*ExclusiveAccess.*Transaction'
        $script:CSharp | Should -Match 'CommitOnDispose\(\).*only after every validation and mutation'
    }

    It "requires exact authorization and fail-closed handling for live PLC operations" {
        $script:Plc | Should -Match 'explicitly authorized the exact portal instance, project, CPU, and action'
        $script:PlcLive | Should -Match 'explicit live-operation authorization'
        $script:PlcLive | Should -Match 'fail closed'
    }

    It "guards project mutation and persistence across domain skills" {
        $script:ImportExport | Should -Match 'explicit authorization'
        $script:ImportExport | Should -Match 'Do not save'
        $script:Devices | Should -Match 'explicit authorization'
        $script:Devices | Should -Match 'Do not save'
        $script:Hmi | Should -Match 'exact selectors'
        $script:Hmi | Should -Match 'explicit authorization'
        $script:Hmi | Should -Match 'Do not save'
        $script:Drives | Should -Match 'exact selectors'
        $script:Drives | Should -Match 'Do not save'
    }

    It "fails closed when network dependency identity is incomplete" {
        $script:Networks | Should -Match 'dependency_evidence_incomplete'
        $script:Networks | Should -Match 'exact selectors'
        $script:Networks | Should -Match 'explicit authorization'
        $script:Networks | Should -Match 'Do not save'
        $script:NetworkConnections | Should -Match 'dependency_evidence_incomplete'
    }

    It "requires authorization before overwriting a drive Safety acceptance report" {
        $script:DriveOverview | Should -Match 'FileOperations\.Overwrite'
        $script:DriveOverview | Should -Match 'explicit overwrite authorization'
    }
}
