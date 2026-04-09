# Device Creation Reference

Source: TIA Portal Openness V21 — Functions on Devices (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
```

---

## 1. TypeIdentifier format

Every hardware object in TIA Portal is identified by a `TypeIdentifier` string:
`<TypeIdentifierType>:<Identifier>`

### OrderNumber (most common — catalog hardware)

| Format | Example |
|---|---|
| `OrderNumber:<PN>` | `OrderNumber:3RK1 200-0CE00-0AA2` |
| `OrderNumber:<PN>/<FW>` | `OrderNumber:6ES7 510-1DJ01-0AB0/V2.0` |
| `OrderNumber:<PN>//<AdditionalId>` | `OrderNumber:6AV2 124-2DC01-0AX0//Landscape` |

Firmware version is optional if only one version is installed. `AdditionalId` is needed
when OrderNumber + FW still don't uniquely identify the object.

### GSD (GSD/GSDML-installed devices)

| Format | Example |
|---|---|
| `GSD:<GsdName>/<GsdType>` | `GSD:SIEM8139.GSD/DAP` |
| `GSD:<GsdName>/<GsdType>/<GsdId>` | `GSD:SIEM8139.GSD/M/4` |

`GsdType` values: `D` (Device), `R` (Rack), `DAP` (HeadModule), `M` (Module), `SM` (Submodule)

### System (objects not covered by OrderNumber or GSD)

| Format | Example |
|---|---|
| `System:<SystemTypeId>` | `System:Device.S7300` |
| `System:<SystemTypeId>/<AdditionalId>` | — |

Prefix hints: `Connection.`, `Subnet.`, `Device.`, `Rack.`

> **Tip:** Enable "Display type identifier" in TIA Portal options
> (Options → Settings → Hardware configuration → Display of the type identifier)
> to read TypeIdentifiers from the hardware catalog viewer.

---

## 2. Querying the hardware catalog before creation

Before creating a device, check that it is installed:

```csharp
private static void CheckAndCreate(TiaPortal tiaPortal, Project project)
{
    // Search catalog — empty string returns all entries
    IList<CatalogEntry> entries = tiaPortal.HardwareCatalog.Find("1516");

    if (!entries.Any())
    {
        Console.WriteLine("Module not found in catalog — install GSD/HSP first.");
        return;
    }

    CatalogEntry first = entries.First();
    Console.WriteLine($"Found: {first.TypeName} ({first.TypeIdentifier})");
    Console.WriteLine($"  Article: {first.ArticleNumber}");
    Console.WriteLine($"  Version: {first.Version}");
    Console.WriteLine($"  Path:    {first.CatalogPath}");

    // Create using the discovered TypeIdentifier
    project.Devices.CreateWithItem(first.TypeIdentifier, "PLC_1", "NewDevice");
}

// Filter catalog by compatibility with an existing module
IList<CatalogEntry> compatible = tiaPortal.HardwareCatalog.Find(
    "1BL00",                                      // filter string
    "OrderNumber:6ES7 516-2GN00-0AB0/V2.9");      // must be compatible/pluggable with this
```

**`CatalogEntry` attributes:**

| Attribute | Description |
|---|---|
| `ArticleNumber` | Order number, e.g. `6ES7 516-3AN00-0AB0` |
| `TypeIdentifier` | Full type identifier for use in `CreateWithItem` / `Create` |
| `TypeIdentifierNormalized` | TypeIdentifier without spaces |
| `TypeName` | Human-readable name, e.g. `CPU 1516-3 PN/DP` |
| `Version` | Firmware version, e.g. `V1.0` |
| `CatalogPath` | Catalog tree path |
| `Description` | Full descriptive text |

---

## 3. Creating a device

### CreateWithItem — creates device + first module in one call

```csharp
// From order number
Device plc = project.Devices.CreateWithItem(
    "OrderNumber:6ES7 510-1DJ01-0AB0/V2.0",
    "PLC_1",        // DeviceItem (module) name
    "NewDevice");   // Device name

// From GSD
Device gsdDevice = project.Devices.CreateWithItem(
    "GSD:SIEM8139.GSD/M/4",
    "GSD Module",
    "NewGsdDevice");
```

### Create — creates only the device shell (no module)

Use when you want to plug modules manually afterwards:

```csharp
Device rack = project.Devices.Create("System:Device.S7300", "S7300Device");
Device gsdOnly = project.Devices.Create("GSD:SIEM8139.GSD/D", "GSD Device");
```

### Create in a device group

Both `CreateWithItem` and `Create` are available on `DeviceUserGroup.Devices`:

```csharp
DeviceUserGroup group = project.DeviceGroups.Find("Line_1");
Device plc = group.Devices.CreateWithItem(
    "OrderNumber:6ES7 515-2AM01-0AB0/V2.0",
    "CPU_1",
    "PLC_Line1");
```

---

## 4. Deleting a device

```csharp
// Delete from root devices
Device toDelete = project.Devices.Find("OldPLC");
toDelete?.Delete();

// Delete from ungrouped devices group
Device ungrouped = project.UngroupedDevicesGroup.Devices.Find("RemoteIO_1");
ungrouped?.Delete();
```

After `Delete()`, the object reference is disposed. Do not use it again.

---

## 5. Reading TypeIdentifier from an existing object

```csharp
string typeId = device.TypeIdentifier;
string itemTypeId = deviceItem.TypeIdentifier;
```
