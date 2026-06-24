## 🛠️ Siemens.Engineering.TestSuite.SystemTest.OpcUaServerAddressNotValidException
>
> Thrown when OpcUa address is not valid

- 📦 `#ctor`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TestSuite.SystemTest.OpcUaServerAddressNotValidException"/> class.
- 📦 `#ctor(System.String)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TestSuite.SystemTest.OpcUaServerAddressNotValidException"/> class.
- 📦 `#ctor(System.String,System.Exception)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TestSuite.SystemTest.OpcUaServerAddressNotValidException"/> class.
- 📦 `#ctor(System.String,System.String[])`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TestSuite.SystemTest.OpcUaServerAddressNotValidException"/> class.
- 📦 `#ctor(System.Runtime.Serialization.SerializationInfo,System.Runtime.Serialization.StreamingContext)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TestSuite.SystemTest.OpcUaServerAddressNotValidException"/> class with serialized data.
- 📦 `GetObjectData(System.Runtime.Serialization.SerializationInfo,System.Runtime.Serialization.StreamingContext)`: When overridden in a derived class, sets the <see cref="T:System.Runtime.Serialization.SerializationInfo"/>B with information about the exception.

## 🛠️ Siemens.Engineering.TestSuite.SystemTest.ServerInterfaces
>
> OPC UA server interface options

## 🛠️ Siemens.Engineering.TestSuite.SystemTest.SystemTestCase
>
> Represents a test case under System Test

- 🔧 `Name`: System test case name
- 🔧 `OPCUAServerAddress`: OPC UA server address
- 🔧 `OPCUAServerInterfaceFolderPath`: Folder path to OPC UA server interface files
- 🔧 `OPCUAServerInterfaceType`: OPC UA server interface type
- 📦 `SaveToFile(System.IO.FileInfo)`: Saves selected test case(s) to a textual file
- 📦 `SetScope(System.String,Siemens.Engineering.TestSuite.SystemTest.ServerInterfaces)`: Set the scope for associated System test case
- 📦 `SetScope(System.String,Siemens.Engineering.TestSuite.SystemTest.ServerInterfaces,System.IO.DirectoryInfo)`: Set the scope for associated System test case
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.TestSuite.SystemTest.SystemTestCaseComposition
>
> Collection of System test cases

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.TestSuite.SystemTest.SystemTestCase)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.TestSuite.SystemTest.SystemTestCase)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create System test case from given master copy
- 📦 `LoadFromFile(System.IO.FileInfo,Siemens.Engineering.ImportOptions,Siemens.Engineering.TestSuite.SystemTest.TCLoadOptions)`: Loading test cases into project from external textual file
- 📦 `Find(System.String)`: Find the test case with specified name

## 🛠️ Siemens.Engineering.TestSuite.SystemTest.SystemTestCaseExecutor
>
> Provides service for system test case execution

- 📦 `Run(Siemens.Engineering.TestSuite.SystemTest.SystemTestCase)`: Executes the selected test case
- 📦 `Run(Siemens.Engineering.TestSuite.SystemTest.SystemTestSystemGroup)`: Executes all the available test cases in the project
- 📦 `Run(System.Collections.Generic.IEnumerable{Siemens.Engineering.TestSuite.SystemTest.SystemTestCase})`: Executes the selected list of test cases

## 🛠️ Siemens.Engineering.TestSuite.SystemTest.SystemTestSystemGroup
>
> System test system folder

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `SystemTestCases`: Collection of System test cases

## 🛠️ Siemens.Engineering.TestSuite.SystemTest.TCLoadOptions
>
> Test case load options
