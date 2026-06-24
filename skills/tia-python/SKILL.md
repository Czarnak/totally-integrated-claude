---
name: tia-python
description: Reference routed skill. Do NOT load directly unless user says so.
license: MIT
---

# TIA Scripting Python – Skill

Library: `siemens_tia_scripting` (v1.1.0)  
Requires: Python 3.12.x, TIA Portal V15.1+, TIA Portal Openness V15.1+

---

## Installation

Do not use `pip install siemens_tia_scripting` or `pip install siemens-tia-scripting`
from PyPI. Download TIA Scripting Python from Siemens Industry Online Support,
unzip it, then choose one Siemens-supported setup path:

- **File import:** set the `TIA_SCRIPTING` environment variable to the extracted
  `binaries` directory and append it to `sys.path`.
- **Wheel install:** navigate to the extracted `binaries` directory and install
  the matching wheel file, for example:

```powershell
cd C:\Path\To\Your\TIA_Scripting_Python\binaries
py -3.12 -m pip install .\siemens_tia_scripting-x.x.x-cp312-cp312-win_amd64.whl
```

Replace `x.x.x` with the version in the downloaded wheel filename.

---

## Setup Boilerplate

```python
import os
import sys

# Option A – environment variable (file import method)
sys.path.append(os.getenv('TIA_SCRIPTING'))
import siemens_tia_scripting as ts

# Option B – installed as pip package
import siemens_tia_scripting as ts
```

---

## Object Hierarchy

```
siemens_tia_scripting (Global functions)
└── Portal
    └── Project
        ├── Plc
        │   ├── ProgramBlock / SystemBlock
        │   ├── PlcTagTable → PlcTag / UserConstant
        │   ├── UserDataType
        │   ├── ExternalSource
        │   ├── ForceTable / WatchTable
        │   ├── TechnologyObject
        │   ├── SoftwareUnit (contains same sub-objects as Plc)
        │   └── SafetyAdministration
        ├── Hmi
        │   ├── HmiTagTable → HmiTag
        │   ├── HmiScreen / HmiScript / HmiCycle
        │   ├── HmiAlarm / HmiAlarmClass
        │   ├── HmiConnection
        │   ├── HmiGraphicList / HmiTextList
        └── ProjectLibrary
            └── LibraryType → LibraryTypeVersion

Portal
└── GlobalLibrary
    └── LibraryTypeFolder → LibraryType → LibraryTypeVersion
```

Accessing any object requires: Portal open → Project open → device retrieved.

---

## Shared Traits (apply to most classes)

These methods behave identically across all classes that have them. Do NOT repeat their full docs in reference files — refer here instead.

### get_name() → str

Returns the name of the object.

### get_property(name: str) → str

Returns a single property value as string. Non-string values are auto-converted.

```python
val = obj.get_property(name="CreationDate")
```

### get_properties() → List[str]

Returns all property names of the object.

### set_property(name: str, value: str) → int

Sets a property. Value must be passed as string regardless of underlying type:

- bool → `"True"` / `"False"`
- int → `"42"`
- float → `"3.14"`
- enum → index string `"0"` or name string `"OptionA"`

```python
obj.set_property(name="Name", value="MyNewName")
```

### get_identifier() → str

Returns a unique identifier string for the object.

### export(target_directory_path, export_options=None, export_format=None, keep_folder_structure=None)

Exports the object. Shared signature across PLC/HMI data objects.

- `export_options`: `Enums.ExportOptions` (WithDefaults=0, Nan=1, WithReadOnly=2)
- `export_format`: `Enums.ExportFormats` (SimaticML=0, ExternalSource=1, SimaticSD=2)
- `keep_folder_structure`: bool — if True, folder hierarchy is preserved

```python
obj.export(target_directory_path="C:\\ws\\export",
           export_options=ts.Enums.ExportOptions.WithDefaults)
```

### delete()

Deletes the object from TIA Portal.

### get_path() → str / get_path_full() → str

- `get_path()` → path up to the parent system folder
- `get_path_full()` → full path up to project root

### get_fingerprints() → List[str]

Returns fingerprint data for the object.

### get_supported_export_format() → List[str]

Returns a list of export format strings supported by the object.

### show_in_editor()

Opens the object in the TIA Portal editor UI.

### is_consistent() → bool

Returns True if the object is consistent (compiled, no errors).

---

## Enums Reference

```python
ts.Enums.PortalMode          # WithGraphicalUserInterface=0, WithoutGraphicalUserInterface=1, AnyUserInterface=2
ts.Enums.UmacUserMode        # Project=0, Global=1
ts.Enums.ExportFormats       # SimaticML=0, ExternalSource=1, SimaticSD=2
ts.Enums.ExportOptions       # WithDefaults=0, Nan=1, WithReadOnly=2
ts.Enums.CleanUpMode         # PreserveDefaultVersionOfUnusedTypes=0, DeleteUnusedTypes=1
ts.Enums.LibraryExportOptions # Nan=0, WithLibraryVersionInfoFile=1, OnlyLibraryVersionInfoFile=2
ts.Enums.HarmonizeOptions    # HarmonizePathsAndNames=0, HarmonizePaths=1, HarmonizeNames=2
ts.Enums.DependenciesMode    # DoNotAutomaticallyCreateOrReleaseDependencies=0, AutomaticallyCreateOrReleaseDependenciesIfRequired=1
```

---

## Logging

```python
ts.set_logging(path="C:\\ws\\tiascripting.log", console=True)
```

Call early in the script, before opening a portal.

---

## Reference Files

Load only the file(s) relevant to the task at hand:

| File | When to load |
|------|-------------|
| `skills/tia-python/references/global_portal.md` | Opening/attaching portal, project management, UMAC, credentials |
| `skills/tia-python/references/plc.md` | Working with PLC devices, blocks, tags, UDTs, technology objects, software units |
| `skills/tia-python/references/hmi.md` | Working with HMI devices, screens, tags, scripts, alarms, connections |
| `skills/tia-python/references/library.md` | Working with GlobalLibrary, ProjectLibrary, LibraryTypes and versions |
| `skills/tia-python/references/project.md` | Project-level operations, ProjectServer, transactions, TestSuite |

For pipelines that span multiple domains, load all relevant files before generating code.

---

## General Coding Guidance

- **One function per device type** — keep PLC logic and HMI logic in separate functions.
- **Always check compile/download return values** — `compile_hardware()` and `compile_software()` return `True` if there are errors.
- **Use `folder_path` parameters** — most `get_*` methods accept an optional `folder_path: str` using `"group1/group2"` syntax to scope retrieval.
- **`import_*` methods take a directory path**, not a file path — point to the folder containing exported XML files.
- **Transactions** — use `project.start_transaction()` / `project.end_transaction()` for bulk changes that should be undoable.
- **`set_property` values are always strings** — even for booleans and numbers.

## Destructive-operation safety

These rules are mandatory for generated Python TIA Scripting code:

- Treat `delete()` and any bulk overwrite/import operation as destructive.
- Never call `delete()` as a bare one-line mutation. Wrap destructive changes in
  `project.start_transaction()` / `project.end_transaction()` when the API supports
  that operation inside a transaction.
- Ensure transaction cleanup is explicit. If generated code starts a transaction,
  it must end or roll back the transaction on every error path.
- Run or request a `compile_check` through MCP after generated block, tag,
  hardware, or HMI changes. Do not present generated project changes as deployable
  until that check passes.
- If Python TIA Scripting cannot provide transaction or exclusive-access safety for
  a destructive operation, route the task to C# Openness or MCP instead.
