# Project and global library operations (TIA Portal V21)

This reference owns the C# Openness workflow for project libraries, global libraries, master copies, library types and versions, type-instance reconciliation, library update/harmonization, cleanup, and comparison.

## Evidence basis

- Installed V21 contract: `Siemens.Engineering.Base.dll` and `Siemens.Engineering.Base.xml` under `PublicAPI/V21/net48`.
- Siemens V21: [Accessing global libraries](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/tia-portal-openness-api/functions-on-libraries/accessing-global-libraries)
- Siemens V21: [Accessing folders in a library](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/tia-portal-openness-api/functions-on-libraries/accessing-folders-in-a-library)
- Siemens V21: [Accessing types](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/tia-portal-openness-api/functions-on-libraries/accessing-types)
- Siemens V21: [Accessing type versions](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/tia-portal-openness-api/functions-on-libraries/accessing-type-versions)
- Siemens V21: [Accessing instances](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/tia-portal-openness-api/functions-on-libraries/accessing-instances)
- Siemens V21: [Updating the project](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/tia-portal-openness-api/functions-on-libraries/updating-the-project?contentId=LMkmyEfJkkhrRi1Dfn7fAw)
- Siemens V21: [Harmonize project from project library](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/tia-portal-openness-api/functions-on-libraries/harmonize-project-from-project-library)

## Entry points and ownership

```csharp
using Siemens.Engineering;
using Siemens.Engineering.Library;
using Siemens.Engineering.Library.MasterCopies;
using Siemens.Engineering.Library.Types;

Project project = /* already opened */;
ProjectLibrary projectLibrary = project.ProjectLibrary;
GlobalLibraryComposition globalLibraries = tiaPortal.GlobalLibraries;

foreach (GlobalLibraryInfo info in globalLibraries.GetGlobalLibraryInfos())
{
    Console.WriteLine($"{info.LibraryType}: {info.Name} ({info.Path})");
}

UserGlobalLibrary library =
    (UserGlobalLibrary)globalLibraries.Open(
        new FileInfo(@"D:\Libraries\Plant.al21"),
        OpenMode.ReadOnly);
```

`ProjectLibrary` is owned by its project and is persisted with the project. A `UserGlobalLibrary` opened by the application must be saved when intended and closed deterministically with `Close()`; it does not implement `IDisposable` in the installed V21 contract. System and corporate global libraries are read-only. Do not reopen the same user library in a conflicting mode.

Opening with upgrade, retrieving, creating, `Save`, `SaveAs`, `Archive`, cleanup, or opening read-write can create or overwrite artifacts. Resolve the exact source and destination first and require explicit authorization before performing them. Never infer permission to mutate a library from a request to inspect it.

## Folder, type, and version traversal

Both `ProjectLibrary` and `GlobalLibrary` implement `ILibrary`:

```csharp
ILibrary library = project.ProjectLibrary;

LibraryTypeSystemFolder typeRoot = library.TypeFolder;
MasterCopySystemFolder masterCopyRoot = library.MasterCopyFolder;

LibraryType type = typeRoot.Types.Find("PumpControl");
if (type == null)
    throw new InvalidOperationException("Library type was not found in this folder.");

foreach (LibraryTypeVersion version in type.Versions)
{
    Console.WriteLine($"{version.VersionNumber} {version.State} {version.Guid}");
}

LibraryType byGuid = library.FindType(type.Guid);
LibraryTypeVersion versionByGuid = library.FindVersion(type.Versions[0].Guid);
```

`Types.Find(name)` searches only that composition, so a duplicate name in another folder remains possible. Prefer `ILibrary.FindType(Guid)` or `FindVersion(Guid)` for stable identity. Traverse `Folders` explicitly when the task begins from a path.

The V21 base `LibraryTypeVersion` exposes `Dependencies`, `Dependents`, `MasterCopiesContainingInstances`, `OriginalLibrary`, `IsDefault`, and `FindInstances(IInstanceSearchScope)`. `PlcSoftware` and `HmiTarget` are supported instance-search scopes. Do not assume that every instance is linked; `GetService<LibraryTypeInstanceInfo>()` may return `null`.

## Master-copy workflow

An object must implement `IMasterCopySource` before it can be captured:

```csharp
IEngineeringObject sourceObject = /* selected project object */;
IMasterCopySource source = sourceObject as IMasterCopySource
    ?? throw new InvalidOperationException("The selected object cannot be a master-copy source.");

MasterCopyComposition target = projectLibrary.MasterCopyFolder.MasterCopies;
MasterCopy created = target.Create(source);

MasterCopy existing = target.Find(created.Name);
MasterCopy copied = target.CreateFrom(existing);
```

The installed signature is `MasterCopyComposition.Create(IMasterCopySource)`. Creation from an existing master copy uses `CreateFrom(MasterCopy)`. Instantiating a master copy is target-composition-specific and normally uses that target's `CreateFrom(MasterCopy[, MasterCopyMode])`; do not invent a universal method on `MasterCopy`.

For collisions, choose `MasterCopyMode.Rename`, `Replace`, or `ThrowIfExists` deliberately. `Replace` and `Delete()` are destructive and need explicit authorization plus an inventory of the affected object and destination.

## Type/version mutation workflow

Creating types or versions from documents returns `TypeCreateTransferResults` or `VersionCreateTransferResults`; inspect the created object, `TransferResultState`, and every result message. `TransferResultState.Warning` is a completed operation with warnings, not proof of clean success.

For existing versions:

```csharp
LibraryTypeVersion selected = /* resolve by GUID/version */;

if (selected.State == LibraryTypeVersionState.Committed)
{
    LibraryTypeVersion inWork = selected.Edit();
    // Edit the supported content/instance, then validate and compile it.
}

selected.Release(
    CreateOrReleaseDependenciesMode.DoNotAutomaticallyCreateOrReleaseDependencies,
    new Version(2, 0, 0),
    "Automation",
    "Validated release");
```

The exact installed method is `LibraryTypeVersion.Release(CreateOrReleaseDependenciesMode, Version, string, string)`. Release, `Edit`, `Discard`, `SetAsDefault`, `Delete`, type creation, and version creation mutate library/project state. Require explicit authorization, examine `Dependencies` and `Dependents`, use the least expansive dependency mode, and do not release automatically just because compilation succeeded.

`UpdatePathsMode` must be selected explicitly when a target `CreateFrom` overload supports it:

- `KeepExistingPathsInTarget`
- `UpdatePathsInTarget`
- `ThrowIfPathsConflict`

Prefer `ThrowIfPathsConflict` for an unattended proposal/validation pass. A global-library type instance is synchronized into the project library before it is created in the project; plan for that extra mutation.

## Update, harmonize, cleanup, and compare

Run the read-only update check before proposing an update:

```csharp
UpdateCheckResult check = globalLibrary.UpdateCheck(
    project,
    UpdateCheckMode.ReportOutOfDateOnly);

foreach (UpdateCheckResultMessage message in check.Messages)
{
    // Record Description, MessageParts, and nested Messages recursively.
}
```

The installed call is `UpdateCheck(project, UpdateCheckMode.ReportOutOfDateOnly)`. Treat nested messages as part of the result; an empty top-level description is not success proof.

`UpdateProject`, `UpdateLibrary`, `HarmonizeProject`, and `ProjectLibrary.CleanUpLibrary` are write operations. Before executing one:

1. Bind the source library, selected types/folders, target project scopes, and current GUID/version inventory into the proposal.
2. Record dependency/dependent and instance evidence.
3. Select `ForceUpdateMode`, `DeleteUnusedVersionsMode`, `StructureConflictResolutionMode`, `HarmonizeProjectOptions`, or `CleanUpMode` explicitly; do not rely on broad defaults.
4. Obtain explicit authorization for that exact proposal.
5. Use `ExclusiveAccess` and a project transaction where the participating API supports it. Do not assume a transaction rolls back a separately saved global library.
6. Re-query type/version GUIDs, instance bindings, default versions, messages, and compile results before saving.

`HarmonizeProjectOptions.None` is invalid for an actual harmonization. `CleanUpMode.DeleteUnusedTypes`, automatic version deletion, forced default-version changes, structure replacement, and `UserGlobalLibrary.Save`/`SaveAs` are destructive or hard-to-reverse choices.

For comparison, call `ProjectLibrary.CompareToLibrary(ISoftwareCompareTarget)` or `GlobalLibrary.CompareToLibrary(ISoftwareCompareTarget)` and traverse `LibraryCompareResult.RootElement`, child `Elements`, `ComparisonResult`, and `DetailedInformation.Properties`. A container-level difference is not sufficient to identify the changed leaf.

## Result and failure boundary

- Treat `TransferResultState.Success` as transport/import completion only; separately validate created type/version identity and compile/runtime suitability.
- Treat `TransferResultState.Warning` as requiring message review and an explicit disposition.
- Catch and report `EngineeringException`/`EngineeringTargetInvocationException` with operation, library identity, selected GUIDs, and target scope; never expose credentials or protected project data.
- Do not save merely because an API returned without throwing.
- Static API/schema checks are not live TIA evidence. Opening, updating, releasing, compiling, saving, and instance reconciliation require an authorized TIA V21 run.

## Installed V21 public type catalogue

The headings below cover all 66 public types in the installed V21 Base assembly under `Siemens.Engineering.Library`, `.MasterCopies`, `.Types`, and `.Compare`.

## 🛠️ Siemens.Engineering.Library.CorporateGlobalLibrary

Read-only corporate-library specialization.

## 🛠️ Siemens.Engineering.Library.ExportTransferResult

Document export result with exported documents, messages, and state.

## 🛠️ Siemens.Engineering.Library.GlobalLibrary

Global-library base object and update/compare entry point.

## 🛠️ Siemens.Engineering.Library.GlobalLibraryComposition

Portal-level global-library discovery, create, open, retrieve, and upgrade composition.

## 🛠️ Siemens.Engineering.Library.GlobalLibraryInfo

Available/open library descriptor.

## 🛠️ Siemens.Engineering.Library.GlobalLibraryType

`System`, `Corporate`, or `User`.

## 🛠️ Siemens.Engineering.Library.ILibrary

Common project/global library folders and update operations.

## 🛠️ Siemens.Engineering.Library.LibraryArchivationMode

Archive compression and restorable-data options.

## 🛠️ Siemens.Engineering.Library.LibraryExportOptions

Library-version-info document export options.

## 🛠️ Siemens.Engineering.Library.LibraryImportOptions

Inactive-culture handling for document import.

## 🛠️ Siemens.Engineering.Library.ProjectLibrary

Project-owned library, cleanup, compare, update, and harmonization entry point.

## 🛠️ Siemens.Engineering.Library.SystemGlobalLibrary

Read-only installed system-library specialization.

## 🛠️ Siemens.Engineering.Library.TransferResultMessage

Transfer message.

## 🛠️ Siemens.Engineering.Library.TransferResultMessageComposition

Transfer-message collection.

## 🛠️ Siemens.Engineering.Library.TransferResultState

`Success` or `Warning`.

## 🛠️ Siemens.Engineering.Library.TypeCreateTransferResults

Created type plus transfer messages/state.

## 🛠️ Siemens.Engineering.Library.UserGlobalLibrary

User-library save, archive, close, cleanup, and lifecycle operations.

## 🛠️ Siemens.Engineering.Library.VersionCreateTransferResults

Created version plus transfer messages/state.

## 🛠️ Siemens.Engineering.Library.MasterCopies.IMasterCopySource

Marker for objects eligible to become master-copy content.

## 🛠️ Siemens.Engineering.Library.MasterCopies.IMasterCopyTarget

Marker for compositions eligible to instantiate master-copy content.

## 🛠️ Siemens.Engineering.Library.MasterCopies.MasterCopy

Named master-copy object with content descriptions and deletion.

## 🛠️ Siemens.Engineering.Library.MasterCopies.MasterCopyAssociation

Read-only master-copy association.

## 🛠️ Siemens.Engineering.Library.MasterCopies.MasterCopyComposition

Create, copy, find, and enumerate master copies.

## 🛠️ Siemens.Engineering.Library.MasterCopies.MasterCopyContentDescription

Master-copy content name/type descriptor.

## 🛠️ Siemens.Engineering.Library.MasterCopies.MasterCopyContentDescriptionComposition

Content-description collection.

## 🛠️ Siemens.Engineering.Library.MasterCopies.MasterCopyFolder

Folder with child folders and master copies.

## 🛠️ Siemens.Engineering.Library.MasterCopies.MasterCopyMode

Collision choice: `Rename`, `Replace`, or `ThrowIfExists`.

## 🛠️ Siemens.Engineering.Library.MasterCopies.MasterCopySystemFolder

Root master-copy folder.

## 🛠️ Siemens.Engineering.Library.MasterCopies.MasterCopyUserFolder

Deletable user master-copy folder.

## 🛠️ Siemens.Engineering.Library.MasterCopies.MasterCopyUserFolderComposition

Create/find/enumerate user master-copy folders.

## 🛠️ Siemens.Engineering.Library.Types.CleanUpMode

Unused-type cleanup behavior.

## 🛠️ Siemens.Engineering.Library.Types.ConsistencyStatus

Library/project version-consistency flags.

## 🛠️ Siemens.Engineering.Library.Types.CreateOptions

Document creation collision choice: `None` or `Override`.

## 🛠️ Siemens.Engineering.Library.Types.CreateOrReleaseDependenciesMode

Dependency creation/release policy.

## 🛠️ Siemens.Engineering.Library.Types.DeleteUnusedVersionsMode

Automatic unused-version deletion policy.

## 🛠️ Siemens.Engineering.Library.Types.ForceUpdateMode

Default-version behavior during force update.

## 🛠️ Siemens.Engineering.Library.Types.HarmonizeProjectOptions

Name/path harmonization flags.

## 🛠️ Siemens.Engineering.Library.Types.IInstanceSearchScope

Scope accepted by `LibraryTypeVersion.FindInstances`.

## 🛠️ Siemens.Engineering.Library.Types.ILibraryTypeInstantiationTarget

Marker for type-version instantiation targets.

## 🛠️ Siemens.Engineering.Library.Types.ILibraryTypeOrFolderSelection

Type/folder selection accepted by update and harmonization APIs.

## 🛠️ Siemens.Engineering.Library.Types.IUpdateProjectScope

Target scope accepted by project update/harmonization APIs.

## 🛠️ Siemens.Engineering.Library.Types.LibraryType

Library type, versions, identity, status, and targeted update operations.

## 🛠️ Siemens.Engineering.Library.Types.LibraryTypeComposition

Find/enumerate types and create a type from documents.

## 🛠️ Siemens.Engineering.Library.Types.LibraryTypeFolder

Folder with child folders and types.

## 🛠️ Siemens.Engineering.Library.Types.LibraryTypeInstanceInfo

Links a project instance to its library type version.

## 🛠️ Siemens.Engineering.Library.Types.LibraryTypeSystemFolder

Root type folder.

## 🛠️ Siemens.Engineering.Library.Types.LibraryTypeUserFolder

Deletable user type folder.

## 🛠️ Siemens.Engineering.Library.Types.LibraryTypeUserFolderComposition

Create/find/enumerate user type folders.

## 🛠️ Siemens.Engineering.Library.Types.LibraryTypeVersion

Version state, dependencies, instances, edit/release/default/discard/export operations.

## 🛠️ Siemens.Engineering.Library.Types.LibraryTypeVersionAssociation

Read-only type-version association.

## 🛠️ Siemens.Engineering.Library.Types.LibraryTypeVersionComposition

Find/enumerate versions and create a version from documents.

## 🛠️ Siemens.Engineering.Library.Types.LibraryTypeVersionState

`InWork` or `Committed`.

## 🛠️ Siemens.Engineering.Library.Types.StructureConflictResolutionMode

Cancel, retain, or update structure during synchronization.

## 🛠️ Siemens.Engineering.Library.Types.UpdateCheckMode

Report out-of-date only or both out-of-date/up-to-date results.

## 🛠️ Siemens.Engineering.Library.Types.UpdateCheckResult

Update-check root result.

## 🛠️ Siemens.Engineering.Library.Types.UpdateCheckResultMessage

Recursive update-check message with description and parts.

## 🛠️ Siemens.Engineering.Library.Types.UpdateCheckResultMessageComposition

Update-check message collection.

## 🛠️ Siemens.Engineering.Library.Types.UpdatePathsMode

Target-path conflict handling during supported type instantiation.

## 🛠️ Siemens.Engineering.Library.Compare.DetailCompareStatus

Detailed-property comparison state.

## 🛠️ Siemens.Engineering.Library.Compare.DetailedCompareResult

Detailed comparison property collection.

## 🛠️ Siemens.Engineering.Library.Compare.DetailedCompareResultElement

Left/right value and detailed comparison status.

## 🛠️ Siemens.Engineering.Library.Compare.DetailedCompareResultElementComposition

Detailed comparison element collection.

## 🛠️ Siemens.Engineering.Library.Compare.LibraryCompareResult

Library comparison root result.

## 🛠️ Siemens.Engineering.Library.Compare.LibraryCompareResultElement

Recursive comparison element with left/right objects and details.

## 🛠️ Siemens.Engineering.Library.Compare.LibraryCompareResultElementComposition

Comparison child-element collection.

## 🛠️ Siemens.Engineering.Library.Compare.LibraryCompareResultState

Object/container identity/difference and left/right-missing states.
