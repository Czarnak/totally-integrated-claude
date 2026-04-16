# WinCC Unified — Tags & Alarms

Source: V21 IntelliSense XML — `Siemens.Engineering.WinCCUnified.xml`

> Assembly: `Siemens.Engineering.WinCCUnified.dll`

---

## 1. Tags

### Tag table hierarchy

```
HmiSoftware
  ├── Tags (HmiTagComposition)           ← all tags (flat)
  ├── TagTables (HmiTagTableComposition) ← tag tables
  └── TagTableGroups (HmiTagTableGroupComposition)
        └── HmiTagTableGroup
              ├── TagTables (HmiTagTableComposition)
              └── Groups (HmiTagTableGroupComposition) ← recursive
```

### Create and find tags

```csharp
using Siemens.Engineering.HmiUnified.HmiTags;

// Create a tag table group
HmiTagTableGroup group = hmiSoftware.TagTableGroups.Create("Process_IO");

// Create a tag table
HmiTagTable table = hmiSoftware.TagTables.Create("Temperatures");

// Create a tag (in the default table)
HmiTag tag = hmiSoftware.Tags.Create("Motor_Speed");

// Create a tag in a specific table
HmiTag tagInTable = hmiSoftware.Tags.Create("Motor_Speed", "Temperatures");

// Find
HmiTagTable foundTable = hmiSoftware.TagTables.Find("Temperatures");
HmiTag foundTag = hmiSoftware.Tags.Find("Motor_Speed");
HmiTagTableGroup foundGroup = hmiSoftware.TagTableGroups.Find("Process_IO");

// Enumerate tags in a table
foreach (HmiTag t in foundTable.Tags)
    Console.WriteLine(t.Name);

// Delete
tag.Delete();
table.Delete();
group.Delete();
```

### Import / Export tags

```csharp
// Export all tags
hmiSoftware.Tags.Export(new DirectoryInfo(@"C:\Export\Tags\"));

// Import tags
ImportResult result = hmiSoftware.Tags.Import(new DirectoryInfo(@"C:\Import\Tags\"));
```

### HmiTag properties

| Property | Type | Description |
| --- | --- | --- |
| `Name` | string | Tag name |
| `DataType` | — | Data type |
| `HmiDataType` | — | HMI-specific data type |
| `Connection` | string | Associated HMI connection |
| `PlcTag` | string | Linked PLC tag |
| `PlcName` | string | PLC name |
| `Address` | string | Tag address |
| `TagTableName` | string | Parent tag table |
| `Scope` | `HmiTagScope` | Tag scope |
| `TagType` | `HmiTagType` | Tag type |
| `AccessMode` | `HmiAccessMode` | Access mode |
| `AcquisitionMode` | `HmiAcquisitionMode` | Acquisition mode |
| `AcquisitionCycle` | — | Acquisition cycle |
| `InitialValue` | object | Initial value |
| `InitialMinValue` | object | Lower limit |
| `InitialMaxValue` | object | Upper limit |
| `HmiStartValue` / `HmiEndValue` | object | HMI range |
| `PlcStartValue` / `PlcEndValue` | object | PLC range |
| `LinearScaling` | bool | Linear scaling enabled |
| `Persistent` | bool | Retentive |
| `MaxLength` | int | Data type length |
| `Timeout` | — | Timeout |
| `GmpRelevant` | bool | GMP relevant (pharma) |
| `ConfirmationType` | `HmiConfirmationType` | E-signature confirmation |
| `MandatoryCommenting` | — | Mandatory comments |
| `DBNameMultiplexing` | — | DB name multiplexing |
| `Comment` | `MultilingualTextItemComposition` | Multilingual comment |
| `DisplayName` | string | Display name |
| `LoggingTags` | `HmiLoggingTagComposition` | Associated logging tags |
| `Members` | — | Composite tag members |
| `Thresholds` | `HmiThresholdComposition` | Tag thresholds |
| `SubstituteValue` | `HmiSubstituteValue` | Substitute value config |
| `UpdateId` | — | Update ID |

### Tag enums

| Enum | Values/Purpose |
| --- | --- |
| `HmiAccessMode` | Read/write access mode |
| `HmiAcquisitionMode` | How values are acquired |
| `HmiTagScope` | Scope of the tag |
| `HmiTagType` | Type classification |
| `HmiConfirmationType` | E-signature confirmation options |
| `HmiSubstituteValueUsage` | When substitute value is used |
| `HmiLimitValueType` | Limit value type |
| `HmiUpdateScope` | Update scope |
| `HmiThresholdMode` | Threshold behaviour |

---

## 2. Alarms

### Alarm hierarchy

```
HmiSoftware
  ├── AlarmClasses (HmiAlarmClassComposition)
  ├── DiscreteAlarms (HmiDiscreteAlarmComposition)
  ├── AnalogAlarms (HmiAnalogAlarmComposition)
  ├── HmiAlarmAuditClass (HmiAlarmAuditClassComposition)
  └── OpcUaAlarmTypes (HmiOpcUaAlarmTypeComposition)
```

### Create and manage alarm classes

```csharp
using Siemens.Engineering.HmiUnified.HmiAlarm;
using Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon;

// Create an alarm class
HmiAlarmClass alarmClass = hmiSoftware.AlarmClasses.Create("Critical");

// Configure
alarmClass.Priority = 1;
Console.WriteLine($"ID: {alarmClass.Id}, System: {alarmClass.IsSystem}");

// State machine and visual states
HmiAlarmStateMachine stateMachine = alarmClass.StateMachine;
HmiRaisedState raised = alarmClass.RaisedState;
HmiAcknowledgedState acknowledged = alarmClass.AcknowledgedState;
HmiClearedState cleared = alarmClass.ClearedState;
HmiAcknowledgedClearedState ackCleared = alarmClass.AcknowledgedClearedState;

// Each state has AlarmStatusVisuals for configuring appearance
// Access via alarmClass.RaisedState, .AcknowledgedState, etc.

// Find / delete
HmiAlarmClass found = hmiSoftware.AlarmClasses.Find("Critical");
found?.Delete();
```

### Create discrete alarms

```csharp
HmiDiscreteAlarm discrete = hmiSoftware.DiscreteAlarms.Create("Motor_Overtemp");

// Configure trigger
discrete.TriggerMode = HmiDiscreteAlarmTriggerMode.OnRisingEdge; // or other mode
discrete.TriggerBitAddress = "DB1.DBX0.0";
discrete.RaisedStateTagBitNumber = 0;

// Acknowledgment tags (optional)
discrete.AcknowledgmentControlTag = "AckTag";
discrete.AcknowledgmentControlTagBitNumber = 0;
discrete.AcknowledgmentStateTag = "AckStateTag";
discrete.AcknowledgmentStateTagBitNumber = 0;

// Find / delete
HmiDiscreteAlarm foundDiscrete = hmiSoftware.DiscreteAlarms.Find("Motor_Overtemp");
foundDiscrete?.Delete();
```

### Create analog alarms

```csharp
HmiAnalogAlarm analog = hmiSoftware.AnalogAlarms.Create("Temp_HighLimit");

// Configure condition
analog.Condition = HmiAlarmCondition.HighLimit; // or other condition
analog.ConditionValue = 85.0;
analog.TriggerAddress = "DB1.DBD4";

// Find / delete
HmiAnalogAlarm foundAnalog = hmiSoftware.AnalogAlarms.Find("Temp_HighLimit");
foundAnalog?.Delete();
```

### Alarm state machine model

Each alarm class defines a state machine with these states:

| State property | Type | Description |
| --- | --- | --- |
| `RaisedState` | `HmiRaisedState` | Alarm is active (incoming) |
| `AcknowledgedState` | `HmiAcknowledgedState` | Alarm acknowledged while still active |
| `ClearedState` | `HmiClearedState` | Alarm condition gone but not acknowledged |
| `AcknowledgedClearedState` | `HmiAcknowledgedClearedState` | Alarm acknowledged and condition gone |
| `StateMachine` | `HmiAlarmStateMachine` | Overall state machine configuration |

Each state carries `AlarmStatusVisuals` for configuring colours, icons, and text
displayed in alarm views for that state.

### Audit classes (GMP/pharma)

```csharp
using Siemens.Engineering.HmiUnified.HmiAudit;

HmiAlarmAuditClass auditClass = hmiSoftware.HmiAlarmAuditClass.Create("GMP_Critical");
// AuditConfirmationMode configures e-signature requirements
```

### OPC UA alarm types

```csharp
using Siemens.Engineering.HmiUnified.HmiOpcUaAlarm;

foreach (HmiOpcUaAlarmType opcAlarm in hmiSoftware.OpcUaAlarmTypes)
    Console.WriteLine(opcAlarm);
```
