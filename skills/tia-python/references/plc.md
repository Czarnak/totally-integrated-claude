# PLC Reference

Shared trait methods (`get_name`, `get_property`, `get_properties`, `set_property`,
`get_identifier`, `export`, `delete`, `get_path`, `get_path_full`, `get_fingerprints`,
`get_supported_export_format`, `show_in_editor`, `is_consistent`) are documented in SKILL.md.
Only unique methods are listed here.

---

## Plc Device

Retrieved via `project.get_plcs()` → `List[Plc]`

```python
plcs = project.get_plcs()
for plc in plcs:
    print(plc.get_name())
```

### Online / Offline

```python
plc.get_online_state()          # → str  current online state
plc.go_offline()
plc.go_online(
    mode="PN/IE",
    pci_interface="PLCSIM",
    ip_address="192.168.0.10"
)                               # → str  online status
plc.compare_to_online()         # → bool  False = identical, True = differences exist
```

### Download

```python
result = plc.download(
    mode="PN/IE",
    pci_interface="PLCSIM",
    ip_address="192.168.0.10"
)  # → str

result = plc.download_to_memory_card(
    download_directory="E:\\",
    is_plcsim_advanced=True     # Optional: default False
)  # → str
```

### Compile

```python
result = plc.compile_hardware()   # → bool  True = errors present
result = plc.compile_software()   # → bool  True = errors present
```

### Hardware

```python
plc.open_device_editor()
plc.upgrade_hardware(full_upgrade=True)
plc.update_module_description()   # → bool
```

### Safety

```python
sa = plc.get_safety_administration()   # → SafetyAdministration
plc.safety_print(print_file="C:\\ws\\safetyprint\\F_PLC_Printout.pdf")  # → bool
```

### Retrieve PLC Sub-objects

All `get_*` methods accept optional `folder_path: str` (e.g. `"group1/group2"`) to scope retrieval.

```python
plc.get_program_blocks(folder_path=None)         # → List[ProgramBlock]
plc.get_system_blocks()                          # → List[SystemBlock]
plc.get_user_data_types(folder_path=None)        # → List[UserDataType]
plc.get_external_sources(folder_path=None)       # → List[ExternalSource]
plc.get_force_tables()                           # → List[ForceTable]
plc.get_watch_tables(folder_path=None)           # → List[WatchTable]
plc.get_technology_objects(folder_path=None)     # → List[TechnologyObject]
plc.get_software_units()                         # → List[SoftwareUnit]
plc.get_plc_tag_tables(folder_path=None)         # → List[PlcTagTable]
```

### Import into PLC

All `import_*` take a directory path (folder of exported XML files). `target_folder_path` is optional.

```python
plc.import_blocks(
    import_root_directory="C:\\ws\\importfolder\\PLC_1\\Program blocks",
    target_folder_path=None
)
plc.import_plc_tags(import_root_directory="C:\\ws\\importfolder\\PLC_1\\PLC tags")
plc.import_data_types(import_root_directory="C:\\ws\\importfolder\\PLC_1\\PLC data types")
plc.import_technology_objects(import_root_directory="C:\\ws\\importfolder\\PLC_1\\Technology objects")
plc.import_watch_tables(import_root_directory="C:\\ws\\importfolder\\PLC_1\\Watch and force tables")
```

### Software Units

```python
plc.create_software_unit(name="Unit 1")
```

---

## ProgramBlock

```python
block.compile()
block.is_consistent()                  # → bool
block.show_in_editor()
block.get_type_version_guid()          # → str  GUID of library type version (if instance)
block.get_type_guid()                  # → str  GUID of library type (if instance)
block.is_library_type()                # → bool
block.set_know_how_protection(password="Password!123")
block.remove_know_how_protection(password="Password!123")
block.export_cross_references(
    target_directory_path="C:\\ws\\exportcrossreferences",
    filter=2   # 1=AllObjects, 2=ObjectsWithReferences, 3=ObjectsWithoutReferences, 4=UnusedObjects
)
```

---

## SystemBlock

Same as ProgramBlock but without know-how protection methods.

```python
block.compile()
block.is_consistent()
block.show_in_editor()
block.export_cross_references(target_directory_path="C:\\ws\\exportcrossreferences", filter=2)
```

---

## UserDataType (UDT)

```python
udt.compile()
udt.is_consistent()
udt.get_type_version_guid()   # → str
udt.get_type_guid()           # → str
udt.is_library_type()         # → bool
udt.export_cross_references(target_directory_path="C:\\ws\\exportcrossreferences", filter=2)
```

---

## PlcTagTable

```python
table.get_plc_tags()        # → List[PlcTag]
table.get_user_constants()  # → List[UserConstant]
table.show_in_editor()
table.export_cross_references(target_directory_path="C:\\ws\\exportcrossreferences", filter=2)
# filter enum: 1=AllObjects, 2=ObjectsWithReferences, 3=ObjectsWithoutReferences, 4=UnusedObjects
```

---

## PlcTag

Has: `get_name`, `get_property`, `get_properties`, `set_property`, `get_identifier`,
`export`, `delete`, `get_supported_export_format`

No unique methods beyond shared traits.

---

## UserConstant

Has: `get_name`, `get_property`, `get_properties`, `set_property`, `get_identifier`,
`export`, `delete`, `get_supported_export_format`

No unique methods beyond shared traits.

---

## ExternalSource

```python
ext_source.block_gen()   # Generate blocks from the external source file
```

---

## ForceTable

```python
force_table.is_consistent()   # → bool
force_table.show_in_editor()
```

---

## WatchTable

```python
watch_table.is_consistent()   # → bool
watch_table.show_in_editor()
```

---

## TechnologyObject

```python
to.compile()
to.is_consistent()
```

---

## SoftwareUnit

A self-contained unit within a PLC. Has its own sub-objects.

```python
su.compile()
su.export_configuration(export_file_path="C:\\ws\\export\\config.xml")
su.import_configuration(import_file_path="C:\\ws\\export\\config.xml")

# Sub-object retrieval (no folder_path parameter — flat access)
su.get_plc_tag_tables()     # → List[PlcTagTable]
su.get_program_blocks()     # → List[ProgramBlock]
su.get_system_blocks()      # → List[SystemBlock]
su.get_user_data_types()    # → List[UserDataType]
su.get_external_sources()   # → List[ExternalSource]
su.get_named_value_types()  # → List[NamedValueType]

# Import into SoftwareUnit (no target_folder_path parameter)
su.import_blocks(import_root_directory="C:\\ws\\importfolder\\PLC_1\\Program blocks")
su.import_plc_tags(import_root_directory="C:\\ws\\importfolder\\PLC_1\\PLC tags")
su.import_data_types(import_root_directory="C:\\ws\\importfolder\\PLC_1\\PLC data types")

su.export_cross_references(target_directory_path="C:\\ws\\exportcrossreferences", filter=2)
```

---

## SafetyAdministration

```python
sa.is_logged_on()              # → bool
sa.is_password_set()           # → bool
sa.get_offline_serial_number() # → str
sa.export_config(target_directory_path="C:\\ws\\export")
# Note: creates "SafetyAdministration" subfolder automatically
sa.import_config(import_root_directory="C:\\ws\\exported\\SafetyAdministration")
```

---

## NamedValueType (NVT)

```python
nvt.get_name()       # → str
nvt.get_namespace()  # → str
nvt.export(
    target_directory_path="C:\\ws\\export",
    keep_folder_structure=None   # Optional bool
)
```
