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

| Reference file | When to use |
|---|---|
| `references/hmi-target.md` | **Initialize/Compile:** Getting the `HmiTarget` from a device; compiling HMI; HMI object model overview; namespace-to-composition mapping. |
| `references/screens.md` | **Screens:** Creating and managing screen folders; deleting screens, screen templates, or entire folder contents. |
| `references/hmi-composition-hierarchy.md` | **Screen Items & Alarms:** Complete screen composition tree (popups, slideins, templates, global elements); screen item attributes; Alarms, Recipes, and Reports API. |
| `references/tags.md` | **Tags:** Creating HMI tag table folders; enumerating tags; deleting individual tags or tag tables. |
| `references/scripts-cycles-connections.md` | **Services:** Managing VB scripts and folders; cycles, connections, text lists, and graphic lists. |

### WinCC Unified (WinCCUnified.dll — `HmiSoftware`)

| Reference file | When to use |
|---|---|
| `references/unified-overview.md` | **Initialize/Overview:** Getting `HmiSoftware` entry point; full composition map; required namespaces. |
| `references/unified-tags-alarms.md` | **Tags & Alarms:** Unified tags, tag tables, groups; alarm classes, discrete/analog alarms; audit classes. |
| `references/unified-screens.md` | **Screens:** Unified screen hierarchy, groups, folders; ScreenBase, ScreenGroup, and ScreenWindow navigation. |
| `references/unified-elements.md` | **Screen Items:** Creating/finding shapes (circles, lines) and widgets (buttons, IO fields, gauges). |
| `references/unified-parts.md` | **UI Components:** Complex parts like DataGrids, AlarmViews, TrendAreas, and ControlBar elements. |
| `references/unified-dynamization.md` | **Dynamization:** Scripting, Tag/Expression dynamization; MappingTables; flashing conditions. |
| `references/unified-events.md` | **Event Handlers:** Subscribing to UI events (OnClick, OnChange) for all screen item types. |
| `references/unified-features.md` | **Features:** UI feature interfaces (IHmiArcFeature, IHmiWindowFeature, IHmiScaleFeature). |
| `references/unified-logging.md` | **Logging:** Data logs, alarm logs, audit trails, and logging tags. |
| `references/unified-connections.md` | **Connections:** HMI connections and driver properties. |
| `references/unified-runtime-settings.md` | **Runtime:** Reporting, Telemetry, OpcUaServer, and UI Runtime resource settings. |
| `references/unified-plant-model.md` | **Plant Model:** Plant Objects, Views, Interfaces, and CPM services. |
| `references/unified-system-services.md` | **Services:** JavaScript modules/scripts; Text and Graphic lists. |
| `references/unified-enums.md` | **Enums:** Comprehensive list of HMI-specific enums (AggregationMode, FillPattern, FontName, etc.). |

---

## Execution pattern

1. Locate the HMI device in `project.Devices`
2. Determine Classic vs Unified:
   - **Classic:** `HmiTarget hmi = sc?.Software as HmiTarget` (namespace: `Siemens.Engineering.Hmi`)
   - **Unified:** `HmiSoftware hmi = sc?.Software as HmiSoftware` (namespace: `Siemens.Engineering.HmiUnified`)
3. Classify the task: tags, screens, alarms, scripts, logging, import/export, compile
4. Load the relevant reference file (Classic or Unified) and navigate the composition
5. Use `ICompilable` for HMI compile (see `tia-project-general/references/compile.md`)
