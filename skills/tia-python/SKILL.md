---
name: tia-python
description: Reference for Siemens TIA Scripting Python V1.4.3. Load only when the user explicitly chooses Python TIA Scripting or the TIA roadmap routes to it.
license: MIT
---

# TIA Scripting Python V1.4.3

Library: `siemens_tia_scripting` (v1.4.3)

Use this skill for the Siemens-supplied Python wrapper around TIA Portal
Openness. It is a reference-routed skill: do not select Python merely because a
task mentions TIA Portal. If the implementation route is not already explicit,
start with `tia-openness-roadmap`.

## Evidence and qualification boundary

This package is aligned to the supplied Siemens V1.4.3 artifacts:

- English manual `109742322_TIA_Scripting_Python_DOC_V143_en.pdf`, entry ID
  109742322, dated 06/2026.
- The `siemens_tia_scripting.pyi` stub bundled identically in the CPython 3.12,
  3.13, and 3.14 wheels.
- Siemens package metadata, changelog, and example workflows distributed with
  V1.4.3.

The manual and stub are the authority for public names and signatures. The
changelog is the authority for version-to-version behavior notes. Static package
inspection does not prove import success, installed products, licensing, live
portal behavior, or project mutation on a particular engineering station.

### Supported environment

- Python 3.12.x, 3.13.x, or 3.14.x only, using the matching Windows x64 wheel.
- The V1.4.3 manual states TIA Portal V15.1 or newer and TIA Portal Openness
  V15.1 or newer.
- Siemens `manifest.json` lists V18-V21, while the delivered package contains
  adapter assemblies from V15.1 through V21.1. Treat this as mixed Siemens
  compatibility metadata: verify the exact installed Portal and update before
  promising runtime support.
- The Windows user must belong to the `Siemens TIA Openness` group. The first
  connection can display the Siemens Openness security prompt.

## Installation

Do not install an unrelated package from PyPI. Use a wheel from the Siemens
download or use the extracted-file import method.

### Siemens wheel

Choose the wheel whose CPython tag matches the interpreter:

```powershell
py -3.12 -m pip install .\install\siemens_tia_scripting-1.4.3-cp312-cp312-win_amd64.whl
py -3.13 -m pip install .\install\siemens_tia_scripting-1.4.3-cp313-cp313-win_amd64.whl
py -3.14 -m pip install .\install\siemens_tia_scripting-1.4.3-cp314-cp314-win_amd64.whl
```

Install only the wheel matching the interpreter. Siemens documents IntelliSense
support through this package-install path with Pylance; other language servers
are not qualified in the V1.4.3 manual.

### Extracted-file import

Set `TIA_SCRIPTING` to the extracted directory that contains
`siemens_tia_scripting.pyd` and its Siemens adapter DLLs. Use the environment
path only as a fallback when the wheel is not installed:

```python
import importlib
import os
import sys
from pathlib import Path

try:
    ts = importlib.import_module("siemens_tia_scripting")
except ImportError as first_error:
    scripting_dir = os.environ.get("TIA_SCRIPTING")
    if not scripting_dir:
        raise RuntimeError(
            "Install the matching Siemens wheel or set TIA_SCRIPTING."
        ) from first_error

    resolved_dir = Path(scripting_dir).expanduser().resolve()
    if not (resolved_dir / "siemens_tia_scripting.pyd").is_file():
        raise RuntimeError(
            "TIA_SCRIPTING must contain siemens_tia_scripting.pyd."
        ) from first_error

    sys.path.insert(0, str(resolved_dir))
    ts = importlib.import_module("siemens_tia_scripting")
```

Do not copy the shipped examples' lifecycle and error handling verbatim. They
are useful API-shape examples, but some V1.4.3 examples contain stale Python
3.12-only comments and do not reliably close or detach portal instances.

## Public object model

```text
siemens_tia_scripting
|-- Enums and 10 global functions
|-- ProductBundle -> Product
`-- Portal
    |-- Project
    |   |-- Device -> Module
    |   |-- Plc
    |   |   |-- DownloadConfig
    |   |   |-- ExecutionResult
    |   |   |-- ProgramBlock / SystemBlock / UserDataType
    |   |   |-- PlcTagTable -> PlcTag / UserConstant / SystemConstant
    |   |   |-- ExternalSource / ForceTable / WatchTable
    |   |   |-- TechnologyObject / SafetyAdministration
    |   |   `-- SoftwareUnit -> NamedValueType and PLC data objects
    |   |-- Hmi
    |   |   |-- HmiTagTable / HmiTag / HmiScreen / HmiScript
    |   |   `-- HmiAlarm / HmiAlarmClass / HmiConnection / HmiCycle
    |   |       / HmiGraphicList / HmiTextList
    |   |-- ProjectLibrary -> MasterCopy / LibraryType -> LibraryTypeVersion
    |   `-- ApplicationTest / RuleSet / SystemTest
    |-- ProjectServer
    `-- GlobalLibraryInfo / GlobalLibrary
        `-- LibraryType -> LibraryTypeVersion
```

The V1.4.3 stub contains 10 global functions and 45 public classes. Load the
domain reference files below instead of expanding this entrypoint with every
method.

## Cross-cutting contracts

### Properties

The V1.4.3 manual and stub annotate `get_property(name: str) -> str` and say
non-string values are converted to strings where possible. The V1.3.0 changelog
instead says property values are returned as their original boolean or numeric
type. Because the supplied authorities conflict, generated code must not assume
one representation:

```python
value = obj.get_property(name="CreationDate")
if isinstance(value, bool):
    normalized = value
elif isinstance(value, str):
    normalized = value.strip()
else:
    normalized = value
```

`set_property(name: str, value: str) -> int` still requires a string value.
Pass booleans, numbers, and enums as their documented string representation.

### Export and import

The common V1.4.3 export signature is:

```python
obj.export(
    target_directory_path=r"C:\Engineering\export",
    export_options=ts.Enums.GeneralExportOptions.WithDefaults,
    export_format=ts.Enums.GeneralExportFormats.SimaticML,
    keep_folder_structure=True,
)
```

Most V1.4.3 import methods accept
`import_options: Optional[Enums.GeneralImportOptions]`. PLC/HMI bulk imports use
an import root directory; explicitly named project-text, CFC, CAx, global-screen,
screen-overview, configuration, and password-policy operations use file paths.
Check the domain reference before choosing a path shape.

### Compile and execution results

- `Device.compile()`, `Module.compile()`, PLC compile methods, block/UDT/
  technology-object compile methods, and `SoftwareUnit.compile()` return
  `ExecutionResult`.
- `ExecutionResult` exposes `get_result_state()`, `get_all_messages()`,
  `get_warnings()`, `get_errors()`, `get_information()`, and `print_result()`.
- `Hmi.compile_hardware()` and `Hmi.compile_software()` remain the exception:
  they return `True` when errors exist and `False` when no errors exist.
- The V1.3.0 changelog calls its breaking result change an "ExecutionReport"
  object, but the delivered V1.4.3 manual and stub expose the callable class as
  `ExecutionResult`. Use `ExecutionResult` in code.

Do not discard result objects or rely only on console logging:

```python
result = plc.compile_software()
errors = result.get_errors()
if errors:
    raise RuntimeError("PLC compile failed: " + " | ".join(errors))
```

## Exact V1.4.3 enums

```text
PortalMode: WithGraphicalUserInterface=0, WithoutGraphicalUserInterface=1,
            AnyUserInterface=2
UmacUserMode: Project=0, Global=1
GeneralExportFormats: SimaticML=0, ExternalSource=1, SimaticSD=2
GeneralExportOptions: WithDefaults=0, Nan=1, WithReadOnly=2
LibraryCleanUpMode: PreserveDefaultVersionOfUnusedTypes=0, DeleteUnusedTypes=1
LibraryExportOptions: Nan=0, WithLibraryVersionInfoFile=1,
                      OnlyLibraryVersionInfoFile=2
LibraryHarmonizeOptions: HarmonizePathsAndNames=0, HarmonizePaths=1,
                         HarmonizeNames=2
LibraryDependenciesMode: DoNotAutomaticallyCreateOrReleaseDependencies=0,
                         AutomaticallyCreateOrReleaseDependenciesIfRequired=1
GeneralDownloadOptions: Hardware=0, Software=1, HardwareAndSoftware=2,
                        SoftwareOnlyChanges=3,
                        HardwareAndSoftwareOnlyChanges=4
TestSuiteTestCaseImportOptions: Nan=0, IgnoreInvalidObject=1
TestSuiteRuleSetImportOptions: Nan=0, IgnorePropertyErrors=1,
                               IgnoreMissingAttributes=2, SkipInvalidObjects=3,
                               IgnoreErrorsAndAttributes=4
GeneralImportOptions: Nan=0, Override=1, SkipInactiveCultures=2,
                      ActivateInactiveCultures=3
ConsoleLogLevel: All=0, Info=1, Warning=2, Error=3
```

## Logging

Configure file/console logging before opening or attaching TIA Portal, and set
the console level separately when required:

```python
ts.set_logging(path=r"C:\Engineering\logs\tia-scripting.log", console=True)
ts.set_log_level(log_level=ts.Enums.ConsoleLogLevel.Info)
```

## Reference routing

Load every reference needed by a cross-domain workflow before generating code.

| Reference | Load for |
| --- | --- |
| `skills/tia-python/references/global_portal.md` | Global functions, portal lifecycle, credentials, products, devices, and modules |
| `skills/tia-python/references/plc.md` | PLC online/download, compilation, imports/exports, CFC, Safety, software units, and PLC data objects |
| `skills/tia-python/references/hmi.md` | Generic wrapper HMI discovery, compile, import/export, and HMI object classes |
| `skills/tia-python/references/library.md` | Global/project libraries, master copies, types, and versions |
| `skills/tia-python/references/project.md` | Project lifecycle, transactions, project texts, CAx, project servers, and Test Suite |

## Destructive-operation safety and authority rules

These rules are mandatory for generated TIA Scripting Python:

1. Treat project/library creation, import, property writes, master-copy
   instantiation, protection changes, `delete()` and other deletion calls, save,
   archive, compile-triggered generation, and hardware upgrade as mutations.
   Require explicit mutation authorization and exact selectors.
2. Require explicit live-operation authorization before `go_online()`,
   `go_offline()`, `download()`, online comparison, online fingerprints, or any
   operation that communicates with a PLC. Confirm the exact target using
   `pc_interface_type`, `pc_interface_name`, and `target_interface`; never infer
   a target from the first device or first accessible interface.
3. Inspect every `ExecutionResult` and stop on errors. For HMI compile calls,
   remember that `True` means errors exist.
4. After generated block, tag, hardware, or HMI changes, run or request a
   `compile_check` through MCP. Do not present the project change as deployable
   until that check passes.
5. Do not save, archive, commit a server session, close a portal, delete, or
   overwrite existing content unless that exact action was authorized.
6. Use `project.start_transaction()` / `project.end_transaction()` only around
   already authorized mutations supported by the transaction, and roll back on
   every exception path:

```python
transaction_open = False
try:
    project.start_transaction(
        undo_text="Authorized TIA change",
        dialog_text="Applying reviewed Python changes",
    )
    transaction_open = True
    # Perform only the already authorized mutation here.
    project.end_transaction(rollback=False)
    transaction_open = False
except Exception:
    if transaction_open:
        project.end_transaction(rollback=True)
    raise
```

7. A transaction does not make an unsupported operation safe. If the wrapper or
   target object cannot provide the required exclusive-access, rollback, exact
   selection, or result evidence, route the task to C# Openness or MCP through a
   guarded workflow.
8. Do not hardcode, print, or commit UMAC, Safety, know-how, module-access, or
   PLC master-secret credentials. Read them from the user's approved secret
   mechanism and pass them only to the exact authorized call.
9. When this script attached to a user-owned portal, use `portal.detach()` in
   cleanup. Call `portal.close_portal()` only for an instance the script owns and
   only after the project disposition has been explicitly decided.

## General coding guidance

- Prefer keyword arguments; V1.4.0 added positional and keyword handling, but
  keyword calls preserve intent across similar string parameters.
- Check optional returns before dereferencing them. V1.4.3 specifically fixes a
  null-reference defect involving optional parameters, but callers still need to
  handle absent TIA objects and values.
- Preserve Unicode paths, names, and text. V1.4.0 added non-ASCII handling.
- Scope retrieval with `folder_path` when the exact group is known.
- Never use collection position such as `plcs[0]` as an engineering selector.
- Keep PLC, HMI, project, library, and live-operation functions separate so each
  authority boundary can be reviewed independently.
