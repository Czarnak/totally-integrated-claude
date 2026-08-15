# Global, Portal, Product, and Device Reference

V1.4.3 authority: Siemens manual sections 2.1, 2.3, 2.7, 2.8, 2.9,
2.28, and 2.40, plus the bundled `siemens_tia_scripting.pyi`.

## Global functions

```text
ts.open_portal(
    portal_mode: Optional[ts.Enums.PortalMode] = None,
    version: Optional[str] = None,
) -> ts.Portal

ts.attach_portal(
    portal_mode: Optional[ts.Enums.PortalMode] = None,
    version: Optional[str] = None,
) -> ts.Portal

ts.open_attach_project(
    project_file_path: str,
    portal_mode: Optional[ts.Enums.PortalMode] = None,
    server_project_view: Optional[bool] = None,
) -> ts.Project

ts.get_installed_bundles() -> List[ts.ProductBundle]
ts.get_installed_products() -> List[ts.Product]

ts.set_umac_credentials(
    user_name: str,
    user_password: str,
    user_type: ts.Enums.UmacUserMode,
) -> None

ts.set_umac_credentials_by_config(
    umac_file_path: str,
    user_type: ts.Enums.UmacUserMode,
    secret: str,
    secret_env_name: str,
) -> None

ts.encrypt_umac_config(
    umac_file_path: str,
    secret: str,
    secret_env_name: str,
) -> str

ts.set_logging(path: str, console: bool) -> None
ts.set_log_level(log_level: ts.Enums.ConsoleLogLevel) -> None
```

When `version` is omitted, Siemens documents selection of the latest installed
TIA Portal version. Supply a version such as `"21.0"` when reproducibility
matters, and verify that exact version is installed before opening it.

### Credential handling

Never put credentials in source, examples, logs, or command lines. Use the
user's approved secret provider. A minimal environment-backed example is:

```python
import os

ts.set_umac_credentials(
    user_name=os.environ["TIA_UMAC_USER"],
    user_password=os.environ["TIA_UMAC_PASSWORD"],
    user_type=ts.Enums.UmacUserMode.Project,
)
```

For `set_umac_credentials_by_config`, pass the approved configuration file,
the intended project/global user mode, the decryption secret, and the name of
the environment variable Siemens should use. Do not log any of those values.

## Portal lifecycle

### Read/discovery methods

```text
portal.get_process_id() -> int
portal.get_project() -> ts.Project
portal.get_global_library_infos() -> List[ts.GlobalLibraryInfo]
portal.get_global_library(library_name: str) -> ts.GlobalLibrary
portal.get_project_servers(server: Optional[str] = None) -> List[ts.ProjectServer]
```

`get_project()` requires an already open project. Check the returned object
before dereferencing it even though the V1.4.3 stub does not annotate an
optional return.

### Open, copy, create, and retrieve

```text
portal.open_project(
    project_file_path: str,
    server_project_view: Optional[bool] = None,
) -> ts.Project

portal.open_project_with_copy(
    project_file_path: str,
    target_directory_path: str,
    delete_existing_project: bool,
) -> ts.Project

portal.retrieve_archive(
    target_directory_path: str,
    archive_file_path: str,
    delete_existing_project: bool,
) -> ts.Project

portal.create_project(
    target_directory_path: str,
    project_name: str,
    delete_existing_project: bool,
) -> ts.Project
```

`delete_existing_project=True` can remove an existing target. Default generated
code to `False`, resolve the exact target path, and require explicit overwrite
authorization before changing it.

### Global library lifecycle

```text
portal.open_global_library(library_path: str) -> ts.GlobalLibrary

portal.open_global_library_with_copy(
    target_directory_path: str,
    library_path: str,
    delete_existing_project: bool,
) -> ts.GlobalLibrary

portal.create_global_library(
    target_directory_path: str,
    library_name: str,
    delete_existing_project: bool,
) -> ts.GlobalLibrary

portal.retrieve_archive_library(
    target_directory_path: str,
    archive_file_path: str,
    delete_existing_project: bool,
) -> ts.GlobalLibrary
```

### Portal ownership and cleanup

```text
portal.detach() -> None
portal.close_portal() -> None
```

- Use `detach()` when the script attached to an existing user-owned portal.
- Use `close_portal()` only for a portal instance created by the script and only
  after every open project's save/discard disposition is explicitly authorized.
  Siemens documents that all projects must be saved or their changes explicitly
  discarded before the portal can close.

Track ownership instead of guessing from UI mode:

```python
portal = ts.attach_portal(
    portal_mode=ts.Enums.PortalMode.AnyUserInterface,
    version="21.0",
)
owns_portal = False
try:
    project = portal.get_project()
    if project is None:
        raise RuntimeError("The attached portal has no open project.")
    # Read-only work with the explicitly selected project.
finally:
    if not owns_portal:
        portal.detach()
```

### Online fingerprints and project-server registration

```text
portal.show_online_finger_prints(
    mode: str,
    pc_interface: str,
    ip_address: str,
) -> None

portal.add_project_server(url: str, name: str) -> ts.ProjectServer
```

Online fingerprints communicate with a target and require explicit
live-operation authorization plus an exact interface and address. Adding a
project server changes portal configuration and requires explicit mutation
authorization.

## ProductBundle and Product

```text
bundle.get_title() -> str
bundle.get_release() -> str
bundle.get_products() -> List[ts.Product]

product.get_name() -> str
product.get_release() -> str
product.get_version() -> str
```

These objects are returned by `get_installed_bundles()` and
`get_installed_products()` and are suitable for read-only environment
inventory. They do not prove that a separately licensed feature is usable.

## Device and Module

`Project.get_devices()` returns general hardware `Device` objects. This is
separate from the wrapper's PLC and HMI software views.

```text
device.get_name() -> str
device.open_device_editor() -> None
device.compile() -> ts.ExecutionResult
device.get_modules() -> List[ts.Module]
device.get_property(name: str) -> str
device.get_properties() -> List[str]
device.set_property(name: str, value: str) -> int
device.get_identifier() -> str
device.create_master_copy(
    library_folder_path: Optional[str] = None,
) -> ts.MasterCopy

module.get_name() -> str
module.compile() -> ts.ExecutionResult
module.get_property(name: str) -> str
module.get_properties() -> List[str]
module.set_property(name: str, value: str) -> int
module.get_identifier() -> str
module.create_master_copy(
    library_folder_path: Optional[str] = None,
) -> ts.MasterCopy
```

Opening an editor is a UI side effect. Compiling can update generated data and
must be explicitly authorized when the workflow is not already an authorized
validation step. Inspect `ExecutionResult.get_errors()` before continuing.
Property writes and master-copy creation are mutations and require exact object
selection and explicit mutation authorization.

## GlobalLibraryInfo

```text
info.get_name() -> str
info.get_property(name: str) -> str
info.get_properties() -> List[str]
info.set_property(name: str, value: str) -> int
```

Use the info object for discovery. Open the actual `GlobalLibrary` through the
portal before library operations. Treat `set_property` as a mutation even on an
info object.
