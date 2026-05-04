## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiArcFeature
>
> This feature defines just the arc that is used to express an arc element

- 🔧 `AngleRange`: Clock-wise angle
- 🔧 `StartAngle`: A start angle of 0° corresponds with 3 o&apos;clock

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiAreaFeature
>
> This feature is used for all shapes that can be filled

- 🔧 `AlternateBackColor`: Specifies the AlternateBackColor
- 🔧 `AlternateBorderColor`: Specifies the AlternateBorderColor
- 🔧 `BackColor`: Specifies BackColor
- 🔧 `BackFillPattern`: Pattern applied to the screen item&apos;s background
- 🔧 `BorderColor`: Specifies BorderColor
- 🔧 `BorderWidth`: Specifes border width
- 🔧 `DashType`: Specifies DashType
- 🔧 `FillDirection`: Specifies FillDirection
- 🔧 `FillLevel`: Percental value indicating some fill level
- 🔧 `ShowFillLevel`: Specifies whether to show fill level.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiAxisFeature
>
> Represents the axis feature

- 🔧 `AxisColor`: Color defined for a specific axis (line, ticks, etc)
- 🔧 `DisplayName`: Specifies the display name of the object
- 🔧 `Name`: Serves as key for the axis
- 🔧 `Visible`: Specifies whether the selected object is visible.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiBasicScreenFeature
>
> This feature carries all properties that are shared by HmiScreen and HmiFaceplateType

- 🔧 `AlternateBackColor`: Secondary color of the screen&apos;s background to be used in FillPattern
- 🔧 `BackColor`: Primary color of the screen&apos;s background
- 🔧 `BackFillPattern`: Specifies the background fill pattern of the screen
- 🔧 `BackGraphic`: Graphic to be shown in the screen&apos;s background
- 🔧 `BackGraphicStretchMode`: Specifies how the backgraphic is stretched
- 🔧 `BackgroundFillMode`: Specifies if the background fills just the screen or the entire window&apos;s view
- 🔧 `Enabled`: States whether the screen is operable at all (‘Enabled’ = true) or not
- 🔧 `Height`: Specifies the dimensions of the screen in device-independend units (DIU)
- 🔧 `HorizontalAlignment`: The initial position of screen is defined through the current scrollbar position of the parent Hmi(TopLevel)ScreenWindow If an screen is smaller than its parent window, this alignment is used for positioning
- 🔧 `VerticalAlignment`: The initial position of screen is defined through the current scrollbar position of the parent Hmi(TopLevel)ScreenWindow If an screen is smaller than its parent window, this alignment is used for positioning
- 🔧 `Width`: Specifies the dimensions of the screen in device-independend units (DIU)

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiBasicScreenItemFeature
>
> This feature carries all properties that are shared by screen items and the TopLevelScreenWindow (which do not share some base class in the screen model)

- 🔧 `Enabled`: Specifies whether the selected object can be operated in runtime
- 🔧 `Name`: Configured name of the screen item
- 🔧 `StyleItemClass`: StyleItem&apos;s class will be resolved by name
- 🔧 `TabIndex`: Screen items specifying a tab index of 0 are not part of the tab order
- 🔧 `Visible`: Specifies whether the selected object is visible

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiBoxFeature
>
> This feature defines all properties that are needed for a bounding box (widgets, windows and controls) or surface (non-centric shapes)

- 🔧 `Height`: Specifies height in device independent units
- 🔧 `Left`: Specifies X coordinates in device independent units
- 🔧 `Top`: Specifies Y coordinates in device independent units
- 🔧 `Width`: Specifies width in device independent units

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiIdentifierFeature
>
> Specifies the identifier feature of the object

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiLineFeature
>
> This feature is used for all line-based shapes, having a starting and end point

- 🔧 `AlternateLineColor`: Specifies secondary line color
- 🔧 `CapType`: Specifies the type of the line cap like square, round, flat
- 🔧 `DashType`: Specifies the line dash type like solid, dash, dot etc
- 🔧 `EndType`: Specifies line end type like line, empty arrow, arrow etc
- 🔧 `LineColor`: Specifies the color of the line
- 🔧 `LineWidth`: Specifies the width of the line
- 🔧 `StartType`: Specifies line start type like line, empty arrow, arrow etc

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiMeasurementUnitFeature
>
> This feature holds all properties that are related to measurement units

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiOperabilityFeature
>
> TODO: Description needs to updated

- 🔧 `Authorization`: Specifies access control for the screen item
- 🔧 `RequireExplicitUnlock`: If set to true, the screen item configured within the screen (or a parent screen if not configured locally) enables the screen item only when the release button while the button is pressed

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiRotationFeature
>
> Represents rotation feature

- 🔧 `RotationAngle`: Specifies the rotation angle of the screen item in degree
- 🔧 `RotationCenterPlacement`: Specifies the Rotation placement wrt center
- 🔧 `RotationCenterX`: Specifies the X coordinate of the rotation point
- 🔧 `RotationCenterY`: Specifies the Y coordinate of the rotation point

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiScaleFeature
>
> Represents feature related to scaling

- 🔧 `AutoScaling`: Specifies whether the scaling is auto
- 🔧 `LabelColor`: Specifies the color of the label
- 🔧 `ScaleMode`: Specifes whether the scale has label or ticks
- 🔧 `TickColor`: Specifies the tick color

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiScreenWindowFeature
>
> Represents all properties used in HmiScreenWindow, HmiPopupScreenWindow (both derived from HmiScreenItemBase) and HmiTopLevelScreenWindow (base class)

- 🔧 `Adaption`: Specifies whether the screen or screen window shall adapt its size
- 🔧 `CurrentZoomFactor`: Defining the zoom factor for the screen window, which may differ from the zoom factor of the contained screen
- 🔧 `HorizontalScrollBarPosition`: Specifies the horizontal position of the screen within the screen window in DIU
- 🔧 `HorizontalScrollBarVisibility`: Defines the screen position in the screen window
- 🔧 `InteractivePanning`: States whether panning is allowed (‘InteractivePanning’ = true) or not for this screen window
- 🔧 `InteractiveZooming`: States whether zooming is allowed (‘InteractiveZooming’ = true) or not for this screen window
- 🔧 `Screen`: Reference to a screen to be shown in the screen window
- 🔧 `ScreenName`: Name is taken from the current screen when read
- 🔧 `ScreenNumber`: Number is taken from the current screen when read
- 🔧 `System`: Specifies the server prefix
- 🔧 `VerticalScrollBarPosition`: Specifies the vertical position of the screen within the screen window in DIU
- 🔧 `VerticalScrollBarVisibility`: Defines the screen position in the screen window

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiTimeRangeFeature
>
> Represents the properties required to define the time range

- 🔧 `BeginTime`: Specifies the start time of the time range
- 🔧 `EndTime`: Specifies the end time of the time range
- 🔧 `PointCount`: Specifiese the the point count for the time range
- 🔧 `RangeType`: Specifies RangeType like TimeRange, FromBiginToEnd, PointCount.
- 🔧 `TimeRangeBase`: Specifies the TimeRangeFactor Avarage
- 🔧 `TimeRangeFactor`: Specifies TimeRangeFactor

## 🛠️ Siemens.Engineering.HmiUnified.UI.Features.IHmiWindowFeature
>
> This feature carries all properties relevant for (screen) windows, since HmiTopLevelScreenWindow is a root element that cannot be configured within a screen and does therefor not inherit from HmiScreenItemBase

- 🔧 `Caption`: Text to be shown in the caption of a screen window or windowed control
- 🔧 `CaptionColor`: Specifies the color of the Caption
- 🔧 `Icon`: Specifes the icon on the window
- 🔧 `WindowFlags`: Specifies the window configuration like ShowCaption, ShowBorder, AlwaysOnTop.
