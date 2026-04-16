# WinCC Unified — Logging, Connections, Settings & Plant Model

Source: V21 IntelliSense XML — `Siemens.Engineering.WinCCUnified.xml`

> Assembly: `Siemens.Engineering.WinCCUnified.dll`

---

## 1. Connections

```csharp
using Siemens.Engineering.HmiUnified.HmiConnections;

// Create a connection
HmiConnection conn = hmiSoftware.Connections.Create("PLC_1_Connection");

// Configure
conn.CommunicationDriver = "SIMATIC S7 300/400";
conn.Partner = "PLC_1";
conn.Station = "Station_1";
conn.InitialAddress = "CommunicationInterface=Industrial Ethernet;" +
    "HostAddress=192.168.0.2;PlcAddress=192.168.0.2;Rack=0;ExpansionSlot=2;" +
    "IsCyclicOperation=true";
conn.DisabledAtStartup = false;
conn.Comment = "Main PLC connection";

// Driver-specific properties
DriverPropertyComposition driverProps = conn.DriverProperties;
foreach (DriverProperty dp in driverProps)
    Console.WriteLine($"{dp}");

// OPC UA alarm configuration
// Access via conn.GetService or attribute-based access

// Find / enumerate / delete
HmiConnection found = hmiSoftware.Connections.Find("PLC_1_Connection");
foreach (HmiConnection c in hmiSoftware.Connections)
    Console.WriteLine($"{c.Name} → {c.Partner} ({c.CommunicationDriver})");
found?.Delete();

// Validate
HmiValidationResult result = conn.Validate();
```

### HmiConnection properties

| Property | Type | Description |
| --- | --- | --- |
| `Name` | string | Connection name |
| `CommunicationDriver` | string | Driver type (e.g. "SIMATIC S7 300/400") |
| `Partner` | string | Connected partner device name |
| `Station` | string | Station containing the partner |
| `Node` | string | Access point of partner |
| `InitialAddress` | string | Key-value connection parameters (semicolon-separated) |
| `DisabledAtStartup` | bool | Connection starts offline |
| `Comment` | string | Additional comments |
| `DriverProperties` | `DriverPropertyComposition` | Driver-specific properties |

---

## 2. Logging

### Data logs

```csharp
using Siemens.Engineering.HmiUnified.HmiLogging;
using Siemens.Engineering.HmiUnified.HmiLogging.HmiLoggingCommon;

// Create a data log
HmiDataLog dataLog = hmiSoftware.DataLogs.Create("ProcessData_Log");

// Find / delete
HmiDataLog found = hmiSoftware.DataLogs.Find("ProcessData_Log");
found?.Delete();

// Enumerate
foreach (HmiDataLog dl in hmiSoftware.DataLogs)
    Console.WriteLine(dl.Name);
```

### Alarm logs

```csharp
HmiAlarmLog alarmLog = hmiSoftware.AlarmLogs.Create("Alarm_Log");
HmiAlarmLog found = hmiSoftware.AlarmLogs.Find("Alarm_Log");
found?.Delete();
```

### Audit trails

```csharp
HmiAuditTrail auditTrail = hmiSoftware.AuditTrails.First();
// Audit trails are typically system-provided; check before creating
Console.WriteLine(auditTrail.Name);
```

### Logging common types

Log configuration is managed via common types in `HmiLogging.HmiLoggingCommon`:

| Type | Description |
| --- | --- |
| `LogSettings` | Overall logging configuration |
| `LogSegment` | Segment configuration (size, rotation) |
| `LogBackup` | Backup configuration |
| `LogDuration` | Time period configuration |
| `SegmentDuration` | Segment time duration |
| `LoggingBase` | Base class for alarm and data logging |
| `DeviceNode` | Storage device node |

Enums: `HmiBackupMode`, `LoggingMethod`, `LoggingSettingType`, `SegmentSize`,
`StorageLocation`, `LogHandlingAtRestart`, `LimitScope`, `TimePeriod`,
`StorageMediaForAudit`, `DataSourceMode`, `HysteresisMode`

---

## 3. Logging tags

Logging tags connect HMI tags to data logs for historical recording:

```csharp
using Siemens.Engineering.HmiUnified.LoggingTags;

// Create a logging tag (associated with an HMI tag)
HmiLoggingTag loggingTag = hmiTag.LoggingTags.Create("Motor_Speed_Log");

// Or find via the tag's logging tags composition
HmiLoggingTag found = hmiTag.LoggingTags.Find("Motor_Speed_Log");

// Configure
loggingTag.DataLog = dataLog;        // reference to HmiDataLog
loggingTag.Source = hmiTag;          // source HMI tag
loggingTag.LoggingMode = HmiLoggingMode.Cyclic;
loggingTag.Cycle = "1s";
loggingTag.CycleFactor = 1;
loggingTag.TriggerMode = HmiTriggerMode.OnChange;
loggingTag.SmoothingMode = HmiSmoothingMode.None;
loggingTag.AggregationMode = HmiAggregationMode.Average;
loggingTag.LimitScope = HmiLimitScope.Tag;
loggingTag.HighLimit = 100.0;
loggingTag.LowLimit = 0.0;

// Validate and delete
loggingTag.Validate();
loggingTag.Delete();
```

### HmiLoggingTag properties

| Property | Type | Description |
| --- | --- | --- |
| `Name` | string | Logging tag name |
| `Source` | — | Source HMI tag |
| `DataLog` | HmiDataLog | Target data log |
| `LoggingMode` | `HmiLoggingMode` | Cyclic / OnChange / etc. |
| `Cycle` | string | Logging cycle |
| `CycleFactor` | int | Cycle multiplier |
| `TriggerMode` | `HmiTriggerMode` | Trigger mode |
| `TriggerTag` | string | Trigger tag (if trigger-based) |
| `TriggerTagBitNumber` | int | Trigger bit number |
| `SmoothingMode` | `HmiSmoothingMode` | Smoothing algorithm |
| `SmoothingDeltaValue` | double | Smoothing delta |
| `SmoothingMinTime` / `SmoothingMaxTime` | — | Smoothing time range |
| `AggregationMode` | `HmiAggregationMode` | Aggregation (Average, Min, Max, etc.) |
| `LimitScope` | `HmiLimitScope` | Limit scope |
| `HighLimit` / `LowLimit` | double | Value limits |

---

## 4. Scripts

```csharp
using Siemens.Engineering.HmiUnified.Scripts;

// Enumerate script modules
foreach (HmiScriptModule script in hmiSoftware.Scripts)
    Console.WriteLine(script.Name);

// Export scripts
hmiSoftware.Scripts.Export(new DirectoryInfo(@"C:\Export\Scripts\"));

// Import scripts
hmiSoftware.Scripts.Import(new DirectoryInfo(@"C:\Import\Scripts\"));
hmiSoftware.Scripts.Import("importFileName");

// Export individual script module
HmiScriptModule module = hmiSoftware.Scripts.First();
module.Export(new DirectoryInfo(@"C:\Export\"));
module.Export("fileName");
```

---

## 5. Text and graphic lists

```csharp
using Siemens.Engineering.HmiUnified.TextGraphicList;

// Text lists
foreach (HmiTextList tl in hmiSoftware.HmiTextLists)
    Console.WriteLine($"TextList: {tl}");

// System text lists (read-only)
foreach (HmiSystemTextList stl in hmiSoftware.HmiSystemTextLists)
    Console.WriteLine($"SystemTextList: {stl}");

// Graphic lists
foreach (HmiGraphicList gl in hmiSoftware.HmiGraphicLists)
    Console.WriteLine($"GraphicList: {gl}");
```

---

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

## 7. Plant model (CPM)

Plant views and plant objects for hierarchical plant structure:

```csharp
using Siemens.Engineering.HmiUnified.Cpm;

// Access plant views
var plantViewsProvider = hmiSoftware.GetService<PlantViewsProvider>();
// (if available as service — otherwise navigate via attribute access)
```

### Plant model types

| Type | Description |
| --- | --- |
| `PlantView` | A plant view (hierarchical structure) |
| `PlantViewComposition` | Collection of plant views |
| `PlantViewNode` | Node in a plant view |
| `PlantViewNodeComposition` | Collection of view nodes |
| `PlantObject` | A plant object |
| `PlantObjectInterface` | Interface definition |
| `PlantObjectInterfaceMember` | Interface member (property) |
| `PlantObjectLoggingTag` | Logging tag on a plant object |

### Plant object tag configuration

| Enum | Description |
| --- | --- |
| `PlantObjectTagAccessMode` | Tag access mode |
| `PlantObjectTagAcquisitionMode` | Acquisition mode |
| `PlantObjectLoggingTagAggregationMode` | Aggregation mode |
| `PlantObjectLoggingTagLoggingMode` | Logging mode |
| `PlantObjectLoggingTagSmoothingMode` | Smoothing mode |
| `PlantObjectLoggingTagTriggerMode` | Trigger mode |
| `PlantObjectLoggingTagLimitScope` | Limit scope |
| `PlantObjectTagLimitValueType` | Limit value type |
| `PlantObjectTagSubstituteValueUsage` | Substitute value usage |
