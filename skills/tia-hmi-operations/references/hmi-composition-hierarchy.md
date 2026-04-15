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
