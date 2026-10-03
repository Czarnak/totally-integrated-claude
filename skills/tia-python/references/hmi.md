# HMI Reference

V1.4.3 authority: Siemens manual sections 2.2 and 2.11-2.21, plus the
bundled `siemens_tia_scripting.pyi`.

## Scope boundary

The Python wrapper exposes one generic `Hmi` class. Siemens' V1.4.3 examples
branch on `hmi.get_hmi_type()` values such as `"Comfort"` and `"Unified"`, but
the wrapper does not expose the full C# Classic and Unified object models.
Describe this as wrapper-level HMI coverage, not complete HMI Openness coverage.
Route unsupported or model-specific engineering to `tia-hmi-operations`.

Select the exact HMI by confirmed name/identifier and type. Do not use the first
returned device.

## Hmi discovery, compile, and hardware

```text
project.get_hmis() -> List[ts.Hmi]

hmi.get_name() -> str
hmi.get_hmi_type() -> str
hmi.get_identifier() -> str
hmi.get_property(name: str) -> str
hmi.get_properties() -> List[str]
hmi.set_property(name: str, value: str) -> int
hmi.open_device_editor() -> None

hmi.compile_hardware() -> bool
hmi.compile_software() -> bool
hmi.upgrade_hardware(full_upgrade: bool) -> None
hmi.create_master_copy(
    library_folder_path: Optional[str] = None,
) -> ts.MasterCopy
```

HMI compile methods are deliberately different from PLC compile methods:
`True` means compile errors exist and `False` means no errors exist.

```python
has_errors = hmi.compile_software()
if has_errors:
    raise RuntimeError("HMI software compile reported errors; inspect TIA logs.")
```

Compiling, property writes, hardware upgrade, editor opening, and master-copy
creation are side-effecting. Require explicit mutation/UI authorization as
appropriate. `full_upgrade=True` may change device order number as well as
firmware.

## Retrieve HMI objects

```text
hmi.get_hmi_tag_tables(
    folder_path: Optional[str] = None,
) -> List[ts.HmiTagTable]
hmi.get_screens(
    folder_path: Optional[str] = None,
) -> List[ts.HmiScreen]
hmi.get_text_lists() -> List[ts.HmiTextList]
hmi.get_scripts(
    folder_path: Optional[str] = None,
) -> List[ts.HmiScript]
hmi.get_alarms() -> List[ts.HmiAlarm]
hmi.get_alarm_classes() -> List[ts.HmiAlarmClass]
hmi.get_connections() -> List[ts.HmiConnection]
hmi.get_cycles() -> List[ts.HmiCycle]
hmi.get_graphic_lists() -> List[ts.HmiGraphicList]
hmi.get_global_screen_elements() -> ts.HmiScreen
hmi.get_screen_overview() -> ts.HmiScreen
hmi.get_slide_in_screens(
    folder_path: Optional[str] = None,
) -> List[ts.HmiScreen]
```

Although the stub does not annotate optional returns for global elements or the
screen overview, the shipped examples check them before export. Do the same.

## HMI imports

All imports mutate the selected HMI. Preflight source content, select one exact
HMI and target folder, pass `import_options` explicitly, and require overwrite
authorization before `GeneralImportOptions.Override`.

### Directory-based imports

```text
hmi.import_hmi_tags(
    import_root_directory: str,
    target_folder_path: Optional[str] = None,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

hmi.import_connections(
    import_root_directory: str,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

hmi.import_cycles(
    import_root_directory: str,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

hmi.import_scripts(
    import_root_directory: str,
    target_folder_path: Optional[str] = None,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

hmi.import_text_lists(
    import_root_directory: str,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

hmi.import_graphic_lists(
    import_root_directory: str,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

hmi.import_screens(
    import_root_directory: str,
    target_folder_path: Optional[str] = None,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

hmi.import_popup_screens(
    import_root_directory: str,
    target_folder_path: Optional[str] = None,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

hmi.import_template_screens(
    import_root_directory: str,
    target_folder_path: Optional[str] = None,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

hmi.import_slidein_screens(
    import_root_directory: str,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None
```

### File-based imports

```text
hmi.import_global_elements(
    import_file: str,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None

hmi.import_screen_overview(
    import_file: str,
    import_options: Optional[ts.Enums.GeneralImportOptions] = None,
) -> None
```

Do not pass the parent directory to the two file-based methods. After imports,
compile the appropriate HMI target and treat `True` as failure.

## Export-capable HMI objects

These classes expose the common property and identifier methods plus the common
V1.4.3 export signature using `GeneralExportOptions` and
`GeneralExportFormats`:

- `HmiTagTable`
- `HmiTag`
- `HmiScreen`
- `HmiScript`
- `HmiConnection`
- `HmiCycle`
- `HmiGraphicList`
- `HmiTextList`

```text
obj.export(
    target_directory_path=r"C:\Engineering\hmi-export",
    export_options=ts.Enums.GeneralExportOptions.WithDefaults,
    export_format=ts.Enums.GeneralExportFormats.SimaticSD,
    keep_folder_structure=True,
) -> None
```

Supported formats vary by object and HMI type. Siemens' examples use
`SimaticSD` for selected Unified scripts, tag tables, and text lists; do not
generalize that example to every HMI object. Prefer a validated object/type
combination and preserve the exact export path.

## HMI object surface

### HmiTagTable, HmiTag, HmiScreen, and HmiScript

Each exposes:

```text
get_name() -> str
get_property(name: str) -> str
get_properties() -> List[str]
set_property(name: str, value: str) -> int
export(... GeneralExportOptions, GeneralExportFormats ...) -> None
get_identifier() -> str
create_master_copy(library_folder_path: Optional[str] = None) -> MasterCopy
```

`HmiTagTable` does not expose a `get_hmi_tags()` method in the supplied V1.4.3
stub. Do not invent table-to-tag traversal.

### HmiConnection, HmiCycle, HmiGraphicList, and HmiTextList

Each exposes name/property methods, `export(...)`, and `get_identifier()`.
These four classes do not expose `create_master_copy()` in the V1.4.3 stub.

### HmiAlarm and HmiAlarmClass

```text
alarm.get_name() -> str
alarm.get_property(name: str) -> str
alarm.get_properties() -> List[str]
alarm.set_property(name: str, value: str) -> int
alarm.get_identifier() -> str
```

`HmiAlarmClass` has the same surface. Neither class exposes `export()` or
`create_master_copy()` in V1.4.3.

## Safe HMI workflow

1. Identify one exact HMI by name, identifier, and `get_hmi_type()`.
2. Export or otherwise capture the current target state when the operation is
   reversible through that artifact.
3. Start a project transaction only if the specific wrapper operation supports
   it; a transaction is not proof of HMI-operation support.
4. Apply only the authorized import/property/master-copy/hardware change.
5. Compile and fail when the HMI compile method returns `True`.
6. Roll back on every exception path. Save only under separate explicit save
   authorization.
7. If the wrapper cannot provide the required exact selector, model-specific
   surface, rollback, or result evidence, route to guarded C# Openness.
