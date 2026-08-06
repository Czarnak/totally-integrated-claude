---
name: tia-plc-operations
description: C# Openness implementation of PLC software engineering.
license: MIT
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
| `references/fingerprint-data.md` | V21 quick-station fingerprint retrieval, `FingerprintDataProvider`, online/TLS/password callback handling, and fingerprint comparison limits |
| `references/download-upload.md` | Live PLC download and station upload, `DownloadProvider`, `StationUploadProvider`, callback configurations, fail-closed target handling |
| `references/compare.md` | Comparing PLC software or hardware, `CompareResult`, `CompareResultState`, `CompareToOnline`, `UpdateProgram` |
| `references/blocks.md` | Program blocks, system blocks, `PlcSoftware` root, know-how/write protection, block groups, ProDiag-FB, DataBlock snapshots, compile individual block/UDT, fingerprints, webserver pages, OB priority, loadable file |
| `references/external-sources.md` | PLC external source files, importing/generating blocks from sources, `PlcExternalSource`, `PlcExternalSourceGroup` |
| `references/tags-types.md` | PLC tag tables, tags, user constants, system constants, UDTs, PLC types, UDT group navigation |
| `references/software-units.md` | Software units (`PlcUnit`), `PlcUnitProvider`, unit relations, unit access/publish, namespaces, name value type documents |
| `references/safety-unit.md` | Fail-safe unit (`PlcSafetyUnit`), SafetyUnit access, safety relations, publish safety blocks |
| `references/safety-administration.md` | Global safety settings, `SafetyAdministration`, safety signature, safety system version, safety runtime groups, safety validation assistant |
| `references/alarms.md` | PLC alarms, alarm classes, alarm text lists, `PlcAlarmTextProvider` |
| `references/technological-objects.md` | Technological Objects (TOs), motion control, axes, encoders, TO mapping, hardware connections |
| `references/watch-force-tables.md` | Watch tables, force tables, `PlcWatchTable`, `PlcForceTable`, watch entries |
| `references/opc-ua.md` | OPC UA server interfaces, OPC UA communication groups, access control, role mapping |
| `references/supervision.md` | Supervision settings, supervision provider, supervision export/import |

For tasks spanning multiple areas, load all relevant reference files before generating code.

---

## Stub behaviour

If a task targets a partial reference file, do not invent API calls.
State clearly which sections are missing.

## Live-operation safety

Treat every live TIA Portal or hardware action as unavailable until the user
has explicitly authorized the exact portal instance, project, CPU, and action.
A build, stub, offline project, or simulated test is not live evidence. Never
infer permission for a download, force, online write, or snapshot load from a
request to inspect, compile, compare, or generate code.

Before an authorized live action, report the resolved target and current
online state, preserve whether this client established the connection, and
disconnect only a connection this client opened. Keep destructive offline
changes inside `ExclusiveAccess` plus a `Transaction` where supported; compile
and verify before saving. Use the deletion safeguards from
`tia-csharp-common` for every `Delete()` example in the references.

---

## Execution pattern

1. Access `PlcSoftware` via device's `SoftwareContainer`
2. Identify which reference file(s) cover the task — load them
3. Navigate Openness object model per reference file patterns
4. For online work: use `OnlineProvider` service on the CPU `DeviceItem` (see `online-status.md`)
5. For download/upload: require explicit live authorization, resolve the exact target, and fail closed on unhandled callbacks (see `download-upload.md`)
6. For compare: use `CompareTo` / `CompareToOnline` on `PlcSoftware` or `Device` (see `compare.md`)
7. For software units: access via `PlcUnitProvider` service on `PlcSoftware` (see `software-units.md`)
8. For safety unit: access via `PlcUnitProvider.UnitGroup.SafetyUnits` (see `safety-unit.md`)

## Access pattern (always needed)

```csharp
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.SW;

// From a DeviceItem (CPU)
SoftwareContainer sc = deviceItem.GetService<SoftwareContainer>();
PlcSoftware plcSoftware = sc?.Software as PlcSoftware;
```
