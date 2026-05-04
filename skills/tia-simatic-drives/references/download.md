# Startdrive Download and Configuration API

Reference for download and upload check configurations in TIA Portal V21.

> Namespace: `Siemens.Engineering.Download.Configurations`
> Namespace: `Siemens.Engineering.Upload.Configurations`

---

## 1. Startdrive Specific Check Configurations

These configurations are reported during Startdrive download/upload operations.

### AcceptDownloadOfUnencryptedSensitiveData
>
> Download check configuration for StartDrive to accept the download of unencrypted sensitive data.

### ReplaceDownloadedData
>
> Download check configuration for StartDrive to replace the downloaded data.

### StartDriveDownloadCheckConfiguration
>
> Base download check configuration for StartDrive.

### OverrideTelegramMismatch
>
> Allows upload to proceed despite telegram configuration mismatch.

- `Checked` (bool): Set to true to acknowledge and proceed.

### OverwriteOfflineConfiguration
>
> Allows upload to overwrite the offline device configuration mismatch.

- `Checked` (bool): Set to true to acknowledge and proceed.

---

## 2. Common Download Configurations

These are inherited from the base Download API but frequently encountered in Startdrive workflows.

### DownloadConfiguration (Base)

- `Message` (string): Description of the configuration requirement.

### DownloadCheckConfiguration

- `Checked` (bool): Specifies if this configuration is checked/acknowledged.

### DownloadSelectionConfiguration

- `CurrentSelection` (object): The chosen option from available selections.

### DownloadPasswordConfiguration

- `IsSecureCommunication` (bool)
- `SetPassword(SecureString password)`: Sets the password for the operation.

### StartModules / StopModules
>
> Controls module state after/before download.

- Selections: `NoAction`, `StartModule`, `StopModule`, etc.

### ResetModule
>
> Option to reset the module as part of the download.

---

## 3. Configuration Marker Types

Use these with `DownloadConfiguration.Is<T>()` or when searching the `Configurations` composition.

| Type | Description |
| --- | --- |
| `AcceptDownloadOfUnencryptedSensitiveData` | Sensitive data warning |
| `ReplaceDownloadedData` | Overwrite data warning |
| `StartDriveDownloadCheckConfiguration` | Generic Startdrive check |
| `OverrideTelegramMismatch` | Telegram mismatch during upload |
| `OverwriteOfflineConfiguration` | Offline config mismatch during upload |
| `ActiveTestCanBeAborted` | Commissioning function active warning |
| `AlarmTextLibrariesDownload` | Alarm text download option |
| `InitializeMemory` | Memory initialization warning |
| `OverwriteOnMemoryCard` | Memory card overwrite confirmation |
| `ProtectionLevelChanged` | CPU protection level change warning |
| `UpgradeTargetDevice` | Version mismatch warning |
