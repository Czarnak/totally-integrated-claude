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
| --- | --- |
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
| --- | --- | --- | --- |
| `SyncRole` | `SyncRole` | read/write | Dynamic attribute |
| `PnDeviceNumber` | int | read-only | Dynamic attribute; shown under ethernet/PROFINET section in UI |

`SyncRole` enum:

| Value | Numerical |
| --- | --- |
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
| --- | --- | --- | --- |
| `PnUpdateTimeAutoCalculation` | bool | read/write | If true, update time is auto-calculated |
| `PnUpdateTime` | Int64 | read/write | Update time in nanoseconds |
| `PnUpdateTimeAdaption` | bool | read/write | — |

### Watchdog time attributes

| Attribute | Type | Access | Description |
| --- | --- | --- | --- |
| `PnWatchdogFactor` | int | read/write | — |
| `PnWatchdogTime` | Int64 | read/write | Watchdog time in nanoseconds |

### Synchronization attributes

| Attribute | Type | Access | Description |
| --- | --- | --- | --- |
| `RtClass` | enum | read/write | RT class |
| `SyncRole` | `SyncRole` | read/write | — |

### Device number attributes

| Attribute | Type | Access | Description |
| --- | --- | --- | --- |
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
| --- | --- | --- | --- |
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
| --- | --- | --- | --- |
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
| --- | --- | --- | --- |
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

---

## API Reference (V21)

## 🛠️ Siemens.Engineering.HW.Address
>
> The object holding the address data

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 📦 `Siemens#Engineering#IEngineeringServiceProvider#GetServiceInfos`: Returns a collection of EngineeringServiceInfo objects describing the different services on this object.
- 🔧 `Parent`: EOM parent of this object
- 🔧 `AddressControllers`: Address&apos;s associated AddressControllers
- 🔧 `IoType`: The IO type of the address
- 🔧 `Length`: Length of the address
- 🔧 `StartAddress`: The start address of this address
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.AddressAssociation
>
> Associated addresses

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Address)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Address)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.AddressComposition
>
> Composition of Addresses

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Address)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Address)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.AddressContext
>
> AddressContext of an address

## 🛠️ Siemens.Engineering.HW.AddressIoType
>
> Address IO type

## 🛠️ Siemens.Engineering.HW.Channel
>
> Class representing a channel

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 📦 `Siemens#Engineering#IEngineeringServiceProvider#GetServiceInfos`: Returns a collection of EngineeringServiceInfo objects describing the different services on this object.
- 🔧 `Parent`: EOM parent of this object
- 🔧 `IoType`: The IO type of the channel
- 🔧 `Number`: The number of this channel
- 🔧 `Type`: The type of this channel
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.ChannelComposition
>
> Composition of Channels

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Channel)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Channel)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(Siemens.Engineering.HW.ChannelType,Siemens.Engineering.HW.ChannelIoType,System.Int32)`: Finds a given channel
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.ChannelIoType
>
> Channel IO type

## 🛠️ Siemens.Engineering.HW.ChannelType
>
> Channel type

## 🛠️ Siemens.Engineering.HW.HwIdentifier
>
> Represents a HW identifier

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 🔧 `HwIdentifierControllers`: Associated Hw identifier controllers
- 🔧 `Identifier`: Identifier for this HW identifier
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.HwIdentifierAssociation
>
> Associated Hw identifiers

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.HwIdentifier)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.HwIdentifier)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.HwIdentifierComposition
>
> Composition of HwIdentifiers

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.HwIdentifier)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.HwIdentifier)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.AddressController
>
> Address controller device

- 🔧 `RegisteredAddresses`: Associated registered address
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.AddressControllerAssociation
>
> Associated address controllers

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Features.AddressController)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Features.AddressController)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.HwIdentifierController
>
> Represents a HW identifier controller

- 🔧 `RegisteredHwIdentifiers`: Associated registered HW identifiers
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.HwIdentifierControllerAssociation
>
> Associated Hw identifier controllers

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Features.HwIdentifierController)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Features.HwIdentifierController)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.NetworkInterface
>
> Represents a HW interface

- 🔧 `IoConnectors`: Composition of IO connectors
- 🔧 `IoControllers`: Composition of IO controllers
- 🔧 `MulticastableTransferAreas`: Composition of multicastable transfer areas
- 🔧 `Nodes`: Composition of nodes
- 🔧 `TransferAreas`: Composition of transfer areas
- 🔧 `InterfaceOperatingMode`: The operating mode of this interface
- 🔧 `InterfaceType`: The type of this interface
- 🔧 `Ports`: Associated ports
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.NetworkInterfaceAssociation
>
> Association of Network Interfaces

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Features.NetworkInterface)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Features.NetworkInterface)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Add(Siemens.Engineering.HW.Features.NetworkInterface)`: Adds an <paramref name="item"/>.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.NetworkPort
>
> Represents a port on a device item

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 📦 `Siemens#Engineering#IEngineeringServiceProvider#GetServiceInfos`: Returns a collection of EngineeringServiceInfo objects describing the different services on this object.
- 🔧 `ConnectedPorts`: Internal use only
- 🔧 `Interface`: The interface supported by this port
- 📦 `ConnectToPort(Siemens.Engineering.HW.Features.NetworkPort)`: Connects to the Port
- 📦 `DisconnectFromPort(Siemens.Engineering.HW.Features.NetworkPort)`: Disconnects a device from the given port
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.NetworkPortAssociation
>
> Associated ports

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Features.NetworkPort)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Features.NetworkPort)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
