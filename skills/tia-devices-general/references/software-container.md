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

---

## API Reference (V21)

## 🛠️ Siemens.Engineering.HW.Software
>
> Represents a base class of an object containing software components

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
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Name`: The name of the software base
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.SoftwareContainer
>
> Represents a class containing software components

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 📦 `Siemens#Engineering#IEngineeringServiceProvider#GetServiceInfos`: Returns a collection of EngineeringServiceInfo objects describing the different services on this object.
- 🔧 `Software`: Gets the software target containing the software elements of the device
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
