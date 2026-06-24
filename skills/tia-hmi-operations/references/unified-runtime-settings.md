## 6. Runtime settings

```csharp
using Siemens.Engineering.HmiUnified.RuntimeSettings;

HmiRuntimeSetting settings = hmiSoftware.RuntimeSettings;
```

### Runtime setting sub-objects

Access via `settings.GetAttribute()` or through composition navigation:

| Type | Description |
| --- | --- |
| `HmiRuntimeSetting` | Root runtime settings object |
| `HmiLanguageAndFont` | Language and font configuration |
| `HmiExclusiveOperationSettings` | Exclusive operation mode |
| `HmiMaxLoginRuntimeSettings` | Maximum login settings |
| `HmiOpcUaServerRuntimeSettings` | OPC UA server configuration |
| `HmiProcessDiagnosticsRuntimeSettings` | Process diagnostics |
| `HmiReportingSettings` | Report generation |
| `HmiRuntimeResourceSettings` | Resource allocation |
| `HmiTelemetryRuntimeSettings` | Telemetry configuration |
| `HmiUnifiedTagSettings` | Tag-specific settings |
| `HmiUpssRuntimeSettings` | UPSS (uninterruptible power supply) settings |

### Common setting enums

| Enum | Description |
| --- | --- |
| `ScreenResolution` | Runtime screen resolution |
| `StorageLocation` | Storage location for settings |
| `GeneralPersistencyStrategy` | User-specific persistency |
| `GeneralESIGCommentsStrategy` | E-signature comments strategy |
| `CentralInteractionSetting` | Central zoom/pan settings |
| `BitNumberEvaluationType` | Bit evaluation mode |

---

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiExclusiveOperationSettings
>
> Runtime Settings of Exclusive operation

- 🔧 `ExclusiveOperationControlTag`: Control tag for exclusive operation
- 🔧 `ExclusiveOperationStatusTag`: Status tag for exclusive operation

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiLanguageAndFont
>
> Language and font

- 🔧 `DefaultFont`: Default/Fallback font for language compatible font
- 🔧 `Enable`: Enables language and font
- 🔧 `EnableForLogging`: Enables the language and font for logging
- 🔧 `FixedFont1`: Fixed font 1
- 🔧 `FixedFont2`: Fixed font 2
- 🔧 `FixedFont3`: Fixed font 3
- 🔧 `FixedFont4`: Fixed font 4
- 🔧 `Language`: Language name
- 🔧 `Order`: Order of language and font entry

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiLanguageAndFontAssociation
>
> Language and font list

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.RuntimeSettings.HmiLanguageAndFont)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.RuntimeSettings.HmiLanguageAndFont)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiMaxLoginRuntimeSettings
>
> Runtime Settings of MaxLogin

- 🔧 `EnableLockAfterNumberOfAttempts`: Enable locking user out after a number of unsuccessful attempts
- 🔧 `MaxLoginErrors`: The number of unsuccessful attempts after a user is locked out
- 📦 `Validate`: Validates the object

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiOpcUaServerRuntimeSettings
>
> Runtime Settings of OPC UA server

- 🔧 `ActAsOPCServer`: Specifies whether hmi device should operate as OPC server
- 🔧 `AllowAlarmOperations`: It allows the alarms operations
- 🔧 `EnableAlarmConditions`: Enables the Alarm and conditions to allow the alarm operations
- 🔧 `EnableGuestAuthentication`: Enables the guest user authentication
- 🔧 `EnableLocalDiscoveryServer`: Enables local discovery server for OPC UA server
- 🔧 `EnableUsernameAndPasswordAuthentication`: Enables the username and password authentication
- 🔧 `EndpointUrlPortNumber`: This port number will used to connect OPC UA server
- 🔧 `MaxMonitoredItemPerSubscriptionCount`: Maximum number of items to monitor per subscription count
- 🔧 `MaxSessionCount`: Maximum number of OPC UA sessions
- 🔧 `MaxSessionTimeout`: Maximum session timeout value
- 🔧 `MinPublishingInterval`: Minimum interval for publishing
- 🔧 `OpcUaServerSecurity128RsaModeSigned`: 128bit signed security mode used for OPC UA server
- 🔧 `OpcUaServerSecurity128RsaModeSignedAndEncrypted`: 128bit signed and encrypted security mode used for OPC UA server
- 🔧 `OpcUaServerSecurity256ModeSigned`: 256bit signed security mode used for OPC UA server
- 🔧 `OpcUaServerSecurity256ModeSignedAndEncrypted`: 256bit signed and encrypted security mode used for OPC UA server
- 🔧 `OpcUaServerSecurity256ShaModeSigned`: 256 bit Sha signed security mode used for OPC UA server
- 🔧 `OpcUaServerSecurity256ShaModeSignedAndEncrypted`: 256bit Sha 256 signed and encrypted security mode used for OPC UA server
- 🔧 `OpcUaServerSecurityAes128Sha256RsaOaepSigned`: Aes128Sha256RsaOaepSign security for OPC UA server
- 🔧 `OpcUaServerSecurityAes128Sha256RsaOaepSignedAndEncrypted`: Aes128Sha256RsaOaepSignEncrypt security for OPC UA Server
- 🔧 `OpcUaServerSecurityAes256Sha256RsaPssSigned`: Aes256Sha256RsaPssSign security for OPC UA Server
- 🔧 `OpcUaServerSecurityAes256Sha256RsaPssSignedAndEncrypted`: Aes256Sha256RsaPssSignEncrypt security for OPC UA Server
- 🔧 `OpcUaServerSecurityNone`: No security is used for OPC UA server
- 📦 `Validate`: Validates the object

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiProcessDiagnosticsRuntimeSettings
>
> Runtime setting of Process diagnostics

- 🔧 `CriteriaAnalysisAbsoluteAddress`: Expand alarm text with absolute address of faulty operand.
- 🔧 `CriteriaAnalysisAll`: Extend text with All faulty operands
- 🔧 `CriteriaAnalysisComment`: Expand alarm text with comment of faulty operand.
- 🔧 `CriteriaAnalysisExtendText`: Select which alarm text should be expanded with fault operand information.
- 🔧 `CriteriaAnalysisSymbol`: Expand alarm text with symbol of faulty operand.
- 🔧 `CriteriaAnalysisValue`: Expand alarm text with value of faulty operand.
- 🔧 `EnableProcessDiagnostics`: Indicates whether device participates in process diagnostics

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiReportingSettings
>
> Runtime Settings of Reporting

- 🔧 `IsReportingEnabled`: Activate Reporting
- 🔧 `ReportingDatabaseStorage`: ReportingDatabaseStorage Storage Medium
- 🔧 `ReportingDatabaseStoragePath`: ReportingDatabaseStoragePath Storage Medium
- 🔧 `ReportingMainStorage`: ReportingMainStorage Storage Medium
- 🔧 `ReportingMainStoragePath`: ReportingMainStoragePath Storage Medium

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiRuntimeResourceSettings
>
> Runtime resource settings

- 🔧 `EnableHighResolutionGraphicsOptimization`: Enable this setting to improve the Runtime performance when using high resolution graphics with screen objects. This might affect the zoom/declutter functionality.

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiRuntimeSetting
>
> Runtime settings of hmi device

- 🔧 `AutoLogOffURL`: The attribute allow to configure URL, so that the runtime client is moved to url when is logged off
- 🔧 `BitSelection`: Bit selection for multiple bit tag dynamization
- 🔧 `BitSelectionStrategyForResourceLists`: Indicates the setting for bit number evaluation strategy of resource lists.
- 🔧 `BitSelectionStrategyForTagDynamization`: Indicates the bitselectionfortagdynamization in runtime settings.
- 🔧 `CentralInputHint`: Indicates the Central input hint runtime setting
- 🔧 `CentralPanning`: Indicates the Central panning runtime setting
- 🔧 `CentralZooming`: Indicates the Central zooming runtime setting
- 🔧 `EnableLanguageCompatibleFontFamilies`: Enable language Compatible Font Families
- 🔧 `GMPEnabled`: Determine whether device is GMP relevant or not
- 🔧 `GeneralESIGCommentsStrategy`: Determines values for Good Manufacturing Practice Audit Strategy
- 🔧 `HmiExclusiveOperationSettings`: Exclusive operation related settings in runtime settings
- 🔧 `HmiReportingSettings`: Indicate Reporting Setting
- 🔧 `HmiUnifiedTagSettings`: Unified tags related settings in runtime settings
- 🔧 `HmiUpssRuntimeSettings`: UPSS related settings in runtime settings
- 🔧 `LanguageAndFonts`: List of language and font entries
- 🔧 `MaxLoginRuntimeSettings`: Indicates the MaxLogin settings in runtime settings
- 🔧 `OpcUaServerRuntimeSettings`: Indicated the opc ua settings in runtime settings
- 🔧 `ProcessDiagnosticsRuntimeSettings`: Indicates the process diagnostics runtime settings
- 🔧 `RuntimeResourceSettings`: Indicates the runtime resource settings.This functionality will be available in future version.
- 🔧 `ScreenResolution`: Indicated the screen resolution in runtime settings
- 🔧 `StartScreen`: Name of the start up screen for hmi device
- 🔧 `TelemetryRuntimeSettings`: Telemetry Rumtime Settings
- 📦 `Validate`: Validates RuntimeSettings

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiTelemetryRuntimeSettings
>
> Telemetry Runtime Settings

- 🔧 `TelemetryActive`: Indicates if the telemetry runtime settings is activated/deactivated
- 🔧 `TelemetryStorageFolder`: Storage Path for the telemetry data
- 🔧 `TelemetryStorageMedia`: Storage Media for the telemetry data

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiUnifiedTagSettings
>
> Runtime Settings of Unified tags

- 🔧 `IgnoreInitialQCNotifications`: Setting to specifies whether to ignore first value quality notifications on the Runtime or not.
- 🔧 `IgnoreTimestampNotifications`: Setting to specify whether to ignore tag timestamp change notifications on the Runtime or not.
- 🔧 `TagOptimizationActive`: Setting to specify whether Tag counting Optimization is active or not.

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiUpssRuntimeSettings
>
> Runtime Settings of UPSS

- 🔧 `GlobalScopePersistencyAuthorization`: Necessary function right to persist global default values at Runtime.
- 🔧 `PersistencyStrategy`: Setting to persist or discard user-specific changes of controls at Runtime.

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiRuntimeSettingsCommon.BitNumberEvaluationType
>
> BitNumberEvaluationType enum to select values when multibit is on.

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiRuntimeSettingsCommon.CentralInteractionSetting
>
> CentralInteractionSetting enum to select value for Central Zooming/Panning

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiRuntimeSettingsCommon.CriteriaAnalysisExtendedText
>
> Criteria Analysis Extended Text

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiRuntimeSettingsCommon.ExtendTextWith
>
> Extend text With

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiRuntimeSettingsCommon.GeneralESIGCommentsStrategy
>
> GeneralESIGCommentsStrategy

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiRuntimeSettingsCommon.GeneralPersistencyStrategy
>
> GeneralPersistencyStrategy enum for user specific persistency settings on runtime.

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiRuntimeSettingsCommon.ScreenResolution
>
> ScreenResolution

## 🛠️ Siemens.Engineering.HmiUnified.RuntimeSettings.HmiRuntimeSettingsCommon.StorageLocation
>
> StorageLocation
