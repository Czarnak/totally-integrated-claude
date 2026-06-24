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

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObject
>
> Plant object

- 🔧 `PlantObjectInterfaces`: Plant object interface members
- 🔧 `Type`: Plant object type

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectInterface
>
> Plant object interface

- 🔧 `Comment`: Get/set comment of interface
- 🔧 `Members`: Members of the plant object interface
- 🔧 `AccessMode`: Plant object interface access mode
- 🔧 `AcquisitionCycle`: The Acquisition cycle attribute
- 🔧 `AcquisitionMode`: Plant object interface AcquisitionMode
- 🔧 `Connection`: The Hmi Connection
- 🔧 `DataType`: Data type of the Plant object interface
- 🔧 `HmiDataType`: Hmi data type
- 🔧 `MaxLength`: Plant object interface Data type length
- 🔧 `Name`: Name of Plant object interface
- 🔧 `Persistent`: The Persistence attribute
- 🔧 `PlcName`: The Plc Name Attribute
- 🔧 `PlcTag`: The Plc Tag attribute
- 📦 `Validate`: Validates the object

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectInterfaceComposition
>
> Collection of Plant object interfaces

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.Cpm.PlantObjectInterface)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.Cpm.PlantObjectInterface)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds plant object interface

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectInterfaceMember
>
> Plant object interface member

- 🔧 `Comment`: Get/set comment of interface member
- 🔧 `LoggingTags`: Plant object logging tag collection
- 🔧 `Members`: Members of the plant object interface member
- 🔧 `DataType`: DataType of the Plant object interface member
- 🔧 `HmiDataType`: Hmi data type
- 🔧 `InitialMaxValue`: Upper limit
- 🔧 `InitialMinValue`: Lower limit
- 🔧 `InitialValue`: Initial value attribute
- 🔧 `MaxLength`: Plant object interface member DataTypeLength
- 🔧 `Name`: Name of Plant object interface member
- 🔧 `SubstituteValue`: The SubstituteValue
- 📦 `Validate`: Validates the object

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectInterfaceMemberComposition
>
> Collection of Plant object interface members

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.Cpm.PlantObjectInterfaceMember)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.Cpm.PlantObjectInterfaceMember)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds plant object interface member

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectLoggingTag
>
> Represents the plant object logging tag

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

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectLoggingTagAggregationMode
>
> PlantObject LoggingTag Aggregation Mode enum

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectLoggingTagComposition
>
> Represents plant object logging tag composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.Cpm.PlantObjectLoggingTag)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.Cpm.PlantObjectLoggingTag)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Find method for plant object logging tag

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectLoggingTagLimitScope
>
> Defines the limit scope for the plant object logging tag

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectLoggingTagLoggingMode
>
> Plant object Logging mode enum

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectLoggingTagSmoothingMode
>
> Plant object logging tag smoothing mode

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectLoggingTagTriggerMode
>
> PlantObject LoggingTag TriggerMode

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectTagAccessMode
>
> Plant object tag access mode

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectTagAcquisitionMode
>
> AcquisitionMode of plant object tag

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectTagLimitValueType
>
> plant object tag limit value type

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectTagLowerRange
>
> Lower limit range

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectTagRange
>
> To set value range

- 🔧 `Value`: Value of upper/lower
- 🔧 `ValueType`: Get and set Vlaue type

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectTagSubstituteValue
>
> Plant object tag substitute value

- 🔧 `SubstituteValueUsage`: Get or set substitute value
- 🔧 `Value`: Get and set substitute value

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectTagSubstituteValueUsage
>
> Plant object tag substitute value usage

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantObjectTagUpperRange
>
> Range for limit high

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantView
>
> Plant View

- 🔧 `PlantViewNodes`: Collection of PlantViewNodes
- 🔧 `AssignedHmiDevice`: Assigned hmi device
- 🔧 `Name`: Name of the plant view
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantViewComposition
>
> Plant View composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.Cpm.PlantView)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.Cpm.PlantView)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `FindPlantViewNode(System.String)`: Finds the view node by hierarchy path
- 📦 `Create(System.String)`: Creates the view
- 📦 `Find(System.String)`: Finds view

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantViewNode
>
> View node

- 🔧 `PlantViewNodes`: Collection of PlantViewNodes
- 🔧 `Name`: Name of the plant view node
- 🔧 `PlantObject`: Plant object
- 🔧 `PlantView`: PlantView of the node
- 🔧 `ViewPath`: Path of the node in the hierarchy
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantViewNodeComposition
>
> View node composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.Cpm.PlantViewNode)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.Cpm.PlantViewNode)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Creates view node
- 📦 `Create(System.String,System.String)`: Creates a view node with plant object
- 📦 `Find(System.String)`: Finds view node

## 🛠️ Siemens.Engineering.HmiUnified.Cpm.PlantViewsProvider
>
> Plant Views Provider

- 🔧 `PlantViews`: PlantViews

## 8. Library

## 🛠️ Siemens.Engineering.HmiUnified.Library.ScriptModuleType
>
> LibraryType for UnifiedTypes in Library
