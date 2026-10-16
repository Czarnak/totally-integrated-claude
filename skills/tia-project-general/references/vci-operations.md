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
- `FileFormat` — Format (e.g. "SimaticML").
- `Status` — Cached `IndividualObjectCompareResult`. **Stale after a synchronization**;
  use `GetStatus()` for decisions.

### MappedObject operations

- `GetStatus()` — Get individual `IndividualObjectCompareResult` (fresh; about 0.46 s
  per mapping on V21, so budget status reads over large workspaces).
- `GetChildStatus()` — Get aggregated `SynchronizationResult` for children. Returned
  `null` for every leaf mapping observed on V21; check for `null`.
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
// Import only when the workspace file alone changed. Synchronize on an Equal mapping
// throws; importing on ProjectObjectChanged, a conflict or WorkspaceFileMissing would
// overwrite project edits.
IndividualObjectCompareResult before = mappedObj.GetStatus();
if (before.CompareState == CompareState.Unequal &&
    before.IndividualObjectCompareDetails == IndividualObjectCompareDetails.WorkspaceFileChanged)
{
    mappedObj.Synchronize(SynchronizationMode.WorkspaceToProject);
    IndividualObjectCompareResult after = mappedObj.GetStatus(); // not mappedObj.Status
}

SynchronizationResult childResult = mappedObj.GetChildStatus(); // null on leaf mappings
MappingState? childState = childResult?.MappingState;
```

### Synchronization behaviour (observed on V21)

> Evidence: live spike on TIA Portal V21 build 2100.0.121.1, one standalone project.

- **`WorkspaceToProject` validates nothing.** A malformed SCL file imported with no
  error and left the mapping `Equal`; the block was merely uncompiled and broken.
  Imported SCL blocks are left inconsistent. Compile the imported objects afterwards
  (see `references/compile.md`) and report the result; never treat a silent import as
  a valid one.
- **The imported object is recreated.** The old `PlcBlock`/object reference is disposed
  and no longer equals `mappedObj.EngineeringObject`. Re-read it from the mapping after
  each import.
- **Transactions.** `WorkspaceToProject` works plainly, under `ExclusiveAccess` and
  inside a `Transaction`; rolling the transaction back reverts the block. A thrown
  item error inside the transaction leaves `CanCommit == false`, so pre-filter to
  mappings that can succeed before starting a batch. Rollback does not remove files
  written by an export (`ProjectToWorkspace` inside a rolled-back transaction is
  untested).
- **Library types.** Importing a library type renamed the type to the workspace file
  name and left its mapping `ProjectObjectChanged`.
- **Cost.** Imports took 1–8 s per block (a 548 KB DB: 5.6 s).

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

### Status meaning (observed on V21)

| Situation | Observed status |
|---|---|
| Right after export | `Equal` |
| File edited on disk | `Unequal`, details `WorkspaceFileChanged` |
| Object edited or renamed in TIA | details `ProjectObjectChanged` |
| Both changed (conflict) | details `ProjectObjectChanged, WorkspaceFileChanged` |
| File deleted or renamed on disk | `WorkspaceFileMissing` (no automatic follow) |
| Object moved to another folder in TIA | `Equal` (a move is invisible) |
| Object deleted in TIA | the mapping disappears silently; the file stays |

Choose the direction from the details: only `WorkspaceFileChanged` → `WorkspaceToProject`;
only `ProjectObjectChanged` → `ProjectToWorkspace`; both → a conflict that needs a user
decision, never an automatic sync. A TIA rename keeps the mapping and its file name.
A new file dropped into a workspace folder is ignored; no Openness call imports it.
`Unknown` was not produced in testing.
