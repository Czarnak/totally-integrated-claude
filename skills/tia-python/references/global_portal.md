# Global & Portal Reference

## Global Functions (on `siemens_tia_scripting` module)

### Open / Attach Portal

```python
# Open a new TIA Portal instance
portal = ts.open_portal(
    portal_mode=ts.Enums.PortalMode.WithGraphicalUserInterface,
    version="18.0"   # Optional: defaults to latest installed
)

# Attach to an already running TIA Portal instance
portal = ts.attach_portal(
    portal_mode=ts.Enums.PortalMode.WithGraphicalUserInterface,
    version="18.0"
)

# Attach to running portal that already has a project open,
# OR open project in a new portal instance (auto-detects version)
project = ts.open_attach_project(
    project_file_path="C:\\ws\\testproj\\testproj.ap17",
    portal_mode=ts.Enums.PortalMode.WithGraphicalUserInterface,
    server_project_view=False   # Optional
)
```

### Installed Products

```python
bundles  = ts.get_installed_bundles()    # → List[ProductBundle]
products = ts.get_installed_products()   # → List[Product]
```

### UMAC Credentials

```python
# Set credentials for protected libraries/projects
ts.set_umac_credentials(
    user_name="admin",
    user_password="Password123",
    user_type=ts.Enums.UmacUserMode.Project
)

# Encrypt UMAC config file
ts.encrypt_umac_config(
    umac_file_path="C:\\ws\\exportUMAC.json",
    secret="mySecret",
    secret_env_name="MY_SECRET_ENV"
)
```

### Logging

```python
ts.set_logging(path="C:\\ws\\tiascripting.log", console=False)
```

---

## Portal Object

```python
portal.get_process_id()     # → int  TIA Portal process ID
portal.detach()             # Detach from portal (does not close it)
portal.close_portal()       # Attempts to close portal (all projects must be saved first)
```

### Open / Create Projects

```python
# Open project
project = portal.open_project(
    project_file_path="C:\\ws\\testproj\\testproj.ap17",
    server_project_view=False
)

# Open project into a temp copy (non-destructive)
project = portal.open_project_with_copy(
    project_file_path="C:\\ws\\testproj\\testproj.ap17",
    target_directory_path="C:\\ws\\temp",
    delete_existing_project=True
)

# Retrieve from archive
project = portal.retrieve_archive(
    archive_file_path="C:\\ws\\testproj\\testproj.zap17",
    target_directory_path="C:\\ws\\temp",
    delete_existing_project=True
)

# Create new project
project = portal.create_project(
    target_directory_path="C:\\ws\\temp",
    project_name="MyNewProject",
    delete_existing_project=True
)

# Get already-open project
project = portal.get_project()
```

### Global Libraries via Portal

```python
infos      = portal.get_global_library_infos()    # → List[GlobalLibraryInfo]
global_lib = portal.get_global_library(library_name="GlobalLib1")
global_lib = portal.open_global_library(library_path="C:\\ws\\testlib\\testlib.al17")
global_lib = portal.open_global_library_with_copy(
    target_directory_path="C:\\ws\\temp",
    library_path="C:\\ws\\testlib\\testlib.al17",
    delete_existing_project=True
)
global_lib = portal.create_global_library(
    target_directory_path="C:\\ws\\temp",
    library_name="MyLib1",
    delete_existing_project=True
)
global_lib = portal.retrieve_archive_library(
    target_directory_path="C:\\ws\\temp",
    archive_file_path="C:\\ws\\testproj\\testlib.zal17",
    delete_existing_project=True
)
```

### Project Servers

```python
servers = portal.get_project_servers(server="CompanyServer")  # → List[ProjectServer]
server  = portal.add_project_server(url="https://project.server.net:8735/", name="MyServer")
```

### Online Fingerprints

```python
portal.show_online_finger_prints(mode="PN/IE", pci_interface="PLCSIM", ip_address="192.168.0.10")
```

---

## Product / ProductBundle Objects

```python
product.get_name()      # → str
product.get_release()   # → str
product.get_version()   # → str

bundle.get_title()      # → str
bundle.get_release()    # → str
bundle.get_products()   # → List[Product]
```
