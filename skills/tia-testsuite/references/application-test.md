## 🛠️ Siemens.Engineering.TestSuite.ApplicationTest.ApplicationTestSet
>
> Represents a TestSet under Application Test

- 🔧 `Name`: Application Test Set name
- 📦 `ShowInEditor`: Show the selected item in the editor
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.TestSuite.ApplicationTest.ApplicationTestSetComposition
>
> Collection of Application Test Sets

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.TestSuite.ApplicationTest.ApplicationTestSet)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.TestSuite.ApplicationTest.ApplicationTestSet)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Find the test set with specified name

## 🛠️ Siemens.Engineering.TestSuite.ApplicationTest.ApplicationTestSystemGroup
>
> Application test system folder

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `ApplicationTestSets`: Collection of test sets
- 🔧 `TestCases`: Collection of test cases
- 📦 `LoadFromFile(System.IO.FileInfo,Siemens.Engineering.ImportOptions,Siemens.Engineering.TestSuite.ApplicationTest.TSLoadOptions)`: Loading test sets and associated test cases into project from external textual file

## 🛠️ Siemens.Engineering.TestSuite.ApplicationTest.ExecutionMode
>
> Testcase execution mode

- `SystemManagedPLCSIMInstance`: Test Suite manages the PLCSIM instance.
- `ExternallyManagedPLCSIMInstance`: The caller/environment owns the named PLCSIM instance.

## 🛠️ Siemens.Engineering.TestSuite.ApplicationTest.SupportSimulationNotEnabledException
>
> Thrown when simulation check is not enabled

- 📦 `#ctor`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TestSuite.ApplicationTest.SupportSimulationNotEnabledException"/> class.
- 📦 `#ctor(System.String)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TestSuite.ApplicationTest.SupportSimulationNotEnabledException"/> class.
- 📦 `#ctor(System.String,System.Exception)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TestSuite.ApplicationTest.SupportSimulationNotEnabledException"/> class.
- 📦 `#ctor(System.String,System.String[])`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TestSuite.ApplicationTest.SupportSimulationNotEnabledException"/> class.
- 📦 `#ctor(System.Runtime.Serialization.SerializationInfo,System.Runtime.Serialization.StreamingContext)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.TestSuite.ApplicationTest.SupportSimulationNotEnabledException"/> class with serialized data.
- 📦 `GetObjectData(System.Runtime.Serialization.SerializationInfo,System.Runtime.Serialization.StreamingContext)`: When overridden in a derived class, sets the <see cref="T:System.Runtime.Serialization.SerializationInfo"/>B with information about the exception.

## 🛠️ Siemens.Engineering.TestSuite.ApplicationTest.TCLoadOptions
>
> Test case load options

- `TCLoadOptions.None`
- `TCLoadOptions.IgnoreInvalidObject`

## 🛠️ Siemens.Engineering.TestSuite.ApplicationTest.TSLoadOptions
>
> Test set load options

- `TSLoadOptions.None`
- `TSLoadOptions.IgnoreInvalidObject`

## 🛠️ Siemens.Engineering.TestSuite.ApplicationTest.TestCase
>
> Represents a test case under Application test

- 🔧 `Name`: Test case name
- 📦 `GetScope`: Retrieves target controller of the selected test case
- 📦 `SaveToFile(System.IO.FileInfo)`: Saves selected test case(s) to a textual file
- 📦 `SetScope(Siemens.Engineering.SW.PlcSoftware)`: Set the scope for associated test case
- 📦 `SetScope(Siemens.Engineering.SW.PlcSoftware,System.String,Siemens.Engineering.TestSuite.ApplicationTest.ExecutionMode)`: Set the scope for associated test case
- 📦 `ShowInEditor`: Show the selected item in the editor
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.TestSuite.ApplicationTest.TestCaseComposition
>
> Collection of Application test cases

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.TestSuite.ApplicationTest.TestCase)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.TestSuite.ApplicationTest.TestCase)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create test case from given master copy
- 📦 `LoadFromFile(System.IO.FileInfo,Siemens.Engineering.ImportOptions,Siemens.Engineering.TestSuite.ApplicationTest.TCLoadOptions)`: Loading test cases into project from external textual file
- 📦 `Find(System.String)`: Find the test case with specified name

## 🛠️ Siemens.Engineering.TestSuite.ApplicationTest.TestCaseExecutor
>
> Provides service for test case execution

- 📦 `Run(ApplicationTestSet)`: Executes one test set and returns `TestResults`.
- 📦 `Run(ApplicationTestSystemGroup)`: Executes the Application Test group and returns `TestResults`.
- 📦 `Run(TestCase)`: Executes one test case and returns `TestResults`.
- 📦 `Run(IEnumerable<ApplicationTestSet>)`: Executes the selected test sets and returns `TestResults`.
- 📦 `Run(IEnumerable<TestCase>)`: Executes the selected test cases and returns `TestResults`.

## V21 workflow and safety

```csharp
TestSuiteService service = project.GetService<TestSuiteService>();
ApplicationTestSystemGroup group = service.ApplicationTestGroup;

List<TestCase> matches = group.TestCases
    .Where(test => string.Equals(test.Name, exactTestCaseName, StringComparison.Ordinal))
    .ToList();
if (matches.Count != 1)
    throw new InvalidOperationException(
        $"Expected exactly one Application Test case '{exactTestCaseName}', found {matches.Count}.");

TestCase testCase = matches[0];
testCase.SetScope(
    exactPlcSoftware,
    exactPlcSimInstanceName,
    ExecutionMode.ExternallyManagedPLCSIMInstance);

TestCaseExecutor executor = group.GetService<TestCaseExecutor>();
TestResults results = executor.Run(testCase);
```

Use `ExecutionMode.SystemManagedPLCSIMInstance` only when Test Suite is authorized
to create/manage the simulator instance. For an externally managed instance,
verify the exact PLCSIM instance identity and ownership first. Application Tests
are PLCSIM-based; do not reinterpret their scope as permission to operate a live PLC.

`ApplicationTestSystemGroup.LoadFromFile(file, importOptions, TSLoadOptions)`
loads test sets and associated cases. `TestCaseComposition.LoadFromFile` loads
test cases with `TCLoadOptions`. Treat files as untrusted, inspect the resulting
identities, and use `IgnoreInvalidObject` only when omitted objects are acceptable
and reported. `ImportOptions.Override` may replace existing project data and
requires explicit project-write authorization.
