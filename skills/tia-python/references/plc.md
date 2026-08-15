# PLC Reference

V1.4.3 authority: Siemens manual sections 2.4, 2.10, and 2.27-2.41,
plus the bundled `siemens_tia_scripting.pyi`.

## Live-operation boundary

The following calls communicate with or change connection state for a real or
simulated PLC and require explicit live-operation authorization:

- `get_online_state()`, `go_online()`, `go_offline()`
- `compare_to_online()`
- `download()`
- Any workflow that derives a target from online discovery

Before a live call, confirm the exact PLC and exact target values with the user:

```python
pc_interface_type = "PN/IE"
pc_interface_name = "Approved interface name"
target_interface = "Approved target interface or address"
```

Do not select `project.get_plcs()[0]`, the first accessible interface, or a
discovered address. Read-only offline enumeration is not evidence that the live
target is correct.

## PLC discovery and offline objects

```text
project.get_plcs() -> List[ts.Plc]

plc.get_name() -> str
plc.get_plc_tag_tables(
    folder_path: Optional[str] = None,
) -> List[ts.PlcTagTable]
plc.get_program_blocks(
    folder_path: Optional[str] = None,
) -> List[ts.ProgramBlock]
plc.get_system_blocks() -> List[ts.SystemBlock]
plc.get_user_data_types(
    folder_path: Optional[str] = None,
) -> List[ts.UserDataType]
plc.get_external_sources(
    folder_path: Optional[str] = None,
) -> List[ts.ExternalSource]
plc.get_force_tables() -> List[ts.ForceTable]
plc.get_watch_tables(
    folder_path: Optional[str] = None,
) -> List[ts.WatchTable]
plc.get_technology_objects(
    folder_path: Optional[str] = None,
) -> List[ts.TechnologyObject]
plc.get_software_units() -> List[ts.SoftwareUnit]
plc.get_safety_administration() -> ts.SafetyAdministration
```

Use `folder_path="group1/group2"` only when that exact offline group is part of
the request. Match PLCs by a user-confirmed name or identifier and reject zero
or multiple matches.

## Online state and download

```text
plc.get_online_state() -> str
plc.go_offline() -> None
plc.go_online(
    pc_interface_type: str,
    pc_interface_name: str,
    target_interface: str,
) -> str

plc.download(
    pc_interface_type: str,
    pc_interface_name: str,
    target_interface: str,
) -> ts.ExecutionResult
```

`download()` uses the PLC's current `DownloadConfig`. Retrieve, print/review,
and explicitly set that configuration before download when defaults are not
acceptable:

```python
download_config = plc.get_download_configuration()
download_config.print_config()

# Configure only already authorized selections, then require a final target
# confirmation before calling plc.download(...).
result = plc.download(
    pc_interface_type=pc_interface_type,
    pc_interface_name=pc_interface_name,
    target_interface=target_interface,
)
if result.get_errors():
    raise RuntimeError("PLC download failed: " + " | ".join(result.get_errors()))
```

Never treat a nonempty status string or an empty console log as proof of a
successful download. Preserve `get_result_state()`, errors, warnings, and
information in the workflow evidence.

### DownloadConfig

```text
plc.get_download_configuration() -> ts.DownloadConfig
```

The V1.4.3 configuration methods are:

```text
set_download_options(options: Enums.GeneralDownloadOptions)
set_check_before_download(value: Optional[bool] = None)
set_upgrade_target_device(value: Optional[bool] = None)
set_turn_off_sequence(value: Optional[bool] = None)
set_overwrite_target_languages(value: Optional[bool] = None)
set_downgrade_target_device(value: Optional[bool] = None)
set_load_identification_data_selection(value: Optional[bool] = None)
set_start_modules_selection(value: Optional[bool] = None)
set_stop_modules_selection(value: Optional[bool] = None)
set_overwrite_system_data_selection(value: Optional[bool] = None)
set_protection_level_changed_selection(value: Optional[bool] = None)
set_active_test_can_be_aborted_selection(value: Optional[bool] = None)
set_reset_module_selection(value: Optional[bool] = None)
set_different_target_configuration_selection(value: Optional[bool] = None)
set_initialize_memory_selection(value: Optional[bool] = None)
set_expand_download_selection(value: Optional[bool] = None)
set_active_test_can_prevent_download_selection(value: Optional[bool] = None)
set_target_for_software_selection(value: Optional[bool] = None)
set_user_management_pre_download_selections(value: Optional[bool] = None)
set_module_read_access_password(password: str)
set_module_write_access_password(password: str)
set_block_binding_password(password: str)
set_consistent_blocks_download_selection(value: Optional[bool] = None)
set_all_blocks_download_selection(value: Optional[bool] = None)
set_data_block_reinitialization_selection(value: Optional[bool] = None)
set_plc_master_secret_password(password: str)
set_over_write_hmi_data(value: Optional[bool] = None)
set_fit_hmi_components(value: Optional[bool] = None)
set_alarm_text_libraries_download_selection(value: Optional[bool] = None)
set_start_backup_modules_selection(value: Optional[bool] = None)
set_stop_hsystem_selection(value: Optional[bool] = None)
set_stop_hsystem_or_module_selection(value: Optional[bool] = None)
set_switch_backup_to_primary_selection(value: Optional[bool] = None)
set_wait_on_reboot_selection(value: Optional[bool] = None)
print_config()
```

Do not set passwords or master secrets unless that specific protected target and
credential use were authorized. Obtain secrets through the approved secret
provider and never print them with the configuration.

`download_to_memory_card(download_directory: str,
is_plcsim_advanced: Optional[bool] = None) -> str` writes an external target
directory and also requires an exact, authorized destination. PLCSIM Advanced
support is documented only for V19 and later.

## Compilation and hardware operations

```text
plc.compile_hardware() -> ts.ExecutionResult
plc.compile_software() -> ts.ExecutionResult
plc.update_module_description() -> bool
plc.upgrade_hardware(full_upgrade: bool) -> None
plc.open_device_editor() -> None
```

Compilation is not a boolean in V1.4.3. Gate on `ExecutionResult.get_errors()`.
Hardware upgrade and module-description update are mutations. `full_upgrade=True`
may change order numbers as well as firmware and requires explicit authorization.
Opening the editor is a UI side effect.

## PLC imports

The V1.4.3 manual and stub expose these directory-based imports:

```text
plc.import_blocks(
    import_root_directory: str,
    target_folder_path: Optional[str] = None,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

plc.import_plc_tags(
    import_root_directory: str,
    target_folder_path: Optional[str] = None,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

plc.import_data_types(
    import_root_directory: str,
    target_folder_path: Optional[str] = None,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

plc.import_technology_objects(
    import_root_directory: str,
    target_folder_path: Optional[str] = None,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

plc.import_watch_tables(
    import_root_directory: str,
    target_folder_path: Optional[str] = None,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None
```

The default import option documented by Siemens is `GeneralImportOptions.Override`.
Therefore generated code must pass the intended `import_options` explicitly,
preflight the source directory, resolve the exact target folder, and require
overwrite authorization before using `Override`. The V1.4.3 public stub does not
expose a separate `import_external_sources()` method.

## CFC charts

```text
plc.export_cfc_charts(
    export_file_path: str,
    model_version: str,
    filter: Optional[int] = None,
    unattended: Optional[bool] = None,
) -> None

plc.import_cfc_charts(
    import_file_path: str,
    model_version: str,
    filter: Optional[int] = None,
    unattended: Optional[bool] = None,
    delete_at_target: Optional[bool] = None,
) -> None
```

These calls use a file path, not an import directory. Siemens documents
`delete_at_target` as defaulting to `True`; explicitly pass `False` unless target
deletion has been separately authorized. Confirm the S7TIA exchange
`model_version` (for example, `"V2.0"`) with the source artifact.

## ExecutionResult

```text
result.get_result_state() -> int
result.get_all_messages() -> List[str]
result.get_warnings() -> List[str]
result.get_errors() -> List[str]
result.get_information() -> List[str]
result.print_result() -> None
```

Siemens documents result state as Success, Warning, or Error but does not publish
numeric mappings in the V1.4.3 manual. Prefer the categorized message methods to
inventing integer meanings. `print_result()` is diagnostic output, not a
machine-verifiable success gate.

## PLC data objects

Several exportable PLC objects (`ForceTable`, `WatchTable`, `PlcTagTable`,
`ProgramBlock`, `SystemBlock`, `UserDataType`, and `TechnologyObject`) expose
these shared V1.4.3 methods where applicable:

```text
get_path() -> str
get_path_full() -> str
get_fingerprints() -> List[Tuple[str, str]]
get_supported_export_format() -> List[str]
get_identifier() -> str
get_properties() -> List[str]
set_property(name: str, value: str) -> int
```

The V1.4.3 signature line omits a return annotation, while its bundled docstring
and the manual document `List[str]`. Use the runtime list as capability evidence
and do not invent support for an unreported format. Fingerprints are pairs in
the shipped stub, not a flat list of strings.

### ProgramBlock, SystemBlock, UserDataType, and TechnologyObject

All four expose common name/property/export/path/fingerprint/identifier methods,
`compile() -> ExecutionResult`, `is_consistent() -> bool`,
`export_cross_references(target_directory_path: str, filter: int)`, deletion,
and `create_master_copy(library_folder_path: Optional[str] = None)`.

Additional methods:

```text
program_block.show_in_editor() -> None
program_block.get_type_version_guid() -> str
program_block.get_type_guid() -> str
program_block.is_library_type() -> bool
program_block.set_know_how_protection(password: str) -> None
program_block.remove_know_how_protection(password: str) -> None

system_block.show_in_editor() -> None

user_data_type.get_type_version_guid() -> str
user_data_type.get_type_guid() -> str
user_data_type.is_library_type() -> bool
```

Cross-reference filter values documented by Siemens are `1=AllObjects`,
`2=ObjectsWithReferences`, `3=ObjectsWithoutReferences`, and `4=UnusedObjects`.
Know-how protection changes require specific authorization and secret-safe input.

### PlcTagTable, PlcTag, UserConstant, and SystemConstant

```text
table.get_plc_tags() -> List[ts.PlcTag]
table.get_user_constants() -> List[ts.UserConstant]
table.get_system_constants() -> List[ts.SystemConstant]
table.show_in_editor() -> None
table.create_master_copy(
    library_folder_path: Optional[str] = None,
) -> ts.MasterCopy

plc_tag.export_cross_references(target_directory_path: str, filter: int) -> None
system_constant.export_cross_references(
    target_directory_path: str,
    filter: int,
) -> None
user_constant.export_cross_references(
    target_directory_path: str,
    filter: int,
) -> None
```

Tag tables and PLC tags also support export and deletion. `PlcTag` supports
`create_master_copy`; `UserConstant` and `SystemConstant` do not expose it in
the shipped V1.4.3 stub.

### ExternalSource, ForceTable, WatchTable, and NamedValueType

```text
external_source.block_gen() -> None

force_table.is_consistent() -> bool
force_table.show_in_editor() -> None

watch_table.is_consistent() -> bool
watch_table.show_in_editor() -> None

named_value_type.get_namespace() -> str
named_value_type.export(
    target_directory_path: str,
    keep_folder_structure: Optional[bool] = None,
) -> None
```

`block_gen()` creates PLC blocks and is a mutation. Force/watch-table exports
use `GeneralExportOptions` and `GeneralExportFormats`.

## SoftwareUnit

```text
plc.create_software_unit(name: str) -> ts.SoftwareUnit

software_unit.compile() -> ts.ExecutionResult
software_unit.export_configuration(export_file_path: str) -> None
software_unit.import_configuration(import_file_path: str) -> None
software_unit.get_plc_tag_tables() -> List[ts.PlcTagTable]
software_unit.get_program_blocks() -> List[ts.ProgramBlock]
software_unit.get_system_blocks() -> List[ts.SystemBlock]
software_unit.get_user_data_types() -> List[ts.UserDataType]
software_unit.get_external_sources() -> List[ts.ExternalSource]
software_unit.get_named_value_types() -> List[ts.NamedValueType]
software_unit.import_blocks(
    import_root_directory: str,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None
software_unit.import_plc_tags(
    import_root_directory: str,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None
software_unit.import_data_types(
    import_root_directory: str,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None
software_unit.export_cross_references(
    target_directory_path: str,
    filter: int,
) -> None
software_unit.create_master_copy(
    library_folder_path: Optional[str] = None,
) -> ts.MasterCopy
```

Software-unit imports are flat with respect to the wrapper signature: there is
no `target_folder_path` parameter. V1.4.0 fixed continuation after one block
import fails, but callers still need independent post-import verification.

## SafetyAdministration

```text
safety.is_logged_on() -> bool
safety.is_password_set() -> bool
safety.get_offline_serial_number() -> str
safety.export_config(target_directory_path: str) -> None
safety.import_config(import_root_directory: str) -> None
safety.login_to_safety(password: str) -> None
```

`login_to_safety` was added in V1.3.1. Safety login and configuration import are
privileged mutations. Require explicit authorization, use an approved secret
provider, and never record the password. Safety export creates a
`SafetyAdministration` subdirectory according to Siemens documentation.

## Other PLC mutations

```text
plc.create_software_unit(name: str) -> ts.SoftwareUnit
plc.safety_print(print_file: str) -> bool
plc.create_master_copy(
    library_folder_path: Optional[str] = None,
) -> ts.MasterCopy
```

`safety_print` overwrites an existing file according to the manual. Resolve the
exact output and require overwrite authorization before calling it. Master-copy
creation, software-unit creation, property writes, deletion, protection changes,
imports, generation, and upgrade all require an authorized transaction where
supported, plus post-operation compile/result checks.
