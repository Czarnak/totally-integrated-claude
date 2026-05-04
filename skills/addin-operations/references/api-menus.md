# TIA Portal Add-In — Menu API Reference

Source: TIA Portal Add-In Development Tools Manual (V21)

This reference covers the `Siemens.Engineering.AddIn.Menu` namespace and related providers, used for creating context menu entries in various TIA Portal editors.

## Menu Providers

To register a context menu Add-In, you must implement one or more of these providers:

- `ProjectTreeAddInProvider`: Adds entries to the Project tree.
- `ProjectLibraryTreeAddInProvider`: Adds entries to the Project library tree.
- `GlobalLibraryTreeAddInProvider`: Adds entries to Global libraries.
- `DevicesAndNetworksAddInProvider`: Adds entries to the Devices & networks editor.
- `VciEditorAddInProvider`: Adds entries to the VCI workspace editor.

## Core Classes

### ContextMenuAddIn
>
> Base class for all context menu Add-Ins.

- `BuildContextMenuItems(ContextMenuAddInRoot root)`: Override this to define the menu structure.
- `DisplayName`: The name displayed in the Add-Ins management view.

### ActionItem<T>
>
> Represents a single clickable menu entry.

- `OnClickDelegate`: The method called when the item is clicked.
- `OnUpdateStatusDelegate`: The method called to determine if the item is enabled/disabled/visible.
- `DefaultLabelText`: The text shown in the menu.
- `Icon`: The icon shown next to the text.

### Submenu
>
> Represents a menu item that contains other items.

- `Items`: Collection of contained menu items.

### MenuSelectionProvider<T>
>
> Provides access to the objects selected by the user when they right-clicked.

- `GetSelection()`: Returns the collection of selected objects of type `T`.
- `GetSelectedObjectCount()`: Returns the number of selected objects.

## Menu Status

Used in `OnUpdateStatusDelegate` to control item state:

- `MenuStatus.Enabled`: Item is visible and clickable.
- `MenuStatus.Disabled`: Item is visible but greyed out.
- `MenuStatus.Hidden`: Item is not visible.

## Styles

### CheckBoxActionItemStyle

- `State`: `Checked`, `Unchecked`, or `Indeterminate`.

### RadioButtonActionItemStyle

- `State`: `Selected` or `Unselected`.

## Factory Methods (ChildItemFactory)

Used within `BuildContextMenuItems` or when building submenus via the `root` or `Submenu` items:

- `AddSubmenu(string label)`
- `AddActionItem<T>(string label, OnClickDelegate click, OnUpdateStatusDelegate status)`
- `AddActionItemWithCheckBox<T>(...)`
- `AddActionItemWithRadioButton<T>(...)`
- `AddActionItemWithIcon<T>(string label, Icon icon, ...)`

## V21 Detailed Class Map

### ActionItem Variants

- `ActionItem<T1>`: For single-type selection.
- `ActionItem<T1, T2>`: For dual-type selection.
- `ActionItem<T1, T2, T3>`: For triple-type selection.

### ChildItemFactory Methods

- `AddActionItem<T>(...)`
- `AddActionItemWithCheckBox<T>(...)`
- `AddActionItemWithRadioButton<T>(...)`
- `AddActionItemWithIcon<T>(...)`
- `ValidateIconSize(Icon)`: Ensures icon doesn't exceed max size.
- `GetIconMemorySize(Icon)`: Calculates memory usage in KB.
