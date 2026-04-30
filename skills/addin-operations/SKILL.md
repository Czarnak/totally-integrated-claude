---
name: addin-operations
description: >
  Routed by tia-openness-roadmap. Handles TIA Portal Add-In development in Visual Studio Code:
  creating Add-In C# projects, adding Add-In templates, compiling and debugging Add-Ins,
  converting Add-Ins from older TIA Portal versions, and configuring Add-In project parameters.
---

# TIA Portal Add-In Development — Visual Studio Code

Source: TIA Portal Add-In Development Tools Manual (11/2025)

## Scope

Add-In development in VS Code using C# and the dotnet Add-In SDK.
Do not mix with Python wrapper calls.
Always load `tia-csharp-common` first (done by roadmap).

---

## Reference files

Load ONLY the reference file(s) relevant to the task. Do not load all files at once.

| Reference file | Load when the task involves |
|---|---|
| `references/api-surface.md` | Choosing provider/add-in types; VCI or CAx workflow item types; workflow-to-assembly mapping |
| `references/assembly-references.md` | Adding PLC software, block, or tag access to an Add-In csproj |
| `references/attribute-helper.md` | Reading/writing engineering object attributes via `GetAttributeInfos` or `SetAttributes` |
| `references/threading-and-callbacks.md` | Showing any WinForms UI from an Add-In; understanding status callback constraints |
| `references/runtime-gotchas.md` | Assembly location resolution failures; NuGet/GAC errors; SplitContainer sizing crashes |
| `references/skeleton.md` | Starting a new context-menu Add-In from scratch |

For tasks spanning multiple areas, load all relevant reference files before generating code.

---

## Execution pattern

1. Pick the Add-In type → run `dotnet new <template>` (see template table below)
2. Decide which TIA Portal objects the Add-In must access; if PLC/SW/HW → load `references/assembly-references.md`
3. Implement `BuildContextMenuItems` — status callback returns `MenuStatus.Enabled`, guard logic goes in the action callback
4. For any UI: follow the two-phase collect/show pattern → load `references/threading-and-callbacks.md`
5. Before distributing: compile with "Run build task", debug with F5

---

## Task: Create new Add-In C# project

### Procedure

1. Open the Windows command prompt with administrator privileges.
2. (Optional) Navigate to the desired project location, or use the `--output` parameter.
3. Run:
   ```
   dotnet new addin-project [options]
   ```

### Essential parameters

| Parameter | Long form | Short | Description |
|-----------|-----------|-------|-------------|
| output | --output | -o | Project folder. If not specified, project is created in the current directory. |
| name | --name | -n | Project name. If not specified, the parent directory name is used. |
| Namespace | --Namespace | -N | C# namespace. Default is derived from output directory or project name. |
| TIAAccess | --TIAAccess | -TI | Authorization level: `ReadWrite` (default) or `ReadOnly`. |

### Example

```
dotnet new addin-project -o C:\MyAddIns\MyFirstAddIn -n MyAddinProject -N MyAddinNamespace -TI ReadWrite
```

### Additional parameters

The following parameters can also be set at creation time but are **editable later in `Config.xml`** inside the project directory: Author, Description, AddInVersion, ProductName, ProductId, ProductVersion, UnrestrictedAccess, JustificationComment.

### Result

A new project is created containing the framework for an empty Add-In that can be built.
The project directory contains `Config.xml` for changing parameters after creation.

---

## Task: Add an Add-In template to existing project

### Procedure

1. Open the Windows command prompt with administrator privileges.
2. Navigate to the project directory (or use `--output`).
3. Run:
   ```
   dotnet new <Add-In-Type> [-o <output dir>] [-n <name>] [-N <namespace>]
   ```

Replace `<Add-In-Type>` with the short name from the table below.

### Available templates

**addin-project-tree-menu** — TIA Portal Project-Tree Context Menu Add-In
Adds custom entries to the right-click menu of the project tree.
Use cases: automating operations on blocks, tag tables, or devices; batch-exporting selected items; running custom validations on project tree objects.

**addin-project-library-tree-menu** — TIA Portal Project-Library-Tree Context Menu Add-In
Adds custom entries to the right-click menu of the project library tree.
Use cases: custom library management operations; automated copying or versioning of library types; bulk operations on library elements.

**addin-global-library-tree-menu** — TIA Portal Global-Library-Tree Context Menu Add-In
Adds custom entries to the right-click menu of a global library.
Use cases: synchronizing global library content with external systems; enforcing naming conventions across library elements; automated library maintenance tasks.

**addin-devices-and-networks-menu** — TIA Portal Devices and Networks Context Menu Add-In
Adds custom entries to the right-click menu of the hardware and network editor.
Use cases: automated network configuration; bulk device parameter changes; generating device reports or hardware bills of materials.

**addin-vci-editor** — TIA Portal VCI Editor Add-In
Adds entries to the workspace area of the Version Control Interface workspace editor. These entries are always visible and should contain general-purpose functions. For repository-specific operations, use the VCI Import or VCI Export templates instead.
Use cases: general version control utilities; workspace status overview; custom reporting on versioned items.

**addin-vci-import-workflow** — TIA Portal VCI Import Add-In
Extends the VCI import workflow with custom shortcut menu entries and enhanced drag-and-drop/synchronization from the workspace area into the project. Can only be used if selected as the import Add-In in the Add-In configuration view.
Use cases: custom import validation; automated conflict resolution during import; post-import processing of files and directories.

**addin-vci-export-workflow** — TIA Portal VCI Repository Export Add-In
Extends the VCI export workflow with custom shortcut menu entries and enhanced drag-and-drop/synchronization from the project into the workspace area. Can only be used if selected as the Version Control Add-In in the workspace editor.
Use cases: custom export rules and filtering; automated commit operations; pre-export validation and packaging.

**addin-cax-export-import-workflow** — TIA Portal CAX Export Import Add-In
Adds custom functions to be executed after a CAx export or import operation in TIA Portal. Enables further interaction with the TIA Portal based on exported or imported data, or with external applications. Export operations are always write-protected. Must be selected as the default Add-In for the "CAx data exchange" workflow in the Add-In configuration.
Use cases: post-export data transformation for external CAx tools; automated validation of imported CAx data; synchronization with external engineering databases.

### Note — Icons and multilingual texts

- You can add icons to the context menu entries for Add-Ins.
- Add-Ins can detect the current TIA Portal language, allowing you to display context menu texts, workflow names, and feedback messages in the matching language.

Examples for icons and multilingual texts can be found in the corresponding templates.

### Result

All classes and methods needed for programming the selected Add-In type are inserted into the project. You can directly implement the desired functionalities.

---

## Task: Compile Add-Ins

### Procedure

1. In VS Code, open Terminal → "Run build task".
2. The program compiles. Status messages appear at the bottom of the terminal.

### Result

If compilation succeeds, the `.addin` file is created in the `bin` directory of the project.

> **Important:** Test your Add-Ins thoroughly before distributing them. You can use the mass rollout mechanism of the TIA Portal to distribute Add-Ins in your organization. Additional information is available in the TIA Portal information system.

---

## Task: Debug Add-Ins

### Procedure

1. Set breakpoints anywhere in your program code.
2. From the Run menu, select "Start debugging" (or press F5).
   TIA Portal starts automatically.
3. In TIA Portal, confirm the "Debug Add-In" message with "Yes" or "Yes, all".

### Result

You can now step through your program code using the debug functions of Visual Studio Code.
The Add-In remains activated until you close the TIA Portal.

> **Note:** It is not necessary to copy the `.addin` file to a specific Add-In folder for debugging.

---

## Task: Convert Add-Ins from older TIA Portal versions

### Context

The Add-In assembly has been split into several segmented assemblies.
Automatic conversion of older Add-Ins is therefore not possible — manual adjustments are required.

### Procedure

1. **Update assembly references:**
   Remove the old reference to `Siemens.Engineering.AddIn.dll` and add references to the new segmented assemblies.

2. **Update API implementations:**
   If your Add-In uses any of the following APIs, update their implementations according to the current procedure:
   - Feedback API
   - Progress API
   - MessageBox API
