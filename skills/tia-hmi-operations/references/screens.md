# Screens Reference

Source: TIA Portal Openness V21 — Functions for Accessing HMI Device Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. Create a user-defined screen folder

Entry point: `hmiTarget.ScreenFolder` (`HmiScreenFolder` / `ScreenSystemFolder`)

```csharp
private static void CreateScreenFolder(HmiTarget hmitarget)
{
    ScreenUserFolder myCreatedFolder = hmitarget.ScreenFolder.Folders.Create("myScreenFolder");
}
```

---

## 2. Delete a screen from a folder

> You cannot delete a permanent area (system screen that is always present).

```csharp
public static void DeleteScreenFromFolder(HmiTarget hmiTarget)
{
    ScreenUserFolder screenUserFolder = hmiTarget.ScreenFolder.Folders.Find("myScreenFolder");
    ScreenComposition screens = screenUserFolder.Screens;
    Screen screen = screens.Find("myScreenName");
    if (screen != null)
    {
        screen.Delete();
    }
}
```

---

## 3. Delete all screens from a folder

> You cannot delete a permanent area. Collect into a list first — do not modify the composition while iterating.

```csharp
private static void DeleteAllScreensFromFolder(HmiTarget hmitarget)
{
    ScreenUserFolder folder = hmitarget.ScreenFolder.Folders.Find("myScreenFolder");
    // or: ScreenSystemFolder folder = hmitarget.ScreenFolder;

    ScreenComposition screens = folder.Screens;
    List<Screen> list = new List<Screen>();

    foreach (Screen screen in screens)
    {
        list.Add(screen);
    }

    foreach (Screen screen in list)
    {
        screen.Delete();
    }
}
```

---

## 4. Delete a screen template from a folder

Entry point: `hmiTarget.ScreenTemplateFolder` (`ScreenTemplateSystemFolder`)

```csharp
private static void DeleteScreenTemplateFromFolder(HmiTarget hmiTarget)
{
    string templateName = "MyScreenTemplate";
    ScreenTemplateUserFolder folder = hmiTarget.ScreenTemplateFolder.Folders.Find("myScreenTemplateFolder");
    ScreenTemplateComposition templates = folder.ScreenTemplates;
    ScreenTemplate template = templates.Find(templateName);
    if (template != null)
    {
        template.Delete();
    }
}
```

---

## 5. Delete a user-defined screen folder

```csharp
ScreenUserFolder screenUserGroup = hmiTarget.ScreenFolder.Folders.Find("MyUserFolder");
screenUserGroup.Delete();
```

## V21 API Reference: Siemens.Engineering.Hmi.Screen

## 🛠️ Siemens.Engineering.Hmi.Screen.AlarmControlActions
>
> Defines actions which can be executed on an AlarmControl

## 🛠️ Siemens.Engineering.Hmi.Screen.AlarmControlTimeUnit
>
> Defines the time unit used for defining time ranges on the AlarmControl.

## 🛠️ Siemens.Engineering.Hmi.Screen.AlarmDisplayOptions
>
> Defines the display categories for alarms

## 🛠️ Siemens.Engineering.Hmi.Screen.AlarmListType
>
> Defines types of alarm lists

## 🛠️ Siemens.Engineering.Hmi.Screen.AlarmViewBasicColumnId
>
> Specifies constants for the alarm columns of the Siemens.Engineering.Hmi.Screen.AlarmViewBasic.

## 🛠️ Siemens.Engineering.Hmi.Screen.AlarmViewBasicMode
>
> Specifies constants defining the the view type of the Siemens.Engineering.Hmi.Screen.AlarmViewBasic.

## 🛠️ Siemens.Engineering.Hmi.Screen.AlarmViewBasicSource
>
> Specifies constants defining the the alarm source of the Siemens.Engineering.Hmi.Screen.AlarmViewBasic.

## 🛠️ Siemens.Engineering.Hmi.Screen.AlarmWindowModes
>
> Defines for alarm window modes.

## 🛠️ Siemens.Engineering.Hmi.Screen.AutoSizingType
>
> Specifies constants for setting the auto-sizing mode.

## 🛠️ Siemens.Engineering.Hmi.Screen.AxisAlignment
>
> Defines the alignment of an axis of a trend control.

## 🛠️ Siemens.Engineering.Hmi.Screen.AxisScalingType
>
> Specifies the scaling type of diagram axes.

## 🛠️ Siemens.Engineering.Hmi.Screen.AxisSide
>
> Axis side of the trend (left or right) in the trend view

## 🛠️ Siemens.Engineering.Hmi.Screen.BackPictureAlignment
>
> Specifies constants for Back Picture Alignment

## 🛠️ Siemens.Engineering.Hmi.Screen.BarOrientation
>
> Specifies constants defining the direction of the Siemens.Engineering.Hmi.Screen.Bar.

## 🛠️ Siemens.Engineering.Hmi.Screen.BarScaleLabelHorizontalAlignment
>
> Specifies constants for setting horizontal alignment of the label of the $.NameSpace$Bar.

## 🛠️ Siemens.Engineering.Hmi.Screen.BarScaleStart
>
> Specifies constants setting the start point of scaling.

## 🛠️ Siemens.Engineering.Hmi.Screen.BarScalingType
>
> Specifies constants for setting the type of scaling of the Siemens.Engineering.Hmi.Screen.Bar.

## 🛠️ Siemens.Engineering.Hmi.Screen.BarSegmentColoring
>
> Specifies constants defining the type of the colors of the Siemens.Engineering.Hmi.Screen.Bar.

## 🛠️ Siemens.Engineering.Hmi.Screen.ButtonBarStyle
>
> Specifies constants defining the button bar style of the Siemens.Engineering.Hmi.Screen.AlarmViewBasic.

## 🛠️ Siemens.Engineering.Hmi.Screen.ButtonType
>
> Specifies constants for setting the type of a Siemens.Engineering.Hmi.Screen.Button.

## 🛠️ Siemens.Engineering.Hmi.Screen.CheckmarkAlignment
>
> Specifies constants defining the positon of the round or rectangle in the Siemens.Engineering.Hmi.Screen.Checkbox or Siemens.Engineering.Hmi.Screen.Optiongroup.

## 🛠️ Siemens.Engineering.Hmi.Screen.ClockFillStyle
>
> Specifies constants defining the style of the back of the Siemens.Engineering.Hmi.Screen.Clock.

## 🛠️ Siemens.Engineering.Hmi.Screen.ClockNumberStyle
>
> Specifies the possible clock number styles

## 🛠️ Siemens.Engineering.Hmi.Screen.ClockTickStyle
>
> Specifies the possible tick styles in a Clock

## 🛠️ Siemens.Engineering.Hmi.Screen.ConnectorConnectionType
>
> Specifies constants for setting the connection type.

## 🛠️ Siemens.Engineering.Hmi.Screen.CornerStyle
>
> Specifies constants for the drawing style of corners.

## 🛠️ Siemens.Engineering.Hmi.Screen.CurveOrientation
>
> Specifies the writing direction for curve values.

## 🛠️ Siemens.Engineering.Hmi.Screen.DataSourceType
>
> Defines the data source type for a trend.

## 🛠️ Siemens.Engineering.Hmi.Screen.DateTimeType
>
> Specifies constants for setting the type of Siemens.Engineering.Hmi.Screen.DateTimeField.

## 🛠️ Siemens.Engineering.Hmi.Screen.ExportRange
>
> Defines the data range to be exported.

## 🛠️ Siemens.Engineering.Hmi.Screen.FillStyle
>
> Specifies constants for the area fill style.

## 🛠️ Siemens.Engineering.Hmi.Screen.FillStyleAlignment
>
> Specifies constants for Fill Style Alignment

## 🛠️ Siemens.Engineering.Hmi.Screen.FlashingRate
>
> Specifies constants for setting the rate of flashing.

## 🛠️ Siemens.Engineering.Hmi.Screen.FlashingType
>
> Specifies constants for setting the type of flashing.

## 🛠️ Siemens.Engineering.Hmi.Screen.GaugeBorder3DStyle
>
> Specifies constants for setting the style of 3D borders for the Siemens.Engineering.Hmi.Screen.Gauge.

## 🛠️ Siemens.Engineering.Hmi.Screen.GaugeFillStyle
>
> Specifies constants defining the style of the back of the Siemens.Engineering.Hmi.Screen.Gauge.

## 🛠️ Siemens.Engineering.Hmi.Screen.GraphDirection
>
> Defines the writing direction for trend values.

## 🛠️ Siemens.Engineering.Hmi.Screen.GraphicIOFieldType
>
> Specifies constants for setting the type of a Siemens.Engineering.Hmi.Screen.GraphicIOField.

## 🛠️ Siemens.Engineering.Hmi.Screen.GridColumnHeaderHorizontalAlignment
>
> Defines the horizontal alignment of text in a grid column header

## 🛠️ Siemens.Engineering.Hmi.Screen.GridHeaderStyle
>
> Defines the visual style of grid headers

## 🛠️ Siemens.Engineering.Hmi.Screen.GridSelectionBorder
>
> Defines the extent of the selection rectangle in a grid

## 🛠️ Siemens.Engineering.Hmi.Screen.GridSelectionColoring
>
> Defines how configured selection colors are used in the grid

## 🛠️ Siemens.Engineering.Hmi.Screen.GridSelectionType
>
> Defines the mode in which grid elements can be selected

## 🛠️ Siemens.Engineering.Hmi.Screen.GridSortSequence
>
> Defines the sequence by which sort modes in a grid are toggled.

## 🛠️ Siemens.Engineering.Hmi.Screen.GridSortTrigger
>
> Defines the action which triggers grid sorting in Runtime.

## 🛠️ Siemens.Engineering.Hmi.Screen.HorizontalAlignment
>
> Specifies constants defining the horizontal alignments.

## 🛠️ Siemens.Engineering.Hmi.Screen.IOFieldDataFormat
>
> Specifies constants for setting the format of data output at Siemens.Engineering.Hmi.Screen.IOField.

## 🛠️ Siemens.Engineering.Hmi.Screen.IOFieldType
>
> Specifies constants for setting the type of Siemens.Engineering.Hmi.Screen.IOField.

## 🛠️ Siemens.Engineering.Hmi.Screen.LineEndShapeStyle
>
> Specifies constants for setting line end styles.

## 🛠️ Siemens.Engineering.Hmi.Screen.LineEndStyle
>
> Specifies constants for setting line end styles.

## 🛠️ Siemens.Engineering.Hmi.Screen.LineFillStyle
>
> Specifies constants for the line fill style.

## 🛠️ Siemens.Engineering.Hmi.Screen.LineJoinStyle
>
> Corners for the polygonal tube.

## 🛠️ Siemens.Engineering.Hmi.Screen.LineStyle
>
> Specifies the line drawing style.

## 🛠️ Siemens.Engineering.Hmi.Screen.NCPartProgramViewAppearance
>
> Specifies constants for setting the appearance of the Siemens.Engineering.Hmi.Screen.NCPartProgramView.

## 🛠️ Siemens.Engineering.Hmi.Screen.NeedleFillStyle
>
> Specifies constants for setting the needle fill style for the Siemens.Engineering.Hmi.Screen.Clock.

## 🛠️ Siemens.Engineering.Hmi.Screen.PictureAlignment
>
> Specifies the picture alignment.

## 🛠️ Siemens.Engineering.Hmi.Screen.PictureSizeMode
>
> Picture size mode

## 🛠️ Siemens.Engineering.Hmi.Screen.PointStyle
>

## 🛠️ Siemens.Engineering.Hmi.Screen.PositionMode
>
> Specifies constants defining the startup position for a screen window.

## 🛠️ Siemens.Engineering.Hmi.Screen.RTPersistence
>
> Defines the retention level of online configuration changes at screen change

## 🛠️ Siemens.Engineering.Hmi.Screen.RTPersistenceType
>
> Defines the scope of runtime persistence

## 🛠️ Siemens.Engineering.Hmi.Screen.RangeDefinitionType
>
> Defines the way (data) ranges can be defined at a control.

## 🛠️ Siemens.Engineering.Hmi.Screen.RecipeControlDataSourceType
>
> Defines the type of data source assigned to a RecipeControl.

## 🛠️ Siemens.Engineering.Hmi.Screen.RecipeViewBasicEntryValuePos
>
> RecipeViewEntryValuePos

## 🛠️ Siemens.Engineering.Hmi.Screen.RecipeViewBasicViewType
>
> Specifies wich type of view is selected for the recipview basic

## 🛠️ Siemens.Engineering.Hmi.Screen.RulerLayer
>
> Specifies the layer in which the ruler is located.

## 🛠️ Siemens.Engineering.Hmi.Screen.RulerStyle
>
> Defines the visual style of a ruler.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScalePosition
>
> Specifies constants for setting the scale position of the Siemens.Engineering.Hmi.Screen.Bar.

## 🛠️ Siemens.Engineering.Hmi.Screen.Screen
>
> Represents a screen

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
- 🔧 `Name`: The name of the screen
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a screen
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenComposition
>
> Composition of Screens

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Screen.Screen)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Screen.Screen)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Hmi.Screen.ScreenLibraryTypeVersion)`: Create screen from type version
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create Screen from MasterCopy
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a screen
- 📦 `Find(System.String)`: Finds a given screen
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenFolder
>
> Represents a screen folder

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
- 🔧 `Folders`: Composition of screen user folders
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Screens`: Composition of screens
- 🔧 `Name`: The name of the screen folder
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenGlobalElements
>
> Represents the screen global elements

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
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of screen global elements
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenLibraryType
>
> Represents a library type made from a screen

- 🔧 `Name`: Name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenLibraryTypeVersion
>
> Represents a library type version made from a screen

- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenOverview
>
> Editor for elements in the overview

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
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a screen overview
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenPopup
>
> Pop-up screen

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
- 🔧 `Name`: Gets or sets the screen name.
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Common export
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenPopupComposition
>
> Composition of popup screens.

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Screen.ScreenPopup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Screen.ScreenPopup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create ScreenPopup from MasterCopy
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Import Action
- 📦 `Find(System.String)`: Finds a given screen popup
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenPopupFolder
>
> Folder containing screen popups

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
- 🔧 `Folders`: Composition of screen popup user folders
- 🔧 `Parent`: EOM parent of this object
- 🔧 `ScreenPopups`: Composition of screen popups
- 🔧 `Name`: The name of the screen popup folder
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenPopupSystemFolder
>
> System folder containing screen popups

- 🔧 `Folders`: Composition of screen popup user folders
- 🔧 `Parent`: EOM parent of this object
- 🔧 `ScreenPopups`: Composition of screen popups
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenPopupUserFolder
>
> User folder containing screen popups

- 🔧 `Folders`: Composition of screen popup user folders
- 🔧 `Parent`: EOM parent of this object
- 🔧 `ScreenPopups`: Composition of screen popups
- 🔧 `Name`: The name of the screen template user folder
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenPopupUserFolderComposition
>
> Composition of ScreenPopupUserFolders

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Screen.ScreenPopupUserFolder)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Screen.ScreenPopupUserFolder)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Creates a screen popup user folder
- 📦 `Find(System.String)`: Finds a given screen popup user folder
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenSlidein
>
> Slide-In screen

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
- 🔧 `SlideinType`: Type of a Slide-In screen.
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Common export
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenSlideinComposition
>
> Composition of slidein screens.

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Screen.ScreenSlidein)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Screen.ScreenSlidein)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Import Action
- 📦 `Find(Siemens.Engineering.Hmi.Screen.SlideinType)`: Find a slidein screen.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenSlideinSystemFolder
>
> Folder for slide-in screens

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
- 🔧 `ScreenSlideins`: Returns a collection of slide-in screens in that folder.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenSystemFolder
>
> System folder containing screens

- 🔧 `Folders`: Composition of screen user folders
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Screens`: Composition of screens
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenTemplate
>
> Represents a screen template

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
- 🔧 `Name`: The name of the screen template
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a screen template
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenTemplateComposition
>
> Composition of ScreenTemplates

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Screen.ScreenTemplate)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Screen.ScreenTemplate)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create ScreenTemplate from MasterCopy
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a screen template
- 📦 `Find(System.String)`: Finds a given screen template
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenTemplateFolder
>
> Folder containing screen templates

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
- 🔧 `Folders`: Composition of screen template user folders
- 🔧 `Parent`: EOM parent of this object
- 🔧 `ScreenTemplates`: Composition of screen templates
- 🔧 `Name`: The name of the screen template folder
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenTemplateSystemFolder
>
> System folder containing screen templates

- 🔧 `Folders`: Composition of screen template user folders
- 🔧 `Parent`: EOM parent of this object
- 🔧 `ScreenTemplates`: Composition of screen templates
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenTemplateUserFolder
>
> User folder containing screen templates

- 🔧 `Folders`: Composition of screen template user folders
- 🔧 `Parent`: EOM parent of this object
- 🔧 `ScreenTemplates`: Composition of screen templates
- 🔧 `Name`: The name of the screen template user folder
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenTemplateUserFolderComposition
>
> Composition of ScreenTemplateUserFolders

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Screen.ScreenTemplateUserFolder)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Screen.ScreenTemplateUserFolder)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Creates a screen template user folder
- 📦 `Find(System.String)`: Finds a given screen template user folder
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenUserFolder
>
> User folder containing screens

- 🔧 `Folders`: Composition of screen user folders
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Screens`: Composition of screens
- 🔧 `Name`: The name of the screen user folder
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScreenUserFolderComposition
>
> Composition of ScreenUserFolders

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Screen.ScreenUserFolder)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Screen.ScreenUserFolder)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Creates a screen user folder
- 📦 `Find(System.String)`: Finds a given screen user folder
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScrollBarOrientation
>
> Specifies constants for setting the position of the scroll Siemens.Engineering.Hmi.Screen.Bar.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScrollBarType
>
> Specifies constants for setting the scroll bar type of the Siemens.Engineering.Hmi.Screen.Bar.

## 🛠️ Siemens.Engineering.Hmi.Screen.ScrollbarVisibility
>
> Defines the scrollbar visibility in a control.

## 🛠️ Siemens.Engineering.Hmi.Screen.SlideinType
>
> Defines the available Slide-In screen types.

## 🛠️ Siemens.Engineering.Hmi.Screen.SliderBorder3DStyle
>
> Specifies constants for setting the style of 3D borders of the Siemens.Engineering.Hmi.Screen.Slider.

## 🛠️ Siemens.Engineering.Hmi.Screen.SliderFillStyle
>
> Specifies constants defining the style of the back of the Siemens.Engineering.Hmi.Screen.Slider.

## 🛠️ Siemens.Engineering.Hmi.Screen.SliderTickStyle
>
> Specifies constants for setting the tick mark style of the Siemens.Engineering.Hmi.Screen.Slider.

## 🛠️ Siemens.Engineering.Hmi.Screen.SmartClientViewConnectionType
>
> Specifies constants for setting the type of VNC connection of a Siemens.Engineering.Hmi.Screen.SmartClientView.

## 🛠️ Siemens.Engineering.Hmi.Screen.SortByTimeDirection
>
> pecifies constants defining the direction types for sorting.

## 🛠️ Siemens.Engineering.Hmi.Screen.SortMode
>
> Defines the sorting direction of grid elements

## 🛠️ Siemens.Engineering.Hmi.Screen.StatusForceAppearance
>
> Specifies constants for setting the appearance of the Siemens.Engineering.Hmi.Screen.StatusForce.

## 🛠️ Siemens.Engineering.Hmi.Screen.StatusForceType
>
> Specifies constants for setting the type of Siemens.Engineering.Hmi.Screen.StatusForce.

## 🛠️ Siemens.Engineering.Hmi.Screen.StencilAlignment
>
> Specifies the alignment state for a Siemens.Engineering.Hmi.Screen.ChildButtonStencil.

## 🛠️ Siemens.Engineering.Hmi.Screen.StyleLibraryType
>
> Represents a library type made from a style

- 🔧 `Name`: Name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.StyleLibraryTypeVersion
>
> Represents a library type version made from a style

- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.StyleSheetLibraryType
>
> Represents a library type made from a style sheet

- 🔧 `Name`: Name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.StyleSheetLibraryTypeVersion
>
> Represents a library type version made from a style sheet

- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.Hmi.Screen.SwitchDirection
>
> Specifies constants for setting the sense of direction of the Siemens.Engineering.Hmi.Screen.Switch.

## 🛠️ Siemens.Engineering.Hmi.Screen.SwitchType
>
> Specifies constants for setting the type of Siemens.Engineering.Hmi.Screen.Switch.

## 🛠️ Siemens.Engineering.Hmi.Screen.SymbolLibraryBlinkMode
>
> Specifies constants defining the mode of the flashing of the symbol library.

## 🛠️ Siemens.Engineering.Hmi.Screen.SymbolLibraryColorMode
>
> Specifies constants defining the foreground mode.

## 🛠️ Siemens.Engineering.Hmi.Screen.SymbolLibraryFillStyle
>
> Specifies constants defining the style of the back of the symbol library.

## 🛠️ Siemens.Engineering.Hmi.Screen.SymbolLibraryFlip
>
> Specifies constants defining the flip of the symbol library.

## 🛠️ Siemens.Engineering.Hmi.Screen.SymbolLibraryRotation
>
> Specifies constants defining the rotation of symbol library.

## 🛠️ Siemens.Engineering.Hmi.Screen.SymbolicIOFieldType
>
> Specifies constants for setting the type of Siemens.Engineering.Hmi.Screen.SymbolicIOField.

## 🛠️ Siemens.Engineering.Hmi.Screen.TabObjectTypes
>
> Specifies constants for setting the type of objects in the tab sequence of a Siemens.Engineering.Hmi.Screen.

## 🛠️ Siemens.Engineering.Hmi.Screen.TabSequence
>
> Specifies constants for setting the type of tab sequence in a Siemens.Engineering.Hmi.Screen.

## 🛠️ Siemens.Engineering.Hmi.Screen.TagLoggingTimeUnit
>
> Specifies time units used for tag logging control.

## 🛠️ Siemens.Engineering.Hmi.Screen.TemplateType
>
> Type of template used to display the window contents.

## 🛠️ Siemens.Engineering.Hmi.Screen.TextOrientation
>
> Specifies constants for text orientation.

## 🛠️ Siemens.Engineering.Hmi.Screen.TimeBase
>
> Specifies the time base for displaying data.

## 🛠️ Siemens.Engineering.Hmi.Screen.TimeFormat
>
> Specifies the time format for time stamps displayed in the Siemens.Engineering.Hmi.Screen.TableViewColumn columns.

## 🛠️ Siemens.Engineering.Hmi.Screen.TimeRangeMode
>
> Defines options of specifying the time range.

## 🛠️ Siemens.Engineering.Hmi.Screen.TimeStepBase
>

## 🛠️ Siemens.Engineering.Hmi.Screen.ToolbarPosition
>
> Defines the position of a toolbar inside the control.

## 🛠️ Siemens.Engineering.Hmi.Screen.TrendLineType
>
> Specifies the linetype of a trend.

## 🛠️ Siemens.Engineering.Hmi.Screen.TrendRulerControlType
>

## 🛠️ Siemens.Engineering.Hmi.Screen.TrendType
>
> Specifies the trend type.

## 🛠️ Siemens.Engineering.Hmi.Screen.TrendValueAlignment
>

## 🛠️ Siemens.Engineering.Hmi.Screen.TrendViewTimeAxisMode
>
> Specifies the mode of the time axes in tag logging diagrams.

## 🛠️ Siemens.Engineering.Hmi.Screen.TrendViewToolbarStyle
>
> Specifies the style of the trend view toolbar.

## 🛠️ Siemens.Engineering.Hmi.Screen.UserViewAppearance
>
> Specifies constants for setting the appearance of the Siemens.Engineering.Hmi.Screen.UserView.

## 🛠️ Siemens.Engineering.Hmi.Screen.UserViewViewType
>
> Specifies wich type of view is selected for the userview

## 🛠️ Siemens.Engineering.Hmi.Screen.VerticalAlignment
>
> Specifies constants defining the vertical alignment.

## 🛠️ Siemens.Engineering.Hmi.Screen.VisibilityModes
>
> Defindes the VisibilityModes

## 🛠️ Siemens.Engineering.Hmi.Screen.WinCCStyle
>
> Specifies constants defining the displayed style by the windows objects.

## 🛠️ Siemens.Engineering.Hmi.Screen.WindowContent
>
> Specifies the window content.

## 🛠️ Siemens.Engineering.Hmi.Screen.WindowHeaderStyle
>
> Defines the style of the window header of a control.
