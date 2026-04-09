# Device Enumeration Reference

Source: TIA Portal Openness V21 — Functions on Devices (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
```

---

## 1. Root-level devices

Devices at the top level of the project (no device group):

```csharp
// Iterate all root devices
DeviceComposition devices = project.Devices;
foreach (Device device in devices)
{
    Console.WriteLine(device.Name);
}

// Find a specific device by name
Device plc1 = project.Devices.Find("PLC_1");

// Find using LINQ
Device plc1 = project.Devices.First(d => d.Name == "PLC_1");
```

---

## 2. Device groups

Devices can be organised into user-defined folders (`DeviceUserGroup`).

```csharp
// Enumerate all groups recursively
private static void EnumerateAllDevices(Project project)
{
    // Root-level devices (no group)
    foreach (Device device in project.Devices)
        ProcessDevice(device);

    // Devices in groups
    foreach (DeviceUserGroup group in project.DeviceGroups)
        EnumerateGroup(group);
}

private static void EnumerateGroup(DeviceUserGroup group)
{
    foreach (Device device in group.Devices)
        ProcessDevice(device);

    // Recurse into sub-groups
    foreach (DeviceUserGroup subGroup in group.Groups)
        EnumerateGroup(subGroup);
}

// Find a device in a specific named group
DeviceUserGroup sortingGroup = project.DeviceGroups.Find("Sorting");
Device conveyorPlc = sortingGroup.Devices.Find("Conveyor_PLC");
```

---

## 3. Ungrouped devices system group

Decentral / distributed devices that do not belong to any user group:

```csharp
DeviceSystemGroup ungrouped = project.UngroupedDevicesGroup;
foreach (Device device in ungrouped.Devices)
{
    Console.WriteLine(device.Name);
}
```

---

## 4. Navigating DeviceItems

`DeviceItem` objects represent slots, modules, and sub-modules within a device.
`device.DeviceItems` is a flat collection of top-level device items (rack, CPU, etc.).
Sub-items are accessed via `deviceItem.DeviceItems` recursively.

```csharp
private static void NavigateDeviceItems(Device device)
{
    foreach (DeviceItem item in device.DeviceItems)
    {
        Console.WriteLine($"  Item: {item.Name} — {item.TypeIdentifier}");
        foreach (DeviceItem subItem in item.DeviceItems)
            Console.WriteLine($"    Sub-item: {subItem.Name}");
    }
}
```

---

## 5. Creating and deleting device groups

```csharp
// Create a top-level device group
DeviceUserGroup newGroup = project.DeviceGroups.Create("Line_1");

// Create a sub-group
DeviceUserGroup subGroup = newGroup.Groups.Create("Station_A");

// Delete a group (must be empty)
DeviceUserGroup toDelete = project.DeviceGroups.Find("OldGroup");
toDelete?.Delete();
```
