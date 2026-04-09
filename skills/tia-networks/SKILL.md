---
name: tia-networks
description: >
  Routed by tia-openness-roadmap. C# Openness implementation of topology and low-level network
  engineering: subnets, nodes, IO systems, DP master systems, ports, interfaces, addresses,
  channels, transfer areas, network topology manipulation, and AML/CAx network exchange.
---

# tia-networks

## Scope
Topology and low-level network engineering — full C# Openness implementation.

When the roadmap routes here, the entire solution is C#.
Do not mix with Python wrapper calls.
Always load `tia-csharp-common` first (done by roadmap).

---

## Reference files

Load ONLY the reference file(s) relevant to the task. Do not load all files at once.

| Reference file | Load when the task involves |
|---|---|
| `references/subnets-and-nodes.md` | Reading/writing subnet attributes (name, type, PROFIBUS bus params, isochronous settings); accessing node attributes (IP address, PROFINET device name, node type); SubnetOwner service |
| `references/io-systems.md` | PROFINET IO system attributes; DP master system (IoSystem) attributes; TransferArea creation/deletion on PN or DP interfaces |
| `references/addresses-and-channels.md` | Address objects (StartAddress, IoType, Length, IsochronousMode, ProcessImage); channel access (ChannelType, ChannelIoType); AddressController service |
| `references/io-timing.md` | IoConnector timing/watchdog attributes (PnUpdateTime, PnWatchdogFactor, RtClass, SyncRole); IO device interface isochronous settings (PnSendClock, IsochronousTi, IsochronousTo) |

For tasks spanning multiple areas, load all relevant reference files before generating code.

---

## Execution pattern

1. Access devices and device items from `Project.Devices`
2. Navigate network interfaces and nodes via Openness HW namespace
3. Use `GetService<SubnetOwner>()` to access subnets owned by a device item
4. Use `GetService<NetworkInterface>()` to access the network interface
5. Create or modify IO systems, subnets, nodes as needed
6. Modify addresses or channel timing via `deviceItem.Addresses` / `deviceItem.Channels`
7. Compile hardware after changes (see `tia-project-general/references/compile.md`)
