# OPC UA

# V21 API Reference

## 🛠️ Siemens.Engineering.SW.OpcUa.AccessControl.AccessControl
>
> OpcUa Access Control

- 🔧 `NamespaceAccessRestrictions`: List of namespace access restriction
- 🔧 `RoleMappings`: List of role mappings

## 🛠️ Siemens.Engineering.SW.OpcUa.AccessControl.NamespaceAccessRestriction
>
> Namespace access restriction

- 🔧 `ApplyRestrictionsToBrowse`: Apply Restrictions To Browse
- 🔧 `EncryptionRequired`: Encryption Required
- 🔧 `NamespaceIndex`: Namespace index
- 🔧 `NamespaceUri`: Namespace URI
- 🔧 `SessionRequired`: Session Required
- 🔧 `SigningRequired`: Signing Required

## 🛠️ Siemens.Engineering.SW.OpcUa.AccessControl.NamespaceAccessRestrictionComposition
>
> Namespace access restrictions

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.OpcUa.AccessControl.NamespaceAccessRestriction)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.OpcUa.AccessControl.NamespaceAccessRestriction)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.

## 🛠️ Siemens.Engineering.SW.OpcUa.AccessControl.NamespacePermission
>
> Namespace permissions

- 🔧 `Browse`: Browse
- 🔧 `Call`: Call
- 🔧 `NamespaceIndex`: Namespace index of the permission
- 🔧 `NamespaceUri`: Namespace URI of the permission
- 🔧 `Read`: Read
- 🔧 `ReadRolePermissions`: Read Role Permissions
- 🔧 `ReceiveEvents`: Receive Events
- 🔧 `Write`: Write
- 📦 `SetPermission(System.String,System.Boolean)`: Enable or disable a permission

## 🛠️ Siemens.Engineering.SW.OpcUa.AccessControl.NamespacePermissionComposition
>
> List of namespace permissions

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.OpcUa.AccessControl.NamespacePermission)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.OpcUa.AccessControl.NamespacePermission)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.

## 🛠️ Siemens.Engineering.SW.OpcUa.AccessControl.RoleMapping
>
> Role mapping information

- 🔧 `NamespacePermissions`: List of namespace permissions
- 🔧 `DefinedInNamespace`: Defining namespace of the role
- 🔧 `Name`: Name of the role
- 🔧 `ProjectRole`: Mapped project role
- 🔧 `RoleId`: Node ID of the role
- 📦 `SetDefiningNamespace(System.String)`: Sets the defining namespace of the role
- 📦 `SetProjectRole(System.String)`: Sets the mapped project role
- 📦 `SetRoleName(System.String)`: Sets the name of the role
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.OpcUa.AccessControl.RoleMappingComposition
>
> List of role mappings

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.OpcUa.AccessControl.RoleMapping)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.OpcUa.AccessControl.RoleMapping)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `AddStandardOpcUaRole(System.String)`: Add a standard OPC UA role
- 📦 `Create(System.String,System.String)`: Create a new Role

## 🛠️ Siemens.Engineering.SW.OpcUa.OpcUaCommunicationGroup
>
> Top level OpcUa Communication folder

- 🔧 `ServerInterfaceGroup`: OPCUA Server Interface Folder

## 🛠️ Siemens.Engineering.SW.OpcUa.OpcUaProvider
>
> OpcUa Provider

- 🔧 `CommunicationGroup`: Access the OpcUa Communication Folder

## 🛠️ Siemens.Engineering.SW.OpcUa.ReferenceNamespace
>
> OpcUa Reference Namespace

- 🔧 `Comment`: Comment
- 🔧 `Author`: Author
- 🔧 `CreationTime`: Creation time
- 🔧 `Enabled`: Enable reference namespace and download to PLC
- 🔧 `GenerateNodes`: Generate nodes based on local data mapping
- 🔧 `GeneratedInterfaceName`: Name of the generated interface
- 🔧 `LastModified`: Last modified time
- 🔧 `Name`: Name
- 🔧 `UseStringNodeIds`: Use string Node IDs for node generation
- 📦 `Export(System.IO.FileInfo)`: Exports the original XML File
- 📦 `Import(System.IO.FileInfo)`: Import file
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.OpcUa.ReferenceNamespaceComposition
>
> Composition of Reference Namespaces

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.OpcUa.ReferenceNamespace)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.OpcUa.ReferenceNamespace)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String,System.IO.FileInfo)`: Create a new Reference Namespace

## 🛠️ Siemens.Engineering.SW.OpcUa.ServerInterface
>
> OpcUa Server Interface

- 🔧 `Comment`: Comment
- 🔧 `Author`: Author
- 🔧 `CreationTime`: Creation time
- 🔧 `Enabled`: Enable server interface and download to PLC
- 🔧 `LastModified`: Last modified time
- 🔧 `Name`: Name
- 📦 `Export(System.IO.FileInfo)`: Exports the original XML File
- 📦 `Import(System.IO.FileInfo)`: Import file
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.OpcUa.ServerInterfaceComposition
>
> Composition of Server Interfaces

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.OpcUa.ServerInterface)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.OpcUa.ServerInterface)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create a new Server Interface

## 🛠️ Siemens.Engineering.SW.OpcUa.ServerInterfaceGroup
>
> Contains Server Interfaces

- 🔧 `AccessControl`: Returns access control information
- 🔧 `ReferenceNamespaces`: Returns a list of Server Interfaces
- 🔧 `ServerInterfaces`: Returns a list of Server Interfaces
- 🔧 `SimaticInterfaces`: Returns a list of Server Interfaces

## 🛠️ Siemens.Engineering.SW.OpcUa.SimaticInterface
>
> OpcUa Simatic Interface

- 🔧 `Comment`: Comment
- 🔧 `Author`: Author
- 🔧 `CreationTime`: Creation time
- 🔧 `Enabled`: Enable simatic interface and download to PLC
- 🔧 `LastModified`: Last modified time
- 🔧 `Name`: Name
- 🔧 `UseStringNodeIds`: Use string Node IDs for node generation
- 📦 `Export(System.IO.FileInfo)`: Exports the original XML File
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.SW.OpcUa.SimaticInterfaceComposition
>
> Composition of Simatic Interfaces

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.OpcUa.SimaticInterface)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.OpcUa.SimaticInterface)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(System.String)`: Create a new Simatic Interface
