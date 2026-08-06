# Threading model and status callback rules

---

## Add-In execution lifetime — mandatory

An Add-In execution instance cannot be used after its callback has completed.
TIA Portal cancels tasks that keep running on background threads after the
execution ends. Therefore, a detached STA thread that displays a WinForms
dialog after the callback returns is **not** a supported lifetime extension.

Use TIA Portal's `MessageBoxProvider` for notifications and confirmations that
belong to the callback. Keep engineering API access and any short operation
inside the execution. Do not retain engineering objects in a dialog,
background task, static field, or child process.

### Diagnosing silent failures — file logging

Because the watchdog kill produces no exception and no UI, the only way to
diagnose startup and callback failures during development is a side-channel log
file. Write to `%TEMP%` so it works from the partial-trust sandbox:

```csharp
private static readonly string LogPath =
    Path.Combine(Path.GetTempPath(), "MyAddIn.log");

private static void Log(string msg)
{
    try
    {
        File.AppendAllText(LogPath,
            $"{DateTime.Now:HH:mm:ss.fff} {msg}{Environment.NewLine}");
    }
    catch { /* never let logging crash the Add-In */ }
}
```

**Log `ex.ToString()`, not `ex.Message`.** Add-Ins are invoked via reflection,
so the outermost exception is usually `TargetInvocationException` whose
`.Message` is the generic "Exception has been thrown by the target of an
invocation." The actionable detail lives in `InnerException`, which only
`ToString()` includes.

Wrap top-level entry points (constructor, `BuildContextMenuItems`, every action
and status callback) in `try { … } catch (Exception ex) { Log(ex.ToString()); throw; }`
during development. Remove or downgrade once the Add-In stabilises.

### Notifications and confirmations

```csharp
private void OnDoWork(MenuSelectionProvider<Device> provider)
{
    MessageBoxProvider messageBox =
        m_TiaPortal.GetService<MessageBoxProvider>();

    foreach (Device device in provider.GetSelection())
    {
        var results = new List<string>();
        try
        {
            CollectData(device, results);
            messageBox.ShowNotification(
                NotificationIcon.Success,
                "My Add-In",
                $"Collected {results.Count} values from {device.Name}.");
        }
        catch (Exception ex)
        {
            messageBox.ShowNotification(NotificationIcon.Error, "My Add-In",
                $"Data collection failed: {ex.Message}");
        }
        break;
    }
}
```

### Long-lived or custom UI

For a long-running task or custom UI that must outlive the callback, start a
**separate process**. The publisher configuration must declare
`Siemens.Engineering.AddIn.Permissions.ProcessStartPermission`, and the Add-In
must reference `Siemens.Engineering.AddIn.Utilities.dll`.

```csharp
Siemens.Engineering.AddIn.Utilities.Process.Start(
    "MyUiHost.exe",
    "--input results.json");
```

Transfer only plain serialized data. A child process does not inherit the
Add-In's engineering objects or connection. If it needs TIA Portal access, it
must establish and own a separate Openness connection and lifecycle.

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
