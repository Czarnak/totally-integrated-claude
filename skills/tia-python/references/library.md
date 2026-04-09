# Library Reference

Shared trait methods (`get_name`, `get_property`, `get_properties`, `set_property`,
`get_identifier`) are documented in SKILL.md. Only unique methods listed here.

---

## GlobalLibrary

Retrieved via `portal.get_global_library()` / `portal.open_global_library()` etc.

```python
global_lib.save()
global_lib.get_author()      # → str
global_lib.get_path()        # → str  full path
global_lib.is_modified()     # → bool
global_lib.is_read_only()    # → bool
global_lib.close_global_library()
```

### Folder Management

```python
global_lib.create_folder(folder_path="myFolder/subFolderExample")
global_lib.delete_folder(folder_path="myFolder/subFolderExample")
```

### Archive

```python
global_lib.archive(
    target_directory_path="C:\\ws\\newfolder",
    archive_name="testgloballib",
    delete_existing_archive=True
)
```

### Type Access

```python
global_lib.get_types()                                  # → List[LibraryType]
global_lib.find_library_type(library_type_name="MyType") # → LibraryType
```

### Update / Harmonize

```python
# Update a target library with types from this global library
global_lib.update_library(
    update_mode=1,       # 1=ForceSetAnyUpdatedVersionAsDefault, 2=NoDefaultVersionChange, 3=SetOnlyHigherUpdatedVersionAsDefault
    delete_mode=1,       # 0=AutomaticallyDelete, 1=DoNotDelete
    conflict_mode=3,     # 1=CancelIfStructureConflicts, 2=RetainStructure, 3=UpdateStructure
    type_guids=["93826aed-..."],  # Optional: filter to specific types
    library_name="MyGlobalLibrary"  # Optional: target library name (defaults to project library)
)

# Update current project with types from this global library
global_lib.update_project(
    update_mode=1,
    delete_mode=1,
    conflict_mode=3,
    type_guids=None     # Optional
)

# Harmonize type instances in project using this library
global_lib.harmonize_project(
    harmonize_options=0,  # 0=HarmonizePathsAndNames, 1=HarmonizePaths, 2=HarmonizeNames
    type_guids=None       # Optional
)

# Clean up library (removes unused type versions, not types themselves)
global_lib.clean_up(folder_path=None)  # Optional folder scope
```

---

## GlobalLibraryInfo

Lightweight info object returned by `portal.get_global_library_infos()`.

```python
# Has: get_name, get_property, get_properties, set_property
# No open/save/archive methods — use portal methods to open the actual library
```

---

## ProjectLibrary

Retrieved via `project.get_project_library()` → `ProjectLibrary`

```python
project_lib = project.get_project_library()
```

### Type Access

```python
project_lib.get_types()                                   # → List[LibraryType]
project_lib.find_library_type(library_type_name="MyType") # → LibraryType
```

### Folder Management

```python
project_lib.create_folder(folder_path="myFolder/subFolderExample")
project_lib.delete_folder(folder_path="myFolder/subFolderExample")
```

### Import

```python
project_lib.import_library_types(
    import_root_directory="C:\\ws\\importLibraryTypes",
    device_name="PLC_1",            # Optional
    software_unit_name="Unit1",     # Optional
    plc_folder_path="group1/group2", # Optional
    library_folder_path="ImportLibFolder/Types"  # Optional
)
```

### Update / Harmonize

```python
# Update a global library with types from this project library
project_lib.update_library(
    library_name="MyGlobalLibrary",
    update_mode=1,
    delete_mode=1,
    conflict_mode=3,
    type_guids=None    # Optional
)

# Update project instances from project library
project_lib.update_project(
    delete_mode=1,
    type_guids=None    # Optional
)

# Harmonize
project_lib.harmonize_project(
    harmonize_options=0,
    type_guids=None
)
```

### Clean Up

```python
project_lib.clean_up(
    clean_up_mode=ts.Enums.CleanUpMode.DeleteUnusedTypes,
    folder_path=None   # Optional
)
```

---

## LibraryTypeFolder

Used to navigate folder structure within a library.

```python
lib_folder.get_name()                                   # → str
lib_folder.get_folders()                                # → List[LibraryTypeFolder]
lib_folder.get_types()                                  # → List[LibraryType]
lib_folder.find_library_type(library_type_name="MyType") # → LibraryType
lib_folder.find_folder(folder_name="MyFolder")          # → LibraryTypeFolder
```

---

## LibraryType

```python
lib_type.get_name()     # → str
lib_type.get_author()   # → str
lib_type.get_guid()     # → str
lib_type.get_comment()  # → str  (current editing language)
lib_type.get_path()     # → str  path to parent system folder
lib_type.get_path_full() # → str  full path to project root

lib_type.get_versions()                   # → List[LibraryTypeVersion]
lib_type.find_version(version="1.0.0")   # → LibraryTypeVersion

# Has: get_property, get_properties, set_property, get_identifier
```

---

## LibraryTypeVersion

```python
version.get_author()           # → str
version.get_guid()             # → str
version.get_version_number()   # → str
version.get_modified_date()    # → str
version.get_state()            # → str
version.get_comment()          # → str
version.get_type_object()      # → LibraryType  (parent type)
```

### Instances

```python
# Find all instances of this type version in the project
instances = version.find_instances(device_name=None)  # Optional device filter

# Create an instance in a PLC or HMI
version.instantiate(
    device_name="PLC_1",
    software_unit_name="Unit1",   # Optional
    folder_path="group1/group2"   # Optional
)
```

### Export

```python
formats = version.get_supported_export_format()   # → List[str]

version.export(
    target_directory_path="C:\\ws\\export",
    export_format="SimaticML",     # Use get_supported_export_format() to check options
    library_export_options=ts.Enums.LibraryExportOptions.WithLibraryVersionInfoFile,
    keep_folder_structure=True     # Optional
)
```

### Edit / Release Workflow

```python
# Begin editing a type version
edited_version = version.edit(device_name="PLC_1")   # Optional device

# Release the edited version
version.release(
    dependencies_mode=ts.Enums.DependenciesMode.AutomaticallyCreateOrReleaseDependenciesIfRequired,
    version="1.0.0",
    author="John",
    comment="Initial release"
)

# Discard changes
version.discard()

# Set this version as the default
version.set_as_default()

# Has: get_property, get_properties, set_property, get_identifier
```
