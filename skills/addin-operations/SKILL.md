---
name: addin-operations
description: >
  Routed by tia-openness-roadmap. Handles TIA Portal Add-In development in Visual Studio Code:
  creating Add-In C# projects, adding Add-In templates, compiling and debugging Add-Ins,
  converting Add-Ins from older TIA Portal versions, and configuring Add-In project parameters.
---

# TIA Portal Add-In Development — Visual Studio Code

Source: TIA Portal Add-In Development Tools Manual (11/2025)

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

---

## Assembly references for TIA object access

The `addin-project` template auto-references five Add-In framework assemblies:
`Siemens.Engineering.Base`, `Siemens.Engineering.AddIn.Base`, `Siemens.Engineering.AddIn.Step7`,
`Siemens.Engineering.AddIn.Utilities`, `Siemens.Engineering.AddIn.Permissions`.

These provide the Add-In framework types (`ContextMenuAddIn`, `ProjectTreeAddInProvider`, etc.)
but **do not expose the full TIA Portal object model**. If the Add-In needs to access PLC
software, blocks, tags, or devices, additional assemblies must be added manually.

### Namespace → assembly map

| Namespace | Assembly to add to csproj | Key types |
|---|---|---|
| `Siemens.Engineering.HW` | already in `Base` | `Device`, `DeviceItem`, `DeviceItemComposition` |
| `Siemens.Engineering.HW.Features` | already in `Base` | `SoftwareContainer` |
| `Siemens.Engineering.SW` | `Siemens.Engineering.Step7.dll` | `PlcSoftware` |
| `Siemens.Engineering.SW.Blocks` | `Siemens.Engineering.Step7.dll` | `PlcBlock`, `PlcBlockGroup`, `PlcBlockSystemGroup`, `PlcBlockUserGroup`, `PlcSystemBlockGroup`, `OB`, `FB`, `FC`, `GlobalDB`, `InstanceDB` |
| `Siemens.Engineering.SW.Tags` | `Siemens.Engineering.Step7.dll` | `PlcTagTable`, `PlcTag` |
| `Siemens.Engineering.SW.Types` | `Siemens.Engineering.Step7.dll` | `PlcTypeComposition` |

> **Note:** `Siemens.Engineering.AddIn.Step7.dll` (included by the template) is **not** the
> same as `Siemens.Engineering.Step7.dll`. The `AddIn.Step7` dll provides Add-In framework
> integration only — it does not expose `PlcSoftware` or block types.

### How to add an extra assembly reference to the csproj

The template generates **two** `ItemGroup` blocks with references — one inside a `<Target>`
element (condition `== ''`) and one at the outer level (condition `!= ''`). Add the new
`<Reference>` entry to **both** blocks, immediately after the last existing `<Reference>`.

```xml
<!-- Inside <Target Name="SetEngineeringAddinReferences"> / <ItemGroup> -->
<Reference Condition="'$(TiaPortalLocation)' == ''" Include="Siemens.Engineering.Step7">
  <HintPath>$(TiaPortalLocation)\PublicAPI\V21\net48\Siemens.Engineering.Step7.dll</HintPath>
  <Private>False</Private>
</Reference>

<!-- In the outer <ItemGroup> below the <Target> blocks -->
<Reference Condition="'$(TiaPortalLocation)' != ''" Include="Siemens.Engineering.Step7">
  <HintPath>$(TiaPortalLocation)\PublicAPI\V21\net48\Siemens.Engineering.Step7.dll</HintPath>
  <Private>False</Private>
</Reference>
```

`<Private>False</Private>` means Copy Local = false — mandatory for all Siemens assemblies.

---

## Threading model — mandatory for any UI shown from Add-In callbacks

### The silent failure

Add-In action callbacks (e.g. `OnScanBlocks`) run on **TIA Portal's UI thread**. Calling
`dialog.ShowDialog()` directly from a callback blocks that thread indefinitely while waiting
for the user to close the dialog. TIA Portal's watchdog detects that the callback never
returned and silently kills the operation. **There is no exception, no error message — the
Add-In appears to do nothing.**

### Required pattern: two-phase collect/show

```
Phase 1 — on TIA Portal callback thread (mandatory for COM access)
  ↳ Read all required data from TIA Portal API objects
  ↳ Store results as plain .NET types (strings, lists, TreeNodes, etc.)
  ↳ Return from callback immediately after starting Phase 2

Phase 2 — on a new STA thread (safe to block here)
  ↳ Create and show the WinForms dialog using the pre-collected data
  ↳ No TIA Portal API access — plain .NET only
```

```csharp
private void OnDoWork(MenuSelectionProvider<Device> provider)
{
    var msgBox = m_TiaPortal.GetService<MessageBoxProvider>();

    foreach (Device device in provider.GetSelection())
    {
        // ── Phase 1: collect on TIA Portal thread ────────────────────────
        var results = new List<string>();
        try
        {
            CollectData(device, results);   // reads TIA Portal API
        }
        catch (Exception ex)
        {
            msgBox?.ShowNotification(NotificationIcon.Error, "MyAddIn",
                $"Data collection failed: {ex.Message}");
            return;
        }

        string caption = device.Name;

        // ── Phase 2: show UI on a separate STA thread ────────────────────
        // Callback returns immediately — TIA Portal watchdog is satisfied.
        var thread = new Thread(() =>
        {
            try
            {
                using (var dialog = new MyDialog(caption, results))
                    dialog.ShowDialog();       // correct call on non-main STA thread
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Dialog error: {ex.Message}", "MyAddIn",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        });
        thread.SetApartmentState(ApartmentState.STA);
        thread.IsBackground = true;
        thread.Start();

        break; // handle first selected item only
    }
}
```

**Rules:**
- Always `thread.SetApartmentState(ApartmentState.STA)` — WinForms requires STA.
- Always `thread.IsBackground = true` — prevents the thread from keeping the process alive
  after TIA Portal closes.
- Use `dialog.ShowDialog()`, not `Application.Run(dialog)`, on non-main STA threads.
- The dialog class must use **only plain .NET types** — never store TIA Portal API references
  in it, as those COM objects are STA-bound to the callback thread.

---

## Status callback rules

Status callbacks (the second argument to `AddActionItem`) are called **on every mouse-over
event**. They run under tighter constraints than action callbacks:

- **Do not make any COM calls** — `GetService<>()` and all TIA Portal API access returns
  `null` or throws in this context.
- **Do not do any meaningful work** — return immediately.

If a status callback calls `GetService<SoftwareContainer>()` to check whether the selected
item is a PLC, it will always get `null`, always return `MenuStatus.Hidden`, and the menu
item will be permanently invisible — with no error and no explanation.

### Recommended pattern

Always return `MenuStatus.Enabled` from the status callback. Move all guard logic into the
action callback where COM access works correctly.

```csharp
protected override void BuildContextMenuItems(ContextMenuAddInRoot root)
{
    // Use IEngineeringObject to match any project tree item.
    // More specific types (Device, PlcSoftware) limit where the item appears
    // but require that type to be precisely right for the right-click target.
    root.Items.AddActionItem<IEngineeringObject>("Do something...", OnDoWork, OnCanDoWork);
}

// Status callback — no COM, return immediately
private static MenuStatus OnCanDoWork(MenuSelectionProvider<IEngineeringObject> provider)
{
    return MenuStatus.Enabled;
}

// Action callback — COM access works here
private void OnDoWork(MenuSelectionProvider<IEngineeringObject> provider)
{
    foreach (IEngineeringObject obj in provider.GetSelection())
    {
        // Resolve the actual type you need here
        PlcSoftware plcSw = obj as PlcSoftware
            ?? (obj as Device) is Device d ? GetPlcSoftware(d) : null;

        if (plcSw == null)
        {
            m_TiaPortal.GetService<MessageBoxProvider>()?.ShowNotification(
                NotificationIcon.Warning, "MyAddIn",
                $"Selected item is not a PLC. (Type: {obj.GetType().Name})");
            return;
        }

        // ... do work with plcSw ...
    }
}
```

---

## Minimal working skeleton — Project-Tree Context Menu Add-In

A complete, compilable starting point for a project-tree context menu Add-In that operates
on PLC devices. Replace `MyAddIn` / `MyNamespace` with your actual names.

**`MyAddInProvider.cs`** — registers the Add-In with TIA Portal:

```csharp
using System.Collections.Generic;
using Siemens.Engineering;
using Siemens.Engineering.AddIn;
using Siemens.Engineering.AddIn.Menu;

namespace MyNamespace
{
    public class MyAddInProvider : ProjectTreeAddInProvider
    {
        private readonly TiaPortal m_TiaPortal;

        public MyAddInProvider(TiaPortal tiaPortal)
        {
            m_TiaPortal = tiaPortal;
        }

        protected override IEnumerable<ContextMenuAddIn> GetContextMenuAddIns()
        {
            yield return new MyContextMenuAddIn(m_TiaPortal);
        }
    }
}
```

**`MyContextMenuAddIn.cs`** — implements the menu item and its logic:

```csharp
using System;
using System.Collections.Generic;
using System.Threading;
using System.Windows.Forms;
using Siemens.Engineering;
using Siemens.Engineering.AddIn;
using Siemens.Engineering.AddIn.Menu;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.SW;
using Siemens.Engineering.SW.Blocks;

namespace MyNamespace
{
    public class MyContextMenuAddIn : ContextMenuAddIn
    {
        private readonly TiaPortal m_TiaPortal;
        private const string DisplayName = "My Add-In";

        public MyContextMenuAddIn(TiaPortal tiaPortal) : base(DisplayName)
        {
            m_TiaPortal = tiaPortal;
        }

        protected override void BuildContextMenuItems(ContextMenuAddInRoot root)
        {
            // IEngineeringObject matches any project tree node.
            // Status callback must make no COM calls — return Enabled immediately.
            root.Items.AddActionItem<IEngineeringObject>(
                "Run My Add-In...", OnRun, _ => MenuStatus.Enabled);
        }

        // ── Action callback — COM access works here ──────────────────────────

        private void OnRun(MenuSelectionProvider<IEngineeringObject> provider)
        {
            var msgBox = m_TiaPortal.GetService<MessageBoxProvider>();

            foreach (IEngineeringObject obj in provider.GetSelection())
            {
                // Resolve PlcSoftware from whatever type was right-clicked
                PlcSoftware plcSoftware = null;
                string deviceName = "Unknown";

                if (obj is PlcSoftware sw)
                {
                    plcSoftware = sw;
                    deviceName = sw.Name;
                }
                else if (obj is Device device)
                {
                    plcSoftware = GetPlcSoftware(device);
                    deviceName = device.Name;
                }
                else if (obj is DeviceItem item)
                {
                    plcSoftware = item.GetService<SoftwareContainer>()?.Software as PlcSoftware;
                    deviceName = item.Name;
                }

                if (plcSoftware == null)
                {
                    msgBox?.ShowNotification(NotificationIcon.Warning, DisplayName,
                        $"No PLC software found. (Type: {obj.GetType().Name})");
                    return;
                }

                // Phase 1: collect data on TIA Portal thread (COM access required)
                var collected = new List<string>();
                try
                {
                    CollectData(plcSoftware, collected);
                }
                catch (Exception ex)
                {
                    msgBox?.ShowNotification(NotificationIcon.Error, DisplayName,
                        $"Collection failed: {ex.Message}");
                    return;
                }

                string name = deviceName;

                // Phase 2: show dialog on a new STA thread — callback returns immediately
                var thread = new Thread(() =>
                {
                    try
                    {
                        // MyResultDialog accepts only plain .NET data — no TIA API refs
                        MessageBox.Show(
                            string.Join(Environment.NewLine, collected),
                            $"{DisplayName} — {name}",
                            MessageBoxButtons.OK,
                            MessageBoxIcon.Information);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"Dialog error: {ex.Message}");
                    }
                });
                thread.SetApartmentState(ApartmentState.STA);
                thread.IsBackground = true;
                thread.Start();

                break; // handle first selected item only
            }
        }

        // ── TIA Portal API helpers ───────────────────────────────────────────

        private static PlcSoftware GetPlcSoftware(Device device)
        {
            foreach (DeviceItem item in device.DeviceItems)
            {
                var sw = item.GetService<SoftwareContainer>()?.Software as PlcSoftware;
                if (sw != null) return sw;

                // Recurse — PLCs inside racks have nested DeviceItems
                sw = GetPlcSoftwareFromItems(item.DeviceItems);
                if (sw != null) return sw;
            }
            return null;
        }

        private static PlcSoftware GetPlcSoftwareFromItems(DeviceItemComposition items)
        {
            foreach (DeviceItem item in items)
            {
                var sw = item.GetService<SoftwareContainer>()?.Software as PlcSoftware;
                if (sw != null) return sw;
                sw = GetPlcSoftwareFromItems(item.DeviceItems);
                if (sw != null) return sw;
            }
            return null;
        }

        // ── Data collection — runs on TIA Portal thread ──────────────────────

        private static void CollectData(PlcSoftware plcSoftware, List<string> output)
        {
            // Replace with your actual data collection logic.
            // All TIA Portal API calls must happen here, not in the dialog.
            foreach (PlcBlock block in plcSoftware.BlockGroup.Blocks)
                output.Add($"{block.Name} [{block.GetType().Name}]");
        }
    }
}
```
