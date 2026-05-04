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

## V21 API Reference: Unified Tags & Alarms

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmClass
>
> Specifies alarm class.

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AcknowledgedClearedState`: Specifies Alarm incoming outgoing acknowledge or AcknowledgedCleared status
- 🔧 `AcknowledgedState`: Specifies Alarm incoming acknowledge or acknowledged status
- 🔧 `ClearedState`: Specifies Alarm coming going or cleared status
- 🔧 `CommonAlarmClass`: Common Alarm Class for Alarm
- 🔧 `Id`: Specifies the alarm class number that identifies the alarm class in runtime
- 🔧 `IsSystem`: Specifies if alarm class is system provided
- 🔧 `Log`: Alarm Log for alarm class
- 🔧 `Name`: Name
- 🔧 `Priority`: Specifies the alarm priority
- 🔧 `RaisedState`: Alarm incoming or raised status
- 🔧 `StateMachine`: Defines the statemachine of the alarm class
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmClassComposition
>
> HmiAlarmClassComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmClass)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmClass)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create new object
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAnalogAlarm
>
> HmiAnalogAlarm

- 🔧 `Condition`: Specifies Limit Mode.
- 🔧 `ConditionValue`: Condition Value can be specified as constant value.
- 🔧 `Name`: Name
- 🔧 `TriggerAddress`: Specifies the address of the trigger tag
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAnalogAlarmComposition
>
> HmiAnalogAlarm Composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiAlarm.HmiAnalogAlarm)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiAlarm.HmiAnalogAlarm)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiDiscreteAlarm
>
> HmiDiscreteAlarm

- 🔧 `AcknowledgmentControlTag`: Control Tag for Acknowledgement of discrete alarm
- 🔧 `AcknowledgmentControlTagBitNumber`: Control tag bit number for Acknowledgement of discrete alarm
- 🔧 `AcknowledgmentStateTag`: Acknowledgment tag for discrete alarm
- 🔧 `AcknowledgmentStateTagBitNumber`: Acknowledgment tag bit number for discrete alarm
- 🔧 `Name`: Name
- 🔧 `RaisedStateTagBitNumber`: Trigger bit on the trigger tag
- 🔧 `TriggerBitAddress`: Specifies the address of the trigger bit
- 🔧 `TriggerMode`: Specify trigger mode for discrete alarm
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiDiscreteAlarmComposition
>
> HmiDiscreteAlarmComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiAlarm.HmiDiscreteAlarm)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiAlarm.HmiDiscreteAlarm)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon.AlarmBase
>
> This is base class for AnalogAlarm and DiscreteAlarm

- 🔧 `EventText`: Specifies event/alarm text of alarm.
- 🔧 `EventText1`: Specifies event/alarm text of alarm 1.
- 🔧 `EventText2`: Specifies event/alarm text of alarm 2.
- 🔧 `EventText3`: Specifies event/alarm text of alarm 3.
- 🔧 `EventText4`: Specifies event/alarm text of alarm 4.
- 🔧 `EventText5`: Specifies event/alarm text of alarm 5.
- 🔧 `EventText6`: Specifies event/alarm text of alarm 6.
- 🔧 `EventText7`: Specifies event/alarm text of alarm 7.
- 🔧 `EventText8`: Specifies event/alarm text of alarm 8.
- 🔧 `EventText9`: Specifies event/alarm text of alarm 9.
- 🔧 `InfoText`: Specifies the multilingual InfoText of the alarm
- 🔧 `Parent`: EOM parent of this object
- 🔧 `AlarmClass`: Specifies the alarm class
- 🔧 `AlarmParameterTags`: Specifies the alarm pararmeters
- 🔧 `Area`: Specifies the area of the alarm
- 🔧 `AuditClass`: AuditClass
- 🔧 `Id`: Alarm row identification Number
- 🔧 `Origin`: Specifies the origin of the alarm
- 🔧 `Priority`: Specifies the alarm priority
- 🔧 `RaisedStateTag`: Specifies the tag that raise/trigger the alarm
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon.AlarmStatusVisuals
>
> Specifies the alarm status visuals

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 🔧 `BackColor`: Specifies the background color
- 🔧 `Flashing`: Specifies the flashing color
- 🔧 `TextColor`: Specifies the text color
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon.HmiAcknowledgedClearedState
>
> HmiAcknowledgedClearedState

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon.HmiAcknowledgedState
>
> HmiAcknowledgedState

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon.HmiAlarmCondition
>
> HmiAlarmCondition

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon.HmiAlarmStateMachine
>
> HmiAlarmStateMachine

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon.HmiClearedState
>
> HmiClearedState

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon.HmiDiscreteAlarmTriggerMode
>
> HmiDiscreteAlarmTriggerMode

## 🛠️ Siemens.Engineering.HmiUnified.HmiAlarm.HmiAlarmCommon.HmiRaisedState
>
> HmiRaisedState

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAudit.AuditConfirmationMode
>
> This class is used to select audit confirmation mode

## 🛠️ Siemens.Engineering.HmiUnified.HmiAudit.HmiAlarmAuditClass
>
> Specifies HmiAlarmAuditClass derived from HmiAuditClass to be used for Discrete/Ananlog alarms

- 🔧 `Parent`: EOM parent of this object
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAudit.HmiAlarmAuditClassComposition
>
> AlarmAuditClasses Collection

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiAudit.HmiAlarmAuditClass)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiAudit.HmiAlarmAuditClass)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Create
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiAudit.HmiAuditClass
>
> This is a prerequisite for HmiAlarmAuditClass

- 🔧 `Parent`: EOM parent of this object
- 🔧 `CommentRequired`: AuditClass CommentRequired attribute
- 🔧 `ConfirmationMode`: AuditClass ConfirmationMode attribute
- 🔧 `DisplayName`: Audit Class DisplayName atrtibute description
- 🔧 `IsGmpEnabled`: Check if GMP Enabled for AuditClass
- 🔧 `Name`: Name of audit class
- 🔧 `RequiredFunctionRights`: AuditClass RequiredFunctionRights attribute
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiOpcUaAlarm.HmiOpcUaAlarmType
>
> Specifies OPC alarm and condition type class.

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AlarmClass`: Specifies Alarm class
- 🔧 `Area`: Specifies the Area Text
- 🔧 `ConditionTypeId`: Specifies Condition type ID
- 🔧 `Connection`: Specifies Connection
- 🔧 `Name`: Name
- 🔧 `NodeId`: Specifies Node ID
- 📦 `SetNodeIdAndConnection(System.String,System.String)`: Sets NodeId and Connection together
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiOpcUaAlarm.HmiOpcUaAlarmTypeComposition
>
> HmiOpcUaAlarmTypeComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiOpcUaAlarm.HmiOpcUaAlarmType)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiOpcUaAlarm.HmiOpcUaAlarmType)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String,System.String,System.String)`: Create Opc Ua Alarm with Connection and NodeId
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiAccessMode
>
> Hmi Tag Access Mode

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiAcquisitionMode
>
> AcquisitionMode of Hmi Tag

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiConfirmationType
>
> Confirmation Type of Hmi Tag

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiLimitValueType
>
> Description for limit value type

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiSubstituteValue
>
> Description for substitute value

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 🔧 `SubstituteValueUsage`: Get or set substitute value
- 🔧 `Value`: Get and set substitute value
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiSubstituteValueUsage
>
> Hmi Substitute Value Usage

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiSystemTag
>
> Hmi system tag

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 🔧 `DataType`: Data type of the system tag
- 🔧 `Name`: Name of system tag
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiSystemTagComposition
>
> Collection of hmi system tag

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiTags.HmiSystemTag)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiTags.HmiSystemTag)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds the hmi system tag based on the given name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiTag
>
> Hmi tag class

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 📦 `Siemens#Engineering#IEngineeringServiceProvider#GetServiceInfos`: Returns a collection of EngineeringServiceInfo objects describing the different services on this object.
- 🔧 `Comment`: MultilingualTextItemComposition for Comment property of Tag. Refer documentation for get and set of language specific comment
- 🔧 `DisplayName`: Get/set display name of tag
- 🔧 `LoggingTags`: Represents
- 🔧 `Members`: Members of the composite Hmi tag
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Thresholds`: Thresholds for simple tag
- 🔧 `AccessMode`: The Hmi Tag Access Mode
- 🔧 `AcquisitionCycle`: The Acquisition cycle attribute
- 🔧 `AcquisitionMode`: Hmi Tag AcquisitionMode
- 🔧 `Address`: The Hmi Tag Address Attribute
- 🔧 `BufferHandshakeTag`: Buffer handshake tag attribute
- 🔧 `ConfirmationType`: Provide different acknowledgement options to runtime user when the GMP tag is changed
- 🔧 `Connection`: The Hmi Connection
- 🔧 `DBNameMultiplexing`: DB name multiplexing status of Tag
- 🔧 `DataType`: DataType of the Tag
- 🔧 `GmpRelevant`: Determines whether Tag is GMP relevant or not
- 🔧 `HmiDataType`: Hmi data type
- 🔧 `HmiEndValue`: Hmi end value
- 🔧 `HmiStartValue`: Hmi start value
- 🔧 `InitialMaxValue`: Upper limit
- 🔧 `InitialMinValue`: Lower limit
- 🔧 `InitialValue`: Initial value attribute
- 🔧 `LinearScaling`: Linear scaling
- 🔧 `MandatoryCommenting`: Mandatory Comments
- 🔧 `MaxLength`: The hmi tag DataTypeLength
- 🔧 `Name`: Name of Hmi Tag
- 🔧 `Persistent`: The Persistence attribute
- 🔧 `PlcEndValue`: Plc end value
- 🔧 `PlcName`: The Plc Name Attribute
- 🔧 `PlcStartValue`: Plc start value
- 🔧 `PlcTag`: The Plc Tag attribute
- 🔧 `ReadHandshakeTag`: Read handshake tag attribute
- 🔧 `RequiredFunctionRights`: The required rights for electronic signature
- 🔧 `Scope`: Scope of the tag
- 🔧 `SubstituteValue`: The SubstituteValue
- 🔧 `TagTableName`: The parent tag table
- 🔧 `TagType`: Indicates different types of hmi tag
- 🔧 `Timeout`: Time out attribute
- 🔧 `UpdateId`: The Update Id Attribute
- 🔧 `WriteHandshakeTag`: Write handshake tag attribute
- 📦 `Validate`: Validates the object
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiTagComposition
>
> Collection of hmi tags

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiTags.HmiTag)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiTags.HmiTag)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Export(System.IO.DirectoryInfo)`: Export tags
- 📦 `Export(System.IO.DirectoryInfo,System.String)`: Export tags
- 📦 `Import(System.IO.DirectoryInfo)`: Import tags
- 📦 `Import(System.IO.DirectoryInfo,System.String)`: Import tags
- 📦 `Create(System.String)`: Creates hmi tag
- 📦 `Create(System.String,System.String)`: Creates hmi tag under a specified tag table
- 📦 `Find(System.String)`: Finds the hmi tag based on the given name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiTagScope
>
> Scope of the tag

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiTagTable
>
> Hmi tag tables

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Tags`: Hmi tag collection
- 🔧 `Name`: Name of HmitagTable
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiTagTableComposition
>
> HmitagTable composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiTags.HmiTagTable)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiTags.HmiTagTable)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Creates hmi tag table
- 📦 `Find(System.String)`: Finding the given tagtable
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiTagTableGroup
>
> Specifies the tag table user group

- 🔧 `Groups`: TagTableGroupComposition
- 🔧 `Parent`: EOM parent of this object
- 🔧 `TagTables`: Tag Table Composition
- 🔧 `Name`: Specifies name of tag table user group
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiTagTableGroupComposition
>
> TagTableGroupComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiTags.HmiTagTableGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiTags.HmiTagTableGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create
- 📦 `Find(System.String)`: Find a tag group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiTagType
>
> Indicates different types of hmi tag

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiThreshold
>
> Threshold for a HMI tag

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Mode`: Threshold mode
- 🔧 `Name`: Name of threshold
- 🔧 `Value`: Threshold value
- 🔧 `ValueType`: Threshold value type
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiThresholdComposition
>
> Collection of HMI thresholds

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiTags.HmiThreshold)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiTags.HmiThreshold)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Add a new threshold
- 📦 `Find(System.String)`: Find Threshold
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiThresholdMode
>
> Threshold mode

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.HmiUpdateScope
>
> The hmi tag Update Scope

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.LowerRange
>
> Lower limit range

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.Range
>
> To set value range

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Value`: Value of upper/lower
- 🔧 `ValueType`: Get and set Vlaue type
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiTags.UpperRange
>
> Range for limit high

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
