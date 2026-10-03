# Project, ProjectServer, and Test Suite Reference

V1.4.3 authority: Siemens manual sections 2.42-2.46 plus the bundled
`siemens_tia_scripting.pyi`.

## Project discovery

```text
project.get_portal() -> ts.Portal
project.get_devices() -> List[ts.Device]
project.get_plcs() -> List[ts.Plc]
project.get_hmis() -> List[ts.Hmi]
project.get_project_library() -> ts.ProjectLibrary
project.get_application_tests() -> List[ts.ApplicationTest]
project.get_system_tests() -> List[ts.SystemTest]
project.get_rule_sets() -> List[ts.RuleSet]
project.get_property(name: str) -> str
project.get_properties() -> List[str]
project.is_session() -> bool
project.get_identifier() -> str
```

Test Suite retrieval requires the relevant Test Suite product and license.
Static method availability does not prove that license is installed.

## Project lifecycle

Mutation/lifecycle signatures:

```text
save() -> None
close() -> None
delete() -> None
save_as(target_directory_path: str, project_name: str) -> str
archive(target_directory_path: str, archive_name: str,
        delete_existing_archive: bool) -> str
commit_and_close(commit_message: str) -> int
set_property(name: str, value: str) -> int
```

- `save()` persists all pending project changes.
- `close()` loses unsaved changes according to the Siemens manual.
- `delete()` removes the project from disk.
- `save_as()` changes the persistence location and returns the saved path.
- `archive(..., delete_existing_archive=True)` can overwrite an existing
  archive.
- `commit_and_close()` applies to a local server session. Its V1.4.3 signature
  line omits a return annotation, while the bundled docstring and manual
  document an integer revision number. Capture that revision when committing a
  session; verify the installed runtime before depending on its concrete Python
  type in a wider workflow.

Every one of these calls requires separate explicit authorization. Resolve the
exact path/project/session, display the pending disposition, and never infer
save/discard/delete/overwrite intent from a request to modify engineering data.

## Transactions and exclusive access

```text
project.start_transaction(undo_text: str, dialog_text: str) -> None
project.update_transaction(dialog_text: str) -> None
project.end_transaction(rollback: Optional[bool] = None) -> None
```

`start_transaction()` obtains exclusive access and starts a transaction.
`end_transaction()` ends both. Siemens documents `rollback=False` as the
default, so error paths must pass `True` explicitly:

```python
transaction_open = False
try:
    project.start_transaction(
        undo_text="Authorized project update",
        dialog_text="Applying reviewed changes",
    )
    transaction_open = True

    # Perform only the exact authorized transaction-compatible mutation.

    project.end_transaction(rollback=False)
    transaction_open = False
except Exception:
    if transaction_open:
        project.end_transaction(rollback=True)
    raise
```

Do not assume every wrapper operation is transaction-compatible. If an operation
cannot be proven rollback-safe, use a copy or route to guarded C# Openness.
Project save/archive/close remains a separate post-transaction decision.

## Hardware, simulation, editors, and generators

```text
project.set_simulation_support(value: bool) -> None
project.set_virtual_plc_support(value: bool) -> None
project.upgrade_hardware(full_upgrade: bool) -> None
project.update_module_description() -> None
project.web_block_generate() -> None
project.sivarc_generate() -> None
project.open_topology_editor() -> None
project.open_network_editor() -> None
```

These are not read-only discovery calls. Simulation/virtual PLC flags change
project configuration; hardware upgrade can change order numbers/firmware;
generation changes generated project content; opening an editor is a UI side
effect. `set_virtual_plc_support` is documented for V19 and later. Web-block
generation requires an activated web server; SiVArc generation requires the
SiVArc product/license.

## CAx data

```text
project.export_cax_data(
    export_file_path: str,
    log_file_path: str,
) -> bool

project.import_cax_data(
    import_file_path: str,
    log_file_path: str,
) -> bool
```

Both use exact file paths. Import mutates hardware/project data and requires
source validation, exact-target review, transaction/copy protection, and
explicit authorization. Inspect the boolean and log file; a created log alone
does not prove success. Export can overwrite output/log files and needs a
resolved destination.

## UMAC and password policy

```text
project.import_umac_config(import_file_path: str) -> int
project.export_umac_config(export_file_path: str) -> None
project.import_password_policy(import_file_path: str) -> None
project.export_password_policy(export_file_path: str) -> None
```

The V1.4.3 stub signature and the manual's signature heading expose only
`import_file_path`, but the same stub docstring and manual parameter
table/example still mention `secret` and `secret_env_name`. The shipped sources
therefore conflict. Before generating an encrypted-import call, verify the
installed runtime/help and emit only parameters confirmed there; do not infer
either that the extra parameters remain callable or that they can safely be
omitted. The global `set_umac_credentials_by_config(...)` function is the
documented configuration-credential route.

UMAC/password-policy imports are security-sensitive mutations. Do not print or
copy secrets, validate the exact source, and require explicit authorization.
Exports can contain sensitive security configuration; store them only in an
approved location.

## Project texts

V1.3.0 added project-text export/import; V1.4.1 added the default-language
behavior for export.

```text
project.export_project_texts(
    export_file_path: str,
    source_language: Optional[str] = None,
    target_language: Optional[str] = None,
) -> None

project.import_project_texts(
    import_file_path: str,
    update_source_language: bool,
) -> int
```

Use exact culture/language identifiers supported by the target project. Treat
`update_source_language=True` as a distinct mutation decision. Inspect the
integer import result and verify resulting language state; do not infer success
from a lack of exception.

## Test Suite import and object access

V1.4.0 added Test Suite test/test-set import handling. All imports require Test
Suite installation/licensing and mutate project test content.

```text
project.import_application_tests(
    import_root_directory: str,
    import_options: ts.Enums.GeneralImportOptions,
    testcase_import_options: ts.Enums.TestSuiteTestCaseImportOptions,
) -> None

project.import_system_tests(
    import_root_directory: str,
    import_options: ts.Enums.GeneralImportOptions,
    testcase_import_options: ts.Enums.TestSuiteTestCaseImportOptions,
) -> None

project.import_rule_sets(
    import_root_directory: str,
    import_options: ts.Enums.GeneralImportOptions,
    ruleset_import_options: ts.Enums.TestSuiteRuleSetImportOptions,
) -> None
```

Pass all enum options explicitly. Preflight the import directory and require
authorization before `GeneralImportOptions.Override` or any ignore/skip mode,
because these options can hide invalid input or replace existing content.

### ApplicationTest

```text
application_test.get_name() -> str
application_test.get_property(name: str) -> str
application_test.export(target_directory_path: str) -> None
application_test.set_scope(
    plc_name: str,
    instance_name: Optional[str] = None,
    execution_mode: Optional[int] = None,
) -> None
```

Siemens documents `instance_name` and `execution_mode` for V19 and later. Scope
changes are mutations; use an exact PLC and instance.

### RuleSet

```text
rule_set.get_name() -> str
rule_set.get_property(name: str) -> str
rule_set.export(target_directory_path: str) -> None
```

### SystemTest

```text
system_test.get_name() -> str
system_test.export(target_directory_path: str) -> None
system_test.set_scope(
    opcua_server_address: str,
    opcua_server_interface_type: int,
    opcua_server_interface_folder_path: Optional[str] = None,
) -> None
system_test.get_property(name: str) -> str
system_test.get_properties() -> List[str]
system_test.set_property(name: str, value: str) -> int
system_test.get_identifier() -> str
```

System-test scope is an external OPC UA endpoint decision. Confirm the exact
address, interface type, and folder; do not discover-and-use the first endpoint.

Exports create the Siemens-documented subdirectories (`Application tests`,
`Style guide`, or `System tests`). Resolve the parent output and require
overwrite authorization.

## ProjectServer

Retrieve/register servers through `Portal`; see `global_portal.md`.

### Read-only methods

```text
server.get_host() -> str
server.get_port() -> int
server.get_server_name() -> str
server.print_info() -> None
server.get_property(name: str) -> str
server.get_properties() -> List[str]
server.get_server_project_paths(
    group: Optional[str] = None,
) -> List[str]
```

`print_info()` writes diagnostics to the console. Do not use it where server
details are sensitive.

### Mutating methods

```text
set_property(name: str, value: str) -> int
delete() -> None
add_project(project_path: str) -> str
create_local_session(server_project_path: str,
                     session_directory_path: str,
                     session_name: str,
                     exclusive: Optional[bool] = None) -> str
delete_local_session(session_file_path: str,
                     server_project_path: str) -> None
```

Server registration/deletion, adding a project, and session creation/deletion
affect shared or local multiuser state. Require exact server/project/session
paths and explicit mutation authorization. Siemens notes that grouped-server
support for local session creation is version-dependent (API V20 and later);
qualify the installed target instead of assuming it.

## Safe project workflow

1. Confirm the exact portal ownership, project path/identifier, and whether the
   project is a local server session.
2. Separate read-only discovery from mutation, live operations, and persistence.
3. Use a copy for operations whose wrapper transaction support is uncertain.
4. Start exclusive access only for authorized, transaction-compatible changes.
5. Verify import/compile/result/log evidence before committing the transaction.
6. Roll back on every exception path.
7. Ask separately whether to save/archive/commit-and-close/discard/delete.
8. Detach from user-owned portals; close only script-owned portals after explicit
   project disposition.
