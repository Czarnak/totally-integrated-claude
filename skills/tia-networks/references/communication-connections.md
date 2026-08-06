# Communication Connections Reference

Source: TIA Portal PublicAPI V21 XML docs, `Siemens.Engineering.Base.xml`.

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.HW.CommunicationConnections;
```

---

## 1. Entry point

Communication connections are exposed through the `CommunicationManagement` service on
the relevant device item.

```csharp
CommunicationManagement communication =
    ((IEngineeringServiceProvider)deviceItem).GetService<CommunicationManagement>();

if (communication == null)
    return;

ConnectionComposition connections = communication.Connections;
foreach (Connection connection in connections)
{
    Console.WriteLine($"{connection.ConnectionType}: valid={connection.IsValid}");
}
```

`CommunicationManagement.Connections` is a `ConnectionComposition`. It supports
enumeration, index access, `Any()`, `Contains()`, `IndexOf()`, and `Create<T>()`.

---

## 2. Common connection properties

All connection objects derive from `Connection`.

| Property | Meaning |
|---|---|
| `ConnectionType` | `S7Connection`, `FdlConnection`, `IsoConnection`, `IsoOnTcpConnection`, `PtpConnection`, `TcpConnection`, `UdpConnection`, or `HmiConnection` |
| `IsValid` | `true` when the connection is fully specified |
| `LocalInterface` / `PartnerInterface` | local and partner network nodes |
| `LocalTarget` / `PartnerTarget` | local and partner device items |
| `LocalSubnetName` / `PartnerSubnetName` | connected subnet names |

Delete a connection with:

```csharp
// `connection` must be the uniquely selected object from a dependency inventory.
// Do not select by index or by ConnectionType alone.
connection.Delete();
```

Before deletion, record at least the connection type, local/partner target paths,
local/partner interface/node identities, and local/partner subnet names. Type-specific
connection names/IDs are additional evidence, not replacements for endpoint identity. If
either endpoint or its selector is incomplete, report `dependency_evidence_incomplete` and
do not delete.

---

## 3. Creating a connection

Create connections from the `ConnectionComposition`. The generic type selects the
connection class.

```csharp
Node localInterface = ...;
DeviceItem partnerTarget = ...;
Node partnerInterface = ...;

if (localInterface == null || partnerTarget == null || partnerInterface == null)
    throw new InvalidOperationException("Connection endpoints were not resolved exactly.");

S7Connection s7 = connections.Create<S7Connection>(
    localInterface,
    partnerTarget,
    partnerInterface);
```

The `Create<T>()` parameters are:

| Parameter | Type | Meaning |
|---|---|---|
| `localInterface` | `Node` | local network node/interface |
| `partnerTarget` | `DeviceItem` | partner device item |
| `partnerInterface` | `Node` | partner network node/interface |

After creation, set the connection-specific properties required by the connection type,
then require `IsValid`, compile hardware, inspect the full compile result, and save only on
success. Keep the creation in a supported transaction so an exception can roll it back.

---

## 4. Connection type fields

`ConnectionType` values:

| Value | Meaning |
|---|---|
| `S7Connection` | S7 connection |
| `FdlConnection` | FDL connection |
| `IsoConnection` | ISO connection |
| `IsoOnTcpConnection` | ISO-on-TCP connection |
| `PtpConnection` | Point-to-point connection |
| `TcpConnection` | TCP connection |
| `UdpConnection` | UDP connection |
| `HmiConnection` | HMI connection |

---

## 5. Type-specific properties

Use these as the first checklist when validating generated code.

| Type | Key properties |
|---|---|
| `S7Connection` | `LocalActiveEstablishment`, `LocalAddress`, `LocalConnectionId`, `LocalConnectionName`, `LocalConnectionResourceId`, `LocalRack`, `LocalSlot`, `LocalTsap`, `LocalUseSimaticACC`, `PartnerActiveEstablishment`, `PartnerAddress`, `PartnerConnectionId`, `PartnerConnectionName`, `PartnerConnectionResourceId`, `PartnerRack`, `PartnerSlot`, `PartnerTsap`, `PartnerUseSimaticACC` |
| `FdlConnection` | `LocalAddress`, `LocalConnectionId`, `LocalConnectionName`, `LocalLsap`, `PartnerAddress`, `PartnerConnectionId`, `PartnerConnectionName`, `PartnerLsap` |
| `IsoConnection` / `IsoOnTcpConnection` | `LocalActiveEstablishment`, `LocalAddress`, `LocalConnectionId`, `LocalConnectionName`, `LocalTsap`, `PartnerActiveEstablishment`, `PartnerAddress`, `PartnerConnectionId`, `PartnerConnectionName`, `PartnerTsap` |
| `TcpConnection` | `LocalActiveEstablishment`, `LocalAddress`, `LocalConnectionId`, `LocalConnectionName`, `LocalPort`, `PartnerActiveEstablishment`, `PartnerAddress`, `PartnerConnectionId`, `PartnerConnectionName`, `PartnerPort` |
| `UdpConnection` | `LocalAddress`, `LocalConnectionId`, `LocalConnectionName`, `LocalPort`, `PartnerAddress`, `PartnerConnectionId`, `PartnerConnectionName`, `PartnerPort` |
| `PtpConnection` | `Direction`, `LocalConnectionId`, `LocalConnectionName`, `LocalConnectionResourceId`, `LocalCpuNumber`, `LocalRack`, `LocalSlot`, `LocalTsap`, `PartnerCpuNumber` |
| `HmiConnection` | `AccessPoint`, `LocalAddress`, `LocalConnectionName`, `Online`, `PartnerAddress`, `TimeSynchronizationMode` |

`PtpConnection.Direction` uses `PtpConnectionDirection`:
`LocalToPartner`, `PartnerToLocal`, or `LocalToAndFromPartner`.

---

## 6. Practical rules

- Treat `IsValid == false` as a signal to inspect missing endpoints/properties before
  running a compile; do not save an invalid connection.
- Never use `ConnectionType`, an index, or one nullable name as the sole selector for a
  destructive action. Complete endpoint identity is required.
- Use strongly typed properties for known fields. Fall back to `IEngineeringObject`
  attributes only when handling version-specific or optional fields.
- `ConnectionConfiguration` in `Siemens.Engineering.Connection` is for choosing online
  connection paths. It is not the same thing as project communication connections.
- Compile hardware after creating or changing communication connections.
