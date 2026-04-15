# V21 Assembly ↔ Namespace Map

Source: extracted from TIA Portal V21 IntelliSense XML documentation files
(shipped at `C:\...\PublicAPI\V21\net48\*.xml`).

All DLLs located at: `C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\net48\`

---

## Quick-lookup: namespace → required DLL(s)

Use this table to determine which assembly to reference when a `using` directive
is needed. Namespaces marked **★** are shared across multiple DLLs — see the
cross-assembly notes at the bottom.

| Namespace | DLL | Domain skill |
| --- | --- | --- |
| `Siemens.Engineering` | Base | tia-project-general |
| `Siemens.Engineering.AdvancedProtection` | Base | tia-project-general |
| `Siemens.Engineering.Cax` | Step7 | tia-import-export |
| `Siemens.Engineering.Compare` | Base | tia-project-general |
| `Siemens.Engineering.Compiler` | Base | tia-project-general |
| `Siemens.Engineering.Connection` | Base | tia-networks |
| `Siemens.Engineering.CrossReference` | Base | tia-project-general |
| `Siemens.Engineering.CustomIdentity` | Base | tia-project-general |
| `Siemens.Engineering.Download` | Base | tia-plc-operations |
| `Siemens.Engineering.Download.Configurations` | **★ Base + Step7 + Startdrive** | tia-plc-operations |
| `Siemens.Engineering.FingerprintData` | Base | tia-project-general |
| `Siemens.Engineering.HW` | **★ Base + Step7** | tia-devices-general |
| `Siemens.Engineering.HW.CommunicationConnections` | Base | tia-networks |
| `Siemens.Engineering.HW.CustomDataTypes` | Base | tia-devices-general |
| `Siemens.Engineering.HW.Extensions` | Base | tia-devices-general |
| `Siemens.Engineering.HW.Features` | **★ Base + Step7** | tia-devices-general |
| `Siemens.Engineering.HW.HardwareCatalog` | Base | tia-devices-general |
| `Siemens.Engineering.HW.Systemdiagnostics.Settings` | Base | tia-devices-general |
| `Siemens.Engineering.HW.Utilities` | Base | tia-devices-general |
| `Siemens.Engineering.Hmi` | **★ WinCC + WinCC.Extension** | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Alarm` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Communication` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Cycle` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Dynamic` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Event` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Faceplate` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Globalization` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Logging` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.MenuToolbar` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Recipe` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Report` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.RuntimeScripting` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.RuntimeSecurity` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Scheduler` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Screen` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Tag` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.TextGraphicList` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.Hmi.Theming` | WinCC | tia-hmi-operations |
| `Siemens.Engineering.HmiUnified.*` (32 sub-namespaces) | WinCCUnified | tia-hmi-operations |
| `Siemens.Engineering.Library` | Base | tia-project-general |
| `Siemens.Engineering.Library.Compare` | Base | tia-project-general |
| `Siemens.Engineering.Library.MasterCopies` | Base | tia-project-general |
| `Siemens.Engineering.Library.Types` | Base | tia-project-general |
| `Siemens.Engineering.MC.Drives` | Startdrive | tia-simatic-drives |
| `Siemens.Engineering.MC.Drives.DFI` | Startdrive | tia-simatic-drives |
| `Siemens.Engineering.MC.Drives.Enums` | Startdrive | tia-simatic-drives |
| `Siemens.Engineering.MC.Drives.SecurityObjects` | Startdrive | tia-simatic-drives |
| `Siemens.Engineering.Multiuser` | Base | tia-project-general |
| `Siemens.Engineering.Online` | Base | tia-plc-operations |
| `Siemens.Engineering.Online.Configurations` | Base | tia-plc-operations |
| `Siemens.Engineering.Online.Security` | Base | tia-plc-operations |
| `Siemens.Engineering.Safety` | Safety | tia-plc-operations |
| `Siemens.Engineering.Safety.Download.Configurations` | Safety | tia-plc-operations |
| `Siemens.Engineering.SafetyValidation` | SafetyValidation | tia-plc-operations |
| `Siemens.Engineering.Security` | Base | tia-project-general |
| `Siemens.Engineering.Settings` | Base | tia-project-general |
| `Siemens.Engineering.SW` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.Alarm` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.Alarm.Exceptions` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.Alarm.TextLists` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.Blocks` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.Blocks.Exceptions` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.Blocks.Interface` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.ExternalSources` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.Loader` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.OpcUa` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.OpcUa.AccessControl` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.Supervision` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.Tags` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.TechnologicalObjects` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.TechnologicalObjects.Ident` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.TechnologicalObjects.Motion` | **★ Step7 + Startdrive** | tia-plc-operations / tia-simatic-drives |
| `Siemens.Engineering.SW.Types` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.Units` | Step7 | tia-plc-operations |
| `Siemens.Engineering.SW.WatchAndForceTables` | Step7 | tia-plc-operations |
| `Siemens.Engineering.TeamcenterGateway` | TeamcenterGateway | — |
| `Siemens.Engineering.TestSuite.*` | TestSuite | — |
| `Siemens.Engineering.Umac` | Base | tia-project-general |
| `Siemens.Engineering.Upload` | Base | tia-plc-operations |
| `Siemens.Engineering.Upload.Configurations` | **★ Base + Startdrive** | tia-plc-operations |
| `Siemens.Engineering.VersionControl` | Base | tia-project-general |

---

## DLL inventory

15 assemblies total. Sorted by relevance to typical automation tasks.

### Core (always needed)

| Assembly | Namespaces | Types | Purpose |
| --- | --- | --- | --- |
| `Siemens.Engineering.Base.dll` | 33 | 1419 | Core object model: TiaPortal, Project, HW, Library, Download, Upload, Compiler, UMAC, Security, Multiuser |

### Domain-specific (add per task)

| Assembly | Namespaces | Types | Purpose |
| --- | --- | --- | --- |
| `Siemens.Engineering.Step7.dll` | 19 | 180 | PLC software: blocks, tags, types, units, alarms, OPC UA, watch/force tables |
| `Siemens.Engineering.WinCC.dll` | 18 | 269 | Classic HMI: screens, tags, alarms, recipes, logging, scripting, faceplates |
| `Siemens.Engineering.WinCCUnified.dll` | 32 | 536 | Unified HMI: screens, tags, widgets, controls, dynamization, events |
| `Siemens.Engineering.Startdrive.dll` | 5 | 80 | SINAMICS drives: drive objects, parameters, telegrams, DFI, commissioning |
| `Siemens.Engineering.Safety.dll` | 2 | 18 | F-system safety operations and download configurations |
| `Siemens.Engineering.SafetyValidation.dll` | 1 | 19 | Safety validation rules |

### Add-In framework (for TIA Portal Add-Ins only)

| Assembly | Namespaces | Types | Purpose |
| --- | --- | --- | --- |
| `Siemens.Engineering.AddIn.Base.dll` | 10 | 66 | Add-In providers, context menus, workflows, VCI integration |
| `Siemens.Engineering.AddIn.Permissions.dll` | 1 | 2 | Add-In permission declarations |
| `Siemens.Engineering.AddIn.Step7.dll` | 1 | 10 | CAx workflow Add-In integration |
| `Siemens.Engineering.AddIn.Utilities.dll` | 1 | 2 | Add-In utility helpers |
| `Siemens.Engineering.AddIn.Safety.dll` | 1 | 6 | Safety compile workflow Add-In integration |

### Specialized (rarely needed)

| Assembly | Namespaces | Types | Purpose |
| --- | --- | --- | --- |
| `Siemens.Engineering.WinCC.Extension.dll` | 1 | 17 | Extended HMI value types (ConstValue, ILimit, DateTimeValues) |
| `Siemens.Engineering.TeamcenterGateway.dll` | 1 | 20 | Teamcenter PLM integration |
| `Siemens.Engineering.TestSuite.dll` | 4 | 28 | Application tests, style guide checks, system tests |

---

## Key types per DLL

### Siemens.Engineering.Base.dll — key types

**Root namespace (`Siemens.Engineering`):**
`TiaPortal`, `TiaPortalMode`, `TiaPortalProcess`, `TiaPortalSession`,
`Project`, `ProjectComposition`, `ProjectOpenMode`,
`ExclusiveAccess`, `Transaction`,
`IEngineeringObject`, `IEngineeringComposition`, `IEngineeringService`, `IEngineeringServiceProvider`,
`Language`, `LanguageComposition`, `LanguageSettings`, `MultilingualText`,
`ImportOptions`, `ExportOptions`,
`UmacCredentials`, `UmacDelegate`,
all `Engineering*Exception` types,
`ConfirmationEventArgs`, `NotificationEventArgs`, `AuthenticationEventArgs`

**HW (`Siemens.Engineering.HW`):**
`Device`, `DeviceComposition`, `DeviceItem`, `DeviceItemComposition`,
`DeviceGroup`, `DeviceGroupComposition`, `DeviceSystemGroup`, `DeviceUserGroup`,
`Subnet`, `SubnetComposition`, `Node`, `NodeComposition`, `IoSystem`, `IoSystemComposition`,
`GsdDevice`, `GsdDeviceItem`,
plus ~900 enum types for HW configuration attributes

**HW.Features (`Siemens.Engineering.HW.Features`):**
`SoftwareContainer`, `NetworkInterface`, `NetworkPort`,
`AddressController`, `AddressControllerAssociation`,
`CommunicationManagement`, `WebserverFeature`, `DisplayProtection`,
`OpcUaConfiguration`, `SntpConfiguration`,
`WatchAndForceTableAccessManager` (★ in Step7)

**Library (`Siemens.Engineering.Library` + sub-namespaces):**
`ProjectLibrary`, `GlobalLibrary`, `GlobalLibraryComposition`,
`MasterCopyFolder`, `MasterCopyComposition`, `MasterCopy`, `MasterCopySystemFolder`, `MasterCopyUserFolder`,
`LibraryType`, `LibraryTypeComposition`, `LibraryTypeVersion`, `LibraryTypeFolder`

**Download / Upload:**
`DownloadProvider`, `DownloadConfiguration`, `DownloadConfigurationDelegate`,
`UploadProvider`, `UploadConfiguration`

**Online (`Siemens.Engineering.Online`):**
`OnlineProvider`, `OnlineState`, `GoOnlineConfiguration`, `GoOfflineConfiguration`

**Compiler (`Siemens.Engineering.Compiler`):**
`CompilerResult`, `CompilerResultMessage`, `CompilerResultMessageComposition`

**Multiuser (`Siemens.Engineering.Multiuser`):**
`LocalSession`, `LocalSessionComposition`, `ProjectServer`, `ProjectServerComposition`,
`MultiuserProject`, `MultiuserSession`

**Security / UMAC:**
`SecurityController`, `CertificateComposition` (in `Siemens.Engineering.Security`);
`UmacFunctionRight`, `UmacRole`, `UmacUser`, `UmacUserComposition` etc. (in `Siemens.Engineering.Umac`)

**VersionControl (`Siemens.Engineering.VersionControl`):**
`VersionControlProviderComposition`, `WorkspaceProvider`, `WorkspaceFolderComposition`

### Siemens.Engineering.Step7.dll — key types

**SW (`Siemens.Engineering.SW`):**
`PlcSoftware`, `PlcDocument`, `PlcDocumentComposition`,
`PlcChecksumProvider`, `FingerprintProvider`, `ProcessImageProvider`

**SW.Blocks:**
`PlcBlock`, `PlcBlockGroup`, `PlcBlockComposition`,
`PlcBlockSystemGroup`, `PlcBlockUserGroup`, `PlcBlockUserGroupComposition`,
`OB`, `FB`, `FC`, `GlobalDB`, `InstanceDB`, `ArrayDB`,
`PlcExternalSource`, `PlcExternalSourceGroup`

**SW.Tags:**
`PlcTagTable`, `PlcTagTableComposition`, `PlcTagTableSystemGroup`, `PlcTagTableUserGroup`,
`PlcTag`, `PlcTagComposition`, `PlcConstant`, `PlcConstantComposition`,
`PlcSystemConstant`, `PlcSystemConstantComposition`,
`PlcUserConstant`, `PlcUserConstantComposition`

**SW.Types:**
`PlcType`, `PlcTypeComposition`, `PlcTypeGroup`,
`PlcTypeSystemGroup`, `PlcTypeUserGroup`, `PlcTypeUserGroupComposition`,
`PlcStruct`

**SW.Units:**
`SoftwareUnit`, `SoftwareUnitComposition`, `SoftwareUnitGroup`,
`CodeBlock`, `CodeBlockComposition`, `DataBlock`, `DataBlockComposition`

**SW.WatchAndForceTables:**
`PlcWatchTable`, `PlcWatchTableComposition`,
`PlcForceTable`, `PlcForceTableComposition`,
`PlcWatchAndForceTableSystemGroup`, `PlcWatchAndForceTableUserGroup`

**SW.Alarm:**
`AlarmClass`, `AlarmClassComposition`, `ProDiagFB`,
`PlcAlarm`, `PlcAlarmComposition`

**SW.OpcUa:**
`OpcUaServerInterface`, `OpcUaNodeComposition`,
`OpcUaCommunicationGroup`, `OpcUaCommunicationGroupComposition`

**SW.ExternalSources:**
`PlcExternalSource`, `PlcExternalSourceComposition`,
`PlcExternalSourceGroup`, `PlcExternalSourceSystemGroup`, `PlcExternalSourceUserGroup`

**SW.Supervision:**
`SupervisionGroup`, `SupervisionGroupComposition`,
`OperatorMessage`, `SupervisionAlarm`

### Siemens.Engineering.WinCC.dll — key types

**Hmi.Screen (141 types!):**
`HmiScreen`, `HmiScreenComposition`, `ScreenFolder`, `ScreenSystemFolder`, `ScreenUserFolder`,
`ScreenTemplate`, `ScreenTemplateComposition`, `ScreenPopup`, `ScreenPopupComposition`,
`ScreenGlobalElements`, plus all screen element types (shapes, controls, etc.)

**Hmi.Tag:**
`HmiTag`, `HmiTagComposition`, `HmiTagTable`, `HmiTagTableComposition`,
`HmiTagFolder`, `HmiTagSystemFolder`, `HmiTagUserFolder`

**Hmi.Communication:**
`HmiConnection`, `HmiConnectionComposition`

**Hmi.Alarm:**
`DiscreteAlarm`, `DiscreteAlarmComposition`, `AnalogAlarm`, `AnalogAlarmComposition`,
`AlarmClass` (HMI variant), `AlarmClassComposition`

**Hmi.RuntimeScripting:**
`VBScript`, `VBScriptComposition`, `VBScriptFolder`,
`VBScriptSystemFolder`, `VBScriptUserFolder`

**Hmi.Logging:**
`DataLog`, `DataLogComposition`, `LoggingTag`, `LoggingTagComposition`

**Hmi.Recipe:**
`Recipe`, `RecipeComposition`, `RecipeElement`, `RecipeElementComposition`

### Siemens.Engineering.Startdrive.dll — key types

**MC.Drives:**
`DriveObject`, `DriveObjectComposition`, `DriveObjectContainer`,
`DriveParameter`, `DriveParameterComposition`,
`Telegram`, `TelegramComposition`,
`OnlineDriveObject`, `OnlineDriveObjectComposition`,
`TechnologyExtension`, `TechnologyExtensionComposition`,
`Security`, `SecurityComposition`,
`SafetyAcceptanceTestProvider`, `SafetyAcceptanceTestReport`

**MC.Drives.DFI:**
`DriveFunctionInterface`, `Commissioning`,
`DriveObjectActivation`, `DriveObjectFunctions`,
`MotorConfiguration`, `EncoderConfiguration`, `HardwareProjection`,
`SafetyCommissioning`

### Siemens.Engineering.AddIn.Base.dll — key types

**AddIn providers:**
`ProjectTreeAddInProvider`, `ProjectLibraryTreeAddInProvider`,
`GlobalLibraryTreeAddInProvider`, `DevicesAndNetworksAddInProvider`

**Menu system (`Siemens.Engineering.AddIn.Menu`):**
`ContextMenuAddIn`, `ContextMenuAddInRoot`,
`ActionItem`, `ActionItem<T>`, `ChildItemFactory`, `Submenu`,
`MenuSelectionProvider`, `MenuStatus`,
`CheckBoxActionItemStyle`, `RadioButtonActionItemStyle`

**Service providers:**
`MessageBoxProvider` — display notification/confirmation dialogs
`ProgressProvider` — display progress bar, check `IsCancelRequested`
`FeedbackProvider` — log messages to TIA Portal Inspector window

**VCI Add-Ins (`Siemens.Engineering.AddIn.VersionControl`):**
`VciEditorAddInProvider`, `VciWorkspaceViewAddInProvider`,
`ExportContext`, `ImportContext`, `ExportArgs`, `ImportArgs`

**Workflow (`Siemens.Engineering.AddIn.Workflow`):**
`WorkflowContext`, `WorkflowExecutionResult`, `WorkflowReturnCode`

---

## Cross-assembly namespace warnings

Six namespaces are split across multiple DLLs. When using types from these
namespaces, you may need to reference more than one assembly.

| Namespace | DLLs | Notes |
| --- | --- | --- |
| `Download.Configurations` | Base (50 types) + Step7 (19 types) + Startdrive (3 types) | Base has generic download configs; Step7 adds block-specific configs; Startdrive adds drive-specific configs. Reference the DLL matching your target device. |
| `HW` | Base (942 types) + Step7 (5 types) | Base has all core HW types. Step7 adds only `WatchTableAccessRule` and `ForceTableAccessRule` — only needed for watch/force table access management. |
| `HW.Features` | Base (42 types) + Step7 (3 types) | Base has all core features. Step7 adds `WatchAndForceTableAccessManager`, `WebDBGenerateOptions`, `WebserverUserDefinedPages`. |
| `Hmi` | WinCC (13 types) + WinCC.Extension (4 types) | WinCC has main types. Extension adds `ConstValue`, `ILimit`, `DateTimeValues`, `NullableDateTime` — only needed for advanced HMI value operations. |
| `SW.TechnologicalObjects.Motion` | Step7 (21 types) + Startdrive (5 types) | Step7 has core motion types. Startdrive adds SDR (Startdrive) interface variants for axis/encoder hardware connections. |
| `Upload.Configurations` | Base (8 types) + Startdrive (2 types) | Base has generic upload configs. Startdrive adds `OverrideTelegramMismatch`, `OverwriteOfflineConfiguration`. |

**Rule:** For most PLC-only tasks, `Base.dll` + `Step7.dll` covers everything.
Add `WinCC.dll` for HMI, `Startdrive.dll` for drives, `Safety.dll` for F-systems.

---

## csproj reference patterns

### Standalone Openness application

Reference DLLs directly. Use `Copy Local: False` for all Siemens assemblies:

```xml
<ItemGroup>
  <Reference Include="Siemens.Engineering.Base">
    <HintPath>C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\net48\Siemens.Engineering.Base.dll</HintPath>
    <Private>False</Private>
  </Reference>
  <Reference Include="Siemens.Engineering.Step7">
    <HintPath>C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\net48\Siemens.Engineering.Step7.dll</HintPath>
    <Private>False</Private>
  </Reference>
  <!-- Add more as needed per the table above -->
</ItemGroup>
```

### Add-In project (uses TiaPortalLocation MSBuild property)

The `addin-project` template auto-references these five assemblies:
`Siemens.Engineering.Base`, `Siemens.Engineering.AddIn.Base`,
`Siemens.Engineering.AddIn.Step7`, `Siemens.Engineering.AddIn.Utilities`,
`Siemens.Engineering.AddIn.Permissions`.

To add extra assemblies (e.g. `Step7.dll` for PLC access), add the reference
to **both** ItemGroup blocks in the `.csproj` — one inside the
`<Target Name="SetEngineeringAddinReferences">` and one at the outer level:

```xml
<!-- Inside <Target Name="SetEngineeringAddinReferences"> / <ItemGroup Condition="... == ''"> -->
<Reference Include="Siemens.Engineering.Step7">
  <HintPath>$(TiaPortalLocation)\PublicAPI\V21\net48\Siemens.Engineering.Step7.dll</HintPath>
  <Private>False</Private>
</Reference>

<!-- In the outer <ItemGroup Condition="... != ''"> -->
<Reference Include="Siemens.Engineering.Step7">
  <HintPath>$(TiaPortalLocation)\PublicAPI\V21\net48\Siemens.Engineering.Step7.dll</HintPath>
  <Private>False</Private>
</Reference>
```

### Domain skill → DLL cheat sheet

| Task domain | Required DLLs |
| --- | --- |
| Project lifecycle, settings, UMAC, libraries | Base |
| Device/hardware configuration | Base |
| PLC blocks, tags, types, units | Base + Step7 |
| PLC alarms, OPC UA, watch/force tables | Base + Step7 |
| PLC online operations, download, upload | Base + Step7 |
| F-system / safety | Base + Step7 + Safety |
| Classic HMI screens, tags, scripting | Base + WinCC |
| Unified HMI | Base + WinCCUnified |
| SINAMICS drives | Base + Startdrive |
| Drives + motion axes | Base + Step7 + Startdrive |
| Network/subnet configuration | Base |
| Import/Export (CAx, XML) | Base + Step7 |
| Add-In development | AddIn.Base + AddIn.Permissions + AddIn.Utilities (+ domain DLLs as needed) |
