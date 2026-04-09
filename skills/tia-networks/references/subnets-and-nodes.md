# Subnets and Nodes Reference

Source: TIA Portal Openness V21 — Functions on Networks (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
```

---

## 1. Accessing subnets — SubnetOwner service

A device item that owns a subnet (e.g. a PROFINET interface) exposes `SubnetOwner`:

```csharp
SubnetOwner subnetOwner =
    ((IEngineeringServiceProvider)deviceItem).GetService<SubnetOwner>();

if (subnetOwner != null)
{
    foreach (Subnet subnet in subnetOwner.Subnets)
    {
        Console.WriteLine($"Subnet: {subnet.Name} — {subnet.NetType}");
    }

    // Access first subnet directly
    Subnet firstSubnet = subnetOwner.Subnets[0];
}
```

---

## 2. Subnet attributes

Attribute availability depends on subnet type. All subnets share `Name` and `NetType`.

### Common (all types)

| Attribute | Type | Writable | Access |
|---|---|---|---|
| `Name` | `string` | r/w | modeled |
| `NetType` | `NetType` | r | modeled |
| `SubnetId` | `string` | r (ASI/PC) / r/w (others) | dynamic |

```csharp
Subnet subnet = subnetOwner.Subnets[0];

string name     = subnet.Name;
NetType netType = (NetType)subnet.NetType;
string subnetId = (string)((IEngineeringObject)subnet).GetAttribute("SubnetId");

subnet.Name = "PROFINET_1";
((IEngineeringObject)subnet).SetAttribute("Name", "PROFINET_1"); // dynamic alternative
```

### Ethernet-specific

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `DefaultSubnet` | `bool` | r/w | `true` if this is the project default subnet (at most one) |

### PROFIBUS-specific (key attributes)

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `HighestAddress` | `int` | r/w | Highest PROFIBUS address |
| `TransmissionSpeed` | `BaudRate` | r/w | Bus speed |
| `BusProfile` | `BusProfile` | r/w | DP / Standard / Universal / UserDefined |
| `IsochronousMode` | `bool` | r/w | Constant bus cycle time |
| `DpCycleMinTimeAutoCalculation` | `bool` | r/w | Auto-calculate shortest DP cycle time |
| `DpCycleTime` | `double` | r/w | DP cycle time (when auto-calc off) |
| `IsochronousTiToAutoCalculation` | `bool` | r/w | Auto-calculate Ti/To |
| `IsochronousTi` | `double` | r/w | Time Ti |
| `IsochronousTo` | `double` | r/w | Time To |

```csharp
// PROFIBUS subnet dynamic attributes
var pbAttrs = new[] { "HighestAddress", "TransmissionSpeed", "BusProfile",
                      "IsochronousMode", "DpCycleTime" };
foreach (var attr in pbAttrs)
    Console.WriteLine($"{attr} = {((IEngineeringObject)subnet).GetAttribute(attr)}");
```

**`BaudRate` enum values:** `Baud9600`, `Baud19200`, `Baud45450`, `Baud93700`,
`Baud187500`, `Baud500000`, `Baud1500000`, `Baud3000000`, `Baud6000000`,
`Baud12000000`, `None` (unknown)

**`BusProfile` enum values:** `DP`, `Standard`, `Universal`, `UserDefined`, `None`

### PROFIBUS Integrated / PROFIdrive Integrated

Similar to PROFIBUS but `IsochronousMode` is read-only. PROFIdrive Integrated adds
`SourceCycleTime` (enum: `Manual=0`, `AutomaticMinimum=1`, `LocalSendClock=2`,
`ProfinetSendClock=3`).

---

## 3. NetType enum

| Value | Network type |
|---|---|
| `NetType.Ethernet` | Ethernet / PROFINET |
| `NetType.Profibus` | PROFIBUS |
| `NetType.ProfibusIntegrated` | PROFIBUS Integrated |
| `NetType.ProfidriveIntegrated` | PROFIdrive Integrated |
| `NetType.Mpi` | MPI |
| `NetType.Asi` | AS-Interface |
| `NetType.PcInternal` | PC internal |
| `NetType.Wan` | WAN |
| `NetType.Ptp` | PTP |
| `NetType.Link` | Link |
| `NetType.Unknown` | Unknown |

---

## 4. Node attributes

Nodes represent a device item's connection point on a subnet. Attribute set depends
on node type (determined by the subnet it is connected to).

### Ethernet node (most common)

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `Name` | `string` | r | Node name |
| `NodeId` | `string` | r | Unique node ID |
| `NodeType` | `NetType` | r/w | Network type |
| `UseIsoProtocol` | `bool` | r/w | Use ISO protocol |
| `MacAddress` | `string` | r/w | MAC address, e.g. `01-80-C2-00-00-00` |
| `UseIpProtocol` | `bool` | r/w | Enable IP protocol |
| `IpProtocolSelection` | enum | r/w | IP assignment mode |
| `Address` | `string` | r/w | IP address (IPv4 only) |
| `SubnetMask` | `string` | r/w | Subnet mask |
| `UseRouter` | `bool` | r/w | Use router/gateway |
| `RouterAddress` | `string` | r/w | Router IP address |
| `DhcpClientId` | `string` | r/w | DHCP client ID |
| `PnDeviceName` | `string` | r/w | PROFINET device name (unique in subnet) |
| `PnDeviceNameAutoGeneration` | `bool` | r/w | Auto-generate PROFINET device name |
| `PnDeviceNameSetDirectly` | `bool` | r/w | Device name set directly at device |

```csharp
// Access node — typically via NetworkInterface service
Node node = ...; // obtained from NetworkInterface composition

// Modeled attributes
string name   = node.Name;
NetType type  = (NetType)node.NodeType;

// Dynamic attributes
var dynAttrs = new[] { "Address", "SubnetMask", "UseRouter", "RouterAddress",
                       "PnDeviceName", "IpProtocolSelection" };
foreach (var attr in dynAttrs)
    Console.WriteLine($"{attr} = {((IEngineeringObject)node).GetAttribute(attr)}");

// Write dynamic attribute
((IEngineeringObject)node).SetAttribute("Address", "192.168.0.10");
((IEngineeringObject)node).SetAttribute("PnDeviceName", "plc-station-1");
```

### PROFIBUS node

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `Name` | `string` | r | Node name |
| `NodeId` | `string` | r | Unique node ID |
| `NodeType` | `NetType` | r | Network type |
| `Address` | `string` | r/w | PROFIBUS address |

### `IpProtocolSelection` enum

| Value | Description |
|---|---|
| `IpProtocolSelection.Project` | IP configured within the project |
| `IpProtocolSelection.Dhcp` | Managed via DHCP (requires DhcpClientId) |
| `IpProtocolSelection.UserProgram` | Set via function block |
| `IpProtocolSelection.OtherPath` | Set via external tools (e.g. PST) |
| `IpProtocolSelection.ViaIoController` | Set via IO Controller at runtime |
| `IpProtocolSelection.None` | Error / not configured |

---

## 5. MRP domain access

Accessed via `MrpDomainOwner` service on a subnet:

```csharp
MrpDomainOwner mrpOwner = subnet.GetService<MrpDomainOwner>();
MrpDomainComposition domains = mrpOwner.MrpDomains;

// Enumerate
foreach (MrpDomain domain in domains) { /* ... */ }

// Create a new MRP domain
MrpDomain newDomain = domains.Create("MRP_Ring_1");
newDomain.SetAttribute("IsDefault", true);

// Add a network interface to the domain as participant
NetworkInterface toAdd = ...; // obtained from a device item
newDomain.DomainParticipants.Add(toAdd);

// Delete
newDomain.Delete();
```
