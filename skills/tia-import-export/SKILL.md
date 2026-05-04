---
name: tia-import-export
description: >
  Routed by tia-openness-roadmap. C# Openness implementation of import/export and round-trip
  engineering: XML, SimaticML, AML, CAx, choosing between file-based exchange and direct
  object-model editing, bulk import/export, folder structure planning, overwrite behavior,
  and object-specific import/export compositions.
---

# tia-import-export

## Scope

Import/export strategy and round-trip design — full C# Openness implementation.

When the roadmap routes here, the entire solution is C#.
Do not mix with Python wrapper calls.

## Use this skill for

- choosing direct object edits vs import/export
- XML / SimaticML / AML / CAx strategy
- bulk engineering changes
- export granularity
- folder-structure planning
- overwrite behavior
- project / HMI / PLC / library round-trip workflows
- object-specific import/export compositions
- mixed import + low-level object-model editing

## Execution pattern

1. identify target object class and Openness composition
2. identify exchange format (SimaticML, AML, XML)
3. decide file-based vs direct-edit approach
4. define source root / target root / overwrite / structure
5. use Openness import/export services on the correct composition
6. compile relevant hardware/software after import
7. validate consistency state

## Reference files

Load ONLY the reference file(s) relevant to the task. Do not load all files at once.

| Reference file | Load when the task involves |
|---|---|
| `references/overview.md` | general import/export principles, ExportOptions/ImportOptions enums, open references, SIMATIC ML versioning, exportable object matrix |
| `references/hmi-screens.md` | exporting or importing HMI screens, screen templates, pop-up screens, slide-in screens, permanent areas, faceplate instances |
| `references/hmi-tags-and-data.md` | HMI tag tables, individual HMI tags, cycles, connections, text lists, graphic lists, VB scripts, special HMI tag considerations (integrated connection, UDT) |
| `references/plc-blocks.md` | PLC block export/import (FB, FC, OB, DB), UDTs, know-how protection, failsafe blocks, system blocks, GRAPH, snapshots, instance DB creation, DB value access, OPC UA XML export, document export/import, open-reference and structural-change import |
| `references/plc-alarms-and-tags.md` | PLC tag tables, individual PLC tags/constants, alarm classes, PLC alarm text lists (XLSX), ProDiag supervisions, watch tables, force tables |
| `references/hardware-aml.md` | CAx/AML export and import, CaxProvider service, project-level vs device-level transfer, CaxImportOptions, TransferResult, type identifiers, AML structure |
| `references/project-data.md` | project-level texts export/import (XLSX), project graphics export/import |
