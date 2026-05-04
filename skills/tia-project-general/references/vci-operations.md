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
- `Status` — Current `MappingState`.

### MappedObject operations

- `GetStatus()` — Get individual `IndividualObjectCompareResult`.
- `GetChildStatus()` — Get aggregated status.
- `Synchronize(SynchronizationMode)` — Sync changes.
- `Delete()` — Remove mapping.

### MappingState (Enum)

- `CheckedIn`, `DeletedInProject`, `DeletedInWorkspace`, `Different`, `MappedOnlyInProject`, `MappedOnlyInWorkspace`, `NotConnected`, `UpToDate`.

---

## 2. Synchronization

Used to push/pull changes between project and workspace.

### SynchronizationMode (Enum)

- `ExportProjectToWorkspace` — Push to disk.
- `ImportWorkspaceToProject` — Pull from disk.

### SynchronizationResult

- `MappingState` — Final state after sync.

```csharp
SynchronizationResult result = mappedObj.Synchronize(SynchronizationMode.ImportWorkspaceToProject);
```

---

## 3. Comparison

Detailed comparison between project and workspace files.

### CompareState (Enum)

- `Different`, `Equal`, `NotIdentified`.

### IndividualObjectCompareResult

- `CompareState` — Result of comparison.
- `IndividualObjectCompareDetails` — Detailed differences.

```csharp
IndividualObjectCompareResult res = mappedObj.GetStatus();
if (res.CompareState == CompareState.Different)
{
    // Handle differences
}
```
