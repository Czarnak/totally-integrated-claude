# WinCC Unified — Screens & Screen Elements

Source: V21 IntelliSense XML — `Siemens.Engineering.WinCCUnified.xml`

> Assembly: `Siemens.Engineering.WinCCUnified.dll`

---

## 1. Screen hierarchy

```
HmiSoftware
  ├── Screens (HmiScreenComposition)
  └── ScreenGroups (HmiScreenGroupComposition)
        └── HmiScreenGroup
              ├── Screens (HmiScreenComposition)
              └── Groups (HmiScreenGroupComposition) ← recursive
```

### Create and manage screens

```csharp
using Siemens.Engineering.HmiUnified.UI.Screens;
using Siemens.Engineering.HmiUnified.UI.ScreenGroup;

// Create a screen
HmiScreen screen = hmiSoftware.Screens.Create("MainScreen");

// Configure screen properties
screen.Width = 1920;
screen.Height = 1080;
screen.BackColor = 0xFF333333;   // ARGB
screen.Enabled = true;
screen.ScreenNumber = 1;

// Resize to match device display
screen.ResizeScreen();

// Create screen groups (folders)
HmiScreenGroup group = hmiSoftware.ScreenGroups.Create("Process_Screens");
HmiScreenGroup subGroup = group.Groups.Create("Line_1");

// Screens inside a group
HmiScreen groupedScreen = group.Screens.Create("Overview");

// Find
HmiScreen found = hmiSoftware.Screens.Find("MainScreen");
HmiScreenGroup foundGroup = hmiSoftware.ScreenGroups.Find("Process_Screens");

// Delete
found?.Delete();
foundGroup?.Delete();
```

### HmiScreen properties

| Property | Type | Description |
| --- | --- | --- |
| `Width` | int | Width in DIU (device-independent units) |
| `Height` | int | Height in DIU |
| `BackColor` | uint | Primary background colour (ARGB) |
| `AlternateBackColor` | uint | Secondary colour for fill patterns |
| `BackFillPattern` | — | Background fill pattern |
| `BackGraphic` | string | Background graphic path |
| `BackGraphicStretchMode` | `HmiGraphicStretchMode` | How background stretches |
| `BackgroundFillMode` | `HmiBackgroundFillMode` | Fill scope (screen or window) |
| `Enabled` | bool | Operable at runtime |
| `ScreenNumber` | int | Configured screen number |
| `HorizontalAlignment` | `HmiHorizontalAlignment` | Alignment in parent window |
| `VerticalAlignment` | `HmiVerticalAlignment` | Alignment in parent window |
| `ScreenItems` | `HmiScreenItemBaseComposition` | Screen items on this screen |
| `EventHandlers` | `HmiScreenEventHandlerComposition` | Screen event handlers |

### Screen windows (screen-in-screen)

```csharp
// HmiScreenWindow provides screen-in-screen functionality
// Create via screen items composition
HmiScreenWindow sw = (HmiScreenWindow)screen.ScreenItems.Create("ScreenWindow_1");
```

---

## 2. Screen items — creating and finding

All screen items are accessed through `HmiScreen.ScreenItems`:

```csharp
using Siemens.Engineering.HmiUnified.UI.Base;
using Siemens.Engineering.HmiUnified.UI.Shapes;
using Siemens.Engineering.HmiUnified.UI.Widgets;
using Siemens.Engineering.HmiUnified.UI.Controls;

HmiScreenItemBaseComposition items = screen.ScreenItems;

// Create a screen item by type name
HmiScreenItemBase item = items.Create("HmiButton");

// Create a custom container
HmiScreenItemBase custom = items.CreateCustomContainer("MyFaceplate");

// Find by name
HmiScreenItemBase found = items.Find("Button_1");

// Enumerate
foreach (HmiScreenItemBase si in items)
{
    Console.WriteLine($"{si.GetType().Name}: {si}");
}

// Cast to specific type for type-specific properties
if (found is HmiButton button)
{
    // Access button-specific properties via GetAttribute/SetAttribute
}
```

---

## 3. Shapes (20 types)

Basic geometric shapes. All inherit from `HmiShapeBase`.

| Type | Description | Base class |
| --- | --- | --- |
| `HmiRectangle` | Fillable rectangle | `HmiSurfaceShapeBase` |
| `HmiCircle` | Fillable circle | `HmiCircularShapeBase` |
| `HmiEllipse` | Fillable ellipse | `HmiEllipticalShapeBase` |
| `HmiCircleSegment` | Fillable circle segment (pie) | `HmiCircularShapeBase` |
| `HmiEllipseSegment` | Fillable ellipse segment | `HmiEllipticalShapeBase` |
| `HmiPolygon` | Fillable polygon | `HmiPointBasedShapeBase` |
| `HmiLine` | Line | `HmiShapeBase` |
| `HmiPolyline` | Multi-segment line | `HmiPointBasedShapeBase` |
| `HmiCircularArc` | Arc on circle | `HmiCircularShapeBase` |
| `HmiEllipticalArc` | Arc on ellipse | `HmiEllipticalShapeBase` |
| `HmiText` | Text without border/background | `HmiSimpleScreenItemBase` |
| `HmiGraphicView` | Graphic image display | `HmiSimpleScreenItemBase` |

Shape hierarchy:

```
HmiShapeBase
  ├── HmiCentricShapeBase
  │     ├── HmiCircularShapeBase → HmiCircle, HmiCircleSegment, HmiCircularArc
  │     └── HmiEllipticalShapeBase → HmiEllipse, HmiEllipseSegment, HmiEllipticalArc
  ├── HmiSurfaceShapeBase → HmiRectangle
  ├── HmiPointBasedShapeBase → HmiPolygon, HmiPolyline
  └── HmiLine
```

Polygon/polyline points managed via `HmiPointComposition` of `HmiPoint` (X/Y coordinates).

---

## 4. Widgets (19 types)

Interactive elements. All inherit from `HmiWidgetBase`.

| Type | Description | Classic equivalent |
|---|---|---|
| `HmiButton` | Push button (no state) | Button |
| `HmiIOField` | Input/output field | IOField |
| `HmiSymbolicIOField` | Symbolic/graphic IO | SymbolicIOField + GraphicIOField |
| `HmiBar` | Bar indicator | Bar |
| `HmiGauge` | Gauge/meter | Gauge |
| `HmiSlider` | Slider control | Slider |
| `HmiClock` | Clock (analog/digital) | Clock |
| `HmiTextBox` | Multi-line text input/output | — |
| `HmiLabel` | Text label (no interaction) | — |
| `HmiListBox` | List selection | — |
| `HmiCheckBoxGroup` | Checkbox group | — |
| `HmiRadioButtonGroup` | Radio button group | — |
| `HmiToggleSwitch` | Toggle switch | Switch (Classic) |
| `HmiTouchArea` | Invisible touch area | — |
| `HmiAlarmIndicator` | Alarm state indicator | — |

Widget hierarchy:

```
HmiWidgetBase
  ├── HmiTextWidgetBase → HmiLabel, HmiTextBox
  ├── HmiScaleWidgetBase → HmiBar, HmiGauge, HmiSlider
  ├── HmiSelectionGroupBase → HmiCheckBoxGroup, HmiRadioButtonGroup
  ├── HmiButton, HmiIOField, HmiSymbolicIOField, HmiClock
  ├── HmiListBox, HmiToggleSwitch, HmiTouchArea, HmiAlarmIndicator
  └── HmiListBox
```

---

## 5. Controls (15 types)

Advanced controls with data grids, trends, etc. All inherit from `HmiControlWindowBase`.

| Type | Description |
| --- | --- |
| `HmiAlarmControl` | Full alarm display (active + pending) |
| `HmiAlarmLineControl` | Simplified alarm line (1-3 alarms) |
| `HmiTrendControl` | Online/offline trend display |
| `HmiFunctionTrendControl` | Function-based trend display |
| `HmiTrendCompanion` | Ruler view for trends (was `HmiRulerView` in Classic) |
| `HmiDetailedParameterControl` | Parameter management (successor of Classic RecipeView) |
| `HmiProcessControl` | Process management control |
| `HmiMediaControl` | Media player |
| `HmiWebControl` | Web browser content |
| `HmiFaceplateContainer` | Faceplate instance |
| `HmiSystemDiagnosisControl` | Device diagnostic information |
| `HmiProcessDiagnosisOverviewControl` | Process diagnosis overview |
| `HmiProcessDiagnosisGraphOverviewControl` | Process diagnosis graph |
| `HmiProcessDiagnosisCriteriaAnalysisControl` | Criteria analysis |
| `HmiProcessDiagnosisPlcCodeViewerControl` | PLC code viewer |

---

## 6. Dynamization

Dynamic behaviour applied to screen item properties.

```csharp
using Siemens.Engineering.HmiUnified.UI.Dynamization;
using Siemens.Engineering.HmiUnified.UI.Dynamization.Tag;
using Siemens.Engineering.HmiUnified.UI.Dynamization.Script;
using Siemens.Engineering.HmiUnified.UI.Dynamization.Flashing;
```

### Dynamization types

| Type | Description |
| --- | --- |
| `TagDynamization` | Property driven by tag value |
| `TagParameterDynamization` | Tag parameter-driven |
| `ExpressionDynamization` | Expression-based |
| `ScriptDynamization` | Script-driven |
| `ResourceListDynamization` | Resource list-driven |
| `FlashingDynamization` | Flashing behaviour |

### Tag dynamization — mapping tables

Map tag values to visual property values:

| Type | Description |
| --- | --- |
| `MappingTable` | Collection of mapping entries |
| `MappingTableEntrySimple` | Direct value → property mapping |
| `MappingTableEntryRange` | Range of values → property mapping |
| `MappingTableEntryBitmask` | Bit pattern → property mapping |
| `ValueConverter` | Value conversion for tag dynamization |

Enums: `ConditionType`, `RangeType`, `BitDynamizationType`

### Script dynamization

| Type | Description |
| --- | --- |
| `ScriptDynamization` | Script-driven property change |
| `Trigger` | Trigger condition |
| `TriggerType` | `OnChange`, `Cyclic`, etc. |
| `IHmiScript` | Script interface |

### Flashing

| Type | Description |
| --- | --- |
| `FlashingDynamization` | Flashing animation |
| `FlashingCondition` | Condition for flashing |
| `FlashingRate` | Flashing speed |

---

## 7. Screen item parts (sub-components)

Complex controls use **parts** for internal configuration. Key part types:

### Trend parts

`HmiTrendPart`, `HmiTrendAreaPart`, `HmiTimeAxisPart`, `HmiXValueAxisPart`,
`HmiYValueAxisPart`, `HmiRulerPart`, `HmiLegendPart`, `HmiHelpLinePart`,
`HmiFunctionTrendPart`, `HmiFunctionTrendAreaPart`

### Control bar parts

`HmiToolBarPart`, `HmiStatusBarPart`, `HmiControlBarButtonPart`,
`HmiControlBarLabelPart`, `HmiControlBarTextBoxPart`,
`HmiControlBarSeparatorPart`, `HmiControlBarToggleSwitchPart`

### Data grid parts

`HmiDataGridViewPart`, `HmiDataGridColumnPart`, `HmiDataGridColumnHeaderPart`,
`HmiDataGridHeaderSettingsPart`

### Alarm/diagnostic column parts

`HmiAlarmColumnPart`, `HmiAlarmLineColumnPart`, `HmiAlarmLineViewPart`,
`HmiSystemDiagnosisControlColumnPart`, `HmiGraphOverviewControlColumnPart`

### Visual parts

`HmiFontPart`, `HmiCornersPart`, `HmiPaddingPart`, `HmiContentPart`,
`HmiTextPart`, `HmiInputBehaviorPart`, `HmiScalePartBase`,
`HmiCurvedScalePart`, `HmiStraightScalePart`, `HmiLinearMovementPart`,
`HmiThresholdPart`, `HmiQualityPart`

### Faceplate/custom parts

`HmiFaceplateInterface`, `HmiFaceplateInterfaceComposition`,
`HmiCustomControlInterface`, `HmiCustomControlInterfaceComposition`

---

## 8. Event handlers

Every screen item type has a matching event handler pair:

```csharp
using Siemens.Engineering.HmiUnified.UI.Events;

// Access event handlers on a screen
HmiScreenEventHandlerComposition screenEvents = screen.EventHandlers;

// Event types per screen item (examples)
// HmiButtonEventType, HmiScreenEventType, HmiIOFieldEventType, etc.
// Each has a Handler + HandlerComposition type
```

48 screen item types × 2 (handler + composition) = 97 event types total.
Pattern: `Hmi{ItemType}EventHandler` + `Hmi{ItemType}EventHandlerComposition`.
Plus `PropertyEventHandler` / `PropertyEventHandlerComposition` for generic property events.

---

## 9. Feature interfaces

Unified uses feature interfaces for shared capabilities across screen items:

| Interface | Description |
| --- | --- |
| `IHmiBoxFeature` | Bounding box (position, size) |
| `IHmiLineFeature` | Start/end points for line shapes |
| `IHmiAreaFeature` | Fill properties for fillable shapes |
| `IHmiArcFeature` | Arc geometry |
| `IHmiRotationFeature` | Rotation properties |
| `IHmiScaleFeature` | Scaling properties |
| `IHmiOperabilityFeature` | Enable/disable |
| `IHmiIdentifierFeature` | Object identifier |
| `IHmiBasicScreenFeature` | Shared screen properties |
| `IHmiBasicScreenItemFeature` | Shared screen item properties |
| `IHmiScreenWindowFeature` | Screen window properties |
| `IHmiWindowFeature` | Window display properties |
| `IHmiTimeRangeFeature` | Time range configuration |
| `IHmiMeasurementUnitFeature` | Measurement units |
| `IHmiAxisFeature` | Axis properties for trends |

Check interface support via `is` pattern matching:

```csharp
if (screenItem is IHmiBoxFeature box)
{
    // Access position/size properties
}
```
