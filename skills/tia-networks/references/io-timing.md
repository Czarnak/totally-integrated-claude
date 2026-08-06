# IO Timing Reference

Source: TIA Portal Openness V21 — Functions on Device Items (03/2026)

> C# only. Do not mix with Python wrapper calls.
> Write access requires the PLC to be **offline**.

---

## Namespaces

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using Siemens.Engineering;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
```

---

## Overview

This file covers timing configuration for two levels:

| Level | Object | Service / Access |
|---|---|---|
| PROFINET interface (IO controller) | `DeviceItem` (PN interface) | dynamic attributes on the device item |
| IO connector (IO device) | `IoConnector` | selected from `NetworkInterface.IoConnectors`; dynamic attributes via `GetAttribute` |

Both are accessed via `GetAttribute` / `SetAttribute` on the relevant `DeviceItem`.

---

## 1. PROFINET interface — IO controller level

The PN interface device item of an IO controller exposes `PnSendClock`.
The device item must be the PROFINET interface submodule, not the CPU.

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `PnSendClock` | `long` | r/w | Send clock in nanoseconds (bus cycle base period) |

```csharp
DeviceItem pnInterface = ...; // PROFINET interface device item of the IO controller

// Read send clock
long sendClockNs = (long)pnInterface.GetAttribute("PnSendClock");

// Write send clock (e.g. 2 ms = 2_000_000 ns)
pnInterface.SetAttribute("PnSendClock", 2_000_000L);
```

---

## 2. IO device interface — isochronous mode

The PROFINET interface device item of an IO device exposes per-device isochronous settings.

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `IsochronousMode` | `bool` | r/w | Enable isochronous mode for this IO device |
| `IsochronousTiToCalculationMode` | `IsochronousTiToCalculationMode` | r/w | How Ti/To are determined |
| `IsochronousTi` | `double` | r/w | Time Ti in ms (when Manual mode) |
| `IsochronousTo` | `double` | r/w | Time To in ms (when Manual mode) |

```csharp
DeviceItem ioDeviceInterface = ...; // PN interface of an IO device

// Read isochronous mode
bool isoEnabled = (bool)ioDeviceInterface.GetAttribute("IsochronousMode");
ioDeviceInterface.SetAttribute("IsochronousMode", true);

// Set calculation mode
ioDeviceInterface.SetAttribute(
    "IsochronousTiToCalculationMode",
    IsochronousTiToCalculationMode.Manual);

// Set Ti/To manually
ioDeviceInterface.SetAttribute("IsochronousTi", 1.0);
ioDeviceInterface.SetAttribute("IsochronousTo", 1.5);
```

**`IsochronousTiToCalculationMode` enum:**

| Value | Description |
|---|---|
| `FromOB` | Ti/To values of the OB configured at the IoSystem are used |
| `AutomaticMinimum` | Ti/To calculated automatically for minimum values |
| `Manual` | User specifies Ti/To values directly |
| `FromSubnet` | Not used by PROFINET interfaces |
| `None` | Not set |

---

## 3. IoConnector — update time and watchdog

An `IoConnector` is an object exposed by the selected PROFINET
`NetworkInterface.IoConnectors` composition. It is not the `DeviceItem` itself.

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `PnUpdateTimeAutoCalculation` | `bool` | r/w | Auto-calculate update time |
| `PnUpdateTime` | `long` | r/w | Update time in nanoseconds |
| `PnUpdateTimeAdaption` | `bool` | r/w | Enable update time adaptation |
| `PnWatchdogFactor` | `int` | r/w | Watchdog factor (multiplied by update time) |
| `PnWatchdogTime` | `long` | r/o | Resulting watchdog time in nanoseconds |
| `RtClass` | `RtClass` | r/w | Real-time class for this IO device |
| `SyncRole` | `SyncRole` | r/o | Synchronisation role (SyncMaster / SyncSlave / Unsynchronized) |
| `PnDeviceNumber` | `int` | r/w | IO device number |

Installed V21 `SyncRole` values are `SyncRole.NotSynchronized`, `SyncRole.SyncMaster`,
`SyncRole.SyncSlave`, and `SyncRole.RedundantSyncMaster`.

```csharp
NetworkInterface networkInterface =
    selectedInterfaceItem.GetService<NetworkInterface>();
if (networkInterface == null)
    throw new InvalidOperationException("Selected item has no NetworkInterface service.");

List<IoConnector> matches = networkInterface.IoConnectors
    .Where(candidate => candidate.ConnectedToIoSystem != null &&
                        candidate.ConnectedToIoSystem.Name == expectedIoSystemName &&
                        candidate.ConnectedToIoSystem.Number == expectedIoSystemNumber)
    .ToList();
if (matches.Count != 1)
    throw new InvalidOperationException($"Expected one IO connector, found {matches.Count}.");
IoConnector ioConnector = matches[0];

// Update time
bool autoCalc = (bool)ioConnector.GetAttribute("PnUpdateTimeAutoCalculation");
ioConnector.SetAttribute("PnUpdateTimeAutoCalculation", false);
ioConnector.SetAttribute("PnUpdateTime", 4_000_000L); // 4 ms in ns

// Watchdog
int wdFactor  = (int)ioConnector.GetAttribute("PnWatchdogFactor");
long wdTimeNs = (long)ioConnector.GetAttribute("PnWatchdogTime"); // read-only
ioConnector.SetAttribute("PnWatchdogFactor", 3);

// RT class and sync role
object rtClass  = ioConnector.GetAttribute("RtClass");
object syncRole = ioConnector.GetAttribute("SyncRole");
int deviceNumber = (int)ioConnector.GetAttribute("PnDeviceNumber");
```

---

## 4. Bulk isochronous configuration example

Setting isochronous mode on a module with ordered dependency (use bulk write):

```csharp
var timingAttrs = new List<KeyValuePair<string, object>>
{
    new KeyValuePair<string, object>("IsochronousTi",   (double)0.5),
    new KeyValuePair<string, object>("IsochronousTo",   (double)0.75),
    new KeyValuePair<string, object>("IsochronousTiToCalculationMode",
        IsochronousTiToCalculationMode.Manual),
    new KeyValuePair<string, object>("IsochronousMode", true)
};

// SetAttributes handles ordering (V19+); abort so a surrounding transaction can roll back.
ioDeviceInterface.SetAttributes(timingAttrs, config =>
{
    Console.Error.WriteLine($"Timing attribute '{config.Name}' failed: {config.Message}");
    config.CurrentSelection = AttributeChoiceSelection.Abort;
});
```
