---
name: tia-csharp-common
description: Internal reference skill — do NOT load directly from user queries.
license: MIT
---

# TIA Portal Openness C# — Common Foundation

Source: TIA Portal Openness General Functions Manual (03/2026, V21);
V21 IntelliSense XML documentation files (PublicAPI\V21\net48\*.xml)

---

## V21 modular assembly architecture

V21 splits the API across multiple DLLs instead of a single `Siemens.Engineering.dll`.
Every project needs `Siemens.Engineering.Base.dll`; add domain DLLs as required.
Referencing the wrong DLL (or omitting one) causes `TypeLoadException` at runtime.

> **Full mapping:** See `references/assembly-namespace-map.md` for the V21
> namespace → DLL → domain skill table, cross-assembly warnings, and csproj patterns.

### Namespaces by assembly

Only import what is actually used. Commented `using` blocks for each assembly
(Base, Step7, WinCC, Startdrive, Safety) are in `references/assembly-namespace-map.md`
under "Common `using` blocks by assembly".

---

## Assembly loading — mandatory for standalone Openness apps

> **Not needed for Add-Ins.** TIA Portal loads Add-In assemblies via its own loader.
> This section applies only to standalone console/desktop Openness applications.

### V21 installation paths

- **Registry key:** `HKLM\SOFTWARE\Siemens\Automation\InstalledApps\Totally Integrated Automation Portal V21` → value `INSTALLPATH`
- **Binary path:** `C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\net48\`
- **Manifest schemas:** `C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\Schemas\`

### Resolver pattern

When using the `AssemblyResolve` approach, register the event before any Openness type is
referenced. This includes method parameters, return types, and class properties — not just
method bodies. A correctly configured `app.config` binding is an alternative.

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

- `TiaPortalMode.WithUserInterface` — starts a new TIA Portal instance with a visible GUI
- `TiaPortalMode.WithoutUserInterface` — starts a new headless instance, suitable for automation pipelines

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
- After disposal, the connection is no longer valid. A later API call after the TIA Portal
  process is closed externally throws `NonRecoverableException`.

---

## Service providers and event handlers

Full patterns: `references/portal-services-and-events.md` (Add-In `MessageBoxProvider`,
`ProgressProvider`, `FeedbackProvider` via `GetService<T>()`, and the `Disposed`,
`Notification`, `Confirmation`, `Authentication` events on `TiaPortal`).

Rules that always apply:

- `GetService<T>()` returns `null` in Add-In status callbacks (`OnUpdateStatus`);
  use services only in action callbacks.
- Unsubscribe every `TiaPortal` event handler in a `finally` block.
- In `Confirmation`, `e.Result` **must** be `"Yes"`, `"YesToAll"` or `"No"`; any other
  value throws.
- `Authentication` (V17+) fires only for UMAC-protected projects; set
  `e.AuthenticationTypeProvider` (`DesktopSso`, `Anonymous`, `Interactive`, `Credentials`).

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

- If `CommitOnDispose()` is never called → rolled back on dispose.
- If an exception occurs at any point before the transaction is disposed → rolled back,
  including when `CommitOnDispose()` was already requested or the exception was caught.
- After an `EngineeringTargetInvocationException`, a later `CommitOnDispose()` request can
  itself raise a recoverable exception; check `CanCommit` and do not assume persistence.

**Not allowed inside a transaction:**
Compile, go online/offline, ProjectText import/export, opening or closing a global library,
project create/open/open-with-upgrade/save/save-as/close, and changing a TIA Portal setting.
These calls raise a recoverable exception while a transaction is active.

---

## Destructive-operation safety

These rules are mandatory for generated C# Openness code:

- **Never bare `.Delete()`**. Any destructive operation must be inside an active
  `ExclusiveAccess` scope and a `Transaction` when the API permits transactions.
- Use `using` blocks for `ExclusiveAccess`, `Transaction`, `TiaPortal`, and other disposable
  Openness objects so rollback and release behavior is explicit. Close projects explicitly
  according to lifecycle ownership; `Project` is not an `IDisposable` object.
- Call `transaction.CommitOnDispose()` only after every validation and mutation in
  the transaction has succeeded.
- Run or request a compile check after generated block, tag, hardware, or HMI
  changes. Do not present generated project changes as deployable until that check
  passes.
- If an API refuses to run inside a transaction, state that limitation explicitly,
  use the narrowest possible `ExclusiveAccess` scope, and require a preview or
  user confirmation before the destructive call.

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
