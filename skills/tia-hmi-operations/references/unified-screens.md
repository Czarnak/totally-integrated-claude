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

## V21 API Reference: Unified Screens & UI Elements

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiCompanionBase
>
> Migration hint: Was called RulerView in Classic

- 🔧 `Parent`: EOM parent of this object
- 🔧 `SnapToSourceControl`: Specifies whether the TrendCompanion snaps to the window of the associated TrendControls
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiContainerBase
>
> Container base

- 🔧 `Parent`: EOM parent of this object
- 🔧 `ContainedType`: Contained type
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiControlWindowBase
>
> Base class for all controls that can be shown within a window

- 🔧 `Parent`: EOM parent of this object
- 🔧 `BackColor`: Specifies the background color
- 🔧 `StatusBar`: Returns the StatusBar object
- 🔧 `ToolBar`: Returns the ToolBar object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiCustomWebControlContainer
>
> HmiCustomWebControlContainer

- 🔧 `EventHandlers`: Events for HmiCustomWebControlContainer
- 🔧 `Interface`: Interface properties Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Authorization`: Specifies access control for the screen item
- 🔧 `RequireExplicitUnlock`: If set to true, the screen item configured within the screen (or a parent screen if not configured locally) enables the screen item only when the release button while the button is pressed
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiCustomWidgetContainer
>
> HmiCustomWidgetContainer

- 🔧 `EventHandlers`: Events for HmiCustomWidgetContainer
- 🔧 `Interface`: Interface properties Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Height`: in DIU
- 🔧 `Left`: Coordinates in DIU
- 🔧 `LinearMovement`: Adjust linear movement settings
- 🔧 `RotationAngle`: Specifies the rotation angle of the screen item in degree
- 🔧 `RotationCenterPlacement`: Specifies the RotationCenterPlacement works
- 🔧 `RotationCenterX`: Specifies the X coordinate of the rotation point
- 🔧 `RotationCenterY`: Specifies the Y coordinate of the rotation point
- 🔧 `Top`: Coordinates in DIU
- 🔧 `VisualizeQuality`: Visualize Quality
- 🔧 `Width`: in DIU
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiScreenBase
>
> This is the base class used by screens and screen templates

- 🔧 `Parent`: EOM parent of this object
- 🔧 `DisplayName`: Specifies display name propoerty of the screen
- 🔧 `Name`: Specifies name of the screen.
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiScreenItemBase
>
> Base class for all screen items that can be configured within a screen

- 🔧 `Parent`: EOM parent of this object
- 🔧 `CurrentQuality`: Read-Only property to summarize the current quality of the complete screen item
- 🔧 `Enabled`: Specifes whether the specified object can be operated in runtime.
- 🔧 `Name`: Configured name of the screen item
- 🔧 `ShowFocusVisual`: With this Property, screen items can be configured to show no focus rect even if they have focus
- 🔧 `StyleItemClass`: Specifies the style which is applied to the object
- 🔧 `TabIndex`: Screen items specifying a tab index of 0 are not part of the tab order
- 🔧 `Visible`: Specifies the visiblity of screen item.
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiScreenItemBaseComposition
>
> HmiScreenItemBaseComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Base.HmiScreenItemBase)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Base.HmiScreenItemBase)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create``1(System.String)`: Create new object
- 📦 `Create``1(System.String,System.String)`: Create new custom container object
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiSimpleScreenItemBase
>
> This base class is used for all simple screen items, which are all shapes and widgets but no advanced controls

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Authorization`: Specifies access control for the screen item
- 🔧 `Opacity`: Specifies the opacity of the object values ranging (0 to 1)
- 🔧 `RequireExplicitUnlock`: If set to true, the screen item configured within the screen (or a parent screen if not configured locally) enables the screen item only when the release button while the button is pressed
- 🔧 `ToolTipText`: Specifies ToolTipText
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiTrendControlBase
>
> Migration hint: Combines HmiFunctionTrend and HmiOnlineTrend functionality

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AreaSpacing`: The space between TrendAreas
- 🔧 `ExtendRulerToAxis`: Specifies whether extend ruler to axis.
- 🔧 `Legend`: Specifies legend of the trendcontrol.
- 🔧 `Online`: Online = Diagram is updated with new values, Offline = Diagram is frozen, no new values are added
- 🔧 `ShiftAxes`: TODO: Description needs to updated
- 🔧 `ShowRuler`: Specify whether to show ruler
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Base.HmiWindowBase
>
> Base class for anything that is potentially displayed within a window, such as screen windows or advanced controls

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Caption`: Text to be shown in the caption of a screen window or windowed control
- 🔧 `CaptionColor`: Specifies the color of the Caption
- 🔧 `Height`: Specifies height of the control window
- 🔧 `Icon`: specifies the icon on the control window
- 🔧 `Left`: Specifies the value of the X coordinates of control window
- 🔧 `Top`: Specifies the value of the Y coordinates of control window
- 🔧 `Width`: Specifies the width of the control window
- 🔧 `WindowFlags`: Specifies the window configuration like ShowCaption, ShowBorder, AlwaysOnTop.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiAlarmControl
>
> Control to display active pending alarms from the alarm service

- 🔧 `EventHandlers`: Events for HmiAlarmControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `AcknowledgmentFlashingRate`: Defines the flashing rate for alarms which have to be acknowledged
- 🔧 `ActiveAlarmsViewSetup`: Only considered with source type &quot;ActiveAlarms&quot;
- 🔧 `AlarmDefinitionViewSetup`: Only considered with source type &quot;AlarmDefinition&quot;
- 🔧 `AlarmSourceType`: Specifies the source of the alarms of the alarm window
- 🔧 `AlarmStatisticsView`: Accepts only columns of type HmiAlarmStatisticsColumnPart
- 🔧 `AlarmView`: Accepts only columns of type HmiAlarmColumnPart
- 🔧 `AlwaysShowRecent`: Migration hint: Was &quot;AutoScroll&quot; in Classic
- 🔧 `DefaultSortDirection`: If none of the Columns has a sort criteria, the DefaultSortDirection of the control is applied to the time column
- 🔧 `Filter`: The specification of the filter syntax is defined in SDS CHROM General (please refer to &quot;Query Language&quot; chapter 4
- 🔧 `ResetFlashingRate`: Defines the flashing rate for alarms which have to be reset
- 🔧 `SuppressFlashing`: Supresses any flashing at control level
- 🔧 `TimeZone`: Positive numbers according to the Microsoft time zone index value specification, negative numbers from CHROM (-1 = RH local)
- 🔧 `UseAlarmColors`: Specifies whether the configured color of the alarm is used
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiAlarmLineControl
>
> Simplified alarm control to show 1-3 most recent alarms.

- 🔧 `EventHandlers`: Events for HmiAlarmLineControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `AcknowledgmentFlashingRate`: Defines the flashing rate for alarms which have to be acknowledged
- 🔧 `ActiveAlarmsViewSetup`: Only considered with source type &quot;ActiveAlarms&quot;
- 🔧 `AlarmLineView`: Accepts only columns of type HmiAlarmColumnPart
- 🔧 `AlternateBackColor`: Specifies the AlternateBackColor
- 🔧 `AlternateBorderColor`: Specifies the AlternateBorderColor
- 🔧 `BackColor`: Specifies BackColor
- 🔧 `BorderColor`: Specifies BorderColor
- 🔧 `BorderWidth`: Specifes border width
- 🔧 `DefaultSortDirection`: If none of the Columns has a sort criteria, the DefaultSortDirection of the control is applied to the time column
- 🔧 `Filter`: The specification of the filter syntax is defined in SDS CHROM General (please refer to &quot;Query Language&quot; chapter 4
- 🔧 `Height`: Specifies the height of the control
- 🔧 `Left`: Specifies the value of the X coordinate
- 🔧 `NumberOfRows`: Specifies the number of alarm lines shown in the control.
- 🔧 `ResetFlashingRate`: Defines the flashing rate for alarms which have to be reset
- 🔧 `SuppressFlashing`: Supresses any flashing at control level
- 🔧 `TimeZone`: Positive numbers according to the Microsoft time zone index value specification, negative numbers from CHROM (-1 = RH local)
- 🔧 `Top`: Specifies the value of the Y coordinate
- 🔧 `UseAlarmColors`: Specifies whether the configured color of the alarm is used
- 🔧 `VisualizeQuality`: Specifies whether the quality of the process value is displayed
- 🔧 `Width`: Specifies the width of the control
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiDetailedParameterControl
>
> Screenitem for managing ParameterControl (successor of classic Panel RecipeView)

- 🔧 `EventHandlers`: Events for HmiDetailedParameterControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `EditMode`: Specifies the type of table editing
- 🔧 `Font`: Specifies the font of the text
- 🔧 `ForeColor`: Specifies the font color
- 🔧 `HideDetails`: By enabling this property, the visibility of table can be controlled to make sure data is displayed only to authorised user
- 🔧 `ParameterSetTypeFixed`: If configured, the control won&apos;t allow changing the parameter set type
- 🔧 `ParameterView`: Accepts only columns of type HmiDetailedParameterControlColumnPart
- 🔧 `SelectionBackColor`: Specifies the background color of the selected cells
- 🔧 `SelectionForeColor`: Specifies the foreground color of the selected cells
- 🔧 `TimeZone`: Positive numbers according to the Microsoft time zone index value specification, negative numbers from CHROM (-1 = RH local)
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiFaceplateContainer
>
> Faceplate concept according to SDS CHROM 30 Screens

- 🔧 `EventHandlers`: Events for HmiFaceplateContainer
- 🔧 `Interface`: Interface properties Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Adaption`: Specifies whether the faceplate or container window shall adapt its size
- 🔧 `InteractivePanning`: Specifies the interactive panning
- 🔧 `LinearMovement`: Adjust linear movement settings
- 🔧 `RotationAngle`: Specifies the rotation angle of the screen item in degree
- 🔧 `RotationCenterPlacement`: Specifies the RotationCenterPlacement works
- 🔧 `RotationCenterX`: Specifies the X coordinate of the rotation point
- 🔧 `RotationCenterY`: Specifies the Y coordinate of the rotation point
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiFunctionTrendControl
>
> Screenitem for displaying different function trends

- 🔧 `EventHandlers`: Events for HmiFunctionTrendControl
- 🔧 `FunctionTrendAreas`: FunctionTrendAreas Collection
- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiMediaControl
>
> Represents a media player embedded in a screen

- 🔧 `EventHandlers`: Events for HmiMediaControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `AutoPlay`: Specifies whether Autoplay is activated
- 🔧 `Url`: source of the media to be played (e
- 🔧 `VideoOutput`: Specifies the scaling of the video output
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiProcessControl
>
> Screenitem for managing different processes

- 🔧 `EventHandlers`: Events for HmiProcessControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `EditMode`: Specifies the type of table editing
- 🔧 `Online`: Specifies start and stop of the updating
- 🔧 `ProcessView`: Accepts exactly one column of type HmiTimeRangeColumnPart and multiple HmiProcessColumnPart
- 🔧 `TimeStepSmoothingBase`: Used as kind of smoothing together with Factor
- 🔧 `TimeStepSmoothingFactor`: Used as kind of smoothing together with Base
- 🔧 `TimeZone`: Positive numbers according to the Microsoft time zone index value specification, negative numbers from CHROM (-1 = RH local)
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiProcessDiagnosisCriteriaAnalysisControl
>
> Process diagnosis criteria analysis control

- 🔧 `EventHandlers`: Events for HmiProcessDiagnosisCriteriaAnalysisControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `CriteriaAnalysisView`: Specifies the appearance of the process diagnostics view
- 🔧 `ForeColor`: Specifies the font color of the text
- 🔧 `SourceControl`: Specifies the data source
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiProcessDiagnosisGraphOverviewControl
>
> Process diagnosis graph overview control

- 🔧 `EventHandlers`: Events for HmiProcessDiagnosisGraphOverviewControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Font`: Specifies the font of the text
- 🔧 `ForeColor`: Specifies the font color of the text
- 🔧 `GraphOverview`: Specifies the appearance of the process diagnostics view
- 🔧 `GridLineColor`: Specifies the color of grid lines
- 🔧 `OperationMode`: Specifies the operating mode
- 🔧 `PlcSource`: Specifies the PLC source
- 🔧 `ShowOperationMode`: Specifies whether to display the operating mode
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiProcessDiagnosisOverviewControl
>
> Process diagnosis overview control

- 🔧 `EventHandlers`: Events for HmiProcessDiagnosisOverviewControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Font`: Specifies the font of the text
- 🔧 `ForeColor`: Specifies the font color of the text
- 🔧 `LineColor`: Specifies the color of the line
- 🔧 `PDiagCategories`: Specifies the category of the process diagnostics overview
- 🔧 `PDiagSupervisionTypes`: Specifies the supervision types of the process diagnostics overview
- 🔧 `PlcSource`: Specifies the PLC source
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiProcessDiagnosisPlcCodeViewerControl
>
> Process diagnosis plc code viewer control

- 🔧 `EventHandlers`: Events for HmiProcessDiagnosisPlcCodeViewerControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `CurrentZoomFactor`: Specifies the zoom factor of the popup screen window
- 🔧 `OverviewDetailRatio`: Specifies how much space the detail view takes up in the PLC code view
- 🔧 `ShowSymbolLine`: Specifies whether the symbol line is displayed
- 🔧 `SymbolLineBackColor`: Specifies the background color of the symbol line
- 🔧 `SymbolLineFont`: Specifies the font of the text in the symbol line
- 🔧 `SymbolLineForeColor`: Specifies the text font color of the symbol line
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiSystemDiagnosisControl
>
> Control to display diagnostic information of devices connected

- 🔧 `EventHandlers`: Events for HmiSystemDiagnosisControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `DiagnosisBufferPathText`: Specifies the path to the diagnostic buffer
- 🔧 `DiagnosisOverviewPathText`: Specifies the path to the diagnostics overview
- 🔧 `MatrixView`: Specifies Matrix View properties
- 🔧 `ScriptDiagnosisOverviewText`: Specifies the overview text for the script diagnosis. ATTENTION: The property &quot;ScriptDiagnosisOverviewText&quot; is not supported in TIA Portal V21. Using this property may cause system instability. Please use only supported properties in this version of TIA Portal.
- 🔧 `ScriptDiagnosisView`: Specifies the script diagnostics view in the control
- 🔧 `ShowStatusPath`: Show Status Path
- 🔧 `SystemDiagnosisView`: Accepts only columns of type HmiDataGridColumnPart
- 🔧 `SystemDiagnosisViewType`: Specifies System Diagnosis View Type Matrix or Diagnosis
- 🔧 `TimeZone`: Positive numbers according to the Microsoft time zone index value specification, negative numbers from CHROM (-1 = RH local)
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiTrendCompanion
>
> Migration hint: Formerly known as HmiRulerView in Classic

- 🔧 `EventHandlers`: Events for HmiTrendCompanion
- 🔧 `Parent`: EOM parent of this object
- 🔧 `ShowAlways`: Specifies wether the companion will always be shown, or just if the parent&apos;s ShowRuler property is set
- 🔧 `SourceTrendControl`: Returns the SourceTrendControl object
- 🔧 `TimeZone`: Positive numbers according to the Microsoft time zone index value specification, negative numbers from CHROM (-1 = RH local)
- 🔧 `TrendCompanionMode`: Specifies the window display of TrendCompanion
- 🔧 `TrendRulerView`: Accepts only columns of type HmiTrendColumnPart
- 🔧 `TrendStatisticAreaView`: Accepts only columns of type HmiTrendColumnPart
- 🔧 `TrendStatisticResultView`: Accepts only columns of type HmiTrendColumnPart
- 🔧 `UseSourceControlBackColor`: Takes trend controls back color as back color for each row in the grid
- 🔧 `UseSourceControlTrendColors`: Takes the individual trend color as font color for the corresponding entry in the grid
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiTrendControl
>
> Screenitem for managing different trends

- 🔧 `EventHandlers`: Events for HmiTrendControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `TrendAreas`: TrendAreas Collection
- 🔧 `ShowStatisticRulers`: Specifies whether the ruler is shown for the statistics area
- 🔧 `TimeZone`: Positive numbers according to the Microsoft time zone index value specification, negative numbers from CHROM (-1 = RH local)
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Controls.HmiWebControl
>
> Widget that can display Web content

- 🔧 `EventHandlers`: Events for HmiWebControl
- 🔧 `Parent`: EOM parent of this object
- 🔧 `HomeUrl`: String formatted URL pointing to the home address the web browser shall display when no Url property is configured and will load when the home button is pressed
- 🔧 `Url`: String formatted URL pointing to the address the web browser shall display
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.UIBase
>
> Base class for all screens and screen objects.

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
- 🔧 `Dynamizations`: Dynamization collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `PropertyEventHandlers`: Property event handlers
- 📦 `Validate`: Validates the object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
