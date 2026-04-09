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
