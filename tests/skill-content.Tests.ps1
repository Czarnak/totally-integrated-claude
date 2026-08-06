$ErrorActionPreference = "Stop"

Describe "portable safety invariants" {
    BeforeAll {
        $script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        $script:CSharpSkill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-csharp-common/SKILL.md")
        $script:CSharpAssemblyMap = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-csharp-common/references/assembly-namespace-map.md")
        $script:AddInPackage = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/addin-operations/references/package-and-publisher.md")
        $script:AddInRuntime = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/addin-operations/references/runtime-gotchas.md")
        $script:AddInThreading = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/addin-operations/references/threading-and-callbacks.md")
        $script:AddInMigration = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/addin-operations/references/migrate-from-older-version.md")
        $script:AddInSkeleton = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/addin-operations/references/skeleton.md")
        $script:VciOperations = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-project-general/references/vci-operations.md")
        $script:ProjectLifecycle = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-project-general/references/project-lifecycle.md")
        $script:ProjectLanguages = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-project-general/references/language-settings.md")
        $script:PortalSettings = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-project-general/references/portal-settings.md")
        $script:PlcSkill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/SKILL.md")
        $script:PlcBlocks = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/references/blocks.md")
        $script:PlcCompare = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/references/compare.md")
        $script:PlcOnline = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/references/online-status.md")
        $script:ImportSkill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-import-export/SKILL.md")
        $script:ImportOverview = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-import-export/references/overview.md")
        $script:ImportHardware = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-import-export/references/hardware-aml.md")
        $script:ImportPlcBlocks = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-import-export/references/plc-blocks.md")
        $script:ImportPlcData = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-import-export/references/plc-alarms-and-tags.md")
        $script:DevicesSkill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-devices-general/SKILL.md")
        $script:DeviceCreation = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-devices-general/references/device-creation.md")
        $script:DeviceAttributes = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-devices-general/references/device-attributes.md")
        $script:DeviceEnumeration = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-devices-general/references/device-enumeration.md")
        $script:DeviceInterfaces = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-devices-general/references/device-item-interfaces.md")
        $script:DeviceOperations = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-devices-general/references/device-item-operations.md")
        $script:SoftwareContainer = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-devices-general/references/software-container.md")
        $script:NetworksSkill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-networks/SKILL.md")
        $script:NetworkSubnets = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-networks/references/subnets-and-nodes.md")
        $script:NetworkConnections = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-networks/references/communication-connections.md")
        $script:NetworkTiming = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-networks/references/io-timing.md")
        $script:NetworkOnline = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-networks/references/online-connection-configuration.md")
        $script:NetworkAddresses = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-networks/references/addresses-and-channels.md")
        $script:HmiSkill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-hmi-operations/SKILL.md")
        $script:HmiTarget = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-hmi-operations/references/hmi-target.md")
        $script:HmiClassicHierarchy = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-hmi-operations/references/hmi-composition-hierarchy.md")
        $script:HmiUnifiedOverview = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-hmi-operations/references/unified-overview.md")
        $script:HmiUnifiedScreens = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-hmi-operations/references/unified-screens.md")
        $script:HmiUnifiedLogging = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-hmi-operations/references/unified-logging.md")
        $script:HmiUnifiedAlarms = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-hmi-operations/references/unified-tags-alarms.md")
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

    It "documents V21 transaction rollback after any in-transaction exception" {
        $script:CSharpSkill | Should -Match 'exception occurs at any point before the transaction is disposed'
        $script:CSharpSkill | Should -Not -Match 'exception occurs \*\*after\*\* `CommitOnDispose\(\)`.*changes are committed'
    }

    It "does not treat Project as IDisposable" {
        $script:CSharpSkill | Should -Not -Match 'using` blocks for `ExclusiveAccess`, `Transaction`, `TiaPortal`, projects'
        $script:CSharpSkill | Should -Match 'Close projects explicitly'
    }

    It "covers the complete V21 modular assembly inventory" {
        $script:CSharpAssemblyMap | Should -Match '16 assemblies total'
        $script:CSharpAssemblyMap | Should -Match 'Siemens\.Engineering\.Sivarc\.dll'
    }

    It "documents the V21 Add-In target without invented publisher constraints" {
        $script:AddInPackage | Should -Match '<PackageConfiguration'
        $script:AddInPackage | Should -Match '<FeatureAssembly>'
        $script:AddInPackage | Should -Match '<RequiredPermissions>'
        $script:AddInPackage | Should -Not -Match '<AddInPublisherConfig'
        $script:AddInPackage | Should -Match 'Siemens V21 template default'
        $script:AddInPackage | Should -Not -Match 'publisher rejects `x86` and `x64`'
        $script:AddInPackage | Should -Not -Match 'major must match the engineering version'
    }

    It "documents managed Add-In dependency packaging" {
        $script:AddInRuntime | Should -Match 'AdditionalAssemblies'
        $script:AddInRuntime | Should -Match 'Native assemblies are not supported'
        $script:AddInRuntime | Should -Not -Match 'Never add a NuGet package reference'
    }

    It "keeps Add-In work within the execution lifetime" {
        $script:AddInThreading | Should -Match 'separate process'
        $script:AddInThreading | Should -Match 'MessageBoxProvider'
        $script:AddInThreading | Should -Not -Match 'new STA thread \(safe to block here\)'
        $script:AddInThreading | Should -Not -Match 'watchdog is satisfied'
        $script:AddInMigration | Should -Not -Match 'two-phase collect/show pattern'
        $script:AddInSkeleton | Should -Not -Match 'new Thread\('
        $script:AddInSkeleton | Should -Match 'MessageBoxProvider'
    }

    It "uses the installed V21 VCI enum and method contracts" {
        $script:VciOperations | Should -Match '`Equal`, `Unequal`'
        $script:VciOperations | Should -Match '`ProjectToWorkspace`'
        $script:VciOperations | Should -Match '`WorkspaceToProject`'
        $script:VciOperations | Should -Match '`void Synchronize\(SynchronizationMode\)`'
        $script:VciOperations | Should -Not -Match 'ImportWorkspaceToProject'
        $script:VciOperations | Should -Not -Match 'CompareState\.Different'
    }

    It "documents V21 project upgrade and SaveAs semantics" {
        $script:ProjectLifecycle | Should -Match 'immediately previous version'
        $script:ProjectLifecycle | Should -Not -Match 'OldProject\.ap18'
        $script:ProjectLifecycle | Should -Match 'changes the active project persistence location'
        $script:ProjectLifecycle | Should -Match 'outside the transaction'
    }

    It "uses the installed V21 language-import enum and settings namespace" {
        $script:ProjectLanguages | Should -Match 'ActivateInActiveCultures'
        $script:ProjectLanguages | Should -Match 'DoNotActivateInActiveCultures'
        $script:ProjectLanguages | Should -Not -Match '\bActivateAll\b'
        $script:PortalSettings | Should -Match 'using Siemens\.Engineering\.Settings;'
    }

    It "requires explicit authorization for live PLC operations" {
        $script:PlcSkill | Should -Match 'Live-operation safety'
        $script:PlcSkill | Should -Match 'explicitly authorized'
        $script:PlcSkill | Should -Match 'download, force, online write, or snapshot load'
    }

    It "uses safe and compilable V21 online-connection guidance" {
        $script:PlcOnline | Should -Match 'using Siemens\.Engineering\.Connection;'
        $script:PlcOnline | Should -Match 'using Siemens\.Engineering\.Online;'
        $script:PlcOnline | Should -Match 'connectedHere'
        $script:PlcOnline | Should -Not -Match '1–16 seconds'
    }

    It "uses installed V21 PLC enum identifiers" {
        $script:PlcBlocks | Should -Match '`Supervisions`'
        $script:PlcBlocks | Should -Not -Match '\| `Supervision` \|'
        $script:PlcBlocks | Should -Not -Match 'GenerateBlockOptions'
        $script:PlcCompare | Should -Match '`FolderContentsDifferent`'
        $script:PlcCompare | Should -Match '`ObjectsDifferent`'
        $script:PlcCompare | Should -Match 'CompareResultState\.FolderContentsIdentical'
        $script:PlcCompare | Should -Match 'CompareResultState\.ObjectsIdentical'
    }

    It "covers guarded V21 PLC download and station upload" {
        $path = Join-Path $script:RepoRoot "skills/tia-plc-operations/references/download-upload.md"
        (Test-Path -LiteralPath $path) | Should -Be $true
        $content = Get-Content -Raw -LiteralPath $path
        $content | Should -Match 'DownloadProvider'
        $content | Should -Match 'StationUploadProvider'
        $content | Should -Match 'explicitly authorized'
        $content | Should -Match 'fail closed'
        $content | Should -Match 'unhandled configuration'
    }

    It "uses the installed V21 import/export identifiers" {
        $script:ImportPlcData | Should -Match 'ImportSupervisionsFromXlsx'
        $script:ImportPlcData | Should -Match 'ImportSupervisionSettingsFromXlsx'
        $script:ImportPlcData | Should -Not -Match 'FromX1sx'
        $script:ImportPlcData | Should -Not -Match 'ExportOptions\.WithDefaultsAndReadOnly'
        $script:ImportPlcData | Should -Match 'there is no installed V21 enum member named `WithDefaultsAndReadOnly`'
        $script:ImportPlcBlocks | Should -Match 'IgnoreUnitAttributes'
        $script:ImportPlcBlocks | Should -Match 'SkipInactiveCultures'
        $script:ImportPlcBlocks | Should -Match 'ActivateInactiveCultures'
    }

    It "describes V21 formats and CAx results without overclaiming" {
        $script:ImportOverview | Should -Match 'AutomationML is XML-based'
        $script:ImportOverview | Should -Not -Match 'File format is XML for all objects except CAx data'
        $script:ImportHardware | Should -Not -Match 'uses \*\*AutomationML \(AML\)\*\* format — not XML'
        $script:ImportHardware | Should -Not -Match 'All errors are reported as exceptions'
        $script:ImportHardware | Should -Match 'TransferResultState\.Error'
    }

    It "guards mutating import workflows" {
        $script:ImportSkill | Should -Match 'explicit authorization'
        $script:ImportSkill | Should -Match 'untrusted input'
        $script:ImportSkill | Should -Match 'Do not save'
    }

    It "guards device and module mutations" {
        $script:DevicesSkill | Should -Match 'explicit authorization'
        $script:DevicesSkill | Should -Match 'exact `TypeIdentifier`'
        $script:DevicesSkill | Should -Match 'Do not save'
        $script:DeviceCreation | Should -Not -Match 'CatalogEntry first = entries\.First\(\)'
        $script:DeviceCreation | Should -Match 'exactMatches\.Count != 1'
        $script:DeviceOperations | Should -Not -Match 'device\.DeviceItems\.First\(\)'
    }

    It "covers classic and Unified HMI software recursively" {
        $script:SoftwareContainer | Should -Match 'Siemens\.Engineering\.HmiUnified'
        $script:SoftwareContainer | Should -Match 'HmiSoftware'
        $script:SoftwareContainer | Should -Match 'EnumerateDeviceItems'
        $script:SoftwareContainer | Should -Match 'CompilerResultState\.Error'
        $script:DeviceEnumeration | Should -Match 'IEnumerable<DeviceItem>'
    }

    It "uses installed V21 device-operation contracts" {
        $script:DeviceOperations | Should -Not -Match 'using Siemens\.Engineering\.HW\.DeviceItem;'
        $script:DeviceOperations | Should -Match 'DeviceItemClassifications\.CompactModule'
        $script:DeviceOperations | Should -Match 'DeviceItemClassifications\.IoLinkModule'
        $script:DeviceOperations | Should -Match 'project\.HwUtilities'
        $script:DeviceOperations | Should -Match 'pscProvider\.Export\(device, exportFile\)'
        $script:DeviceOperations | Should -Match 'SecureString'
        $script:DeviceOperations | Should -Match 'ImportDataPoints'
        $script:DeviceOperations | Should -Not -Match 'ImportDatapoints'
        $script:DeviceOperations | Should -Match 'AttributeConfiguration'
        $script:DeviceOperations | Should -Match 'AttributeChoiceSelection\.Abort'
        $script:DeviceAttributes | Should -Match 'Siemens\.Engineering\.CustomIdentity'
        $script:DeviceAttributes | Should -Match 'GetService<GsdDeviceItem>'
        $script:DeviceAttributes | Should -Not -Match 'Siemens\.Engineering\.HW\.Extensions'
        $script:DeviceInterfaces | Should -Not -Match 'Siemens\.Engineering\.HW\.Node;'
    }

    It "fails closed on incomplete network dependency evidence" {
        $script:NetworksSkill | Should -Match 'dependency_evidence_incomplete'
        $script:NetworksSkill | Should -Match 'explicit authorization'
        $script:NetworksSkill | Should -Match 'exact selectors'
        $script:NetworksSkill | Should -Match 'Do not save'
        $script:NetworkConnections | Should -Match 'dependency_evidence_incomplete'
        $script:NetworkSubnets | Should -Not -Match 'Subnets\[0\]'
    }

    It "uses installed V21 network enum identifiers" {
        $script:NetworkSubnets | Should -Match '`Baud93750`'
        $script:NetworkSubnets | Should -Not -Match '`Baud93700`'
        $script:NetworkSubnets | Should -Match '`Dp`'
        $script:NetworkSubnets | Should -Not -Match '`DP`,'
        $script:NetworkTiming | Should -Match 'SyncRole\.NotSynchronized'
        $script:NetworkTiming | Should -Match 'SyncRole\.RedundantSyncMaster'
    }

    It "models IoConnector and bulk timing writes correctly" {
        $script:NetworkTiming | Should -Match 'networkInterface\.IoConnectors'
        $script:NetworkTiming | Should -Match '`PnDeviceNumber`'
        $script:NetworkTiming | Should -Match 'AttributeChoiceSelection\.Abort'
        $script:NetworkTiming | Should -Not -Match 'config\.CurrentSelection = AttributeChoiceSelection\.Ignore'
    }

    It "guards online path and security configuration" {
        $script:NetworkOnline | Should -Match 'explicit live-operation authorization'
        $script:NetworkOnline | Should -Match 'connectedHere'
        $script:NetworkOnline | Should -Match 'Disable Tls'
        $script:NetworkOnline | Should -Match 'do not weaken'
        $script:NetworkAddresses | Should -Match 'assigned PLC tags'
    }

    It "keeps classic and Unified HMI object models separate and guarded" {
        $script:HmiSkill | Should -Match 'exact selectors'
        $script:HmiSkill | Should -Match 'explicit authorization'
        $script:HmiSkill | Should -Match 'Do not save'
        $script:HmiTarget | Should -Match 'Unified devices expose `HmiSoftware`'
        $script:HmiTarget | Should -Not -Match 'Unified devices use the same `HmiTarget` root'
        $script:HmiTarget | Should -Match 'EnumerateDeviceItems'
        $script:HmiTarget | Should -Match 'CompilerResultState\.Error'
    }

    It "uses installed V21 HMI import and creation signatures" {
        $script:HmiTarget | Should -Match 'ImportOptions\.Override'
        $script:HmiTarget | Should -Not -Match 'ImportOptions\.Overwrite'
        $script:HmiUnifiedOverview | Should -Match 'Export\(exportDirectory, "exportFileName"\)'
        $script:HmiUnifiedOverview | Should -Match 'Import\(importDirectory, "importFileName"\)'
        $script:HmiUnifiedOverview | Should -Match 'ResultState\.Error'
        $script:HmiUnifiedOverview | Should -Not -Match 'unified-screens-elements\.md'
        $script:HmiUnifiedOverview | Should -Not -Match 'unified-logging-connections\.md'
        $script:HmiUnifiedScreens | Should -Match 'Create<HmiButton>'
        $script:HmiUnifiedScreens | Should -Not -Match 'CreateCustomContainer'
    }

    It "uses installed V21 Unified enum identifiers" {
        $script:HmiUnifiedLogging | Should -Match 'HmiTriggerMode\.None'
        $script:HmiUnifiedLogging | Should -Match 'HmiSmoothingMode\.NoSmoothing'
        $script:HmiUnifiedLogging | Should -Match 'HmiLimitScope\.WithinLimits'
        $script:HmiUnifiedAlarms | Should -Match 'HmiAlarmCondition\.UpperLimit'
        $script:HmiClassicHierarchy | Should -Not -Match 'Siemens\.Engineering\.\# V21 API Reference'
    }

    It "ships and routes a V21 SiVArc domain skill" {
        $skillPath = Join-Path $script:RepoRoot "skills/tia-sivarc/SKILL.md"
        (Test-Path -LiteralPath $skillPath) | Should -Be $true
        $roadmap = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-openness-roadmap/SKILL.md")
        $readme = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "README.md")
        $roadmap | Should -Match 'tia-sivarc'
        $readme | Should -Match '`tia-sivarc`'
    }

    It "uses installed V21 SiVArc service and generation contracts" {
        $skill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-sivarc/SKILL.md")
        $generation = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-sivarc/references/generation.md")
        $skill | Should -Match 'Siemens\.Engineering\.SiVArc'
        $skill | Should -Match 'project\.GetService<Sivarc>\(\)'
        $skill | Should -Match 'explicit authorization'
        $skill | Should -Match 'LicenseNotFound'
        $generation | Should -Match 'GenerationOptions\.AdvancedTags'
        $generation | Should -Match '!result\.IsGenerationSuccessful'
        $generation | Should -Match 'result\.ErrorCount > 0'
        $generation | Should -Match 'RecursivelyWriteMessages'
        $generation | Should -Not -Match '\bGenerateOptions\.'
    }

    It "covers all V21 SiVArc rule and auxiliary service families" {
        $rules = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-sivarc/references/rules-and-libraries.md")
        $services = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-sivarc/references/definitions-expression-layout.md")
        foreach ($family in 'Screen', 'Alarm', 'Copy', 'Tag', 'AdvancedTag', 'Textlist') {
            $rules | Should -Match ($family + 'Rules')
        }
        $rules | Should -Match 'CreateOptions\.Replace'
        $rules | Should -Match 'CreateOptions\.Rename'
        $services | Should -Match 'SivarcDataProvider'
        $services | Should -Match 'textDefinition\.Text\.Items\.Find'
        $services | Should -Not -Match 'textDefinition\.Text ='
        $services | Should -Match 'SivarcDefinitionsUpgrader'
        $services | Should -Match 'UpgradeDefinitionsResult'
        $services | Should -Match 'GetExpressionResolver'
        $services | Should -Match 'LayoutDataImportResult'
        $services | Should -Match 'LayoutImportResultState\.Warning'
        $services | Should -Not -Match 'LayoutImportResultState\.Error'
    }

    It "catalogues all 92 installed V21 SiVArc types" {
        $catalogue = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-sivarc/references/api-catalogue.md")
        ([regex]::Matches($catalogue, '(?m)^## 🛠️ Siemens\.Engineering\.SiVArc\.').Count) | Should -Be 92
        $catalogue | Should -Match '(?m)^## 🛠️ Siemens\.Engineering\.SiVArc\.Sivarc$'
        $catalogue | Should -Match '(?m)^## 🛠️ Siemens\.Engineering\.SiVArc\.AdvancedTagRules$'
        $catalogue | Should -Match '(?m)^## 🛠️ Siemens\.Engineering\.SiVArc\.UpgradeDefinitionsResult$'
    }

    It "guards Startdrive mutation and live operations" {
        $skill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-simatic-drives/SKILL.md")
        $overview = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-simatic-drives/references/drives-overview.md")
        $download = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-simatic-drives/references/download.md")
        $skill | Should -Match 'explicit live-operation authorization'
        $skill | Should -Match 'exact selectors'
        $skill | Should -Match 'Do not save'
        $overview | Should -Match 'EnumerateDeviceItems'
        $overview | Should -Match 'OnlineDriveObject\.Parameters'
        $overview | Should -Match 'live write'
        $overview | Should -Match 'Security security = driveObj\.Security;'
        $overview | Should -Not -Match 'driveObj\.Security\.First\('
        $download | Should -Match 'fail closed'
        $download | Should -Match 'unhandled configuration'
    }

    It "uses installed V21 Startdrive telegram contracts and complete type inventory" {
        $motion = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-simatic-drives/references/motion-control.md")
        $catalogue = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-simatic-drives/references/api-catalogue.md")
        $motion | Should -Match 'CanChangeTelegram\(int number\)'
        $motion | Should -Not -Match '(?<!Can)ChangeTelegram\(int number\)'
        ([regex]::Matches($catalogue, '(?m)^## 🛠️ Siemens\.Engineering\.').Count) | Should -Be 64
    }

    It "uses the installed V21 Multiuser roots and operations" {
        $skill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-multiuser/SKILL.md")
        $workflow = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-multiuser/references/workflows-and-safety.md")
        $skill | Should -Match 'tiaPortal\.ProjectServers'
        $skill | Should -Match 'tiaPortal\.LocalSessions'
        $skill | Should -Not -Match '\bMultiuserService\b'
        $skill | Should -Not -Match '\bMultiuserCommissioningService\b'
        $skill | Should -Not -Match '\bAccessOptions\b'
        $skill | Should -Not -Match '\bCheckIn\(\)'
        $skill | Should -Not -Match '\bUpdate\(\)'
        $workflow | Should -Match 'SessionCreationMode\.Multiuser'
        $workflow | Should -Match 'SessionCreationMode\.Exclusive'
        $workflow | Should -Match 'IsUptoDate\(\)'
        $workflow | Should -Match 'CloseAndCommit'
        $workflow | Should -Match 'explicit remote-write authorization'
        $workflow | Should -Match 'monitoring or forcing jobs'
    }

    It "uses the installed V21 Teamcenter Gateway providers" {
        $skill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-teamcenter/SKILL.md")
        $workflow = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-teamcenter/references/workflows-and-safety.md")
        $skill | Should -Match 'tiaPortal\.GetService<TeamcenterConnectionProvider>\(\)'
        $skill | Should -Match 'tiaPortal\.GetService<TcGatewayLockProvider>\(\)'
        $skill | Should -Match 'tiaPortal\.GetService<TcGatewaySearchAndDownloadProvider>\(\)'
        $skill | Should -Match 'project\.GetService<TcGatewayWorkflowProvider>\(\)'
        $skill | Should -Not -Match '\bTeamcenterService\b'
        $skill | Should -Not -Match '\bTeamcenterStorage\b'
        $workflow | Should -Match 'SecureString'
        $workflow | Should -Match 'SessionToken'
        $workflow | Should -Match 'never log'
        $workflow | Should -Match 'LocalCacheOption\.Overwrite'
        $workflow | Should -Match 'explicit remote-write authorization'
        $workflow | Should -Match 'CancelCheckoutDataset'
        $workflow | Should -Match 'does not discard local changes'
    }

    It "catalogues the complete installed V21 Teamcenter Gateway type surface" {
        $catalogue = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-teamcenter/references/v21-api-surface.md")
        ([regex]::Matches($catalogue, '(?m)^## 🛠️ Siemens\.Engineering\.TeamcenterGateway\.').Count) | Should -Be 20
        $catalogue | Should -Match '(?m)^## 🛠️ Siemens\.Engineering\.TeamcenterGateway\.TeamcenterConnectionProvider$'
        $catalogue | Should -Match '(?m)^## 🛠️ Siemens\.Engineering\.TeamcenterGateway\.TcGatewayLockProvider$'
        $catalogue | Should -Match '(?m)^## 🛠️ Siemens\.Engineering\.TeamcenterGateway\.TcGatewayWorkflowProvider$'
    }

    It "uses the installed V21 Test Suite roots and permission model" {
        $skill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-testsuite/SKILL.md")
        $skill | Should -Match 'project\.GetService<TestSuiteService>\(\)'
        $skill | Should -Match 'service\.ApplicationTestGroup'
        $skill | Should -Match 'service\.StyleGuideGroup'
        $skill | Should -Match 'service\.SystemTestGroup'
        $skill | Should -Not -Match '\bStyleGuideSystemGroups\b'
        $skill | Should -Not -Match '\bSystemTestSystemGroups\b'
        $skill | Should -Match 'Edit Test Suite data'
        $skill | Should -Match 'explicit live-operation authorization'
    }

    It "covers exact V21 Test Suite execution, import, and result gates" {
        $application = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-testsuite/references/application-test.md")
        $style = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-testsuite/references/style-guide.md")
        $system = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-testsuite/references/system-test.md")
        $results = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-testsuite/references/test-results.md")
        $application | Should -Match 'ExecutionMode\.SystemManagedPLCSIMInstance'
        $application | Should -Match 'ExecutionMode\.ExternallyManagedPLCSIMInstance'
        $application | Should -Match 'TSLoadOptions\.IgnoreInvalidObject'
        $application | Should -Match 'TCLoadOptions\.IgnoreInvalidObject'
        $style | Should -Match 'RSLoadOptions\.IgnorePropertyErrors'
        $style | Should -Match 'UpdateOptions\.Override'
        $system | Should -Match 'ServerInterfaces\.UserDefined'
        $system | Should -Match 'ServerInterfaces\.StandardSIMATIC'
        $system | Should -Match 'ServerInterfaces\.SiOMECompanionSpecification'
        $system | Should -Match 'exact OPC UA endpoint'
        $results | Should -Match 'TestResultsState\.Information'
        $results | Should -Match 'recurs'
        $results | Should -Match 'ErrorCount > 0'
    }

    It "catalogues all 28 installed V21 Test Suite types" {
        $catalogue = (Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-testsuite/references/application-test.md")) +
            (Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-testsuite/references/style-guide.md")) +
            (Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-testsuite/references/system-test.md")) +
            (Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-testsuite/references/test-results.md"))
        ([regex]::Matches($catalogue, '(?m)^## 🛠️ Siemens\.Engineering\.TestSuite\.').Count) | Should -Be 28
        $catalogue | Should -Match '(?m)^## 🛠️ Siemens\.Engineering\.TestSuite\.StyleGuide\.RuleSetComposition$'
        $catalogue | Should -Match '(?m)^## 🛠️ Siemens\.Engineering\.TestSuite\.StyleGuide\.RuleSetExecutor$'
        $catalogue | Should -Match '(?m)^## 🛠️ Siemens\.Engineering\.TestSuite\.StyleGuide\.StyleGuideSystemGroup$'
        $catalogue | Should -Match '(?m)^## 🛠️ Siemens\.Engineering\.TestSuite\.StyleGuide\.UpdateOptions$'
    }

    It "documents the scoped V21 tia-doctor probe" {
        $skill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-doctor/SKILL.md")
        $probe = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-doctor/probe.ps1")
        $skill | Should -Match '-RequiredMajorVersion 21'
        $skill | Should -Match '-SkipPython'
        $skill | Should -Match '-SkipMcp'
        $skill | Should -Match 'Siemens\.Engineering\.Base\.dll'
        $probe | Should -Match '\[int\] \$RequiredMajorVersion = 21'
        $probe | Should -Match '\[switch\] \$SkipPython'
        $probe | Should -Match '\[switch\] \$SkipMcp'
        $probe | Should -Match 'Siemens\.Engineering\.Base\.dll'
    }

    It "recognizes V21 SIMATIC SD and schema-backed PLC analysis inputs" {
        $skill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/plc-code-analysis/SKILL.md")
        $skill | Should -Match 'SIMATIC SD'
        $skill | Should -Match '\.s7dcl'
        $skill | Should -Match '\.s7res'
        $skill | Should -Match 'SW\.PlcBlocks\.SCL_v4\.xsd'
        $skill | Should -Match 'does not prove.*compile'
        $skill | Should -Match 'source-backed'
    }

    It "uses V21-accurate Safety data-exchange and timing rules" {
        $critic = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/plc-code-analysis/references/compiler-critic.md")
        $critic | Should -Match 'transfer data blocks'
        $critic | Should -Match 'standard tags are unsafe'
        $critic | Should -Match 'plausibility'
        $critic | Should -Match 'ARRAY\[\*\].*InOut'
        $critic | Should -Match 'low limit.*0'
        $critic | Should -Match 'high limit.*10000'
        $critic | Should -Match 'manual.*positive edge'
        $critic | Should -Not -Match 'may only READ data from the standard program'
        $critic | Should -Not -Match 'must be significantly shorter than\s+the standard cycle time'
        $critic | Should -Not -Match 'two-step "Arm and Fire"'
    }

    It "does not infer local V21 security configuration from instruction presence" {
        $hardware = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/plc-code-analysis/references/hardware-reviewer.md")
        $security = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/plc-code-analysis/references/security-practices.md")
        $hardware | Should -Match 'partner CPU'
        $hardware | Should -Match 'cannot establish.*local CPU'
        $hardware | Should -Match 'firmware V3\.1'
        $hardware | Should -Match 'users.*roles.*function rights'
        $hardware | Should -Not -Match 'PUT/GET instructions in code \| PUT/GET access enabled on CPU'
        $hardware | Should -Not -Match 'MB_SERVER block instances \| Modbus TCP enabled, firewall port open'
        $security | Should -Match 'TSEND_C.*TRCV_C.*not.*cryptographic'
        $security | Should -Not -Match 'TSEND_C / TRCV_C with connection monitoring \(good\)'
    }

    It "calibrates PLC threat mappings as hypotheses rather than compromise evidence" {
        $threats = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/plc-code-analysis/references/threat-mapping.md")
        $threats | Should -Match 'hypothesis'
        $threats | Should -Match 'not evidence of compromise'
        $threats | Should -Match 'permitted data-exchange direction'
        $threats | Should -Not -Match 'Any path in standard \(non-safety\) code that can affect F-program behavior'
        $threats | Should -Not -Match 'prevents OB35 \(safety cyclic interrupt\)'
    }

    It "keeps explicit implementation choices and standalone analysis out of automatic routing" {
        $roadmap = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-openness-roadmap/SKILL.md")
        $roadmap | Should -Match 'explicit.*implementation.*scope'
        $roadmap | Should -Match 'plc-code-analysis'
        $roadmap | Should -Match 'standalone'
        $roadmap | Should -Match 'do not load.*roadmap'
        $roadmap | Should -Not -Match 'Use \*\*C# TIA Portal Openness\*\* only if Python is insufficient'
    }

    It "owns V21 project and global library workflows in the C# package" {
        $skill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-project-general/SKILL.md")
        $library = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-project-general/references/library-operations.md")
        $skill | Should -Match 'references/library-operations\.md'
        $library | Should -Match 'tiaPortal\.GlobalLibraries'
        $library | Should -Match 'project\.ProjectLibrary'
        $library | Should -Match 'MasterCopyComposition\.Create\(IMasterCopySource\)'
        $library | Should -Match 'LibraryTypeVersion\.Release\(CreateOrReleaseDependenciesMode'
        $library | Should -Match 'UpdateCheck\(project, UpdateCheckMode\.ReportOutOfDateOnly\)'
        $library | Should -Match 'explicit authorization'
        $library | Should -Match 'TransferResultState\.Warning'
        ([regex]::Matches($library, '(?m)^## 🛠️ Siemens\.Engineering\.Library(?:\.|$)').Count) | Should -Be 66
    }

    It "keeps the repository overview aligned with the V21 audit" {
        $readme = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "README.md")
        $readme | Should -Match 'SIMATIC SD'
        $readme | Should -Match 'Siemens\.Engineering\.Base\.dll'
        $readme | Should -Match '-SkipPython -SkipMcp'
        $readme | Should -Match 'Classic and Unified'
        $readme | Should -Match 'provider-based Teamcenter Gateway'
        $readme | Should -Not -Match 'bundled Siemens PLC language\s+server'
    }

    It "catalogues the V21 CAx result model and all download configuration markers" {
        $cax = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-import-export/references/hardware-aml.md")
        $download = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/references/download-upload.md")
        foreach ($type in 'CaxImportOptions', 'CaxProvider', 'TransferResult', 'TransferResultMessage', 'TransferResultMessageComposition', 'TransferResultState') {
            $cax | Should -Match ("(?m)^## 🛠️ Siemens\.Engineering\.Cax\." + $type + '$')
        }
        $cax | Should -Match 'TransferResultState\.Information'
        $cax | Should -Match 'recurs'
        ([regex]::Matches($download, '(?m)^## 🛠️ Siemens\.Engineering\.Download\.Configurations\.').Count) | Should -Be 19
        $download | Should -Match 'DataBlockReinitializationOrKeepActualValuesSelections\.KeepActualValues'
        $download | Should -Match 'TargetForSoftwareSelections\.PlcSimulationAdvanced'
        $download | Should -Match 'AllBlocksDownloadSelections\.DownloadAllBlocks'
    }

    It "routes every installed specialized namespace to its corrected domain skill" {
        $map = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-csharp-common/references/assembly-namespace-map.md")
        $map | Should -Match 'Siemens\.Engineering\.FingerprintData` \| Base \| tia-plc-operations'
        $map | Should -Match 'Siemens\.Engineering\.Multiuser` \| Base \| tia-multiuser'
        $map | Should -Match 'Siemens\.Engineering\.SiVArc` \| Sivarc \| tia-sivarc'
        $map | Should -Match 'Siemens\.Engineering\.TeamcenterGateway` \| TeamcenterGateway \| tia-teamcenter'
        $map | Should -Match 'Siemens\.Engineering\.TestSuite\.\*` \| TestSuite \| tia-testsuite'
        $map | Should -Not -Match '\bUploadProvider\b'
        $map | Should -Not -Match '\bGoOnlineConfiguration\b'
        $map | Should -Not -Match '\bGoOfflineConfiguration\b'
        $map | Should -Not -Match '\bMultiuserSession\b'
    }

    It "catalogues all installed Base and Step7 download/upload configurations" {
        $download = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/references/download-upload.md")
        ([regex]::Matches($download, '(?m)^## 🛠️ Siemens\.Engineering\.Download\.Configurations\.').Count) | Should -Be 69
        ([regex]::Matches($download, '(?m)^## 🛠️ Siemens\.Engineering\.Upload\.Configurations\.').Count) | Should -Be 8
        $download | Should -Match 'PlcMasterSecretPassword'
        $download | Should -Match 'UserManagementPreDownloadSelections'
        $download | Should -Match 'UploadPasswordConfiguration'
        $download | Should -Match 'UploadMissingProductsSelections\.NoAction'
        $download | Should -Match 'device\.GetService<RHDownloadProvider>\(\)'
        $download | Should -Match 'DownloadToPrimary'
        $download | Should -Match 'DownloadToBackup'
        $download | Should -Match 'Download\(new DirectoryInfo'
    }

    It "handles secure online configuration without implicit certificate trust" {
        $online = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/references/online-status.md")
        $online | Should -Match 'OnlineLegitimation \+='
        $online | Should -Match 'OnlineLegitimation -='
        $online | Should -Match 'TlsVerificationConfiguration'
        $online | Should -Match 'certificate.*approved fingerprint'
        $online | Should -Match 'EnableLegacyCommunication.*disables TLS'
        $online | Should -Match 'device\.GetService<RHOnlineProvider>\(\)'
        $online | Should -Match 'GoOnlineToPrimary'
        $online | Should -Match 'GoOnlineToBackup'
        ([regex]::Matches($online, '(?m)^## 🛠️ Siemens\.Engineering\.Online\.Configurations\.').Count) | Should -Be 10
        ([regex]::Matches($online, '(?m)^## 🛠️ Siemens\.Engineering\.Online\.Security\.').Count) | Should -Be 2
    }

    It "covers the V21 quick-station fingerprint workflow and exact public types" {
        $skill = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/SKILL.md")
        $fingerprint = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-plc-operations/references/fingerprint-data.md")
        $skill | Should -Match 'references/fingerprint-data\.md'
        $fingerprint | Should -Match 'tiaPortal\.GetService<FingerprintDataProvider>\(\)'
        $fingerprint | Should -Match 'GetFingerprintData\(address, ConfigureOnline\)'
        $fingerprint | Should -Match 'fail closed'
        $fingerprint | Should -Match 'not.*full station comparison'
        ([regex]::Matches($fingerprint, '(?m)^## 🛠️ Siemens\.Engineering\.FingerprintData\.').Count) | Should -Be 4
    }

    It "does not overwrite a drive Safety acceptance report by default" {
        $drives = Get-Content -Raw -LiteralPath (Join-Path $script:RepoRoot "skills/tia-simatic-drives/references/drives-overview.md")
        $drives | Should -Match 'FileOperations\.None'
        $drives | Should -Match 'explicit overwrite authorization'
        $drives | Should -Not -Match '(?m)^\s+FileOperations\.Overwrite\);$'
    }
}
