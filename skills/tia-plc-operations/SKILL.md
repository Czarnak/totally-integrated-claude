---
name: tia-plc-operations
description: >
  Routed by tia-openness-roadmap. C# Openness implementation of PLC software engineering:
  program blocks, system blocks, PLC tags and tag tables, user data types, external sources,
  watch and force tables, technology objects, software units, know-how protection,
  SafetyAdministration, PLC online/offline control, download, upload, compare-to-online,
  PLC compile, PLC import/export, master secret, and certificate/security services.
---

# tia-plc-operations

## Scope
PLC software engineering — full C# Openness implementation.

When the roadmap routes here, the entire solution is C#.
Do not mix with Python wrapper calls.
Always load `tia-csharp-common` first (done by roadmap).

---

## Reference files

Load ONLY the reference file(s) relevant to the task. Do not load all files at once.

| Reference file | Load when the task involves | 
| --- | --- | 
| `references/online-status.md` | Going online/offline, reading PLC state, configuring connection parameters, `OnlineProvider`, `OnlineState`, `ConnectionConfiguration` | 
| `references/compare.md` | Comparing PLC software or hardware, `CompareResult`, `CompareResultState`, `CompareToOnline`, `UpdateProgram` | 
| `references/blocks.md` | Program blocks, system blocks, external sources, know-how/write protection, block groups, ProDiag-FB, DataBlock snapshots, compile individual block/UDT, fingerprints, webserver pages, OB priority, loadable file | 
| `references/tags-types.md` | PLC tag tables, tags, user constants, system constants, UDT group navigation | 
| `references/software-units.md` | Software units (`PlcUnit`), `PlcUnitProvider`, unit relations, unit access/publish, external sources in units, units as mastercopies, namespaces, name value type documents, loadable file for units | 
| `references/safety-unit.md` | Fail-safe unit (`PlcSafetyUnit`), SafetyUnit access, safety relations, publish safety blocks, supervision export/import | 

For tasks spanning multiple areas, load all relevant reference files before generating code.

---

## Stub behaviour

If a task targets a partial reference file, do not invent API calls.
State clearly which sections are missing. The only remaining stub is import/export
signatures in `compile-import-export.md` — all other files are complete.

---

## Execution pattern

1. Access `PlcSoftware` via device's `SoftwareContainer`
2. Identify which reference file(s) cover the task — load them
3. Navigate Openness object model per reference file patterns
4. For online work: use `OnlineProvider` service on the CPU `DeviceItem` (see `online-status.md`)
5. For compare: use `CompareTo` / `CompareToOnline` on `PlcSoftware` or `Device` (see `compare.md`)
6. For software units: access via `PlcUnitProvider` service on `PlcSoftware` (see `software-units.md`)
7. For safety unit: access via `PlcUnitProvider.UnitGroup.SafetyUnits` (see `safety-unit.md`)

## Access pattern (always needed)

```csharp
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.SW;

// From a DeviceItem (CPU)
SoftwareContainer sc = deviceItem.GetService<SoftwareContainer>();
PlcSoftware plcSoftware = sc?.Software as PlcSoftware;
```