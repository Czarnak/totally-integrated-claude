# IO Systems Reference

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

## 1. PROFINET IO system attributes

`IoSystem` represents a PROFINET IO system controlled by an IO controller.

| Attribute | Type | Writable | Access | Description |
|---|---|---|---|---|
| `Name` | `string` | r/w | property | IO system name |
| `Number` | `int` | r/w | property | IO system number — accepts values the UI would reject; compile fails if invalid |
| `MultipleUseIoSystem` | `bool` | r/w | dynamic | Allow the same IO system on multiple subnets |
| `UseIoSystemNameAsDeviceNameExtension` | `bool` | r/w | dynamic | Auto-extend PROFINET device names (not writable when `MultipleUseIoSystem` is `true`) |
| `MaxNumberIWlanLinksPerSegment` | `int` | r/w | dynamic | Max IWLAN links per segment |

```csharp
IoSystem ioSystem = ...; // obtained via NetworkInterface.IoControllers, etc.

// Modeled attributes — direct property access
string name = ioSystem.Name;
int number  = ioSystem.Number;
ioSystem.Name   = "PN-IO_1";
ioSystem.Number = 100;

// Dynamic attributes
bool multiUse = (bool)((IEngineeringObject)ioSystem).GetAttribute("MultipleUseIoSystem");
((IEngineeringObject)ioSystem).SetAttribute("MultipleUseIoSystem", true);

var dynAttrs = new[] { "MultipleUseIoSystem",
                       "UseIoSystemNameAsDeviceNameExtension",
                       "MaxNumberIWlanLinksPerSegment" };
foreach (var attr in dynAttrs)
    Console.WriteLine($"{attr} = {((IEngineeringObject)ioSystem).GetAttribute(attr)}");
```

---

## 2. DP master system attributes

The PROFIBUS DP master system is also represented as `IoSystem`:

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `Name` | `string` | r/w | DP master system name |
| `Number` | `int` | r/w | DP master system number |

```csharp
IoSystem dpMasterSystem = ...;

string name = dpMasterSystem.Name;
int number  = dpMasterSystem.Number;

dpMasterSystem.Name   = "DP_Master_1";
dpMasterSystem.Number = 42;
```

---

## 3. Transfer areas on PN/DP interfaces

Transfer areas are created on a `NetworkInterface`. Used for PN-PN coupling and
CM DP as DP slave configurations.

```csharp
// Get NetworkInterface from a device item
NetworkInterface netInterface =
    ((IEngineeringServiceProvider)deviceItem).GetService<NetworkInterface>();

TransferAreaComposition transferAreas = netInterface.TransferAreas;

// Create a transfer area
TransferArea ta = transferAreas.Create("TA_Send_1", TransferAreaType.MS);
```

**Transfer area parameters:**

| Parameter | Type | Access | Description |
|---|---|---|---|
| `Name` | `string` | r/w | Transfer area name |
| `Direction` | enum | r/w | Transfer direction |
| `Comment` | `string` | r/w | Comment |
| `LocalToPartnerLength` | `int` | r/w | Bytes from local to partner |
| `PartnerToLocalLength` | `int` | r/w | Bytes from partner to local |
| `LocalAddresses` | `AddressComposition` | r | Local address objects |
| `PartnerAddresses` | `AddressComposition` | r | Partner address objects |
| `PositionNumber` | `int` | r | Position in the transfer area list |
| `Type` | enum | r | Transfer area type |

```csharp
// Configure and delete
ta.Name                  = "TA_Send_1";
ta.LocalToPartnerLength  = 16;
ta.PartnerToLocalLength  = 16;

ta.Delete(); // remove transfer area
```

---

## 4. IsochronousTiToAutoCalculation on IO system

The timing auto-calculation for an IO system is set on the `IoSystem` object itself:

```csharp
// Enable auto-calculation of Ti/To for all devices on this IO system
((IEngineeringObject)ioSystem).SetAttribute("IsochronousTiToAutoCalculation", true);
bool autoCalc = (bool)((IEngineeringObject)ioSystem).GetAttribute("IsochronousTiToAutoCalculation");
```

See `io-timing.md` for per-device interface timing attributes.
