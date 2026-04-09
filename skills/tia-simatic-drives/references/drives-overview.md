# Drives Overview Reference

Source: TIA Portal Openness V21 — Functions for SIMATIC Drive Controller (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Coverage status

The V21 Openness API documentation for drive-specific functions (Startdrive, SINAMICS,
SIMATIC Drive Controller, PROFIdrive) was not available in machine-readable form at the
time this reference was written. The content below documents the **entry pattern** that
applies to all drive tasks and the **safe conservative approach** for implementation.

> **Do not invent drive-specific class names, service names, or method signatures.**
> Inspect the installed V21 assemblies directly (see section 3) before writing any
> drive-specific code.

---

## 1. Scope of drive-specific engineering

Tasks in this skill include:

- **Startdrive** — commissioning, parameter access, drive telegrams
- **SINAMICS** — SINAMICS G/S series configuration via TIA Portal
- **SIMATIC Drive Controller** — S210 and similar integrated drive PLCs
- **PROFIdrive** — PROFIdrive integrated network properties (subnets, timing)
- **Drive controller as CPU** — programming the integrated PLC on a SIMATIC Drive Controller

---

## 2. Standard device entry pattern

All drive tasks start from `project.Devices`, same as any device:

```csharp
// Find a drive device by name
Device driveDevice = project.Devices.Find("Drive_1");
if (driveDevice == null)
    throw new InvalidOperationException("Drive device not found.");

// Enumerate device items to find the drive controller item
foreach (DeviceItem item in driveDevice.DeviceItems)
{
    Console.WriteLine($"Item: {item.Name} | TypeId: {item.TypeIdentifier}");

    // Probe for drive-specific services — check installed assemblies for exact type
    // Example (verify name against installed V21 assemblies before use):
    // var driveService = item.GetService<SomeDriveSpecificService>();
}
```

Drive controller devices that include an integrated PLC expose `SoftwareContainer`
on their CPU device item — access `PlcSoftware` normally for the programming side:

```csharp
SoftwareContainer sc = cpuDeviceItem.GetService<SoftwareContainer>();
PlcSoftware plcSw = sc?.Software as PlcSoftware;
// Standard PLC operations apply — see tia-plc-operations
```

---

## 3. Discovering installed drive assemblies

Before implementing drive-specific API calls, enumerate the available assemblies
in the V21 Openness installation to find the correct types:

```csharp
// List Siemens.Engineering assemblies in the Openness folder
string opennessFolder = @"C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\net48";
var assemblies = Directory.GetFiles(opennessFolder, "Siemens.Engineering*.dll");
foreach (var asm in assemblies)
    Console.WriteLine(Path.GetFileName(asm));
```

Look for assemblies such as `Siemens.Engineering.Drive*.dll` or similar.
Load and inspect types using reflection to verify exact class and method names.

---

## 4. PROFIdrive integrated subnet timing

For PROFIdrive integrated network properties (isochronous timing, source cycle time),
use the network skills — these are accessible via standard `SubnetOwner` and `IoSystem`
services without drive-specific APIs. See `tia-networks/references/subnets-and-nodes.md`.

---

## 5. Known safe operations

These standard Openness operations work on drive devices without drive-specific APIs:

- `project.Devices.Find("Drive_1")` — locate device
- `device.Name`, `device.TypeIdentifier` — read device properties
- `device.DeviceItems` — enumerate slots and submodules
- `deviceItem.GetService<SoftwareContainer>()` — access integrated PLC software
- `deviceItem.GetService<ICompilable>()` — compile hardware or software
- `deviceItem.Addresses` — access I/O addresses
- `deviceItem.Channels` — access channels

For everything beyond this — inspect installed assemblies first.
