# Networks and Connections Reference

Source: TIA Portal Openness V21 — Functions for Accessing Devices, Networks and Connections (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.SW;
```

---

## 1. Opening the Devices & Networks editor

Two methods are available:

- `project.ShowHwEditor(View)` — opens the editor from the project
- `device.ShowInEditor(View)` — opens the editor focused on a specific device

`View` parameter values: `View.Topology`, `View.Network`, `View.Device`

```csharp
// Open Topology view from project
private static void OpenEditorFromProject(Project project)
{
    project.ShowHwEditor(Siemens.Engineering.HW.View.Topology);
}

// Open Topology view for a specific device
private static void OpenEditorForDevice(Device device)
{
    device.ShowInEditor(Siemens.Engineering.HW.View.Topology);
}

// Open Network view for a specific device
private static void OpenNetworkViewForDevice(Device device)
{
    device.ShowInEditor(Siemens.Engineering.HW.View.Network);
}
```

---

## 2. Querying PLC and HMI targets

Determine whether a device item exposes a `PlcSoftware` or `HmiTarget` via the `SoftwareContainer` service.

```csharp
// Returns PlcSoftware or null
private PlcSoftware GetPlcSoftware(Device device)
{
    DeviceItemComposition deviceItemComposition = device.DeviceItems;
    foreach (DeviceItem deviceItem in deviceItemComposition)
    {
        SoftwareContainer softwareContainer =
            deviceItem.GetService<SoftwareContainer>();
        if (softwareContainer != null)
        {
            Software softwareBase = softwareContainer.Software;
            PlcSoftware plcSoftware = softwareBase as PlcSoftware;
            if (plcSoftware != null)
                return plcSoftware;
        }
    }
    return null;
}

// Returns HmiTarget or null
private HmiTarget GetHmiTarget(Device device)
{
    DeviceItemComposition deviceItemComposition = device.DeviceItems;
    foreach (DeviceItem deviceItem in deviceItemComposition)
    {
        SoftwareContainer softwareContainer =
            deviceItem.GetService<SoftwareContainer>();
        if (softwareContainer != null)
        {
            Software softwareBase = softwareContainer.Software;
            HmiTarget hmiTarget = softwareBase as HmiTarget;
            if (hmiTarget != null)
                return hmiTarget;
        }
    }
    return null;
}
```

> This pattern is equivalent to the `SoftwareContainer` service described in `references/software-container.md`. Load that file when the goal is software block access; load this file when the goal is network/connection discovery.

---

## 3. Accessing attributes of an address object

Address objects are found on network nodes and carry network addressing information.

| Attribute | Type | Writable | Access | Description |
|---|---|---|---|---|
| `IsochronousMode` | bool | read/write | Dynamic | Activate/deactivate isochronous mode |
| `ProcessImage` | Int32 | read/write | Dynamic | Process image partition number |
| `InterruptObNumber` | Int64 | read/write | Dynamic | Interrupt OB number (classic controllers only) |
| `StartAddress` | Int32 | read/write | Modeled | I/O start address |

```csharp
Address address = ...;

// Read start address
int startAddr = (int)((IEngineeringObject)address).GetAttribute("StartAddress");

// Write start address
((IEngineeringObject)address).SetAttribute("StartAddress", 100);

// Activate isochronous mode
((IEngineeringObject)address).SetAttribute("IsochronousMode", true);

// Set process image partition
((IEngineeringObject)address).SetAttribute("ProcessImage", 1);
```

> Changing `StartAddress` on the input type may implicitly change the output type of the same module. Write access is not supported for all devices.

---

## 4. Accessing channels of a module (network perspective)

Signal modules (e.g., analog input modules) expose multiple channels.
Channels are accessed via `deviceItem.Channels` (`ChannelComposition`).

```csharp
DeviceItem aiModule = ...;

ChannelComposition channels = aiModule.Channels;
foreach (Channel channel in channels)
{
    // Work with the channel
}

// Read identifying attributes per channel
Channel channel = ...;
int channelNumber = channel.Number;
ChannelType type = channel.Type;
ChannelIoType ioType = channel.IoType;
```

Channel mandatory attributes:

| Attribute | Type | Access | Description |
|---|---|---|---|
| `Number` | Int32 | read (modeled) | Channel number |
| `Type` | `ChannelType` | read (modeled) | Channel type |
| `IoType` | `ChannelIoType` | read (modeled) | Input or output |
| `ChannelAddress` | Int32 | read (dynamic) | Address in bits |
| `ChannelWidth` | UInt32 | read (dynamic) | Width in bits |

Access a single channel by identifying attribute:

```csharp
// Access a specific channel (e.g., first input channel)
Channel inputChannel = channels.First(c => c.IoType == ChannelIoType.Input);
```

