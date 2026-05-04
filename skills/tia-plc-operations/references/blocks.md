# PLC Blocks Reference

Source: TIA Portal Openness V21 — Blocks and Tags (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering.SW;
using Siemens.Engineering.SW.Blocks;
using Siemens.Engineering.SW.ExternalSources;
using Siemens.Engineering.SW.Types;
using Siemens.Engineering.Compiler;
```

## Access entry point

```csharp
using Siemens.Engineering.HW.Features;

SoftwareContainer sc = deviceItem.GetService<SoftwareContainer>();
PlcSoftware plcSoftware = sc?.Software as PlcSoftware;
```

---

## 1. Block group navigation

### Root block group

```csharp
// Root system group — top of the block tree
PlcBlockSystemGroup blockGroup = plcSoftware.BlockGroup;
```

### System block groups (system-generated folders)

```csharp
// Iterate all system block groups and their sub-groups
foreach (PlcSystemBlockGroup systemGroup in plcSoftware.BlockGroup.SystemBlockGroups)
{
    foreach (PlcSystemBlockGroup group in systemGroup.Groups)
    {
        PlcBlockComposition blocks = group.Blocks;
        foreach (PlcBlock block in blocks)
        {
            // process block
        }
    }
}

// Enumerate recursively
PlcSystemBlockGroupComposition systemBlockGroups = plcSoftware.BlockGroup.SystemBlockGroups;
if (systemBlockGroups.Count != 0)
{
    PlcSystemBlockGroup sbSystemGroup = systemBlockGroups[0];
    foreach (PlcSystemBlockGroup group in sbSystemGroup.Groups)
        EnumerateSystemBlockGroups(group);
}

private static void EnumerateSystemBlockGroups(PlcSystemBlockGroup systemBlockGroup)
{
    foreach (PlcSystemBlockGroup group in systemBlockGroup.Groups)
        EnumerateSystemBlockGroups(group); // recursion
}

// Find a specific system subgroup by name
PlcSystemBlockGroup group1 = systemBlockGroup.Groups.Find("User group XYZ");
PlcSystemBlockGroup group2 = group1.Groups.Find("User group ZYX");
```

### User-defined block groups

```csharp
// Enumerate all user groups recursively
foreach (PlcBlockUserGroup blockUserGroup in plcSoftware.BlockGroup.Groups)
    EnumerateBlockUserGroups(blockUserGroup);

private static void EnumerateBlockUserGroups(PlcBlockUserGroup blockUserGroup)
{
    foreach (PlcBlockUserGroup sub in blockUserGroup.Groups)
        EnumerateBlockUserGroups(sub); // recursion
}

// Find a specific user group by name
PlcBlockUserGroupComposition userGroupComposition = plcSoftware.BlockGroup.Groups;
PlcBlockUserGroup myGroup = userGroupComposition.Find("MyUserfolder");
```

---

## 2. Enumerating and finding blocks

```csharp
// All blocks in root
foreach (PlcBlock block in plcSoftware.BlockGroup.Blocks)
{
    // process
}

// Find specific block by name (root group)
PlcBlock block = plcSoftware.BlockGroup.Blocks.Find("MyBlock");

// Find in user group
PlcBlock block = plcSoftware.BlockGroup.Groups.Find("MyFolder").Blocks.Find("MyBlock");
```

---

## 3. Block properties (read)

```csharp
PlcBlock plcBlock = plcSoftware.BlockGroup.Blocks.Find("MyBlock");

DateTime compileDate      = plcBlock.CompileDate;          // UTC
DateTime modifiedDate     = plcBlock.ModifiedDate;         // UTC
bool     isConsistent     = plcBlock.IsConsistent;
int      blockNumber      = plcBlock.Number;
string   blockName        = plcBlock.Name;
ProgrammingLanguage lang  = plcBlock.ProgrammingLanguage;  // program/data blocks only
string   author           = plcBlock.HeaderAuthor;
string   family           = plcBlock.HeaderFamily;
string   userDefinedId    = plcBlock.HeaderName;
System.Version version    = plcBlock.HeaderVersion;
DateTime downloadDate     = plcBlock.DownloadDate;         // read-only
long     loadMemory       = plcBlock.LoadMemoryLength;     // bytes, read-only
long     workMemory       = plcBlock.WorkMemoryLength;     // bytes, read-only
```

`IsConsistent` is true when: block compiled successfully AND not changed since compilation AND no external objects changed that would require re-compilation.

### Header attributes (read/write)

```csharp
block1.HeaderAuthor  = "NewAuthor";
block1.HeaderFamily  = "NewFamily";
block1.HeaderName    = "NewUserDefinedId";
block1.HeaderVersion = new Version(1, 0, 0);
```

### Dynamic attributes (not available on all block types)

```csharp
// OB, FB, FC only
bool isIECCheckEnabled  = (bool)block.GetAttribute("IsIECCheckEnabled");
bool setENOAuto         = (bool)block.GetAttribute("SetENOAutomatically");
block.SetAttribute("SetENOAutomatically", true);

// DB, IDB only (also TechnologicalObject DB)
bool onlyLoadMemory     = (bool)block.GetAttribute("IsOnlyStoredInLoadMemory");
bool writeProtectedInAS = (bool)block.GetAttribute("IsWriteProtectedInAS");
bool opcuaAccessible    = (bool)block.GetAttribute("DBAccessibleFromOPCUA");
```

### SetAttribute / SetAttributes

```csharp
// Single attribute
block.SetAttribute("AutoNumber", false);
block.SetAttribute("Number", 2);
object val = block.GetAttribute("AutoNumber");

// Multiple attributes in one transaction — atomically applied or all rejected
IList<KeyValuePair<string, object>> list = new List<KeyValuePair<string, object>>()
{
    new KeyValuePair<string, object>("DataExchangeMode", OBDataExchangeMode.Synchronous),
    new KeyValuePair<string, object>("SynchronousApplicationCycleTime", (float)69)
};
try
{
    block.SetAttributes(list);
}
catch (EngineeringException e)
{
    Console.WriteLine("Exception: " + e.Message);
}
```

### Multilingual title/comment (PlcType, PlcBlock, TechnologicalInstanceDB)

```csharp
CultureInfo cultureInfo = new CultureInfo("de-DE");
Language language = OpnsProject.LanguageSettings.Languages.Find(cultureInfo);
MultilingualText title = block1.Title;
MultilingualTextItem titleItem = title.Items.Find(language);
Console.WriteLine($"Title in DE: {titleItem.Text}");
titleItem.Text = "New value in DE: Neu";
```

---

## 4. Create and manage block groups

```csharp
// Create user group under root
PlcBlockSystemGroup systemGroup = plcSoftware.BlockGroup;
PlcBlockUserGroupComposition groupComposition = systemGroup.Groups;
PlcBlockUserGroup newGroup = groupComposition.Create("MySubGroupName");

// Rename group
newGroup.SetAttribute("Name", "New_name_of_group");
// or equivalently:
newGroup.Name = "New_name_of_group";

// Delete group (PLC must not be online)
PlcBlockUserGroup group = plcSoftware.BlockGroup.Groups.Find("myGroup");
PlcBlockUserGroup subgroup = group.Groups.Find("myUserGroup");
if (subgroup != null)
    subgroup.Delete();
```

---

## 5. Delete blocks

```csharp
// Iterate in reverse to avoid index shifting when deleting
PlcBlockSystemGroup group = plcSoftware.BlockGroup;
for (int i = group.Blocks.Count - 1; i >= 0; i--)
{
    PlcBlock block = group.Blocks[i];
    if (block != null)
        block.Delete();
}
```

Requirement: PLC must not be online.

---

## 6. Know-how protection (PlcBlockProtectionProvider)

`GetService<PlcBlockProtectionProvider>()` returns non-null only when ALL of:

- Block is know-how protectable
- Block is a code block or global DB
- Block must be compiled
- Block is supported / editable in current PLC
- Block is not in readonly context
- Block is not already know-how protected
- Block is not online
- Block is not a CPU-DB
- Block is not ProDiag or ProDiag-OB
- Block is not an encrypted imported classic block

```csharp
PlcBlock block = ...;
PlcBlockProtectionProvider pp = block.GetService<PlcBlockProtectionProvider>();
if (pp != null)
{
    // Protect
    pp.Protect(password); // SecureString

    // Unprotect
    pp.Unprotect(password);

    // Validate password characters
    IList<char> invalidChars = pp.GetInvalidPasswordCharacters();
}
```

Error cases:

- Protect already-protected block → "You can't protect an already protected object"
- Empty password → "Password was not specified"
- Unprotect already-unprotected block → "You can't unprotect an object without protection"
- Wrong password → "The used password was refused"

---

## 7. Write protection (PlcBlockWriteProtectionProvider)

```csharp
PlcBlock block1 = plcSoftware.BlockGroup.Blocks.Find("Block_1");
var wp = block1.GetService<PlcBlockWriteProtectionProvider>();

SecureString pwd = new SecureString();
pwd.AppendChar('1'); // repeat for each character
pwd.MakeReadOnly();

wp.Define(pwd);       // register password on the service
wp.Protect(pwd);      // write-protect the block
wp.Unprotect(pwd);    // temporarily remove write protection
wp.Change(pwd, null); // permanently remove password and write protection
```

---

## 8. DataBlock snapshots (ValueService)

Requires PLC in Online mode.

```csharp
DataBlock block1 = (DataBlock)plcSoftware.BlockGroup.Blocks.Find("DataBlock_1");

// Create snapshot of current online values
ValueService valueService = block1.Interface.GetService<ValueService>();
valueService.CreateSnapshot();

// Export snapshot
InterfaceSnapshot snap = valueService.GetService<InterfaceSnapshot>();
FileInfo path = new FileInfo(@"C:\temp\snapshot.xml");
snap.Export(path, ExportOptions.None);

// Load snapshot back as actual values (PLC must be Online)
valueService.LoadSnapshotAsActualValues();

// Load start values as actual values (PLC must be Online)
valueService.LoadStartValuesAsActualValues();
```

---

## 9. Compile a block or UDT

```csharp
using Siemens.Engineering.Compiler;

// Compile a single block
CompilerResult result = block.Compile();

// Compile a UDT
CompilerResult result = plcType.Compile();

// Inspect result
if (result.State == CompilerResultState.Error)
{
    Console.WriteLine($"Errors: {result.ErrorCount}");
    foreach (CompilerResultMessage msg in result.Messages)
        Console.WriteLine(msg.Description);
}
```

---

## 10. External source files

### Add an external source file

Supported extensions: `.awl` (STL), `.scl`, `.db`, `.udt`.
Note: accessing groups inside "External source files" folder is NOT supported.

```csharp
PlcExternalSource externalSource =
    plcSoftware.ExternalSourceGroup.ExternalSources.CreateFromFile("SomeBlock.scl");
```

### Generate source from block/UDT

Only STL and SCL supported for blocks; only `.udt` for UDTs.
Exception thrown if: language not STL/SCL, or file of same name already exists.

```csharp
PlcExternalSourceSystemGroup systemGroup = plcSoftware.ExternalSourceGroup;

// Block(s) to source file
var blocks = new List<PlcBlock>() { block1 };
var fileInfo = new FileInfo(@"C:\temp\MyBlock.scl");
systemGroup.GenerateSource(blocks, fileInfo, GenerateOptions.WithDependencies);

// UDT(s) to source file
var types = new List<PlcType>() { udt1 };
var fileInfo = new FileInfo(@"C:\temp\MyType.udt");
systemGroup.GenerateSource(types, fileInfo, GenerateOptions.WithDependencies);
```

`GenerateOptions.None` — generates from provided objects only
`GenerateOptions.WithDependencies` — includes all dependent objects

UTF-8 with BOM required when source contains special characters.

### Generate blocks from external source (simple)

Existing blocks are overwritten. Only ASCII format supported.

```csharp
foreach (PlcExternalSource src in plcSoftware.ExternalSourceGroup.ExternalSources)
{
    src.GenerateBlocksFromSource();
}
```

### Generate blocks from source with error handling (KeepOnError)

```csharp
try
{
    IList<IEngineeringObject> generated =
        externalSource.GenerateBlocksFromSource(GenerateBlockOptions.KeepOnError);

    foreach (IEngineeringObject obj in generated)
    {
        CompilerResult compilerResult = null;
        string objectName = null;

        if (obj is PlcBlock)
        {
            PlcBlock block = (PlcBlock)obj;
            objectName = block.Name;
            compilerResult = block.Compile();
        }
        else if (obj is PlcType)
        {
            PlcType plcType = (PlcType)obj;
            objectName = plcType.Name;
            compilerResult = plcType.Compile();
        }

        if (compilerResult != null && compilerResult.State == CompilerResultState.Error)
        {
            Console.WriteLine($"'{objectName}' failed: {compilerResult.ErrorCount} error(s)");
            foreach (CompilerResultMessage msg in compilerResult.Messages)
                Console.WriteLine(msg.Description);
        }
    }
}
catch (RecoverableException ex)
{
    Console.WriteLine(ex.Message);
}
```

`GenerateBlockOptions.KeepOnError` — no exception thrown, returns list of generated objects (even if errors), does not delete failed objects
`GenerateBlockOptions.None` — throws `RecoverableException` on failure, deletes the generated block/UDT

---

## 11. User data types (UDTs)

### Access

```csharp
PlcTypeSystemGroup typeGroup = plcSoftware.TypeGroup;

// User types
PlcTypeComposition userTypes = typeGroup.Types;
PlcType udt = userTypes.Find("DataTypeName");

// System types
PlcSystemTypeGroup systemTypeGroup = typeGroup.SystemTypeGroups.FirstOrDefault();
```

### Delete UDT

```csharp
PlcType dataType = plcSoftware.TypeGroup.Types.Find("DataTypeName");
if (dataType != null)
    dataType.Delete();
```

Requirement: PLC must not be online.

---

## 12. ProDiag-FB

### Create ProDiag-FB and its IDB

```csharp
PlcBlockGroup blockFolder = plc.BlockGroup;
PlcBlockComposition blockComposition = blockFolder.Blocks;

FB block = blockComposition.CreateFB("ProDiag_Block", isAutoNumber: true, number: 1,
    programmingLanguage: ProgrammingLanguage.ProDiag);

InstanceDB iDbBlock = blockComposition.CreateInstanceDB("ProDiag_IDB",
    isAutoNumber: true, number: 1, instanceOfName: "ProDiag_Block");
```

### Access ProDiag-FB supervisions

```csharp
PlcBlock iDB = plc.BlockGroup.Blocks.Find("FB_Block_DB");
string fbName = iDB.GetAttribute("InstanceOfName").ToString();
FB fb = (FB)plc.BlockGroup.Blocks.Find(fbName);
Console.WriteLine(fb.Supervisions.Count > 0 ? "Has supervisions" : "No supervisions");
```

### Assign ProDiag-FB to IDB

```csharp
PlcBlock instanceDB = blockFolder.Blocks.Find("IDB");
PlcBlock prodiag = blockFolder.Blocks.Find("block_Prodiag");
instanceDB.SetAttribute("AssignedProDiagFB", prodiag.Name);
var assigned = instanceDB.GetAttribute("AssignedProDiagFB");
```

Note: `SetAttributes()` cannot set more than one attribute for ProDiag-FB — throws exception.

### AssignedProDiagFB on DB member and Tag

Valid only for UDT instances in Global DB and Tag Table.
NOT valid for: simple types (int, string), structs, arrays, system types, user/system constants.

```csharp
// Read from DB member (simple UDT instance)
Member member = dataBlock.Interface.Members.Find("SimpleUdtInstanceMember");
object v = member.GetAttribute("AssignedProDiagFB");

// Array element
member = dataBlock.Interface.Members.Find("ArrayUdtMember.ArrayUdtMember[0]");

// Nested struct
member = dataBlock.Interface.Members.Find("structMember.UdtInstanceMember");

// Read from TagTable
PlcTag tag = plc.TagTableGroup.TagTables.Find("Tag_table_1").Tags.Find("Tag_1");
object v2 = tag.GetAttribute("AssignedProDiagFB");

// Write
member.SetAttribute("AssignedProDiagFB", "ProDiagFBName");
tag.SetAttribute("AssignedProDiagFB", "ProDiagFBName");
```

### ProDiag-FB attributes (GetAttribute/GetAttributes)

| Attribute | Type |
|---|---|
| `ProDiagVersion` | Version |
| `InitialValueAcquisition` | bool |
| `UseCentralTimeStamp` | bool |

### Export ProDiag alarm messages (CSV)

```csharp
FB fb = plcBlock as FB;
if (fb != null &&
    fb.ProgrammingLanguage == ProgrammingLanguage.ProDiag &&
    fb.IsConsistent)
{
    DirectoryInfo dir = new DirectoryInfo(Path.Combine(@"D:\Temp\ProDiagInfos", fb.Name));
    fb.ExportProDIAGInfo(dir);
}
```

Output is CSV, openable in Excel. Contains: client alarm ID, supervision ID (hex), priority, supervision category.

---

## 13. Delete external source file

```csharp
PlcExternalSource externalSource =
    plcSoftware.ExternalSourceGroup.ExternalSources.Find("myExternalsource");
externalSource.Delete();
```

Note: accessing groups inside "External source files" is not supported — only root-level sources.
Requirement: PLC must not be online.

---

## 14. Start block / UDT editor (requires TIA Portal UI instance)

```csharp
// Open a block in the block editor
PlcBlock plcBlock = plcSoftware.BlockGroup.Blocks.Find("MyBlock");
plcBlock.ShowInEditor();

// Open a UDT in the UDT editor
PlcTypeComposition types = plcSoftware.TypeGroup.Types;
PlcType udt = types.Find("my_udt");
udt.ShowInEditor();
```

Requirement: TIA Portal instance must be opened with user interface.

---

## 15. Block fingerprints (FingerprintProvider)

Fingerprints detect changes to blocks and UDTs. Available on blocks and UDTs; not on tag tables.
Block must be consistent before calling — otherwise `RecoverableException` is thrown.

```csharp
var block1 = plcSoftware.BlockGroup.Blocks.Find("FBDBlock") as CodeBlock;
FingerprintProvider provider = block1.GetService<FingerprintProvider>();
IList<Fingerprint> fingerprints = provider.GetFingerprints();

foreach (var fingerprint in fingerprints)
{
    string value      = fingerprint.Value;  // checksum string
    FingerprintId id  = fingerprint.Id;
    Console.WriteLine($"Id: {id}  checksum: {value}");
}
```

### FingerprintId values

| Value | What changes it considers |
|---|---|
| `Code` | All code changes inside block body. Ignores compilation result. |
| `Interface` | All interface changes including DB start values. |
| `Properties` | Block property changes (e.g. name, number). |
| `Comments` | Comment changes; for OBs also changes in project language settings. |
| `LibraryType` | Exists when block is connected to a library type. |
| `Texts` | Only for Graph blocks (V15 SP1+). |
| `Alarms` | Exists when block uses alarming. |
| `Supervision` | Exists when block contains supervision. |
| `TechnologyObject` | Only for technology object DBs. |
| `Events` | Only for OBs. |
| `TextualInterface` | Exists when block has a textual interface. |
| `ProgramCode` | Pure code changes — ignores inline/multi-line comments, line breaks, tabs. |

---

## 16. Webserver user-defined pages (WebserverUserDefinedPages)

Accessed as a service on `DeviceItem` (the PLC device item), not on `PlcSoftware`.
Creates DBs that store the web page data. Two overloads:

```csharp
// Simple overload — use stored project attributes for HTML directory and page
var svc = deviceItem.GetService<WebserverUserDefinedPages>();
IList<PlcBlock> blocks = svc.GenerateBlocks(WebDBGenerateOptions.None);

// Full overload — specify HTML directory, default page, app name explicitly
DirectoryInfo htmlDirectory = ...;
FileInfo defaultHTMLPage = ...;
string applicationName = ...;
IList<PlcBlock> blocks = svc.GenerateBlocks(
    htmlDirectory, defaultHTMLPage, applicationName,
    WebDBGenerateOptions.Override);
```

`WebDBGenerateOptions.None` — throws if blocks with same name already exist
`WebDBGenerateOptions.Override` — overwrites existing blocks

To delete the generated DBs, iterate the returned list and call `block.Delete()` on each.

---

## 17. OB block priority attribute

```csharp
PlcBlock obBlock = plcSoftware.BlockGroup.Blocks.Find("CyclicInterrupt");
obBlock.SetAttribute("PriorityNumber", 14);
int priority = (int)obBlock.GetAttribute("PriorityNumber");
```

`PriorityNumber` (Integer, Read/Write) — available on OB blocks in both unit and non-unit programming model.

---

## 18. Generate block/UDT from source into a specific user group

```csharp
// Blocks into a specific user group
PlcBlockUserGroup folder = plc.BlockGroup.Groups.Find("Group_1");

// Without options (throws on error, deletes generated object)
plc.ExternalSourceGroup.ExternalSources.Find("Block_1.scl")
    .GenerateBlocksFromSource(folder, GenerateBlockOption.None);

// With KeepOnError (no exception, returns generated objects)
IList<IEngineeringObject> result =
    plc.ExternalSourceGroup.ExternalSources.Find("Block_1.scl")
       .GenerateBlocksFromSource(folder, GenerateBlockOption.KeepOnError);

// UDTs into a specific type user group
PlcTypeUserGroup typeFolder = plc.TypeGroup.Groups.Find("Group_1");

plc.ExternalSourceGroup.ExternalSources.Find("User_data_type_1.udt")
    .GenerateBlocksFromSource(typeFolder, GenerateBlockOption.None);

plc.ExternalSourceGroup.ExternalSources.Find("User_data_type_1.udt")
    .GenerateBlocksFromSource(typeFolder, GenerateBlockOption.KeepOnError);
```

---

## 19. Generate loadable file for blocks outside of software units

Supported only for PLC1518 (or subtype) with firmware V2.8 or higher. PLC must be compile-clean.

Block restrictions: not a system block, not a PRODIAG block, not a failsafe block, OB must be ProgramCycle type only, no dynamic binding, not a technology object.

```csharp
// Get LoadableProvider service from PlcSoftware
var loadableProviderService = plc.GetService<LoadableProvider>();

var file = new FileInfo(loadablePath);
var blocks = new List<PlcBlock>
{
    plc.BlockGroup.Blocks.Find("Block_1") ?? throw new InvalidOperationException()
};

try
{
    loadableProviderService.GenerateLoadable(file, blocks, TargetOption.Plc);
}
catch (EngineeringTargetInvocationException e)
{
    Console.WriteLine("Generating the loadable file failed.");
    Console.WriteLine(e);
}
```

### TargetOption enum

| Value | Description |
|---|---|
| `TargetOption.None` | Default value — do not use. |
| `TargetOption.Plc` | Generate loadable file for a real PLC. |
| `TargetOption.PlcSim` | Generate loadable file for a simulated PLC. All blocks must have been compiled with simulation support. |

# V21 API Reference

## 🛠️ Siemens.Engineering.SW.Blocks.ArrayDB
>
> Class representing array DBs

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.BlockType
>
> The list of possible IECPL block types

## 🛠️ Siemens.Engineering.SW.Blocks.CodeBlock
>
> Class representing a code block

- 📦 `ExportProDIAGInfo(System.IO.DirectoryInfo)`: Exports prodiag alarm information
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.CodeBlockLibraryType
>
> Class representing a code block library type

- 🔧 `Name`: Name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.CodeBlockLibraryTypeVersion
>
> Class representing a code block library type version

- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.DataBlock
>
> Class representing a data block

- 🔧 `Interface`: Interface to all members of a block
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.FB
>
> Represents an FB

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Supervisions`: Get supervisions
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.FC
>
> Represents an FC

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.GlobalDB
>
> Represents a global DB

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.InstanceDB
>
> Represents an instance DB

- 🔧 `Parent`: EOM parent of this object
- 🔧 `InstanceOfName`: The block name of the father instance (FB/SFB/UDT/SDT)
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.InterfaceSnapshot
>
> Provides Snapshot Value functionality.

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
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of snapshot values.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.MemoryLayout
>
> Determines if a block access is optimized or not

## 🛠️ Siemens.Engineering.SW.Blocks.OB
>
> Represents an OB

- 🔧 `Parent`: EOM parent of this object
- 🔧 `SecondaryType`: Additional information about the type
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.OBDataExchangeMode
>
> Enum for OBDataExchangeMode

## 🛠️ Siemens.Engineering.SW.Blocks.OBExecution
>
> Enum for Execution

## 🛠️ Siemens.Engineering.SW.Blocks.OBTimeMode
>
> Enum for TimeMode

## 🛠️ Siemens.Engineering.SW.Blocks.PlcBlock
>
> Represents a Plc block

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
- 🔧 `Comment`: User-entered comment, can be in multiple languages
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Title`: User-entered title, can be in multiple languages
- 🔧 `AutoNumber`: Determines if the block gets the block number automatically or manually
- 🔧 `CodeModifiedDate`: Last code modification date
- 🔧 `CompileDate`: Last compilation date
- 🔧 `CreationDate`: Creation date of this Plc block
- 🔧 `DownloadDate`: Last download date
- 🔧 `HeaderAuthor`: PLC header attribute author
- 🔧 `HeaderFamily`: PLC header attribute family
- 🔧 `HeaderName`: PLC header attribute name
- 🔧 `HeaderVersion`: PLC header attribute version
- 🔧 `InterfaceModifiedDate`: Last interface modification
- 🔧 `IsConsistent`: True if block and used data is consistent
- 🔧 `IsKnowHowProtected`: Gets the know-how protection status of the block
- 🔧 `LoadMemoryLength`: Length of the load memory required by the block
- 🔧 `MemoryLayout`: Indicates if a block has been optimized
- 🔧 `ModifiedDate`: Last modification date including e.g. comments
- 🔧 `Name`: The name of the Plc block
- 🔧 `Namespace`: The namespace of the given Plc block
- 🔧 `Number`: The number of this Plc block
- 🔧 `ParameterModified`: Date of the last parameter modification
- 🔧 `ProgrammingLanguage`: The language of this block
- 🔧 `StructureModified`: Date of the last structure modification
- 🔧 `WorkMemoryLength`: Length of the work memory required by the block
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a Plc block
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions,Siemens.Engineering.DocumentInfoOptions)`: Simatic ML export of a Plc block
- 📦 `ExportAsDocuments(System.IO.DirectoryInfo,System.String)`: Export documents of a Plc block
- 📦 `ShowInEditor`: Show the indicated item in the Plc block editor
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.PlcBlockAssociation
>
> PLC Block Association

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Blocks.PlcBlock)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Blocks.PlcBlock)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.PlcBlockComposition
>
> Composition of PlcBlocks

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Blocks.PlcBlock)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Blocks.PlcBlock)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create PlcBlock from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.SW.Blocks.CodeBlockLibraryTypeVersion)`: Create PlcBlock from type version
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create PlcBlock from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.SW.Blocks.CodeBlockLibraryTypeVersion,Siemens.Engineering.Library.Types.UpdatePathsMode)`: Create PlcBlock from type version
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a Plc block
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions,Siemens.Engineering.SW.SWImportOptions)`: Simatic ML import of a Plc block with ignore flags.
- 📦 `ImportFromDocuments(System.IO.DirectoryInfo,System.String,Siemens.Engineering.SW.ImportDocumentOptions)`: Create Plc block by importing documents
- 📦 `CreateFB(System.String,System.Boolean,System.Int32,Siemens.Engineering.SW.Blocks.ProgrammingLanguage)`: Creates a block.
- 📦 `CreateInstanceDB(System.String,System.Boolean,System.Int32,System.String)`: Creates an instance DB.
- 📦 `Find(System.String)`: Finds a given Plc block
- 📦 `Find(System.String,System.String)`: Find the given Plc block
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.PlcBlockGroup
>
> Group containing Plc blocks &amp; Plc block user groups

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
- 🔧 `Blocks`: Composition of Plc blocks
- 🔧 `Groups`: Composition of Plc block user groups
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: The name of the Plc block group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.PlcBlockProtectionProvider
>
> Provides protection services.

- 🔧 `Parent`: EOM parent of this object
- 📦 `Protect(System.Security.SecureString)`: Sets protection for the underlying object
- 📦 `Unprotect(System.Security.SecureString)`: Removes protection for the underlying object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.PlcBlockSystemGroup
>
> System group containing Plc blocks &amp; Plc block user groups

- 🔧 `Parent`: EOM parent of this object
- 🔧 `SystemBlockGroups`: Composition of Plc system block groups
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.PlcBlockUserGroup
>
> User group containing Plc blocks &amp; Plc block user groups

- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: The name of the Plc block user group
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.PlcBlockUserGroupComposition
>
> Composition of PlcBlockUserGroups

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Blocks.PlcBlockUserGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Blocks.PlcBlockUserGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create PlcBlockUserGroup from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create PlcBlockUserGroup from MasterCopy
- 📦 `Create(System.String)`: Create PlcBlockUserGroup
- 📦 `Find(System.String)`: Finds a given Plc block user group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.PlcBlockWriteProtectionProvider
>
> Provides write-protection services.

- 🔧 `Parent`: EOM parent of this object
- 🔧 `IsDefined`: Is password defined
- 🔧 `IsProtected`: Is write protection enabled
- 📦 `Change(System.Security.SecureString,System.Security.SecureString)`: Changes the write-protection password for the underlying object
- 📦 `Define(System.Security.SecureString)`: Defines the write-protection password for the underlying object
- 📦 `Protect(System.Security.SecureString)`: Enables write-protection for the underlying object
- 📦 `Unprotect(System.Security.SecureString)`: Disables write-protection for the underlying object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.PlcSystemBlockGroup
>
> Group containing Plc system blocks &amp; Plc system block groups

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
- 🔧 `Blocks`: Composition of Plc system blocks
- 🔧 `Groups`: Composition of Plc system block groups
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: The name of the Plc system block group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.PlcSystemBlockGroupComposition
>
> Composition of PlcSystemBlockGroups

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Blocks.PlcSystemBlockGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Blocks.PlcSystemBlockGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds a given Plc system block group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.ProgrammingLanguage
>
> The list of possible creation languages of programming blocks

## 🛠️ Siemens.Engineering.SW.Blocks.Supervision
>
> Supervision

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
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.SupervisionComposition
>
> Supervisions of the block

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Blocks.Supervision)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Blocks.Supervision)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.Exceptions.DataBlockCreationNotAllowedException
>
> This exception indicates that exception occured during creation of DataBlock.

- 📦 `#ctor`: Initializes a new instance of the <see cref="T:Siemens.Engineering.SW.Blocks.Exceptions.DataBlockCreationNotAllowedException"/> class.
- 📦 `#ctor(System.String)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.SW.Blocks.Exceptions.DataBlockCreationNotAllowedException"/> class.
- 📦 `#ctor(System.String,System.Exception)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.SW.Blocks.Exceptions.DataBlockCreationNotAllowedException"/> class.
- 📦 `#ctor(System.String,System.String[])`: Initializes a new instance of the <see cref="T:Siemens.Engineering.SW.Blocks.Exceptions.DataBlockCreationNotAllowedException"/> class.
- 📦 `#ctor(System.Runtime.Serialization.SerializationInfo,System.Runtime.Serialization.StreamingContext)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.SW.Blocks.Exceptions.DataBlockCreationNotAllowedException"/> class with serialized data.
- 📦 `GetObjectData(System.Runtime.Serialization.SerializationInfo,System.Runtime.Serialization.StreamingContext)`: When overridden in a derived class, sets the <see cref="T:System.Runtime.Serialization.SerializationInfo"/>B with information about the exception.

## 🛠️ Siemens.Engineering.SW.Blocks.Interface.Member
>
> Represents an entry in a block

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
- 🔧 `Name`: Represents the name of the Member
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.Interface.MemberComposition
>
> Gives all the members of a block

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Blocks.Interface.Member)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Blocks.Interface.Member)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds a Block Member by name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.Interface.PlcBlockInterface
>
> Interface for all blocks

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
- 🔧 `Members`: Represents Members of a block
- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Blocks.Interface.ValueService
>
> Provides value functionality.

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
- 📦 `CreateSnapshot`: Create a snapshot of the actual values.
- 📦 `LoadSnapshotAsActualValues`: Loads the snapshot as actual values.
- 📦 `LoadStartValuesAsActualValues`: Loads the start values as actual values.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.DocumentExportResult
>
> Represents the documents export operation result.

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
- 🔧 `Messages`: Returns the messages which are logged during export operation.
- 🔧 `Parent`: EOM parent of this object
- 🔧 `ExportedDocuments`: List of documents which are exported.
- 🔧 `State`: Status of document export operation
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.DocumentImportResult
>
> Represent the documents import operation result.

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
- 🔧 `Messages`: Returns the messages which are logged during import operation.
- 🔧 `Parent`: EOM parent of this object
- 🔧 `State`: Status of document import operation
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.DocumentImportResultForBlocks
>
> Document Import results for Plc Blocks

- 🔧 `Parent`: EOM parent of this object
- 🔧 `ImportedPlcBlocks`: Collection of imported Plc Blocks
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.DocumentImportResultForSplDocument
>
> Document Import results for Named Value Type Documents

- 🔧 `Parent`: EOM parent of this object
- 🔧 `ImportedDocuments`: Collection of imported Document Types
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.DocumentImportResultForTypes
>
> Document Import results for Plc Types

- 🔧 `Parent`: EOM parent of this object
- 🔧 `ImportedPlcTypes`: Collection of imported Plc Types
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.DocumentResultMessage
>
> Message explain about document export/import operation.

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
- 🔧 `Message`: Gets the log message of document export/import.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.DocumentResultMessageComposition
>
> Collection of log message of document export/import.

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.DocumentResultMessage)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.DocumentResultMessage)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.DocumentResultState
>
> Document import/export result state

## 🛠️ Siemens.Engineering.SW.Fingerprint
>
> fingerprint

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
- 🔧 `Id`: ID of the fingerprint
- 🔧 `Value`: fingerprint data
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.FingerprintId
>
> fingerprint id

## 🛠️ Siemens.Engineering.SW.FingerprintProvider
>
> Provides fingerprints.

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
- 📦 `GetFingerprints`: Read Fingerprint
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.ImportDocumentOptions
>
> The list of possible SIMATIC Source document import options

## 🛠️ Siemens.Engineering.SW.PlcChecksumProvider
>
> Provides checksums.

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
- 🔧 `Software`: Software checksum
- 🔧 `TextLists`: Text lists checksum
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.PlcDocument
>
> Document for Blocks or Types

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
- 🔧 `Parent`: Parent of Plc Document
- 🔧 `Name`: Defines the name of the document.
- 📦 `ExportAsDocuments(System.IO.DirectoryInfo,System.String)`: Export Document of PlcDocument
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.PlcDocumentAssociation
>
> Plc Document Association

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.PlcDocument)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.PlcDocument)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.PlcDocumentComposition
>
> Composition for plc document

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.PlcDocument)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.PlcDocument)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create PlcDocument from MasterCopy object
- 📦 `CreateFrom(Siemens.Engineering.SW.Types.PlcDocumentLibraryTypeVersion)`: Creates PlcDocument from PlcDocumentLibraryTypeVersion object.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create PlcDocument from MasterCopy object based on the MasterCopyMode
- 📦 `CreateFrom(Siemens.Engineering.SW.Types.PlcDocumentLibraryTypeVersion,Siemens.Engineering.Library.Types.UpdatePathsMode)`: Creates PlcDocument from PlcDocumentLibraryTypeVersion object based on UpdatePathsMode
- 📦 `ImportFromDocuments(System.IO.DirectoryInfo,System.String,Siemens.Engineering.SW.ImportDocumentOptions)`: Create documents in Tia Portal by importing documents
- 📦 `Find(System.String)`: Find action for plc document compostition
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.PlcSimulationSettingsProvider
>
> Service provider for simulation during block compilation in project

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
- 🔧 `IsSimulationDuringBlockCompilationEnabled`: To indicate whether Support for Simulation during block compilation is enabled for the project
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.PlcSoftware
>
> Represents the software components of a Plc

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 📦 `Siemens#Engineering#IEngineeringServiceProvider#GetServiceInfos`: Returns a collection of EngineeringServiceInfo objects describing the different services on this object.
- 🔧 `BlockGroup`: Gets the Plc block system group
- 🔧 `ExternalSourceGroup`: Gets the Plc external source system group
- 🔧 `PlcAlarmTextlistGroup`: Description for published
- 🔧 `TagTableGroup`: Gets the Plc tag table system group
- 🔧 `TechnologicalObjectGroup`: This system folder can contain technological objects
- 🔧 `TypeGroup`: Gets the Plc type system group
- 🔧 `WatchAndForceTableGroup`: Get the Plc watch table system group
- 🔧 `Name`: The name of the Plc software
- 📦 `CompareTo(Siemens.Engineering.Compare.ISoftwareCompareTarget)`: Compare the PLC software to the given target
- 📦 `CompareToOnline`: Compare the PLC software to the online target
- 📦 `UpdateProgram`: Update PLC program
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.PlcTagProvider
>
> Service provider for obtaining Plc Tag from Channel.

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
- 📦 `GetLinkedTags`: Get Linked Tags from channel
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.ProcessImageProvider
>
> Service provider for AssignProcessImageToOrganizationBlock

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
- 📦 `AssignProcessImageToOrganizationBlock(Siemens.Engineering.SW.Blocks.OB)`: Assign the current process image to the OB.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.SWImportOptions
>
> The list of possible sw importoptions for Import

## 🛠️ Siemens.Engineering.SW.VirtualPlcSettingsProvider
>
> Service provider for virtual plc during block compilation in project

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
- 🔧 `IsVirtualPlcDuringBlockCompilationEnabled`: To indicate whether Support for virtual plc during block compilation is enabled for the project
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Loader.LoadableProvider
>
> Generates loadables files

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
- 📦 `GenerateLoadable(System.IO.FileInfo,System.Collections.Generic.IEnumerable{Siemens.Engineering.SW.Blocks.PlcBlock},Siemens.Engineering.SW.Loader.TargetOption)`: Generates a loadable file for blocks in the non unit program
- 📦 `GenerateLoadable(System.IO.FileInfo,System.Collections.Generic.IEnumerable{Siemens.Engineering.SW.Units.PlcUnit},Siemens.Engineering.SW.Loader.TargetOption)`: Generates a loadable file for software units
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Loader.TargetOption
>
> Target option
