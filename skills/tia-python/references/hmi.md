# HMI Reference

Shared trait methods (`get_name`, `get_property`, `get_properties`, `set_property`,
`get_identifier`, `export`) are documented in SKILL.md.
Only unique methods are listed here.

---

## Hmi Device

Retrieved via `project.get_hmis()` → `List[Hmi]`

```python
hmis = project.get_hmis()
for hmi in hmis:
    print(hmi.get_name())
```

### Device Info

```python
hmi.get_hmi_type()   # → str  type of the HMI device
hmi.open_device_editor()
```

### Compile & Upgrade

```python
result = hmi.compile_hardware()         # → bool  True = errors present
result = hmi.compile_software()         # → bool  True = errors present
hmi.upgrade_hardware(full_upgrade=True) # full_upgrade=True changes order number too
```

### Retrieve HMI Sub-objects

Methods accepting `folder_path` use `"group1/group2"` syntax.

```python
hmi.get_hmi_tag_tables(folder_path=None)        # → List[HmiTagTable]
hmi.get_screens(folder_path=None)               # → List[HmiScreen]
hmi.get_slide_in_screens(folder_path=None)      # → List[HmiScreen]
hmi.get_scripts(folder_path=None)               # → List[HmiScript]
hmi.get_text_lists()                            # → List[HmiTextList]
hmi.get_alarms()                                # → List[HmiAlarm]
hmi.get_alarm_classes()                         # → List[HmiAlarmClass]
hmi.get_connections()                           # → List[HmiConnection]
hmi.get_cycles()                                # → List[HmiCycle]
hmi.get_graphic_lists()                         # → List[HmiGraphicList]
hmi.get_global_screen_elements()                # → HmiScreen
hmi.get_screen_overview()                       # → HmiScreen
```

### Import into HMI

All `import_*` take a directory path (folder of exported files).

```python
hmi.import_hmi_tags(
    import_root_directory="C:\\ws\\importfolder\\HMI_1\\Tags",
    target_folder_path=None   # Optional
)
hmi.import_connections(import_root_directory="C:\\ws\\importfolder\\HMI_1\\Connections")
hmi.import_cycles(import_root_directory="C:\\ws\\importfolder\\HMI_1\\Cycles")
hmi.import_scripts(
    import_root_directory="C:\\ws\\importfolder\\HMI_1\\Scripts",
    target_folder_path=None
)
hmi.import_text_lists(import_root_directory="C:\\ws\\importfolder\\HMI_1\\Text lists")
hmi.import_graphic_lists(import_root_directory="C:\\ws\\importfolder\\HMI_1\\Graphics")
hmi.import_screens(
    import_root_directory="C:\\ws\\importfolder\\HMI_1\\Screens",
    target_folder_path=None
)
hmi.import_popup_screens(
    import_root_directory="C:\\ws\\importfolder\\HMI_1\\PopUpScreens",
    target_folder_path=None
)
hmi.import_template_screens(
    import_root_directory="C:\\ws\\importfolder\\HMI_1\\TemplateScreens",
    target_folder_path=None
)
hmi.import_slidein_screens(import_root_directory="C:\\ws\\importfolder\\HMI_1\\SlideinScreens")

# These take a single FILE path, not a directory
hmi.import_global_elements(import_file="C:\\ws\\importfolder\\HMI_1\\GlobalElements.xml")
hmi.import_screen_overview(import_file="C:\\ws\\importfolder\\HMI_1\\ScreenOverview.xml")
```

---

## HmiTagTable

```python
# Has: get_name, get_property, get_properties, set_property, get_identifier, export
# No unique methods beyond shared traits
```

---

## HmiTag

```python
# Has: get_name, get_property, get_properties, set_property, get_identifier, export
# No unique methods beyond shared traits
```

---

## HmiScreen

Returned by `get_screens()`, `get_slide_in_screens()`, `get_global_screen_elements()`, `get_screen_overview()`.

```python
# Has: get_name, get_property, get_properties, set_property, get_identifier, export
# No unique methods beyond shared traits
```

---

## HmiScript

```python
# Has: get_name, get_property, get_properties, set_property, get_identifier, export
# No unique methods beyond shared traits
```

---

## HmiAlarm

```python
# Has: get_name, get_property, get_properties, set_property, get_identifier
# Note: HmiAlarm does NOT have an export() method
```

---

## HmiAlarmClass

```python
# Has: get_name, get_property, get_properties, set_property, get_identifier
# Note: HmiAlarmClass does NOT have an export() method
```

---

## HmiConnection

```python
# Has: get_name, get_property, get_properties, set_property, get_identifier, export
# export() uses the standard shared signature (see SKILL.md)
```

---

## HmiCycle

```python
# Has: get_name, get_property, get_properties, set_property, get_identifier, export
# No unique methods beyond shared traits
```

---

## HmiTextList

```python
# Has: get_name, get_property, get_properties, set_property, get_identifier, export
# No unique methods beyond shared traits
```

---

## HmiGraphicList

```python
# Has: get_name, get_property, get_properties, set_property, get_identifier, export
# No unique methods beyond shared traits
```
