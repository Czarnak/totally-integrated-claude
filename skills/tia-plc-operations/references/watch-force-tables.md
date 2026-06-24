# WATCH FORCE-TABLES

# V21 API Reference

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcForceTable
>
> Represents a Plc force table

- 🔧 `Entries`: Composition of ForceTable Entries
- 🔧 `IsConsistent`: Table is consistent or not
- 🔧 `Name`: Name of the ForceTable
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a Plc force table
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions,Siemens.Engineering.DocumentInfoOptions)`: Simatic ML export of a PlcForceTable
- 📦 `ShowInEditor`: Show the indicated item in the Plc force table editor

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcForceTableComposition
>
> Composition of PlcForceTables

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.WatchAndForceTables.PlcForceTable)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.WatchAndForceTables.PlcForceTable)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Import Plc force table from Simatic ML
- 📦 `Find(System.String)`: Find force table by name

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcForceTableEntry
>
> Represents a Plc force table entry

- 🔧 `Address`: Address information of the tag
- 🔧 `DisplayFormat`: DisplayFormat
- 🔧 `ForceIntention`: Force intention of the user
- 🔧 `ForceValue`: The value that shall be forced
- 🔧 `MonitorTrigger`: The trigger used for monitoring
- 🔧 `Name`: Name of the tag

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcTableCommentEntry
>
> Represents a Plc Force\Watch table comment entry

- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcTableCommentEntryComposition
>
> Represents a Plc Force\Watch table comment entries

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.WatchAndForceTables.PlcTableCommentEntry)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.WatchAndForceTables.PlcTableCommentEntry)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create`: Creates a TableCommentEntry

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcWatchAndForceTableDisplayFormat
>
> Enum for DisplayFormat

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcWatchAndForceTableGroup
>
> Group contatining Plc watch tables

- 🔧 `ForceTables`: Composition of PlcWatchTables
- 🔧 `Groups`: Composition of User Groups
- 🔧 `WatchTables`: Composition of PlcWatchTables
- 🔧 `Name`: The name of the Plc watch table group

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcWatchAndForceTablePreDefinedTrigger
>
> Enum for PreDefinedTrigger

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcWatchAndForceTableSystemGroup
>
> System group containing Plc watch tables and Plc force tables and user group containing these

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcWatchAndForceTableUserGroup
>
> User group containing Plc watch tables

- 🔧 `Name`: Name of the User Group
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcWatchAndForceTableUserGroupComposition
>
> Composition of PlcWatchTableUserGroups

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.WatchAndForceTables.PlcWatchAndForceTableUserGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.WatchAndForceTables.PlcWatchAndForceTableUserGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create PlcBlockUserGroup from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create PlcBlockUserGroup from MasterCopy
- 📦 `Create(System.String)`: Creates user folder for Plc watch and forcetable collection
- 📦 `Find(System.String)`: Finds given Plc watch table user group

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcWatchTable
>
> Represents a Plc watch table

- 🔧 `Entries`: Composition of WatchTable Entries
- 🔧 `IsConsistent`: Table is consistent or not
- 🔧 `Name`: Name of the WatchTable
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a Plc watch table
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions,Siemens.Engineering.DocumentInfoOptions)`: Simatic ML export of a PlcWatchTable
- 📦 `ShowInEditor`: Show the indicated item in the Plc watch table editor
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcWatchTableComposition
>
> Composition of PlcWatchTables

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.WatchAndForceTables.PlcWatchTable)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.WatchAndForceTables.PlcWatchTable)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Import Plc watch table from Simatic ML
- 📦 `Create(System.String)`: Creates a watch table from the given parameters
- 📦 `Find(System.String)`: Finds a given Plc watch table

## 🛠️ Siemens.Engineering.SW.WatchAndForceTables.PlcWatchTableEntry
>
> Represents a Plc watch table entry

- 🔧 `Address`: Address
- 🔧 `DisplayFormat`: DisplayFormat
- 🔧 `ModifyIntention`: The user&apos;s modify intention
- 🔧 `ModifyTrigger`: The trigger used for modify
- 🔧 `ModifyValue`: The value that shall be used for modify.
- 🔧 `MonitorTrigger`: The trigger used for monitoring.
- 🔧 `Name`: Name
