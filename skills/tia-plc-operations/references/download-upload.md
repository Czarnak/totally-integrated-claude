# PLC Download and Station Upload Reference

Source: TIA Portal Openness V21 — Functions for downloading data to PLC
devices (03/2026), checked against the installed V21 Base and Step7 XML API
documentation.

> C# only. These are live, target-affecting workflows. Do not execute them
> unless the user has explicitly authorized the exact project, interface,
> address, CPU, and direction of transfer.

---

## Namespaces

```csharp
using System;
using Siemens.Engineering;
using Siemens.Engineering.Connection;
using Siemens.Engineering.Download;
using Siemens.Engineering.HW;
using Siemens.Engineering.Upload;
using DownloadConfigurations = Siemens.Engineering.Download.Configurations;
using UploadConfigurations = Siemens.Engineering.Upload.Configurations;
```

The aliases avoid collisions such as `ModuleReadAccessPassword`, which exists
in both configuration namespaces.

---

## Safety gate

Before a download or station upload:

1. Resolve and display the exact offline project, CPU/device item, connection
   mode, PC interface, target interface, and online address.
2. Obtain explicit authorization for that resolved target and direction.
3. Compile before download and inspect the complete compiler result. Compilation
   is also part of download, but the separate compile gives usable diagnostics.
4. Do not run download/upload inside a `Transaction`.
5. Treat every callback configuration as a decision. Handle only types whose
   consequences are understood and explicitly approved; fail closed on every
   unhandled configuration.
6. Never embed passwords. Obtain `SecureString` values through the application's
   approved secret mechanism and clear/dispose secret material promptly.

An offline build, PLCSIM test, or successful API call against another target is
not evidence that the intended physical CPU was changed.

---

## DownloadProvider

`DownloadProvider` is a service on a downloadable CPU `DeviceItem`. A device
item that is not a download target returns `null`.

```csharp
DownloadProvider provider = cpuDeviceItem.GetService<DownloadProvider>();
if (provider == null)
    throw new InvalidOperationException("Selected device item is not downloadable.");

ConnectionConfiguration connection = provider.Configuration;
ConfigurationMode mode = connection.Modes.Find("PN/IE");
ConfigurationPcInterface pcInterface =
    mode?.PcInterfaces.Find(expectedInterfaceName, expectedInterfaceNumber);
IConfiguration target = pcInterface?.TargetInterfaces.Find(expectedTargetName);

if (target == null)
    throw new InvalidOperationException("The approved download target was not resolved.");
```

Do not silently fall back to the first interface or target. If the configured
offline IP differs from the running PLC address, use the overload that also
accepts a `ConfigurationAddress` created from the selected target interface.

### R/H systems

An R/H system exposes `RHDownloadProvider` from the system `Device`; member CPUs
do not expose the standard `DownloadProvider` workflow. Primary and backup are
separate write targets even though they share one connection configuration:

```csharp
RHDownloadProvider provider =
    device.GetService<RHDownloadProvider>();
if (provider == null)
    throw new InvalidOperationException("Selected device is not an R/H system.");

IConfiguration target = ResolveApprovedTarget(provider.Configuration);

DownloadResult primary = provider.DownloadToPrimary(
    target,
    ConfigurePreDownload,
    ConfigurePostDownload,
    DownloadOptions.Hardware | DownloadOptions.Software);

// Use DownloadToBackup(...) only when the approved target is the backup CPU.
```

Do not automatically retry `DownloadToPrimary` as `DownloadToBackup`, or vice
versa. Bind the R/H system identity, selected role, target interface/address,
and the current `PrimaryState`/`BackupState` evidence into the authorization.
Each result is reconciled independently.

### Callback rule

Both delegates may be invoked multiple times. The pre-download callback handles
decisions before transfer; the post-download callback commonly handles the
module restart decision. This deliberately incomplete template aborts whenever
V21 presents a configuration that has not been reviewed:

```csharp
private static void ConfigurePreDownload(
    DownloadConfigurations.DownloadConfiguration configuration)
{
    if (configuration is DownloadConfigurations.StopModules stop)
    {
        stop.CurrentSelection =
            DownloadConfigurations.StopModulesSelections.StopAll;
        return;
    }

    if (configuration is DownloadConfigurations.ConsistentBlocksDownload blocks)
    {
        blocks.CurrentSelection =
            DownloadConfigurations.ConsistentBlocksDownloadSelections.ConsistentDownload;
        return;
    }

    if (configuration is DownloadConfigurations.TargetForSoftware target)
    {
        target.CurrentSelection =
            DownloadConfigurations.TargetForSoftwareSelections.CPU;
        return;
    }

    throw new NotSupportedException(
        $"Download aborted: unhandled configuration {configuration.GetType().FullName}");
}

private static void ConfigurePostDownload(
    DownloadConfigurations.DownloadConfiguration configuration)
{
    if (configuration is DownloadConfigurations.StartModules start)
    {
        start.CurrentSelection =
            DownloadConfigurations.StartModulesSelections.StartModule;
        return;
    }

    throw new NotSupportedException(
        $"Download aborted: unhandled configuration {configuration.GetType().FullName}");
}
```

The example selections stop and restart the CPU and therefore require explicit
approval. Extend the callbacks for the exact CPU/product set; do not replace the
final exception with a permissive default.

### Invoke and verify

```csharp
DownloadOptions options = DownloadOptions.Hardware | DownloadOptions.Software;
DownloadResult result = provider.Download(
    target,
    ConfigurePreDownload,
    ConfigurePostDownload,
    options);

if (result.State == DownloadResultState.Error || result.ErrorCount != 0)
    throw new InvalidOperationException(
        $"Download failed with {result.ErrorCount} errors and {result.WarningCount} warnings.");
```

Valid V21 `DownloadOptions` are `Hardware`, `Software`, and
`SoftwareOnlyChanges`. Do not combine `Software` with `SoftwareOnlyChanges`, and
do not use `None`.

Always traverse and persist `DownloadResult.Messages`; the top-level state and
counts alone do not explain warnings or nested failures.

### Download to a Windows folder

V21 can generate a PLC/SIMATIC-memory-card image in a local Windows folder
without connecting to a PLC. The standard and R/H providers expose
`Download(DirectoryInfo, DownloadConfigurationDelegate)`:

```csharp
DirectoryInfo output = new DirectoryInfo(approvedEmptyOutputDirectory);
DownloadResult result = provider.Download(new DirectoryInfo(output.FullName),
                                          ConfigurePreDownload);
```

Treat the folder as a material output: resolve the exact absolute path, require
an empty/new destination or explicit overwrite authorization, handle every
callback configuration, and validate nested result messages. A generated image
is not evidence that any target was downloaded or commissioned.

---

## StationUploadProvider

Station upload is obtained from the **Project**, not from a device item. It
creates an uploaded `Device` in that project and therefore mutates the offline
project.

```csharp
StationUploadProvider provider =
    project.GetService<StationUploadProvider>();
if (provider == null)
    throw new InvalidOperationException("Station upload is unavailable for this project.");

ConnectionConfiguration connection = provider.Configuration;
ConfigurationPcInterface pcInterface =
    connection.Modes.Find("PN/IE")
              ?.PcInterfaces.Find(expectedInterfaceName, expectedInterfaceNumber);
ConfigurationAddress uploadAddress =
    pcInterface?.Addresses.Create(approvedIpAddress);

if (uploadAddress == null)
    throw new InvalidOperationException("The approved upload address was not resolved.");
```

The upload callback follows the same fail-closed rule. Password configurations
must be populated from an approved secret source. For selection configurations,
choose a value deliberately; `NoAction` is the safe default when the user has
not approved the consequence.

```csharp
private static void ConfigureUpload(
    UploadConfigurations.UploadConfiguration configuration)
{
    if (configuration is UploadConfigurations.UploadMissingProducts missing)
    {
        missing.CurrentSelection =
            UploadConfigurations.UploadMissingProductsSelections.NoAction;
        return;
    }

    throw new NotSupportedException(
        $"Upload aborted: unhandled configuration {configuration.GetType().FullName}");
}

UploadResult result = provider.StationUpload(uploadAddress, ConfigureUpload);
Device uploadedStation = result.UploadedStation;

if (result.State == UploadResultState.Error ||
    result.ErrorCount != 0 || uploadedStation == null)
{
    throw new InvalidOperationException(
        $"Station upload failed with {result.ErrorCount} errors.");
}
```

`StationUpload` automatically uploads hardware, software, and files; V21 does
not expose an upload-options argument on this overload. Traverse and persist
all nested `UploadResult.Messages`, then compile and inspect the uploaded
station before deciding whether to save the project.

---

## Installed V21 download-configuration type catalogue

These are the 19 public types under
`Siemens.Engineering.Download.Configurations` in the installed V21 Step7 module.
They can be supplied to the pre/post-download callbacks depending on the exact
target and delta. Handle only an explicitly understood type and fail closed on
every other configuration.

## 🛠️ Siemens.Engineering.Download.Configurations.AllBlocksDownload

Selection configuration whose installed selection is
`AllBlocksDownloadSelections.DownloadAllBlocks`.

## 🛠️ Siemens.Engineering.Download.Configurations.AllBlocksDownloadSelections

Enum containing `AllBlocksDownloadSelections.DownloadAllBlocks`.

## 🛠️ Siemens.Engineering.Download.Configurations.BlockBindingPassword

Password configuration for a block-binding requirement. Supply an approved secret;
never log or persist it.

## 🛠️ Siemens.Engineering.Download.Configurations.CheckBeforeDownload

Confirmation/check configuration surfaced before download.

## 🛠️ Siemens.Engineering.Download.Configurations.ConsistentBlocksDownload

Selection configuration for a consistent block download.

## 🛠️ Siemens.Engineering.Download.Configurations.ConsistentBlocksDownloadSelections

Enum containing `ConsistentBlocksDownloadSelections.ConsistentDownload`.

## 🛠️ Siemens.Engineering.Download.Configurations.DataBlockReinitialization

Selection configuration governing data-block reinitialization.

## 🛠️ Siemens.Engineering.Download.Configurations.DataBlockReinitializationOrKeepActualValues

Selection configuration that can stop/reinitialize, keep actual values, or take no action.

## 🛠️ Siemens.Engineering.Download.Configurations.DataBlockReinitializationOrKeepActualValuesSelections

Enum members: `NoAction`, `StopPlcAndReinitialize`, and
`DataBlockReinitializationOrKeepActualValuesSelections.KeepActualValues`.

## 🛠️ Siemens.Engineering.Download.Configurations.DataBlockReinitializationSelections

Enum members: `StopPlcAndReinitialize` and `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.DeleteWebApplication

Named configuration for deleting a web application from the target.

## 🛠️ Siemens.Engineering.Download.Configurations.DowngradeTargetDevice

Configuration indicating a target-device downgrade consequence.

## 🛠️ Siemens.Engineering.Download.Configurations.DownloadWebApplication

Named configuration for downloading a web application.

## 🛠️ Siemens.Engineering.Download.Configurations.OverwriteTargetLanguages

Configuration indicating overwrite of target languages.

## 🛠️ Siemens.Engineering.Download.Configurations.TargetForSoftware

Selection configuration for the software target.

## 🛠️ Siemens.Engineering.Download.Configurations.TargetForSoftwareSelections

Enum members: `TargetForSoftwareSelections.CPU` and
`TargetForSoftwareSelections.PlcSimulationAdvanced`.

## 🛠️ Siemens.Engineering.Download.Configurations.TurnOffSequence

Configuration indicating a target turn-off sequence.

## 🛠️ Siemens.Engineering.Download.Configurations.UpdateWebApplication

Named configuration for updating a web application.

## 🛠️ Siemens.Engineering.Download.Configurations.UpgradeTargetDevice

Configuration indicating a target-device upgrade consequence.

Target upgrade/downgrade, CPU stop/reinitialization, keep-actual-values, language
overwrite, and web-application delete/update/download are not harmless defaults.
Require exact target identity and explicit live-operation authorization before
selecting/confirming them. Re-present any newly surfaced configuration rather than
auto-retrying with a broader callback.

---

## Installed V21 Base download/upload configuration catalogue

Together with the 19 Step7 types above, the next 50 headings complete the 69
installed V21 Base + Step7 download callback types owned by this skill. The
eight upload headings are the complete Base upload-configuration surface.
Startdrive adds drive-specific callback types; those are owned and catalogued by
`tia-simatic-drives`.

## 🛠️ Siemens.Engineering.Download.Configurations.ActiveTestCanBeAborted

Selection requested when an active test can be aborted.

## 🛠️ Siemens.Engineering.Download.Configurations.ActiveTestCanBeAbortedSelections

`AcceptAll` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.ActiveTestCanPreventDownload

Selection requested when an active test can prevent download.

## 🛠️ Siemens.Engineering.Download.Configurations.ActiveTestCanPreventDownloadSelections

`AcceptAll` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.AlarmTextLibrariesDownload

Alarm-text-library consistency selection.

## 🛠️ Siemens.Engineering.Download.Configurations.AlarmTextLibrariesDownloadSelections

`ConsistentDownload` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.DifferentTargetConfiguration

Decision for a target whose configuration differs.

## 🛠️ Siemens.Engineering.Download.Configurations.DifferentTargetConfigurationSelections

`AcceptAll` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.DownloadCertificate

Certificate-related download check; validate the exact certificate and target.

## 🛠️ Siemens.Engineering.Download.Configurations.DownloadCheckConfiguration

Base check configuration exposing `Checked`.

## 🛠️ Siemens.Engineering.Download.Configurations.DownloadConfiguration

Base callback configuration exposing `Message`.

## 🛠️ Siemens.Engineering.Download.Configurations.DownloadPasswordConfiguration

Base password configuration with `IsSecureCommunication` and
`SetPassword(SecureString)`.

## 🛠️ Siemens.Engineering.Download.Configurations.DownloadSelectionConfiguration

Base selection configuration.

## 🛠️ Siemens.Engineering.Download.Configurations.ExpandDownload

Selection to expand the planned download.

## 🛠️ Siemens.Engineering.Download.Configurations.ExpandDownloadSelections

`Download` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.FitHmiComponents

Check involving HMI components included in the download.

## 🛠️ Siemens.Engineering.Download.Configurations.InitializeMemory

Memory-initialization decision.

## 🛠️ Siemens.Engineering.Download.Configurations.InitializeMemorySelections

`AcceptAll` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.LoadIdentificationData

Identification-data loading decision.

## 🛠️ Siemens.Engineering.Download.Configurations.LoadIdentificationDataSelections

`LoadData` or `LoadNothing`.

## 🛠️ Siemens.Engineering.Download.Configurations.ModuleReadAccessPassword

Module read-access password; supply only through `SecureString`.

## 🛠️ Siemens.Engineering.Download.Configurations.ModuleWriteAccessPassword

Module write-access password; supply only through `SecureString`.

## 🛠️ Siemens.Engineering.Download.Configurations.OverwriteHmiData

Check that can overwrite target HMI data.

## 🛠️ Siemens.Engineering.Download.Configurations.OverwriteOnMemoryCard

Memory-card overwrite selection.

## 🛠️ Siemens.Engineering.Download.Configurations.OverwriteOnMemoryCardSelections

`Load` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.OverwriteSystemData

System-data overwrite selection.

## 🛠️ Siemens.Engineering.Download.Configurations.OverwriteSystemDataSelections

`Overwrite` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.PlcMasterSecretPassword

PLC master-secret password configuration; never log or persist the secret.

## 🛠️ Siemens.Engineering.Download.Configurations.ProtectionLevelChanged

Decision surfaced when the target protection level changed.

## 🛠️ Siemens.Engineering.Download.Configurations.ProtectionLevelChangedSelections

`ContinueDownloading` or `NoChange`.

## 🛠️ Siemens.Engineering.Download.Configurations.ResetModule

Module-reset/delete-all decision.

## 🛠️ Siemens.Engineering.Download.Configurations.ResetModuleSelections

`DeleteAll` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.SelectiveDeleteDataSelections

`AcceptAll`, `DeleteAll`, or `DeleteSelected`.

## 🛠️ Siemens.Engineering.Download.Configurations.SelectiveDeleteDownload

Selective target-data deletion configuration.

## 🛠️ Siemens.Engineering.Download.Configurations.StartBackupModules

R/H backup-module start/switchover selection.

## 🛠️ Siemens.Engineering.Download.Configurations.StartBackupModulesSelections

`NoAction`, `StartModule`, or `SwitchToPrimaryCpu`.

## 🛠️ Siemens.Engineering.Download.Configurations.StartModules

Post-download module-start selection.

## 🛠️ Siemens.Engineering.Download.Configurations.StartModulesSelections

`StartModule` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.StopHSystem

R/H-system stop selection.

## 🛠️ Siemens.Engineering.Download.Configurations.StopHSystemOrModule

Selection between stopping the R/H system, one module, or doing nothing.

## 🛠️ Siemens.Engineering.Download.Configurations.StopHSystemOrModuleSelections

`StopHSystem`, `StopModule`, or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.StopHSystemSelections

`StopHSystem` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.StopModules

Standard module-stop selection.

## 🛠️ Siemens.Engineering.Download.Configurations.StopModulesSelections

`StopAll` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.SwitchBackupToPrimary

R/H role-switchover selection.

## 🛠️ Siemens.Engineering.Download.Configurations.SwitchBackupToPrimarySelections

`SwitchToPrimaryCpu` or `NoAction`.

## 🛠️ Siemens.Engineering.Download.Configurations.UserManagementDownload

User-management-data download decision.

## 🛠️ Siemens.Engineering.Download.Configurations.UserManagementPreDownloadSelections

`DownloadAllUserManagementDataResetToProject`,
`KeepOnlineUserManagementData`, or
`UpdateUserManagementDataButKeepOnlinePassword`.

## 🛠️ Siemens.Engineering.Download.Configurations.WaitOnReboot

Target-reboot wait decision.

## 🛠️ Siemens.Engineering.Download.Configurations.WaitOnRebootSelections

`Wait` or `NoAction`.

## 🛠️ Siemens.Engineering.Upload.Configurations.ModuleReadAccessPassword

Upload module read-access password configuration.

## 🛠️ Siemens.Engineering.Upload.Configurations.ModuleWriteAccessPassword

Upload module write-access password configuration.

## 🛠️ Siemens.Engineering.Upload.Configurations.PasswordReadAccess

Read-access password specialization.

## 🛠️ Siemens.Engineering.Upload.Configurations.UploadConfiguration

Base upload callback configuration exposing `Message`.

## 🛠️ Siemens.Engineering.Upload.Configurations.UploadMissingProducts

Selection for handling products missing from the engineering station.

## 🛠️ Siemens.Engineering.Upload.Configurations.UploadMissingProductsSelections

`UploadMissingProductsSelections.NoAction` or `TryUpload`.

## 🛠️ Siemens.Engineering.Upload.Configurations.UploadPasswordConfiguration

Base upload password configuration with `IsSecureCommunication` and
`SetPassword(SecureString)`.

## 🛠️ Siemens.Engineering.Upload.Configurations.UploadSelectionConfiguration

Base upload selection configuration.

Reset/delete, system or module stop/start, R/H switchover, memory
initialization, memory-card/system/HMI overwrite, user-management replacement,
protection-level continuation, and expanded download are not defaults. Each
requires exact consequence review and explicit live-operation authorization.
