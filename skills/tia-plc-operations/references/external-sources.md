# EXTERNAL SOURCES

# V21 API Reference

## 🛠️ Siemens.Engineering.SW.ExternalSources.GenerateBlockOption
>
> Lists the possible options for block generation from source

## 🛠️ Siemens.Engineering.SW.ExternalSources.GenerateOptions
>
> Options for source generation

## 🛠️ Siemens.Engineering.SW.ExternalSources.IGenerateSource
>
> Can generate source.

## 🛠️ Siemens.Engineering.SW.ExternalSources.PlcExternalSource
>
> Represents a Plc external source

- 🔧 `Name`: The name of the Plc external source
- 📦 `GenerateBlocksFromSource`: Creates a block or blocks from the current source file object
- 📦 `GenerateBlocksFromSource(Siemens.Engineering.SW.ExternalSources.GenerateBlockOption)`: Creates a block or blocks from the current source file object
- 📦 `GenerateBlocksFromSource(Siemens.Engineering.SW.Blocks.PlcBlockUserGroup,Siemens.Engineering.SW.ExternalSources.GenerateBlockOption)`: Creates a block or blocks from the current source file object under block user group
- 📦 `GenerateBlocksFromSource(Siemens.Engineering.SW.Types.PlcTypeUserGroup,Siemens.Engineering.SW.ExternalSources.GenerateBlockOption)`: Creates a type or types from the current source file object under type user groups
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.ExternalSources.PlcExternalSourceComposition
>
> Composition of PlcExternalSources

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.ExternalSources.PlcExternalSource)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.ExternalSources.PlcExternalSource)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create External Source from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create External Source from MasterCopy
- 📦 `CreateFromFile(System.String,System.String)`: Create an external source from a specified file
- 📦 `Find(System.String)`: Finds a given Plc external source

## 🛠️ Siemens.Engineering.SW.ExternalSources.PlcExternalSourceGroup
>
> Group containing Plc external sources &amp; Plc external source user groups

- 🔧 `ExternalSources`: Composition of Plc external sources
- 🔧 `Groups`: Composition of Plc external source user groups
- 🔧 `Name`: The name of the Plc external source group

## 🛠️ Siemens.Engineering.SW.ExternalSources.PlcExternalSourceSystemGroup
>
> System group containing Plc external sources &amp; Plc external source user groups

- 📦 `GenerateSource(System.Collections.Generic.IEnumerable{Siemens.Engineering.SW.ExternalSources.IGenerateSource},System.IO.FileInfo)`: Generates source file.
- 📦 `GenerateSource(System.Collections.Generic.IEnumerable{Siemens.Engineering.SW.ExternalSources.IGenerateSource},System.IO.FileInfo,Siemens.Engineering.SW.ExternalSources.GenerateOptions)`: Generates source file.

## 🛠️ Siemens.Engineering.SW.ExternalSources.PlcExternalSourceUserGroup
>
> User group containing Plc external sources &amp; Plc external source user groups

- 🔧 `Name`: The name of the Plc external source user group
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.ExternalSources.PlcExternalSourceUserGroupComposition
>
> Composition of PlcExternalSourceUserGroups

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.ExternalSources.PlcExternalSourceUserGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.ExternalSources.PlcExternalSourceUserGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create ExternalSourceUserGroup from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create ExternalSourceUserGroup from MasterCopy
- 📦 `Create(System.String)`: Creates a MasterCopy
- 📦 `Find(System.String)`: Finds a given Plc external source user group
