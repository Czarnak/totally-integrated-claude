# Portal Settings & Services Reference

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using System.Globalization;
using Siemens.Engineering;
using Siemens.Engineering.HW.Systemdiagnostics.Settings; // for SystemDiagnostics
```

---

## 1. TIA Portal general settings (TiaPortalSettingsFolder)

Access TIA Portal application-level settings through `tiaPortal.SettingsFolders`.
The `"General"` folder exposes two settings:

| Setting name | Type | r/w | Description |
|---|---|---|---|
| `"SearchInProject"` | `bool` | r/w | Enables/disables project search index creation |
| `"UserInterfaceLanguage"` | `CultureInfo` | r/w | Active UI language of TIA Portal |

```csharp
private static void ConfigurePortalSettings(TiaPortal tiaPortal)
{
    TiaPortalSettingsFolder generalFolder =
        tiaPortal.SettingsFolders.Find("General");

    // Read / write SearchInProject
    TiaPortalSetting searchSetting =
        generalFolder.Settings.Find("SearchInProject");
    bool searchEnabled = (bool)searchSetting.Value;
    searchSetting.Value = false; // disable search index

    // Read / write UI language
    TiaPortalSetting uiLangSetting =
        generalFolder.Settings.Find("UserInterfaceLanguage");
    CultureInfo currentLang = (CultureInfo)uiLangSetting.Value;
    uiLangSetting.Value = CultureInfo.GetCultureInfo("en-US");
}
```

> **Note:** The UI language affects how `HistoryEntry.Text` is returned.
> Headless (no-UI) sessions always return English regardless of this setting.

---

## 2. ObjectIdentifierProvider

Issues stable string identifiers for engineering objects that survive project
close/re-open cycles. Useful for bookmarking objects across Openness sessions.

**Supported types:** `Device`, `DeviceItem`, `CodeBlock` subtypes (`FB`, `FC`, `OB`,
`GlobalDB`, `InstanceDB`, `ArrayDB`), `PlcStruct`, `TechnologicalInstanceDB`,
`PlcTag`, `PlcUnit`.

```csharp
private static void UseObjectIdentifiers(Project project)
{
    ObjectIdentifierProvider idProvider =
        project.GetService<ObjectIdentifierProvider>();

    // Get a stable ID
    Device device = project.Devices.Find("PLC_1");
    string id = idProvider.GetIdentifier(device);
    Console.WriteLine($"Device ID: {id}");

    // Re-find the object from its ID (e.g. after project was closed and re-opened)
    Device found = idProvider.Find(id) as Device;

    // DeviceItem example
    DeviceItem cpuItem = device.DeviceItems.First();
    string itemId = idProvider.GetIdentifier(cpuItem);
}
```

**Exception behaviour:**
- `GetIdentifier(null)` → `EngineeringTargetInvocationException`
- `GetIdentifier(disposedObject)` → `EngineeringObjectDisposedException`
- `Find(null)` → `EngineeringTargetInvocationException`

---

## 3. System Diagnostics settings export/import

Export or import system diagnostics settings for the project as a `.dat` file.

```csharp
private static void ExportSystemDiagnostics(Project project, string path)
{
    var provider = project.GetService<SystemdiagnosticsSettingsDataProvider>();
    var result = provider.Export(new FileInfo(path));

    // result.State: Success, Warning, or Error
    Console.WriteLine($"Export: {result.State}");
}

private static void ImportSystemDiagnostics(Project project, string path)
{
    var provider = project.GetService<SystemdiagnosticsSettingsDataProvider>();
    var result = provider.Import(new FileInfo(path));

    Console.WriteLine($"Import: {result.State}");
}
```

**`SystemdiagnosticsSettingsExportImportResultState` enum:**

| Value | Meaning |
|---|---|
| `Success` | Operation completed without issues |
| `Warning` | Completed with warnings |
| `Error` | Operation failed |

---

## 4. Read-only project capabilities summary

When a project is opened with read-only credentials or as a secondary project,
the following Openness API subset is available:

**Always permitted:**
- All `GetAttribute(s)`, property getters
- `GetComposition`, `GetService`, `Find`, `foreach` enumeration
- `System.Object` methods (equality, hash, etc.)

**Also permitted (explicit non-modifying actions):**
- `Project.Close()`
- `PlcBlock.ShowInEditor()`
- `CaxProvider.Export(Device, ...)` / `CaxProvider.Export(Project, ...)`

Any write or modifying operation throws `EngineeringSecurityException`.
