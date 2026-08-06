---
name: tia-simatic-drives
description: >
  Routed by tia-openness-roadmap. Handles drive-specific engineering: Startdrive, SINAMICS,
  SIMATIC Drive Controller, PROFIdrive integrated properties, drive telegrams, and integrated
  drive configuration. Always uses C# TIA Portal Openness.
license: MIT
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
| `references/api-catalogue.md` | Complete inventory of all 64 public types in the installed V21 Startdrive module |

---

## Execution pattern

1. Confirm the task is drive-specific (Startdrive, SINAMICS, drive controller, PROFIdrive)
2. Read `references/drives-overview.md`
3. Resolve the drive device and drive object using exact selectors; recursively traverse nested device items and fail on zero or ambiguous matches
4. Get `DriveObjectContainer` via `GetService<>()` on the device item to access `DriveObject`s
5. Use `DriveObject.Parameters` for parameter access, `.Telegrams` for telegram find/insert/erase/size operations
6. Use `GetService<DriveFunctionInterface>()` for commissioning, motor/encoder config, DFI, and drive-object activation/type handling
7. For download/upload handling, include Startdrive-specific check configurations from `Siemens.Engineering.Download.Configurations` and `Siemens.Engineering.Upload.Configurations`
8. For network/PROFIdrive timing — see `tia-networks/references/subnets-and-nodes.md`

## Safety boundary

- Require explicit live-operation authorization for online parameter writes, download/upload, factory reset, RAM-to-ROM copy, drive encryption/UMAC changes, and Safety commissioning.
- Require explicit mutation authorization for offline parameters, telegrams, drive-object type/activation, motor/encoder projection, Technology Extension install/uninstall, and report overwrite.
- Bind exact selectors to the project, device, nested `DeviceItem`, drive-object number, parameter name/number/index, telegram type, and requested value. Never use `.First()`, `[0]`, or catalog-order assumptions.
- Inventory current parameters, telegrams, topology, safety/security state, Technology Extensions, and dependent PLC/HMI configuration before mutation. Factory reset, encryption deactivation, forced package removal, and telegram deletion are destructive.
- Inspect every boolean result and every download/upload configuration. Unknown or unsupported configurations fail closed; never approve all checks automatically.
- Secrets must arrive as `SecureString` from the caller's approved secret source. Never embed, print, persist, or reconstruct passwords in examples.
- Do not save: call `project.Save()` only when persistence was explicitly requested and post-change verification succeeded.
- Static API checks are not commissioning evidence. Online state, firmware/device support, Safety acceptance, and successful drive behavior require an authorized live V21 test.
