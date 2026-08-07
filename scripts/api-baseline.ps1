[CmdletBinding()]
param(
    [ValidateSet("Validate", "Extract", "Compare")]
    [string] $Mode = "Validate",

    [string] $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")),

    [string] $BaselineRoot = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) "api-baselines/v21"),

    [string] $PublicApiPath,

    [string] $CandidateRoot = (Join-Path (Resolve-Path (Join-Path $PSScriptRoot "..")) "build/api-baseline-candidate/v21"),

    [switch] $Force,

    [switch] $JsonOutput
)

$ErrorActionPreference = "Stop"

function Get-TiaOrdinalSortedUnique {
    param([object[]] $Values)

    $set = New-Object "System.Collections.Generic.HashSet[string]" ([System.StringComparer]::Ordinal)
    foreach ($value in @($Values)) {
        if ($null -eq $value) {
            continue
        }
        $text = [string] $value
        if ([string]::IsNullOrWhiteSpace($text)) {
            continue
        }
        $null = $set.Add($text)
    }

    $result = [string[]] $set
    [array]::Sort($result, [System.StringComparer]::Ordinal)
    return $result
}

function Get-TiaSha256FromString {
    param([Parameter(Mandatory = $true)] [string] $Value)

    $algorithm = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
        $hash = $algorithm.ComputeHash($bytes)
        return (($hash | ForEach-Object { $_.ToString("x2") }) -join "")
    } finally {
        $algorithm.Dispose()
    }
}

function Get-TiaApiXmlSurface {
    param([Parameter(Mandatory = $true)] [string] $XmlPath)

    if (-not (Test-Path -LiteralPath $XmlPath -PathType Leaf)) {
        throw "API XML documentation was not found: $XmlPath"
    }

    [xml] $document = Get-Content -Raw -LiteralPath $XmlPath
    $memberIds = @(
        $document.doc.members.member |
            ForEach-Object { [string] $_.name } |
            Where-Object { $_ -match "^[TMPFE]:" }
    )
    $memberIds = @(Get-TiaOrdinalSortedUnique -Values $memberIds)

    $types = @(
        $memberIds |
            Where-Object { $_.StartsWith("T:", [System.StringComparison]::Ordinal) } |
            ForEach-Object { $_.Substring(2) }
    )
    $types = @(Get-TiaOrdinalSortedUnique -Values $types)

    $namespaceCandidates = New-Object System.Collections.Generic.List[string]
    foreach ($typeName in $types) {
        $segments = @($typeName.Split("."))
        for ($length = 2; $length -lt $segments.Count; $length++) {
            $namespaceCandidates.Add(($segments[0..($length - 1)] -join "."))
        }
    }
    $namespaces = @(Get-TiaOrdinalSortedUnique -Values $namespaceCandidates)

    [pscustomobject]@{
        types = $types
        namespaces = $namespaces
        documentedMemberCounts = [pscustomobject]@{
            types = @($memberIds | Where-Object { $_.StartsWith("T:", [System.StringComparison]::Ordinal) }).Count
            methods = @($memberIds | Where-Object { $_.StartsWith("M:", [System.StringComparison]::Ordinal) }).Count
            properties = @($memberIds | Where-Object { $_.StartsWith("P:", [System.StringComparison]::Ordinal) }).Count
            fields = @($memberIds | Where-Object { $_.StartsWith("F:", [System.StringComparison]::Ordinal) }).Count
            events = @($memberIds | Where-Object { $_.StartsWith("E:", [System.StringComparison]::Ordinal) }).Count
        }
        documentedMembersSha256 = Get-TiaSha256FromString -Value ($memberIds -join "`n")
    }
}

function Compare-TiaApiAssemblySurface {
    param(
        [Parameter(Mandatory = $true)] [object] $Baseline,
        [Parameter(Mandatory = $true)] [object] $Candidate
    )

    $baselineTypes = @(Get-TiaOrdinalSortedUnique -Values @($Baseline.types))
    $candidateTypes = @(Get-TiaOrdinalSortedUnique -Values @($Candidate.types))
    $baselineSet = New-Object "System.Collections.Generic.HashSet[string]" ([System.StringComparer]::Ordinal)
    $candidateSet = New-Object "System.Collections.Generic.HashSet[string]" ([System.StringComparer]::Ordinal)
    foreach ($typeName in $baselineTypes) {
        $null = $baselineSet.Add($typeName)
    }
    foreach ($typeName in $candidateTypes) {
        $null = $candidateSet.Add($typeName)
    }

    $added = @($candidateTypes | Where-Object { -not $baselineSet.Contains($_) })
    $removed = @($baselineTypes | Where-Object { -not $candidateSet.Contains($_) })
    $memberSurfaceChanged = ([string] $Baseline.documentedMembersSha256 -cne [string] $Candidate.documentedMembersSha256)

    [pscustomobject]@{
        matches = ($added.Count -eq 0 -and $removed.Count -eq 0 -and -not $memberSurfaceChanged)
        addedTypes = $added
        removedTypes = $removed
        memberSurfaceChanged = $memberSurfaceChanged
    }
}

function Get-TiaApiModuleInstallationState {
    param(
        [Parameter(Mandatory = $true)] [object] $Module,
        [Parameter(Mandatory = $true)] [string] $PublicApiPath
    )

    $missing = New-Object System.Collections.Generic.List[string]
    foreach ($assemblyName in @($Module.assemblies)) {
        $dllPath = Join-Path $PublicApiPath $assemblyName
        $xmlPath = [System.IO.Path]::ChangeExtension($dllPath, ".xml")
        if (-not (Test-Path -LiteralPath $dllPath -PathType Leaf)) {
            $missing.Add($assemblyName)
        }
        if (-not (Test-Path -LiteralPath $xmlPath -PathType Leaf)) {
            $missing.Add([System.IO.Path]::GetFileName($xmlPath))
        }
    }

    $missing = @(Get-TiaOrdinalSortedUnique -Values $missing)
    [pscustomobject]@{
        moduleId = [string] $Module.id
        status = if ($missing.Count -eq 0) { "installed" } else { "not_installed" }
        blocking = ([bool] $Module.required -and $missing.Count -gt 0)
        missingFiles = $missing
    }
}

function Compare-TiaApiDocumentationSurface {
    param(
        [string[]] $BaselineTypes,
        [string[]] $BaselineNamespaces,
        [string[]] $DocumentedHeadings,
        [ValidateSet("complete", "partial")] [string] $Coverage = "partial"
    )

    $types = @(Get-TiaOrdinalSortedUnique -Values $BaselineTypes)
    $namespaces = @(Get-TiaOrdinalSortedUnique -Values $BaselineNamespaces)
    $headings = @(Get-TiaOrdinalSortedUnique -Values $DocumentedHeadings)
    $allowed = New-Object "System.Collections.Generic.HashSet[string]" ([System.StringComparer]::Ordinal)
    $documented = New-Object "System.Collections.Generic.HashSet[string]" ([System.StringComparer]::Ordinal)
    foreach ($item in @($types + $namespaces)) {
        $null = $allowed.Add($item)
    }
    foreach ($item in $headings) {
        $null = $documented.Add($item)
    }

    $invalid = @($headings | Where-Object { -not $allowed.Contains($_) })
    $missing = @()
    if ($Coverage -eq "complete") {
        $missing = @($types | Where-Object { -not $documented.Contains($_) })
    }

    [pscustomobject]@{
        matches = ($invalid.Count -eq 0 -and $missing.Count -eq 0)
        invalidHeadings = $invalid
        missingTypes = $missing
    }
}

function Read-TiaApiJsonFile {
    param([Parameter(Mandatory = $true)] [string] $Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "JSON file was not found: $Path"
    }
    return (Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json)
}

function Write-TiaApiJsonFile {
    param(
        [Parameter(Mandatory = $true)] [object] $Value,
        [Parameter(Mandatory = $true)] [string] $Path
    )

    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) {
        $null = New-Item -ItemType Directory -Path $parent -Force
    }
    $json = $Value | ConvertTo-Json -Depth 20
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $json + "`n", $encoding)
}

function Get-TiaApiDocumentedHeadings {
    param(
        [Parameter(Mandatory = $true)] [string] $RepoRoot,
        [Parameter(Mandatory = $true)] [string[]] $Paths
    )

    $files = New-Object System.Collections.Generic.List[string]
    foreach ($relativePath in $Paths) {
        $resolved = Join-Path $RepoRoot $relativePath
        if (Test-Path -LiteralPath $resolved -PathType Leaf) {
            $files.Add($resolved)
        } elseif (Test-Path -LiteralPath $resolved -PathType Container) {
            Get-ChildItem -LiteralPath $resolved -Recurse -File -Filter "*.md" |
                ForEach-Object { $files.Add($_.FullName) }
        } else {
            throw "Documentation path was not found: $relativePath"
        }
    }

    $headings = New-Object System.Collections.Generic.List[string]
    $pattern = "(?m)^##[^\r\n]*?(Siemens\.Engineering\.[A-Za-z0-9_.+#]+)\s*$"
    foreach ($file in @(Get-TiaOrdinalSortedUnique -Values $files)) {
        $content = Get-Content -Raw -LiteralPath $file
        foreach ($match in [regex]::Matches($content, $pattern)) {
            $headings.Add($match.Groups[1].Value)
        }
    }
    return @(Get-TiaOrdinalSortedUnique -Values $headings)
}

function Get-TiaApiAssemblyEvidence {
    param(
        [Parameter(Mandatory = $true)] [string] $AssemblyName,
        [Parameter(Mandatory = $true)] [string] $PublicApiPath
    )

    $dllPath = Join-Path $PublicApiPath $AssemblyName
    $xmlPath = [System.IO.Path]::ChangeExtension($dllPath, ".xml")
    $surface = Get-TiaApiXmlSurface -XmlPath $xmlPath
    $fileVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($dllPath)
    $assemblyVersion = [System.Reflection.AssemblyName]::GetAssemblyName($dllPath).Version.ToString()

    [pscustomobject]@{
        name = $AssemblyName
        assemblyVersion = $assemblyVersion
        fileVersion = [string] $fileVersion.FileVersion
        productVersion = [string] $fileVersion.ProductVersion
        dllSha256 = (Get-FileHash -LiteralPath $dllPath -Algorithm SHA256).Hash.ToLowerInvariant()
        xmlSha256 = (Get-FileHash -LiteralPath $xmlPath -Algorithm SHA256).Hash.ToLowerInvariant()
        typeCount = @($surface.types).Count
        types = @($surface.types)
        namespaces = @($surface.namespaces)
        documentedMemberCounts = $surface.documentedMemberCounts
        documentedMembersSha256 = $surface.documentedMembersSha256
    }
}

function New-TiaApiModuleBaseline {
    param(
        [Parameter(Mandatory = $true)] [object] $Configuration,
        [Parameter(Mandatory = $true)] [object] $Module,
        [Parameter(Mandatory = $true)] [string] $PublicApiPath
    )

    $assemblies = @(
        foreach ($assemblyName in @($Module.assemblies)) {
            Get-TiaApiAssemblyEvidence -AssemblyName $assemblyName -PublicApiPath $PublicApiPath
        }
    )

    [pscustomobject]@{
        schemaVersion = [int] $Configuration.schemaVersion
        tiaVersion = [string] $Configuration.tiaVersion
        moduleId = [string] $Module.id
        displayName = [string] $Module.displayName
        required = [bool] $Module.required
        documentationCoverage = [string] $Module.documentationCoverage
        cataloguePaths = @($Module.cataloguePaths)
        provenance = [pscustomobject]@{
            sourceKind = "installed-public-api-xml-and-assembly-metadata"
            publicApiRelativePath = "PublicAPI/V21/net48"
            extractorVersion = 1
        }
        assemblies = $assemblies
    }
}

function Test-TiaApiSortedUniqueArray {
    param([object[]] $Values)

    $original = @($Values | ForEach-Object { [string] $_ })
    $expected = @(Get-TiaOrdinalSortedUnique -Values $original)
    if ($original.Count -ne $expected.Count) {
        return $false
    }
    for ($index = 0; $index -lt $original.Count; $index++) {
        if ($original[$index] -cne $expected[$index]) {
            return $false
        }
    }
    return $true
}

function Test-TiaApiBaselineRepository {
    param(
        [Parameter(Mandatory = $true)] [string] $BaselineRoot,
        [Parameter(Mandatory = $true)] [string] $RepoRoot
    )

    $errors = New-Object System.Collections.Generic.List[string]
    $warnings = New-Object System.Collections.Generic.List[string]
    $configurationPath = Join-Path $BaselineRoot "modules.json"
    try {
        $configuration = Read-TiaApiJsonFile -Path $configurationPath
    } catch {
        $errors.Add($_.Exception.Message)
        return [pscustomobject]@{
            status = "fail"
            tiaInstallationRequired = $false
            moduleCount = 0
            errors = @($errors)
            warnings = @($warnings)
        }
    }

    $globalTypes = New-Object System.Collections.Generic.List[string]
    $globalNamespaces = New-Object System.Collections.Generic.List[string]
    $seenTypes = New-Object "System.Collections.Generic.HashSet[string]" ([System.StringComparer]::Ordinal)

    foreach ($moduleConfig in @($configuration.modules)) {
        $modulePath = Join-Path $BaselineRoot (([string] $moduleConfig.id) + ".json")
        if (-not (Test-Path -LiteralPath $modulePath -PathType Leaf)) {
            $errors.Add("Missing baseline for module '$($moduleConfig.id)': $modulePath")
            continue
        }

        try {
            $baseline = Read-TiaApiJsonFile -Path $modulePath
        } catch {
            $errors.Add($_.Exception.Message)
            continue
        }

        if ([int] $baseline.schemaVersion -ne [int] $configuration.schemaVersion) {
            $errors.Add("Module '$($moduleConfig.id)' has the wrong schema version.")
        }
        if ([string] $baseline.tiaVersion -cne [string] $configuration.tiaVersion) {
            $errors.Add("Module '$($moduleConfig.id)' has the wrong TIA version.")
        }
        if ([string] $baseline.moduleId -cne [string] $moduleConfig.id) {
            $errors.Add("Module '$($moduleConfig.id)' has a mismatched moduleId.")
        }

        $expectedAssemblies = @(Get-TiaOrdinalSortedUnique -Values @($moduleConfig.assemblies))
        $actualAssemblies = @(Get-TiaOrdinalSortedUnique -Values @($baseline.assemblies | ForEach-Object { $_.name }))
        if (($expectedAssemblies -join "`n") -cne ($actualAssemblies -join "`n")) {
            $errors.Add("Module '$($moduleConfig.id)' does not contain its configured assembly set.")
        }

        $moduleTypes = New-Object System.Collections.Generic.List[string]
        $moduleNamespaces = New-Object System.Collections.Generic.List[string]
        foreach ($assembly in @($baseline.assemblies)) {
            $types = @($assembly.types)
            if (-not (Test-TiaApiSortedUniqueArray -Values $types)) {
                $errors.Add("Assembly '$($assembly.name)' types are not ordinal-sorted and unique.")
            }
            if ([int] $assembly.typeCount -ne $types.Count) {
                $errors.Add("Assembly '$($assembly.name)' has a mismatched typeCount.")
            }
            foreach ($hashName in "dllSha256", "xmlSha256", "documentedMembersSha256") {
                $hash = [string] $assembly.$hashName
                if ($hash -notmatch "^[0-9a-f]{64}$") {
                    $errors.Add("Assembly '$($assembly.name)' has an invalid $hashName.")
                }
            }
            foreach ($typeName in $types) {
                if (-not $seenTypes.Add([string] $typeName)) {
                    $errors.Add("Type '$typeName' appears in more than one module baseline.")
                }
                $moduleTypes.Add([string] $typeName)
                $globalTypes.Add([string] $typeName)
            }
            foreach ($namespaceName in @($assembly.namespaces)) {
                $moduleNamespaces.Add([string] $namespaceName)
                $globalNamespaces.Add([string] $namespaceName)
            }
        }

        if ([string] $moduleConfig.documentationCoverage -eq "complete") {
            try {
                $headings = @(Get-TiaApiDocumentedHeadings -RepoRoot $RepoRoot -Paths @($moduleConfig.cataloguePaths))
                $comparison = Compare-TiaApiDocumentationSurface `
                    -BaselineTypes @(Get-TiaOrdinalSortedUnique -Values $moduleTypes) `
                    -BaselineNamespaces @(Get-TiaOrdinalSortedUnique -Values $moduleNamespaces) `
                    -DocumentedHeadings $headings `
                    -Coverage "complete"
                foreach ($invalid in @($comparison.invalidHeadings)) {
                    $errors.Add("Module '$($moduleConfig.id)' documents unknown API heading '$invalid'.")
                }
                foreach ($missing in @($comparison.missingTypes)) {
                    $errors.Add("Module '$($moduleConfig.id)' complete catalogue is missing '$missing'.")
                }
            } catch {
                $errors.Add($_.Exception.Message)
            }
        }
    }

    try {
        $allHeadings = @(Get-TiaApiDocumentedHeadings -RepoRoot $RepoRoot -Paths @("skills"))
        $globalComparison = Compare-TiaApiDocumentationSurface `
            -BaselineTypes @(Get-TiaOrdinalSortedUnique -Values $globalTypes) `
            -BaselineNamespaces @(Get-TiaOrdinalSortedUnique -Values $globalNamespaces) `
            -DocumentedHeadings $allHeadings `
            -Coverage "partial"
        foreach ($invalid in @($globalComparison.invalidHeadings)) {
            $errors.Add("Documentation contains an API heading absent from the certified V21 baseline: '$invalid'.")
        }
    } catch {
        $errors.Add($_.Exception.Message)
    }

    [pscustomobject]@{
        status = if ($errors.Count -eq 0) { "pass" } else { "fail" }
        tiaInstallationRequired = $false
        tiaVersion = [string] $configuration.tiaVersion
        moduleCount = @($configuration.modules).Count
        typeCount = @(Get-TiaOrdinalSortedUnique -Values $globalTypes).Count
        errors = @($errors)
        warnings = @($warnings)
    }
}

function Get-TiaV21PublicApiPath {
    foreach ($root in @("C:\Program Files", "C:\Program Files (x86)")) {
        $candidate = Join-Path $root "Siemens/Automation/Portal V21/PublicAPI/V21/net48"
        if (Test-Path -LiteralPath $candidate -PathType Container) {
            return $candidate
        }
    }
    return $null
}

function Invoke-TiaApiBaselineExtraction {
    param(
        [Parameter(Mandatory = $true)] [string] $BaselineRoot,
        [Parameter(Mandatory = $true)] [string] $PublicApiPath,
        [Parameter(Mandatory = $true)] [string] $CandidateRoot,
        [switch] $Force
    )

    if (-not (Test-Path -LiteralPath $PublicApiPath -PathType Container)) {
        throw "TIA Portal V21 Public API path was not found: $PublicApiPath"
    }
    if ((Test-Path -LiteralPath $CandidateRoot) -and -not $Force) {
        $existing = @(Get-ChildItem -LiteralPath $CandidateRoot -File -ErrorAction SilentlyContinue)
        if ($existing.Count -gt 0) {
            throw "Candidate directory is not empty. Use -Force to overwrite known candidate files: $CandidateRoot"
        }
    }

    $configuration = Read-TiaApiJsonFile -Path (Join-Path $BaselineRoot "modules.json")
    $states = New-Object System.Collections.Generic.List[object]
    foreach ($module in @($configuration.modules)) {
        $state = Get-TiaApiModuleInstallationState -Module $module -PublicApiPath $PublicApiPath
        $states.Add($state)
        if ($state.status -eq "installed") {
            $candidate = New-TiaApiModuleBaseline -Configuration $configuration -Module $module -PublicApiPath $PublicApiPath
            Write-TiaApiJsonFile -Value $candidate -Path (Join-Path $CandidateRoot (([string] $module.id) + ".json"))
        }
    }

    $manifest = [pscustomobject]@{
        schemaVersion = [int] $configuration.schemaVersion
        tiaVersion = [string] $configuration.tiaVersion
        publicApiRelativePath = "PublicAPI/V21/net48"
        modules = $states.ToArray()
    }
    Write-TiaApiJsonFile -Value $manifest -Path (Join-Path $CandidateRoot "extraction-manifest.json")

    $blocking = @($states | Where-Object { $_.blocking })
    [pscustomobject]@{
        status = if ($blocking.Count -eq 0) { "pass" } else { "fail" }
        candidateRoot = $CandidateRoot
        modules = $states.ToArray()
    }
}

function Compare-TiaApiBaselineDirectories {
    param(
        [Parameter(Mandatory = $true)] [string] $BaselineRoot,
        [Parameter(Mandatory = $true)] [string] $CandidateRoot
    )

    $configuration = Read-TiaApiJsonFile -Path (Join-Path $BaselineRoot "modules.json")
    $manifest = Read-TiaApiJsonFile -Path (Join-Path $CandidateRoot "extraction-manifest.json")
    $changes = New-Object System.Collections.Generic.List[object]
    $errors = New-Object System.Collections.Generic.List[string]

    foreach ($module in @($configuration.modules)) {
        $state = @($manifest.modules | Where-Object { $_.moduleId -ceq [string] $module.id }) | Select-Object -First 1
        if ($null -eq $state) {
            $errors.Add("Extraction manifest has no state for module '$($module.id)'.")
            continue
        }
        if ($state.status -ne "installed") {
            if ([bool] $module.required) {
                $errors.Add("Required module '$($module.id)' was not installed during extraction.")
            }
            continue
        }

        $baseline = Read-TiaApiJsonFile -Path (Join-Path $BaselineRoot (([string] $module.id) + ".json"))
        $candidate = Read-TiaApiJsonFile -Path (Join-Path $CandidateRoot (([string] $module.id) + ".json"))
        foreach ($candidateAssembly in @($candidate.assemblies)) {
            $baselineAssembly = @($baseline.assemblies | Where-Object { $_.name -ceq $candidateAssembly.name }) | Select-Object -First 1
            if ($null -eq $baselineAssembly) {
                $changes.Add([pscustomobject]@{
                    moduleId = [string] $module.id
                    assembly = [string] $candidateAssembly.name
                    kind = "assembly_added"
                    addedTypes = @($candidateAssembly.types)
                    removedTypes = @()
                })
                continue
            }
            $surface = Compare-TiaApiAssemblySurface -Baseline $baselineAssembly -Candidate $candidateAssembly
            $metadataChanged = (
                [string] $baselineAssembly.assemblyVersion -cne [string] $candidateAssembly.assemblyVersion -or
                [string] $baselineAssembly.fileVersion -cne [string] $candidateAssembly.fileVersion -or
                [string] $baselineAssembly.dllSha256 -cne [string] $candidateAssembly.dllSha256 -or
                [string] $baselineAssembly.xmlSha256 -cne [string] $candidateAssembly.xmlSha256
            )
            if (-not $surface.matches -or $metadataChanged) {
                $changes.Add([pscustomobject]@{
                    moduleId = [string] $module.id
                    assembly = [string] $candidateAssembly.name
                    kind = "assembly_changed"
                    metadataChanged = $metadataChanged
                    memberSurfaceChanged = $surface.memberSurfaceChanged
                    addedTypes = @($surface.addedTypes)
                    removedTypes = @($surface.removedTypes)
                })
            }
        }
    }

    [pscustomobject]@{
        status = if ($errors.Count -eq 0 -and $changes.Count -eq 0) { "pass" } else { "changes" }
        errors = @($errors)
        changes = $changes.ToArray()
    }
}

function Write-TiaApiHumanResult {
    param([Parameter(Mandatory = $true)] [object] $Result)

    if ($Result.status -eq "pass") {
        Write-Host "[PASS] TIA API baseline operation completed."
    } else {
        Write-Host "[FAIL] TIA API baseline operation reported '$($Result.status)'."
    }
    if ($null -ne $Result.PSObject.Properties["errors"]) {
        foreach ($errorMessage in @($Result.errors)) {
            Write-Host "[ERROR] $errorMessage"
        }
    }
    if ($null -ne $Result.PSObject.Properties["changes"]) {
        foreach ($change in @($Result.changes)) {
            Write-Host "[CHANGE] $($change.moduleId)/$($change.assembly): +$(@($change.addedTypes).Count) -$(@($change.removedTypes).Count)"
        }
    }
    if ($null -ne $Result.PSObject.Properties["modules"]) {
        foreach ($module in @($Result.modules)) {
            $prefix = if ($module.status -eq "installed") { "PASS" } elseif ($module.blocking) { "ERROR" } else { "WARN" }
            Write-Host "[$prefix] $($module.moduleId): $($module.status)"
        }
    }
}

function Invoke-TiaApiBaselineCli {
    param(
        [string] $Mode,
        [string] $RepoRoot,
        [string] $BaselineRoot,
        [string] $PublicApiPath,
        [string] $CandidateRoot,
        [switch] $Force,
        [switch] $JsonOutput
    )

    if ($Mode -eq "Validate") {
        $result = Test-TiaApiBaselineRepository -BaselineRoot $BaselineRoot -RepoRoot $RepoRoot
    } elseif ($Mode -eq "Extract") {
        if ([string]::IsNullOrWhiteSpace($PublicApiPath)) {
            $PublicApiPath = Get-TiaV21PublicApiPath
        }
        if ([string]::IsNullOrWhiteSpace($PublicApiPath)) {
            throw "TIA Portal V21 Public API was not found. Pass -PublicApiPath explicitly."
        }
        $result = Invoke-TiaApiBaselineExtraction -BaselineRoot $BaselineRoot -PublicApiPath $PublicApiPath -CandidateRoot $CandidateRoot -Force:$Force
    } else {
        $result = Compare-TiaApiBaselineDirectories -BaselineRoot $BaselineRoot -CandidateRoot $CandidateRoot
    }

    if ($JsonOutput) {
        $result | ConvertTo-Json -Depth 20
    } else {
        Write-TiaApiHumanResult -Result $result
    }

    if ($result.status -eq "pass") {
        return 0
    }
    return 1
}

if ($MyInvocation.InvocationName -ne ".") {
    try {
        $cliOutput = @(Invoke-TiaApiBaselineCli `
            -Mode $Mode `
            -RepoRoot $RepoRoot `
            -BaselineRoot $BaselineRoot `
            -PublicApiPath $PublicApiPath `
            -CandidateRoot $CandidateRoot `
            -Force:$Force `
            -JsonOutput:$JsonOutput)
        $exitCode = [int] $cliOutput[$cliOutput.Count - 1]
        if ($cliOutput.Count -gt 1) {
            $cliOutput[0..($cliOutput.Count - 2)] | Write-Output
        }
        exit $exitCode
    } catch {
        if ($JsonOutput) {
            [pscustomobject]@{
                status = "error"
                error = $_.Exception.Message
            } | ConvertTo-Json -Depth 4
        } else {
            Write-Error "TIA API baseline operation failed: $($_.Exception.Message)"
        }
        exit 2
    }
}
