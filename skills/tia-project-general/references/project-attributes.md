# Project Attributes Reference

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using System;
using Siemens.Engineering;
```

---

## 1. Project attributes

All attributes are read-only after project creation except where noted.

| Attribute | Type | Writable | Description |
|---|---|---|---|
| `Author` | `string` | r/o | Author set at creation |
| `Comment` | `MultilingualText` | r/o | Multilingual project comment |
| `Copyright` | `string` | r/o | Copyright string |
| `CreationTime` | `DateTime` | r/o | UTC timestamp of creation |
| `Family` | `string` | r/o | Project family |
| `IsModified` | `bool` | r/o | `true` if unsaved changes exist |
| `LanguageSettings` | `LanguageSettings` | r/o | Project language configuration |
| `LastModified` | `DateTime` | r/o | UTC timestamp of last modification |
| `LastModifiedBy` | `string` | r/o | Name of last modifier |
| `Name` | `string` | r/o | Project name |
| `Path` | `FileInfo` | r/o | Absolute path to project file |
| `Size` | `Int64` | r/o | Size in KB |
| `Version` | `string` | r/o | TIA Portal version string |
| `IsSimulationDuringBlockCompilationEnabled` | `bool` | **r/w** | Enable PLCSIM Advanced simulation |
| `IsVirtualPlcDuringBlockCompilationEnabled` | `bool` | **r/w** | Enable virtual PLC support |

```csharp
private static void ReadProjectAttributes(Project project)
{
    string name    = project.Name;
    string version = project.Version;
    string author  = project.Author;
    DateTime created  = project.CreationTime;
    DateTime modified = project.LastModified;
    string modifiedBy = project.LastModifiedBy;
    bool hasChanges   = project.IsModified;
    Int64 sizeKb      = project.Size;
    FileInfo path     = project.Path;

    // Simulation support flags (r/w)
    bool simEnabled    = project.IsSimulationDuringBlockCompilationEnabled;
    bool virtualEnabled = project.IsVirtualPlcDuringBlockCompilationEnabled;
    project.IsSimulationDuringBlockCompilationEnabled = false;
    project.IsVirtualPlcDuringBlockCompilationEnabled = true;
}
```

---

## 2. Project history

History entries are read-only. Text language matches the TIA Portal UI language;
headless sessions always return English.

```csharp
private static void ReadProjectHistory(Project project)
{
    HistoryEntryComposition history = project.HistoryEntries;
    foreach (HistoryEntry entry in history)
    {
        string text     = entry.Text;
        DateTime time   = entry.DateTime;
        Console.WriteLine($"{time:yyyy-MM-dd HH:mm:ss} — {text}");
    }
}
```

---

## 3. Used products

Lists all TIA Portal products/packages that contributed to the project.

```csharp
private static void ReadUsedProducts(Project project)
{
    UsedProductComposition products = project.UsedProducts;
    foreach (UsedProduct product in products)
    {
        string productName    = product.Name;
        string productVersion = product.Version;
        Console.WriteLine($"{productName} {productVersion}");
    }
}
```

---

## 4. Project graphics

```csharp
// Find and delete a named project graphic
MultiLingualGraphicComposition graphics = project.Graphics;
MultiLingualGraphic graphic = graphics.Find("Graphic XYZ");
graphic?.Delete();
```

---

## 5. Object identity across sessions

`ObjectIdentifierProvider` issues stable string identifiers for engineering objects
that survive close/re-open cycles. Supported object types: `Device`, `DeviceItem`,
`CodeBlock` subtypes, `GlobalDB`, `InstanceDB`, `ArrayDB`, `PlcStruct`,
`TechnologicalInstanceDB`, and tag/unit types.

```csharp
private static void DemonstrateObjectIdentity(Project project)
{
    ObjectIdentifierProvider idProvider =
        project.GetService<ObjectIdentifierProvider>();

    // Get a stable string ID for an object
    Device device = project.Devices.First();
    string deviceId = idProvider.GetIdentifier(device);

    // Re-find the same object using its ID (e.g. after re-opening the project)
    Device sameDevice = idProvider.Find(deviceId) as Device;
}
```

Throws `EngineeringTargetInvocationException` if called with `null` or a disposed object.
Throws `EngineeringObjectDisposedException` if the object has been deleted.
