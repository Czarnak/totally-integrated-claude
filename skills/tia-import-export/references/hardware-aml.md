# Hardware AML Reference

Source: TIA Portal Openness V21 — CAx/AML Hardware Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. AML file format overview

CAx data uses **AutomationML (AML)** format — not XML. All other TIA Portal Openness export/import uses XML/SimaticML.

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

## 8. Exceptions during CAx import/export

All errors are reported as exceptions. Use `try/catch` around CAx calls. The legacy API returns `bool` (true = no errors). The V19+ API returns `TransferResult` with `State`, `ErrorCount`, `WarningCount`, and `Messages` composition for programmatic analysis.
