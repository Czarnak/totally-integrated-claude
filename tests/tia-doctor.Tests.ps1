$ErrorActionPreference = "Stop"

Describe "tia-doctor probe helpers" {
    BeforeAll {
        $script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        . (Join-Path $script:RepoRoot "skills/tia-doctor/probe.ps1")
    }

    It "creates machine-readable result objects" {
        $result = New-TiaDoctorResult -Id "sample" -Name "Sample" -Status "pass" -Required $true -Detail "ok" -Remediation "none" -Evidence @{ path = "x" }

        $result.id | Should Be "sample"
        $result.status | Should Be "pass"
        $result.required | Should Be $true
        $result.evidence.path | Should Be "x"
    }

    It "returns exit code 1 when a required check fails" {
        $results = @(
            (New-TiaDoctorResult -Id "a" -Name "A" -Status "pass" -Required $true -Detail "ok" -Remediation "none"),
            (New-TiaDoctorResult -Id "b" -Name "B" -Status "fail" -Required $true -Detail "missing" -Remediation "fix")
        )

        Get-TiaDoctorExitCode -Results $results | Should Be 1
    }

    It "returns exit code 0 when only optional checks warn" {
        $results = @(
            (New-TiaDoctorResult -Id "a" -Name "A" -Status "pass" -Required $true -Detail "ok" -Remediation "none"),
            (New-TiaDoctorResult -Id "b" -Name "B" -Status "warn" -Required $false -Detail "missing" -Remediation "fix")
        )

        Get-TiaDoctorExitCode -Results $results | Should Be 0
    }

    It "converts results to the documented JSON manifest shape" {
        $results = @(
            (New-TiaDoctorResult -Id "a" -Name "A" -Status "pass" -Required $true -Detail "ok" -Remediation "none")
        )

        $manifest = New-TiaDoctorManifest -Results $results
        $json = $manifest | ConvertTo-Json -Depth 8
        $parsed = $json | ConvertFrom-Json

        $parsed.status | Should Be "pass"
        $parsed.results[0].id | Should Be "a"
    }

    It "reports Siemens TIA Openness group membership as a required check" {
        $result = Test-OpennessUserGroup

        $result.id | Should Be "openness-user-group"
        $result.required | Should Be $true
        $result.evidence.group | Should Be "Siemens TIA Openness"
        if ($result.status -eq "pass") {
            $result.remediation | Should Be "No action required."
        } else {
            $result.remediation | Should Match "sign out and sign back in"
        }
    }
}
