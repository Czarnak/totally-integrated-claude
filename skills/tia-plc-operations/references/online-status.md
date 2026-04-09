# PLC Online Status & Connection Reference

Source: TIA Portal Openness V21 — Functions for accessing PLC service (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## OnlineProvider — entry point

`OnlineProvider` is a service on the CPU `DeviceItem`. Only CPU device items return a non-null
instance. Always null-check before use.

```csharp
OnlineProvider onlineProvider = deviceItem.GetService<OnlineProvider>();
if (onlineProvider == null) { return; } // not a CPU device item
```

---

## Reading online state

```csharp
OnlineState state = onlineProvider.State;
```

`OnlineState` enum values:

| Value | Meaning |
| --- | --- |
| `Offline` | No connection |
| `Connecting` | Connection being established |
| `Online` | Connected |
| `Disconnecting` | Disconnecting in progress |
| `Incompatible` | Connected but software/hardware mismatch |
| `NotReachable` | Cannot reach the device |
| `Protected` | Device is password protected |

Reading state for all PLCs in a project:

```csharp
foreach (Device device in project.Devices)
{
    foreach (DeviceItem deviceItem in device.DeviceItems)
    {
        OnlineProvider onlineProvider =
            deviceItem.GetService<OnlineProvider>();
        if (onlineProvider != null)
        {
            OnlineState state = onlineProvider.State;
            Console.WriteLine($"{deviceItem.Name}: {state}");
        }
    }
}
```

---

## Going online

Standard (uses configured connection parameters):

```csharp
OnlineState resultState = onlineProvider.GoOnline();
```

**Notes:**

- Call can take 1–16 seconds to complete.
- Calling `GoOnline()` on an already-online PLC has no effect.
- A `Transaction` active via `StartTransaction()` will cause `GoOnline()` to fail — go online
  before opening a transaction.

With a custom IP address (for S7-1200/1500 only — not S7-300/400):

```csharp
ConfigurationPcInterface pcInterface =
    onlineProvider.Configuration.Modes.Find("PN/IE")
                  .PcInterfaces.Find("PLCSIM", 1);

ConfigurationAddress customAddress =
    pcInterface.Addresses.Create("10.119.57.54");

OnlineState resultState = onlineProvider.GoOnline(customAddress);
```

---

## Going offline

```csharp
onlineProvider.GoOffline();
```

Go offline for all PLCs in a project:

```csharp
foreach (Device device in project.Devices)
    foreach (DeviceItem deviceItem in device.DeviceItems)
    {
        OnlineProvider op = deviceItem.GetService<OnlineProvider>();
        op?.GoOffline();
    }
```

Guarded pattern (check IsConfigured before going online, always go offline after):

```csharp
OnlineProvider op = deviceItem.GetService<OnlineProvider>();
if (op == null) { return; }

if (op.Configuration.IsConfigured)
{
    op.GoOnline();
    try
    {
        // ... online work ...
    }
    finally
    {
        op.GoOffline();
    }
}
```

---

## Connection configuration

`ConnectionConfiguration` exposes the available connection modes, PC interfaces, slots,
subnets, and gateways. Access it through `OnlineProvider.Configuration`.

```csharp
ConnectionConfiguration config = onlineProvider.Configuration;
```

### Enumerate connection modes and PC interfaces

```csharp
foreach (ConfigurationMode mode in config.Modes)
{
    Console.WriteLine($"Mode: {mode.Name}");                    // e.g. "PN/IE"
    foreach (ConfigurationPcInterface iface in mode.PcInterfaces)
    {
        Console.WriteLine($"  Interface: {iface.Name} ({iface.Number})");
        foreach (ConfigurationTargetInterface slot in iface.TargetInterfaces)
            Console.WriteLine($"    Slot: {slot.Name}");
    }
}
```

### Find by name

```csharp
ConfigurationMode mode = config.Modes.Find("PN/IE");
ConfigurationPcInterface iface = mode.PcInterfaces.Find("PLCSIM", 1);
ConfigurationTargetInterface slot = iface.TargetInterfaces.Find("2 X3");
```

### Enumerate subnets and gateways on a PC interface

```csharp
foreach (ConfigurationSubnet subnet in iface.Subnets)
{
    Console.WriteLine($"Subnet: {subnet.Name}");
    foreach (ConfigurationGateway gw in subnet.Gateways)
    {
        Console.WriteLine($"  Gateway: {gw.Name}");
        foreach (ConfigurationAddress addr in gw.Addresses)
            Console.WriteLine($"    Address: {addr.Name} = {addr.Address}");
    }
}
```

Find by name or address:

```csharp
ConfigurationSubnet subnet = iface.Subnets.Find("PN/IE_1");
ConfigurationAddress subnetAddr = subnet.Addresses.Find("192.168.0.1");

ConfigurationGateway gateway = subnet.Gateways.Find("Gateway 1");
ConfigurationAddress gwAddr = gateway.Addresses.Find("192.168.0.2");
```

---

## Setting connection parameters

Use `ApplyConfiguration()` to set the active target interface or gateway address.
All previously set parameters are overwritten on each call.

**Note:** If the connection parameters were already configured in TIA Portal GUI,
`ApplyConfiguration()` is not required. Calling it while a PLC connection is already active
throws an exception.

Set via slot:

```csharp
ConnectionConfiguration config = onlineProvider.Configuration;
ConfigurationMode mode = config.Modes.Find(@"PN/IE");
ConfigurationPcInterface iface = mode.PcInterfaces.Find("PLCSIM", 1);
ConfigurationTargetInterface slot = iface.TargetInterfaces.Find("2 X3");

config.ApplyConfiguration(slot);
onlineProvider.GoOnline();
```

Set via gateway address:

```csharp
ConfigurationPcInterface iface =
    config.Modes.Find(@"PN/IE").PcInterfaces.Find("PLCSIM", 1);
ConfigurationSubnet subnet = iface.Subnets.Find(subnetName);
ConfigurationAddress gwAddr = subnet.Gateways.Find("Gateway 1")
                                     .Addresses.Find(gatewayAddressName);

config.ApplyConfiguration(gwAddr);
onlineProvider.GoOnline();
```

Check if already configured before applying:

```csharp
bool isConfigured = config.IsConfigured; // true if parameters are set
```
