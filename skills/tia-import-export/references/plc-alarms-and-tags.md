# PLC Alarms and Tags Reference

Source: TIA Portal Openness V21 — Functions for Accessing PLC Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. Export all PLC tag tables (recursive)

Entry point: `plcSoftware.TagTableGroup` (`PlcTagTableSystemGroup`)

```csharp
private static void ExportAllTagTables(PlcSoftware plcSoftware)
{
    PlcTagTableSystemGroup plcTagTableSystemGroup = plcSoftware.TagTableGroup;
    ExportTagTables(plcTagTableSystemGroup.TagTables);
    foreach (PlcTagTableUserGroup userGroup in plcTagTableSystemGroup.Groups)
        ExportUserGroupDeep(userGroup);
}

private static void ExportTagTables(PlcTagTableComposition tagTables)
{
    foreach (PlcTagTable table in tagTables)
        table.Export(new FileInfo(string.Format(@"D:\Samples\{0}.xml", table.Name)), ExportOptions.WithDefaults);
}

private static void ExportUserGroupDeep(PlcTagTableUserGroup group)
{
    ExportTagTables(group.TagTables);
    foreach (PlcTagTableUserGroup userGroup in group.Groups)
        ExportUserGroupDeep(userGroup);
}
```

---

## 2. Import PLC tag table

```csharp
private static void ImportTagTable(PlcSoftware plcSoftware)
{
    PlcTagTableSystemGroup plcTagTableSystemGroup = plcSoftware.TagTableGroup;
    PlcTagTableComposition tagTables = plcTagTableSystemGroup.TagTables;
    tagTables.Import(new FileInfo(@"D:\Samples\myTagTable.xml"), ImportOptions.Override);
    // Import into subfolder:
    // plcTagTableSystemGroup.Groups.Find("SubGroup").TagTables.Import(..., ImportOptions.Override);
}
```

---

## 3. Export individual PLC tag or constant

With `ExportOptions.None`, the following are omitted when at default value: `ExternalAccessible`, `ExternalWritable`, `ExternalVisible`, `LocalAddress`, constant `Value`, `DataTypeName`, `IsSafety`. PLC system constants are excluded from export/import.

```csharp
private static void ExportTag(PlcSoftware plcSoftware, string tagName)
{
    PlcTagTableSystemGroup plcTagTableSystemGroup = plcSoftware.TagTableGroup;
    PlcTag tag = plcTagTableSystemGroup.TagTables[0].Tags.Find(tagName);
    if (tag != null)
        tag.Export(new FileInfo(string.Format(@"D:\Samples\{0}.xml", tag.Name)), ExportOptions.WithDefaults);
}

private static void ExportUserConstant(PlcSoftware plcSoftware, string userConstantName)
{
    PlcTagTableSystemGroup plcTagTableSystemGroup = plcSoftware.TagTableGroup;
    PlcUserConstant plcConstant = plcTagTableSystemGroup.TagTables[0].UserConstants.Find(userConstantName);
    if (plcConstant != null)
        plcConstant.Export(new FileInfo(string.Format(@"D:\Samples\{0}.xml", plcConstant.Name)), ExportOptions.WithDefaults);
}
```

---

## 4. Import individual PLC tag or constant

```csharp
private static void ImportTag(PlcSoftware plcSoftware, string tagtableName)
{
    PlcTagTable tagTable = plcSoftware.TagTableGroup.TagTables.Find(tagtableName);
    if (tagTable == null) return;
    tagTable.Tags.Import(new FileInfo(@"D:\Samples\myTags.xml"), ImportOptions.Override);
}

private static void ImportConstant(PlcSoftware plcSoftware, string tagtableName)
{
    PlcTagTable tagTable = plcSoftware.TagTableGroup.TagTables.Find(tagtableName);
    if (tagTable == null) return;
    tagTable.UserConstants.Import(new FileInfo(@"D:\Samples\myConstants.xml"), ImportOptions.Override);
}
```

> Constants can only be imported as user constants.

---

## 5. Export/import alarm classes (.DAT format)

Entry point: `Project.GetService<AlarmClassDataProvider>()`

```csharp
// Export
FileInfo fileInfo = new FileInfo(@"D:\AlarmClasses.DAT");
AlarmClassDataProvider provider = Project.GetService<AlarmClassDataProvider>();
AlarmClassExportImportResult result = provider.Export(fileInfo);
// result.State: AlarmClassExportImportResultState (Success / Warning / Error)
// result.ErrorCount, result.WarningCount
// result.Messages: AlarmClassExportImportResultMessageComposition

// Import
AlarmClassExportImportResult result = provider.Import(fileInfo);
```

> On error, an `EngineeringTargetInvocationException` is raised; error details are in `e.DetailMessageData`. Supported import schema versions: 1.0 and 2.0.

---

## 6. Export/import PLC alarm text lists (XLSX format)

Entry point: `PlcAlarmTextListProvider` — accessible under `PlcSoftware` or `PlcUnit`.

```csharp
// Simple export (all text lists, all activated project languages)
FileInfo fileInfo = new FileInfo(Path.Combine(Environment.CurrentDirectory, $"{xlsxName}.xlsx"));
PlcAlarmTextListProvider textListProvider = plcSoftware.GetService<PlcAlarmTextListProvider>();
TextListXlsxResult result = textListProvider.ExportToXlsx(fileInfo);

// Export with language and text list filter
IEnumerable<Language> cultureInfos = cultureCodes.Select(
    i => project.LanguageSettings.Languages.Find(CultureInfo.GetCultureInfo(i)));
TextListXlsxResult result = textListProvider.ExportToXlsx(fileInfo, textListNames, cultureInfos);

// Import
TextListXlsxResult result = textListProvider.ImportFromXlsx(fileInfo, ImportOptions.Override);
```

> The XLSX file must have a custom property `FileContent = "Alarm text lists"`. If missing or invalid, import is denied. `ImportOptions.ActivateInactiveCultures` and `SkipInactiveCultures` are **not** supported for this API.

---

## 7. Export/import ProDiag global supervisions (XLSX format)

Entry point: `FB.GetService<SupervisionProvider>()` on a ProDiag FB.

```csharp
// Export
FileInfo fileInfo = new FileInfo(@"C:\Users\...\Supervisions_Openness.xlsx");
var proDiagBlock = (FB)plcSoftware.BlockGroup.Blocks.Find("Block1");
SupervisionProvider supervisionProvider = proDiagBlock.GetService<SupervisionProvider>();
SupervisionXlsxResult result = supervisionProvider.ExportSupervisionsToXlsx(fileInfo);
// result.State: SupervisionXlsxResultState (Success / Failure)

// Import supervisions
SupervisionXlsxResult result = supervisionProvider.ImportSupervisionsFromX1sx(fileInfo, ImportOptions.Override);

// Import supervision settings only
SupervisionXlsxResult result = supervisionProvider.ImportSupervisionSettingsFromX1sx(fileInfo, ImportOptions.Override);
```

---

## 8. Export/import watch tables and force tables

Entry point: `plcSoftware.PlcWatchAndForceTableGroup`

`ExportOptions` for watch tables: `None`, `WithDefaults`, `WithReadOnly`, `WithDefaultsAndReadOnly`. The only published property of a WatchTable is `Name` (read-only).

```csharp
// Export watch table
PlcWatchTable watchTable = plcSoftware.PlcWatchAndForceTableGroup.WatchTables.Find(watchTableName);
if (watchTable != null)
    watchTable.Export((FileInfo)fileInfo, ExportOptions.None);

// Export force table (only one ForceTable exists)
PlcForceTable forceTable = plcSoftware.PlcWatchAndForceTableGroup.ForceTables[0];
forceTable.Export((FileInfo)fileInfo, ExportOptions.None);

// Import watch table
IList<PlcWatchTable> WatchTables = plcSoftware.PlcWatchAndForceTableGroup.WatchTables
    .Import((FileInfo)fileInfo, ImportOptions.None);

// Import force table (use Override if a ForceTable already exists)
// With ImportOptions.None: throws RecoverableException if non-empty ForceTable exists
```
