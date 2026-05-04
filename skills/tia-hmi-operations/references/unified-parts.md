## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiAlarmColumnPart
>
> Usage sample:AlarmControl1

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AlarmBlock`: Specifies which component of the alarm is displayed
- 🔧 `UseAlarmColors`: Specifies whether the configured color of the alarm is used
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiAlarmLineColumnPart
>
> Hmi alarm line column part

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AlarmBlock`: Specifies which property of the alarm is displayed
- 🔧 `BackColor`: Background color
- 🔧 `Content`: Content
- 🔧 `Enabled`: Enable of column
- 🔧 `ForeColor`: Foreground color
- 🔧 `Name`: Unique name for the column within the DataGrid
- 🔧 `OutputFormat`: Output format of column
- 🔧 `UseAlarmColors`: Specifies whether the configured alarm colors are used
- 🔧 `Visible`: Visiblity of column
- 🔧 `Width`: Width of column
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiAlarmLineColumnPartComposition
>
> HmiAlarmLineColumnPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiAlarmLineColumnPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiAlarmLineColumnPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiAlarmLineViewPart
>
> Hmi alarm line view part

- 🔧 `AlarmLineColumns`: AlarmLineColumns Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `AllowFilter`: Specifies whether filtering of columns is permitted
- 🔧 `AlternateBackColor`: Specifies the alternate background color
- 🔧 `AlternateForeColor`: Specifies the alternate foreground color
- 🔧 `BackColor`: Specifies the background color
- 🔧 `CellPadding`: Specifies the inner spacing of the content from the cell border
- 🔧 `ColoringMode`: Specifies whether rows or colums have alternating colors
- 🔧 `Font`: Specifies the font of the cells
- 🔧 `ForeColor`: Specifies the foreground color
- 🔧 `GridLineColor`: Specifies the grid line color
- 🔧 `GridLineVisibility`: Specifies the visibility of the grid lines
- 🔧 `GridLineWidth`: Specifies the thickness of the grid lines in DIU
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiAlarmStatePart
>
> Defines visual attributes for displaying alarm states in HmiAlarmIndicator

- 🔧 `Parent`: EOM parent of this object
- 🔧 `BackColor`: Specifies the background color
- 🔧 `BorderColor`: Specifies the border color
- 🔧 `BorderWidth`: Specifies the border thickness
- 🔧 `Content`: Specifies the content
- 🔧 `ForeColor`: Specifies the foreground color
- 🔧 `Graphic`: Specifies the graphic of this alarm state
- 🔧 `Text`: Specifies the text of this alarm state
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiAlarmStatisticColumnPart
>
> This part contains property assocaited with Alarmcolumn part

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AlarmStatisticBlock`: AlarmStatisticBlock
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiContentPart
>
> Includes properties regarding how the content of the screenitem

- 🔧 `Parent`: EOM parent of this object
- 🔧 `ContentMode`: Specifies whether text, graphic or both shall be used for visualization
- 🔧 `GraphicStretchMode`: Specifies the type of scaling of the graphic in the screen
- 🔧 `HorizontalTextAlignment`: Specifies the horizontal alignment of a text
- 🔧 `Spacing`: Fix and absolute spacing in between areas spawn by the content split ratio
- 🔧 `SplitRatio`: Defines ratio of graphic to text (0
- 🔧 `TextPosition`: Position of the text in relation to the element&apos;s graphic
- 🔧 `TextTrimming`: Specifies the type of trimming of a text if the space is not sufficient
- 🔧 `VerticalTextAlignment`: Specifies the vertical alignment of a text
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarButtonPart
>
> Button that can be used within control bars, such as within a toolbar

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AlternateBackColor`: Specifies the second color for a color gradient
- 🔧 `AlternateBorderColor`: Specifies the second border color which is displayed for line styles such as Dash
- 🔧 `BackColor`: Specifies the background color
- 🔧 `BorderColor`: Specifies the line color
- 🔧 `BorderWidth`: Specifies the line thickness
- 🔧 `HotKey`: Specifies the hot(shortcut) key
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarDisplayPart
>
> Can show a graphic and text that can be arranged via content part

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Content`: Returns the Content object
- 🔧 `Graphic`: Specifies the graphic
- 🔧 `Text`: Specifies the labeling
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarElementPartBase
>
> Base class of any element that can be used within a control bar, e

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Authorization`: Specifies access control for the tool- or statusbar element
- 🔧 `CustomID`: ID can be used to identify a control bar element, e
- 🔧 `Enabled`: Specifies whether the specified object can be operated in runtime
- 🔧 `ForeColor`: Specifies the font color
- 🔧 `Height`: Specifies the height
- 🔧 `MaximumHeight`: Specifies the maximum height
- 🔧 `MaximumWidth`: Specifies the maximum width
- 🔧 `MinimumHeight`: Specifies the minimum height
- 🔧 `MinimumWidth`: Specifies the minimum width
- 🔧 `Padding`: Specifies the distance of the content from the border
- 🔧 `ToolTipText`: Specifies the tooltip text
- 🔧 `Visible`: Specifies whether the selected object is visible
- 🔧 `Width`: Specifies the width
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarElementPartBaseComposition
>
> HmiControlBarElementPartBaseComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarElementPartBase)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarElementPartBase)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarLabelPart
>
> Label to be used within control bars, such as a tool bar

- 🔧 `Parent`: EOM parent of this object
- 🔧 `HorizontalTextAlignment`: Specifies the horizontal alignment of a text
- 🔧 `Text`: Specifies the labeling
- 🔧 `VerticalTextAlignment`: Specifies the vertical alignment of a text
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarPartBase
>
> Base class for control bars, such as tool and status bars

- 🔧 `Elements`: Elements Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `BackColor`: Specifies the background color
- 🔧 `Enabled`: Specifies whether the specified object can be operated in runtime
- 🔧 `Font`: Specifies the font of the text
- 🔧 `Padding`: Specifies the value of padding
- 🔧 `ShowToolTips`: Specifies whether tooltips are shown
- 🔧 `Visible`: Specifies whether the selected object is visible
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarSeparatorPart
>
> defines a separator that can be used on a control bar

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarTextBoxPart
>
> Edit field used within HmiToolBar or HmiStatusBar

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AlternateBorderColor`: Specifies the second border color which is displayed for line styles such as Dash
- 🔧 `BackColor`: Specifies the background color
- 🔧 `BorderColor`: Specifies the line color
- 🔧 `BorderWidth`: Specifies the line thickness
- 🔧 `ReadOnly`: Specifies whether the text box is write-protected
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiControlBarToggleSwitchPart
>
> defines property that indicates about the switch&apos;s state

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AlternateGraphic`: In pressed state toggle button can have the defined Alternate Graphic
- 🔧 `AlternateText`: In pressed state toggle button can have the defined Alternate text
- 🔧 `HotKey`: Specifies the hot(shortcut) key
- 🔧 `IsAlternateState`: Indicator for the switch&apos;s state
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiCornersPart
>
> This screen item part specifies the round corners of an area-based screen item

- 🔧 `Parent`: EOM parent of this object
- 🔧 `BottomLeftRadius`: Specifies the radius of the rounding of the bottom left corner
- 🔧 `BottomRightRadius`: Specifies the radius of the rounding of the bottom right corner
- 🔧 `TopLeftRadius`: Specifies the radius of the rounding of top left corner
- 🔧 `TopRightRadius`: Specifies the radius of the rounding of top right corner
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiCurvedScalePart
>
> This screen item part specifies the curved scale of guage

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AngleRange`: The offset angle clock-wise
- 🔧 `StartAngle`: The angle where the scale starts
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiCustomControlInterface
>
> Hmi Custom Control Interface property

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Properties`: Parent of the custom properties which are specific to each custom control or custom widgets.
- 🔧 `PropertyName`: Interface property name
- 🔧 `Value`: Value of interface property
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiCustomControlInterfaceComposition
>
> HmiCustomControlInterfaceComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiCustomControlInterface)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiCustomControlInterface)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CanCreate`: Checks if a property can be created
- 📦 `CanDelete`: Checks if a property can be deleted
- 📦 `Create`: Create Custom Interface
- 📦 `Find(System.String)`: Find Custom Control Interface
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiDataGridColumnHeaderPart
>
> Part specifying the header for a column

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Content`: Returns the Content object
- 🔧 `Graphic`: Specifies the graphic
- 🔧 `Text`: Specifies the labeling
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiDataGridColumnPart
>
> Part specifying properties of DataGridColumn

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Key`: Matches the considered column in binding source &quot;ConsideredColumns&quot; property
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiDataGridColumnPartBase
>
> Base class for all types of columns within a data grid

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AllowSort`: This property is ignored if the AllowSort=false on the overall screen item is set
- 🔧 `BackColor`: alpha channel is zero; colors are taken from the HmiDataGridViewPart; otherwise colors are mixed in order from grid to column to cells
- 🔧 `Content`: Returns the Content object
- 🔧 `Enabled`: The cells of the affected column are enabled or disabled
- 🔧 `ForeColor`: alpha channel is zero; colors are taken from the HmiDataGridViewPart; otherwise colors are mixed in order from grid to column to cells
- 🔧 `Header`: Returns the Header object
- 🔧 `MaximumWidth`: Specifies the maximum width
- 🔧 `MinimumWidth`: Specifies the minimum width
- 🔧 `Name`: Unique name for the column within the DataGrid
- 🔧 `OutputFormat`: Specifies the format for displaying values
- 🔧 `SortDirection`: Specifies the direction of sorting
- 🔧 `SortOrder`: Index 0 is ignored, starting with 1 (highest) the index specifies the priority of columns and their individual sort order
- 🔧 `Visible`: Specifies whether the selected object is visible
- 🔧 `Width`: Specifies the width
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiDataGridColumnPartBaseComposition
>
> HmiDataGridColumnPartBaseComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiDataGridColumnPartBase)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiDataGridColumnPartBase)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiDataGridHeaderSettingsPart
>
> Settings used within a data grid that apply for all columns and their headers

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AllowColumnReorder`: Specifies whether the order of the columns can be changed
- 🔧 `AllowColumnResize`: Specifies whether the size of the columns can be changed
- 🔧 `ColumnHeaderType`: Specifies the type of content of a column header
- 🔧 `Font`: Specifies the font of the text
- 🔧 `HeaderBackColor`: Specifies the background color of the header
- 🔧 `HeaderForeColor`: Specifies the font color of the headers
- 🔧 `HeaderGridLineColor`: Specifies the color of the dividing line between column headers
- 🔧 `HeaderSelectionBackColor`: Specifies the background color of the header of a selected row or column
- 🔧 `HeaderSelectionForeColor`: Specifies the font color of the header of a selected row or column
- 🔧 `RowHeaderType`: Specifies the type of content of a row header
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiDataGridViewPart
>
> Part that represents a data grid that can be used within advanced controls

- 🔧 `Columns`: Columns Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `AllowFilter`: Specifies if filter is applied or not
- 🔧 `AllowSort`: Setting this property to true turns all AllowSort properties on the individual columns active (the actual true/false value of the column is used)
- 🔧 `AlternateBackColor`: Specifies the second color for a color gradient
- 🔧 `AlternateForeColor`: Specifies the flashing color for the text
- 🔧 `BackColor`: Specifies the background color
- 🔧 `CellPadding`: Specifies the inner distance of the contents from the cell frame
- 🔧 `ColoringMode`: Specifies whether rows or colums have alternating colors
- 🔧 `Font`: Is the font to be used within the table (cells)
- 🔧 `ForeColor`: Specifies the font color
- 🔧 `GridLineColor`: Specifies the color of the grid lines
- 🔧 `GridLineVisibility`: Specifies the visibility of the grid lines
- 🔧 `GridLineWidth`: Specifies the width of the separator lines in pixels
- 🔧 `GridSelectionMode`: Specifies whether multiple selection is enabled in the table content
- 🔧 `HeaderSettings`: Returns the HeaderSettings object
- 🔧 `HorizontalScrollBarVisibility`: Specifies the setting for the horizontal scroll bar of the window
- 🔧 `RowHeight`: Specifies the height of all rows of the table in DIU (Device Independent Unit)
- 🔧 `SelectFullRow`: Specifies whether only the cell or the whole row is included in a selection
- 🔧 `SelectionBackColor`: Specifies the background color of the selected cells
- 🔧 `SelectionBorderColor`: Specifies the border color of a selection
- 🔧 `SelectionBorderWidth`: Specifies the border thickness of a selection
- 🔧 `SelectionForeColor`: Specifies the foreground color of the selected cells
- 🔧 `VerticalScrollBarVisibility`: Specifies the setting for the vertical scroll bar of the window
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiDataSourcePart
>
> Part which defines the source data

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Source`: Accepts (currently) only HmiTag and HmiLoggingTag
- 🔧 `VisualizeQuality`: Specifies whether the quality of the process value is displayed
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiDetailedParameterControlColumnPart
>
> Part defining properties of DetailedparameterControlColumn

- 🔧 `Parent`: EOM parent of this object
- 🔧 `DetailedParameterControlBlock`: Specifies the parameters of a parameter set
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiFaceplateInterface
>
> Hmi faceplate properties interface

- 🔧 `Parent`: EOM parent of this object
- 🔧 `PropertyName`: Interface property name
- 🔧 `Value`: Value of interface property
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiFaceplateInterfaceComposition
>
> HmiFaceplateInterfaceComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiFaceplateInterface)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiFaceplateInterface)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds HmiFaceplateInterface
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiFontPart
>
> This screen item part specifies a font configuration

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Italic`: Specifies whether the text is italic
- 🔧 `Name`: Specifies the text font name
- 🔧 `Size`: Font size unit is: DIU
- 🔧 `StrikeOut`: Specifies whether the text is striked out
- 🔧 `Underline`: Specifies whether the text is underlined
- 🔧 `Weight`: Specifies the text is bold
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiFunctionTrendAreaPart
>
> Migration hint: trend areas have been named trend windows in Classic

- 🔧 `BottomValueAxes`: BottomValueAxes Collection
- 🔧 `FunctionTrends`: FunctionTrends Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `TopValueAxes`: TopValueAxes Collection
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiFunctionTrendAreaPartComposition
>
> HmiFunctionTrendAreaPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiFunctionTrendAreaPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiFunctionTrendAreaPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create new object
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiFunctionTrendPart
>
> Part defining properties of FunctionTrend

- 🔧 `Parent`: EOM parent of this object
- 🔧 `BeginTime`: Specifies the date and time for the start time of the time range
- 🔧 `DataSourceX`: Specifies the tag for data source of the x value axis
- 🔧 `EndTime`: Specifies the date and time for the end time of the time range
- 🔧 `PointCount`: Specifies the number of measurement points from the start time
- 🔧 `RangeType`: Specifies the type of time range
- 🔧 `TimeRangeBase`: Specifies the basis of the time range
- 🔧 `TimeRangeFactor`: Specifies the factor for the time base for defining the time range
- 🔧 `TrendMode`: Specifies the type of trend representation
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiFunctionTrendPartComposition
>
> HmiFunctionTrendPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiFunctionTrendPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiFunctionTrendPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Create new object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiGraphOverviewControlColumnPart
>
> Usage sample:HmiGraphOverviewControl1

- 🔧 `Parent`: EOM parent of this object
- 🔧 `GraphOverviewControlBlock`: Specifies which component of the graph overview is displayed
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiHelpLinePart
>
> Parts defining properties of HelpLine

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Value`: Specifies a value for the object being used or returns it
- 🔧 `Visible`: Specifies whether the selected object is visible
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiHelpLinePartComposition
>
> HmiHelpLinePartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiHelpLinePart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiHelpLinePart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Create new object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiInputBehaviorPart
>
> Covers all aspects of special behavior input elements may have in HMI

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AcceptOnDeactivated`: Value is written to tag once the screen item loses its focus
- 🔧 `ClearOnActivate`: On focus the last value will be cleared
- 🔧 `HiddenInput`: Specifies whether the IOField accepts input while not showing it
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiLegendPart
>
> Part defining properties of legend

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Font`: Specifies the font of the text
- 🔧 `ForeColor`: Fore color for legend part
- 🔧 `Visible`: Specifies whether the selected object is visible
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiLinearMovementPart
>
> Defines properties for a linear item movement

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Tag`: Tag that controls the current position based on the value
- 🔧 `TagRangeEnd`: End value of tag range
- 🔧 `TagRangeStart`: Start value of tag range
- 🔧 `TargetPositionX`: X coordinate of the target position for the animation
- 🔧 `TargetPositionY`: Y coordinate of the target position for the animation
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiMatrixViewPart
>
> Part specifying Matrix view properties

- 🔧 `HardwareDetails`: HardwareDetails Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `SystemDiagnosisHardwareDetailView`: SystemDiagnosisHardwareDetailView
- 🔧 `TileBorderWidth`: Specifies tie border width
- 🔧 `TileHeightMax`: Specifies the tile max height
- 🔧 `TileHeightMin`: Specifies the tile minimum height
- 🔧 `TileWidthMax`: Specifies the tile width max
- 🔧 `TileWidthMin`: Specifies the tile width min
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiOverviewParameterControlColumnPart
>
> Part defining properties of OverviewParameterControlColumn

- 🔧 `Parent`: EOM parent of this object
- 🔧 `OverviewParameterControlBlock`: Specifies the OverviewParameterControlBlock property
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiPaddingPart
>
> This screen item part specifies the distance of a screen item&apos;s content and it&apos;s border

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Bottom`: Specifies the distance to the bottom
- 🔧 `Left`: Specifies the value of the X coordinate
- 🔧 `Right`: Specifies the right margin
- 🔧 `Top`: Specifies the value of the Y coordinate
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiPlcDataSourcePart
>
> Hmi Plc data source part

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Connection`: Specifies the connection
- 🔧 `DB_Name`: Specifies the name of the database
- 🔧 `Tag`: Specifies the tag
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiPressedStateTagPart
>
> Part defining properties of PressedStateTag

- 🔧 `Parent`: EOM parent of this object
- 🔧 `BitNumber`: Specifies the tag&apos;s bit number
- 🔧 `Tag`: Specifies the tag
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiPressedStateTagPartComposition
>
> HmiPressedStateTagPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiPressedStateTagPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiPressedStateTagPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Create new object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiProcessColumnPart
>
> Part defining properties of ProcessColumn

- 🔧 `Parent`: EOM parent of this object
- 🔧 `DataSource`: Specifies the data source of the value column
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiProcessDiagnosisCriteriaAnalysisControlColumnPart
>
> Usage sample:HmiProcessDiagnosisCriteriaAnalysisControl

- 🔧 `Parent`: EOM parent of this object
- 🔧 `CriteriaAnalysisBlock`: Specifies which component of the process diagnosis criteria analysis column is displayed
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiProcessDiagnosisOperationModePart
>
> Hmi process diagnosis operation mode part

- 🔧 `Parent`: EOM parent of this object
- 🔧 `OpModeAutoText`: Specifies the automatic text
- 🔧 `OpModeManText`: Specifies the manual text
- 🔧 `OpModeTapText`: Specifies the text on clicking
- 🔧 `OpModeTopText`: Specifies the title text
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiProcessDiagnosisOverviewElementPart
>
> Hmi process diagnosis overview element part

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AlternateBackColor`: Specifies the second background color for a color gradient
- 🔧 `AlternateForeColor`: Specifies the flashing color for the text
- 🔧 `BackColor`: Specifies the background color
- 🔧 `FlashingRate`: Specifies the flashing rate
- 🔧 `ForeColor`: Specifies the text color
- 🔧 `Text`: Specifies the text of the element
- 🔧 `Visible`: Specifies if the element is visible
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiProcessDiagnosisOverviewElementPartComposition
>
> HmiProcessDiagnosisOverviewElementPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiProcessDiagnosisOverviewElementPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiProcessDiagnosisOverviewElementPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Create new object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiProcessDiagnosisOverviewPart
>
> Hmi process diagnosis overview part

- 🔧 `PDiagElements`: PDiagElements Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Label`: Specifies the label below the screen item
- 🔧 `SymbolFont`: Specifies the font of the symbol text
- 🔧 `Visible`: Specifies if the element is visible
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiQualityPart
>
> Part defining properties for identifying the quality

- 🔧 `Parent`: EOM parent of this object
- 🔧 `BadColor`: Specifies the color for values of quality Bad, Value cannot be used
- 🔧 `UncertainColor`: Specifies the color for values of quality Uncertain, the quality of the value is worse than usual, the value could still be usable.
- 🔧 `Visible`: Specifies whether the selected object is visible
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiRulerPart
>
> Part defining properties of ruler

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Color`: Specifies the line color
- 🔧 `Width`: Specifies the width
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiScalePartBase
>
> TODO: LabelPosition (LeftOrTop, RightOrBottom) to be considered

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AutoScaling`: Specifies whether automatic scaling is activated
- 🔧 `BeginValue`: Specifies the start of a value range or value range section
- 🔧 `DivisionCount`: Number of primary divisions (in between large ticks)
- 🔧 `EndValue`: Specifies the end of a value range or value range section
- 🔧 `LabelColor`: Specifies the color of the label
- 🔧 `LabelFont`: Specifies the Lable Font
- 🔧 `OutputFormat`: Specifies a format pattern that is applied to scale label&apos;s and process value indicators
- 🔧 `ScaleMode`: Specifies the type of scaling
- 🔧 `ScalingType`: The scaling type has influence on the scale (e
- 🔧 `SubDivisionCount`: Number of secondary divisions (in between small ticks)
- 🔧 `TickColor`: Specifies the color of the axis scale
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiScalingEntryPart
>
> Migration Hint: was called CustomSegments in Classic

- 🔧 `Parent`: EOM parent of this object
- 🔧 `BeginValue`: Specifies the start of a value range or value range section
- 🔧 `BeginValueTarget`: Specifies the scaled value for the specified start of a value range or value range section
- 🔧 `DisplayName`: Specifies the display name
- 🔧 `EndValue`: Specifies the end of a value range or value range section
- 🔧 `EndValueTarget`: Specifies the scaled value for the specified end of a value range or value range section
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiScalingEntryPartComposition
>
> HmiScalingEntryPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiScalingEntryPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiScalingEntryPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Create new object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiScreenElementBase
>
> base class for all elements

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiScreenPartBase
>
> Base class for all screen model parts

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiSelectionItemPart
>
> This screen item part represents a single entry to be used within a selection group

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Graphic`: Specifies the graphic
- 🔧 `IsSelected`: Specifies whether the entry is selected
- 🔧 `Text`: Specifies the labeling
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiSelectionItemPartComposition
>
> HmiSelectionItemPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiSelectionItemPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiSelectionItemPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Create new object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiStatusBarPart
>
> A status bar is a specialization of the control bar, which is usually found at the bottom of a control or window

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiStraightScalePart
>
> Part defining property associated with alignment of screenitem

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Orientation`: Migration hint: Former modes UpAndDown and LeftAndRight can be specified by using the BarOriginValue in addition to this orientation
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiSystemDiagnosisControlColumnPart
>
> This part contains property assocaited with SystemDiagnosisControlColumn part

- 🔧 `Parent`: EOM parent of this object
- 🔧 `SystemDiagnosisControlBlock`: Specifies which component of the SystemDiagnosisControl is displayed
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiSystemDiagnosisControlScriptColumnPart
>
> This screen item part specifies a script block configuration for system diagnosis control columns.

- 🔧 `Parent`: EOM parent of this object
- 🔧 `SystemDiagnosisControlScriptBlock`: Specifies the script block configuration for the system diagnosis control.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiSystemDiagnosisDetailViewPart
>
> Part specifying the Detail View Properties of Hardware details

- 🔧 `HardwareDetails`: HardwareDetails Collection
- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiSystemDiagnosisHardwareDetailPart
>
> Part specifying Hardware Detail Properties

- 🔧 `Parent`: EOM parent of this object
- 🔧 `SystemDiagnosisMatrixBlock`: SystemDiagnosisMatrixBlock
- 🔧 `Visible`: Visible
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiSystemDiagnosisHardwareDetailPartComposition
>
> HmiSystemDiagnosisHardwareDetailPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiSystemDiagnosisHardwareDetailPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiSystemDiagnosisHardwareDetailPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Create new object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiSystemDiagnosisMatrixColumnPart
>
> HmiSystemDiagnosisMatrixColumn properties

- 🔧 `Parent`: EOM parent of this object
- 🔧 `SystemDiagnosisMatrixBlock`: SystemDiagnosisMatrixBlock
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTextPart
>
> This part covers several aspects that are related to text and applied formatting

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Font`: Specifies the font of the text
- 🔧 `ForeColor`: Specifies the font color
- 🔧 `Text`: Specifies the labeling
- 🔧 `Visible`: Specifies whether the selected object is visible
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiThresholdPart
>
> Threshold values are taken from the tag

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Color`: &quot;Gaps&quot; have to be configured as transparent colors
- 🔧 `DisplayName`: Display name of threshold
- 🔧 `Enable`: Enable ThresholdMode property
- 🔧 `Name`: Name of threshold
- 🔧 `ThresholdMode`: Mode of threshold
- 🔧 `Value`: Taken from tag
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiThresholdPartComposition
>
> HmiThresholdPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiThresholdPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiThresholdPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTimeAxisPart
>
> Part defining properties of TimeAxis

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AlwaysShowRecent`: Always move visible area with recently added value
- 🔧 `AutoScaling`: Specifies whether automatic scaling is activated
- 🔧 `AxisColor`: Color defined for a specific axis (line, ticks, etc)
- 🔧 `BeginTime`: Specifies the date and time for the start time of the time range
- 🔧 `DisplayName`: Specifies the display name
- 🔧 `EndTime`: Specifies the type of line end
- 🔧 `LabelColor`: Specifies the color of the label
- 🔧 `LabelFont`: Specifies the label font
- 🔧 `Name`: Serves as key for the axis
- 🔧 `OutputFormat`: Specifies the format for displaying values
- 🔧 `PointCount`: Specifies the number of measurement points from the start time
- 🔧 `RangeType`: Specifies the type of time range
- 🔧 `ScaleMode`: Specifies the type of scaling
- 🔧 `TickColor`: Specifies the color of the axis scale
- 🔧 `TimeRangeBase`: Specifies the basis of the time range
- 🔧 `TimeRangeFactor`: Specifies the factor for the time base for defining the time range
- 🔧 `Visible`: Specifies whether the selected object is visible
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTimeAxisPartComposition
>
> HmiTimeAxisPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiTimeAxisPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiTimeAxisPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create new object
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTimeRangeColumnPart
>
> Part defining properties of timerange

- 🔧 `Parent`: EOM parent of this object
- 🔧 `BeginTime`: Specifies the date and time for the start time of the time range
- 🔧 `EndTime`: Specifies the date and time for the end time of the time range
- 🔧 `PointCount`: Specifies the number of measurement points from the start time
- 🔧 `RangeType`: Specifies the type of time range
- 🔧 `TimeRangeBase`: Specifies the basis of the time range
- 🔧 `TimeRangeFactor`: Specifies the factor for the time base for defining the time range
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiToolBarPart
>
> A tool bar is a specialization of the control bar, which can be positioned freely and carries hot keys

- 🔧 `Parent`: EOM parent of this object
- 🔧 `UseHotKeys`: Specifies whether the hotkeys are activated for buttons in the toolbar
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendAreaPart
>
> Part defining properties of trendarea

- 🔧 `BottomTimeAxes`: BottomTimeAxes Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `TopTimeAxes`: TopTimeAxes Collection
- 🔧 `Trends`: Trends Collection
- 🔧 `StatisticRulers`: Defines the appearance of the two statistic rulers in this area
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendAreaPartBase
>
> Base class of HmiTrendAreaPart

- 🔧 `LeftValueAxes`: LeftValueAxes Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `RightValueAxes`: RightValueAxes Collection
- 🔧 `BackColor`: Specifies the background color
- 🔧 `GridLines`: Grid lines are always shown for the area&apos;s inner axes (that&apos;s the axis with index=0 in the parts arrays)
- 🔧 `MajorGridLinesColor`: Specifies the separator line color of the major scaling
- 🔧 `MinorGridLinesColor`: Specifies the separator line color of the minor scaling
- 🔧 `Name`: Is used as key for the graph area
- 🔧 `Ruler`: Defines the appearance of the ruler in this area
- 🔧 `SizeFactor`: The TrendControl will set the areas proportional to their individual HeightFactors
- 🔧 `Visible`: Specifies whether the selected object is visible
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendAreaPartComposition
>
> HmiTrendAreaPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendAreaPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendAreaPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create new object
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendColumnPart
>
> Part defining properties of trendcolumn

- 🔧 `Parent`: EOM parent of this object
- 🔧 `TrendInfoBlock`: Specifies the properties or evaluated data of the associated TrendControl which are displayed in the column of the TrendCompanion
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendPart
>
> part defining different trends in various controls

- 🔧 `Parent`: EOM parent of this object
- 🔧 `AggregationMode`: Aggregation applied to logging tags only
- 🔧 `TrendMode`: Specifies the type of trend representation
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendPartBase
>
> Base class of HmiTrendPart

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Thresholds`: Thresholds Collection
- 🔧 `AlternateBackColor`: Specifies the second color for a color gradient
- 🔧 `BackColor`: Specifies the background color
- 🔧 `BackFillPattern`: Specifies the pattern of the background or the fill
- 🔧 `DashType`: Specifies the dash type of the frame or the line
- 🔧 `DataSourceY`: Specifies the tag for data source of the value axis
- 🔧 `DisplayName`: Specifies the display name
- 🔧 `LineColor`: Specifies the line color
- 🔧 `LineWidth`: Specifies the line thickness
- 🔧 `MarkerColor`: Specifies the point color of the trend
- 🔧 `MarkerDimension`: Specifies the point width
- 🔧 `MarkerGraphic`: Specifies a graphic element as a dot
- 🔧 `MarkerType`: Specifies the type of dots
- 🔧 `QualityVisualization`: If Limit colors are defined and quality is uncertain with RangeViolation, colors defined in this part are ignored
- 🔧 `ShowLoggedDataImmediately`: Only relevant for historical data
- 🔧 `Visible`: Specifies whether the selected object is visible
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendPartComposition
>
> HmiTrendPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiTrendPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Create new object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiValueAxisPartBase
>
> BaseClass of both X and Y ValueAxis

- 🔧 `HelpLines`: HelpLines Collection
- 🔧 `Parent`: EOM parent of this object
- 🔧 `ScalingEntries`: ScalingEntries Collection
- 🔧 `ApplyScalingEntries`: Specifies whether the user scaling is applied
- 🔧 `AutoRange`: Specifies whether the automatic determination of the value range is activated by the minimum and maximum value of the trend
- 🔧 `AxisColor`: Color defined for a specific axis (line, ticks, etc)
- 🔧 `DisplayName`: Specifies the display name
- 🔧 `Name`: Serves as key for the axis
- 🔧 `ShowScalingDisplayNames`: Specifies whether the display names of the user scaling are used
- 🔧 `Visible`: Specifies whether the selected object is visible
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiXValueAxisPart
>
> Horizontal X axis for values

- 🔧 `Parent`: EOM parent of this object
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiXValueAxisPartComposition
>
> HmiXValueAxisPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiXValueAxisPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiXValueAxisPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create new object
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiYValueAxisPart
>
> Vertical y axis for values

- 🔧 `Parent`: EOM parent of this object
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Parts.HmiYValueAxisPartComposition
>
> HmiYValueAxisPartComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Parts.HmiYValueAxisPart)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Parts.HmiYValueAxisPart)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create new object
- 📦 `Find(System.String)`: Find
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
