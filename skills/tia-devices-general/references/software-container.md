# Software Container Reference

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using System;
using System.Collections.Generic;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.SW;
using Siemens.Engineering.Hmi;
using Siemens.Engineering.HmiUnified;
```

---

## 1. SoftwareContainer service

A `DeviceItem` that hosts software (a CPU or an HMI panel) exposes a `SoftwareContainer`
service. The `Software` property returns the concrete software object — use
`PlcSoftware` for STEP 7, `HmiTarget` for classic WinCC, or `HmiSoftware` for
WinCC Unified. These are distinct object models.

```csharp
SoftwareContainer sc = deviceItem.GetService<SoftwareContainer>();
if (sc == null) return; // this device item has no software

Software sw = sc.Software;
```

---

## 2. GetPlcSoftware — standard helper pattern

```csharp
private static IEnumerable<DeviceItem> EnumerateDeviceItems(DeviceItemComposition items)
{
    foreach (DeviceItem item in items)
    {
        yield return item;
        foreach (DeviceItem child in EnumerateDeviceItems(item.DeviceItems))
            yield return child;
    }
}

private static PlcSoftware GetPlcSoftware(Device device)
{
    foreach (DeviceItem item in EnumerateDeviceItems(device.DeviceItems))
    {
        SoftwareContainer sc = item.GetService<SoftwareContainer>();
        if (sc != null)
        {
            PlcSoftware plcSw = sc.Software as PlcSoftware;
            if (plcSw != null) return plcSw;
        }
    }
    return null;
}
```

Usage:

```csharp
PlcSoftware plcSoftware = GetPlcSoftware(device);
if (plcSoftware == null) throw new InvalidOperationException("Not a PLC device.");

// Access blocks
PlcBlockSystemGroup blockGroup = plcSoftware.BlockGroup;
```

---

## 3. GetHmiTarget — standard helper pattern

```csharp
private static HmiTarget GetHmiTarget(Device device)
{
    foreach (DeviceItem item in EnumerateDeviceItems(device.DeviceItems))
    {
        SoftwareContainer sc = item.GetService<SoftwareContainer>();
        if (sc != null)
        {
            HmiTarget hmi = sc.Software as HmiTarget;
            if (hmi != null) return hmi;
        }
    }
    return null;
}
```

For WinCC Unified, use a separate helper and return the Unified type rather than
casting it to classic `HmiTarget`:

```csharp
private static HmiSoftware GetUnifiedHmiSoftware(Device device)
{
    foreach (DeviceItem item in EnumerateDeviceItems(device.DeviceItems))
    {
        SoftwareContainer container = item.GetService<SoftwareContainer>();
        HmiSoftware unified = container?.Software as HmiSoftware;
        if (unified != null) return unified;
    }
    return null;
}
```

Usage:

```csharp
HmiTarget hmiTarget = GetHmiTarget(device);
if (hmiTarget == null) throw new InvalidOperationException("Not an HMI device.");

// Access HMI screens
// hmiTarget.Screens ...
```

---

## 4. Checking device type from software

```csharp
private static void ClassifyDevice(Device device)
{
    foreach (DeviceItem item in EnumerateDeviceItems(device.DeviceItems))
    {
        SoftwareContainer sc = item.GetService<SoftwareContainer>();
        if (sc == null) continue;

        if (sc.Software is PlcSoftware)
            Console.WriteLine($"{device.Name} → PLC");
        else if (sc.Software is HmiTarget)
            Console.WriteLine($"{device.Name} → classic HMI");
        else if (sc.Software is HmiSoftware)
            Console.WriteLine($"{device.Name} → Unified HMI");
        else
            Console.WriteLine($"{device.Name} → Other software target");
    }
}
```

---

## 5. Accessing software attributes

```csharp
SoftwareContainer sc = deviceItem.GetService<SoftwareContainer>();
if (sc != null)
{
    PlcSoftware plcSw = sc.Software as PlcSoftware;
    if (plcSw != null)
        Console.WriteLine($"PLC software name: {plcSw.Name}");
}
```

---

## 6. Compile from software container entry point

After obtaining `PlcSoftware` or `HmiTarget`, compile via `ICompilable`:

```csharp
using Siemens.Engineering.Compiler;

ICompilable compile = plcSoftware.GetService<ICompilable>();
if (compile == null)
    throw new InvalidOperationException("The selected software target is not compilable.");

CompilerResult result = compile.Compile();
Console.WriteLine($"Compile state: {result.State}, Errors: {result.ErrorCount}");
if (result.State == CompilerResultState.Error || result.ErrorCount > 0)
    throw new InvalidOperationException("Compile failed; inspect CompilerResult messages and do not save.");
```

See `tia-project-general/references/compile.md` for full `CompilerResult` traversal.

---

## API Reference (V21)

## 🛠️ Siemens.Engineering.HW.Software
>
> Represents a base class of an object containing software components

- 🔧 `Name`: The name of the software base

## 🛠️ Siemens.Engineering.HW.Features.SoftwareContainer
>
> Represents a class containing software components

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `Software`: Gets the software target containing the software elements of the device
