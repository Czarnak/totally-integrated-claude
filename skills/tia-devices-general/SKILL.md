---
name: tia-devices-general
description: >
  C# Openness implementation of device-level operations
license: MIT
---

# tia-devices-general

## Scope

Device-level engineering — full C# Openness implementation.

When the roadmap routes here, the entire solution is C#.
Do not mix with Python wrapper calls.
Always load `tia-csharp-common` first (done by roadmap).

---

## Reference files

Load ONLY the reference file(s) relevant to the task. Do not load all files at once.

| Reference file | Load when the task involves |
|---|---|
| `references/device-enumeration.md` | Listing, finding, or iterating devices; device groups; ungrouped devices; navigating DeviceItems. |
| `references/device-creation.md` | Creating or deleting devices; understanding TypeIdentifier formats (OrderNumber, GSD, System). |
| `references/device-attributes.md` | Reading/writing basic device or device-item attributes; using GsdDevice service; managing Application IDs (CustomIdentityProvider). |
| `references/hardware-parameters.md` | Setting specific hardware parameters via SetAttribute (e.g., IO addresses, diagnostic settings, module-specific enums). |
| `references/software-container.md` | Accessing PlcSoftware or HmiTarget from a device; using the SoftwareContainer service. |
| `references/device-item-operations.md` | Plugging, moving, copying, or deleting device items/modules; changing device/module types; hardware catalog queries. |
| `references/device-item-interfaces.md` | NetworkInterface service; IOController/IOConnector attributes; hardware identifiers; managing addresses and channels. |
| `references/networks-and-connections.md` | Opening hardware/network editors; querying targets from a network perspective; address object attributes. |

For tasks spanning multiple areas, load all relevant reference files before generating code.

---

## Execution pattern

1. Access `Project.Devices` composition (or `DeviceGroups` / `UngroupedDevicesGroup`)
2. Resolve the exact existing object or exact `TypeIdentifier`; never select the first catalog/device/device-item match
3. Before create, plug, move, copy, change-type, attribute write, import, or delete, obtain explicit authorization for the exact project, object identity, and requested mutation
4. Navigate the complete recursive `DeviceItem` hierarchy as needed
5. Access `SoftwareContainer` via `GetService<SoftwareContainer>()` when PLC, classic HMI, or Unified HMI software is needed
6. Put supported project mutations in `ExclusiveAccess` plus a transaction and allow exceptions to roll it back (see `tia-csharp-common`)
7. Use `ICompilable` for hardware or software compile and inspect the full `CompilerResult` (see `tia-project-general/references/compile.md`)
8. Do not save when selection is ambiguous, a service is unavailable, a mutation reports an error, or compile/consistency validation fails
