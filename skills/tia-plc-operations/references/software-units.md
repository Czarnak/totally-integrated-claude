# PLC Software Units Reference

Source: TIA Portal Openness V21 — Functions for software units (03/2026), chapter 1

> C# only. Do not mix with Python wrapper calls.
> Units are not modelled statically in the object model — always access via PlcUnitProvider service.

---

## Namespaces

```csharp
using Siemens.Engineering.SW;
using Siemens.Engineering.SW.Units;
using Siemens.Engineering.SW.Blocks;
using Siemens.Engineering.SW.Tags;
using Siemens.Engineering.SW.Types;
```

## Access entry point

```csharp
using Siemens.Engineering.HW.Features;

SoftwareContainer sc = deviceItem.GetService<SoftwareContainer>();
PlcSoftware plcSoftware = sc?.Software as PlcSoftware;

// Units are accessed via service — not directly on PlcSoftware
PlcUnitProvider unitProvider = plcSoftware.GetService<PlcUnitProvider>();
PlcUnitComposition unitComposition = unitProvider.UnitGroup.Units;
```

---

## PlcUnit properties and methods

| Attribute | Type | Access |
|---|---|---|
| `Author` | string | Read/Write |
| `Name` | string | Read/Write |
| `NamespacePreset` | string | Read/Write |
| `Comment` | MultilingualText | Read (items writable) |

| Method | Return | Description |
|---|---|---|
| `Export()` | void | Export the unit |
| `Delete()` | void | Delete the unit |
| `GetAttributes(list)` | IList\<object\> | Get attribute values |
| `SetAttributes(list)` | void | Set attribute values |

Sub-objects accessible on `PlcUnit` (same API as on `PlcSoftware`):

- `unit.BlockGroup` — `PlcBlockSystemGroup`
- `unit.TagTableGroup` — `PlcTagTableSystemGroup`
- `unit.TypeGroup` — `PlcTypeSystemGroup`
- `unit.ExternalSourceGroup` — `PlcExternalSourceSystemGroup`
- `unit.Relations` — `PlcUnitRelationComposition`

---

## 1. Access and find units

```csharp
// Find a specific unit by name
PlcUnit unit = unitProvider.UnitGroup.Units.Find("Unit_1");

// Iterate all units
foreach (PlcUnit u in unitProvider.UnitGroup.Units)
{
    Console.WriteLine(u.Name);
}

// Index access
PlcUnit firstUnit = unitProvider.UnitGroup.Units[0];
```

---

## 2. Create, delete, rename units

```csharp
// Create
PlcUnit unit1 = unitComposition.Create("Unit_1");
// Error if name already exists: RecoverableException "Unit with name 'Unit1' already exists"
// Error if name starts with space or has invalid chars: RecoverableException

// Delete
unitProvider.UnitGroup.Units.Find("Unit_1").Delete();
// NullReferenceException if Find() returns null — guard with null check

// Rename — three equivalent ways
unit1.Name = "Unit1_new";
unit1.SetAttributes(new List<KeyValuePair<string, object>>
{
    new KeyValuePair<string, object>("Name", "Unit2_new")
});
((IEngineeringObject)unit1).SetAttribute("Name", "Unit2_new");
```

---

## 3. Access underlying objects

```csharp
// Blocks under the unit
PlcBlockComposition blocks = unit.BlockGroup.Blocks;
foreach (PlcBlock block in blocks) { /* ... */ }

PlcBlockUserGroupComposition blockGroups = unit.BlockGroup.Groups;
foreach (PlcBlockUserGroup group in blockGroups)
{
    foreach (PlcBlock block in group.Blocks) { /* ... */ }
}

// UDTs under the unit
PlcTypeComposition types = unit.TypeGroup.Types;
foreach (PlcType type in types) { /* ... */ }

PlcTypeUserGroupComposition typeGroups = unit.TypeGroup.Groups;

// Tag tables under the unit
PlcTagTableComposition tagTables = unit.TagTableGroup.TagTables;
foreach (PlcTagTable table in tagTables) { /* ... */ }

PlcTagTableUserGroupComposition tagTableGroups = unit.TagTableGroup.Groups;
```

---

## 4. Unit relations

Relations control cross-unit accessibility. A unit can reference objects in other units or outside units.

### Relation attributes

| Attribute | Type | Description |
|---|---|---|
| `RelationType` | `UnitRelationType` | Type of relation |
| `RelatedObject` | string | Name of the accessible element |

### UnitRelationType enum

| Value | Meaning |
|---|---|
| `SoftwareUnit` | Relation to another software unit |
| `NonUnitDB` | Relation to a DB outside units |
| `TODB` | Relation to a technology object DB |

### Access existing relations

```csharp
PlcUnitRelationComposition relations = unit.Relations;

// By iteration
foreach (PlcUnitRelation relation in relations)
{
    UnitRelationType type = relation.RelationType;
    string relatedObj    = relation.RelatedObject;
}

// By index
PlcUnitRelation rel = unit.Relations[1];

// By related object name
PlcUnitRelation found = unit.Relations.Find("Unit_2");
```

### Create relations

```csharp
// Access another software unit
PlcUnitRelation r1 = unit.Relations.Create("Unit_2", UnitRelationType.SoftwareUnit);

// Access a global DB outside units
PlcUnitRelation r2 = unit.Relations.Create("DB_Global", UnitRelationType.NonUnitDB);

// Access a technology object DB
PlcUnitRelation r3 = unit.Relations.Create("Axis_TO", UnitRelationType.TODB);
```

### Delete relations

```csharp
unit.Relations[0].Delete();          // by index
m_SoftwareUnitRelation.Delete();     // direct reference
```

### Modify relations

```csharp
// Update related object name
relation.RelatedObject = "Unit_3";
((IEngineeringObject)relation).SetAttribute("RelatedObject", "Unit_4");
relation.SetAttributes(new List<KeyValuePair<string, object>>
{
    new KeyValuePair<string, object>("RelatedObject", "Unit_4")
});
```

Note: creating a relation to a non-existing object does not throw — the relation is created silently. Leading spaces or invalid TIA naming causes a `RecoverableException`.

---

## 5. Update unit properties

```csharp
// Author
unit1.Author = "Z012345";
unit1.SetAttributes(new List<KeyValuePair<string, object>>
{
    new KeyValuePair<string, object>("Author", "Z012345")
});

// Comment — cannot use SetAttribute("Comment", ...) — throws EngineeringNotSupportedException
// Must set via MultilingualText.Items (indexed by project language, 0 = default)
unit1.Comment.Items[0].Text = "new Comment";
unit1.Comment.Items[1].Text = "neuro Kommentar"; // second project language
```

---

## 6. Publish (Access attribute on unit objects)

Controls whether blocks and UDTs inside a unit are accessible from outside it.
The `Access` attribute is only on objects **inside** a unit — not on the unit itself.
Supported object types: program blocks and data blocks (except OBs), PLC types.
System generated blocks are excluded. Throws `EngineeringNotSupportedException` if accessed on non-unit objects.

```csharp
// Read Access on a block inside a unit
PlcBlock block = unit.BlockGroup.Blocks.Find("FB_1");
UnitAccessType access = (UnitAccessType)block.GetAttribute("Access");

// Write Access
block.SetAttribute("Access", UnitAccessType.Published);
block.SetAttributes(new List<KeyValuePair<string, object>>
{
    new KeyValuePair<string, object>("Access", UnitAccessType.Published)
});

// Same pattern on a UDT
PlcType type = unit.TypeGroup.Types.Find("UDT_1");
type.SetAttribute("Access", UnitAccessType.Published);
```

`UnitAccessType` enum: `Published`, `Unpublished`

---

## 7. External sources in units

Same API as on `PlcSoftware`. Supported formats: `.scl`, `.db`, `.udt`.

```csharp
// Add external source file to a unit
PlcExternalSource src =
    unit.ExternalSourceGroup.ExternalSources.CreateFromFile(GetFilePath(filename));

// Generate blocks from source (void return, throws on error)
src.GenerateBlocksFromSource();

// Generate with KeepOnError
IList<IEngineeringObject> generated =
    src.GenerateBlocksFromSource(GenerateBlockOption.None);
// or
IList<IEngineeringObject> generated =
    src.GenerateBlocksFromSource(GenerateBlockOption.KeepOnError);

// Generate source from blocks in the unit
PlcBlock unitBlock = unit.BlockGroup.Blocks.Find("MyBlock");
unit.ExternalSourceGroup.GenerateSource(
    new[] { unitBlock },
    new FileInfo(outputPath),
    GenerateOptions.WithDependencies);

// Generate source from UDTs in the unit
PlcType unitUdt = unit.TypeGroup.Types.Find("MyUDT");
unit.ExternalSourceGroup.GenerateSource(
    new[] { unitUdt },
    new FileInfo(outputPath),
    GenerateOptions.None);

// Enumerate external sources
PlcExternalSourceComposition srcComp = unit.ExternalSourceGroup.ExternalSources;
foreach (PlcExternalSource s in srcComp)
    s.GenerateBlocksFromSource(GenerateBlockOption.None);
```

---

## 8. Units as mastercopies

```csharp
// Cast unit to IMasterCopySource
IMasterCopySource unitAsMasterCopy = (IMasterCopySource)unit;

// Save to project library
project.ProjectLibrary.MasterCopyFolder.MasterCopies.Create(unitAsMasterCopy);

// Save to global library (must be opened ReadWrite)
tiaPortal.GlobalLibraries.Open(libFile, OpenMode.ReadWrite);
GlobalLibrary globalLib = tiaPortal.GlobalLibraries[0];
globalLib.MasterCopyFolder.MasterCopies.Create(unitAsMasterCopy);
// Error if library is read-only: RecoverableException "Cannot write to read-only libraries"

// Recreate unit from project library mastercopy
MasterCopy mc = project.ProjectLibrary.MasterCopyFolder.MasterCopies.Find("Unit_2");
unitComposition.CreateFrom(mc);

// Recreate unit from global library mastercopy
MasterCopy mc2 = globalLib.MasterCopyFolder.MasterCopies.Find("Unit_2");
unitComposition.CreateFrom(mc2);
```

---

## 9. Name value type document

Name value type documents (`.nvt`) are accessed via `unit.TypeGroup.Documents`.

```csharp
PlcDocumentComposition docComp = unit.TypeGroup.Documents;
PlcDocument doc = docComp[0];
// or
PlcDocument doc = docComp.Find("Named_Value_Type_1");

// PlcDocument.Name is read-only (available from V20)
string name = doc.Name;
```

---

## 10. Namespaces

### Unit namespace

```csharp
// Get/set via property
unit.NamespacePreset = "Siemens.Simatic";
string ns = unit.NamespacePreset;
```

### Block namespace (within a unit)

Namespace is exported/imported with the block via SimaticML.

```csharp
// Via GetAttribute / SetAttribute (cast required for SetAttribute)
var ns = unitBlock.GetAttribute("Namespace");
unitBlock.SetAttribute("Namespace", "Unit.Siemens");
```

SimaticML representation: `<Namespace>Siemens.Simatic</Namespace>` inside the block's `AttributeList`.

### UDT namespace (within a unit)

```csharp
// Via property
unitUDT.Namespace = "Motor";
string ns = unitUDT.Namespace;

// Via GetAttribute
var ns = unitUDT.GetAttribute("Namespace");
```

SimaticML representation: `<Namespace>Siemens</Namespace>` inside the UDT's `AttributeList`.

---

## 11. Generate loadable file for software units

Supported only for PLC1518 (or subtype) with firmware V2.8+. PLC must be compile-clean.

Unit restrictions: must not contain system blocks, ProDiag blocks, failsafe blocks, OBs other than ProgramCycle, blocks with dynamic binding, technology objects, or user data types.

```csharp
var loadableProviderService = plcSoftware.GetService<LoadableProvider>();

var file = new FileInfo(loadablePath);
var unitProvider = plcSoftware.GetService<PlcUnitProvider>();
var units = new List<PlcUnit>
{
    unitProvider.UnitGroup.Units.Find("Unit_1") ?? throw new InvalidOperationException()
};

try
{
    loadableProviderService.GenerateLoadable(file, units, TargetOption.PlcSim);
}
catch (EngineeringTargetInvocationException e)
{
    Console.WriteLine("Generating the loadable file failed.");
    Console.WriteLine(e);
}
```

`TargetOption` enum — same values as for blocks: `None` (do not use), `Plc` (real PLC), `PlcSim` (simulated PLC, requires simulation support compilation).

# V21 API Reference

## 🛠️ Siemens.Engineering.SW.Units.PlcUnit
>
> Represents a Plc unit

- 🔧 `Parent`: EOM parent of this object
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Units.PlcUnitBase
>
> Base class for software unit

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
- 🔧 `BlockGroup`: Gets the Plc block system group
- 🔧 `Comment`: The comment of the software unit
- 🔧 `ExternalSourceGroup`: Gets software unit external source group
- 🔧 `Parent`: EOM parent of this object
- 🔧 `PlcAlarmTextlistGroup`: Group for alarming related objects
- 🔧 `Relations`: Gets the software unit relations
- 🔧 `TagTableGroup`: Gets the Plc tag table system group
- 🔧 `TypeGroup`: Gets the Plc type system group
- 🔧 `Author`: The author of the Plc unit
- 🔧 `Name`: The name of the Plc unit
- 🔧 `NamespacePreset`: The namespace of software unit
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Units.PlcUnitComposition
>
> Composition of Plc units

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Units.PlcUnit)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Units.PlcUnit)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create a Plc unit from a master copy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create a Plc unit from a master copy
- 📦 `Create(System.String)`: Creates a Plc unit
- 📦 `Find(System.String)`: Find a Plc unit by name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Units.PlcUnitProvider
>
> Provides Plc units

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
- 🔧 `UnitGroup`: Gets the Plc unit system group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Units.PlcUnitRelation
>
> Represents a unit relation

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
- 🔧 `RelatedObject`: Related object of the relation
- 🔧 `RelationType`: Unit relation type which allowed to access
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Units.PlcUnitRelationComposition
>
> Composition of Plc unit relations

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Units.PlcUnitRelation)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Units.PlcUnitRelation)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String,Siemens.Engineering.SW.Units.UnitRelationType)`: Create an unit relation
- 📦 `Find(System.String)`: Find a Plc unit relation by the name of the related object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Units.PlcUnitSystemGroup
>
> System group containing Plc units

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
- 🔧 `SafetyUnits`: Composition of Safety Units
- 🔧 `Units`: Composition of Plc units
- 🔧 `Name`: The name of Software units group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Units.UnitAccessType
>
> Unit accessibility type

## 🛠️ Siemens.Engineering.SW.Units.UnitRelationType
>
> Relation types in Unit relation editor
