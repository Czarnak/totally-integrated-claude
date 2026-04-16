# WinCC Unified — Overview & Navigation

Source: V21 IntelliSense XML — `Siemens.Engineering.WinCCUnified.xml`

> C# only. Assembly: `Siemens.Engineering.WinCCUnified.dll`
> Root namespace: `Siemens.Engineering.HmiUnified`

---

## 1. Entry point — HmiSoftware

Access via `SoftwareContainer` on the Unified HMI device item:

```csharp
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.HmiUnified;

SoftwareContainer sc = unifiedDeviceItem.GetService<SoftwareContainer>();
HmiSoftware hmiSoftware = sc?.Software as HmiSoftware;
```

> **Classic vs Unified:** Classic HMI uses `HmiTarget` (from `Siemens.Engineering.Hmi`).
> Unified HMI uses `HmiSoftware` (from `Siemens.Engineering.HmiUnified`).
> Check the device type to determine which cast to use.

---

## 2. HmiSoftware composition map

All Unified HMI data is accessed through `HmiSoftware` properties:

| Property | Type | Namespace | Reference file |
| --- | --- | --- | --- |
| `Screens` | `HmiScreenComposition` | `UI.Screens` | `unified-screens-elements.md` |
| `ScreenGroups` | `HmiScreenGroupComposition` | `UI.ScreenGroup` | `unified-screens-elements.md` |
| `Tags` | `HmiTagComposition` | `HmiTags` | `unified-tags-alarms.md` |
| `TagTables` | `HmiTagTableComposition` | `HmiTags` | `unified-tags-alarms.md` |
| `TagTableGroups` | `HmiTagTableGroupComposition` | `HmiTags` | `unified-tags-alarms.md` |
| `SystemTags` | `HmiSystemTagComposition` | `HmiTags` | `unified-tags-alarms.md` |
| `AlarmClasses` | `HmiAlarmClassComposition` | `HmiAlarm` | `unified-tags-alarms.md` |
| `DiscreteAlarms` | `HmiDiscreteAlarmComposition` | `HmiAlarm` | `unified-tags-alarms.md` |
| `AnalogAlarms` | `HmiAnalogAlarmComposition` | `HmiAlarm` | `unified-tags-alarms.md` |
| `HmiAlarmAuditClass` | `HmiAlarmAuditClassComposition` | `HmiAudit` | `unified-tags-alarms.md` |
| `OpcUaAlarmTypes` | `HmiOpcUaAlarmTypeComposition` | `HmiOpcUaAlarm` | `unified-tags-alarms.md` |
| `Connections` | `HmiConnectionComposition` | `HmiConnections` | `unified-logging-connections.md` |
| `DataLogs` | `HmiDataLogComposition` | `HmiLogging` | `unified-logging-connections.md` |
| `AlarmLogs` | `HmiAlarmLogComposition` | `HmiLogging` | `unified-logging-connections.md` |
| `AuditTrails` | `HmiAuditTrailComposition` | `HmiLogging` | `unified-logging-connections.md` |
| `Scripts` | `HmiScriptModuleComposition` | `Scripts` | `unified-logging-connections.md` |
| `HmiTextLists` | `HmiTextListComposition` | `TextGraphicList` | `unified-logging-connections.md` |
| `HmiSystemTextLists` | `HmiSystemTextListComposition` | `TextGraphicList` | `unified-logging-connections.md` |
| `HmiGraphicLists` | `HmiGraphicListComposition` | `TextGraphicList` | `unified-logging-connections.md` |
| `RuntimeSettings` | `HmiRuntimeSetting` | `RuntimeSettings` | `unified-logging-connections.md` |
| `PlantObjectTags` | — | `Cpm` | `unified-logging-connections.md` |

---

## 3. Standard composition pattern

All Unified compositions follow the same contract:

```csharp
// Create
var newItem = composition.Create("ItemName");

// Find (non-recursive — current level only)
var found = composition.Find("ItemName");

// Enumerate
foreach (var item in composition)
    Console.WriteLine(item.Name);

// Contains / IndexOf
bool exists = composition.Contains(someItem);
int idx = composition.IndexOf(someItem);

// Count
int total = composition.Count;

// Delete (on the item, not the composition)
found.Delete();
```

### Import / Export (available on tags and scripts)

```csharp
// Tags — export and import via HmiTagComposition
hmiSoftware.Tags.Export(new DirectoryInfo(@"C:\Export\Tags\"));
hmiSoftware.Tags.Export("exportFileName");
ImportResult result = hmiSoftware.Tags.Import(new DirectoryInfo(@"C:\Import\Tags\"));
ImportResult result2 = hmiSoftware.Tags.Import("importFileName");

// Scripts — export and import via HmiScriptModuleComposition
hmiSoftware.Scripts.Export(new DirectoryInfo(@"C:\Export\Scripts\"));
hmiSoftware.Scripts.Import(new DirectoryInfo(@"C:\Import\Scripts\"));
```

### ImportResult

Import operations return an `ImportResult` with:

| Property | Description |
| --- | --- |
| `State` | `ResultState` — success/failure of the operation |
| `Messages` | Collection of messages during import |
| `CreatedObject` | The created object(s) |
| `Documents` | List of documents used for creation |

---

## 4. Attribute-based configuration

Unified objects use the standard `GetAttribute`/`SetAttribute` pattern for properties
not exposed as direct .NET properties:

```csharp
// Read
object value = hmiTag.GetAttribute("SomeProperty");

// Write
hmiTag.SetAttribute("SomeProperty", newValue);

// Discover available attributes
var infos = ((IEngineeringObject)hmiTag).GetAttributeInfos();
foreach (var info in infos)
    Console.WriteLine($"{info.Name} ({info.AccessMode})");
```

---

## 5. Validation

Many Unified objects support validation via the `IValidator` interface:

```csharp
HmiValidationResult result = hmiTag.Validate();
// Check result for errors
```

---

## 6. Required usings

```csharp
using Siemens.Engineering.HmiUnified;                      // HmiSoftware
using Siemens.Engineering.HmiUnified.HmiTags;              // tags, tag tables
using Siemens.Engineering.HmiUnified.HmiAlarm;             // alarm classes, discrete/analog alarms
using Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon; // alarm base types
using Siemens.Engineering.HmiUnified.HmiAudit;             // audit classes
using Siemens.Engineering.HmiUnified.HmiConnections;       // connections
using Siemens.Engineering.HmiUnified.HmiLogging;           // data/alarm logs, audit trails
using Siemens.Engineering.HmiUnified.HmiLogging.HmiLoggingCommon; // log settings
using Siemens.Engineering.HmiUnified.LoggingTags;          // logging tags
using Siemens.Engineering.HmiUnified.RuntimeSettings;      // runtime settings
using Siemens.Engineering.HmiUnified.Scripts;              // script modules
using Siemens.Engineering.HmiUnified.TextGraphicList;      // text/graphic lists
using Siemens.Engineering.HmiUnified.Cpm;                  // plant model
using Siemens.Engineering.HmiUnified.UI.Screens;           // screens
using Siemens.Engineering.HmiUnified.UI.ScreenGroup;       // screen groups
using Siemens.Engineering.HmiUnified.UI.Base;              // screen item base classes
using Siemens.Engineering.HmiUnified.UI.Shapes;            // shapes (circle, rect, etc.)
using Siemens.Engineering.HmiUnified.UI.Widgets;           // widgets (button, IOField, etc.)
using Siemens.Engineering.HmiUnified.UI.Controls;          // controls (alarm, trend, etc.)
using Siemens.Engineering.HmiUnified.UI.Dynamization;      // dynamization
using Siemens.Engineering.HmiUnified.UI.Events;            // event handlers
using Siemens.Engineering.HmiUnified.UI.Parts;             // screen item parts
using Siemens.Engineering.HmiUnified.UI.Features;          // feature interfaces
using Siemens.Engineering.HmiUnified.UI.Enum;              // all UI enums
```
