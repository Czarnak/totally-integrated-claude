param(
    [switch] $Json,
    [int] $RequiredMajorVersion = 21,
    [switch] $SkipPython,
    [switch] $SkipMcp
)

$ErrorActionPreference = "Stop"

function New-TiaDoctorResult {
    param(
        [Parameter(Mandatory = $true)] [string] $Id,
        [Parameter(Mandatory = $true)] [string] $Name,
        [Parameter(Mandatory = $true)] [ValidateSet("pass", "warn", "fail")] [string] $Status,
        [Parameter(Mandatory = $true)] [bool] $Required,
        [Parameter(Mandatory = $true)] [string] $Detail,
        [Parameter(Mandatory = $true)] [string] $Remediation,
        [hashtable] $Evidence = @{}
    )

    [pscustomobject]@{
        id = $Id
        name = $Name
        status = $Status
        required = $Required
        detail = $Detail
        remediation = $Remediation
        evidence = [pscustomobject] $Evidence
    }
}

function Find-CommandPath {
    param([string[]] $Names)

    foreach ($name in $Names) {
        $command = Get-Command $name -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($null -ne $command) {
            return $command.Source
        }
    }
    return $null
}

function Join-DoctorArguments {
    param([string[]] $Arguments)

    ($Arguments | ForEach-Object {
        if ($_ -match '[\s"]') {
            '"' + ($_ -replace '"', '\"') + '"'
        } else {
            $_
        }
    }) -join " "
}

function Invoke-DoctorProcess {
    param(
        [Parameter(Mandatory = $true)] [string] $FileName,
        [string[]] $Arguments = @(),
        [int] $TimeoutMilliseconds = 5000
    )

    $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $FileName
    $startInfo.Arguments = Join-DoctorArguments -Arguments $Arguments
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.UseShellExecute = $false

    $process = [System.Diagnostics.Process]::Start($startInfo)
    if (-not $process.WaitForExit($TimeoutMilliseconds)) {
        try {
            $process.Kill()
        } catch {
        }
        return [pscustomobject]@{
            exitCode = $null
            stdout = ""
            stderr = "Timed out after $TimeoutMilliseconds ms"
            timedOut = $true
        }
    }

    [pscustomobject]@{
        exitCode = $process.ExitCode
        stdout = $process.StandardOutput.ReadToEnd()
        stderr = $process.StandardError.ReadToEnd()
        timedOut = $false
    }
}

function Get-CommonTiaPortalPaths {
    param([int] $RequiredMajorVersion = 21)

    $roots = @(
        ${env:ProgramFiles(x86)},
        $env:ProgramFiles
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique

    foreach ($root in $roots) {
        $automationRoot = Join-Path $root "Siemens\Automation"
        if (-not (Test-Path -LiteralPath $automationRoot)) {
            continue
        }
        Get-ChildItem -LiteralPath $automationRoot -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -eq "Portal V$RequiredMajorVersion" } |
            ForEach-Object {
                $portalExe = Join-Path $_.FullName "Bin\Siemens.Automation.Portal.exe"
                if (Test-Path -LiteralPath $portalExe) {
                    $portalExe
                }
            }
    }
}

function Get-TiaRegistryEvidence {
    if (-not $IsWindows -and $PSVersionTable.PSEdition -eq "Core") {
        return @()
    }

    $roots = @(
        "HKLM:\SOFTWARE\Siemens\Automation",
        "HKLM:\SOFTWARE\WOW6432Node\Siemens\Automation"
    )
    $evidence = New-Object System.Collections.Generic.List[string]
    foreach ($root in $roots) {
        if (-not (Test-Path $root)) {
            continue
        }
        Get-ChildItem -Path $root -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.PSChildName -match "Portal|TIA|Openness|V[0-9]+" } |
            Select-Object -First 20 |
            ForEach-Object { $evidence.Add($_.Name) }
    }
    return $evidence.ToArray()
}

function Test-TiaPortalInstall {
    param([int] $RequiredMajorVersion = 21)

    $paths = @(Get-CommonTiaPortalPaths -RequiredMajorVersion $RequiredMajorVersion)
    $registry = @(Get-TiaRegistryEvidence)
    $version = "V$RequiredMajorVersion"
    if ($paths.Count -gt 0) {
        return New-TiaDoctorResult -Id "tia-portal" -Name "TIA Portal install" -Status "pass" -Required $true -Detail "Detected TIA Portal $version executable." -Remediation "No action required." -Evidence @{
            paths = $paths
            registry = $registry
            version = $version
        }
    }

    New-TiaDoctorResult -Id "tia-portal" -Name "TIA Portal install" -Status "fail" -Required $true -Detail "TIA Portal $version executable was not found in the common Siemens install paths." -Remediation "Install TIA Portal $version (including Openness), or run a probe version that matches the installed Portal release." -Evidence @{
        paths = $paths
        registry = $registry
        version = $version
    }
}

function Get-OpennessAssemblyPaths {
    param([int] $RequiredMajorVersion = 21)

    $roots = @(
        ${env:ProgramFiles(x86)},
        $env:ProgramFiles
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique

    foreach ($root in $roots) {
        $automationRoot = Join-Path $root "Siemens\Automation"
        if (-not (Test-Path -LiteralPath $automationRoot)) {
            continue
        }
        Get-ChildItem -LiteralPath $automationRoot -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -eq "Portal V$RequiredMajorVersion" } |
            ForEach-Object {
                $publicApi = Join-Path $_.FullName "PublicAPI\V$RequiredMajorVersion\net48"
                if (Test-Path -LiteralPath $publicApi) {
                    Get-ChildItem -LiteralPath $publicApi -Filter "Siemens.Engineering*.dll" -File -ErrorAction SilentlyContinue |
                        ForEach-Object { $_.FullName }
                }
            }
    }
}

function Test-OpennessAssembly {
    param([int] $RequiredMajorVersion = 21)

    $requiredModule = "Siemens.Engineering.Base.dll"
    $assemblyPaths = @(Get-OpennessAssemblyPaths -RequiredMajorVersion $RequiredMajorVersion)
    $modules = @(
        foreach ($assemblyPath in $assemblyPaths) {
            $assemblyVersion = "unknown"
            try {
                $assemblyVersion = [System.Reflection.AssemblyName]::GetAssemblyName($assemblyPath).Version.ToString()
            } catch {
            }
            $fileVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($assemblyPath).FileVersion
            [pscustomobject]@{
                name = [System.IO.Path]::GetFileName($assemblyPath)
                path = $assemblyPath
                fileVersion = $fileVersion
                assemblyVersion = $assemblyVersion
            }
        }
    )
    $hasRequiredModule = @($modules | Where-Object { $_.name -eq $requiredModule }).Count -eq 1
    $version = "V$RequiredMajorVersion"

    if ($hasRequiredModule) {
        return New-TiaDoctorResult -Id "openness" -Name "TIA Openness V21 modular API" -Status "pass" -Required $true -Detail "Detected the $version modular Openness core and $($modules.Count) Siemens.Engineering module(s)." -Remediation "No action required." -Evidence @{
            requiredModule = $requiredModule
            version = $version
            modules = $modules
        }
    }

    New-TiaDoctorResult -Id "openness" -Name "TIA Openness V21 modular API" -Status "fail" -Required $true -Detail "Required $version modular core '$requiredModule' was not found in PublicAPI\$version\net48." -Remediation "Install or repair the TIA Portal $version Openness component; ancillary Siemens.Engineering modules alone are not a complete core API installation." -Evidence @{
        requiredModule = $requiredModule
        version = $version
        modules = $modules
    }
}

function Get-CurrentWindowsIdentityName {
    try {
        return [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    } catch {
        return $env:USERNAME
    }
}

function Test-PrincipalInWindowsGroup {
    param(
        [Parameter(Mandatory = $true)] [string] $GroupName
    )

    try {
        $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = [System.Security.Principal.WindowsPrincipal]::new($identity)
        return $principal.IsInRole($GroupName)
    } catch {
        return $false
    }
}

function Test-OpennessUserGroup {
    $groupName = "Siemens TIA Openness"
    $userName = Get-CurrentWindowsIdentityName
    if (Test-PrincipalInWindowsGroup -GroupName $groupName) {
        return New-TiaDoctorResult -Id "openness-user-group" -Name "Siemens TIA Openness user group" -Status "pass" -Required $true -Detail "Current user '$userName' is a member of '$groupName'." -Remediation "No action required." -Evidence @{
            user = $userName
            group = $groupName
        }
    }

    New-TiaDoctorResult -Id "openness-user-group" -Name "Siemens TIA Openness user group" -Status "fail" -Required $true -Detail "Current user '$userName' is not a member of '$groupName'." -Remediation "Add the current Windows user to the local '$groupName' group, then sign out and sign back in before using TIA Openness." -Evidence @{
        user = $userName
        group = $groupName
    }
}

function Test-PythonTiaScripting {
    $candidates = @(
        @{ Command = "py"; Args = @("-3.12", "-c", "import siemens_tia_scripting as ts; print(getattr(ts, '__version__', 'unknown'))") },
        @{ Command = "py"; Args = @("-3", "-c", "import siemens_tia_scripting as ts; print(getattr(ts, '__version__', 'unknown'))") },
        @{ Command = "python"; Args = @("-c", "import siemens_tia_scripting as ts; print(getattr(ts, '__version__', 'unknown'))") }
    )

    foreach ($candidate in $candidates) {
        $commandPath = Find-CommandPath -Names @($candidate.Command)
        if ($null -eq $commandPath) {
            continue
        }
        $result = Invoke-DoctorProcess -FileName $commandPath -Arguments $candidate.Args -TimeoutMilliseconds 8000
        if ($result.exitCode -eq 0) {
            return New-TiaDoctorResult -Id "python-tia-scripting" -Name "Python TIA Scripting" -Status "pass" -Required $true -Detail "siemens_tia_scripting imports successfully." -Remediation "No action required." -Evidence @{
                command = $candidate.Command
                version = $result.stdout.Trim()
            }
        }
    }

    New-TiaDoctorResult -Id "python-tia-scripting" -Name "Python TIA Scripting" -Status "fail" -Required $true -Detail "Could not import siemens_tia_scripting with py or python." -Remediation "Download TIA Scripting Python from Siemens, unzip it, then either set TIA_SCRIPTING to the extracted binaries directory or run py -3.12 -m pip install .\siemens_tia_scripting-x.x.x-cp312-cp312-win_amd64.whl from that binaries directory."
}

function Test-TiaMcp {
    $tiaMcp = Find-CommandPath -Names @("tia-mcp")
    if ($null -ne $tiaMcp) {
        return New-TiaDoctorResult -Id "tia-mcp" -Name "TIA MCP server" -Status "pass" -Required $true -Detail "tia-mcp is available on PATH." -Remediation "No action required." -Evidence @{ command = $tiaMcp }
    }

    $dotnet = Find-CommandPath -Names @("dotnet")
    if ($null -ne $dotnet) {
        $toolList = Invoke-DoctorProcess -FileName $dotnet -Arguments @("tool", "list", "-g") -TimeoutMilliseconds 8000
        if ($toolList.exitCode -eq 0 -and $toolList.stdout -match "(?im)TiaMcpServer|tia-mcp") {
            return New-TiaDoctorResult -Id "tia-mcp" -Name "TIA MCP server" -Status "pass" -Required $true -Detail "TIA MCP server appears in dotnet global tools." -Remediation "No action required." -Evidence @{ command = "dotnet tool list -g" }
        }
    }

    New-TiaDoctorResult -Id "tia-mcp" -Name "TIA MCP server" -Status "fail" -Required $true -Detail "tia-mcp was not found on PATH or in dotnet global tools." -Remediation "Install it with: dotnet tool install -g TiaMcpServer"
}

function Invoke-TiaDoctorProbe {
    param(
        [int] $RequiredMajorVersion = 21,
        [switch] $SkipPython,
        [switch] $SkipMcp
    )

    Test-TiaPortalInstall -RequiredMajorVersion $RequiredMajorVersion
    Test-OpennessAssembly -RequiredMajorVersion $RequiredMajorVersion
    Test-OpennessUserGroup
    if (-not $SkipPython) {
        Test-PythonTiaScripting
    }
    if (-not $SkipMcp) {
        Test-TiaMcp
    }
}

function Get-TiaDoctorExitCode {
    param([object[]] $Results)

    foreach ($result in $Results) {
        if ($result.required -and $result.status -eq "fail") {
            return 1
        }
    }
    return 0
}

function New-TiaDoctorManifest {
    param([object[]] $Results)

    $exitCode = Get-TiaDoctorExitCode -Results $Results
    [pscustomobject]@{
        status = if ($exitCode -eq 0) { "pass" } else { "fail" }
        generatedAt = (Get-Date).ToUniversalTime().ToString("o")
        results = $Results
    }
}

function Write-TiaDoctorHumanSummary {
    param([object] $Manifest)

    Write-Host "TIA doctor: $($Manifest.status)"
    foreach ($result in $Manifest.results) {
        $marker = if ($result.status -eq "pass") { "PASS" } elseif ($result.status -eq "warn") { "WARN" } else { "FAIL" }
        Write-Host "[$marker] $($result.name): $($result.detail)"
        if ($result.status -ne "pass") {
            Write-Host "       Remediation: $($result.remediation)"
        }
    }
}

function Invoke-TiaDoctorMain {
    param(
        [switch] $JsonOutput,
        [int] $RequiredMajorVersion = 21,
        [switch] $SkipPython,
        [switch] $SkipMcp
    )

    try {
        $results = @(Invoke-TiaDoctorProbe -RequiredMajorVersion $RequiredMajorVersion -SkipPython:$SkipPython -SkipMcp:$SkipMcp)
        $manifest = New-TiaDoctorManifest -Results $results
        if ($JsonOutput) {
            $manifest | ConvertTo-Json -Depth 8
        } else {
            Write-TiaDoctorHumanSummary -Manifest $manifest
        }
        exit (Get-TiaDoctorExitCode -Results $results)
    } catch {
        if ($JsonOutput) {
            [pscustomobject]@{
                status = "error"
                generatedAt = (Get-Date).ToUniversalTime().ToString("o")
                error = $_.Exception.Message
            } | ConvertTo-Json -Depth 4
        } else {
            Write-Error "TIA doctor failed: $($_.Exception.Message)"
        }
        exit 2
    }
}

if ($MyInvocation.InvocationName -ne ".") {
    Invoke-TiaDoctorMain -JsonOutput:$Json -RequiredMajorVersion $RequiredMajorVersion -SkipPython:$SkipPython -SkipMcp:$SkipMcp
}
