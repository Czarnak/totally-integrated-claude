# TECHNOLOGICAL OBJECTS

# V21 API Reference

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.AxisEncoderHardwareConnectionSDRInterface
>
> AxisEncoderHardwareConnection interfaces for Technology objects and Sinamics drive

- 📦 `Connect(Siemens.Engineering.MC.Drives.Telegram)`: This method connects the drive telegram with the Technology object
- 📦 `Connect(Siemens.Engineering.MC.Drives.Telegram,Siemens.Engineering.SW.TechnologicalObjects.Motion.ConnectOption)`: This method connects the drive telegram with the Technology object

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.AxisEncoderHardwareConnectionSDRInterfaceComposition
>
> Composition of AxisEncoderHardwareConnectionSDRInterface

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.TechnologicalObjects.Motion.AxisEncoderHardwareConnectionSDRInterface)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.TechnologicalObjects.Motion.AxisEncoderHardwareConnectionSDRInterface)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.AxisHardwareConnectionSDRProvider
>
> Service to access the interfaces for Technology objects and Sinamics drive

- 🔧 `ActorInterface`: Provides interfaces for actor connections
- 🔧 `SensorInterface`: Provides interfaces for sensor connections
- 🔧 `TorqueInterface`: Provides interfaces for torque connections

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.EncoderHardwareConnectionSDRProvider
>
> Service to access the interfaces for Technology objects and Sinamics drive

- 🔧 `SensorInterface`: Provides interfaces for sensor connections

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.TorqueHardwareConnectionSDRInterface
>
> TorqueHardwareConnection interfaces for Technology objects and Sinamics drive

- 📦 `Connect(Siemens.Engineering.MC.Drives.Telegram)`: This method connects the drive telegram with the Technology object
- 📦 `Connect(Siemens.Engineering.MC.Drives.Telegram,Siemens.Engineering.SW.TechnologicalObjects.Motion.ConnectOption)`: This method connects the drive telegram with the Technology object

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDB
>
> Instance of a technological DB

- 🔧 `Parameters`: Get all technological parameters
- 🔧 `Parent`: Parent of this object
- 🔧 `Name`: Name of the Block
- 🔧 `OfSystemLibElement`: Gets the name of the system library element associated with the DB
- 🔧 `OfSystemLibVersion`: Gets the version of the system library element associated with the DB
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions)`: Simatic ML export of a TechnlogicalInstanceDB
- 📦 `Export(System.IO.FileInfo,Siemens.Engineering.ExportOptions,Siemens.Engineering.DocumentInfoOptions)`: Simatic ML export with configure document info of a TechnologicalInstanceDB

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDBAssociation
>
> TO Association

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDB)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDB)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Add(Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDB)`: Adds an <paramref name="item"/>.
- 📦 `Remove(Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDB)`: Removes an <paramref name="item"/>.

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDBComposition
>
> TO composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDB)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDB)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create TechnologicalInstanceDB from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create TechnologicalInstanceDB from MasterCopy
- 📦 `Import(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Simatic ML import of a Technological Object
- 📦 `Create(System.String,System.String,System.Version)`: Create a new TechnologicalInstanceDB
- 📦 `Find(System.String)`: Find by its name

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDBGroup
>
> Contains Technological Objects and groups of Technological Objects

- 📦 `GetService``1`: Gets an instance of type <c>T</c>.
- 🔧 `Groups`: Composition of Technological Object user groups
- 🔧 `Parent`: Parent of this object
- 🔧 `TechnologicalObjects`: Get all technological objects
- 🔧 `Name`: Name of external source group

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDBSystemGroup
>
> Contains Technological Objects and groups

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDBUserGroup
>
> User group containing Technological Objects &amp; Technological Object user groups

- 🔧 `Name`: The name of the Technological Object user group
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDBUserGroupComposition
>
> Composition of TechnologicalInstanceDBUserGroups

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDBUserGroup)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.TechnologicalObjects.TechnologicalInstanceDBUserGroup)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy)`: Create TechnologicalInstanceDBUserGroup from MasterCopy
- 📦 `CreateFrom(Siemens.Engineering.Library.MasterCopies.MasterCopy,Siemens.Engineering.Library.MasterCopies.MasterCopyMode)`: Create TechnologicalInstanceDBUserGroup from MasterCopy
- 📦 `Create(System.String)`: Create TechnologicalInstanceDBUserGroup
- 📦 `Find(System.String)`: Finds a given Technological Object user group

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.TechnologicalParameter
>
> Represenst a technological parameter

- 🔧 `Name`: Represents the name of a technological parameter
- 🔧 `Value`: Represents the value of a technological parameter

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.TechnologicalParameterComposition
>
> Parameter composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.TechnologicalObjects.TechnologicalParameter)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.TechnologicalObjects.TechnologicalParameter)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Find(System.String)`: Finds a TechnologicalParameter by name

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Ident.IdentTechnologicalObjectProvider
>
> Provides access to the TO Ident

- 🔧 `ConnectedIdentDevice`: Returns the connected Ident Device
- 📦 `Connect(Siemens.Engineering.HW.DeviceItem)`: Connects an TO Ident with an Ident Device

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.AxisEncoderHardwareConnectionInterface
>
> Handles connections to hardware objects for axis and encoder TechnologicalInstanceDBs

- 🔧 `Channel`: Connected Channel
- 🔧 `ConnectOption`: ConnectOption that has been set when the connection was made
- 🔧 `InputAddress`: Raw input bit address
- 🔧 `InputModule`: Connected input (sub) module
- 🔧 `InputOutputModule`: Connected mixed (sub) module that contains input and output addresses
- 🔧 `IsConnected`: Indicates whether the interface is connected
- 🔧 `OutputAddress`: Raw output bit address
- 🔧 `OutputModule`: Connected output (sub) module
- 🔧 `OutputTag`: Connected tag (analog connection)
- 🔧 `PathToDBMember`: Path to connected DB member
- 🔧 `SensorIndexInActorTelegram`: Connection to sensor part in actor telegram.
- 📦 `Connect(Siemens.Engineering.HW.Channel)`: Connect with a Channel (e.g. of a TechnologyModule)
- 📦 `Connect(Siemens.Engineering.HW.DeviceItem)`: Connect with a mixed (sub) module that contains input and output addresses
- 📦 `Connect(Siemens.Engineering.SW.Tags.PlcTag)`: Connect to an output PlcTag in order to establish an analog connection
- 📦 `Connect(System.String)`: Connect to DB member
- 📦 `Connect(Siemens.Engineering.HW.DeviceItem,Siemens.Engineering.HW.DeviceItem)`: Connect with separate (sub) modules for inputs and outputs, specifying an additional ConnectOption
- 📦 `Connect(Siemens.Engineering.HW.DeviceItem,Siemens.Engineering.HW.DeviceItem,Siemens.Engineering.SW.TechnologicalObjects.Motion.ConnectOption)`: Connect with separate (sub) modules for inputs and outputs, specifying an additional ConnectOption
- 📦 `Connect(System.Int32,System.Int32,Siemens.Engineering.SW.TechnologicalObjects.Motion.ConnectOption)`: Connect specifying input and output bit addresses directly
- 📦 `Disconnect`: Remove an existing connection

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.AxisEncoderHardwareConnectionInterfaceComposition
>
> AxisEncoderHardwareConnectionInterface Composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.TechnologicalObjects.Motion.AxisEncoderHardwareConnectionInterface)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.TechnologicalObjects.Motion.AxisEncoderHardwareConnectionInterface)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.AxisHardwareConnectionProvider
>
> Handles connections to hardware objects for axis TechnologicalInstanceDBs

- 🔧 `ActorInterface`: Provides access to the connections for the actor interface of the axis
- 🔧 `SensorInterface`: Provides access to the connections for the sensor interfaces of the axis
- 🔧 `TorqueInterface`: Provides access to the torque connection interface of the axis

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.CamDataFormat
>
> Describes the format in which a cam object should be Exportet/Imported

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.CamDataFormatSeparator
>
> Describes a Seperator with which the data should be seperated on Import/Export

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.CamDataSupport
>
> Handles import export commands for Cam

- 📦 `LoadCamData(System.IO.FileInfo,Siemens.Engineering.SW.TechnologicalObjects.Motion.CamDataFormatSeparator)`: Loads the cam data from the specified file
- 📦 `LoadCamDataBinary(System.IO.FileInfo)`: Loads the cam data from the specified binary file
- 📦 `SaveCamData(System.IO.FileInfo,Siemens.Engineering.SW.TechnologicalObjects.Motion.CamDataFormat,Siemens.Engineering.SW.TechnologicalObjects.Motion.CamDataFormatSeparator)`: Saves the cam data to the specified file in the given format
- 📦 `SaveCamDataBinary(System.IO.FileInfo)`: Saves the cam data to the specified file in binary format
- 📦 `SaveCamDataPointList(System.IO.FileInfo,Siemens.Engineering.SW.TechnologicalObjects.Motion.CamDataFormatSeparator,System.Int32)`: Saves the cam data to the specified file as a point list

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.ConnectOption
>
> Describes additional options for making a connection

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.ConveyorTrackingLeadingValues
>
> Handles connections between Kinematics Technological Objects and their master values

- 🔧 `ActualValueCoupling`: Master values that are coupled via actual values
- 🔧 `DelayedCoupling`: Master values that are coupled via actual values
- 🔧 `SetPointCoupling`: Master values that are coupled via set points

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.DBMemberMapping
>
> Handles mapping instances to DB Members objects

- 🔧 `Alias`: Alias of this DB mapping entry
- 🔧 `DataType`: DataType of the member
- 🔧 `MemberPath`: string representation of the connected member
- 🔧 `Readonly`: Readonly flag
- 🔧 `StartIndex`: startindex inside an array
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.DBMemberMappingComposition
>
> DBMemberMapping composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.TechnologicalObjects.Motion.DBMemberMapping)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.TechnologicalObjects.Motion.DBMemberMapping)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create a new TOMapping entry
- 📦 `Find(System.String)`: Find by its Alias

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.EncoderHardwareConnectionProvider
>
> Handles connections to hardware objects for encoder TechnologicalInstanceDBs

- 🔧 `SensorInterface`: Provides access to the connections for the sensor interface of the encoder

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.InterpreterMappings
>
> Handles connections between SynchronousAxis Technological Objects and their master values

- 🔧 `DBMemberMapping`: mapping type for technological objects
- 🔧 `TechnologicalObjectMapping`: mapping type for technological objects

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.InterpreterProgramSupport
>
> Handles import export commands for interpreter programs

- 📦 `LoadSource(System.IO.FileInfo)`: Loads the interpreter program from the specified file
- 📦 `SaveSource(System.IO.FileInfo)`: Saves the interpreter program to the specified file.

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.MeasuringInputHardwareConnectionProvider
>
> Handles connections to hardware objects for measuring input TechnologicalInstanceDBs

- 🔧 `Channel`: Connected Channel
- 🔧 `ChannelIndex`: Index of connected channel with respect to InputModule
- 🔧 `InputAddress`: Raw input bit address
- 🔧 `InputModule`: Connected input (sub) module
- 🔧 `IsConnected`: Indicates whether the interface is connected
- 📦 `Connect(Siemens.Engineering.HW.Channel)`: Connect with a Channel (e.g. of a TechnologyModule)
- 📦 `Connect(System.Int32)`: Connect specifying the input bit address directly
- 📦 `Connect(Siemens.Engineering.HW.DeviceItem,System.Int32)`: Connect with a (sub) module, specifying an additional channel index
- 📦 `Disconnect`: Remove an existing connection

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.OutputCamHardwareConnectionProvider
>
> Handles connections to hardware objects for output cam and cam track TechnologicalInstanceDBs

- 🔧 `Channel`: Connected Channel
- 🔧 `IsConnected`: Indicates whether the interface is connected
- 🔧 `OutputAddress`: Raw output bit address
- 🔧 `OutputTag`: Connected tag
- 📦 `Connect(Siemens.Engineering.HW.Channel)`: Connect with a Channel (e.g. of a TechnologyModule)
- 📦 `Connect(Siemens.Engineering.SW.Tags.PlcTag)`: Connect to an output PlcTag
- 📦 `Connect(System.Int32)`: Connect specifying the output bit address directly
- 📦 `Disconnect`: Remove an existing connection

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.OutputCamMeasuringInputContainer
>
> Container for output cam, cam track and measuring input TOs

- 🔧 `MeasuringInputs`: Contains measuring input TOs
- 🔧 `OutputCams`: Contains output cam and cam track TOs

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.SuperimposingAxes
>
> Handles connections between Kinematics Technological Objects and their master values

- 🔧 `SetPointCoupling`: Master values that are coupled via set points

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.SynchronousAxisMasterValues
>
> Handles connections between SynchronousAxis Technological Objects and their master values

- 🔧 `ActualValueCoupling`: Master values that are coupled via actual values
- 🔧 `DelayedCoupling`: Master values that are coupled via actual values
- 🔧 `SetPointCoupling`: Master values that are coupled via set points

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.TOMapping
>
> Handles mapping instances to Technological objects

- 🔧 `Alias`: Alias of this TO mapping entry
- 🔧 `TechnologicalObject`: Connected technological object
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.TOMappingComposition
>
> TOMapping composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.TechnologicalObjects.Motion.TOMapping)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.TechnologicalObjects.Motion.TOMapping)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create a new TOMapping entry
- 📦 `Find(System.String)`: Find by its Alias

## 🛠️ Siemens.Engineering.SW.TechnologicalObjects.Motion.TorqueHardwareConnectionInterface
>
> Handles connections to Torque possible hardware objects for axis and encoder TechnologicalInstanceDBs

- 🔧 `ConnectOption`: ConnectOption that has been set when the connection was made
- 🔧 `InputAddress`: Raw input bit address
- 🔧 `InputModule`: Connected input (sub) module
- 🔧 `InputOutputModule`: Connected mixed (sub) module that contains input and output addresses
- 🔧 `IsConnected`: Indicates whether the interface is connected
- 🔧 `OutputAddress`: Raw output bit address
- 🔧 `OutputModule`: Connected output (sub) module
- 🔧 `PathToDBMember`: Path to connected DB member
- 📦 `Connect(Siemens.Engineering.HW.DeviceItem)`: Connect with a mixed (sub) module that contains input and output addresses
- 📦 `Connect(System.String)`: Connect to DB member
- 📦 `Connect(Siemens.Engineering.HW.DeviceItem,Siemens.Engineering.HW.DeviceItem)`: Connect with separate (sub) modules for inputs and outputs, specifying an additional ConnectOption
- 📦 `Connect(Siemens.Engineering.HW.DeviceItem,Siemens.Engineering.HW.DeviceItem,Siemens.Engineering.SW.TechnologicalObjects.Motion.ConnectOption)`: Connect with separate (sub) modules for inputs and outputs, specifying an additional ConnectOption
- 📦 `Connect(System.Int32,System.Int32,Siemens.Engineering.SW.TechnologicalObjects.Motion.ConnectOption)`: Connect specifying input and output bit addresses directly
- 📦 `Disconnect`: Remove an existing connection
