# SUPERVISION

# V21 API Reference

## 🛠️ Siemens.Engineering.SW.Supervision.SupervisionProvider
>
> prodiag global supervision provider of proDiagFB

- 📦 `ExportSupervisionsToXlsx(System.IO.FileInfo)`: Export of prodiag global supervisions to xlsx file
- 📦 `ImportSupervisionSettingsFromXlsx(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Import of prodiag settings from xlsx file
- 📦 `ImportSupervisionsFromXlsx(System.IO.FileInfo,Siemens.Engineering.ImportOptions)`: Import of prodiag global supervisions from xlsx file

## 🛠️ Siemens.Engineering.SW.Supervision.SupervisionSettingsExportImportResult
>
> Represents supervision settings export/import final result.

- 🔧 `Messages`: List of supervision settings export/import messages
- 🔧 `ErrorCount`: Error count after export/import of supervision settings
- 🔧 `State`: Final state of the supervision settings export/import result.
- 🔧 `WarningCount`: Warning count after import of supervision settings

## 🛠️ Siemens.Engineering.SW.Supervision.SupervisionSettingsExportImportResultMessage
>
> Represents supervision settings export/import final result message

- 🔧 `Message`: Final message text of supervision settings export/import result.

## 🛠️ Siemens.Engineering.SW.Supervision.SupervisionSettingsExportImportResultMessageComposition
>
> Composition of SupervisionSettingsExportImportResultMessage

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.SW.Supervision.SupervisionSettingsExportImportResultMessage)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.SW.Supervision.SupervisionSettingsExportImportResultMessage)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.

## 🛠️ Siemens.Engineering.SW.Supervision.SupervisionSettingsExportImportResultState
>
> The state of supervision settings export/import result

## 🛠️ Siemens.Engineering.SW.Supervision.SupervisionSettingsProvider
>
> Provider for supervision settings

- 📦 `Export(System.IO.FileInfo)`: Exports supervision settings in DAT file format
- 📦 `Import(System.IO.FileInfo)`: Imports supervision settings from DAT file

## 🛠️ Siemens.Engineering.SW.Supervision.SupervisionXlsxResult
>
> Represents a supervision export or import result.

- 🔧 `LogFilePath`: Path to the log file.
- 🔧 `State`: Final state of the supervision export or import result.

## 🛠️ Siemens.Engineering.SW.Supervision.SupervisionXlsxResultState
>
> Supervision import/export result state
