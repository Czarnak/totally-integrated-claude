# VCI Workspace Management Reference

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using System;
using System.Collections.Generic;
using System.IO;
using System.Globalization;
using System.Linq;
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
- `Groups` — Child user groups.
- `Workspaces` — Workspaces directly below the system group.

### WorkspaceUserGroup

- `Name` — The name of the user group.
- `Parent` — The engineering parent.
- `Groups` — Nested user groups.
- `Workspaces` — Workspaces directly below the user group.
- `Delete()` — Delete this user group.

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
- `Comment` — Workspace comment (`MultilingualText`).
- `MappedObjects` — Collection of mappings (`MappedObjectComposition`).
- `GlobalLibraryPath` — Global-library file used for type import (`FileInfo`).
- `DeleteUnusedTypeVersionFromLibrary` — Flag for cleaning up types on import.

### Workspace operations

- `Delete()` — Delete the workspace.
- `ExportObject(IEngineeringObject, DirectoryInfo, string fileName, string fileFormat)` — Export object to workspace.
- `ConnectObject(IEngineeringObject, DirectoryInfo, string fileName, string fileFormat)` — Connect object without export.
- `GetSupportedFileFormats(IEngineeringObject)` — Get format names for a leaf object:
  `SimaticML`, `SimaticSD`, plus `SCL` for SCL blocks and `DB` for data blocks; tag tables
  and technology-object DBs return `SimaticML` only; Unified HMI script modules
  `SimaticSD` only. Threw for every container type tested.

### WorkspaceComposition (on Groups)

- `Create(string name)` — Create with default path.
- `Create(string name, DirectoryInfo root)` — Create with specific path.
- `Create(string name, DirectoryInfo root, CultureInfo language)` — Full creation.
- `Find(string name)` — Find workspace by name.

```csharp
// The root directory must already exist ("Root directory does not exist" otherwise).
Directory.CreateDirectory(@"C:\VCI\Main");
Workspace workspace = systemGroup.Workspaces.Create("MainWorkspace", new DirectoryInfo(@"C:\VCI\Main"));
```

Duplicate workspace names throw. Creating a workspace on a leftover folder keeps its
files and adopts none of them.

---

## 4. Export and connect safety (observed on V21)

> Evidence: live spike on TIA Portal V21 build 2100.0.121.1, one standalone project.
> Treat as observed behaviour, not as documented Siemens contract.

**Leaf objects only — containers can crash TIA Portal.** Pass only single objects
(block, tag table, PLC data type, technology object, script module) to `ExportObject` or
`ConnectObject`. Some containers (block groups, tag-table/type/TO groups) are rejected
cleanly, but a **device** and the **project library** crashed the whole Portal: an
unhandled exception inside Siemens' export command, surfaced to the client only as
`NonRecoverableException`. The VCI editor UI also expands containers to leaf mappings.
Expand a folder to its leaves yourself and export each leaf.

**Formats.** Always pass the format explicitly; it overrides workspace and global VCI
settings, which Openness cannot read anyway. Prefer `SimaticML` for PLC objects:
`SimaticSD` crashed the Portal on one block that `SimaticML` refused cleanly as "not
consistent". VCI applies its own consistency check, so `IsConsistent == true` does not
guarantee an export succeeds. `SCL` was not offered for LAD/FBD blocks (expected the
same for STL/GRAPH, untested). Unified HMI script modules support `SimaticSD` only.

**Silent overwrite.** Exporting a second object to the same relative directory and file
name overwrote the first object's files with no error and left the first mapping
`WorkspaceFileMissing`. Before every export, check that no mapping already uses that
directory and file name (case-insensitive) and that no `<fileName>.*` file exists.
`ConnectObject` onto an existing file threw (one attempt).

**Directories.** The directory argument is relative to `RootPath`, starts with `\`, and
must **already exist**; `ExportObject` never creates it.

```csharp
// Export ONE PLC leaf as SimaticML (HMI script modules need "SimaticSD" instead).
// GetSupportedFileFormats throws on containers, so it doubles as a gate: if it
// throws, do not call ExportObject on that object.
static void ExportPlcLeaf(Workspace workspace, IEngineeringObject leaf,
    string relativeDirectory /* e.g. @"\PLC_1\Blocks" */, string fileName)
{
    List<string> formats = workspace.GetSupportedFileFormats(leaf).ToList();
    if (!formats.Contains("SimaticML"))
        throw new InvalidOperationException("SimaticML not supported for this object.");

    string root = Path.GetFullPath(workspace.RootPath.FullName).TrimEnd(Path.DirectorySeparatorChar);
    string physicalDir = Path.GetFullPath(root + relativeDirectory)
        .TrimEnd(Path.DirectorySeparatorChar);
    if (!physicalDir.StartsWith(root + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase))
        throw new InvalidOperationException($"'{relativeDirectory}' escapes the workspace root.");
    bool keyTaken = workspace.MappedObjects.Any(m =>
        string.Equals(m.DirectoryPath.FullName.TrimEnd(Path.DirectorySeparatorChar), physicalDir,
            StringComparison.OrdinalIgnoreCase) &&
        string.Equals(m.FileNameWithoutExtension, fileName, StringComparison.OrdinalIgnoreCase));
    if (keyTaken || (Directory.Exists(physicalDir) &&
                     Directory.GetFiles(physicalDir, fileName + ".*").Length > 0))
        throw new InvalidOperationException($"Refusing to overwrite '{fileName}' in {relativeDirectory}.");

    Directory.CreateDirectory(physicalDir);
    workspace.ExportObject(leaf, new DirectoryInfo(relativeDirectory), fileName, "SimaticML");
}
```

The mapping check catches a key whose files are already gone (`WorkspaceFileMissing`);
the file check catches leftovers that no mapping owns. Scanning `MappedObjects` per
export grows with the workspace; for bulk exports, collect the taken keys once and
re-check just before each `ExportObject`.

**Cost.** About 0.8 s per leaf plain (max 13.8 s) and about 0.25 s per leaf inside one
transaction. A whole PLC (~570 leaves) extrapolates to ~8 min plain / ~3.5 min in one
transaction, and later bulk runs (~610 leaves, via a tool with extra per-leaf safety
scans) did not finish within 15 min. Chunk
large exports and budget for timeouts. A transaction rollback restores the project but **not** files already
written by an export.

**After a `NonRecoverableException`**, do not retry or continue the batch. The real
exception is in TIA Portal's crash report (see `tia-csharp-common` → Exception handling).

**Persistence and deletes.** New workspaces and mappings are lost if the project closes
without saving. `MappedObject.Delete()` and `Workspace.Delete()` keep every file on disk.
