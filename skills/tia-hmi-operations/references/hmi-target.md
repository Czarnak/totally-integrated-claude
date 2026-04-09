# HMI Target Reference

Source: TIA Portal Openness V21 — Functions for Accessing HMI Device Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.Hmi;
using Siemens.Engineering.Hmi.Tag;
using Siemens.Engineering.Hmi.Screen;
using Siemens.Engineering.Hmi.Cycle;
using Siemens.Engineering.Hmi.Communication;
using Siemens.Engineering.Hmi.Globalization;
using Siemens.Engineering.Hmi.RuntimeScripting;
using Siemens.Engineering.Hmi.TextGraphicList;
using Siemens.Engineering.Compiler;
```

Note: `HmiTarget` is in `Siemens.Engineering.Hmi`. A using alias is often added to avoid
conflicts with `Siemens.Engineering.SW.Software`:

```csharp
using HmiTarget = Siemens.Engineering.Hmi.HmiTarget;
```

---

## 1. Accessing HmiTarget from a device

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
if (hmiTarget == null)
    throw new InvalidOperationException($"{device.Name} is not an HMI device.");
```

---

## 2. Compile HMI software

```csharp
using Siemens.Engineering.Compiler;

private static void CompileHmi(HmiTarget hmiTarget)
{
    ICompilable compileService = hmiTarget.GetService<ICompilable>();
    CompilerResult result = compileService.Compile();

    Console.WriteLine($"HMI compile: {result.State}  " +
                      $"Errors: {result.ErrorCount}  " +
                      $"Warnings: {result.WarningCount}");
}
```

See `tia-project-general/references/compile.md` for full `CompilerResult` traversal.

---

## 3. HMI object model — composition overview

All compositions are accessed from the `HmiTarget` root object.

| Task | Namespace | Entry point on HmiTarget |
|---|---|---|
| HMI tags and tag tables | `Siemens.Engineering.Hmi.Tag` | `hmiTarget.TagTableFolder` |
| Screens, templates, popup, slide-in | `Siemens.Engineering.Hmi.Screen` | `hmiTarget.ScreenFolder` |
| Connections (to PLCs etc.) | `Siemens.Engineering.Hmi.Communication` | `hmiTarget.ConnectionFolder` |
| Cycles | `Siemens.Engineering.Hmi.Cycle` | `hmiTarget.CycleFolder` |
| Text lists | `Siemens.Engineering.Hmi.TextGraphicList` | `hmiTarget.TextListFolder` |
| Graphic lists | `Siemens.Engineering.Hmi.TextGraphicList` | `hmiTarget.GraphicListFolder` |
| VB Scripts | `Siemens.Engineering.Hmi.RuntimeScripting` | `hmiTarget.ScriptFolder` |
| Project texts (multilingual) | `Siemens.Engineering.Hmi.Globalization` | `hmiTarget.ProjectTextFolder` |

### Navigation examples

```csharp
// Tags
HmiTagTableFolder tagFolder = hmiTarget.TagTableFolder;
foreach (HmiTagTable table in tagFolder.TagTables)
{
    foreach (HmiTag tag in table.Tags)
        Console.WriteLine($"Tag: {tag.Name}");
}

// Screens
HmiScreenFolder screenFolder = hmiTarget.ScreenFolder;
foreach (HmiScreen screen in screenFolder.Screens)
    Console.WriteLine($"Screen: {screen.Name}");

// Connections
HmiConnectionFolder connFolder = hmiTarget.ConnectionFolder;
foreach (HmiConnection conn in connFolder.Connections)
    Console.WriteLine($"Connection: {conn.Name}");
```

---

## 4. Determining HMI device type

Use the `TypeIdentifier` to distinguish classic HMI (TP/KTP/Comfort) from Unified panels:

```csharp
string typeId = device.TypeIdentifier;
bool isUnified = typeId.Contains("Unified") ||
                 typeId.Contains("6AV2 128") || // Unified Comfort Panel
                 typeId.Contains("6AV2 151");   // Unified PC

Console.WriteLine(isUnified ? "Unified HMI" : "Classic HMI");
```

Unified devices use the same `HmiTarget` root but some compositions (e.g. logs, events,
plant model, advanced dynamization) are Unified-specific and may not be present on
classic panels. Always null-check compositions before use.

---

## 5. Import/export for HMI objects

HMI data is exported/imported as XML files. The import/export service is accessed directly
on the relevant composition (tag table, screen, connection, etc.).

```csharp
// Export a tag table to XML
HmiTagTable table = hmiTarget.TagTableFolder.TagTables.Find("HMI_Tags");
table.Export(new FileInfo(@"C:\Export\HMI_Tags.xml"), ExportOptions.None);

// Import a tag table from XML
hmiTarget.TagTableFolder.TagTables.Import(
    new FileInfo(@"C:\Export\HMI_Tags.xml"),
    ImportOptions.Overwrite);
```

For cross-domain import/export strategy and file format details, see `tia-import-export`.
