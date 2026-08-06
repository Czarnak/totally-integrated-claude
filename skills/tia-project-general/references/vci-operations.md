# VCI Operations Reference (Sync & Compare)

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.VersionControl;
```

---

## 1. Mapped Objects

`MappedObject` represents a specific engineering object linked to a file in a workspace.

### MappedObject properties

- `EngineeringObject` — The linked TIA Portal object.
- `DirectoryPath` — Path in the workspace.
- `FileNameWithoutExtension` — File name.
- `FileFormat` — Format (e.g. "xml").
- `Status` — Current `IndividualObjectCompareResult`.

### MappedObject operations

- `GetStatus()` — Get individual `IndividualObjectCompareResult`.
- `GetChildStatus()` — Get aggregated `SynchronizationResult` for children.
- `void Synchronize(SynchronizationMode)` — Sync changes; this method does not
  return a result.
- `Delete()` — Remove mapping.

### MappingState (Enum)

- `Equal`, `Unequal`.

---

## 2. Synchronization

Used to push/pull changes between project and workspace.

### SynchronizationMode (Enum)

- `ProjectToWorkspace` — Push project changes to disk.
- `WorkspaceToProject` — Pull workspace changes into the project.

### SynchronizationResult

- `MappingState` — Final state after sync.

```csharp
mappedObj.Synchronize(SynchronizationMode.WorkspaceToProject);
SynchronizationResult childResult = mappedObj.GetChildStatus();
MappingState childState = childResult.MappingState;
```

---

## 3. Comparison

Detailed comparison between project and workspace files.

### CompareState (Enum)

- `Equal`, `Unequal`, `WorkspaceFileMissing`, `Unknown`.

### IndividualObjectCompareResult

- `CompareState` — Result of comparison.
- `IndividualObjectCompareDetails` — Detailed differences.

```csharp
IndividualObjectCompareResult res = mappedObj.GetStatus();
if (res.CompareState == CompareState.Unequal)
{
    // Handle differences
}
```
