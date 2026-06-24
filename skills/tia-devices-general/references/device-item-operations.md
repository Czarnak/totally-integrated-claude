# Device Item Operations Reference

Source: TIA Portal Openness V21 — Functions on Device Items (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Utilities;
```

---

## 1. Enumerating device items

Device items represent rack, CPU, modules, and sub-modules within a device.

```csharp
// Enumerate via HardwareObject.Items (flat, top-level only)
private static void EnumerateDeviceItems(HardwareObject hardwareObject)
{
    foreach (DeviceItem deviceItem in hardwareObject.Items)
    {
        // add code here
    }
}

// Enumerate via composition hierarchy (device.DeviceItems)
private static void EnumerateDeviceItems(Device device)
{
    DeviceItemComposition deviceItemComposition = device.DeviceItems;
    foreach (DeviceItem deviceItem in deviceItemComposition)
    {
        // add code here
    }
}

// Enumerate via association (device.Items)
private static void EnumerateDeviceItemsWithAssociation(Device device)
{
    DeviceItemAssociation deviceItemAssociation = device.Items;
    foreach (DeviceItem deviceItem in deviceItemAssociation)
    {
        // add code here
    }
}
```

---

## 2. Accessing device items

```csharp
// Access a device item from a device (by index)
public static DeviceItem AccessDeviceItemFromDevice(Device device)
{
    DeviceItem deviceItem = device.DeviceItems[0];
    return deviceItem;
}

// Access a sub-device item from a device item
public static DeviceItem AccessDeviceItemFromDeviceItem(DeviceItem deviceItem)
{
    DeviceItem subDeviceItem = deviceItem.DeviceItems[0];
    return subDeviceItem;
}
```

Key attributes on `DeviceItem`:

| Attribute | Type | Access | Notes |
|---|---|---|---|
| `Name` | string | read/write | modeled |
| `TypeIdentifier` | string | read | modeled |
| `PositionNumber` | int | read | modeled |
| `IsBuiltIn` | bool | read | modeled |
| `IsPlugged` | bool | read | modeled |
| `OrderNumber` | string | read | dynamic, head modules only |
| `IsProfinet` | bool | read | modeled |
| `IsProfibus` | bool | read | modeled |

---

## 3. Mandatory attributes of a device item

```csharp
private static void GetMandatoryAttributesDeviceItem(DeviceItem deviceItem)
{
    string nameValue = deviceItem.Name;
    string typeIdentifierValue = deviceItem.TypeIdentifier;
    int positionNumberValue = deviceItem.PositionNumber;
    bool isBuiltInValue = deviceItem.IsBuiltIn;
    bool isPluggedValue = deviceItem.IsPlugged;
}
```

`DeviceItemClassifications` enum:

| Value | Description |
|---|---|
| `DeviceItemClassifications.None` | No classification |
| `DeviceItemClassifications.CPU` | The device item is a CPU |
| `DeviceItemClassifications.HM` | The device item is a head module |

---

## 4. Plugging a new device item

`HardwareObject.PlugNew()` creates and plugs a new device item or sub-module.
Check feasibility first with `CanPlugNew()`.

```csharp
private static void PluggingDeviceItem(
    HardwareObject hwObject, string typeIdentifier,
    string name, int positionNumber)
{
    if (hwObject.CanPlugNew(typeIdentifier, name, positionNumber))
    {
        DeviceItem newPluggedDeviceItem =
            hwObject.PlugNew(typeIdentifier, name, positionNumber);
    }
}
```

Common failure reasons even when `CanPlugNew` returns `true`:

- Position already taken by another device item
- Device is online
- Name already taken within the same container

---

## 5. Moving a device item to another slot

```csharp
private static void MoveDeviceItemsIntoAnotherSlot(
    HardwareObject hwObject,
    DeviceItem deviceItemToMove, int positionNumber)
{
    if (hwObject.CanPlugMove(deviceItemToMove, positionNumber))
    {
        DeviceItem movedDeviceItem = hwObject.PlugMove(deviceItemToMove, positionNumber);
    }
}
```

---

## 6. Copying a device item

```csharp
HardwareObject hwObject = ...;
DeviceItem deviceItemToCopy = ...;
int positionNumber = ...;

if (hwObject.CanPlugCopy(deviceItemToCopy, positionNumber))
{
    DeviceItem copiedDeviceItem = hwObject.PlugCopy(deviceItemToCopy, positionNumber);
}
```

---

## 7. Deleting a device item

```csharp
Project project = ...;
var device = project.UngroupedDevicesGroup.Devices.Find("PLC_1");
var deviceItem = device.DeviceItems.First();

// Delete device item
deviceItem.Delete();
```

---

## 8. Change device / change type

Use `ChangeType()` to swap a device item to a newer firmware version or compatible module.

```csharp
using Siemens.Engineering.HW.DeviceItem;

private void ChangeTypeDeviceItem()
{
    DeviceItem rack = ...;
    DeviceItem deviceItem = rack.PlugNew("OrderNumber:6ES7 516-3AN01-0AB0/V2.8", "PLC_1", 1);

    try
    {
        deviceItem.ChangeType("OrderNumber:6ES7 516-3AN01-0AB0/V2.9");
    }
    catch (EngineeringTargetInvocationException e)
    {
        Console.WriteLine("ChangeType failed: {0}", e.Message);
    }
}
```

Limitations vs. TIA Portal UI:

- No list of possible change partners provided
- No feedback message about type changes
- GSDML exchange and module description update are not supported

---

## 9. Module information and plug locations

Use `ModuleInformationProvider` (accessed via `project.HwUtilities`) to query slot info before plugging.

```csharp
// Get the ModuleInformationProvider
private static void ModuleInformationAccess(Project project)
{
    HardwareUtilityComposition extensions = project.HwUtilities;
    var result = extensions.Find("ModuleInformationProvider")
        as ModuleInformationProvider;
}

// Find container types for a module (network view modules only)
private static void AccessingContainerType(
    string typeIdentifier,
    ModuleInformationProvider moduleInformationProvider)
{
    string[] containerTypes = moduleInformationProvider.FindContainerTypes(typeIdentifier);
}

// Find all versions matching a partial type identifier
private static void AccessVersionHardwareObject(
    string partialTypeIdentifier,
    ModuleInformationProvider moduleInformationProvider)
{
    string[] moduleTypes = moduleInformationProvider.FindModuleTypes(partialTypeIdentifier);
}

// Get free plug locations (position number + label) on a hardware object
private static void AccessPlugLocation(HardwareObject hardwareObject)
{
    IList<PlugLocation> result = hardwareObject.GetPlugLocations();
    foreach (PlugLocation item in result)
    {
        Console.WriteLine("{0} - {1}", item.PositionNumber, item.Label);
    }
}
```

Partial type identifier constraints:

- `OrderNumber`: at least one part — e.g. `OrderNumber:6ES7 317-2EK14-0AB0`
- `GSD`: at least two parts — e.g. `GSD:SI05816A.GSD/M`
- `System`: at least one part — e.g. `System:Rack.ET200SP`

---

## 10. Bulk-changing hardware parameters

Set multiple attributes of a hardware object in a single call.
`AttributeDelegate errorHandler` receives per-attribute errors without aborting the batch.

```csharp
private static void BulkChangeHardwareParameter(TiaPortal tiaPortal, Project project)
{
    IList<KeyValuePair<string, object>> attributesToSet =
        new List<KeyValuePair<string, object>>
        {
            new KeyValuePair<string, object>("IsochronousTime", (double)1000),
            new KeyValuePair<string, object>("SomeOtherParam", someValue),
        };

    AttributeDelegate errorHandler = (attributeName, ex) =>
    {
        Console.WriteLine($"Error on attribute '{attributeName}': {ex.Message}");
    };

    ((IEngineeringObject)deviceItem).SetAttributes(attributesToSet, errorHandler);
}
```

Signature:

```
SetAttributes(IEnumerable<KeyValuePair<string, object>> attributes, AttributeDelegate errorHandler)
```

> Available from V19. Handles attribute ordering and dependencies automatically.

---

## 11. PSC file export

Export a device configuration to a PSC (Program/System Controller) file.

```csharp
using Siemens.Engineering.HW.Utilities;

private static void ExportToPscFile(DeviceItem deviceItem, string pscFilePath)
{
    CardReaderPscProvider pscProvider =
        ((IEngineeringServiceProvider)deviceItem).GetService<CardReaderPscProvider>();

    // Export (file must not already exist)
    pscProvider.Export(new FileInfo(pscFilePath));

    // Export encrypted (V20+, requires CPU V40.0+)
    // pscProvider.Export(new FileInfo(pscFilePath), "password");
}
```

Rules:

- The target file must not exist; `Export()` will not overwrite.
- F-activated devices are not supported (V18 and below).
- Encrypted export requires TIA Portal Openness V20+ and CPU firmware V40.0+.

---

## 12. Extension rack connections

Fetch, add, or remove connections between port device items on extension racks.

```csharp
ImConnection imConnection = portDeviceItem.GetService<ImConnection>();

imConnection.Connect(partnerPort);
imConnection.Disconnect();
imConnection.GetPartnerPort();

var imConnectionOwner = imConnection.OwnedBy;
```

---

## 13. Telecontrol datapoint export/import

`TelecontrolManagement` (a `DeviceItem` service) exports/imports datapoints as CSV files.

```csharp
private void ExportDataPointUsingCSV(DeviceItem cpDeviceItem)
{
    TelecontrolManagement telecontrolManagement =
        cpDeviceItem.GetService<TelecontrolManagement>();

    bool exportSuccessful = true;
    try
    {
        telecontrolManagement.ExportDataPoints(new FileInfo(@"C:\datapoints.csv"));
    }
    catch (Exception e)
    {
        exportSuccessful = false;
        Console.WriteLine(e.Message);
    }
}

private void ImportDataPointUsingCSV(DeviceItem cpDeviceItem)
{
    TelecontrolManagement telecontrolManagement =
        cpDeviceItem.GetService<TelecontrolManagement>();

    telecontrolManagement.ImportDatapoints(new FileInfo(@"C:\datapoints.csv"));
}
```

Supported device article numbers include `6GK7 542-6VX00-0XE0 (V 2.3)`, `6GK7 243-7SX30-0XE0 (V 3.5)`, and others.

---

## 14. User-defined logo settings (S7-1500 CPU display)

```csharp
// Get FrontPanel Display service
FrontPanelDisplay frontPanelDisplay =
    ((IEngineeringServiceProvider)cpuDisplayDeviceItem).GetService<FrontPanelDisplay>();

// Enable user-defined logo first
((IEngineeringObject)frontPanelDisplay).SetAttribute("UserDefinedLogoActivated", true);

// Upload logo image
frontPanelDisplay.SetUserDefinedLogo(new FileInfo(@"C:\logo.png"));
```

Properties available when CPU contains a display:

| Property | Type | Description |
|---|---|---|
| `UserDefinedLogoActivated` | bool | Must be `true` before calling `SetUserDefinedLogo()` |

---

## API Reference (V21)

## 🛠️ Siemens.Engineering.HW.TelecontrolDataPoint
>
> Respresents an abstract datapoint

- 🔧 `DataPointType`: Defines the protocol-specific datapoint type
- 🔧 `Name`: Defines the unique name of the datapoint on the telecontrol device
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HW.TelecontrolDataPointComposition
>
> Represents a connection information object

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.TelecontrolDataPoint)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.TelecontrolDataPoint)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create``1(Siemens.Engineering.IEngineeringObject)`: Creates a datapoint

## 🛠️ Siemens.Engineering.HW.TelecontrolDnp3DataPoint
>
> Respresents a Dnp3 protocol datapoint

- 🔧 `DataPointIndex`: Defines the datapoint index to address the datapoint
- 🔧 `MasterFunction`: Defines whether the value of the datapoint are sent as for a master

## 🛠️ Siemens.Engineering.HW.TelecontrolIecDataPoint
>
> Respresents an Iec protocol datapoint

- 🔧 `DataPointIndex`: Defines the datapoint index to address the datapoint
- 🔧 `MasterFunction`: Defines whether the value of the datapoint are sent as for a master

## 🛠️ Siemens.Engineering.HW.TelecontrolSt7DataPoint
>
> Respresents a St7 protocol datapoint

## 🛠️ Siemens.Engineering.HW.TelecontrolWdcDataPoint
>
> Respresents a Telecontrol Basic (Wdc) protocol datapoint

- 🔧 `DataPointIndex`: The attribute defines the index of the data point.

## 🛠️ Siemens.Engineering.HW.Extensions.PlugLocation
>
> Information about a free slot.

- 🔧 `Label`: The label of the free slot.
- 🔧 `PositionNumber`: The position number of the free slot

## 🛠️ Siemens.Engineering.HW.Features.DeviceItemFeature
>
> Base class for all DeviceItem related services

- 🔧 `OwnedBy`: DeviceItem Object that owns this role

## 🛠️ Siemens.Engineering.HW.Features.HardwareFeature

> Base class for all HW related services

## 🛠️ Siemens.Engineering.HW.Features.ModuleDescriptionUpdater
>
> Represents the ModuleDescriptionUpdater

- 🔧 `CanUpdate`: Exists a new version of deviceitem to update
- 📦 `UpdateModuleDescription`: Update module description of the deviceItem or deviceItems

## 🛠️ Siemens.Engineering.HW.Features.TelecontrolManagement
>
> Represents a service for telecontrol operations

- 🔧 `TelecontrolDataPoints`: Composition of datapoints
- 📦 `ExportDataPoints(System.IO.FileInfo)`: Exports the datapoints of the telecontrol device
- 📦 `ImportDataPoints(System.IO.FileInfo)`: Imports the datapoints of the telecontrol device

## 🛠️ Siemens.Engineering.HW.Utilities.CardReaderPscProvider
>
> Card reader provider utility for .psc file

- 📦 `Export(Siemens.Engineering.HW.Device,System.IO.FileInfo)`: Exports device configuration to file
- 📦 `Export(Siemens.Engineering.HW.Device,System.IO.FileInfo,System.Security.SecureString)`: Exports device configuration to file

## 🛠️ Siemens.Engineering.HW.Utilities.HardwareUtility
>
> Abstract base class for all extensions to the HW model

- 🔧 `Identifier`: Identifier for this HW extension

## 🛠️ Siemens.Engineering.HW.Utilities.HardwareUtilityComposition
>
> Composition of HardwareUtilities

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Utilities.HardwareUtility)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Utilities.HardwareUtility)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds a given extension

## 🛠️ Siemens.Engineering.HW.Utilities.ModuleInformationProvider
>
> Service provider for module information

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 📦 `FindContainerTypes(System.String)`: Finds the possible container types
- 📦 `FindModuleTypes(System.String)`: Finds the possible module types
- 📦 `GetTypeIdentifierNormalized(System.String)`: Gets the TypeIdentifierNormalized

## 🛠️ Siemens.Engineering.HW.Utilities.OpcUaExportProvider
>
> Service provider for export of OPC UA

- 📦 `Export(Siemens.Engineering.HW.DeviceItem,System.IO.FileInfo)`: Simatic ML export of a OPC UA
