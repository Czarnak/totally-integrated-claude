$ErrorActionPreference = "Stop"

Describe "tia-write-guard" {
    BeforeAll {
        $script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        $script:GuardPath = Join-Path $script:RepoRoot "hooks/tia-write-guard.ps1"
        $script:PowerShellExe = (Get-Process -Id $PID).Path

        function Join-TestArguments {
            param([string[]] $Arguments)

            ($Arguments | ForEach-Object {
                if ($_ -match '[\s"]') {
                    '"' + ($_ -replace '"', '\"') + '"'
                } else {
                    $_
                }
            }) -join " "
        }

        function Invoke-TiaWriteGuard {
            param([string] $InputJson)

            $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
            $startInfo.FileName = $script:PowerShellExe
            $startInfo.Arguments = Join-TestArguments -Arguments @(
                "-NoProfile",
                "-ExecutionPolicy",
                "Bypass",
                "-File",
                $script:GuardPath
            )
            $startInfo.RedirectStandardInput = $true
            $startInfo.RedirectStandardOutput = $true
            $startInfo.RedirectStandardError = $true
            $startInfo.UseShellExecute = $false

            $process = [System.Diagnostics.Process]::Start($startInfo)
            $process.StandardInput.Write($InputJson)
            $process.StandardInput.Close()
            $stdout = $process.StandardOutput.ReadToEnd()
            $stderr = $process.StandardError.ReadToEnd()
            $process.WaitForExit()

            [pscustomobject]@{
                ExitCode = $process.ExitCode
                Output = $stdout | ConvertFrom-Json
                Error = $stderr
            }
        }
    }

    It "allows unknown tools" {
        $inputJson = @{ tool_name = "Read"; tool_input = @{} } | ConvertTo-Json -Compress
        $result = Invoke-TiaWriteGuard -InputJson $inputJson

        $result.ExitCode | Should -Be 0
        $result.Output.decision | Should -Be "allow"
    }

    It "denies missing confirm on write tools" {
        $inputJson = @{ tool_name = "mcp__tia-portal__delete_tag"; tool_input = @{ safetyToken = "abc" } } | ConvertTo-Json -Compress
        $result = Invoke-TiaWriteGuard -InputJson $inputJson

        $result.Output.decision | Should -Be "deny"
        $result.Output.reason | Should -Match "confirm=true"
    }

    It "denies missing safetyToken on write tools" {
        $inputJson = @{ tool_name = "mcp__tia-portal__delete_tag"; tool_input = @{ confirm = $true } } | ConvertTo-Json -Compress
        $result = Invoke-TiaWriteGuard -InputJson $inputJson

        $result.Output.decision | Should -Be "deny"
        $result.Output.reason | Should -Match "safetyToken"
    }

    It "allows valid write tool confirmation and token" {
        $inputJson = @{ tool_name = "mcp__tia-portal__delete_tag"; tool_input = @{ confirm = $true; safetyToken = "abc" } } | ConvertTo-Json -Compress
        $result = Invoke-TiaWriteGuard -InputJson $inputJson

        $result.Output.decision | Should -Be "allow"
    }

    It "denies malformed JSON" {
        $result = Invoke-TiaWriteGuard -InputJson "{not-json"

        $result.Output.decision | Should -Be "deny"
        $result.Output.reason | Should -Match "could not parse"
    }
}
