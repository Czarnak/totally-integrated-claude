# PLC Online Status & Connection Reference

Source: TIA Portal Openness V21 — Functions for accessing PLC service and
supporting secure S7 communication with TLS (03/2026), checked against the
installed V21 Base XML API documentation.

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using System;
using Siemens.Engineering;
using Siemens.Engineering.Connection;
using Siemens.Engineering.HW;
using Siemens.Engineering.Online;
using Siemens.Engineering.Online.Configurations;
using Siemens.Engineering.Online.Security;
```

---

## OnlineProvider — entry point

`OnlineProvider` is a service on the CPU `DeviceItem`. Only CPU device items return a non-null
instance. Always null-check before use.

```csharp
OnlineProvider onlineProvider = deviceItem.GetService<OnlineProvider>();
if (onlineProvider == null) { return; } // not a CPU device item
```

For an S7-1500 R/H system, use the system `Device` service instead. Do not look
for `OnlineProvider` on either member CPU:

```csharp
RHOnlineProvider rhOnlineProvider =
    device.GetService<RHOnlineProvider>();
if (rhOnlineProvider == null)
    throw new InvalidOperationException("Selected device is not an R/H system.");

OnlineState primaryState = rhOnlineProvider.PrimaryState;
OnlineState backupState = rhOnlineProvider.BackupState;

// Execute only the one direction named in the approved operation.
OnlineState primaryResult = rhOnlineProvider.GoOnlineToPrimary();
// Or: OnlineState backupResult = rhOnlineProvider.GoOnlineToBackup();
```

`RHOnlineProvider.Configuration` is shared for primary and backup selection.
`GoOnlineToPrimary` and `GoOnlineToBackup` also have `ConfigurationAddress`
overloads. Bind the approved role (primary or backup), not only the IP address,
and never connect to both as a fallback. Call `GoOffline()` only for a connection
this application established.

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

- The call is synchronous and connection time depends on the interface,
  network, target, and protection state.
- Calling `GoOnline()` on an already-online PLC has no effect.
- An active `Transaction` causes `GoOnline()` to fail — go online before
  opening a transaction.

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

Guarded pattern (do not disconnect a connection owned by the user or another
operation):

```csharp
OnlineProvider op = deviceItem.GetService<OnlineProvider>();
if (op == null) { return; }

bool connectedHere = false;
if (op.State == OnlineState.Offline)
{
    if (!op.Configuration.IsConfigured)
        throw new InvalidOperationException("Confirm and configure the target first.");

    OnlineState result = op.GoOnline();
    if (result != OnlineState.Online)
        throw new InvalidOperationException($"Connection ended in state {result}.");

    connectedHere = true;
}
else if (op.State != OnlineState.Online)
{
    throw new InvalidOperationException($"PLC is in transitional state {op.State}.");
}

try
{
    // ... explicitly authorized online work ...
}
finally
{
    if (connectedHere && op.State != OnlineState.Offline)
        op.GoOffline();
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

---

## TLS legitimation and online authentication

For an S7-1500 connection using TLS, `ConnectionConfiguration` can request a
trust or authentication decision through `OnlineLegitimation`. Register the
same delegate instance before the online operation and remove it in `finally`:

```csharp
OnlineConfigurationDelegate legitimation = ConfigureOnline;
config.OnlineLegitimation += legitimation;

try
{
    OnlineState result = onlineProvider.GoOnline();
    if (result != OnlineState.Online)
        throw new InvalidOperationException($"Connection ended in state {result}.");
}
finally
{
    config.OnlineLegitimation -= legitimation;
}
```

The callback must fail closed on every unhandled configuration. For a
`TlsVerificationConfiguration`, bind `PlcName`, `VerificationInfo`, and every
`VerificationCertificate.Certificate` (`X509Certificate2`) to the approved
target. Verify each certificate against an approved fingerprint/thumbprint or
approved chain policy before setting `CurrentSelection` to
`TlsVerificationConfigurationSelection.Trusted`. Merely receiving a
certificate from the target is not verification. Set `NonTrusted` and abort
when the identity differs or evidence is incomplete.

```csharp
private static void ConfigureOnline(OnlineConfiguration onlineConfiguration)
{
    TlsVerificationConfiguration tls =
        onlineConfiguration as TlsVerificationConfiguration;

    if (tls == null)
        throw new NotSupportedException(
            $"Online operation aborted: unhandled configuration " +
            onlineConfiguration.GetType().FullName);

    bool identityMatchesApprovedTarget =
        VerifyApprovedPlcNameAndCertificates(
            tls.PlcName,
            tls.VerificationInfo,
            tls.Certificates);

    tls.CurrentSelection = identityMatchesApprovedTarget
        ? TlsVerificationConfigurationSelection.Trusted
        : TlsVerificationConfigurationSelection.NonTrusted;

    if (!identityMatchesApprovedTarget)
        throw new InvalidOperationException(
            "Online operation aborted: PLC certificate identity mismatch.");
}
```

`OnlineAuthenticationConfiguration` exposes `GetSupportedAuthenticationTypes()`
and `OnlineCredentials`. Select the intended `UserType`, user name, and password
only from the approved authentication policy. Supply a password through
`OnlineCredentials.SetPassword(SecureString)`; never log or persist it. The
`IsSecureCommunication` property must be checked before sending credentials.

`OnlinePasswordConfiguration` and `OnlineReadAccessPassword` are separate
password callback shapes. Handle only the exact shape presented. A callback
exception cancels the operation.

`EnableLegacyCommunication = true` disables TLS in the installed V21 contract.
Never enable it as a compatibility fallback. It requires an explicit risk
decision for the exact target and network; otherwise keep TLS enabled and fail.

## Installed V21 online configuration type catalogue

These 12 public types are the complete installed Base surface under
`Siemens.Engineering.Online.Configurations` and
`Siemens.Engineering.Online.Security`.

## 🛠️ Siemens.Engineering.Online.Configurations.AuthenticationType

Supported/current authentication-type descriptor.

## 🛠️ Siemens.Engineering.Online.Configurations.OnlineAuthenticationConfiguration

Secure-communication flag, supported authentication types, and credentials.

## 🛠️ Siemens.Engineering.Online.Configurations.OnlineConfiguration

Base callback configuration.

## 🛠️ Siemens.Engineering.Online.Configurations.OnlineConfigurationSelection

Base callback selection type.

## 🛠️ Siemens.Engineering.Online.Configurations.OnlineCredentials

Mutable `Name`, `UserType`, and `SetPassword(SecureString)` credentials object.

## 🛠️ Siemens.Engineering.Online.Configurations.OnlinePasswordConfiguration

Password callback with `IsSecureCommunication` and `SetPassword(SecureString)`.

## 🛠️ Siemens.Engineering.Online.Configurations.OnlineReadAccessPassword

Read-access-password callback specialization.

## 🛠️ Siemens.Engineering.Online.Configurations.TlsVerificationConfiguration

PLC name, verification information, certificates, and trust selection.

## 🛠️ Siemens.Engineering.Online.Configurations.TlsVerificationConfigurationSelection

`NonVerified`, `Trusted`, or `NonTrusted`.

## 🛠️ Siemens.Engineering.Online.Configurations.UserType

`None`, `AnonymousUser`, `PasswordOnly`, `ProjectUser`, `GlobalUser`, or
`SingleSignOnUser`.

## 🛠️ Siemens.Engineering.Online.Security.VerificationCertificate

Wrapper exposing the target `X509Certificate2` through `Certificate`.

## 🛠️ Siemens.Engineering.Online.Security.VerificationCertificateComposition

Read-only collection of verification certificates.
