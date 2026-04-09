# Project & ProjectServer Reference

---

## Project

Retrieved via `portal.get_project()` or returned by project-open methods.

### Basic Operations

```python
project.save()
project.close()          # WARNING: unsaved changes are permanently lost
project.delete()         # Deletes the project from disk
project.get_portal()     # → Portal  get the portal instance for this project
project.is_session()     # → bool  True if this is a local server session
```

### Save / Archive

```python
# Save under a different name/path
path = project.save_as(
    target_directory_path="C:\\ws\\newfolder",
    project_name="testproj"
)  # → str  full path of saved project

# Archive project
archive_path = project.archive(
    target_directory_path="C:\\ws\\newfolder",
    archive_name="testproj",
    delete_existing_archive=True
)  # → str  full path of archive
```

### Hardware & Simulation

```python
project.upgrade_hardware(full_upgrade=True)
project.update_module_description()
project.set_simulation_support(value=True)
project.set_virtual_plc_support(value=True)   # V19+ only
project.web_block_generate()                   # Web server must be activated
project.sivarc_generate()                      # SiVArc must be installed and licensed
```

### Editors

```python
project.open_topology_editor()
project.open_network_editor()
```

### Get Devices

```python
plcs = project.get_plcs()    # → List[Plc]
hmis = project.get_hmis()    # → List[Hmi]
```

### Project Library

```python
project_lib = project.get_project_library()   # → ProjectLibrary
```

### CAx Data

```python
result = project.export_cax_data(
    export_file_path="C:\\ws\\exportfolder\\exportCAX.aml",
    log_file_path="C:\\ws\\exportfolder\\exportCAX.log"
)  # → bool

result = project.import_cax_data(
    import_file_path="C:\\ws\\importfolder\\importCAX.aml",
    log_file_path="C:\\ws\\importfolder\\importCAX.log"
)  # → bool
```

### UMAC & Password Policies

```python
project.import_umac_config(
    import_file_path="C:\\ws\\importfolder\\importUMAC.json",
    secret_env_name="MYSECRETENV"   # Optional if not encrypted
)
project.export_umac_config(export_file_path="C:\\ws\\exportfolder\\exportUMAC.json")
project.import_password_policy(import_file_path="C:\\ws\\importfolder\\PWPolicy.json")
project.export_password_policy(export_file_path="C:\\ws\\exportfolder\\exportPWPolicy.json")
```

### Transactions (Exclusive Access)

Use transactions when making bulk changes that should be atomic and undoable.

```python
project.start_transaction(
    undo_text="MyUndoDescription",
    dialog_text="MyExclusiveAccess"
)
# ... make changes ...
project.update_transaction(dialog_text="MyNewExclusiveAccess")  # Update dialog text mid-transaction
project.end_transaction(rollback=False)  # rollback=True to revert all changes
```

### Server Sessions

```python
# Commit changes and close the session
rev_number = project.commit_and_close(commit_message="MyCommitMessage")  # → int
```

### Test Suite

Requires Test Suite Advanced installed and licensed.

```python
tests     = project.get_application_tests()  # → List[ApplicationTest]
sys_tests = project.get_system_tests()       # → List[SystemTest]
rule_sets = project.get_rule_sets()          # → List[RuleSet]
```

### Shared Traits

Has: `get_property`, `get_properties`, `set_property`, `get_identifier`

---

## ProjectServer

Retrieved via `portal.get_project_servers()` or `portal.add_project_server()`.

```python
server.get_host()          # → str
server.get_port()          # → int
server.get_server_name()   # → str
server.print_info()        # Prints server info to console
server.delete()
```

### Project Management on Server

```python
# List all project paths on the server
paths = server.get_server_project_paths(group="MyGroup")  # → List[str]

# Add a project to the server
server.add_project(project_path="D:\\tia_sessions\\MyTestSession\\MyTestSession.als")
```

### Local Sessions

```python
# Create a local session (returns local project path)
local_path = server.create_local_session(
    server_project_path="myServerGroup/MyServerProject",
    session_directory_path="C:\\ws\\sessionDir",
    session_name="myLocalSession",
    exclusive=False   # Default True
)  # → str  local session file path

# Delete a local session
server.delete_local_session(
    session_file_path="C:\\ws\\tia-sessions\\myproject\\myproject.amc",
    server_project_path="myGroup/serverproject"
)
```

### Shared Traits

Has: `get_property`, `get_properties`, `set_property`

---

## Test Suite – ApplicationTest

Requires Test Suite Advanced.

```python
app_test.get_name()           # → str
app_test.get_property(name)   # → str

app_test.export(target_directory_path="C:\\ws\\export")
# Note: creates "Application tests" subfolder automatically

app_test.set_scope(
    plc_name="PLC_1",
    instance_name=None,    # Optional (V19+)
    execution_mode=None    # Optional (V19+): 1=SystemManaged, 2=ExternallyManaged
)
```

---

## Test Suite – SystemTest

Requires Test Suite Advanced.

```python
sys_test.get_name()   # → str

sys_test.export(target_directory_path="C:\\ws\\export")
# Note: creates "System tests" subfolder automatically

sys_test.set_scope(
    opcua_server_address="opc.tcp://server.port/path",
    opcua_server_interface_type=1,   # 1=UserDefined, 2=StandardSIMATIC
    opcua_server_interface_folder_path=None  # Optional
)

# Has: get_property, get_properties, set_property, get_identifier
```

---

## Test Suite – RuleSet

Requires Test Suite Advanced.

```python
rule.get_name()           # → str
rule.get_property(name)   # → str

rule.export(target_directory_path="C:\\ws\\export")
# Note: creates "Style guide" subfolder automatically
```
