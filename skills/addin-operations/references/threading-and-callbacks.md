# Threading model and status callback rules

---

## Threading model — mandatory for any UI shown from Add-In callbacks

### The silent failure

Add-In action callbacks (e.g. `OnScanBlocks`) run on **TIA Portal's UI thread**. Calling
`dialog.ShowDialog()` directly from a callback blocks that thread indefinitely while waiting
for the user to close the dialog. TIA Portal's watchdog detects that the callback never
returned and silently kills the operation. **There is no exception, no error message — the
Add-In appears to do nothing.**

### Required pattern: two-phase collect/show

```text
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
        PlcSoftware plcSw = obj as PlcSoftware;
        if (plcSw == null && obj is Device d)
        {
            plcSw = GetPlcSoftware(d);
        }

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
