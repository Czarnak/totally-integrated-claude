# V21 API Reference: Siemens.Engineering.Multiuser

## 🛠️ Siemens.Engineering.Multiuser.LocalSession
>
> Represents a Local Session

- 🔧 `MarkingService`: Marking Service
- 🔧 `Project`: Gives access to the project information
- 📦 `Close`: Performs a close operation of Multiuser localSession.
- 📦 `CloseAndCommit(System.String)`: Performs a commit of opened server project changes.
- 📦 `IsUptoDate`: Gets the value that Session is Up-to-date or not.
- 📦 `Save`: Performs a save of opened session.

## 🛠️ Siemens.Engineering.Multiuser.LocalSessionComposition
>
> Composition of Local sessions

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Multiuser.LocalSession)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Multiuser.LocalSession)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Open(System.IO.FileInfo)`: Performs a open operation of Multiuser localSession.
- 📦 `OpenServerProject(System.IO.FileInfo)`: Performs a open operation of Multiuser Server Project.

## 🛠️ Siemens.Engineering.Multiuser.LocalSessionInfo
>
> Represents information about a local session

- 🔧 `ProjectFileInfo`: The location of the local session.
- 🔧 `SessionId`: The Unique identifier of a Local Session

## 🛠️ Siemens.Engineering.Multiuser.LockStateProvider
>
> Provides information about Lock on a project.

- 📦 `GetLockOwner`: Gets the information about lock owner.
- 📦 `IsProjectLocked`: Gets the value that Project is locked or not.

## 🛠️ Siemens.Engineering.Multiuser.MarkState
>
> Status of the marked engineering object

## 🛠️ Siemens.Engineering.Multiuser.MarkStateInfo
>
> Represents information about the markstate of an engineering object.

- 🔧 `IsMarkable`: Is the engineering object a markable object.True for a whitelisted object, False for a blacklisted object.
- 🔧 `MarkState`: Represents the MarkSate types such as IsMarkedByMe, IsMarkedByOthers and IsUptoDate

## 🛠️ Siemens.Engineering.Multiuser.Marking
>
> Represents a non deleted marking.

- 🔧 `MarkState`: Gets the mark state of the marked non deleted engineering object.
- 🔧 `MarkedObject`: Gets the marked non deleted engineering object.

## 🛠️ Siemens.Engineering.Multiuser.MarkingComposition
>
> Composition of markings.

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Multiuser.Marking)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Multiuser.Marking)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.

## 🛠️ Siemens.Engineering.Multiuser.MarkingService
>
> Represents the marking service navigator.

- 📦 `GetMarkStateInfo(Siemens.Engineering.IEngineeringObject)`: Gets the marking related information.
- 📦 `GetMarkings`: Gets the markings from the opened local session.
- 📦 `IsMarkable(Siemens.Engineering.IEngineeringObject)`: Checks if the provided engineering objects of the local session is markable
- 📦 `MarkObjects(System.Collections.Generic.IEnumerable{Siemens.Engineering.IEngineeringObject})`: Marks the provided engineering objects of the local session for checkin
- 📦 `UnmarkObjects(System.Collections.Generic.IEnumerable{Siemens.Engineering.IEngineeringObject})`: Unmarks the provided engineering objects of the local session

## 🛠️ Siemens.Engineering.Multiuser.Markings
>
> Represents non deleted markings.

- 🔧 `AllMarkings`: Gets all the non deleted markings.
- 🔧 `ConflictedMarkings`: Gets all the non deleted conflicted markings.

## 🛠️ Siemens.Engineering.Multiuser.MultiuserException
>
> This exception indicates that exception occured during execution of Multiuser-Openness API call

- 📦 `#ctor`: Initializes a new instance of the <see cref="T:Siemens.Engineering.Multiuser.MultiuserException"/> class.
- 📦 `#ctor(System.String)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.Multiuser.MultiuserException"/> class.
- 📦 `#ctor(System.String,System.Exception)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.Multiuser.MultiuserException"/> class.
- 📦 `#ctor(System.String,System.String[])`: Initializes a new instance of the <see cref="T:Siemens.Engineering.Multiuser.MultiuserException"/> class.
- 📦 `#ctor(System.Runtime.Serialization.SerializationInfo,System.Runtime.Serialization.StreamingContext)`: Initializes a new instance of the <see cref="T:Siemens.Engineering.Multiuser.MultiuserException"/> class with serialized data.
- 📦 `GetObjectData(System.Runtime.Serialization.SerializationInfo,System.Runtime.Serialization.StreamingContext)`: When overridden in a derived class, sets the <see cref="T:System.Runtime.Serialization.SerializationInfo"/>B with information about the exception.

## 🛠️ Siemens.Engineering.Multiuser.MultiuserProject
>
> Represents a multiuser project

## 🛠️ Siemens.Engineering.Multiuser.ProjectServer
>
> Represents Project Server

- 🔧 `Host`: Host of the server.
- 🔧 `Port`: Port of the server.
- 🔧 `ServerName`: Alias name of the server.
- 📦 `AddProjectToServer(System.IO.FileInfo)`: Adds project to Multiuser server
- 📦 `CreateLocalSession(Siemens.Engineering.Multiuser.ServerProjectInfo,System.String,System.IO.DirectoryInfo,Siemens.Engineering.Multiuser.SessionCreationMode)`: Perform creation of Multiuser Local Session.
- 📦 `DeleteConnection`: Delete project server connection
- 📦 `DeleteLocalSessionFromServer(Siemens.Engineering.Multiuser.ServerProjectInfo,Siemens.Engineering.Multiuser.LocalSessionInfo)`: Perform deletion of Multiuser Local Session.
- 📦 `GetLocalSessions(Siemens.Engineering.Multiuser.ServerProjectInfo)`: Performs a get operation of all available local session for the given ServerProjectInfo.
- 📦 `GetLockStateProvider(Siemens.Engineering.Multiuser.ServerProjectInfo)`: Performs a get operation of LockStateProvider.
- 📦 `GetProjectServerGroups`: Retrieves the available Group info from a specified server.
- 📦 `GetServerProjects`: Retrieves the available projects info from a specified server.
- 📦 `SetHostName(System.String)`: Set the host name.
- 📦 `SetPort(System.Int32)`: Set the port value.
- 📦 `SetProtocol(Siemens.Engineering.Multiuser.Protocol)`: Set the protocal value.

## 🛠️ Siemens.Engineering.Multiuser.ProjectServerComposition
>
> Composition of Project Server

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.Multiuser.ProjectServer)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.Multiuser.ProjectServer)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String,Siemens.Engineering.Multiuser.Protocol,System.String,System.Int32)`: Create project server connection

## 🛠️ Siemens.Engineering.Multiuser.ProjectServerGroup
>
> Represents information about project server group

- 🔧 `Name`: The name of the Group.
- 📦 `AddProjectToServer(System.IO.FileInfo)`: Adds project to Multiuser server
- 📦 `GetServerProjects`: Retrieves the available projects info from a specified server.

## 🛠️ Siemens.Engineering.Multiuser.Protocol
>
> Protocol

## 🛠️ Siemens.Engineering.Multiuser.ServerProjectInfo
>
> Represents information about a server project

- 🔧 `ProjectName`: The name of the project.
- 🔧 `ServerAlias`: Alias name of the server where project exist.

## 🛠️ Siemens.Engineering.Multiuser.SessionCreationMode
>
> Local session creation mode
