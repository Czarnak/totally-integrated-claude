# Device Item Interfaces Reference

Source: TIA Portal Openness V21 — Functions on Device Items (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Node;
using Siemens.Engineering.HW.Features;
```

---

## 1. Accessing a device item as a network interface

When a device item is a network interface (PROFINET or PROFIBUS port), it exposes the `NetworkInterface` service with nodes, operating mode, and interface type.

```csharp
NetworkInterface itf =
    ((IEngineeringServiceProvider)deviceItem).GetService<NetworkInterface>();

if (itf != null)
{
    // Accessing nodes and operating mode
    NodeComposition nodes = itf.Nodes;
    InterfaceOperatingModes mode = itf.InterfaceOperatingMode;

    // Accessing the type of interface
    NetType itfType = itf.InterfaceType;

    // Modifying the operating mode
    itf.InterfaceOperatingMode = InterfaceOperatingModes.IoController;
}
```

`InterfaceOperatingModes` enum:

| Value | Description |
|---|---|
| `InterfaceOperatingModes.None` | Default |
| `InterfaceOperatingModes.IoDevice` | Slave mode |
| `InterfaceOperatingModes.IoController` | Master mode |
| `InterfaceOperatingModes.IoDevice \| InterfaceOperatingModes.IoController` | Both |

---

## 2. Getting the subnet of a device item

```csharp
using Siemens.Engineering.HW.Node;

private void GetSubnetDeviceItem()
{
    DeviceItem itfDeviceItem = ...;
    NetworkInterface itf = itfDeviceItem.GetService<NetworkInterface>();

    foreach (Node node in itf.Nodes)
    {
        Subnet subnet = node.ConnectedSubnet;
        // subnet is null if the node is not connected to any subnet
    }
}
```

---

## 3. IOController attributes

`IoController` is a service on the PROFINET interface device item.
Requires PLC to be offline for write access.

| Attribute | Type | Access | Description |
|---|---|---|---|
| `SyncRole` | `SyncRole` | read/write | Dynamic attribute |
| `PnDeviceNumber` | int | read-only | Dynamic attribute; shown under ethernet/PROFINET section in UI |

`SyncRole` enum:

| Value | Numerical |
|---|---|
| `SyncRole.NotSynchronized` | 0 |
| `SyncRole.SyncMaster` | 1 |
| `SyncRole.SyncSlave` | 2 |
| `SyncRole.RedundantSyncMaster` | 4 |

```csharp
IoController ioController = ...;

// Get SyncRole
SyncRole syncRole = (SyncRole)((IEngineeringObject)ioController).GetAttribute("SyncRole");

// Set SyncRole
((IEngineeringObject)ioController).SetAttribute("SyncRole", SyncRole.SyncMaster);
```

---

## 4. IOConnector attributes

`IoConnector` is a service on a PROFINET device item acting as IO device (slave).
Requires PLC to be offline for write access.

### Update time attributes

| Attribute | Type | Access | Description |
|---|---|---|---|
| `PnUpdateTimeAutoCalculation` | bool | read/write | If true, update time is auto-calculated |
| `PnUpdateTime` | Int64 | read/write | Update time in nanoseconds |
| `PnUpdateTimeAdaption` | bool | read/write | — |

### Watchdog time attributes

| Attribute | Type | Access | Description |
|---|---|---|---|
| `PnWatchdogFactor` | int | read/write | — |
| `PnWatchdogTime` | Int64 | read/write | Watchdog time in nanoseconds |

### Synchronization attributes

| Attribute | Type | Access | Description |
|---|---|---|---|
| `RtClass` | enum | read/write | RT class |
| `SyncRole` | `SyncRole` | read/write | — |

### Device number attributes

| Attribute | Type | Access | Description |
|---|---|---|---|
| `PnDeviceNumber` | int | read/write | IO device number |

```csharp
IoConnector connector = ...;

var attributeNames = new[]
{
    "PnUpdateTimeAutoCalculation", "PnUpdateTime", "PnUpdateTimeAdaption",
    "PnWatchdogFactor", "PnWatchdogTime", "RtClass", "SyncRole"
};

foreach (var attributeName in attributeNames)
{
    object value = ((IEngineeringObject)connector).GetAttribute(attributeName);
    Console.WriteLine($"{attributeName} = {value}");
}

// Write an attribute
((IEngineeringObject)connector).SetAttribute("PnUpdateTimeAutoCalculation", false);
((IEngineeringObject)connector).SetAttribute("PnUpdateTime", (Int64)1000000);
```

---

## 5. Address controller

`AddressController` exposes addresses that are registered at the controller for a device item.

```csharp
AddressController addressController =
    ((IEngineeringServiceProvider)deviceItem).GetService<AddressController>();

if (addressController != null)
{
    foreach (Address registeredAddress in addressController.RegisteredAddresses)
    {
        // work with registeredAddress
    }
}
```

---

## 6. Addresses

Address objects are acquired via `deviceItem.Addresses` (an `AddressComposition`).

```csharp
// Get addresses of a device item
AddressComposition addresses = deviceItem.Addresses;
foreach (Address address in addresses)
{
    // work with the address
}

// Get addresses of an IoController
AddressComposition addresses = ioController.Addresses;
foreach (Address address in addresses)
{
    // work with the address
}
```

`Address` attributes:

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `StartAddress` | Int32 | read/write (modeled) | Base I/O address. Changing input may implicitly change output. |
| `Length` | Int32 | read | Length in bytes |
| `IoType` | `AddressIoType` | read | Input or output |
| `Context` | `AddressContext` | read (dynamic) | Only for diagnosis addresses and special device items |
| `AddressControllers` | `AddressControllerAssociation` | read | — |

`AddressIoType` values: `Input`, `Output`, `None`.

---

## 7. Hardware identifiers

`HwIdentifier` objects are acquired from a `Device`, `DeviceItem`, or `IoSystem` via the `HwIdentifiers` attribute.

```csharp
var hwObject = ...;  // Device, DeviceItem, or IoSystem

foreach (HwIdentifier hardwareIdentifier in hwObject.HwIdentifiers)
{
    Int64 id = hardwareIdentifier.Identifier;
    HwIdentifierControllerAssociation controllers =
        hardwareIdentifier.HwIdentifierControllers;
}
```

---

## 8. Hardware identifier controller

`HwIdentifierController` exposes hardware identifiers registered at a device item controller.

```csharp
HwIdentifierController hwIdentifierController =
    ((IEngineeringServiceProvider)deviceItem).GetService<HwIdentifierController>();

if (hwIdentifierController != null)
{
    foreach (HwIdentifier hwIdentifier in
        hwIdentifierController.RegisteredHwIdentifiers)
    {
        // work with hwIdentifier
    }
}
```

---

## 9. Channels of a device item

Channels represent individual I/O signals (e.g., each pin of an analog input module).

```csharp
// Enumerate all channels
ChannelComposition channels = deviceItem.Channels;
foreach (Channel channel in channels)
{
    // work with channel
}

// Read identifying attributes
Channel channel = ...;
int channelNumber = channel.Number;
ChannelType type = channel.Type;
ChannelIoType ioType = channel.IoType;
```

`Channel` mandatory attributes:

| Attribute | Type | Access | Description |
|---|---|---|---|
| `Number` | Int32 | read (modeled) | Channel number |
| `Type` | `ChannelType` | read (modeled) | — |
| `IoType` | `ChannelIoType` | read (modeled) | Input or output |
| `ChannelAddress` | Int32 | read (dynamic) | Address in bits |
| `ChannelWidth` | UInt32 | read (dynamic) | Width in bits |

> If a device item has no channels, `Channels` returns an empty collection.

---

## 10. Normalized type identifiers

`ModuleInformationProvider.GetTypeIdentifierNormalized()` returns the canonical (normalized) form of a type identifier.

```csharp
using Siemens.Engineering.HW.Utilities;

private void ProvideTypeIdentifier(ModuleInformationProvider moduleInformationProvider)
{
    string typeIdentifier = ...;
    string normalizedTypeIdentifier =
        moduleInformationProvider.GetTypeIdentifierNormalized(typeIdentifier);
}
```

`ModuleInformationProvider` is retrieved via `project.HwUtilities`:

```csharp
HardwareUtilityComposition extensions = project.HwUtilities;
ModuleInformationProvider mip =
    extensions.Find("ModuleInformationProvider") as ModuleInformationProvider;
```

---

## 11. Address object attributes

Access address object attributes for process image partitions, isochronous mode, and interrupt OBs.

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `IsochronousMode` | bool | read/write (dynamic) | Activate/deactivate isochronous mode |
| `ProcessImage` | Int32 | read/write (dynamic) | Process image partition number |
| `InterruptObNumber` | Int64 | read/write (dynamic) | Interrupt OB number (classic controllers only) |
| `StartAddress` | Int32 | read/write (modeled) | I/O start address |

> Setting `StartAddress` may implicitly change the opposite I/O type at the same module.
> Write access is not supported for all devices.

```csharp
Address address = ...;

// Get/set start address
int startAddr = (int)((IEngineeringObject)address).GetAttribute("StartAddress");
((IEngineeringObject)address).SetAttribute("StartAddress", 100);

// Activate isochronous mode
((IEngineeringObject)address).SetAttribute("IsochronousMode", true);

// Set process image partition
((IEngineeringObject)address).SetAttribute("ProcessImage", 1);
```

