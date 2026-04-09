# Addresses and Channels Reference

Source: TIA Portal Openness V21 — Functions on Device Items (03/2026)

> C# only. Do not mix with Python wrapper calls.
> Write access to addresses requires the PLC to be **offline**.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
```

---

## 1. Address composition

Address objects are accessed via the `Addresses` composition on a `DeviceItem` or
`IoController`. Each address object describes a contiguous I/O address range of one
IO type (Input, Output, Diagnosis, Substitute).

```csharp
// Iterate all addresses of a module
AddressComposition addresses = deviceItem.Addresses;
foreach (Address address in addresses)
{
    Console.WriteLine(
        $"Type: {address.IoType}  Start: {address.StartAddress}  Len: {address.Length}");
}

// Access from an IO controller
AddressComposition ioCtrlAddresses = ioController.Addresses;
```

---

## 2. Address attributes

| Attribute | Type | Writable | Access | Description |
|---|---|---|---|---|
| `IoType` | `AddressIoType` | r | — | Input / Output / Diagnosis / Substitute / None |
| `StartAddress` | `Int32` | **r/w** | modeled | Process image start address |
| `Length` | `Int32` | r | — | Address range length in bytes |
| `AddressControllers` | `AddressControllerAssociation` | r | — | Assigned address controllers |
| `Context` | `AddressContext` | r | dynamic | Device / Head / None |

```csharp
// Read attributes
AddressIoType ioType    = address.IoType;
int startAddr           = address.StartAddress;
int length              = address.Length;
AddressContext context  = (AddressContext)
    ((IEngineeringObject)address).GetAttribute("Context");

// Write start address
address.StartAddress = 256;
```

**`AddressIoType` enum:**

| Value | Description |
|---|---|
| `AddressIoType.Input` | Input address |
| `AddressIoType.Output` | Output address |
| `AddressIoType.Diagnosis` | Diagnosis address |
| `AddressIoType.Substitute` | Substitute address |
| `AddressIoType.None` | Not specified |

**`AddressContext` enum:**

| Value | Description |
|---|---|
| `AddressContext.None` | Not applicable |
| `AddressContext.Device` | Device address context |
| `AddressContext.Head` | Head address context |

> **Warning:** Changing `StartAddress` on an input may implicitly change the output
> address of the same module. Changing via Openness does **not** rewire assigned tags.
> Packed addresses are not supported.

---

## 3. Dynamic address object attributes

Isochronous mode and process image configuration via `GetAttribute` / `SetAttribute`:

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `IsochronousMode` | `bool` | r/w | Activate isochronous mode for this address |
| `ProcessImage` | `int` | r/w | Process image partition number |
| `InterruptObNumber` | `long` | r/w | Interrupt OB number (classic controllers only: S7-300/400) |

```csharp
// Read/write isochronous mode
bool iso = (bool)address.GetAttribute("IsochronousMode");
address.SetAttribute("IsochronousMode", true);

// Read/write process image partition
int pip = (int)address.GetAttribute("ProcessImage");
address.SetAttribute("ProcessImage", 5);

// Assign a process image partition to an OB
OB ob = plcSoftware.BlockGroup.Blocks.Find("OB61") as OB;
try
{
    address.AssignProcessImageToOrganizationBlock(ob);
}
catch (RecoverableException ex)
{
    Console.WriteLine($"Assignment failed: {ex.Message}");
}

// Remove the assignment
address.AssignProcessImageToOrganizationBlock(null);
```

---

## 4. AddressController service

A device item that acts as an address controller (e.g. a CPU) exposes
`AddressController`. This gives access to all addresses it manages.

```csharp
AddressController addrCtrl =
    ((IEngineeringServiceProvider)deviceItem).GetService<AddressController>();

if (addrCtrl != null)
{
    foreach (Address registeredAddr in addrCtrl.RegisteredAddresses)
    {
        Console.WriteLine(
            $"  Managed: {registeredAddr.IoType} @ {registeredAddr.StartAddress}");
    }
}
```

---

## 5. Channel access

Signal modules (analog/digital I/O) have multiple channels within a single module.
Each channel provides the same function multiple times (e.g. 4 analog inputs).

```csharp
// Iterate all channels of a module
ChannelComposition channels = deviceItem.Channels;
foreach (Channel channel in channels)
{
    int chNum         = channel.Number;
    ChannelType chType = channel.Type;
    ChannelIoType chIo = channel.IoType;
    Console.WriteLine($"Channel {chNum}: {chType} {chIo}");
}

// Find a specific channel directly
Channel analogIn0 = deviceItem.Channels.Find(
    ChannelType.Analog, ChannelIoType.Input, 0);
```

**`ChannelType` enum:**

| Value | Description |
|---|---|
| `ChannelType.Analog` | Analog channel |
| `ChannelType.Digital` | Digital channel |
| `ChannelType.Technology` | Technology channel |
| `ChannelType.None` | Invalid |

**`ChannelIoType` enum:**

| Value | Description |
|---|---|
| `ChannelIoType.Input` | Input channel |
| `ChannelIoType.Output` | Output channel |
| `ChannelIoType.Complex` | Complex (e.g. technological) |
| `ChannelIoType.None` | Invalid |
