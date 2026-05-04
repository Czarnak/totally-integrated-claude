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
| HMI tags and tag tables | `Siemens.Engineering.Hmi.Tag` | `hmiTarget.TagFolder` |
| Screens, templates, popup, slide-in | `Siemens.Engineering.Hmi.Screen` | `hmiTarget.ScreenFolder` |
| Connections (to PLCs etc.) | `Siemens.Engineering.Hmi.Communication` | `hmiTarget.Connections` |
| Cycles | `Siemens.Engineering.Hmi.Cycle` | `hmiTarget.Cycles` |
| Text lists | `Siemens.Engineering.Hmi.TextGraphicList` | `hmiTarget.TextLists` |
| Graphic lists | `Siemens.Engineering.Hmi.TextGraphicList` | `hmiTarget.GraphicLists` |
| VB Scripts | `Siemens.Engineering.Hmi.RuntimeScripting` | `hmiTarget.VBScriptFolder` |

### Navigation examples

```csharp
// Tags
TagSystemFolder tagFolder = hmiTarget.TagFolder;
foreach (TagTable table in tagFolder.TagTables)
{
    foreach (Tag tag in table.Tags)
        Console.WriteLine($"Tag: {tag.Name}");
}

// Screens
ScreenSystemFolder screenFolder = hmiTarget.ScreenFolder;
foreach (Screen screen in screenFolder.Screens)
    Console.WriteLine($"Screen: {screen.Name}");

// Connections
ConnectionComposition connections = hmiTarget.Connections;
foreach (Connection conn in connections)
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
TagTable table = hmiTarget.TagFolder.TagTables.Find("HMI_Tags");
table.Export(new FileInfo(@"C:\Export\HMI_Tags.xml"), ExportOptions.None);

// Import a tag table from XML
hmiTarget.TagFolder.TagTables.Import(
    new FileInfo(@"C:\Export\HMI_Tags.xml"),
    ImportOptions.Overwrite);
```

For cross-domain import/export strategy and file format details, see `tia-import-export`.

---

## V21 API Reference: Siemens.Engineering.Hmi

## 🛠️ Siemens.Engineering.Hmi.HmiTarget
>
> Represents the target device

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 📦 `Siemens#Engineering#IEngineeringServiceProvider#GetServiceInfos`: Returns a collection of EngineeringServiceInfo objects describing the different services on this object.
- 🔧 `Connections`: Composition of connections
- 🔧 `Cycles`: Composition of cycles
- 🔧 `GraphicLists`: Composition of graphic lists
- 🔧 `ScreenFolder`: Gets the Hmi screen system folder
- 🔧 `ScreenGlobalElements`: Gets the Hmi screen global elements
- 🔧 `ScreenOverview`: Gets the Hmi screen overview
- 🔧 `ScreenPopupFolder`: System folder for the HMI pop-up screens
- 🔧 `ScreenSlideinFolder`: System folder for the HMI slide-in screens
- 🔧 `ScreenTemplateFolder`: Composition of screen template folders
- 🔧 `TagFolder`: Gets the Hmi tag system folder
- 🔧 `TextLists`: Composition of text lists
- 🔧 `VBScriptFolder`: Gets the VBScript system folder
- 🔧 `Author`: Author of the device
- 🔧 `Name`: The name of the Hmi target
- 📦 `ImportScreenGlobalElements(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of screen global elements
- 📦 `ImportScreenOverview(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a screen overview
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
