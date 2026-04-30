# Online Connection Configuration Reference

Source: TIA Portal PublicAPI V21 XML docs, `Siemens.Engineering.Base.xml`.

> C# only. Do not mix with Python wrapper calls.
> This configures the online path used to reach a target. It does not create project
> topology, subnets, nodes, or communication connections.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.Connection;
using Siemens.Engineering.Online;
```

---

## 1. Entry point

Access `ConnectionConfiguration` from an `OnlineProvider`.

```csharp
OnlineProvider onlineProvider =
    ((IEngineeringServiceProvider)deviceItem).GetService<OnlineProvider>();

ConnectionConfiguration config = onlineProvider.Configuration;
```

`ConnectionConfiguration` exposes:

| Member | Meaning |
|---|---|
| `Modes` | available connection modes |
| `IsConfigured` | `true` when connection parameters are already configured |
| `EnableLegacyCommunication` | disables TLS for legacy communication when set |
| `ApplyConfiguration(ConfigurationTargetInterface)` | applies a selected target interface |
| `ApplyConfiguration(ConfigurationAddress)` | applies a selected gateway/subnet address |

Do not call `ApplyConfiguration()` while a PLC connection is already active.

---

## 2. Browse modes, PC interfaces, target interfaces

```csharp
foreach (ConfigurationMode mode in config.Modes)
{
    Console.WriteLine($"Mode: {mode.Name}");
    foreach (ConfigurationPcInterface pcInterface in mode.PcInterfaces)
    {
        Console.WriteLine($"{pcInterface.Name} #{pcInterface.Number}");
        foreach (ConfigurationTargetInterface target in pcInterface.TargetInterfaces)
            Console.WriteLine($"  Target: {target.Name}");
    }
}
```

Find common entries by name/number:

```csharp
ConfigurationMode mode = config.Modes.Find("PN/IE");
ConfigurationPcInterface pcInterface = mode.PcInterfaces.Find("PLCSIM", 1);
ConfigurationTargetInterface target = pcInterface.TargetInterfaces.Find("2 X3");
```

`ConfigurationPcInterface` also exposes `Addresses`, `Subnets`, and
`GetAccessibleDevices()`.

---

## 3. Apply a target interface

```csharp
if (!config.IsConfigured)
{
    ConfigurationMode mode = config.Modes.Find("PN/IE");
    ConfigurationPcInterface pcInterface = mode.PcInterfaces.Find("PLCSIM", 1);
    ConfigurationTargetInterface target = pcInterface.TargetInterfaces.Find("2 X3");

    bool applied = config.ApplyConfiguration(target);
    if (!applied)
        throw new InvalidOperationException("Online path was not applied.");
}

onlineProvider.GoOnline();
```

---

## 4. Apply a subnet/gateway address

Use this path when the online route must go through a configured subnet/gateway address.

```csharp
ConfigurationMode mode = config.Modes.Find("PN/IE");
ConfigurationPcInterface pcInterface = mode.PcInterfaces.Find("PLCSIM", 1);

ConfigurationSubnet subnet = pcInterface.Subnets.Find("PN/IE_1");
ConfigurationGateway gateway = subnet.Gateways.Find("Gateway 1");
ConfigurationAddress gatewayAddress = gateway.Addresses.Find("192.168.0.2");

bool applied = config.ApplyConfiguration(gatewayAddress);
```

Relevant compositions:

| Composition | Key members |
|---|---|
| `ConfigurationModeComposition` | `Find(string name)` |
| `ConfigurationPcInterfaceComposition` | `Find(string name, int number)` |
| `ConfigurationTargetInterfaceComposition` | `Find(string name)` |
| `ConfigurationSubnetComposition` | `Find(string name)` |
| `ConfigurationGatewayComposition` | `Find(string name)` |
| `ConfigurationAddressComposition` | `Create(string address)`, `Find(string name)` |

---

## 5. Accessible devices

`ConfigurationPcInterface.GetAccessibleDevices()` returns online devices visible through
that PC interface.

```csharp
foreach (ConfigurationAccessibleDevice device in pcInterface.GetAccessibleDevices())
{
    Console.WriteLine(
        $"{device.Name} {device.DeviceSeries} {device.Address} {device.MACAddress}");
}
```

`ConfigurationAccessibleDevice` exposes `Name`, `DeviceSeries`, `Address`, and
`MACAddress`.

---

## 6. Practical rules

- Use this reference for online path selection before `GoOnline()`.
- Use `subnets-and-nodes.md` for modeled project topology and node IP/device-name
  attributes.
- Use `communication-connections.md` for configured PLC/HMI/TCP/UDP/S7/etc.
  project communication connections.
- `ApplyConfiguration()` overwrites the previously selected online path.
