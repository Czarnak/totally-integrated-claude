# PLC Tags & Types Reference

Source: TIA Portal Openness V21 — Blocks and Tags (03/2026), chapter 2

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering.SW;
using Siemens.Engineering.SW.Tags;
```

## Access entry point

```csharp
using Siemens.Engineering.HW.Features;

SoftwareContainer sc = deviceItem.GetService<SoftwareContainer>();
PlcSoftware plcSoftware = sc?.Software as PlcSoftware;
```

---

## Object model

| Object | Role |
|---|---|
| `PlcSoftware.TagTableGroup` | Root tag system group (`PlcTagTableSystemGroup`) |
| `PlcTagTableSystemGroup.Groups` | User-defined group composition (`PlcTagTableUserGroupComposition`) |
| `PlcTagTableUserGroup` | A user-defined folder for tag tables |
| `PlcTagTable` | A tag table (user or system) |
| `PlcTagComposition` | Collection of tags in a table (`tagTable.Tags`) |
| `PlcTag` | Individual tag |
| `PlcUserConstantComposition` | User constants in a table (`tagTable.UserConstants`) |
| `PlcUserConstant` | A user-defined constant |
| `PlcSystemConstantComposition` | System constants (`tagTable.SystemConstants`) |

---

## 1. Tag table group navigation

### Access root system group

```csharp
PlcTagTableSystemGroup systemGroup = plcSoftware.TagTableGroup;
```

### Enumerate user-defined groups (recursive)

```csharp
foreach (PlcTagTableUserGroup group in plcSoftware.TagTableGroup.Groups)
    EnumerateTagTableUserGroups(group);

private static void EnumerateTagTableUserGroups(PlcTagTableUserGroup group)
{
    foreach (PlcTagTableUserGroup sub in group.Groups)
        EnumerateTagTableUserGroups(sub); // recursion
}
```

### Find a specific user group by name

```csharp
PlcTagTableUserGroupComposition composition = plcSoftware.TagTableGroup.Groups;
PlcTagTableUserGroup folder = composition.Find("MySubGroupName");
```

Note: `PlcTagTableUserGroup.Name` is read-only in V19 and earlier; read/write in V20+.

---

## 2. Create and delete tag table groups

```csharp
// Create user group under root
PlcTagTableSystemGroup systemGroup = plcSoftware.TagTableGroup;
PlcTagTableUserGroupComposition groupComposition = systemGroup.Groups;
PlcTagTableUserGroup myGroup = groupComposition.Create("MySubGroupName");

// Create nested sub-group
PlcTagTableUserGroup mySubGroup = myGroup.Groups.Create("MySubSubGroupName");

// Delete user group
PlcTagTableUserGroup group = plcSoftware.TagTableGroup.Groups.Find("MySubGroupName");
if (group != null)
    group.Delete();
```

---

## 3. Create, enumerate, find, and delete tag tables

### Create tag table

```csharp
PlcTagTable myTable = plc.TagTableGroup.TagTables.Create("myTable");
```

### Enumerate tag tables

```csharp
// Root-level tables
PlcTagTableComposition tagTables = plcSoftware.TagTableGroup.TagTables;
foreach (PlcTagTable tagTable in tagTables)
{
    // process
}

// Tables inside a user group
PlcTagTableComposition groupTables =
    plcSoftware.TagTableGroup.Groups.Find("UserGroup XYZ").TagTables;
```

### Find tag table by name

```csharp
PlcTagTable table = plcSoftware.TagTableGroup.TagTables.Find("Tag table XYZ");
// or from a user group:
PlcTagTable table = plcSoftware.TagTableGroup.Groups.Find("UserGroup XYZ")
                                .TagTables.Find("Tag table XYZ");
```

### PlcTagTable attributes and actions

**Attributes:**

| Name | Type | Access |
|---|---|---|
| `IsDefault` | bool | Read-only |
| `ModifiedTimeStamp` | DateTime (UTC) | Read-only |
| `Name` | string | Read-only (R/W in V20+) |

**Actions:**

| Name | Return | Description |
|---|---|---|
| `Delete()` | void | Deletes the table. Throws if `IsDefault` is true. |
| `Export()` | void | Exports the tag table as SimaticML. |
| `ShowInEditor()` | void | Opens the table in the PLC Tags editor (requires UI). |

### Read modification timestamp

```csharp
PlcTagTable plcTagTable = plcSoftware.TagTableGroup.TagTables.Find("MyTagTable");
DateTime lastModified = plcTagTable.ModifiedTimeStamp; // UTC
```

### Delete tag table

```csharp
PlcTagTableSystemGroup group = plcSoftware.TagTableGroup;
PlcTagTable tagtable = group.TagTables.Find("MyTagTable");
if (tagtable != null)
    tagtable.Delete(); // throws if IsDefault == true
```

### Open tag table in editor (requires TIA Portal UI)

```csharp
PlcTagTable plcTagTable = plcSoftware.TagTableGroup.TagTables.Find("MyTagTable");
plcTagTable.ShowInEditor();
```

---

## 4. Tags

### Enumerate all tags in a tag table

```csharp
PlcTagTable tagTable = plcSoftware.TagTableGroup.TagTables.Find("Tagtable XYZ");
foreach (PlcTag plcTag in tagTable.Tags)
{
    string name           = plcTag.Name;
    string dataTypeName   = plcTag.DataTypeName;
    string logicalAddress = plcTag.LogicalAddress;
}
```

### Find tag by name

```csharp
PlcTag plcTag = tagTable.Tags.Find("Tag XYZ");
```

### PlcTag attributes

| Attribute name | Data type | Access |
|---|---|---|
| `DataTypeName` | string | Read and Write |
| `ExternalAccessible` | bool | Read and Write |
| `ExternalVisible` | bool | Read and Write |
| `ExternalWritable` | bool | Read and Write |
| `LogicalAddress` | string | Read and Write |
| `Name` | string | Read and Write (V20+; read-only before V20) |
| `IsSafety` | bool | Read and Write |

### Create tags

```csharp
// Create with name only (default attributes)
PlcTag tag = tagTable.Tags.Create("MyTag");

// Create with data type and logical address
PlcTag tag = tagTable.Tags.Create("MyTag", "Bool", "");
// Pass "" for logicalAddress to leave it unassigned
```

### Delete a tag

```csharp
PlcTagTable table = plcSoftware.TagTableGroup.TagTables.Find("myTagTable");
PlcTag tag = table.Tags.Find("MyTag");
if (tag != null)
    tag.Delete();
```

---

## 5. User constants

`PlcUserConstantComposition` is the collection of user constants in a tag table.

**User constant attributes:** `Name` (read-only), `DataTypeName` (R/W), `Value` (R/W)

### Access and find user constants

```csharp
PlcUserConstantComposition userConstants = tagTable.UserConstants;
PlcUserConstant userConstant = userConstants.Find("Constant XYZ");
```

### Create user constant

```csharp
PlcTagTable table = plcSoftware.TagTableGroup.TagTables.Find("myTagTable");
PlcUserConstant userConstant = table.UserConstants.Create("MyConstant");
```

### Delete user constant

```csharp
PlcUserConstant userConstant = table.UserConstants.Find("MyConstant");
if (userConstant != null)
    userConstant.Delete();
```

---

## 6. System constants

`PlcSystemConstantComposition` holds system-generated constants. All attributes are read-only.

**System constant attributes:** `Name` (read-only), `DataTypeName` (read-only), `Value` (read-only)

```csharp
// Access a system constant by name (returns PlcTag)
PlcTag systemConstant = tagTable.SystemConstants.Find("Constant XYZ");
```

# V21 API Reference

## 🛠️ Siemens.Engineering.SW.Tags.PlcConstant
>
> Represents a Plc constant

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
- 🔧 `DataTypeName`: Defines the data type of this constant
- 🔧 `Name`: The name of the Plc constant
- 🔧 `Value`: Defines the value of this constant.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcSystemConstant
>
> Represents a Plc system constant

- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcSystemConstantComposition
>
> Composition of PlcSystemConstants

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Tags.PlcSystemConstant)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Tags.PlcSystemConstant)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds a given Plc system constant
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcTag
>
> Represents a Plc tag

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
- 🔧 `Comment`: The multilingual comment of the PlcTag
- 🔧 `Parent`: EOM parent of this object
- 🔧 `DataTypeName`: Defines the data type of this tag
- 🔧 `ExternalAccessible`: Internal use only
- 🔧 `ExternalVisible`: Indicates whether this tag should be shown when browsing for tags from an HMI editor
- 🔧 `ExternalWritable`: Indicates whether this tag can be written to when browsing for tags from an HMI editor
- 🔧 `IsSafety`: Indicates whether this tag has a failsafe address
- 🔧 `LogicalAddress`: The address in the PLC&apos;s address space
- 🔧 `Name`: The name of the Plc tag
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a Plc tag
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions,Siemens.Engineering.DocumentInfoOptions)`: Simatic ML export of a PlcTag with DocumentInfoOptions
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcTagComposition
>
> Composition of PlcTags

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Tags.PlcTag)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Tags.PlcTag)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create PlcTag from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create PlcTag from MasterCopy
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a Plc tag
- 📦 `Create(System.String)`: Creates a PLC tag from the given parameters
- 📦 `Create(System.String,System.String,System.String)`: Creates a PLC tag from the given parameters
- 📦 `Find(System.String)`: Finds a given Plc tag
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcTagTable
>
> Represents a Plc tag table

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
- 🔧 `SystemConstants`: Composition of Plc system constants
- 🔧 `Tags`: Composition of Plc tags
- 🔧 `UserConstants`: Composition of Plc user constants
- 🔧 `IsDefault`: Indicates if this tag table is the default tag table
- 🔧 `ModifiedTimeStamp`: Represents the last modified timestamp of this tag table
- 🔧 `Name`: The name of the Plc tag table
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a Plc tag table
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions,Siemens.Engineering.DocumentInfoOptions)`: Simatic ML export of a PlcTagTable with DocumentInfoOptions
- 📦 `ShowInEditor`: Show the indicated item in the Plc tag table editor
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcTagTableComposition
>
> Composition of PlcTagTables

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Tags.PlcTagTable)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Tags.PlcTagTable)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create PlcTagTable from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create PlcTagTable from MasterCopy
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a Plc tag table
- 📦 `Create(System.String)`: Creates a tag table from the given parameters
- 📦 `Find(System.String)`: Finds a given Plc tag table
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcTagTableGroup
>
> Group containing Plc tag tables &amp; Plc tag table user groups

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
- 🔧 `Groups`: Composition of Plc tag table user groups
- 🔧 `Parent`: EOM parent of this object
- 🔧 `TagTables`: Composition of Plc tag tables
- 🔧 `Name`: The name of the Plc tag table group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcTagTableSystemGroup
>
> System group containing Plc tag tables &amp; Plc tag table user groups

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcTagTableUserGroup
>
> User group containing Plc tag tables &amp; Plc tag table user groups

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: The name of the Plc tag table user group
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcTagTableUserGroupComposition
>
> Composition of PlcTagTableUserGroups

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Tags.PlcTagTableUserGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Tags.PlcTagTableUserGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create PlcTagTableUserGroup from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create PlcTagTableUserGroup from MasterCopy
- 📦 `Create(System.String)`: Create user folder for PLC tag collection
- 📦 `Find(System.String)`: Finds a given Plc tag table user group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcUserConstant
>
> Represents a Plc user constant

- 🔧 `Comment`: The comment of the user constant
- 🔧 `DataTypeName`: Defines the data type of this constant
- 🔧 `Name`: The name of the Plc constant
- 🔧 `Value`: Defines the value of this constant.
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a Plc constant
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions,Siemens.Engineering.DocumentInfoOptions)`: Simatic ML export of a PlcUserConstant with DocumentInfoOptions
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Tags.PlcUserConstantComposition
>
> Composition of PlcUserConstants

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Tags.PlcUserConstant)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Tags.PlcUserConstant)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create PlcUserConstant from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create PlcUserConstant from MasterCopy
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a Plc constant
- 📦 `Create(System.String)`: Creates a plc user constant from the given parameters
- 📦 `Create(System.String,System.String,System.String)`: Creates a plc user constant from the given parameters
- 📦 `Find(System.String)`: Finds a given Plc user constant
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcDocumentLibraryType
>
> Represents a library type made from a Plc Document type

- 🔧 `Name`: Name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcDocumentLibraryTypeVersion
>
> Represents a library type version made from a Plc Document type

- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcStruct
>
> Represents a Plc struct

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcSystemTypeGroup
>
> Group containing Plc system types

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
- 🔧 `Types`: Composition of Plc system types
- 🔧 `Name`: The name of the Plc system type group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcSystemTypeGroupComposition
>
> Composition of PlcSystemTypeGroups

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Types.PlcSystemTypeGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Types.PlcSystemTypeGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcType
>
> Represents a Plc type

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
- 🔧 `Comment`: Get the user entered comment, can be multi lingual
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Title`: Get the user entered title, can be multi lingual
- 🔧 `CreationDate`: Creation date of this Plc type
- 🔧 `InterfaceModifiedDate`: Get last breakable interface change of the PLC data type
- 🔧 `IsConsistent`: True if block and used data is consistent
- 🔧 `IsKnowHowProtected`: Gets the know-how protection status of the block
- 🔧 `ModifiedDate`: Get the last non-breakable modification of the PLC data type
- 🔧 `Name`: The name of the Plc type
- 🔧 `Namespace`: The namespace of the given Plc type
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a Plc type
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions,Siemens.Engineering.DocumentInfoOptions)`: Simatic ML export of a Plc type
- 📦 `ExportAsDocuments(System.IO.DirectoryInfo,System.String)`: Export documents of a Plc type
- 📦 `ShowInEditor`: Show the indicated item in the Plc type editor
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcTypeAssociation
>
> PLC Type Association

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Types.PlcType)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Types.PlcType)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcTypeComposition
>
> Composition of PlcTypes

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Types.PlcType)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Types.PlcType)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create PlcType from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.SW.Types.PlcTypeLibraryTypeVersion)`: Create PlcType from type version
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create PlcType from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.SW.Types.PlcTypeLibraryTypeVersion,Siemens.Engineering.Library.Types.UpdatePathsMode)`: Create PlcType from type version
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a Plc type
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions,Siemens.Engineering.SW.SWImportOptions)`: Simatic ML import of a Plc type
- 📦 `ImportFromDocuments(System.IO.DirectoryInfo,System.String,Siemens.Engineering.SW.ImportDocumentOptions)`: Create Plc type by importing documents
- 📦 `Find(System.String)`: Finds a given Plc type
- 📦 `Find(System.String,System.String)`: Find the given Plc type
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcTypeGroup
>
> Group containing Plc types &amp; Plc type user groups

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
- 🔧 `Documents`: Composition of Plc Document
- 🔧 `Groups`: Composition of Plc type user groups
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Types`: Composition of Plc types
- 🔧 `Name`: The name of the Plc type group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcTypeLibraryType
>
> Represents a library type made from a Plc type

- 🔧 `Name`: Name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcTypeLibraryTypeVersion
>
> Represents a library type version made from a Plc type

- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcTypeSystemGroup
>
> System group containing Plc types &amp; Plc type user groups

- 🔧 `Parent`: EOM parent of this object
- 🔧 `SystemTypeGroups`: Composition of system data types
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcTypeUserGroup
>
> User group containing Plc types &amp; Plc type user groups

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: The name of the Plc type user group
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Types.PlcTypeUserGroupComposition
>
> Composition of PlcTypeUserGroups

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Types.PlcTypeUserGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Types.PlcTypeUserGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create PlcTypeUserGroup from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create PlcTypeUserGroup from MasterCopy
- 📦 `Create(System.String)`: Create the user folder for the PLC data type collection
- 📦 `Find(System.String)`: Finds a given Plc type user group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
