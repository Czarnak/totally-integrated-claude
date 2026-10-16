# TiaPortal Service Providers and Event Handlers

Source: TIA Portal Openness General Functions Manual (03/2026, V21).
Loaded from `tia-csharp-common` when Add-In UI services or `TiaPortal` events are needed.

---

## Service providers — `GetService<T>()`

V21 uses a service-provider pattern for UI interactions. Call `GetService<T>()` on the
`TiaPortal` instance to obtain a service. Available services depend on the runtime context.

### Add-In runtime services

These services are available only when code runs inside a TIA Portal Add-In:

| Service type | Namespace | Purpose |
|---|---|---|
| `MessageBoxProvider` | `Siemens.Engineering.AddIn` | Display notification/confirmation dialogs in TIA Portal |
| `ProgressProvider` | `Siemens.Engineering.AddIn` | Display a progress bar; check `IsCancelRequested` for cancellation |
| `FeedbackProvider` | `Siemens.Engineering.AddIn` | Log messages to TIA Portal's Inspector window (General Info tab) |

```csharp
// MessageBoxProvider — notification and confirmation dialogs
var msgBox = tiaPortal.GetService<MessageBoxProvider>();
msgBox?.ShowNotification(NotificationIcon.Information, "Title", "Message text");
msgBox?.ShowNotification(NotificationIcon.Warning, "Title", "Message", "Detail text");

// Confirmation dialog — defaultChoice is the pre-selected button; return value is user's choice
ConfirmationResult result = msgBox.ShowConfirmation(
    ConfirmationIcon.General, "Title", "Proceed?",
    ConfirmationChoices.Yes | ConfirmationChoices.No, ConfirmationResult.Yes);
if (result == ConfirmationResult.No) return;

// ProgressProvider — progress bar with cancellation
var progress = tiaPortal.GetService<ProgressProvider>();
progress?.Update("Step description", "Detail text");
if (progress?.IsCancelRequested == true)
{
    // User requested cancellation — clean up and return
}

// FeedbackProvider — log to Inspector window (General Info tab)
var feedback = tiaPortal.GetService<FeedbackProvider>();
feedback?.Log(NotificationIcon.Information, "Operation completed successfully.");
feedback?.Log(NotificationIcon.Warning, "Skipped 3 items due to missing data.");
```

**Important:** In Add-In status callbacks (the `OnUpdateStatus` delegate passed to
`AddActionItem`), `GetService<T>()` returns `null`. Only use services in action
callbacks where COM access is fully available.

---

## Event handlers

Four events are available on `TiaPortal`. Always unsubscribe in a `finally` block.

### Disposed

Fires when TIA Portal closes while the Openness client is still connected.

```csharp
tiaPortal.Disposed += OnDisposed;
try
{
    // ... work ...
}
finally
{
    tiaPortal.Disposed -= OnDisposed;
}

private static void OnDisposed(object sender, EventArgs e)
{
    // TIA Portal was closed externally — clean up and exit
}
```

### Notification

Fires for informational messages that require only an acknowledgment (OK).

```csharp
tiaPortal.Notification += OnNotification;
try { /* ... */ }
finally { tiaPortal.Notification -= OnNotification; }

private static void OnNotification(object sender, NotificationEventArgs e)
{
    Console.WriteLine($"[TIA Notification] {e.Text}");
    // No response required — notification is auto-acknowledged
}
```

### Confirmation

Fires for dialogs that require a decision. **Must** set `e.Result` to one of:
`"Yes"`, `"YesToAll"`, or `"No"`. Any other value throws an exception.

Auto-confirm pattern (most common in automation):

```csharp
tiaPortal.Confirmation += OnConfirmation;
try { /* ... */ }
finally { tiaPortal.Confirmation -= OnConfirmation; }

private static void OnConfirmation(object sender, ConfirmationEventArgs e)
{
    e.Result = "Yes";
}
```

### Authentication (V17+)

Fires when opening a UMAC-protected project. Use to specify the authentication method
instead of passing credentials via `UmacDelegate`. Only fires for protected projects.

```csharp
tiaPortal.Authentication += OnAuthentication;
try { /* open project ... */ }
finally { tiaPortal.Authentication -= OnAuthentication; }

private static void OnAuthentication(object sender, AuthenticationEventArgs e)
{
    // Choose one of: DesktopSso, Anonymous, Interactive, Credentials
    e.AuthenticationTypeProvider = AuthenticationTypeProvider.DesktopSso;
    // For Credentials mode, credentials are supplied separately via UmacDelegate
}
```

| `AuthenticationTypeProvider` | Behaviour |
|---|---|
| `DesktopSso` | Signs in with the current Windows user — no password prompt |
| `Anonymous` | Uses the anonymous user account — no password prompt |
| `Interactive` | Shows TIA Portal login dialog to the user |
| `Credentials` | Reads credentials from the supplied `UmacDelegate` |
