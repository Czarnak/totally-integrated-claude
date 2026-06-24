## 🛠️ Siemens.Engineering.HmiUnified.UI.ScreenGroup.HmiScreenGroup
>
> Specifies screen user group

- 🔧 `Groups`: Composition of Screen Group
- 🔧 `Screens`: HmiScreenComposition
- 🔧 `Name`: Specifies name of screen user group
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HmiUnified.UI.ScreenGroup.HmiScreenGroupComposition
>
> ScreenGroupComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.ScreenGroup.HmiScreenGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.ScreenGroup.HmiScreenGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create
- 📦 `Find(System.String)`: Find

## 🛠️ Siemens.Engineering.HmiUnified.UI.Screens.HmiScreen
>
> Represents a screen

- 🔧 `EventHandlers`: Events for HmiScreen
- 🔧 `ScreenItems`: Specifies screen Item composition
- 🔧 `AlternateBackColor`: Secondary color of the screen&apos;s background to be used in FillPattern
- 🔧 `BackColor`: Primary color of the screen&apos;s background
- 🔧 `BackFillPattern`: Specifyies the background fill pattern of the screen
- 🔧 `BackGraphic`: Graphic to be shown in the screen&apos;s background
- 🔧 `BackGraphicStretchMode`: Specifies how the backgraphic is stretched
- 🔧 `BackgroundFillMode`: Specifies if the background fills just the screen or the entire window&apos;s view
- 🔧 `Enabled`: States whether the screen is operable at all (‘Enabled’ = true) or not
- 🔧 `Height`: Specifies the height of the screen in device-independend units (DIU)
- 🔧 `HorizontalAlignment`: The initial position of screen is defined through the current scrollbar position of the parent Hmi(TopLevel)ScreenWindow If an screen is smaller than its parent window, this alignment is used for positioning
- 🔧 `ScreenNumber`: Configured number of the screen
- 🔧 `VerticalAlignment`: The initial position of screen is defined through the current scrollbar position of the parent Hmi(TopLevel)ScreenWindow If an screen is smaller than its parent window, this alignment is used for positioning
- 🔧 `Width`: Specifies the width of the screen in device-independend units (DIU)
- 📦 `ResizeScreen`: Resize screen as per device display size

## 🛠️ Siemens.Engineering.HmiUnified.UI.Screens.HmiScreenComposition
>
> Screens Composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Screens.HmiScreen)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Screens.HmiScreen)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Creates New Screen
- 📦 `Find(System.String)`: Find

## 🛠️ Siemens.Engineering.HmiUnified.UI.Screens.HmiScreenWindow
>
> HmiScreenWindow references an HmiScreen in order to provide screen-in-screen functionality

- 🔧 `EventHandlers`: Events for HmiScreenWindow
- 🔧 `Adaption`: Specifies whether the screen or screen window shall adapt its size
- 🔧 `CurrentZoomFactor`: Defining the zoom factor for the screen window, which may differ from the zoom factor of the contained screen
- 🔧 `HorizontalScrollBarPosition`: Specifies the horizontal position of the screen within the screen window in DIU
- 🔧 `HorizontalScrollBarVisibility`: Defines the screen position in the screen window
- 🔧 `InteractivePanning`: States whether panning is allowed (‘InteractivePanning’ = true) or not for this screen window
- 🔧 `InteractiveZooming`: States whether zooming is allowed (‘InteractiveZooming’ = true) or not for this screen window
- 🔧 `LinearMovement`: Adjust linear movement settings
- 🔧 `Screen`: Reference to a screen to be shown in the screen window
- 🔧 `ScreenName`: Name is taken from the current screen when read
- 🔧 `ScreenNumber`: Number is taken from the current screen when read
- 🔧 `SupportedNavigation`: Specifies which navigation in the screen history is possible for this window
- 🔧 `System`: Specifies the server prefix
- 🔧 `TabIntoWindow`: Specifies whether the screen window can swith to window with tab.
- 🔧 `VerticalScrollBarPosition`: Specifies the vertical position of the screen within the screen window in DIU
- 🔧 `VerticalScrollBarVisibility`: Defines the screen position in the screen window

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiCentricShapeBase
>
> Base class for all shapes that have a defined center

- 🔧 `CenterX`: Specifies the X coordinate of center.
- 🔧 `CenterY`: Specifies the Y coordinate of center.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiCircle
>
> This screen item represents a specific shape that can be filled

- 🔧 `EventHandlers`: Events for HmiCircle
- 🔧 `AlternateBackColor`: Secondary color of the circle&apos;s background to be used in FillPattern
- 🔧 `AlternateBorderColor`: Secondary color of the circle&apos;s border to be used in FillPattern
- 🔧 `BackColor`: Primary color of the screen item&apos;s background
- 🔧 `BackFillPattern`: Pattern applied to the screen item&apos;s background
- 🔧 `BorderColor`: Primary color of the screen item&apos;s border
- 🔧 `BorderWidth`: Specifies the border width
- 🔧 `DashType`: Specifies the outer line dash type like solid, dash, dot etc
- 🔧 `FillDirection`: Specifies the fill direction
- 🔧 `FillLevel`: Percental value indicating some fill level
- 🔧 `ShowFillLevel`: Specifies whether to show fill level is shown

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiCircleSegment
>
> This screen item represents a specific shape that can be filled

- 🔧 `EventHandlers`: Events for HmiCircleSegment
- 🔧 `AngleRange`: Clock-wise angle
- 🔧 `StartAngle`: A start angle of 0° corresponds with 3 o&apos;clock

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiCircularArc
>
> This screen item represents a specific shape based on a line

- 🔧 `EventHandlers`: Events for HmiCircularArc
- 🔧 `AlternateLineColor`: Secondary color of the screen item&apos;s line color
- 🔧 `AngleRange`: Clock-wise angle
- 🔧 `CapType`: Specifies the type of the cap like square, round, flat
- 🔧 `DashType`: Specifies the dash type like solid, dash, dot etc
- 🔧 `EndType`: Specifies end type like line, empty arrow, arrow etc
- 🔧 `LineColor`: Specifies line color
- 🔧 `LineWidth`: Specifies line width
- 🔧 `StartAngle`: A start angle of 0° corresponds with 3 o&apos;clock
- 🔧 `StartType`: Specifies start type like line, empty arrow, arrow etc

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiCircularShapeBase
>
> Base class for all circular shapes

- 🔧 `Radius`: Specifies the radius

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiEllipse
>
> This screen item represents a specific shape that can be filled

- 🔧 `EventHandlers`: Events for HmiEllipse
- 🔧 `AlternateBackColor`: Secondary color of the screen item&apos;s background to be used in FillPattern
- 🔧 `AlternateBorderColor`: Secondary color of the screen item&apos;s border to be used in FillPattern
- 🔧 `BackColor`: Primary color of the screen item&apos;s background
- 🔧 `BackFillPattern`: Pattern applied to the screen item&apos;s background
- 🔧 `BorderColor`: Specifies border color
- 🔧 `BorderWidth`: Specifies the border width
- 🔧 `DashType`: Specifies the line dash type like solid, dash, dot etc
- 🔧 `FillDirection`: Specifies fill direction
- 🔧 `FillLevel`: Percental value indicating some fill level
- 🔧 `ShowFillLevel`: Specifies whether to show fill level

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiEllipseSegment
>
> This screen item represents a specific shape that can be filled

- 🔧 `EventHandlers`: Events for HmiEllipseSegment
- 🔧 `AngleRange`: Clock-wise angle
- 🔧 `StartAngle`: A start angle of 0° corresponds with 3 o&apos;clock

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiEllipticalArc
>
> This screen item represents a specific shape based on a line

- 🔧 `EventHandlers`: Events for HmiEllipticalArc
- 🔧 `AlternateLineColor`: Specifies secondary line color
- 🔧 `AngleRange`: Clock-wise angle
- 🔧 `CapType`: Specifies the type of the line cap like square, round, flat
- 🔧 `DashType`: Specifies the line dash type like solid, dash, dot etc
- 🔧 `EndType`: Specifies line end type like line, empty arrow, arrow etc
- 🔧 `LineColor`: Specifies the color of the line
- 🔧 `LineWidth`: Specifies the width of the line
- 🔧 `StartAngle`: A start angle of 0° corresponds with 3 o&apos;clock
- 🔧 `StartType`: Specifies line start type like line, empty arrow, arrow etc

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiEllipticalShapeBase
>
> Base class for all elliptical shapes

- 🔧 `RadiusX`: Specifies the primary axis
- 🔧 `RadiusY`: Specifies secondary axis

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiGraphicView
>
> This screen item is a shape that can display graphics

- 🔧 `EventHandlers`: Events for HmiGraphicView
- 🔧 `AlternateBackColor`: Secondary color of the screen item&apos;s background to be used in FillPattern
- 🔧 `BackColor`: Primary color of the screen item&apos;s background to be used in FillPattern
- 🔧 `BackFillPattern`: Pattern applied to the screen item&apos;s background
- 🔧 `FillDirection`: Specifies the direction the fill level will be drawn, usually from bottom to top
- 🔧 `FillLevel`: Percental value indicating some fill level
- 🔧 `Graphic`: Graphic to be shown
- 🔧 `GraphicStretchMode`: Specifies graphic stretch mode like Fill, Uniform, UniformToFill
- 🔧 `Padding`: Specifies the distance between the contained graphic and the border
- 🔧 `ShowFillLevel`: Some part of the screen item&apos;s area (usually the background) will be filled according to the FillLevel property

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiLine
>
> This screen item represents a specific shape based on a line

- 🔧 `EventHandlers`: Events for HmiLine
- 🔧 `AlternateLineColor`: Specifies line start type like line, empty arrow, arrow etc
- 🔧 `CapType`: Specifies the type of the line cap like square, round, flat
- 🔧 `DashType`: Specifies the line dash type like solid, dash, dot etc
- 🔧 `EndType`: Specifies line end type like line, empty arrow, arrow etc
- 🔧 `LineColor`: Specifies the color of the line
- 🔧 `LineWidth`: Specifies the width of the line
- 🔧 `StartType`: Specifies line start type like line, empty arrow, arrow etc
- 🔧 `X1`: Relative to surface, not screen
- 🔧 `X2`: Relative to surface, not screen
- 🔧 `Y1`: Relative to surface, not screen
- 🔧 `Y2`: Relative to surface, not screen

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiPoint
>
> HmiPoint to hols X,Y coorinates

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `X`: X coordinate
- 🔧 `Y`: Y coordinate
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiPointBasedShapeBase
>
> Base class for screen items like polygon, polyline

- 🔧 `Points`: Points Collection
- 🔧 `JoinType`: Specifies the corner style of the polyline

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiPointComposition
>
> HMIPoint Composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Shapes.HmiPoint)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Shapes.HmiPoint)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.Int32,System.Int32)`: Create a HmiPoint for give X,Y coordinates

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiPolygon
>
> This screen item represents a specific shape that can be filled

- 🔧 `EventHandlers`: Events for HmiPolygon
- 🔧 `AlternateBackColor`: Secondary color of the screen item&apos;s background to be used in FillPattern
- 🔧 `AlternateBorderColor`: Secondary color of the screen item&apos;s border to be used in FillPattern
- 🔧 `BackColor`: Primary color of the screen item&apos;s background
- 🔧 `BackFillPattern`: Pattern applied to the screen item&apos;s background
- 🔧 `BorderColor`: Specifies the border color
- 🔧 `BorderWidth`: Specifies the border width
- 🔧 `DashType`: Specifies the outer line dash type like solid, dash, dot etc
- 🔧 `FillDirection`: Specifies the fill direction
- 🔧 `FillLevel`: Percental value indicating some fill level
- 🔧 `ShowFillLevel`: Specifies whether to show fill level is shown

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiPolyline
>
> This screen item represents a specific shape based on a line

- 🔧 `EventHandlers`: Events for HmiPolyline
- 🔧 `AlternateLineColor`: Specifies secondary line color
- 🔧 `CapType`: Specifies the type of the line cap like square, round, flat
- 🔧 `DashType`: Specifies the line dash type like solid, dash, dot etc
- 🔧 `EndType`: Specifies line end type like line, empty arrow, arrow etc
- 🔧 `LineColor`: Specifies the color of the line
- 🔧 `LineWidth`: Specifies the width of the line
- 🔧 `StartType`: Specifies line start type like line, empty arrow, arrow etc

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiRectangle
>
> This screen item represents a specific shape that can be filled

- 🔧 `EventHandlers`: Events for HmiRectangle
- 🔧 `AlternateBackColor`: Secondary color of the screen item&apos;s background to be used in FillPattern
- 🔧 `AlternateBorderColor`: Secondary color of the screen item&apos;s border to be used in FillPattern
- 🔧 `BackColor`: Primary color of the screen item&apos;s background
- 🔧 `BackFillPattern`: Pattern applied to the screen item&apos;s background
- 🔧 `BorderColor`: Specifies border color
- 🔧 `BorderWidth`: Specifies border width
- 🔧 `Corners`: Specifies if and to which degree the corners of the rectangle shall be round
- 🔧 `DashType`: Specifies the line dash type like solid, dash, dot etc
- 🔧 `FillDirection`: Specifies fill direction
- 🔧 `FillLevel`: Percental value indicating some fill level
- 🔧 `ShowFillLevel`: Specifies whether to show fill level

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiShapeBase
>
> Base class for all shapes

- 🔧 `LinearMovement`: Adjust linear movement settings
- 🔧 `RotationAngle`: Specifies the rotation angle of the screen item in degree
- 🔧 `RotationCenterPlacement`: Specifies the RotationCenterPlacement works
- 🔧 `RotationCenterX`: Specifies the X coordinate of the rotation point
- 🔧 `RotationCenterY`: Specifies the Y coordinate of the rotation point

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiSurfaceShapeBase
>
> Base class for all shapes having properties associated with surface

- 🔧 `Height`: Specifies height in device independent units
- 🔧 `Left`: Specifies X coordinates in device independent units
- 🔧 `Top`: Specifies Y coordinates in device independent units
- 🔧 `Width`: Specifies width in device independent units

## 🛠️ Siemens.Engineering.HmiUnified.UI.Shapes.HmiText
>
> Text without any chrome like border and backcolors

- 🔧 `EventHandlers`: Events for HmiText
- 🔧 `Font`: Specifies the font
- 🔧 `ForeColor`: Specifies the forecolor
- 🔧 `HorizontalTextAlignment`: Specifies the horizontal text alignment
- 🔧 `Text`: Specifies the text
- 🔧 `VerticalTextAlignment`: Specifies the vertical text alignment

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiAlarmIndicator
>
> AlarmIndicator screen item to visualze the overall alarm state

- 🔧 `EventHandlers`: Events for HmiAlarmIndicator
- 🔧 `AlarmState`: Specifies the alarm state
- 🔧 `Filter`: Specifies a string for filtering alarms
- 🔧 `FlashingColor`: Specifies to color that is used for flashing
- 🔧 `Font`: Specifies the font
- 🔧 `Height`: Specifies the height of the screen item in DIU (Device Independent Unit)
- 🔧 `IsFlashingRequired`: Specifies if flashing is requiered
- 🔧 `Left`: Sets the value of the X coordinate in DIU (Device Independent Unit)
- 🔧 `NoAlarmState`: Specifies the no alarm state
- 🔧 `ShowAlways`: Specifies wether item is visible in no alarm state
- 🔧 `Top`: Sets the value of the Y coordinate in DIU (Device Independent Unit)
- 🔧 `Width`: Specifies the width of the screen item in DIU (Device Independent Unit)

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiBar
>
> This screenitem represents HmiBar

- 🔧 `EventHandlers`: Events for HmiBar
- 🔧 `BarMode`: Specifies the color display of the bar graph
- 🔧 `StraightScale`: Specifies the linear scale of the bar display

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiButton
>
> This screen item represents a button that can be operated but has no state

- 🔧 `EventHandlers`: Events for HmiButton
- 🔧 `PressedStateTags`: PressedStateTags Collection
- 🔧 `AlternateGraphic`: Graphic shown while the button is pressed/down
- 🔧 `AlternateText`: Text shown while the button is pressed/down
- 🔧 `Content`: Returns the context of a key performance indicator in performance management
- 🔧 `Font`: Specifies the font of the text
- 🔧 `ForeColor`: Color of the button&apos;s text
- 🔧 `Graphic`: Graphic shown while the button is NOT pressed/down
- 🔧 `HotKey`: Hotkeys are unique within a screen
- 🔧 `Padding`: Specifies the distance of the content from the border
- 🔧 `Text`: Text shown while the button is NOT pressed/down

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiCheckBoxGroup
>
> This screenitem represents CheckBox

- 🔧 `EventHandlers`: Events for HmiCheckBoxGroup

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiClock
>
> Output only, digital clock may ignore properties that apply for analog clock only

- 🔧 `EventHandlers`: Events for HmiClock
- 🔧 `DialBackColor`: Specifies the color of the dial background
- 🔧 `DialLabelColor`: Specifies the color of the text of the dial
- 🔧 `DialLabelFont`: Specifies the character set for the dial
- 🔧 `DialMode`: Defines which details of a dial have to be drawn, e
- 🔧 `DialTickColor`: Specifies the color of the graduation of the dial
- 🔧 `ShowDate`: Specifies whether to show the date in the clock
- 🔧 `ShowHours`: Specifies whether to show the hour-needle or not
- 🔧 `ShowMinutes`: Specifies whether to show the minutes-needle or not
- 🔧 `ShowSeconds`: Specifies whether to show the seconds-needle or not
- 🔧 `TimeSource`: Provides time to be displayed; if not configured client locale time is displayed
- 🔧 `Title`: Returns the Title object

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiGauge
>
> This screenitem represents HmiGauge

- 🔧 `EventHandlers`: Events for HmiGauge
- 🔧 `BarMode`: TODO: Description needs to updated
- 🔧 `CurvedScale`: Specifies the curved scale of the display

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiIOField
>
> A field for input and output that can be connected with the process value

- 🔧 `EventHandlers`: Events for HmiIOField
- 🔧 `Thresholds`: Thresholds Collection
- 🔧 `HorizontalTextAlignment`: Specifies the horizontal alignment of a text
- 🔧 `IOFieldType`: Specifies the input/output type
- 🔧 `InputBehavior`: Returns the InputBehavior object
- 🔧 `OutputFormat`: Describes how the IOField&apos;s value will be formatted for display
- 🔧 `ProcessValue`: Specifies the process value
- 🔧 `ShiftDecimalPlaces`: Specifies the number of digits the ProcessValue property value is shifted to the left for input and output
- 🔧 `ShowInputHint`: Specifies if an input hint with additional information like tag range is shown during input
- 🔧 `TextTrimming`: Specifies the type of trimming of a text if the space is not sufficient
- 🔧 `VerticalTextAlignment`: Specifies the vertical alignment of a text

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiLabel
>
> This screen item can display one or many lines of unformatted text

- 🔧 `HorizontalTextAlignment`: Specifies the horizontal alignment of a text
- 🔧 `Text`: Specifies the labeling
- 🔧 `TextTrimming`: TextTrimming is only applied in case of TextWrapping=NoWrap
- 🔧 `TextWrapping`: Specifies whether lines shall be wrapped in case of not enough screen item width
- 🔧 `VerticalTextAlignment`: Specifies the vertical alignment of a text

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiListBox
>
> This screenitem represents listBox

- 🔧 `EventHandlers`: Events for HmiListBox
- 🔧 `SelectionMode`: Indicates whether one or more entries can be selected in the selection list

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiRadioButtonGroup
>
> This screenitem represents RadioButton

- 🔧 `EventHandlers`: Events for HmiRadioButtonGroup

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiScaleWidgetBase
>
> This screen item represents a bar that can display a process value

- 🔧 `Thresholds`: Thresholds Collection
- 🔧 `Font`: Specifies the font of the text
- 🔧 `Label`: Represents the Editable text box object
- 🔧 `NormalRangeColor`: Specifies the color of the normal range
- 🔧 `OriginValue`: Specifies the start value that is visualized
- 🔧 `OutputFormat`: Specifies the format for displaying values
- 🔧 `PeakIndicators`: Defines whether indicators for the highest/lowest value seen have to be shown
- 🔧 `ProcessValue`: Specifies the process value
- 🔧 `ProcessValueIndicatorBackColor`: Specifies the background color for the process value
- 🔧 `ProcessValueIndicatorForeColor`: Used for ProcessIndicator or for Bar in SegementedStatic
- 🔧 `ProcessValueIndicatorMode`: Defines the visual representation of indicator for the current process value
- 🔧 `RelativeToOrigin`: States whether the origin value is an absolute value or if the origin is calculated from a percental declaration between minimum and maximum value
- 🔧 `ScaleBackColor`: Specifies the background color of the scale
- 🔧 `ScaleForeColor`: Specifies the foreground color of the scale
- 🔧 `ShowTrendIndicator`: The trend Indicator itself is part of the rendering template (e
- 🔧 `ThresholdIndicators`: Specifies how parameterized limit values are visualized
- 🔧 `Title`: Returns the Title object
- 🔧 `TrendIndicatorColor`: Specifies the color of the trend view

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiSelectionGroupBase
>
> This screen items represents a group of entries from which one or multiple can be selected

- 🔧 `SelectionItems`: SelectionItems Collection
- 🔧 `Content`: Returns the Content object
- 🔧 `Font`: Specifies the font of the text
- 🔧 `ForeColor`: Specifies the font color
- 🔧 `Padding`: Specifies the distance of the content from the border
- 🔧 `ProcessValue`: Specifies the process value
- 🔧 `SelectionItemHeight`: 0 means auto mode, Item height is caliculated automatically
- 🔧 `SelectorPosition`: Specifies the horizontal alignment of the entries

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiSlider
>
> Migration hint: Former properties of HmiSlider in Classic (BackGraphic, ThumbGraphic) are moved into the Rendering Template

- 🔧 `EventHandlers`: Events for HmiSlider
- 🔧 `ShowValue`: Shows the current formatted value as text in addition to the bar
- 🔧 `ThumbBackColor`: Specifies the background color of the slider
- 🔧 `ThumbForeColor`: Specifies the foreground color of the slider
- 🔧 `ValuePosition`: Static position of the current value relative to scale and &quot;bar&quot;
- 🔧 `WriteDuringChange`: While manipulating the sliding control, the value will be written down to process immediately, not only when releasing the control

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiSymbolicIOField
>
> This screen item is a combination of HmiSymbolicIOField and HmiGraphicIOField

- 🔧 `EventHandlers`: Events for HmiSymbolicIOField
- 🔧 `Content`: Returns the &quot;Content&quot; object.
- 🔧 `Graphic`: Holds the graphic from the resource list entry valid for the current process value
- 🔧 `IOFieldType`: Migration hint: Was known in Classic as &quot;Mode&quot;
- 🔧 `ProcessValue`: Specifies the process value
- 🔧 `ResourceList`: Specifies source of the Text or Graphic list to be displayed in the screen object
- 🔧 `SelectedIndex`: Index of the resource list entry valid for the current process value
- 🔧 `SelectionBackColor`: Specifies the background color of the selected cells
- 🔧 `SelectionForeColor`: Specifies the foreground color of the selected cells
- 🔧 `Text`: Holds the text from the resource list entry valid for the current process value

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiTextBox
>
> A text box can be used for unformatted input/output of text

- 🔧 `EventHandlers`: Events for HmiTextBox
- 🔧 `ReadOnly`: Specifies whether the text box is write-protected

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiTextWidgetBase
>
> Base class for all widgets that have to handle text among other aspects

- 🔧 `Font`: Specifies the font of the text
- 🔧 `ForeColor`: Color of the text in the widget
- 🔧 `Padding`: Specifies the distance of the content from the border

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiToggleSwitch
>
> Migration hint: Was known as &quot;HmiSwitch&quot; in Classic

- 🔧 `EventHandlers`: Events for HmiToggleSwitch
- 🔧 `IsAlternateState`: Specifies whether the selected object engages after it has been operated in runtime

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiTouchArea
>
> TODO: Description needs to updated

- 🔧 `EventHandlers`: Events for HmiTouchArea
- 🔧 `Authorization`: Specifies access control for the screen item
- 🔧 `BackColor`: Specifies the background color
- 🔧 `Height`: in DIU
- 🔧 `Left`: Coordinates in DIU
- 🔧 `RequireExplicitUnlock`: If set to true, the screen item configured within the screen (or a parent screen if not configured locally) enables the screen item only when the release button while the button is pressed
- 🔧 `Top`: Coordinates in DIU
- 🔧 `Width`: in DIU

## 🛠️ Siemens.Engineering.HmiUnified.UI.Widgets.HmiWidgetBase
>
> Base class for all widgets

- 🔧 `AlternateBackColor`: Alternate color to be used for the background
- 🔧 `AlternateBorderColor`: Specifies the second border color which is displayed for line styles such as Dash
- 🔧 `BackColor`: Specifies the background color
- 🔧 `BorderColor`: Specifies the line color
- 🔧 `BorderWidth`: Specifies the line thickness
- 🔧 `Height`: Specifies the height
- 🔧 `Left`: Specifies the value of the X coordinate
- 🔧 `LinearMovement`: Adjust linear movement settings
- 🔧 `RotationAngle`: Specifies the rotation angle of the screen item in degree
- 🔧 `RotationCenterPlacement`: Specifies the RotationCenterPlacement works
- 🔧 `RotationCenterX`: Specifies the X coordinate of the rotation point
- 🔧 `RotationCenterY`: Specifies the Y coordinate of the rotation point
- 🔧 `Top`: Specifies the value of the Y coordinate
- 🔧 `VisualizeQuality`: Specifies whether the quality of the process value is displayed
- 🔧 `Width`: Specifies the width
