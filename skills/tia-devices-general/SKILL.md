---
name: tia-devices-general
description: >
  Routed by tia-openness-roadmap. C# Openness implementation of device-level operations:
  enumerating devices, creating and deleting devices, plugging and moving device items,
  slot/subslot/module manipulation, hardware identifiers, addresses, channels, compiling
  hardware and software, device properties, and software container traversal.
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
| `references/device-enumeration.md` | Listing, finding, or iterating devices; device groups; ungrouped devices; navigating DeviceItems |
| `references/device-creation.md` | Creating or deleting devices; TypeIdentifier format (OrderNumber, GSD, System) |
| `references/device-attributes.md` | Reading/writing device or device-item attributes; GsdDevice service; CustomIdentityProvider (App IDs); hardware catalog queries |
| `references/software-container.md` | Accessing PlcSoftware or HmiTarget from a device; SoftwareContainer service; dynamic object structure discovery |
| `references/device-item-operations.md` | Plugging, moving, copying, or deleting device items; enumerating device items; changing device/module type; module information and plug locations; bulk SetAttributes; PSC file export; extension rack connections; telecontrol datapoint CSV export/import; user-defined logo settings |
| `references/device-item-interfaces.md` | NetworkInterface service; IOController or IOConnector attributes (SyncRole, PnUpdateTime, PnWatchdogTime, PnDeviceNumber); AddressController; addresses (StartAddress, IoType, Length); hardware identifiers; HwIdentifierController; channels (ChannelComposition, IoType, ChannelAddress); normalized type identifiers; address object attributes (IsochronousMode, ProcessImage) |
| `references/networks-and-connections.md` | Opening the Devices & Networks editor (ShowHwEditor, ShowInEditor); querying PLC or HMI targets by iterating DeviceItems; address object attributes; accessing channels of a module from a network perspective |

For tasks spanning multiple areas, load all relevant reference files before generating code.

---

## Execution pattern

1. Access `Project.Devices` composition (or `DeviceGroups` / `UngroupedDevicesGroup`)
2. Find or create `Device` objects
3. Navigate `DeviceItem` hierarchy as needed
4. Access `SoftwareContainer` via `GetService<SoftwareContainer>()` when PLC/HMI software is needed
5. Use `ICompilable` for hardware or software compile (see `tia-project-general/references/compile.md`)
