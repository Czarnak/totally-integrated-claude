# SAFETY ADMINISTRATION

# V21 API Reference

## 🛠️ Siemens.Engineering.Safety.AssignmentOfBlockNumbers
>
> Enables access to attributes for configuring block number ranges of system-generated safety blocks.

- 🔧 `FromDB`: Gets or sets the &quot;from DB&quot; fixed range block number.
- 🔧 `FromFB`: Gets or sets the &quot;from FB&quot; fixed range block number.
- 🔧 `FromFC`: Gets or sets the &quot;from FC&quot; fixed range block number.
- 🔧 `ManagementMode`: Gets or sets indicating whether block numbers are system generated or manually assigned.
- 🔧 `ToDB`: Gets or sets the &quot;to DB&quot; fixed range block number.
- 🔧 `ToFB`: Gets or sets the &quot;from FB&quot; fixed range block number.
- 🔧 `ToFC`: Gets or sets the &quot;to FC&quot; fixed range block number.

## 🛠️ Siemens.Engineering.Safety.BlockNumbersManagementMode
>
> Defines modes for managing the number blocks of F-system blocks

## 🛠️ Siemens.Engineering.Safety.GlobalSettings
>
> GlobalSettings

- 📦 `GenerationOfDefaultFailsafeProgram`: Gets the generation of default failsafe program
- 📦 `GenerationOfDefaultFailsafeProgram(System.Boolean)`: Sets the generation of default failsafe program
- 📦 `ManagementOfFailsafeInSoftwareUnitsEnvironment`: Gets the management of failsafe in &apos;Software Units&apos; environment
- 📦 `ManagementOfFailsafeInSoftwareUnitsEnvironment(System.Boolean)`: Sets the management of failsafe in &apos;Software Units&apos; environment
- 📦 `SafetyModificationsPossible`: Query whether SafetyModifications are possible.
- 📦 `SafetyModificationsPossible(System.Boolean)`: Specify wether changes to an F-Program are possible
- 📦 `UsernameForFChangeHistory`: Retrieves the username to be used for F-change history entries
- 📦 `UsernameForFChangeHistory(System.String)`: Sets the username to be used for F-change history entries

## 🛠️ Siemens.Engineering.Safety.RuntimeGroup
>
> Enables access to information and methods regarding the Runtime Groups of the Safety program.

- 🔧 `FOBEventClass`: The Event class of the Fail-safe organization block
- 🔧 `FOBName`: The name of the Fail-safe organization block
- 🔧 `InfoDbName`: The name of the Runtime Groups Information DB Block
- 🔧 `MainSafetyBlockIDbName`: The name of the main safety&apos;s IDb block
- 🔧 `MainSafetyBlockName`: The name of the main safety block
- 🔧 `MaximumCycleTime`: The Maximum Cycle Time of the Runtime Group
- 🔧 `Name`: The name of the Runtime Group
- 🔧 `PostProcessingName`: The Post processing Block of the Runtime Group
- 🔧 `PreProcessingName`: The Pre processing Block of the Runtime Group
- 🔧 `WarnCycleTime`: The Warn Cycle Time of the Runtime Group
- 📦 `GenerateGlobalFIOStatusBlock`: Creates a global F-I/O status block or overrides it if it already exists
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.Safety.RuntimeGroupComposition
>
> Represents a Safety Runtime Group with its associated information and actions for working with them.

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Safety.RuntimeGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Safety.RuntimeGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Creates a new Runtime Group with the given name
- 📦 `Create(System.String,Siemens.Engineering.SW.Blocks.PlcBlock)`: Creates a new Runtime Group with the given name and MainSafety Function
- 📦 `Create(System.String,Siemens.Engineering.SW.Blocks.PlcBlock,Siemens.Engineering.SW.Blocks.PlcBlock)`: Creates a new Runtime Group with the given name, MainSafety Function Block and Instance Data Block
- 📦 `Find(System.String)`: Searches for a Runtime Group via the name.

## 🛠️ Siemens.Engineering.Safety.SafetyAdministration
>
> Provides access to Safety-related information and configuration.

- 🔧 `ProgramSignatures`: Provides access to the Safety Signatures of the PLC
- 🔧 `RuntimeGroups`: Provides access to the RuntimeGroups of the Safety program.
- 🔧 `Settings`: Provides access to the Settings of the Safety program.
- 🔧 `IsLoggedOnToSafetyOfflineProgram`: Query whether the user is logged on
- 🔧 `IsSafetyOfflineProgramPasswordSet`: Query whether a safety program password is set
- 📦 `LoginToSafetyOfflineProgram(System.Security.SecureString)`: Logs into the safety program if correct password is given
- 📦 `LogoffFromSafetyOfflineProgram`: Log off from the safety program
- 📦 `RevokeSafetyOfflineProgramPassword(System.Security.SecureString)`: Removes the safety password if it matches the current password
- 📦 `SetSafetyOfflineProgramPassword(System.Security.SecureString)`: Sets the safety password if it isn&apos;t set

## 🛠️ Siemens.Engineering.Safety.SafetyBaseIdProvider
>
> Provides access to Safety-related BaseID configuration.

- 📦 `GenerateBaseId`: Generates and assigns the FBaseID

## 🛠️ Siemens.Engineering.Safety.SafetyPrintout
>
> Service providing Safety Printout functionality for Plus PLCs.

- 📦 `Print(Siemens.Engineering.Safety.SafetyPrintoutFilePrinter,System.IO.FileInfo,System.String,Siemens.Engineering.Safety.SafetyPrintoutOption)`: Creates a Safety Printout for the current device item and prints it to a file. If the file already exists, it is overridden. - Returns true on success.

## 🛠️ Siemens.Engineering.Safety.SafetyPrintoutFilePrinter
>
> Defines the available built-in Windows printer drivers which support printing to file.

## 🛠️ Siemens.Engineering.Safety.SafetyPrintoutOption
>
> Defines the options for Safety Printout.

## 🛠️ Siemens.Engineering.Safety.SafetySettings
>
> Enables access to information and methods regarding the Settings of the Safety program.

- 🔧 `AssignmentOfBlockNumbers`: Provides access to attributes for configuring block number ranges of system-generated safety blocks.
- 🔧 `ActivationOfFChangeHistory`: Indicates whether logging of changes to the Safety program is activated (enabled).
- 🔧 `CreateDriverInstanceDataBlocksWithoutPrefix`: Gets or sets whether the names of the F-I/O DBs are created without prefix.
- 🔧 `SafetyModeCanBeDisabled`: Gets or sets indicating whether one can prevent the Safety mode for a Safety program from being disabled.
- 🔧 `SafetySystemVersion`: Gets or sets the Safety system version (including version of the F-system blocks and automatically generated F-blocks).
- 📦 `CleanSystemGeneratedObjects`: Cleans up the result of the fail-safe compilation.
- 📦 `GetApplicableSafetySystemVersions`: A List enumeration with the applicable Safety-System-Versions.

## 🛠️ Siemens.Engineering.Safety.SafetySignature
>
> Provides the Safety Signature.

- 🔧 `Type`: Defines the type of the SafetySignature
- 🔧 `Value`: Provides the safety signature value.

## 🛠️ Siemens.Engineering.Safety.SafetySignatureComposition
>
> Composition of SafetySignatures

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Safety.SafetySignature)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Safety.SafetySignature)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(Siemens.Engineering.Safety.SafetySignatureType)`: Searches for a SafetySignature by a given signature type

## 🛠️ Siemens.Engineering.Safety.SafetySignatureProvider
>
> Represents the Safety Signature of an object.

- 🔧 `Signatures`: Provides the SafetySignatures that belongs to the Parent object.

## 🛠️ Siemens.Engineering.Safety.SafetySignatureType
>
> Represents the SafetySignature Types

## 🛠️ Siemens.Engineering.Safety.SafetySystemVersion
>
> Represents a Safety system version value.

- 🔧 `Value`: The string value of Safety system version.

## 🛠️ Siemens.Engineering.Safety.Download.Configurations.SafetyProgram
>
> Load safety program to device

- 🔧 `CurrentSelection`: Current Selection for this Configuration.

## 🛠️ Siemens.Engineering.Safety.Download.Configurations.SafetyProgramSelections
>
> Available Selections for Safety Program configuration.

## 🛠️ Siemens.Engineering.SafetyValidation.ActivationTest
>
> Represents a Safety Activation Test

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `SafetyFunctions`: Composition of SafetyFunctions
- 🔧 `Author`: Author of the ActivationTest
- 🔧 `EvaluationDeviceName`: Name of the EvaluationDevice
- 🔧 `Name`: Name of the ActivationTest
- 🔧 `OverallState`: Overall state of the ActivationTest
- 📦 `AvailableDevices`: List of DeviceItems which can be used in the SafetyFunction
- 📦 `ChangeEvaluationDevice(Siemens.Engineering.HW.DeviceItem)`: Change the EvaluationDevice of the ActivationTest
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of an ActivationTest
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions,Siemens.Engineering.DocumentInfoOptions)`: Simatic ML export of an ActivationTest with DocumentInfoOptions
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SafetyValidation.ActivationTestComposition
>
> Composition of ActivationTests

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SafetyValidation.ActivationTest)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SafetyValidation.ActivationTest)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create ActivationTest from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.SafetyValidation.ActivationTest)`: Create a new ActivationTest based on an existing ActivationTest
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.SafetyValidation.ActivationTestImportOptions)`: Simatic ML import of an ActivationTest
- 📦 `Create(System.String,Siemens.Engineering.HW.DeviceItem)`: Create an ActivationTest using the specified parameters
- 📦 `Find(System.String)`: Finds a given ActivationTest

## 🛠️ Siemens.Engineering.SafetyValidation.ActivationTestImportOptions
>
> Import options for safety activation tests

## 🛠️ Siemens.Engineering.SafetyValidation.ActivationTestPrintout
>
> Service providing printout functionality for ActivationTests

- 📦 `Generate(System.IO.FileInfo)`: Save a report to a file. If the file already exists, it is overridden

## 🛠️ Siemens.Engineering.SafetyValidation.ActivationTestUserGroup
>
> User group containing Activation Tests &amp; Activation Test user groups

- 🔧 `ActivationTests`: Composition of ActivationTests
- 🔧 `Groups`: Composition of ActivationTest user groups
- 🔧 `Name`: The name of the ActivationTest user group
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SafetyValidation.ActivationTestUserGroupComposition
>
> Composition of ActivationTestUserGroups

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SafetyValidation.ActivationTestUserGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SafetyValidation.ActivationTestUserGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create ActivationTest from MasterCopy
- 📦 `Create(System.String)`: Create user folder for ActivationTest collection
- 📦 `Find(System.String)`: Finds given ActivationTest user group

## 🛠️ Siemens.Engineering.SafetyValidation.Condition
>
> A test condition of a SafetyFunction

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `Comment`: Comment of the Signal
- 🔧 `DeviceName`: The name of the device
- 🔧 `ExecutedInput`: The expected executed state of the Signal
- 🔧 `InitialInput`: The expected initial state of the Signal
- 🔧 `Response`: The expected response state of the Signal
- 🔧 `SignalName`: The name of the Signal
- 🔧 `SignalUsage`: The signal type of the Condition
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SafetyValidation.ConditionComposition
>
> Represents the SafetyFunction Conditions

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SafetyValidation.Condition)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SafetyValidation.Condition)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(Siemens.Engineering.HW.DeviceItem,Siemens.Engineering.SafetyValidation.SignalUsage,System.String)`: Create a Condition

## 🛠️ Siemens.Engineering.SafetyValidation.ConditionValue
>
> Expected value of the condition

## 🛠️ Siemens.Engineering.SafetyValidation.DeviceQuery
>
> Service that provide query for Safety Validation Assistant relevant devices

- 📦 `EvaluationDevices`: Possible evaluation devices in the project

## 🛠️ Siemens.Engineering.SafetyValidation.SafetyFunction
>
> Represents a Safety function for an ActivationTest

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `Conditions`: Composition of Conditions
- 🔧 `TraceConfiguration`: Trace configuration of the SafetyFunction
- 🔧 `Description`: Description of the SafetyFunction
- 🔧 `Name`: Name of the SafetyFunction (e.g. SF 1)
- 🔧 `TestName`: Test name of the SafetyFunction
- 🔧 `TestState`: Test state of the SafetyFunction
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a SafetyFunction
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions,Siemens.Engineering.DocumentInfoOptions)`: Simatic ML export of an SafetyFunction with DocumentInfoOptions
- 📦 `ResetTestResult`: Reset the Test Result of the SafetyFunction
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SafetyValidation.SafetyFunctionComposition
>
> Composition of SafetyFunctions

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SafetyValidation.SafetyFunction)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SafetyValidation.SafetyFunction)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.SafetyValidation.SafetyFunction)`: Create a new SafetyFunction based on an existing SafetyFunction
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a SafetyFunction
- 📦 `Create`: Create a new SafetyFunction

## 🛠️ Siemens.Engineering.SafetyValidation.SafetyValidationAssistant
>
> Provide access to Safety Validation Assistant related information and configuration

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `ActivationTestGroups`: ActivationTestGroups in the project
- 🔧 `ActivationTests`: ActivationTests in the project

## 🛠️ Siemens.Engineering.SafetyValidation.SignalUsage
>
> Signal usage type

## 🛠️ Siemens.Engineering.SafetyValidation.TestState
>
> Last executed state of the SafetyFunction

## 🛠️ Siemens.Engineering.SafetyValidation.TestValidationResult
>
> Result of the validity of the activation test

- 🔧 `ErrorCount`: The number of errors in a given validation scenario
- 🔧 `Messages`: The error messages in a given validation scenario
- 🔧 `State`: Final state of a given validation scenario

## 🛠️ Siemens.Engineering.SafetyValidation.TestValidationResultState
>
> Overall state of the test validation check for the given object

## 🛠️ Siemens.Engineering.SafetyValidation.TestValidity
>
> Service that provide the validity of an ActivationTest relevant item

- 📦 `CheckValidity`: Checks the validity of the item

## 🛠️ Siemens.Engineering.SafetyValidation.TraceConfiguration
>
> Trace configuration for the SafetyFunction

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `IsTraced`: Trace is enabled during test execution
