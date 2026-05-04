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

---

## API Reference (V21)

## 🛠️ Siemens.Engineering.HW.DeviceComposition
>
> Composition of Devices

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.Device)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.Device)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create device from MasterCopy
- 📦 `CreateWithItem(System.String,System.String,System.String)`: Create a device with subcomponents
- 📦 `Create(System.String,System.String)`: Creates a Device
- 📦 `Find(System.String)`: Finds a given device
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.DeviceGroup
>
> Group containing devices

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 📦 `Siemens#Engineering#IEngineeringServiceProvider#GetServiceInfos`: Returns a collection of EngineeringServiceInfo objects describing the different services on this object.
- 🔧 `Devices`: Composition of devices
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: The name of the device group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.DeviceItemAssociation
>
> Associated device items

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.DeviceItem)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.DeviceItem)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Add(Siemens.Engineering.HW.DeviceItem)`: Adds an <paramref name="item"/>.
- 📦 `Remove(Siemens.Engineering.HW.DeviceItem)`: Removes an <paramref name="item"/>.
- 📦 `Find(Siemens.Engineering.HW.DeviceItemClassifications)`: Find device items by classification.
- 📦 `Find(System.String)`: Find device item by name.
- 📦 `Find(System.Int32)`: Find device item by position number.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.DeviceItemComposition
>
> Composition of DeviceItems

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.DeviceItem)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.DeviceItem)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create device item from MasterCopy
- 📦 `Find(Siemens.Engineering.HW.DeviceItemClassifications)`: Find device items by classification.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.DeviceSystemGroup
>
> Represents a device system group (e.g. ungrouped devices group)

- 🔧 `Parent`: EOM parent of this object
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.DeviceUserGroup
>
> Group containing the devices

- 🔧 `Groups`: Composition of device user groups
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: The name of the device user group
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.DeviceUserGroupComposition
>
> Composition of DeviceUserGroups

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.DeviceUserGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.DeviceUserGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create device user group from MasterCopy
- 📦 `Create(System.String)`: Creates a device user group
- 📦 `Find(System.String)`: Finds a given device user group
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
