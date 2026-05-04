# HMI Composition Hierarchy & Connections Reference

Source: V21 IntelliSense XML documentation — `Siemens.Engineering.WinCC.xml`

> C# only. Assembly: `Siemens.Engineering.WinCC.dll`

---

## 1. HmiTarget entry points

All HMI navigation starts from `HmiTarget`. Access it via `SoftwareContainer`:

```csharp
using Siemens.Engineering.Hmi;
using Siemens.Engineering.Hmi.Screen;
using Siemens.Engineering.Hmi.Tag;
using Siemens.Engineering.Hmi.Communication;
using Siemens.Engineering.Hmi.RuntimeScripting;
using Siemens.Engineering.Hmi.TextGraphicList;
using Siemens.Engineering.Hmi.Cycle;

SoftwareContainer sc = hmiDeviceItem.GetService<SoftwareContainer>();
HmiTarget hmiTarget = sc?.Software as HmiTarget;
```

### HmiTarget properties (composition entry points)

| Property | Type | Description |
| --- | --- | --- |
| `ScreenFolder` | `ScreenSystemFolder` | Root of screen hierarchy |
| `ScreenPopupFolder` | `ScreenPopupSystemFolder` | Root of popup screens |
| `ScreenSlideinFolder` | `ScreenSlideinSystemFolder` | Root of slide-in screens |
| `ScreenTemplateFolder` | `ScreenTemplateSystemFolder` | Root of screen templates |
| `ScreenGlobalElements` | `ScreenGlobalElements` | Global screen elements |
| `ScreenOverview` | `ScreenOverview` | Screen overview editor |
| `TagFolder` | `TagSystemFolder` | Root of HMI tag hierarchy |
| `VBScriptFolder` | `VBScriptSystemFolder` | Root of VB scripts |
| `Connections` | `ConnectionComposition` | PLC connections |
| `Cycles` | `CycleComposition` | Acquisition cycles |
| `TextLists` | `TextListComposition` | Text lists |
| `GraphicLists` | `GraphicListComposition` | Graphic lists |
| `Name` | string | HMI device name |
| `Author` | string | Author of the device |

---

## 2. Screen composition hierarchy

### Regular screens

```
HmiTarget.ScreenFolder (ScreenSystemFolder)
  └── Screens (ScreenComposition)
  │     └── Screen — individual screens
  └── Folders (ScreenUserFolderComposition)
        └── ScreenUserFolder
              └── Screens (ScreenComposition)
              └── Folders (ScreenUserFolderComposition) ← recursive
```

```csharp
ScreenSystemFolder root = hmiTarget.ScreenFolder;

// Create a user folder
ScreenUserFolder folder = root.Folders.Create("MyFolder");

// Create a screen in the root
Screen screen = root.Screens.Import(
    new FileInfo(@"C:\Export\MyScreen.xml"), ImportOptions.None);

// Enumerate all screens (non-recursive — current level only)
foreach (Screen s in root.Screens)
    Console.WriteLine(s.Name);

// Find a screen by name
Screen found = root.Screens.Find("MainScreen");

// Export a screen
found.Export(new FileInfo(@"C:\Export\MainScreen.xml"), ExportOptions.None);

// Delete a screen
found.Delete();
```

### Popup screens

```
HmiTarget.ScreenPopupFolder (ScreenPopupSystemFolder)
  └── ScreenPopups (ScreenPopupComposition)
  └── Folders (ScreenPopupUserFolderComposition)
        └── ScreenPopupUserFolder ← recursive
```

```csharp
ScreenPopupSystemFolder popupRoot = hmiTarget.ScreenPopupFolder;

foreach (ScreenPopup popup in popupRoot.ScreenPopups)
    Console.WriteLine($"Popup: {popup.Name}");

// Import, export, delete — same pattern as regular screens
popup.Export(new FileInfo(path), ExportOptions.None);
popup.Delete();
```

### Slide-in screens (V21)

```
HmiTarget.ScreenSlideinFolder (ScreenSlideinSystemFolder)
  └── ScreenSlideins (ScreenSlideinComposition)
```

```csharp
ScreenSlideinSystemFolder slideinRoot = hmiTarget.ScreenSlideinFolder;

foreach (ScreenSlidein slidein in slideinRoot.ScreenSlideins)
{
    Console.WriteLine($"Slide-in type: {slidein.SlideinType}");
    slidein.Export(new FileInfo(path), ExportOptions.None);
}
```

`SlideinType` values: defines the position/behaviour of the slide-in screen.

### Screen templates

```
HmiTarget.ScreenTemplateFolder (ScreenTemplateSystemFolder)
  └── ScreenTemplates (ScreenTemplateComposition)
  └── Folders (ScreenTemplateUserFolderComposition)
        └── ScreenTemplateUserFolder ← recursive
```

```csharp
ScreenTemplateSystemFolder templateRoot = hmiTarget.ScreenTemplateFolder;

foreach (ScreenTemplate tmpl in templateRoot.ScreenTemplates)
    Console.WriteLine($"Template: {tmpl.Name}");

tmpl.Export(new FileInfo(path), ExportOptions.None);
tmpl.Delete();
```

### Global elements and overview

```csharp
// Global elements — elements shared across all screens
ScreenGlobalElements globals = hmiTarget.ScreenGlobalElements;
globals.Export(new FileInfo(@"C:\Export\GlobalElements.xml"), ExportOptions.None);

// Screen overview — the overview editor
ScreenOverview overview = hmiTarget.ScreenOverview;
overview.Export(new FileInfo(@"C:\Export\Overview.xml"), ExportOptions.None);
```

---

## 3. Connections

HMI connections link the HMI device to PLC devices for tag communication.

```csharp
ConnectionComposition connections = hmiTarget.Connections;

foreach (Connection conn in connections)
{
    Console.WriteLine($"Connection: {conn.Name}");

    // Connections use attribute-based access for configuration
    string partner = (string)conn.GetAttribute("Partner");
    Console.WriteLine($"  Partner: {partner}");

    // Export a connection
    conn.Export(new FileInfo(path), ExportOptions.None);
}

// Delete a connection
connections.First().Delete();
```

Connections are primarily configured through `GetAttribute`/`SetAttribute`.

---

## 4. Attribute-based configuration

Classic WinCC screen objects (Screen, ScreenPopup, ScreenTemplate, Connection) use
the attribute-based access pattern for most of their properties. Visual properties
like colors, sizes, positions, and element configurations are accessed as attributes.

```csharp
// Read an attribute
object width = screen.GetAttribute("Width");
object height = screen.GetAttribute("Height");

// Write an attribute
screen.SetAttribute("BackColor", 0xFFFFFF);

// Read all available attributes
var infos = ((IEngineeringObject)screen).GetAttributeInfos();
foreach (var info in infos)
    Console.WriteLine($"  {info.Name} ({info.AccessMode})");

// Bulk read/write
var names = new List<string> { "Width", "Height", "BackColor" };
var values = ((IEngineeringObject)screen).GetAttributes(names);
```

For a list of available attributes per screen element type, use `GetAttributeInfos()`
at runtime or inspect the Simatic ML export XML files.

---

## 5. Screen element configuration enums

Screen elements are configured through attributes. When setting attribute values,
use the corresponding enum types from `Siemens.Engineering.Hmi.Screen`:

### Bar / Gauge elements

`BarOrientation`, `BarScalingType`, `BarSegmentColoring`, `BarScaleStart`,
`GaugeBorder3DStyle`, `GaugeFillStyle`

### Button / Switch elements

`ButtonType`, `SwitchType`, `SwitchDirection`

### IO Field elements

`IOFieldType`, `IOFieldDataFormat`, `GraphicIOFieldType`, `SymbolicIOFieldType`

### Clock elements

`ClockFillStyle`, `ClockNumberStyle`, `ClockTickStyle`, `NeedleFillStyle`

### Slider elements

`SliderBorder3DStyle`, `SliderFillStyle`, `SliderTickStyle`

### Trend / Chart elements

`TrendType`, `TrendLineType`, `TrendViewTimeAxisMode`, `TrendViewToolbarStyle`,
`DataSourceType`, `CurveOrientation`, `GraphDirection`, `TimeBase`, `TimeRangeMode`,
`AxisScalingType`, `AxisAlignment`, `AxisSide`, `RulerStyle`, `RulerLayer`

### Alarm view elements

`AlarmControlActions`, `AlarmControlTimeUnit`, `AlarmDisplayOptions`,
`AlarmListType`, `AlarmViewBasicMode`, `AlarmViewBasicSource`,
`AlarmViewBasicColumnId`, `AlarmWindowModes`

### Recipe view elements

`RecipeControlDataSourceType`, `RecipeViewBasicViewType`, `RecipeViewBasicEntryValuePos`

### Grid / Table elements

`GridSelectionType`, `GridSelectionBorder`, `GridSelectionColoring`,
`GridSortSequence`, `GridSortTrigger`, `GridHeaderStyle`,
`GridColumnHeaderHorizontalAlignment`, `SortMode`

### General visual properties

`FillStyle`, `LineStyle`, `LineEndStyle`, `CornerStyle`, `FlashingRate`,
`FlashingType`, `HorizontalAlignment`, `VerticalAlignment`, `TextOrientation`,
`PictureAlignment`, `PictureSizeMode`, `AutoSizingType`, `WinCCStyle`,
`PositionMode`, `WindowContent`, `WindowHeaderStyle`, `VisibilityModes`,
`TabSequence`, `TabObjectTypes`

### Dynamization enums (from `Siemens.Engineering.Hmi.Dynamic`)

`DynamicType`, `TriggerType`, `FlashingType`, `PropertyAnimationType`,
`BracketType`, `TagStatusEvaluationType`

---

## 6. Library types from screens

Screens and templates can be converted to library types:

| Type | Description |
| --- | --- |
| `ScreenLibraryType` | Library type created from a screen |
| `ScreenLibraryTypeVersion` | Specific version of a screen library type |
| `StyleLibraryType` | Library type created from a style |
| `StyleSheetLibraryType` | Library type created from a style sheet |
| `FaceplateLibraryType` | Library type created from a faceplate |
| `FaceplateLibraryTypeVersion` | Specific version of a faceplate library type |

## V21 API Reference: Enums, Alarms, Globalization, Faceplates, Recipes, Reports, Scheduler, Theming

## 🛠️ Siemens.Engineering.# V21 API Reference: Siemens.Engineering.Hmi

## 🛠️ Siemens.Engineering.Hmi.ConstValue
>
> Represents an constant value.

- 📦 `#ctor(System.Object)`: Constructor
- 🔧 `Value`: Gets or sets the value of the Siemens.Engineering.Hmi.ConstValue.
- 📦 `ToString`: Returns a String that represents the current Object.

## 🛠️ Siemens.Engineering.Hmi.ILimit
>
> Represents an object which can serve as a limit.

## 🛠️ Siemens.Engineering.Hmi.NullableDateTime
>
> Represents an instant in time, typically expressed as a date and time

- 📦 `#ctor(System.DateTime)`: Constructor
- 📦 `#ctor(System.DateTime,Siemens.Engineering.Hmi.DateTimeValues)`: Constructor
- 📦 `#ctor(Siemens.Engineering.Hmi.NullableDateTime)`: Constructor
- 📦 `#ctor(System.String)`: Constructor
- 🔧 `DateTimeValues`: The granularity of the wrapped <c>System.DateTime</c>.
- 🔧 `Year`: Year
- 🔧 `Month`: Month
- 🔧 `Day`: Day
- 🔧 `Hour`: Hour
- 🔧 `Minute`: Minute
- 🔧 `Second`: Second
- 📦 `op_Explicit(Siemens.Engineering.Hmi.NullableDateTime)~System.DateTime`: The convertion operator used to convert a <c>NullableDateTime</c> to a <c>System.DateTime</c>.
- 📦 `op_Equality(Siemens.Engineering.Hmi.NullableDateTime,Siemens.Engineering.Hmi.NullableDateTime)`: Indicates whether this objects are equal.
- 📦 `op_Inequality(Siemens.Engineering.Hmi.NullableDateTime,Siemens.Engineering.Hmi.NullableDateTime)`: Indicates whether this objects are not equal.
- 📦 `Equals(System.Object)`: Indicates whether this instance and a specified object are equal.
- 📦 `GetHashCode`: Returns the hash code for this instance.
- 📦 `ToString`: Converts the value of the current NullableDateTime object to its equivalent string representation.

## 🛠️ Siemens.Engineering.Hmi.DateTimeValues
>
> A value indicating the granularity of the data or time (eg. Year, Month, etc.).

## 🛠️ Siemens.Engineering.Hmi.Alarm.AlarmAcknowledgementModel
>
> Defines the available acknowledgment model.

## 🛠️ Siemens.Engineering.Hmi.Alarm.AlarmAlertAcknowledgement
>
> Alarm acknowledgment modes.

## 🛠️ Siemens.Engineering.Hmi.Alarm.AlarmBlockAlignment
>
> Defines the alignment of alarm block texts.

## 🛠️ Siemens.Engineering.Hmi.Alarm.AlarmDisplayClassId
>
> ID of the alarm display class.

## 🛠️ Siemens.Engineering.Hmi.Alarm.DeadbandMode
>
> Defines different modes when hysteresis will become active.

## 🛠️ Siemens.Engineering.Hmi.Alarm.DelayTimeUnit
>
> Defines different delay time units.

## 🛠️ Siemens.Engineering.Hmi.Alarm.LimitMode
>
> Defines for different trigger conditions.

## 🛠️ Siemens.Engineering.Hmi.Alarm.ProcessValueBlockId
>
> ID for selected process value blocks.

## 🛠️ Siemens.Engineering.Hmi.Alarm.SystemBlockDateFormat
>
> Date format for system blocks.

## 🛠️ Siemens.Engineering.Hmi.Alarm.SystemBlockDurationFormat
>
> Format of system block duration.

## 🛠️ Siemens.Engineering.Hmi.Alarm.SystemBlockId
>
> Definition of the system block ID.

## 🛠️ Siemens.Engineering.Hmi.Alarm.SystemBlockNumberFormat
>
> Format of system block numbers.

## 🛠️ Siemens.Engineering.Hmi.Alarm.SystemBlockTimeFormat
>
> Time format of system blocks.

## 🛠️ Siemens.Engineering.Hmi.Alarm.SystemEventTypes
>
> Definition of system event types.

## 🛠️ Siemens.Engineering.Hmi.Alarm.TriggerMode
>
> Defines trigger modes for discrete alarms.

## 🛠️ Siemens.Engineering.Hmi.Alarm.UserTextBlockId
>
> Definition of the user text block ID.

## 🛠️ Siemens.Engineering.Hmi.AppearanceAnalysisId
>
> The enum defines the different ways, how the bits are relevant for Animation appearance.

## 🛠️ Siemens.Engineering.Hmi.BitTextListsAnalysisId
>
> The enum defines the different ways, how the bits into the bit number text lists will be analysised for the specific device.

## 🛠️ Siemens.Engineering.Hmi.ColorDepthTypes
>
> The type for the color depth in settings editor

## 🛠️ Siemens.Engineering.Hmi.ControlFilterExpressionOperand
>

## 🛠️ Siemens.Engineering.Hmi.ControlFilterLogicalOperand
>

## 🛠️ Siemens.Engineering.Hmi.CursorBehaviourInTables
>
> Values for the CursorBehaviourInTablesTypes

## 🛠️ Siemens.Engineering.Hmi.FlashingRate
>
> Flash rate.

## 🛠️ Siemens.Engineering.Hmi.OPCServerType
>

## 🛠️ Siemens.Engineering.Hmi.PowerManagementValues
>
> This enum serves the values for Wireless devices power management settings

## 🛠️ Siemens.Engineering.Hmi.RefreshModes
>
> Enum for RefreshModes.

## 🛠️ Siemens.Engineering.Hmi.SynchronizationPeriod
>
> Values for SynchronizationPeriodTypes

## 🛠️ Siemens.Engineering.Hmi.WindowOpeningStyleType
>
> Window styles used in the Additional Tasks/Applications section in autostart.

## 🛠️ Siemens.Engineering.Hmi.Dynamic.BracketType
>
> Bracket type for the extended floating ranges of a PropertyAnimation

## 🛠️ Siemens.Engineering.Hmi.Dynamic.DynamicType
>
> Represents the dynamic type.

## 🛠️ Siemens.Engineering.Hmi.Dynamic.FlashingType
>
> Represents the type of flashing.

## 🛠️ Siemens.Engineering.Hmi.Dynamic.PropertyAnimationType
>
> The type of the process value in a property animation

## 🛠️ Siemens.Engineering.Hmi.Dynamic.TagStatusEvaluationType
>
> The type how the tag should be evaluated

## 🛠️ Siemens.Engineering.Hmi.Dynamic.TriggerType
>
> Represents the trigger type.

## 🛠️ Siemens.Engineering.Hmi.Event.FunctionListEntryType
>
> Specifies the constants which define the type of a function list entry.

## 🛠️ Siemens.Engineering.Hmi.Faceplate.FaceplateLibraryType
>
> A class representing a faceplate library type

- 🔧 `Name`: Name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Faceplate.FaceplateLibraryTypeVersion
>
> A class representing a faceplate version

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Faceplate.InterfacePropertyDirection
>
> direction of the interface property

## 🛠️ Siemens.Engineering.Hmi.Faceplate.ResizeRules
>
> rules how an instance of a screenmodule can be resized

## 🛠️ Siemens.Engineering.Hmi.Globalization.GraphicsProvider
>
> Graphics Provider

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
- 🔧 `Graphics`: Composition of graphics
- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Globalization.MultiLingualGraphic
>
> Represents a multilingual graphic object of the project

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
- 🔧 `Name`: The name of the multilingual graphic
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a multilingual graphic
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Globalization.MultiLingualGraphicComposition
>
> Composition of MultiLingualGraphics

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Globalization.MultiLingualGraphic)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Globalization.MultiLingualGraphic)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a multilingual graphic
- 📦 `Find(System.String)`: Finds a given multilingual graphic
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Logging.AcquisitionMode
>
> Acquisition modes available for logging tags.

## 🛠️ Siemens.Engineering.Hmi.Logging.AnalogProcessingMethod
>
> Defines the processing methods for logging tags whose source tag contains neither binary nor raw data.

## 🛠️ Siemens.Engineering.Hmi.Logging.BinaryProcessingMethod
>
> Defines the processing methods for logging tags whose source tag is binary.

## 🛠️ Siemens.Engineering.Hmi.Logging.CompressedProcessingMethod
>
> Defines the methods for processing compressed data logs.

## 🛠️ Siemens.Engineering.Hmi.Logging.CompressedTagProcessingMethod
>
> Defines the methods for processing compressed logging tags.

## 🛠️ Siemens.Engineering.Hmi.Logging.DataSourceMode
>
> Defines the available data source modes.

## 🛠️ Siemens.Engineering.Hmi.Logging.HysteresisMode
>
> Defines the available operating modes with hysteresis.

## 🛠️ Siemens.Engineering.Hmi.Logging.LimitScope
>
> Defines the scope of logging limiting.

## 🛠️ Siemens.Engineering.Hmi.Logging.LogHandlingAtRestart
>
> Specifies the restart mode of the data logs.

## 🛠️ Siemens.Engineering.Hmi.Logging.LoggingMethod
>
> Defines the available data logging methods.

## 🛠️ Siemens.Engineering.Hmi.Logging.LoggingSettingType
>
> Defines the available logging setting types.

## 🛠️ Siemens.Engineering.Hmi.Logging.SegmentSize
>
> Defines the available units for the segment size.

## 🛠️ Siemens.Engineering.Hmi.Logging.StorageLocation
>
> Defines the storage location the data logs.

## 🛠️ Siemens.Engineering.Hmi.Logging.StorageMediaForAudit
>
> Defines the storage format for Audit trail log

## 🛠️ Siemens.Engineering.Hmi.Logging.SupplyingTags
>
> Enum for SupplyingTags.

## 🛠️ Siemens.Engineering.Hmi.Logging.TimePeriod
>
> Defines the available units of the time period.

## 🛠️ Siemens.Engineering.Hmi.MenuToolbar.ButtonType
>
> Predefined toolbar button types.

## 🛠️ Siemens.Engineering.Hmi.MenuToolbar.PictureSize
>
> Size of the toolbar button icons.

## 🛠️ Siemens.Engineering.Hmi.MenuToolbar.ToolbarAlignment
>
> The toolbar is aligned relative to its sides in its parent window

## 🛠️ Siemens.Engineering.Hmi.Recipe.RecipeCommunicationType
>
> Specifies the communication type of a Recipe recipe.

## 🛠️ Siemens.Engineering.Hmi.Recipe.RecipeDataType
>
> Specifies the available data types in the Recipe subsystem.

## 🛠️ Siemens.Engineering.Hmi.Recipe.RecipeSizeType
>
> Specifies the size type of a Recipe recipe.

## 🛠️ Siemens.Engineering.Hmi.Recipe.StorageMedia
>
> values for the confirmation type

## 🛠️ Siemens.Engineering.Hmi.Report.AlarmBackStyle
>
> Specifies constants for the back style.

## 🛠️ Siemens.Engineering.Hmi.Report.AlarmBorderStyle
>
> Specifies the border style.

## 🛠️ Siemens.Engineering.Hmi.Report.AlarmSorting
>
> Specifies constants for the back style.

## 🛠️ Siemens.Engineering.Hmi.Report.AreaStyle
>
> Specifies the print area constants for the Siemens.Engineering.Hmi.Report.Hardcopy.

## 🛠️ Siemens.Engineering.Hmi.Report.AuditTrailBackStyle
>
> Specifies constants for the back style.

## 🛠️ Siemens.Engineering.Hmi.Report.AuditTrailBorderStyle
>
> Specifies the border style.

## 🛠️ Siemens.Engineering.Hmi.Report.ControlViewTextContent
>
> Specifies the content of a ScreenControlViewText.

## 🛠️ Siemens.Engineering.Hmi.Report.DialogType
>
> Specifies constants which define the type of dialog shown at the start of reporting (at runtime).

## 🛠️ Siemens.Engineering.Hmi.Report.PageFormat
>
> Specifies page format constants for the Siemens.Engineering.Hmi.Report.Report.

## 🛠️ Siemens.Engineering.Hmi.Report.PageOrientation
>
> Specifies page orientation constants for the Siemens.Engineering.Hmi.Report.Report.

## 🛠️ Siemens.Engineering.Hmi.Report.PageRangeType
>
> Specifies constants which define the type of page range for the Siemens.Engineering.Hmi.Report.PrintConfiguration.

## 🛠️ Siemens.Engineering.Hmi.Report.PrintConfigurationTimeRangeUnit
>
> Specifies constant values of the time range for the Siemens.Engineering.Hmi.Report.PrintConfiguration.

## 🛠️ Siemens.Engineering.Hmi.Report.RecipeBackStyle
>
> Specifies constants for the back style.

## 🛠️ Siemens.Engineering.Hmi.Report.RecipeBorderStyle
>
> Specifies the border style.

## 🛠️ Siemens.Engineering.Hmi.Report.RecipeColumnId
>
> Specifies constants for the alarm columns of the Siemens.Engineering.Hmi.Report.PrintRecipe.

## 🛠️ Siemens.Engineering.Hmi.Report.RecipeDrawMode
>
> Specifies constants for the drawing mode.

## 🛠️ Siemens.Engineering.Hmi.Report.RecipeRecipeSelection
>
> Specifies selection type for the recipe.

## 🛠️ Siemens.Engineering.Hmi.Report.RecipeRecordSelection
>
> Specifies selection type for the recipe records.

## 🛠️ Siemens.Engineering.Hmi.Report.ScreenControlViewType
>
> Specifies page format constants for the Siemens.Engineering.Hmi.Report.Report.

## 🛠️ Siemens.Engineering.Hmi.Report.TimeRangeType
>
> Specifies constants for the type of time range for the Siemens.Engineering.Hmi.Report.PrintConfiguration.

## 🛠️ Siemens.Engineering.Hmi.Report.UnitStyle
>
> Specifies the unit style constants for the Siemens.Engineering.Hmi.Report.Report.

## 🛠️ Siemens.Engineering.Hmi.RuntimeSecurity.TakeUserDataFromTypes
>
> enum for values to determine from where to take userdata

## 🛠️ Siemens.Engineering.Hmi.Scheduler.JobMode
>
> Mode of the job

## 🛠️ Siemens.Engineering.Hmi.Scheduler.JobType
>
> Defines the job type

## 🛠️ Siemens.Engineering.Hmi.Scheduler.Weekday
>
> Days of the week.

## 🛠️ Siemens.Engineering.Hmi.Theming.ButtonModes
>
> Possible values for button display mode

## 🛠️ Siemens.Engineering.Hmi.Theming.ClockModes
>
> Possible values for clock and display intrument display mode

## 🛠️ Siemens.Engineering.Hmi.Theming.HoveringTypes
>
> Possible values for hovering settings

## 🛠️ Siemens.Engineering.Hmi.Theming.MenuToolbarModes
>
> Possible values for menu and toolbar display mode

## 🛠️ Siemens.Engineering.Hmi.Theming.RTControlModes
>
> Possible values for RT control display mode

## 🛠️ Siemens.Engineering.Hmi.Theming.RoundButtonModes
>
> Possible values for round button display mode

## 🛠️ Siemens.Engineering.Hmi.Theming.SliderModes
>
> Possible values for slider display mode
