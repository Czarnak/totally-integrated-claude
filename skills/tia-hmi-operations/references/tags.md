# HMI Tags Reference

Source: TIA Portal Openness V21 — Functions for Accessing HMI Device Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

> **Mutation gate:** resolve the exact tag or table; require explicit authorization before create, import, overwrite, rename, or delete; inventory screen, alarm, script, and connection references before destructive work; compile and inspect errors before committing. Do not call `project.Save()` unless requested.

---

## 1. Create a user-defined folder for HMI tags

Entry point: `hmiTarget.TagFolder` (`TagSystemFolder`)

```csharp
private static void CreateUserfolderForHMITags(HmiTarget hmitarget)
{
    TagSystemFolder folder = hmitarget.TagFolder;
    TagUserFolder myCreatedFolder = folder.Folders.Create("MySubFolder");
}
```

---

## 2. Enumerate tags of an HMI tag table

```csharp
private static void EnumerateTagsInTagtable(HmiTarget hmitarget)
{
    TagTable table = hmitarget.TagFolder.TagTables.Find("MyTagtable");

    // Alternatively, access the default tag table:
    // TagTable defaulttable = hmitarget.TagFolder.DefaultTagTable;

    TagComposition tagComposition = table.Tags;
    foreach (Tag tag in tagComposition)
    {
        // process tag
    }
}
```

---

## 3. Delete an individual tag from an HMI tag table

```csharp
private static void DeleteATag(HmiTarget hmiTarget)
{
    string tagName = "MyTag";
    TagTable defaultTagTable = hmiTarget.TagFolder.DefaultTagTable;
    TagComposition tags = defaultTagTable.Tags;
    Tag tag = tags.Find(tagName);
    tag.Delete();
}
```

---

## 4. Delete a tag table from a folder

> You cannot delete the default tag table.

```csharp
private static void DeleteTagTable(HmiTarget hmiTarget)
{
    string tableName = "myTagTable";
    TagSystemFolder tagSystemFolder = hmiTarget.TagFolder;
    TagTableComposition tagTables = tagSystemFolder.TagTables;
    TagTable tagTable = tagTables.Find(tableName);
    tagTable.Delete();
}
```

## V21 API Reference: Siemens.Engineering.Hmi.Tag

## 🛠️ Siemens.Engineering.Hmi.Tag.AcquisitionModes
>
> Specifies options of setting the mode for acquiring process values from a PLC.

## 🛠️ Siemens.Engineering.Hmi.Tag.AddressAccessModes
>
> Specifies the possible address access modes

## 🛠️ Siemens.Engineering.Hmi.Tag.Codings
>
> Specifies constants for value coding.

## 🛠️ Siemens.Engineering.Hmi.Tag.ConfirmationTypes
>
> Specifies how the user must confirm changes to values.

## 🛠️ Siemens.Engineering.Hmi.Tag.HmiUdtLibraryType
>
> Represents a library type made from a Udt

- 🔧 `Name`: Name

## 🛠️ Siemens.Engineering.Hmi.Tag.HmiUdtLibraryTypeVersion
>
> Represents a library type version made from a Udt

## 🛠️ Siemens.Engineering.Hmi.Tag.RawDataMode
>
> Specifies the possible values for the RawDataMode.

## 🛠️ Siemens.Engineering.Hmi.Tag.SubstituteValueUsage
>
> Specifies constants which define conditions of using substitute values. This enumeration is assigned a flag attribute that enables bit combinations of its associated values.

## 🛠️ Siemens.Engineering.Hmi.Tag.Tag
>
> Represents an Hmi tag

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `Name`: The name of the tag
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a tag
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.Hmi.Tag.TagComposition
>
> Composition of (Hmi)Tags

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Tag.Tag)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Tag.Tag)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create Tag from MasterCopy
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a tag
- 📦 `Find(System.String)`: Finds a given tag

## 🛠️ Siemens.Engineering.Hmi.Tag.TagFolder
>
> Folder containing Hmi tag tables &amp; Hmi tag user folders

- 🔧 `Folders`: Composition of tag user folders
- 🔧 `TagTables`: Composition of Hmi tag tables
- 🔧 `Name`: The name of the tag folder

## 🛠️ Siemens.Engineering.Hmi.Tag.TagSystemFolder
>
> System folder containing Hmi tag tables &amp; Hmi tag user folders

- 🔧 `DefaultTagTable`: Get the default Hmi tag table
- 🔧 `Folders`: Composition of tag user folders
- 🔧 `TagTables`: Composition of Hmi tag tables

## 🛠️ Siemens.Engineering.Hmi.Tag.TagTable
>
> Represents an Hmi tag table

- 🔧 `Tags`: Composition of Hmi tags
- 🔧 `IsSystemObject`: Gets a value that identifies this is the default tag table
- 🔧 `Name`: The name of the tag table
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a tag table
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.Hmi.Tag.TagTableComposition
>
> Composition of (Hmi)TagTables

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Tag.TagTable)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Tag.TagTable)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create TagTable from MasterCopy
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a tag table
- 📦 `Find(System.String)`: Finds a given tag table

## 🛠️ Siemens.Engineering.Hmi.Tag.TagUserFolder
>
> User folder containing Hmi tag tables &amp; Hmi tag user folders

- 🔧 `Folders`: Composition of tag user folders
- 🔧 `TagTables`: Composition of Hmi tag tables
- 🔧 `Name`: The name of the tag user folder
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.Hmi.Tag.TagUserFolderComposition
>
> Composition of (Hmi)TagUserFolders

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Hmi.Tag.TagUserFolder)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Hmi.Tag.TagUserFolder)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Creates a tag user folder
- 📦 `Find(System.String)`: Finds a given tag user folder

## 🛠️ Siemens.Engineering.Hmi.Tag.UpdateMode
>
> Specifies options of defining the mode for updating internal HMI tags.
