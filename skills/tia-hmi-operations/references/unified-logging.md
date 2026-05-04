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

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiAlarmLog
>
> Alarm logging

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: Name
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiAlarmLogComposition
>
> Alarm log collection

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiLogging.HmiAlarmLog)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiLogging.HmiAlarmLog)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create method for alarm log
- 📦 `Find(System.String)`: Find method of alarmlog
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiAuditTrail
>
> Audit trail configuration

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: Name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiAuditTrailComposition
>
> Audit trail collection

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiLogging.HmiAuditTrail)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiLogging.HmiAuditTrail)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiDataLog
>
> Data log configuration

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: Name
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiDataLogComposition
>
> Data log collection

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiLogging.HmiDataLog)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiLogging.HmiDataLog)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create Method of HmiDataLog
- 📦 `Find(System.String)`: Find method of HmiDataLog
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiLoggingCommon.DeviceNode
>
> DeviceNode

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiLoggingCommon.HmiBackupMode
>
> HmiBackupMode

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiLoggingCommon.LogBackup
>
> Logging backup configuration

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
- 🔧 `BackupMode`: Defines the backup mode
- 🔧 `PrimaryPath`: Logging backup path
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiLoggingCommon.LogDuration
>
> Specifies the time period type

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
- 🔧 `Days`: Specifies number of days
- 🔧 `Hours`: Specifies number of hours
- 🔧 `Minutes`: Specifies minutes
- 🔧 `Seconds`: Specifies seconds
- 🔧 `Ticks`: Hundred Nonoseconds
- 📦 `GetDoubleLogDuration`: Return timeperiod in double
- 📦 `GetStringLogDuration`: Return Log Duration in String
- 📦 `SetLogDuration(System.UInt32,System.UInt32,System.UInt32,System.UInt32,System.UInt32)`: Set timeperiod in double
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiLoggingCommon.LogSegment
>
> Logging segment configuration

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
- 🔧 `SegmentMaxSize`: Defines the maximum size of a segment of the log on the storage medium in units of megabytes. When the value is set to 0, the size of the segment is not considered.
- 🔧 `SegmentStartTime`: Start time of the logging segment
- 🔧 `SegmentTimePeriod`: Segment Time Period
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiLoggingCommon.LogSettings
>
> Logging configuration

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
- 🔧 `LogMaxSize`: Maximum size of data storage in MB
- 🔧 `LogTimePeriod`: Log Time period
- 🔧 `StorageDevice`: StorageDevice
- 🔧 `StorageFolder`: Path for storage
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiLoggingCommon.LoggingBase
>
> Base class for Alarm and Data logging

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Backup`: Log backup
- 🔧 `Segment`: Log segment for backup
- 🔧 `Settings`: Logging settings
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.HmiLogging.HmiLoggingCommon.SegmentDuration
>
> Segment duration Class

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
- 🔧 `Days`: Days
- 🔧 `Hours`: Hours
- 🔧 `Minutes`: Minutes
- 🔧 `Seconds`: Seconds
- 🔧 `Ticks`: Hundred Nanoseconds
- 📦 `GetDoubleSegmentDuration`: Method for getting segment timeperiod
- 📦 `GetStringSegmentDuration`: Return Segment Duration in String
- 📦 `SetSegmentDuration(System.UInt32,System.UInt32,System.UInt32,System.UInt32,System.UInt32)`: Method for setting segment timeperiod
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

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

## 🛠️ Siemens.Engineering.HmiUnified.LoggingTags.HmiAggregationMode
>
> Hmi Aggregation Mode enum

## 🛠️ Siemens.Engineering.HmiUnified.LoggingTags.HmiLimitScope
>
> Defines the limit scope for the logging tag

## 🛠️ Siemens.Engineering.HmiUnified.LoggingTags.HmiLoggingMode
>
> Hmi Logging mode enum

## 🛠️ Siemens.Engineering.HmiUnified.LoggingTags.HmiLoggingTag
>
> Represents the LoggingTag

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
- 🔧 `AggregationDelay`: Compression Delay
- 🔧 `AggregationMode`: Compression Mode
- 🔧 `Cycle`: Logging Cycle
- 🔧 `CycleFactor`: Logging Cycle Factor
- 🔧 `DataLog`: Reference to the used data log configuration
- 🔧 `HighLimit`: Defines the Higher limit
- 🔧 `LimitScope`: LimitScope of Hmi Logging Tag
- 🔧 `LoggingMode`: Logging Mode
- 🔧 `LowLimit`: Defines the Lower limit
- 🔧 `Name`: Name of the Logging Tag
- 🔧 `SmoothingDeltaValue`: Smoothing delta value
- 🔧 `SmoothingMaxTime`: Smoothing max time
- 🔧 `SmoothingMinTime`: Smoothing min time
- 🔧 `SmoothingMode`: Smoothing mode of the logging tag
- 🔧 `Source`: Source Logging Tag
- 🔧 `TriggerMode`: TriggerMode property
- 🔧 `TriggerTag`: TriggerTag Value
- 🔧 `TriggerTagBitNumber`: TriggerTagBitNumber
- 📦 `Validate`: Validates the object
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.LoggingTags.HmiLoggingTagComposition
>
> Represensts Logging Tag Composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.LoggingTags.HmiLoggingTag)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.LoggingTags.HmiLoggingTag)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create method for Logging Tag
- 📦 `Find(System.String)`: Find method for Logging Tag
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.LoggingTags.HmiSmoothingMode
>
> Hmi Smoothing Mode

## 🛠️ Siemens.Engineering.HmiUnified.LoggingTags.HmiTriggerMode
>
> HmiTiggerMode enum
