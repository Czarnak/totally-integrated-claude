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

- `ServerInterfaces.UserDefined`
- `ServerInterfaces.StandardSIMATIC`
- `ServerInterfaces.SiOMECompanionSpecification`

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

- `TCLoadOptions.None`
- `TCLoadOptions.IgnoreInvalidObject`

## V21 workflow and live-system gate

```csharp
TestSuiteService service = project.GetService<TestSuiteService>();
SystemTestSystemGroup group = service.SystemTestGroup;

List<SystemTestCase> matches = group.SystemTestCases
    .Where(test => string.Equals(test.Name, exactTestCaseName, StringComparison.Ordinal))
    .ToList();
if (matches.Count != 1)
    throw new InvalidOperationException(
        $"Expected exactly one System Test case '{exactTestCaseName}', found {matches.Count}.");

SystemTestCase testCase = matches[0];
testCase.SetScope(exactOpcUaServerAddress, ServerInterfaces.StandardSIMATIC);

SystemTestCaseExecutor executor = group.GetService<SystemTestCaseExecutor>();
TestResults results = executor.Run(testCase);
```

`UserDefined` and `SiOMECompanionSpecification` may require the overload that
also supplies the exact interface-file directory. Validate the directory,
expected files, and provenance before changing scope.

System Tests connect through the exact OPC UA endpoint in the test-case scope.
That endpoint may be a live controller or production server and a test may have
side effects. Require explicit live-operation authorization for the exact OPC UA endpoint,
interface kind, security/credential context, and selected test case. Never assume
simulation from the fact that the object is a Test Suite case.

`SystemTestCaseComposition.LoadFromFile` consumes external test definitions.
Treat them as untrusted. `TCLoadOptions.IgnoreInvalidObject` can yield a partial
import; inventory omissions. `ImportOptions.Override` may replace project data
and requires explicit project-write authorization and the `Edit Test Suite data`
right.
