# Software Container Reference

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.SW;
using Siemens.Engineering.Hmi;
```

---

## 1. SoftwareContainer service

A `DeviceItem` that hosts software (a CPU or an HMI panel) exposes a `SoftwareContainer`
service. The `Software` property returns the concrete software object — cast it to
`PlcSoftware` or `HmiTarget` depending on the device type.

```csharp
SoftwareContainer sc = deviceItem.GetService<SoftwareContainer>();
if (sc == null) return; // this device item has no software

Software sw = sc.Software;
```

---

## 2. GetPlcSoftware — standard helper pattern

```csharp
private static PlcSoftware GetPlcSoftware(Device device)
{
    foreach (DeviceItem item in device.DeviceItems)
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
    foreach (DeviceItem item in device.DeviceItems)
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
    foreach (DeviceItem item in device.DeviceItems)
    {
        SoftwareContainer sc = item.GetService<SoftwareContainer>();
        if (sc == null) continue;

        if (sc.Software is PlcSoftware)
            Console.WriteLine($"{device.Name} → PLC");
        else if (sc.Software is HmiTarget)
            Console.WriteLine($"{device.Name} → HMI");
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
CompilerResult result = compile.Compile();
Console.WriteLine($"Compile state: {result.State}, Errors: {result.ErrorCount}");
```

See `tia-project-general/references/compile.md` for full `CompilerResult` traversal.
