# Hardware AML Reference

Source: TIA Portal Openness V21 — CAx/AML Hardware Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. AML file format overview

CAx data uses **AutomationML (AML)**. AML is XML-based, but it is a distinct exchange model and `.aml` workflow from SimaticML object export/import. Do not pass an AML file to a generic SimaticML composition import.

Export/import is supported at:

- **Project level** — all devices in the project
- **Device level** — single device

**Not supported** for export/import: HMI devices (except push button/key panels), drives, certain SCALANCE device items.

---

## 2. Access the CaxProvider service

```csharp
// Single project
Project project = tiaPortal.Projects.Open(...);
CaxProvider caxProvider = project.GetService<CaxProvider>();
if (caxProvider != null)
{
    // Perform CAx export/import
}

// Multiuser — local session
MultiuserProject project = tiaPortal.LocalSessions.Open(...).Project;
CaxProvider caxProvider = project.GetService<CaxProvider>();

// Multiuser — server project
MultiuserProject project = tiaPortal.LocalSessions.OpenServerProject(...).Project;
CaxProvider caxProvider = project.GetService<CaxProvider>();
```

> CAx Import APIs cannot be used within exclusive access — an engineering exception is thrown.

---

## 3. Export CAx data at project level

**Legacy API (returns bool):**

```csharp
caxProvider.Export(project, new FileInfo(@"D:\Temp\ProjectExport.aml"),
    new FileInfo(@"D:\Temp\ProjectExport_Log.log"));
```

**V19+ API (returns TransferResult):**

```csharp
private static void CaxTransferAtProjectLevel(ProjectBase project, CaxProvider caxProvider)
{
    FileInfo exportFilePath = new FileInfo(@"D:\temp\ExportFile.aml");
    TransferResult projectExportResult = caxProvider.Export(project, exportFilePath);
    PrintCaxResult(projectExportResult);
}

private static void PrintCaxResult(TransferResult result)
{
    Console.WriteLine($"CAx result summary: {result.State} (errors: {result.ErrorCount}, warnings: {result.WarningCount})");
    foreach (TransferResultMessage message in result.Messages)
        Console.WriteLine($"  {message.State} {message.Message} {message.DateTime}");

    if (result.State == TransferResultState.Error || result.ErrorCount > 0)
        throw new InvalidOperationException("CAx transfer completed with errors; inspect result messages and do not save.");
}
```

`TransferResultState` values: `Success`, `Information`, `Warning`, `Error`.

---

## 4. Export CAx data at device level

**Legacy API:**

```csharp
caxProvider.Export(device, new FileInfo(@"D:\Temp\DeviceExport.aml"),
    new FileInfo(@"D:\Temp\DeviceExport_Log.log"));
```

**V19+ API (returns TransferResult):**

```csharp
private static void CaxTransferAtDeviceLevel(ProjectBase project, CaxProvider caxProvider)
{
    FileInfo exportFilePath = new FileInfo(@"D:\temp\ExportFile.aml");
    Device deviceToExport = project.Devices.Find("Station_1");
    TransferResult deviceExportResult = caxProvider.Export(deviceToExport, exportFilePath);
    PrintCaxResult(deviceExportResult);
}
```

---

## 5. Import CAx data

**Legacy API:**

```csharp
caxProvider.Import(new FileInfo(@"D:\Temp\ProjectImport.aml"),
    new FileInfo(@"D:\Temp\ProjectImport_Log.log"),
    CaxImportOptions.MoveToParkingLot);
```

**V19+ API (returns TransferResult):**

```csharp
private static void ImportCaxTransfer(ProjectBase project, CaxProvider caxProvider)
{
    FileInfo importFilePath = new FileInfo(@"D:\temp\ImportFile.aml");
    CaxImportOptions importOption = CaxImportOptions.RetainTiaDevice;
    TransferResult importResult = caxProvider.Import(importFilePath, importOption);
    PrintCaxResult(importResult);
}
```

**`CaxImportOptions` conflict resolution:**

| Option | Description |
|---|---|
| `MoveToParkingLot` | Retain conflicting devices in project; import CAx devices into parking lot folder |
| `RetainTiaDevice` | Retain conflicting devices in project; skip importing those from CAx |
| `OverwriteTiaDevice` | Overwrite conflicting devices in project with CAx version |

---

## 6. AML type identifiers

Devices in AML files are identified by `TypeIdentifier` (article number) or `TemplateIdentifier` (library-based). From V17 onwards, normalized format of TypeIdentifier is also supported.

- Import of modules with `TypeIdentifier` fails if the required product license (e.g. Step7) is missing.
- Import of modules with `TemplateIdentifier` succeeds even without a product license.

---

## 7. Structure of CAx data

The AML file uses the AutomationML structure with `InternalElement`, `Attribute`, `SupportedRoleClass`, `RefRoleClassPath`, etc. Key AML elements map to TIA Portal concepts:

- `InternalElement` → device, rack, module
- `Attribute` → device properties (plant designation, location identifier, etc.)
- `RefPartnerSideA/B` → connection endpoints (for IO-Link, PROFINET topology, etc.)

Pruned AML exports contain only modified/non-default attributes (analogous to `ExportOptions.None` for XML).

---

## 8. Exceptions and results during CAx import/export

Use `try/catch` for invocation-level failures. Do not assume that every transfer failure is thrown: the V19+ overload returns a `TransferResult`, so treat `TransferResultState.Error` or a nonzero `ErrorCount` as failure and inspect the recursive `Messages` composition before deciding whether to save. The legacy overload returns `bool` (`true` means no reported errors) and writes the supplied log file.

The result-state members are `TransferResultState.Success`,
`TransferResultState.Information`, `TransferResultState.Warning`, and
`TransferResultState.Error`. Recursively traverse each
`TransferResultMessage.Messages` collection; preserve `DateTime`, `Message`, state,
and counts. A top-level success must not hide a nested error.

---

## Installed V21 CAx type catalogue

## 🛠️ Siemens.Engineering.Cax.CaxImportOptions

Conflict policy enum: `MoveToParkingLot`, `OverwriteTiaDevice`, or
`RetainTiaDevice`.

## 🛠️ Siemens.Engineering.Cax.CaxProvider

Project service providing device/project AML `Export(...)` overloads and AML
`Import(...)` overloads with `CaxImportOptions`.

## 🛠️ Siemens.Engineering.Cax.TransferResult

Transfer result with `State`, `ErrorCount`, `WarningCount`, and recursive `Messages`.

## 🛠️ Siemens.Engineering.Cax.TransferResultMessage

One transfer message with `DateTime`, `Message`, `State`, counts, and child `Messages`.

## 🛠️ Siemens.Engineering.Cax.TransferResultMessageComposition

Read-only composition of `TransferResultMessage` values.

## 🛠️ Siemens.Engineering.Cax.TransferResultState

Result-state enum: `Success`, `Information`, `Warning`, and `Error`.
