# VCI Workspace Management Reference

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using System.IO;
using System.Globalization;
using Siemens.Engineering;
using Siemens.Engineering.VersionControl;
```

---

## 1. Accessing VCI

```csharp
VersionControlInterface vci = project.GetService<VersionControlInterface>();
WorkspaceSystemGroup systemGroup = vci.WorkspaceGroup;
```

---

## 2. Workspace Groups

Workspaces are organized into a system group and optional user groups.

### WorkspaceSystemGroup

- `Name` — The name of the system group.
- `Parent` — The engineering parent.

### WorkspaceUserGroup

- `Name` — The name of the user group.
- `Parent` — The engineering parent.

### WorkspaceUserGroupComposition

- `Create(string name)` — Create a user group.
- `Find(string name)` — Find a user group.

```csharp
WorkspaceUserGroup userGroup = systemGroup.Groups.Create("MyWorkspaces");
```

---

## 3. Workspaces

A workspace represents a mapping between TIA Portal objects and files on disk.

### Workspace properties

- `Name` — The name of the workspace.
- `RootPath` — The root path on disk (`DirectoryInfo`).
- `WorkspaceLanguage` — The export language (`CultureInfo`).
- `Comment` — Workspace comment.
- `MappedObjects` — Collection of mappings (`MappedObjectComposition`).
- `GlobalLibraryPath` — Path to global library used for type import.
- `DeleteUnusedTypeVersionFromLibrary` — Flag for cleaning up types on import.

### Workspace operations

- `Delete()` — Delete the workspace.
- `ExportObject(IEngineeringObject, DirectoryInfo, string fileName, string fileFormat)` — Export object to workspace.
- `ConnectObject(IEngineeringObject, DirectoryInfo, string fileName, string fileFormat)` — Connect object without export.
- `GetSupportedFileFormats(IEngineeringObject)` — Get formats (e.g., "xml").

### WorkspaceComposition (on Groups)

- `Create(string name)` — Create with default path.
- `Create(string name, DirectoryInfo root)` — Create with specific path.
- `Create(string name, DirectoryInfo root, CultureInfo language)` — Full creation.
- `Find(string name)` — Find workspace by name.

```csharp
Workspace workspace = systemGroup.Workspaces.Create("MainWorkspace", new DirectoryInfo(@"C:\VCI\Main"));
```
