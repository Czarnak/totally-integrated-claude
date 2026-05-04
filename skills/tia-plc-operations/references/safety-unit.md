# PLC Safety Unit Reference

Source: TIA Portal Openness V21 — Functions for fail-safe unit (03/2026), chapter 2

> C# only. Do not mix with Python wrapper calls.
> SafetyUnit is a system-generated, one-and-only unit. It cannot be created or deleted via Openness.
> Only available on fail-safe PLCs that support software units.

---

## Namespaces

```csharp
using Siemens.Engineering.SW;
using Siemens.Engineering.SW.Units;
using Siemens.Engineering.SW.Blocks;
using Siemens.Engineering.SW.Tags;
```

## Access entry point

```csharp
using Siemens.Engineering.HW.Features;

SoftwareContainer sc = deviceItem.GetService<SoftwareContainer>();
PlcSoftware plcSoftware = sc?.Software as PlcSoftware;

PlcUnitProvider unitProvider = plcSoftware.GetService<PlcUnitProvider>();
```

---

## 1. Generating the fail-safe unit environment

The SafetyUnit is auto-created when a new fail-safe PLC with software unit support is created.
Controlled via two settings on the `GlobalSettings` service (obtained from `TiaPortal`):

```csharp
GlobalSettings globalSettings = myTiaPortal.GetService<GlobalSettings>();

// --- Default fail-safe program under standard PLC ---
// Get current setting
bool isDefault = globalSettings.GenerationOfDefaultFailsafeProgram();

// Enable/disable generation of default fail-safe program for new PLC
globalSettings.GenerationOfDefaultFailsafeProgram(true);

// --- SafetyUnit environment (fail-safe program hosted in a Safety Unit) ---
// Get current setting
bool isSafetyUnitEnabled = globalSettings.ManagementOfFailsafeInSoftwareUnitsEnvironment();

// Enable/disable hosting fail-safe program within a Safety Unit
globalSettings.ManagementOfFailsafeInSoftwareUnitsEnvironment(true);
```

---

## 2. Accessing the SafetyUnit

`SafetyUnit` is accessed through `PlcUnitProvider.UnitGroup.SafetyUnits` (type `PlcSafetyUnitComposition`).
It is a **read-only** composition — `Create()` is not accessible and throws a compile error if called.

```csharp
PlcUnitProvider unitProvider = plcSoftware.GetService<PlcUnitProvider>();

// Access the safety unit composition
PlcSafetyUnitComposition safetyUnits = unitProvider.UnitGroup.SafetyUnits;

// Find the SafetyUnit by name
PlcSafetyUnit safetyUnit = safetyUnits.Find("SafetyUnit");
```

`PlcSafetyUnit` exposes the same sub-objects as `PlcUnit`:

- `safetyUnit.BlockGroup`
- `safetyUnit.TagTableGroup`
- `safetyUnit.TypeGroup`
- `safetyUnit.Relations`

---

## 3. SafetyUnit relations

Same API as standard unit relations — TOs and GlobalDBs can be created/deleted the same way.

```csharp
// Create relation
var relation = safetyUnit.Relations.Create("Unit_1", UnitRelationType.SoftwareUnit);

// Delete relation
relation.Delete();
```

`UnitRelationType` enum: `SoftwareUnit`, `NonUnitDB`, `TODB`

---

## 4. SafetyUnit elements — create, access, export, import

Blocks, tags, and UDTs under the SafetyUnit use the same API as in standard units.
Exception: **fail-safe system generated blocks** are excluded — accessing their `Access` attribute throws a runtime exception.

```csharp
// Create tag table and tags
var tagTable = safetyUnit.TagTableGroup.TagTables.Create("Tag_Table_1");
var newTag = tagTable.Tags.Create("tag_1");
newTag.Delete();
var found = tagTable.Tags.Find("tag_1");

// Export a block (SimaticML)
var block = safetyUnit.BlockGroup.Blocks.Find("Block_2");
block.Export(new FileInfo(@"D:\Export\SafetyBlock_unit.xml"), ExportOptions.None);

// Import a block
safetyUnit.BlockGroup.Blocks.Import(
    new FileInfo(@"C:\Users\user\Desktop\Block1.xml"),
    ImportOptions.Override);
```

---

## 5. Export/import supervisions under SafetyUnit

Supervisions are exported/imported as Excel (`.xlsx`).
Two access paths: from a **ProDiag FB** inside the SafetyUnit, or from the **SafetyUnit** itself.

```csharp
string filePath = @"E:\Temp\...\fileName.xlsx";

// --- Via ProDiag block ---
var proDiagBlock = safetyUnit.BlockGroup.Blocks.CreateFB(
    "Block_1", true, 1, ProgrammingLanguage.ProDiag);
var proDiagProvider = proDiagBlock.GetService<SupervisionProvider>();

// Export supervisions
proDiagProvider.ExportSupervisionsToXlsx(new FileInfo(filePath));

// Import supervisions
ImportOptions importOptions = ImportOptions.None;
proDiagProvider.ImportSupervisionsFromXlsx(new FileInfo(filePath), importOptions);

// --- Via SafetyUnit (global supervision provider) ---
var globalProvider = safetyUnit.GetService<SupervisionProvider>();

// Export
globalProvider.ExportSupervisionsToXlsx(new FileInfo(filePath));

// Import supervisions
globalProvider.ImportSupervisionsFromXlsx(new FileInfo(filePath), importOptions);

// Import supervision settings only
globalProvider.ImportSupervisionSettingsFromXlsx(new FileInfo(filePath), importOptions);
```

**Restrictions on SafetyUnit:**

- Cannot create, delete, or copy a stand-alone SafetyUnit via Openness
- Cannot download/upload SafetyUnit via Openness
- Cannot copy the hosted SafetyUnit into project/global library mastercopy

---

## 6. Publishing blocks under the SafetyUnit

Same `Access` attribute pattern as in standard units. System generated blocks are excluded — accessing their attribute throws a runtime exception.

```csharp
PlcSafetyUnit safetyUnit = unitProvider.UnitGroup.SafetyUnits.Find("SafetyUnit");
var safetyBlock = safetyUnit.BlockGroup.Blocks.Find("Block_2");

// Publish
safetyBlock.SetAttribute("Access", UnitAccessType.Published);

// Check access type
var access = safetyBlock.GetAttribute("Access");
```

`UnitAccessType` enum: `Published`, `Unpublished`

# V21 API Reference

## 🛠️ Siemens.Engineering.SW.Units.PlcSafetyUnit
>
> Represents a Plc safety unit

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.SW.Units.PlcSafetyUnitComposition
>
> Composition of safety unit

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Units.PlcSafetyUnit)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Units.PlcSafetyUnit)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds the Safety Unit By name
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
