# Device Attributes Reference

Source: TIA Portal Openness V21 — Functions on Devices (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Extensions; // GsdDevice
```

---

## 1. Mandatory device and device-item attributes

All devices and device items expose these attributes. Write access varies by object type
and configuration state. PLC must be offline for write operations.

| Attribute | Type | Writable | Access | Notes |
|---|---|---|---|---|
| `Name` | `string` | r/w (sometimes r/o) | modeled | Device/item name |
| `TypeIdentifier` | `string` | r/o | modeled | Full type identifier string |
| `TypeName` | `string` | r/o | dynamic | Human-readable type name |
| `IsGsd` | `bool` | r/o | modeled | `true` if installed via GSD/GSDML |
| `Author` | `string` | r/w | dynamic | Author field |
| `Comment` | `string` | r/w | dynamic | Single-language comment |
| `CommentML` | `MultilingualText` | r/w | dynamic | Multilingual comment |

```csharp
// Modeled attributes — direct property access
string name     = device.Name;
bool   isGsd    = device.IsGsd;
string typeId   = device.TypeIdentifier;

// Dynamic attributes — via GetAttribute
string typeName = (string)device.GetAttribute("TypeName");
string author   = (string)device.GetAttribute("Author");
string comment  = (string)device.GetAttribute("Comment");
device.SetAttribute("Author", "AutoTool");
device.SetAttribute("Comment", "Auto-generated");
```

---

## 2. GSD device service

Devices installed via GSD/GSDML provide additional identification via `GsdDevice`:

```csharp
// On a Device
GsdDevice gsdDev = ((IEngineeringServiceProvider)device).GetService<GsdDevice>();
if (gsdDev != null)
{
    string gsdId    = gsdDev.GsdId;      // e.g. "4"
    string gsdName  = gsdDev.GsdName;    // e.g. "SIEM8139.GSD"
    string gsdType  = gsdDev.GsdType;    // e.g. "M"
    bool isProfibus = gsdDev.IsProfibus;
    bool isProfinet = gsdDev.IsProfinet;
}

// On a DeviceItem
GsdDevice gsdItem = ((IEngineeringServiceProvider)deviceItem).GetService<GsdDevice>();
```

---

## 3. CustomIdentityProvider — Application IDs

Key-value pairs attached to a device or device-item, scoped to the current Openness
session. Not persisted in the project file.

**Constraints:** max 64 IDs per object; key and value max 128 characters each.
Duplicate keys overwrite the previous value.

```csharp
// Get the service
CustomIdentityProvider idService = device.GetService<CustomIdentityProvider>();

// Set an Application ID (key-value pair)
idService.Set("ToolId", "AutoGen-001");

// Retrieve
string value = idService.Get("ToolId"); // returns "AutoGen-001"

// Remove — throws CustomIdentityNotFoundException if key does not exist
try
{
    idService.Remove("ToolId");
}
catch (CustomIdentityNotFoundException ex)
{
    Console.WriteLine($"Key not found: {ex.Message}");
}
```

---

## 4. Bulk attribute change with error handler

Sets multiple attributes in one call. Dependency ordering between attributes is handled
automatically (V19+). The callback fires per attribute — use it to skip failures without
aborting the whole batch.

```csharp
private static void BulkSetAttributes(DeviceItem item)
{
    var attrs = new List<KeyValuePair<string, object>>
    {
        new KeyValuePair<string, object>("IsochronousTi",   (double)0.1),
        new KeyValuePair<string, object>("IsochronousTo",   (double)0.3),
        new KeyValuePair<string, object>("IsochronousTiToCalculationMode",
            Siemens.Engineering.HW.IsochronousTiToCalculationMode.Manual),
        new KeyValuePair<string, object>("IsochronousMode", true)
    };

    item.SetAttributes(attrs, config =>
    {
        // Ignore errors on individual attributes and continue with the rest
        config.CurrentSelection = AttributeChoiceSelection.Ignore;
    });
}
```

---

## 5. Dynamic object structure discovery

Useful for tooling that must inspect unknown objects:

```csharp
// List all composition names on an object
IList<EngineeringCompositionInfo> comps =
    ((IEngineeringObject)device).GetCompositionInfos();
foreach (var c in comps)
    Console.WriteLine(c.Name);

// Get a composition by name (when type is known)
DeviceItemComposition items =
    (DeviceItemComposition)((IEngineeringObject)device).GetComposition("DeviceItems");

// List all attributes with access modes
IList<EngineeringAttributeInfo> attrInfos =
    ((IEngineeringObject)deviceItem).GetAttributeInfos();
foreach (var ai in attrInfos)
    Console.WriteLine($"{ai.Name} — {ai.AccessMode}");
```
