---
name: tia-hmi-operations
description: >
  Routed by tia-openness-roadmap. C# Openness implementation of HMI engineering: HMI tags
  and tag tables, screens and screen items, templates, popup and slide-in screens, scripts,
  cycles, alarms and alarm classes, connections, text lists, graphic lists, HMI import/export,
  HMI compile, Unified runtime settings, logs, events, dynamization, and plant model.
---

# tia-hmi-operations

## Scope
HMI engineering — full C# Openness implementation.

When the roadmap routes here, the entire solution is C#.
Do not mix with Python wrapper calls.
Always load `tia-csharp-common` first (done by roadmap).

---

## Reference files

Load ONLY the reference file(s) relevant to the task. Do not load all files at once.

### Classic WinCC (WinCC.dll — `HmiTarget`)

| Reference file | Load when the task involves |
|---|---|
| `references/hmi-target.md` | Getting the HmiTarget from a device; compiling HMI; HMI object model overview; which namespace covers which HMI composition |
| `references/screens.md` | Creating screen folders; deleting screens, screen templates, or all screens from a folder; deleting a user-defined screen folder |
| `references/composition-hierarchy.md` | Complete screen composition tree (popups, slideins, templates, global elements); connections; attribute-based configuration; screen element configuration enums |
| `references/tags.md` | Creating HMI tag table folders; enumerating tags; deleting individual tags or tag tables |
| `references/scripts-cycles-connections.md` | VB script folders and deletion; deleting cycles, connections, text lists, graphic lists |

### WinCC Unified (WinCCUnified.dll — `HmiSoftware`)

| Reference file | Load when the task involves |
|---|---|
| `references/unified-overview.md` | Getting `HmiSoftware` entry point; full composition map; import/export patterns; required namespaces |
| `references/unified-tags-alarms.md` | Unified tags, tag tables, tag groups; alarm classes, discrete/analog alarms; audit classes; OPC UA alarms |
| `references/unified-screens-elements.md` | Unified screens, screen groups; screen items (shapes, widgets, controls); dynamization; event handlers; parts; feature interfaces |
| `references/unified-logging-connections.md` | Data/alarm logs, audit trails; logging tags; connections; runtime settings; scripts; text/graphic lists; plant model (CPM) |

---

## Execution pattern

1. Locate the HMI device in `project.Devices`
2. Determine Classic vs Unified:
   - **Classic:** `HmiTarget hmi = sc?.Software as HmiTarget` (namespace: `Siemens.Engineering.Hmi`)
   - **Unified:** `HmiSoftware hmi = sc?.Software as HmiSoftware` (namespace: `Siemens.Engineering.HmiUnified`)
3. Classify the task: tags, screens, alarms, scripts, logging, import/export, compile
4. Load the relevant reference file (Classic or Unified) and navigate the composition
5. Use `ICompilable` for HMI compile (see `tia-project-general/references/compile.md`)
