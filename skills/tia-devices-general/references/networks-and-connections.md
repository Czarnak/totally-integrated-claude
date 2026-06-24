# Networks and Connections Reference

Source: TIA Portal Openness V21 — Functions for Accessing Devices, Networks and Connections (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.SW;
```

---

## 1. Opening the Devices & Networks editor

Two methods are available:

- `project.ShowHwEditor(View)` — opens the editor from the project
- `device.ShowInEditor(View)` — opens the editor focused on a specific device

`View` parameter values: `View.Topology`, `View.Network`, `View.Device`

```csharp
// Open Topology view from project
private static void OpenEditorFromProject(Project project)
{
    project.ShowHwEditor(Siemens.Engineering.HW.View.Topology);
}

// Open Topology view for a specific device
private static void OpenEditorForDevice(Device device)
{
    device.ShowInEditor(Siemens.Engineering.HW.View.Topology);
}

// Open Network view for a specific device
private static void OpenNetworkViewForDevice(Device device)
{
    device.ShowInEditor(Siemens.Engineering.HW.View.Network);
}
```

---

## 2. Querying PLC and HMI targets

Determine whether a device item exposes a `PlcSoftware` or `HmiTarget` via the `SoftwareContainer` service.

```csharp
// Returns PlcSoftware or null
private PlcSoftware GetPlcSoftware(Device device)
{
    DeviceItemComposition deviceItemComposition = device.DeviceItems;
    foreach (DeviceItem deviceItem in deviceItemComposition)
    {
        SoftwareContainer softwareContainer =
            deviceItem.GetService<SoftwareContainer>();
        if (softwareContainer != null)
        {
            Software softwareBase = softwareContainer.Software;
            PlcSoftware plcSoftware = softwareBase as PlcSoftware;
            if (plcSoftware != null)
                return plcSoftware;
        }
    }
    return null;
}

// Returns HmiTarget or null
private HmiTarget GetHmiTarget(Device device)
{
    DeviceItemComposition deviceItemComposition = device.DeviceItems;
    foreach (DeviceItem deviceItem in deviceItemComposition)
    {
        SoftwareContainer softwareContainer =
            deviceItem.GetService<SoftwareContainer>();
        if (softwareContainer != null)
        {
            Software softwareBase = softwareContainer.Software;
            HmiTarget hmiTarget = softwareBase as HmiTarget;
            if (hmiTarget != null)
                return hmiTarget;
        }
    }
    return null;
}
```

> This pattern is equivalent to the `SoftwareContainer` service described in `references/software-container.md`. Load that file when the goal is software block access; load this file when the goal is network/connection discovery.

---

## 3. Accessing attributes of an address object

Address objects are found on network nodes and carry network addressing information.

| Attribute | Type | Writable | Access | Description |
|---|---|---|---|--- |
| `IsochronousMode` | bool | read/write | Dynamic | Activate/deactivate isochronous mode |
| `ProcessImage` | Int32 | read/write | Dynamic | Process image partition number |
| `InterruptObNumber` | Int64 | read/write | Dynamic | Interrupt OB number (classic controllers only) |
| `StartAddress` | Int32 | read/write | Modeled | I/O start address |

```csharp
Address address = ...;

// Read start address
int startAddr = (int)((IEngineeringObject)address).GetAttribute("StartAddress");

// Write start address
((IEngineeringObject)address).SetAttribute("StartAddress", 100);

// Activate isochronous mode
((IEngineeringObject)address).SetAttribute("IsochronousMode", true);

// Set process image partition
((IEngineeringObject)address).SetAttribute("ProcessImage", 1);
```

> Changing `StartAddress` on the input type may implicitly change the output type of the same module. Write access is not supported for all devices.

---

## 4. Accessing channels of a module (network perspective)

Signal modules (e.g., analog input modules) expose multiple channels.
Channels are accessed via `deviceItem.Channels` (`ChannelComposition`).

```csharp
DeviceItem aiModule = ...;

ChannelComposition channels = aiModule.Channels;
foreach (Channel channel in channels)
{
    // Work with the channel
}

// Read identifying attributes per channel
Channel channel = ...;
int channelNumber = channel.Number;
ChannelType type = channel.Type;
ChannelIoType ioType = channel.IoType;
```

Channel mandatory attributes:

| Attribute | Type | Access | Description |
|---|---|---|---|
| `Number` | Int32 | read (modeled) | Channel number |
| `Type` | `ChannelType` | read (modeled) | Channel type |
| `IoType` | `ChannelIoType` | read (modeled) | Input or output |
| `ChannelAddress` | Int32 | read (dynamic) | Address in bits |
| `ChannelWidth` | UInt32 | read (dynamic) | Width in bits |

Access a single channel by identifying attribute:

```csharp
// Access a specific channel (e.g., first input channel)
Channel inputChannel = channels.First(c => c.IoType == ChannelIoType.Input);
```

---

## API Reference (V21)

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.Connection
>
> Represents the base class for a connection information object

- 🔧 `ConnectionType`: The connection type of the connection
- 🔧 `IsValid`: Is the connection fully specified
- 🔧 `LocalInterface`: Link to local interface
- 🔧 `LocalSubnetName`: Name of local connected subnet
- 🔧 `LocalTarget`: Link to local target
- 🔧 `PartnerInterface`: Link to partner interface
- 🔧 `PartnerSubnetName`: Name of partner connected subnet
- 🔧 `PartnerTarget`: Link to partner target
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.ConnectionComposition
>
> Composition of Connections

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.CommunicationConnections.Connection)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.CommunicationConnections.Connection)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create``1(Siemens.Engineering.HW.Node,Siemens.Engineering.HW.DeviceItem,Siemens.Engineering.HW.Node)`: Create a connection

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.ConnectionType
>
> Connection Type

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.FdlConnection
>
> Represents a fdl connection information object

- 🔧 `LocalAddress`: Display of the address of the local interface.
- 🔧 `LocalConnectionId`: Local ID of the connection end point.
- 🔧 `LocalConnectionName`: Name of the local connection end point.
- 🔧 `LocalLsap`: LSAP address of the local connection end point.
- 🔧 `PartnerAddress`: Display of the address of the partner interface.
- 🔧 `PartnerConnectionId`: Partner ID of the connection end point.
- 🔧 `PartnerConnectionName`: Name of the partner connection end point.
- 🔧 `PartnerLsap`: LSAP address of the partner connection end point.

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.HmiConnection
>
> Represents a hmi connection information object

- 🔧 `AccessPoint`: Name of access point
- 🔧 `LocalAddress`: Display of the address of the local interface.
- 🔧 `LocalConnectionName`: Name of the local connection end point.
- 🔧 `Online`: Initial runtime sate of the connection.
- 🔧 `PartnerAddress`: Display of the address of the partner interface.
- 🔧 `TimeSynchronizationMode`: Time synchronization mode.

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.IsoConnection
>
> Represents a iso connection information object

- 🔧 `LocalActiveEstablishment`: Active establishment of local connection end point.
- 🔧 `LocalAddress`: Display of the address of the local interface.
- 🔧 `LocalConnectionId`: Local ID of the connection end point.
- 🔧 `LocalConnectionName`: Name of the local connection end point.
- 🔧 `LocalTsap`: TSAP (ASCII) of local connection end point.
- 🔧 `PartnerActiveEstablishment`: Active establishment of partner connection end point.
- 🔧 `PartnerAddress`: Display of the address of the partner interface.
- 🔧 `PartnerConnectionId`: Partner ID of the connection end point.
- 🔧 `PartnerConnectionName`: Name of the partner connection end point.
- 🔧 `PartnerTsap`: TSAP (ASCII) of partner connection end point.

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.IsoOnTcpConnection
>
> Represents a isoOnTcp connection information object

- 🔧 `LocalActiveEstablishment`: Active establishment of local connection end point.
- 🔧 `LocalAddress`: Display of the address of the local interface.
- 🔧 `LocalConnectionId`: Local ID of the connection end point.
- 🔧 `LocalConnectionName`: Name of the local connection end point.
- 🔧 `LocalTsap`: TSAP (ASCII) of local connection end point.
- 🔧 `PartnerActiveEstablishment`: Active establishment of partner connection end point.
- 🔧 `PartnerAddress`: Display of the address of the partner interface.
- 🔧 `PartnerConnectionId`: Partner ID of the connection end point.
- 🔧 `PartnerConnectionName`: Name of the partner connection end point.
- 🔧 `PartnerTsap`: TSAP (ASCII) of partner connection end point.

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.PtpConnection
>
> Represents a ptp connection information object

- 🔧 `Direction`: Direction of the connection
- 🔧 `LocalConnectionId`: Local ID of the connection end point.
- 🔧 `LocalConnectionName`: Name of the local connection end point.
- 🔧 `LocalConnectionResourceId`: Connection resource ID (decimal) of the local connection end point.
- 🔧 `LocalCpuNumber`: RK512 CPU number of the local connection end point.
- 🔧 `LocalRack`: Rack number of the local connection end point.
- 🔧 `LocalSlot`: Slot number of the local connection end point.
- 🔧 `LocalTsap`: TSAP (ASCII) of local connection end point.
- 🔧 `PartnerCpuNumber`: RK512 CPU number of the partner connection end point.

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.PtpConnectionDirection
>
> Ptp Connection Direction

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.S7Connection
>
> Represents a s7 connection information object

- 🔧 `LocalActiveEstablishment`: Active establishment of local connection end point.
- 🔧 `LocalAddress`: Display of the address of the local interface.
- 🔧 `LocalConnectionId`: Local ID of the connection end point.
- 🔧 `LocalConnectionName`: Name of the local connection end point.
- 🔧 `LocalConnectionResourceId`: Connection resource ID (decimal) of the local connection end point.
- 🔧 `LocalRack`: Rack number of the local connection end point.
- 🔧 `LocalSlot`: Slot number of the local connection end point.
- 🔧 `LocalTsap`: TSAP (ASCII) of local connection end point.
- 🔧 `LocalUseSimaticACC`: A selected &apos;SIMATIC-ACC&apos; is used as TSAP of the local connection end point.
- 🔧 `PartnerActiveEstablishment`: Active establishment of partner connection end point.
- 🔧 `PartnerAddress`: Display of the address of the partner interface.
- 🔧 `PartnerConnectionId`: Partner ID of the connection end point.
- 🔧 `PartnerConnectionName`: Name of the partner connection end point.
- 🔧 `PartnerConnectionResourceId`: Connection resource ID (decimal) of the partner connection end point.
- 🔧 `PartnerRack`: Rack number of the partner connection end point.
- 🔧 `PartnerSlot`: Slot number of the partner connection end point.
- 🔧 `PartnerTsap`: TSAP (ASCII) of partner connection end point.
- 🔧 `PartnerUseSimaticACC`: A selected &apos;SIMATIC-ACC&apos; is used as TSAP of the partner connection end point

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.TcpConnection
>
> Represents a tcp connection information object

- 🔧 `LocalActiveEstablishment`: Active establishment of local connection end point.
- 🔧 `LocalAddress`: Display of the address of the local interface.
- 🔧 `LocalConnectionId`: Local ID of the connection end point.
- 🔧 `LocalConnectionName`: Name of the local connection end point.
- 🔧 `LocalPort`: Port of local connection end point.
- 🔧 `PartnerActiveEstablishment`: Active establishment of partner connection end point.
- 🔧 `PartnerAddress`: Display of the address of the partner interface.
- 🔧 `PartnerConnectionId`: Partner ID of the connection end point.
- 🔧 `PartnerConnectionName`: Name of the partner connection end point.
- 🔧 `PartnerPort`: Port of partner connection end point.

## 🛠️ Siemens.Engineering.HW.CommunicationConnections.UdpConnection
>
> Represents a udp connection information object

- 🔧 `LocalAddress`: Display of the address of the local interface.
- 🔧 `LocalConnectionId`: Local ID of the connection end point.
- 🔧 `LocalConnectionName`: Name of the local connection end point.
- 🔧 `LocalPort`: Port of local connection end point.
- 🔧 `PartnerAddress`: Display of the address of the partner interface.
- 🔧 `PartnerConnectionId`: Partner ID of the connection end point.
- 🔧 `PartnerConnectionName`: Name of the partner connection end point.
- 🔧 `PartnerPort`: Port of partner connection end point.

## 🛠️ Siemens.Engineering.HW.MrpDomain
>
> Media Redundancy Protocol Domain

- 🔧 `DomainParticipants`: Association of Network Interfaces
- 🔧 `Name`: Name of the Mrp Domain
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HW.MrpDomainComposition
>
> Composition of Mrp Domains

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.MrpDomain)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.MrpDomain)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create Mrp Domain on Subnet
- 📦 `Find(System.String)`: Finds a given Mrp Domain

## 🛠️ Siemens.Engineering.HW.MrpInstance
>
> Mrp Instance of a Profinet Interface

- 🔧 `ConnectedMrpDomain`: The MrpDomain which is connected to this instance
- 🔧 `Interface`: Interface of the MrpInstance
- 🔧 `Name`: Name of the Mrp Instance
- 🔧 `RingPort1`: Ring port 1 of the MrpInstance
- 🔧 `RingPort2`: Ring port 2 of the MrpInstance

## 🛠️ Siemens.Engineering.HW.MrpInstanceComposition
>
> Composition of MrpInstances

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.MrpInstance)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.MrpInstance)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.

## 🛠️ Siemens.Engineering.HW.Node
>
> Node is an object which is used as an interface from DeviceItem to Subnet

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `ConnectedSubnet`: The connected subnet
- 🔧 `Name`: The name of the node
- 🔧 `NodeId`: The id of this node
- 🔧 `NodeType`: Particular type e.g. Industrial Ethernet or Wireless LAN
- 📦 `ConnectToSubnet(Siemens.Engineering.HW.Subnet)`: Connects to the Subnet
- 📦 `CreateAndConnectToSubnet(System.String)`: Create and connect to a subnet
- 📦 `DisconnectFromSubnet`: Disconnects a device from the given Subnet

## 🛠️ Siemens.Engineering.HW.NodeAssociation
>
> Associated nodes

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Node)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Node)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.

## 🛠️ Siemens.Engineering.HW.NodeComposition
>
> Composition of Nodes

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Node)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Node)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds a given node

## 🛠️ Siemens.Engineering.HW.Subnet
>
> Represents a Subnet, one of the following (SubnetMpi or SubnetIE) represents the net object

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `IoSystems`: Associated IO systems
- 🔧 `Name`: The name of the Subnet
- 🔧 `NetType`: Particular subnet net type
- 🔧 `Nodes`: Associated nodes
- 🔧 `TypeIdentifier`: The type identifier of this Subnet
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HW.SubnetComposition
>
> Composition of Subnets

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Subnet)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Subnet)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create subnet from MasterCopy
- 📦 `Create(System.String,System.String)`: Creates a Subnet
- 📦 `Find(System.String)`: Finds a given Subnet

## 🛠️ Siemens.Engineering.HW.SyncDomain
>
> Sync Domain

- 🔧 `ConvertedName`: Converted name of the Sync Domain
- 🔧 `DomainParticipants`: Association of Sync Domain Participants
- 🔧 `IsDefault`: Default state of the Sync Domain
- 🔧 `Name`: Name of the Sync Domain
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HW.SyncDomainComposition
>
> Composition of Sync Domains

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.SyncDomain)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.SyncDomain)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create Sync Domain on Subnet
- 📦 `Find(System.String)`: Finds a given Sync Domain

## 🛠️ Siemens.Engineering.HW.Features.MrpDomainOwner
>
> Represents a Mrp Domain owner

- 🔧 `MrpDomains`: Composition of Mrp Domain

## 🛠️ Siemens.Engineering.HW.Features.MrpInstancesOwner
>
> Service for accessing the Mrp Instances

- 🔧 `MrpInstances`: Composition of Mrp Instances

## 🛠️ Siemens.Engineering.HW.Features.SubnetFeature
>
> Base class for Subnet related services

- 🔧 `OwnedBy`: Subnet Object that owns this role

## 🛠️ Siemens.Engineering.HW.Features.SubnetOwner
>
> Represents a Subnet owner

- 🔧 `Subnets`: Composition of Subnets

## 🛠️ Siemens.Engineering.HW.Features.SyncDomainOwner
>
> Represents a Sync Domain owner

- 🔧 `SyncDomains`: Composition of Sync Domain
