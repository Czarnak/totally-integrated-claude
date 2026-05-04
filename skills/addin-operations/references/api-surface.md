# PublicAPI-derived Add-In surface map

Source: `C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\net48`, XML docs,
validated against the local graph in `graphify-out/`.

The Add-In API is split into small framework assemblies. Pick the template by workflow,
then use the matching provider/support/item types below when generating or reviewing code.

| Workflow | Assembly | Main provider/add-in types | Workflow item types | Key context/info types |
| --- | --- | --- | --- | --- |
| Project/library/device context menus | `Siemens.Engineering.AddIn.Base.dll` | `ProjectTreeAddInProvider`, `ProjectLibraryTreeAddInProvider`, `GlobalLibraryTreeAddInProvider`, `DevicesAndNetworksAddInProvider`, `ContextMenuAddIn` | `ActionItem<T>`, `ActionItem<T1,T2>`, `ActionItem<T1,T2,T3>` | `MenuSelectionProvider`, `MenuSelectionProvider<T>`, `MenuStatus` |
| VCI workspace editor | `Siemens.Engineering.AddIn.Base.dll` | `VciEditorAddInProvider`, `VciWorkspaceViewAddInProvider` | context menu add-ins | `WorkspaceFile`, `WorkspaceFolder` |
| VCI repository export | `Siemens.Engineering.AddIn.Base.dll` | `VciWorkspaceRepositoryAddInProvider`, `VciWorkspaceRepositoryAddIn`, `VciWorkspaceRepositoryWorkflowAddIn`, `ExportWorkflowSupport` | `PreExportWorkflowItem`, `PostExportWorkflowItem` | `ExportContext`, `ExportArgs`, `PreExportInfo`, `PostExportInfo`, `PreExportRollbackInfo`, `MappingFileInfo`, `ExportAction`, `ExportStatus`, `ExportResult` |
| VCI import | `Siemens.Engineering.AddIn.Base.dll` | `VciImportAddInProvider`, `VciImportAddIn`, `VciImportWorkflowAddIn`, `ImportWorkflowSupport` | `PreImportWorkflowItem`, `PostImportWorkflowItem` | `ImportContext`, `ImportArgs`, `PreImportInfo`, `PostImportInfo`, `ImportAction`, `ImportStatus` |
| CAx export/import | `Siemens.Engineering.AddIn.Step7.dll` | `CaxAddInProvider`, `CaxWorkflowAddIn`, `CaxExportWorkflowSupport`, `CaxImportWorkflowSupport` | `CaxPreExportWorkflowItem`, `CaxPostExportWorkflowItem`, `CaxPreImportWorkflowItem`, `CaxPostImportWorkflowItem` | `CaxWorkflowContext`, `CaxWorkflowArgs` |
| Safety compile | `Siemens.Engineering.AddIn.Safety.dll` | `SafetyCompileAddInProvider`, `SafetyCompileWorkflowAddIn`, `SafetyCompileWorkflowSupport` | `SafetyCompileWorkflowItem` | `SafetyCompileContext`, `SafetyCompileWorkflowArgs` |

---

## VCI export/import workflow facts

The graph found the strongest Add-In bridge around VCI workflow info objects and the
core attribute APIs. Treat VCI `*Info`, `WorkspaceFile`, `WorkspaceFolder`, and
`WorkflowExecutionResult` as engineering objects: they expose `GetAttribute`,
`GetAttributes(AttributeAccessOptions)`, `GetAttributeInfos`, `SetAttribute`, and
`SetAttributes(..., AttributeDelegate)` through the common `IEngineeringObject` pattern.

Useful properties to remember:

| Type | Useful properties |
| --- | --- |
| `ExportArgs`, `ImportArgs` | `CurrentWorkspace`, `Parent` |
| `ExportContext`, `ImportContext` | `Args`, `Parent` |
| `PreExportInfo` | `Mappings`, `ExportAction`, `ObjectToExport`, `Parent`, `SetStatus(PreExportAddInStatus)` |
| `PostExportInfo` | `Mappings`, `ExportAction`, `ObjectExportStatus`, `ObjectToExport`, `PreExportAddInStatus`, `Parent` |
| `MappingFileInfo` | `ExistingMappingInfo`, `NewMappingInfo`, `Parent` |
| `PreImportInfo` | `ImportAction`, `ImportSourceInfos`, `ImportTarget`, `Parent` |
| `PostImportInfo` | `ImportAction`, `ImportSourceInfos`, `ImportStatus`, `ImportTarget`, `ImportedObject`, `Parent` |
| `WorkspaceFile` | `FileInfo`, `Workspace`, `Parent` |
| `WorkspaceFolder` | `DirectoryInfo`, `Workspace`, `Parent` |

Workflow items return `WorkflowExecutionResult`, created from the workflow context via
`context.WorkflowExecutionResult(WorkflowReturnCode.Success|Fail|Cancel[, message])`.
Use a user-friendly message when returning `Fail` or `Cancel`; TIA Portal can display it.

---

## CAx & Safety Workflows

CAx and Safety workflows follow a similar "Support -> Item -> Context" pattern but live in specialized assemblies.

- **CAx Workflow**: Used during "CAx data exchange". Must be selected as default in Add-In configuration.
- **Safety Compile**: Intercepts or extends the safety compilation process.

Key Context Types for specialized workflows:

- `CaxWorkflowContext`: Access via `Args.ProjectPath` and `Args.PctMappingFilePath`.
- `SafetyCompileContext`: Access via `Args.PlcName`.

---

## Common Feedback Interfaces

Add-Ins can provide feedback to TIA Portal users via:

- `FeedbackProvider`: For logging messages.
- `MessageBoxProvider`: For interactive dialogs.
- `ProgressProvider`: For reporting long-running operation progress.
