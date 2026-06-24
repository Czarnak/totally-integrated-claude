# WinCC Unified — Logging, Connections, Settings & Plant Model

Source: V21 IntelliSense XML — `Siemens.Engineering.WinCCUnified.xml`

> Assembly: `Siemens.Engineering.WinCCUnified.dll`

---

## 1. Connections

```csharp
using Siemens.Engineering.HmiUnified.HmiConnections;

// Create a connection
HmiConnection conn = hmiSoftware.Connections.Create("PLC_1_Connection");

// Configure
conn.CommunicationDriver = "SIMATIC S7 300/400";
conn.Partner = "PLC_1";
conn.Station = "Station_1";
conn.InitialAddress = "CommunicationInterface=Industrial Ethernet;" +
    "HostAddress=192.168.0.2;PlcAddress=192.168.0.2;Rack=0;ExpansionSlot=2;" +
    "IsCyclicOperation=true";
conn.DisabledAtStartup = false;
conn.Comment = "Main PLC connection";

// Driver-specific properties
DriverPropertyComposition driverProps = conn.DriverProperties;
foreach (DriverProperty dp in driverProps)
    Console.WriteLine($"{dp}");

// OPC UA alarm configuration
// Access via conn.GetService or attribute-based access

// Find / enumerate / delete
HmiConnection found = hmiSoftware.Connections.Find("PLC_1_Connection");
foreach (HmiConnection c in hmiSoftware.Connections)
    Console.WriteLine($"{c.Name} → {c.Partner} ({c.CommunicationDriver})");
found?.Delete();

// Validate
HmiValidationResult result = conn.Validate();
```

### HmiConnection properties

| Property | Type | Description |
| --- | --- | --- |
| `Name` | string | Connection name |
| `CommunicationDriver` | string | Driver type (e.g. "SIMATIC S7 300/400") |
| `Partner` | string | Connected partner device name |
| `Station` | string | Station containing the partner |
| `Node` | string | Access point of partner |
| `InitialAddress` | string | Key-value connection parameters (semicolon-separated) |
| `DisabledAtStartup` | bool | Connection starts offline |
| `Comment` | string | Additional comments |
| `DriverProperties` | `DriverPropertyComposition` | Driver-specific properties |

---

## 🛠️ Siemens.Engineering.HmiUnified.HmiConnections.DriverProperty
>
> Communication driver specific properties

- 🔧 `Info`: Interface property information
- 🔧 `PropertyName`: Interface property name
- 🔧 `Value`: Value of interface property

## 🛠️ Siemens.Engineering.HmiUnified.HmiConnections.DriverPropertyComposition
>
> DriverPropertyComposition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiConnections.DriverProperty)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiConnections.DriverProperty)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds DriverProperty

## 🛠️ Siemens.Engineering.HmiUnified.HmiConnections.HmiConnection
>
> Represents the HmiConnection

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `DriverProperties`: Driver specific properties collection
- 🔧 `Comment`: Additional comments if any
- 🔧 `CommunicationDriver`: Gives the communication driver
- 🔧 `DisabledAtStartup`: Connection initially will be online or not in runtime.
- 🔧 `InitialAddress`: Parameters of connection provided in key value pair separated by semicolon. For Example: IntialAddress string for S7 300/400 connection “CommunicationInterface=Industrial Ethernet;HostAddress=192.168.0.2;HostAccessPoint=S7Online;PlcAddress=192.168.0.2;ExpansionSlot=2;Rack=0;IsCyclicOperation=true”
- 🔧 `Name`: Name of connection
- 🔧 `Node`: Shows access point of Partner (eg PLC)
- 🔧 `Partner`: Name of connected partner
- 🔧 `Station`: Name of the station to which partner is located.
- 📦 `Validate`: Validates the object
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HmiUnified.HmiConnections.HmiConnectionComposition
>
> Represents the Composition of Hmi Connections

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.HmiConnections.HmiConnection)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.HmiConnections.HmiConnection)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create method for Connection
- 📦 `Find(System.String)`: Find method for Connection

## 🛠️ Siemens.Engineering.HmiUnified.HmiConnections.OpcUaAlarm
>
> Communication driver specific properties

- 🔧 `DisplayNames`: Returns the display names for opc ua alarms.
- 📦 `GetNodeId(System.String)`: Returns the node id of an OPC UA alarm for a certain display name.
- 📦 `Import(System.String)`: Reads the OPC UA alarm information from a xml file.
