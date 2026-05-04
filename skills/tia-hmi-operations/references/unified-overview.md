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

## V21 API Reference: HmiSoftware & Common

## 🛠️ Siemens.Engineering.HmiUnified.Common.HmiBase
>
> This class hold the common properties of AlarmClass, AnalogAlarm, DiscretAlarm

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
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: Name of the object
- 📦 `Validate`: Validates the HmiUnified object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.Common.HmiGroupBase
>
> Base class of user group

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
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.Common.HmiValidationResult
>
> Error object that notifies the errors associated with a particular property

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
- 🔧 `Errors`: Errors associated with the property
- 🔧 `PropertyName`: Name of the property
- 🔧 `Warnings`: Warnings associated with the property
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.Common.IChromDataExchangeExport
>
> IChromDataExchangeExport Interface

- 📦 `Export(System.IO.DirectoryInfo)`: Export script module
- 📦 `Export(System.IO.DirectoryInfo,System.String)`: Export script module under a different file name

## 🛠️ Siemens.Engineering.HmiUnified.Common.IValidator
>
> Validates the object

- 📦 `Validate`: Validates the object

## 🛠️ Siemens.Engineering.HmiUnified.Common.ImportResult
>
> Result of an import operation

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
- 🔧 `CreatedObject`: Reflects the created objects
- 🔧 `Documents`: The list of documents used for creation
- 🔧 `Messages`: The messages during the import operation
- 🔧 `State`: Reflects the state of the operation
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.Common.ResultState
>
> Result state of an import or export operation

## 🛠️ Siemens.Engineering.HmiUnified.HmiSoftware
>
> Represents the software components of a Hmi

- 🔧 `AlarmClasses`: AlarmClasses collection
- 🔧 `AlarmLogs`: Specifies HmiAlarmLog collection
- 🔧 `AnalogAlarms`: AnalogAlarm collection
- 🔧 `AuditTrails`: Specifies HmiAuditTrail collection
- 🔧 `Connections`: HmiConnection Collection
- 🔧 `DataLogs`: Specifies HmiDataLog collection
- 🔧 `DiscreteAlarms`: DiscreteAlarms collection
- 🔧 `HmiAlarmAuditClass`: Hmi Alarm Audit Class collecttion
- 🔧 `HmiGraphicLists`: HmiGraphicList Composition
- 🔧 `HmiSystemTextLists`: HmiSystemTextList Composition
- 🔧 `HmiTextLists`: HmiTextList Composition
- 🔧 `OpcUaAlarmTypes`: OpcUaAlarmTypes collection
- 🔧 `PlantObjectTags`: Plant object tags
- 🔧 `ScreenGroups`: ScreenGroupComposition
- 🔧 `Screens`: HmiScreen compostition
- 🔧 `Scripts`: Represents the HmiScripts
- 🔧 `SystemTags`: Hmi system tag collection
- 🔧 `TagTableGroups`: TagGroupComposition
- 🔧 `TagTables`: Hmi tagtables
- 🔧 `Tags`: Hmi tag collection
- 🔧 `RuntimeSettings`: Runtime settings of the hmi device
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
