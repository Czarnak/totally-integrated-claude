---
name: tia-simatic-drives
description: >
  Routed by tia-openness-roadmap. Handles drive-specific engineering: Startdrive, SINAMICS,
  SIMATIC Drive Controller, PROFIdrive integrated properties, drive telegrams, and integrated
  drive configuration. Always uses C# TIA Portal Openness.
---

# tia-simatic-drives

## Scope

Startdrive and drive-specific engineering — full C# Openness implementation.

When the roadmap routes here, the entire solution is C#.
Do not mix with Python wrapper calls.
Always load `tia-csharp-common` first (done by roadmap).

---

## Reference files

| Reference file | Load when the task involves |
|---|---|
| `references/drives-overview.md` | Core patterns for Startdrive/SINAMICS engineering (Navigate, Parameters, Telegrams, DFI, Safety, Security) |
| `references/motion-control.md` | Detailed reference for `Siemens.Engineering.MC` namespaces (Drives, DFI, SecurityObjects, Enums) |
| `references/download.md` | Startdrive-specific and common Download/Upload check configurations |

---

## Execution pattern

1. Confirm the task is drive-specific (Startdrive, SINAMICS, drive controller, PROFIdrive)
2. Read `references/drives-overview.md`
3. Locate the drive device in `project.Devices` using standard device navigation
4. Get `DriveObjectContainer` via `GetService<>()` on the device item to access `DriveObject`s
5. Use `DriveObject.Parameters` for parameter access, `.Telegrams` for telegram find/insert/erase/size operations
6. Use `GetService<DriveFunctionInterface>()` for commissioning, motor/encoder config, DFI, and drive-object activation/type handling
7. For download/upload handling, include Startdrive-specific check configurations from `Siemens.Engineering.Download.Configurations` and `Siemens.Engineering.Upload.Configurations`
8. For network/PROFIdrive timing — see `tia-networks/references/subnets-and-nodes.md`
