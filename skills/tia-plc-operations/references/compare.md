# PLC Compare Reference

Source: TIA Portal Openness V21 — Functions for downloading data to PLC device (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Software compare

`PlcSoftware` implements `ISoftwareCompareTarget`, so any two `PlcSoftware` objects can be
compared directly. The result is always returned as a `CompareResult` tree.

### Signatures

```csharp
CompareResult PlcSoftware.CompareTo(ISoftwareCompareTarget compareTarget)
CompareResult PlcSoftware.CompareToOnline()
```

### Compare targets

| What to compare against | Code |
| --- | --- |
| Another PLC's software | `plcSoftware0.CompareTo(plcSoftware1)` |
| Project library | `plcSoftware.CompareTo(project.ProjectLibrary)` |
| Global library | `plcSoftware.CompareTo(globalLibrary)` |
| Master copy of a PLC | `plcSoftware.CompareTo(project.ProjectLibrary.MasterCopyFolder.MasterCopies.Find("MyPLC"))` |
| Connected online PLC | `plcSoftware.CompareToOnline()` |

### Reading the result

`CompareResult` is a tree. Navigate it via `RootElement` and its `Elements` collection.

```csharp
CompareResult result = plcSoftware0.CompareTo(plcSoftware1);
WriteResult(result.RootElement, string.Empty);

private static void WriteResult(CompareResultElement element, string indent)
{
    Console.WriteLine($"{indent}{element.LeftName} <{element.ComparisonResult}>" +
                      $" {element.RightName} — {element.DetailedInformation}");

    foreach (CompareResultElement child in element.Elements)
        WriteResult(child, indent + "  ");
}
```

### CompareResultState values

| Value | Meaning |
| --- | --- |
| `ObjectsIdentical` | Content of compared objects is identical |
| `LeftMissing` | Object not present in the source (left side) |
| `RightMissing` | Object not present in the compare target (right side) |
| `CompareIrrelevant` | Comparison between these two objects is not meaningful |
| `FolderContainsDifferencesOwnStateDifferent` | Folder has differences; folder's own state also differs |
| `FolderContentEqualOwnStateDifferent` | Folder content is the same; folder's own state differs |

### Check for quick identical test

```csharp
bool identical = result.RootElement.ComparisonResult ==
                 CompareResultState.ObjectsIdentical;
```

---

## Hardware compare

Device objects (not `PlcSoftware`) are compared using `CompareTo` with an
`IHardwareCompareTarget`.

### Signature

```csharp
CompareResult Device.CompareTo(IHardwareCompareTarget compareTarget)
```

`compareTarget` must not be null — passing null throws
`Siemens.Engineering.EngineeringTargetInvocationException`.

### Example

```csharp
// plc_1 and plc_2 are Device objects (not DeviceItem or PlcSoftware)
CompareResult result = plc_1.CompareTo(plc_2);

CompareResultState state = result.RootElement.ComparisonResult;

if (state == CompareResultState.FolderContainsDifferencesOwnStateDifferent)
{
    Console.WriteLine("Hardware differences found.");
    WriteResult(result.RootElement, string.Empty);
}
```

`CompareResultState` values for hardware compare:

| Value | Meaning |
| --- | --- |
| `FolderContainsDifferencesOwnStateDifferent` | Contents have differences; folder state also differs |
| `FolderContentEqualOwnStateDifferent` | Contents are equal; folder's own state differs |

---

## Update PLC program instructions

Upgrades block instructions to the latest version supported by the PLC firmware.
Access via `PlcSoftware`.

```csharp
PlcSoftware plcSoftware = ...; // access via SoftwareContainer
plcSoftware.UpdateProgram();
```

# V21 API Reference

## 🛠️ Siemens.Engineering.SW.PlcSoftware
>
> Represents the software components of a Plc

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 📦 `Siemens#Engineering#IEngineeringServiceProvider#GetServiceInfos`: Returns a collection of EngineeringServiceInfo objects describing the different services on this object.
- 🔧 `BlockGroup`: Gets the Plc block system group
- 🔧 `ExternalSourceGroup`: Gets the Plc external source system group
- 🔧 `PlcAlarmTextlistGroup`: Description for published
- 🔧 `TagTableGroup`: Gets the Plc tag table system group
- 🔧 `TechnologicalObjectGroup`: This system folder can contain technological objects
- 🔧 `TypeGroup`: Gets the Plc type system group
- 🔧 `WatchAndForceTableGroup`: Get the Plc watch table system group
- 🔧 `Name`: The name of the Plc software
- 📦 `CompareTo(Siemens.Engineering.Compare.ISoftwareCompareTarget)`: Compare the PLC software to the given target
- 📦 `CompareToOnline`: Compare the PLC software to the online target
- 📦 `UpdateProgram`: Update PLC program
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
