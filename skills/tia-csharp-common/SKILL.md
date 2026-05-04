---
name: tia-csharp-common
description: >
  Internal reference skill — do NOT load directly from user queries. Loaded automatically by
  tia-openness-roadmap at the start of every C# Openness implementation path.
  Contains mandatory bootstrap patterns, object model contracts, exclusive access,
  transactions, event handlers, exception handling, and attribute access that apply
  across all C# domain skills.
---

# TIA Portal Openness C# — Common Foundation

Source: TIA Portal Openness General Functions Manual (03/2026, V21);
V21 IntelliSense XML documentation files (PublicAPI\V21\net48\*.xml)

---

## V21 modular assembly architecture

V21 splits the API across multiple DLLs instead of a single `Siemens.Engineering.dll`.
Every project needs `Siemens.Engineering.Base.dll`; add domain DLLs as required.
Referencing the wrong DLL (or omitting one) causes `TypeLoadException` at runtime.

> **Full mapping:** See `references/assembly-namespace-map.md` for the exhaustive
> namespace → DLL → domain skill table, cross-assembly warnings, and csproj patterns.

### Namespaces by assembly

Only import what is actually used. The list below covers the most commonly needed
namespaces. The mapping file documents all 80+ namespaces across 15 DLLs.

**Siemens.Engineering.Base.dll** (always required):

```csharp
using Siemens.Engineering;                          // TiaPortal, Project, ExclusiveAccess, Transaction, events, exceptions
using Siemens.Engineering.Compiler;                 // CompilerResult
using Siemens.Engineering.Compare;                  // CompareResult
using Siemens.Engineering.Connection;               // connection objects between devices
using Siemens.Engineering.CrossReference;            // cross-reference queries
using Siemens.Engineering.Download;                 // DownloadProvider, DownloadConfiguration
using Siemens.Engineering.Download.Configurations;  // device-specific download configs (★ also in Step7 + Startdrive)
using Siemens.Engineering.HW;                       // Device, DeviceItem, Subnet, Node, IoSystem (★ also in Step7)
using Siemens.Engineering.HW.CommunicationConnections; // communication connection configs
using Siemens.Engineering.HW.Extensions;            // extension methods on HW objects
using Siemens.Engineering.HW.Features;              // SoftwareContainer, NetworkInterface (★ also in Step7)
using Siemens.Engineering.HW.HardwareCatalog;       // hardware catalog access
using Siemens.Engineering.HW.Utilities;             // HW utility helpers
using Siemens.Engineering.Library;                  // ProjectLibrary, GlobalLibrary
using Siemens.Engineering.Library.MasterCopies;     // MasterCopy, MasterCopyFolder
using Siemens.Engineering.Library.Types;            // LibraryType, LibraryTypeVersion
using Siemens.Engineering.Multiuser;                // LocalSession, ProjectServer
using Siemens.Engineering.Online;                   // OnlineProvider, OnlineState
using Siemens.Engineering.Online.Configurations;    // GoOnlineConfiguration, GoOfflineConfiguration
using Siemens.Engineering.Security;                 // SecurityController, certificates
using Siemens.Engineering.Settings;                 // TIA Portal settings
using Siemens.Engineering.Umac;                     // UmacRole, UmacUser, UmacFunctionRight
using Siemens.Engineering.Upload;                   // UploadProvider
using Siemens.Engineering.Upload.Configurations;    // upload configs (★ also in Startdrive)
using Siemens.Engineering.VersionControl;           // workspace and version control providers
```

**Siemens.Engineering.Step7.dll** (PLC operations):

```csharp
using Siemens.Engineering.Cax;                      // CAx import/export
using Siemens.Engineering.SW;                       // PlcSoftware
using Siemens.Engineering.SW.Alarm;                 // PlcAlarm, AlarmClass
using Siemens.Engineering.SW.Alarm.TextLists;       // alarm text lists
using Siemens.Engineering.SW.Blocks;                // PlcBlock, OB, FB, FC, GlobalDB, InstanceDB, ArrayDB
using Siemens.Engineering.SW.Blocks.Interface;      // block interface access
using Siemens.Engineering.SW.ExternalSources;       // PlcExternalSource
using Siemens.Engineering.SW.Loader;                // program loader
using Siemens.Engineering.SW.OpcUa;                 // OPC UA server interface
using Siemens.Engineering.SW.Supervision;           // supervision alarms, operator messages
using Siemens.Engineering.SW.Tags;                  // PlcTagTable, PlcTag, PlcConstant
using Siemens.Engineering.SW.TechnologicalObjects;  // technology objects
using Siemens.Engineering.SW.TechnologicalObjects.Motion; // motion axes (★ also in Startdrive)
using Siemens.Engineering.SW.Types;                 // PlcType, PlcStruct
using Siemens.Engineering.SW.Units;                 // SoftwareUnit, CodeBlock, DataBlock
using Siemens.Engineering.SW.WatchAndForceTables;   // PlcWatchTable, PlcForceTable
```

**Siemens.Engineering.WinCC.dll** (classic HMI):

```csharp
using Siemens.Engineering.Hmi;                      // HmiTarget (★ also in WinCC.Extension)
using Siemens.Engineering.Hmi.Alarm;                // DiscreteAlarm, AnalogAlarm
using Siemens.Engineering.Hmi.Communication;        // HmiConnection
using Siemens.Engineering.Hmi.Cycle;                // cycle settings
using Siemens.Engineering.Hmi.Dynamic;              // dynamization
using Siemens.Engineering.Hmi.Faceplate;            // faceplate types
using Siemens.Engineering.Hmi.Globalization;         // language/translation
using Siemens.Engineering.Hmi.Logging;              // DataLog, LoggingTag
using Siemens.Engineering.Hmi.Recipe;               // Recipe, RecipeElement
using Siemens.Engineering.Hmi.RuntimeScripting;     // VBScript
using Siemens.Engineering.Hmi.Screen;               // HmiScreen, ScreenTemplate, ScreenPopup + all elements
using Siemens.Engineering.Hmi.Tag;                  // HmiTag, HmiTagTable
using Siemens.Engineering.Hmi.TextGraphicList;      // text/graphic lists
using Siemens.Engineering.Hmi.Theming;              // HMI themes
```

**Siemens.Engineering.Startdrive.dll** (SINAMICS drives):

```csharp
using Siemens.Engineering.MC.Drives;                // DriveObject, DriveParameter, Telegram
using Siemens.Engineering.MC.Drives.DFI;            // DriveFunctionInterface, Commissioning
using Siemens.Engineering.MC.Drives.Enums;          // drive enumerations
using Siemens.Engineering.MC.Drives.SecurityObjects; // drive encryption, UMAC
```

**Siemens.Engineering.Safety.dll** (F-system):

```csharp
using Siemens.Engineering.Safety;                   // safety operations
```

---

## Assembly resolver — MANDATORY (standalone Openness apps)

> **Not needed for Add-Ins.** TIA Portal loads Add-In assemblies via its own loader.
> This section applies only to standalone console/desktop Openness applications.

### V21 installation paths

- **Registry key:** `HKLM\SOFTWARE\Siemens\Automation\InstalledApps\Totally Integrated Automation Portal V21` → value `INSTALLPATH`
- **Binary path:** `C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\net48\`
- **Manifest schemas:** `C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\Schemas\`

### Resolver pattern

The `AssemblyResolve` event **must** be registered before any Openness type is referenced.
This includes method parameters, return types, and class properties — not just method bodies.

Recommended pattern: register in a static constructor of `Program`, then move all Openness
code to a separate class so the resolver is active before those classes are loaded.

```csharp
internal static class Program
{
    // Register resolver at earliest possible point
    static Program()
    {
        AppDomain.CurrentDomain.AssemblyResolve += OnAssemblyResolve;
    }

    public static void Main()
    {
        // All Openness code must be in a separate class
        var app = new OpennessApp();
        app.Run();
    }

    private static Assembly OnAssemblyResolve(object sender, ResolveEventArgs args)
    {
        // Read install path from registry (recommended) or hardcode for simple tools
        string opennessFolder = GetOpennessInstallPath(); // implement per project
        AssemblyName requestedName = new AssemblyName(args.Name);
        string filePath = Path.Combine(opennessFolder,
            string.Concat(requestedName.Name, ".dll"));

        if (!requestedName.Name.StartsWith("Siemens.Engineering.") ||
            !File.Exists(filePath))
            return null;

        Assembly loaded = Assembly.LoadFrom(filePath);
        if (requestedName.FullName != loaded.GetName().FullName)
            throw new FileNotFoundException(
                "TIA Portal Openness version does not match", filePath);

        return loaded;
    }
}
```

**Key rules:**

- `Copy Local: False` (`<Private>False</Private>`) must be set for every `Siemens.Engineering` assembly reference.
- V21 uses modular DLLs: `Base.dll` is always needed; add `Step7.dll`, `WinCC.dll`,
  `Startdrive.dll`, etc. per task. The resolver handles all of them automatically
  because it matches any name starting with `Siemens.Engineering.`.
- The recommended approach reads the install path from the registry key
  `HKLM\SOFTWARE\Siemens\Automation\InstalledApps\Totally Integrated Automation Portal V21`
  (value `INSTALLPATH`) rather than hardcoding it.

**Registry-based path discovery:**

```csharp
private static string GetOpennessInstallPath()
{
    using (var key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey(
        @"SOFTWARE\Siemens\Automation\InstalledApps\Totally Integrated Automation Portal V21"))
    {
        string installPath = key?.GetValue("INSTALLPATH") as string;
        if (string.IsNullOrEmpty(installPath))
            throw new FileNotFoundException("TIA Portal V21 installation not found in registry.");
        return Path.Combine(installPath, @"PublicAPI\V21\net48");
    }
}
```

**Alternative — app.config:**
For stable installations where the path is known at build time, an `app.config` file with
`<assemblyBinding>` / `<codeBase>` entries is a simpler option that requires no code.
Use the `AssemblyResolve` event for tools that need to discover the install path at runtime.

---

## TiaPortal instantiation

Always use a `using` statement so the session is disposed on exit or exception:

```csharp
internal class OpennessApp
{
    public void Run()
    {
        using (TiaPortal tiaPortal = new TiaPortal(TiaPortalMode.WithUserInterface))
        {
            // All Openness work goes here
        }
        // TIA Portal is disposed (not necessarily closed) after this point
    }
}
```

**Modes:**

- `TiaPortalMode.WithUserInterface` — starts or attaches with visible GUI
- `TiaPortalMode.WithoutUserInterface` — headless, suitable for automation pipelines

**Attaching to a running instance:**

```csharp
// Attach to the first running TIA Portal process of this Openness version
TiaPortal tiaPortal = TiaPortal.GetProcesses().First().Attach();
```

Use `GetProcesses()` when TIA Portal is already open and you do not want to start a new
instance. Returns only processes from the same Openness version as the loaded assembly.

**Dispose vs. close:**

- If started headless and no other Openness client is attached, `Dispose()` closes TIA Portal.
- If started with GUI or other clients are attached, `Dispose()` only disconnects.
- After dispose, any further API access throws `NonRecoverableException`.

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

---

## Exclusive access

Highly recommended for all non-trivial operations. Signals TIA Portal that a controlled
activity is in progress and displays a dialog to the user.

```csharp
using (ExclusiveAccess exclusiveAccess = tiaPortal.ExclusiveAccess("Generating project"))
{
    // All Openness operations here run under exclusive access

    // Optionally update the displayed message during long operations
    exclusiveAccess.Text = "Compiling software";
    // ...
    exclusiveAccess.Text = "Downloading to PLC";
}
// Exclusive access is released on dispose
```

**Rules:**

- Only one `ExclusiveAccess` can exist at a time — a second attempt throws a recoverable
  exception while the first is still active.
- Setting `exclusiveAccess.Text = string.Empty` or `null` clears the displayed message.

---

## Transactions

Group multiple modifications into a single undo unit. Requires an active `ExclusiveAccess`.

```csharp
using (ExclusiveAccess exclusiveAccess = tiaPortal.ExclusiveAccess("Bulk edit"))
{
    using (Transaction transaction = exclusiveAccess.Transaction(project, "Create blocks"))
    {
        // Perform all modifications
        project.DeviceGroups.Create("Line_1");
        project.DeviceGroups.Create("Line_2");

        // MANDATORY: call CommitOnDispose() to persist changes
        // If this line is never reached, the transaction is rolled back
        transaction.CommitOnDispose();
    }
}
```

**Rollback rules — critical:**

- If `CommitOnDispose()` is never called → always rolled back on dispose.
- If an exception occurs **before** `CommitOnDispose()` → rolled back, even inside try/catch.
- If an exception occurs **after** `CommitOnDispose()` → changes are committed.

**Not allowed inside a transaction:**
Project open, save, close, archive, retrieve, and some compile/import/export operations
cannot be called while a transaction is active.

---

## Exception handling

Two top-level categories:

| Category | Base type | Behaviour |
|---|---|---|
| Recoverable | `Siemens.Engineering.EngineeringException` | API call failed; session remains valid |
| Non-recoverable | `Siemens.Engineering.NonRecoverableException` | TIA Portal closed; restart required |

**Recoverable subtypes:**

| Type | Typical cause |
|---|---|
| `EngineeringSecurityException` | Missing access rights |
| `EngineeringObjectDisposedException` | Object no longer exists (e.g. deleted) |
| `EngineeringNotSupportedException` | Attribute or operation not available on this object |
| `EngineeringTargetInvocationException` | General failure despite a valid API call |
| `EngineeringRuntimeException` | Runtime error, e.g. invalid cast |
| `EngineeringOutOfMemoryException` | Insufficient resources in TIA Portal instance |
| `EngineeringUserAbortException` | Operation cancelled by the user (e.g. import dialog) |
| `EngineeringDelegateInvocationException` | Exception thrown inside a caller-supplied delegate |
| `MissingProductsException` | Project requires TIA Portal products/packages not installed (V18+) |

**Recommended catch order:**

```csharp
try
{
    // Openness work
}
catch (EngineeringSecurityException ex)
{
    Console.WriteLine($"Access denied: {ex.Message}");
}
catch (EngineeringObjectDisposedException ex)
{
    Console.WriteLine($"Object disposed: {ex.Message}");
}
catch (EngineeringNotSupportedException ex)
{
    Console.WriteLine($"Not supported: {ex.MessageData.Text}");
    foreach (ExceptionMessageData detail in ex.DetailMessageData)
        Console.WriteLine($"  Detail: {detail.Text}");
}
catch (MissingProductsException ex)
{
    Console.WriteLine($"Missing products: {ex.Message}");
}
catch (EngineeringTargetInvocationException)
{
    throw; // Do not swallow — rethrow for caller to handle
}
catch (EngineeringException)
{
    throw; // Do not swallow general engineering exceptions
}
catch (NonRecoverableException ex)
{
    Console.WriteLine($"Fatal — TIA Portal closed: {ex.Message}");
    // Must restart TIA Portal; the session is gone
}
```

---

## Project open mode

When opening multiple projects or working in multiuser environments:

```csharp
// Primary — visible in project navigation, full read-write access
Project primary = tiaPortal.Projects.Open(
    new FileInfo(path), umacDelegate, ProjectOpenMode.Primary);

// Secondary — hidden from UI, always read-only regardless of user rights
Project secondary = tiaPortal.Projects.Open(
    new FileInfo(path), null, ProjectOpenMode.Secondary);

bool isPrimary = secondary.IsPrimary; // false
```

**Rules:**

- Only one primary project per TIA Portal instance.
- Secondary projects do not need a primary project to be open first.
- A user with write rights to a UMAC-protected project still gets read-only access when
  opening it as secondary.

---

## Object model contracts

### Composition methods

Most engineering objects are accessed through compositions. Available methods:

| Method | Behaviour |
|---|---|
| `Create(id, ...)` | Creates and adds a new instance. Signature varies per composition. |
| `Find(id)` | Finds by identifier. **Non-recursive** — searches current level only. |
| `GetEnumerator()` | Used implicitly in `foreach` loops. |
| `Contains(obj)` | Returns `bool` — checks if object is in the composition. |
| `IndexOf(obj)` | Returns `int` index of the object in the composition. |
| `Import(path, ImportOptions)` | Available on compositions that support import. `ImportOptions`: `None` or `Overwrite`. |
| `Delete(obj)` | Removes and deletes the instance. |

Not all methods are available on every composition — check domain skills.

### Object equality

```csharp
// Reference equality (same .NET object reference)
bool sameRef = (objA == objB);

// TIA Portal identity equality (same engineering object, possibly different references)
bool sameObj = System.Object.Equals(objA, objB);
```

Use `System.Object.Equals()` when comparing objects retrieved through different navigation
paths that may represent the same underlying engineering object.

### DirectoryInfo / FileInfo — absolute paths only

All `DirectoryInfo` and `FileInfo` instances passed to Openness **must** use absolute paths.
Relative paths cause an exception at runtime.

```csharp
// Correct
var dir = new DirectoryInfo(@"C:\Projects\MyProject\Export");

// Wrong — will throw
var dir = new DirectoryInfo(@"Export");
```

---

## Bulk attribute access

Useful for dynamic tooling or when setting multiple attributes efficiently on HW objects.

### Read all attributes

```csharp
// Get names of all available attributes
IList<EngineeringAttributeInfo> infos =
    ((IEngineeringObject)deviceItem).GetAttributeInfos();

// Read all readable attributes in one call
IList<string> names = infos.Select(i => i.Name).ToList();
IList<object> values = ((IEngineeringObject)deviceItem).GetAttributes(names);
```

### Filtered read by access mode

```csharp
// AttributeAccessOptions: None, ReadOnly, WriteOnly, ReadWrite
IReadOnlyList<KeyValuePair<string, object>> readableAttrs =
    deviceItem.GetAttributes(AttributeAccessOptions.ReadOnly);
```

### Bulk write (HW objects only — provides callback)

```csharp
var pairs = new List<KeyValuePair<string, object>>
{
    new KeyValuePair<string, object>("Name", "NewModuleName"),
    new KeyValuePair<string, object>("Comment", "Auto-generated")
};

// Overload with callback fires after each attribute is set
deviceItem.SetAttributes(pairs, (name, val, ex) =>
{
    if (ex != null)
        Console.WriteLine($"Failed to set {name}: {ex.Message}");
});

// Overload without callback — for non-HW objects
((IEngineeringObject)someObject).SetAttributes(pairs);
```
