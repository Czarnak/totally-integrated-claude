# Library and Master Copy Reference

V1.4.3 authority: Siemens manual sections 2.5, 2.22-2.26, and
2.35-2.37, plus the bundled `siemens_tia_scripting.pyi`.

The V1.4.3 public surface has `GlobalLibrary`, `GlobalLibraryInfo`,
`ProjectLibrary`, `LibraryType`, `LibraryTypeVersion`, and `MasterCopy`. It does
not expose a separate public folder-navigation class. Folder operations use
string paths such as `"Area/Subarea"`.

All folder creation/deletion, import, update, harmonize, cleanup, edit, release,
discard, default-version selection, instantiation, and master-copy creation are
mutations. Require exact library/type/version/folder selectors and explicit
mutation authorization. Save or archive only under separate authorization.

## GlobalLibrary

Open or create a global library through `Portal`; see `global_portal.md`.

### Read-only surface

```text
global_library.get_name() -> str
global_library.get_author() -> str
global_library.get_path() -> str
global_library.is_modified() -> bool
global_library.is_read_only() -> bool
global_library.get_types() -> List[ts.LibraryType]
global_library.find_library_type(library_type_name: str) -> ts.LibraryType
global_library.get_property(name: str) -> str
global_library.get_properties() -> List[str]
```

`find_library_type()` is not an exact-selection guarantee by itself. Verify the
returned GUID and path when ambiguity matters.

### Lifecycle and mutation signatures

```text
save() -> None
close_global_library() -> None
archive(target_directory_path: str, archive_name: str,
        delete_existing_archive: bool) -> None
set_property(name: str, value: str) -> int
create_folder(folder_path: str) -> None
delete_folder(folder_path: str) -> None
clean_up(folder_path: Optional[str] = None) -> None
update_library(update_mode: int, delete_mode: int, conflict_mode: int,
               type_guids: Optional[List[str]] = None,
               library_name: Optional[str] = None) -> None
update_project(update_mode: int, delete_mode: int, conflict_mode: int,
               type_guids: Optional[List[str]] = None) -> None
harmonize_project(harmonize_options: int,
                  type_guids: Optional[List[str]] = None) -> None
```

Do not assume integer update/delete/conflict modes from memory. Use the values
defined for the installed wrapper and target workflow, record them in the review,
and restrict `type_guids` instead of updating every type when possible.

`delete_existing_archive=True` can overwrite an archive. Default to `False` and
resolve the exact output path before requesting overwrite authorization.

## ProjectLibrary

```text
project_library = project.get_project_library()

project_library.get_types() -> List[ts.LibraryType]
project_library.find_library_type(
    library_type_name: str,
) -> ts.LibraryType
project_library.get_master_copies() -> List[ts.MasterCopy]
```

Mutation signatures:

```text
clean_up(clean_up_mode: Enums.LibraryCleanUpMode,
         folder_path: Optional[str] = None) -> None
import_library_types(import_root_directory: str,
                     device_name: Optional[str] = None,
                     software_unit_name: Optional[str] = None,
                     plc_folder_path: Optional[str] = None,
                     library_folder_path: Optional[str] = None) -> None
update_library(library_name: str, update_mode: int, delete_mode: int,
               conflict_mode: int,
               type_guids: Optional[List[str]] = None) -> None
update_project(delete_mode: int,
               type_guids: Optional[List[str]] = None) -> None
harmonize_project(harmonize_options: int,
                  type_guids: Optional[List[str]] = None) -> None
create_folder(folder_path: str) -> None
delete_folder(folder_path: str) -> None
```

`import_library_types()` is directory-based. The V1.4.3 stub does not add a
`GeneralImportOptions` parameter to this method even though many PLC/HMI imports
now have one. Do not invent it.

The exact cleanup enum is `Enums.LibraryCleanUpMode`, not an older shortened
name:

```python
ts.Enums.LibraryCleanUpMode.PreserveDefaultVersionOfUnusedTypes
ts.Enums.LibraryCleanUpMode.DeleteUnusedTypes
```

Cleanup can delete unused types/versions. Preflight the scoped folder and list
the affected GUIDs before authorization.

## MasterCopy

V1.4.0 added wrapper support for master copies.

```text
master_copy.get_name() -> str
master_copy.get_author() -> str
master_copy.get_creation_date() -> str
master_copy.get_content_name() -> str
master_copy.get_content_type() -> str
master_copy.get_property(name: str) -> str
master_copy.get_properties() -> List[str]
master_copy.set_property(name: str, value: str) -> int
master_copy.get_identifier() -> str

master_copy.instantiate(
    device_name: Optional[str] = None,
    software_unit_name: Optional[str] = None,
    folder_path: Optional[str] = None,
) -> None
```

Objects that expose
`create_master_copy(library_folder_path: Optional[str] = None) -> MasterCopy`
include `Device`, `Module`, `Plc`, `ProgramBlock`, `SystemBlock`,
`UserDataType`, `TechnologyObject`, `SoftwareUnit`, `PlcTagTable`, `PlcTag`,
`Hmi`, `HmiTagTable`, `HmiTag`, `HmiScreen`, and `HmiScript` in the V1.4.3
stub.

Both creation and instantiation are mutations. Specify the exact project-library
folder and exact target device/software-unit/object folder. Reject zero or
multiple target matches.

## LibraryType

```text
library_type.get_name() -> str
library_type.get_author() -> str
library_type.get_guid() -> str
library_type.get_versions() -> List[ts.LibraryTypeVersion]
library_type.find_version(version: str) -> ts.LibraryTypeVersion
library_type.get_property(name: str) -> str
library_type.get_properties() -> List[str]
library_type.set_property(name: str, value: str) -> int
library_type.get_path_full() -> str
library_type.get_path() -> str
library_type.get_comment() -> str
library_type.get_identifier() -> str
```

Use GUID plus full path for exact selection. A name/version string alone can be
ambiguous across libraries or folders.

## LibraryTypeVersion

### Read and discovery

```text
version.get_author() -> str
version.get_guid() -> str
version.get_version_number() -> str
version.get_modified_date() -> str
version.get_state() -> str
version.get_type_object() -> ts.LibraryType
version.get_property(name: str) -> str
version.get_properties() -> List[str]
version.get_comment() -> str
version.get_identifier() -> str
version.find_instances(
    device_name: Optional[str] = None,
) -> List[object]
version.get_supported_export_format() -> List[str]
```

The V1.4.3 signature line omits a return annotation, while its bundled docstring
and the manual document `List[str]`. Use the returned list as the selected
object's runtime capability evidence; do not hardcode an unreported format.

### Export

```text
version.export(
    target_directory_path: str,
    export_format: str,
    library_export_options: ts.Enums.LibraryExportOptions,
    keep_folder_structure: Optional[bool] = None,
) -> None
```

The exact enum is `LibraryExportOptions`. Export itself is normally read-only
with respect to TIA but can overwrite files in the destination; resolve the path
and require overwrite authorization.

### Instantiate, edit, release, discard, and default

```text
version.instantiate(
    device_name: str,
    software_unit_name: Optional[str] = None,
    folder_path: Optional[str] = None,
) -> None

edited_version = version.edit(
    device_name: Optional[str] = None,
)

version.release(
    dependencies_mode: ts.Enums.LibraryDependenciesMode,
    version: str,
    author: str,
    comment: str,
) -> None

version.discard() -> None
version.set_as_default() -> None
version.set_property(name: str, value: str) -> int
```

The exact dependency enum is `Enums.LibraryDependenciesMode`:

```python
ts.Enums.LibraryDependenciesMode.DoNotAutomaticallyCreateOrReleaseDependencies
ts.Enums.LibraryDependenciesMode.AutomaticallyCreateOrReleaseDependenciesIfRequired
```

Automatic dependency release can widen the mutation beyond the selected type.
Prefer the nonautomatic mode unless dependency creation/release was explicitly
reviewed and authorized. `discard()` loses edits; `set_as_default()` changes
future instantiation behavior. Treat each as a separately authorized action.

## Safe library workflow

1. Confirm project versus global library, exact library path/name, type GUID,
   version GUID, and target folder.
2. Capture current type/version/default/instance state before mutation.
3. Scope update, harmonize, cleanup, or import to explicit GUIDs/folders.
4. Use a project transaction only when the target operation supports it; global
   library operations may require different lifecycle handling.
5. Validate resulting types/versions/instances and compile affected engineering
   objects.
6. Roll back or discard only under the pre-agreed failure policy.
7. Save/archive/close only under separate explicit authority.
