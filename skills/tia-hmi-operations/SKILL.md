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

| Reference file | Load when the task involves |
|---|---|
| `references/hmi-target.md` | Getting the HmiTarget from a device; compiling HMI; HMI object model overview; which namespace covers which HMI composition |
| `references/screens.md` | Creating screen folders; deleting screens, screen templates, or all screens from a folder; deleting a user-defined screen folder |
| `references/composition-hierarchy.md` | Complete screen composition tree (popups, slideins, templates, global elements); connections; attribute-based configuration; screen element configuration enums |
| `references/tags.md` | Creating HMI tag table folders; enumerating tags; deleting individual tags or tag tables |
| `references/scripts-cycles-connections.md` | VB script folders and deletion; deleting cycles, connections, text lists, graphic lists |

---

## Execution pattern

1. Locate the HMI device in `project.Devices`
2. Access `HmiTarget` via `SoftwareContainer` (see `references/hmi-target.md`)
3. Classify the task: tags, screens, alarms, scripts, import/export, compile
4. Navigate the relevant composition on `HmiTarget`
5. For Unified devices, use Unified-specific namespaces and object areas
6. Use `ICompilable` for HMI compile (see `tia-project-general/references/compile.md`)
