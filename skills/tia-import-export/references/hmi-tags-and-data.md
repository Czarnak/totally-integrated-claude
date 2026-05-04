# HMI Tags and Data Reference

Source: TIA Portal Openness V21 — Functions for Accessing HMI Device Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. Export all HMI tag tables from a folder

Entry point: `hmiTarget.TagFolder` (`TagSystemFolder`)

```csharp
private static void ExportAllTagTablesFromTagFolder(HmiTarget hmitarget)
{
    TagSystemFolder folder = hmitarget.TagFolder;
    TagTableComposition tables = folder.TagTables;
    foreach (TagTable table in tables)
    {
        FileInfo info = new FileInfo(string.Format(@"C:\OpennessSamples\TagTables\{0}.xml", table.Name));
        table.Export(info, ExportOptions.WithDefaults);
    }
}
```

---

## 2. Export a single HMI tag table

```csharp
private static void ExportTagTableFromHMITarget(HmiTarget hmitarget)
{
    string tableName = "Tag table XYZ";
    TagSystemFolder folder = hmitarget.TagFolder;
    TagTable table = folder.TagTables.Find(tableName);
    if (table != null)
    {
        FileInfo info = new FileInfo(string.Format(@"C:\OpennessSamples\TagTables\{0}.xml", table.Name));
        table.Export(info, ExportOptions.WithDefaults);
    }
}
```

---

## 3. Export all HMI tag tables (recursive, all folders)

```csharp
private static void ExportAllTagTablesFromHMITarget(HmiTarget hmitarget)
{
    TagSystemFolder sysFolder = hmitarget.TagFolder;
    foreach (TagUserFolder userFolder in sysFolder.Folders)
        ExportUserFolderDeep(userFolder);
    ExportTablesInSystemFolder(sysFolder);
}

private static void ExportUserFolderDeep(TagUserFolder rootUserFolder)
{
    foreach (TagUserFolder userFolder in rootUserFolder.Folders)
        ExportUserFolderDeep(userFolder);
    ExportTablesInUserFolder(rootUserFolder);
}

private static void ExportTablesInUserFolder(TagUserFolder folderToExport)
{
    foreach (TagTable table in folderToExport.TagTables)
    {
        string fullFilePath = string.Format(@"C:\OpennessSamples\TagTables\{0}.xml", table.Name);
        table.Export(new FileInfo(fullFilePath), ExportOptions.WithDefaults);
    }
}

private static void ExportTablesInSystemFolder(TagSystemFolder folderToExport)
{
    foreach (TagTable table in folderToExport.TagTables)
    {
        string fullFilePath = string.Format(@"C:\OpennessSamples\TagTables\{0}.xml", table.Name);
        table.Export(new FileInfo(fullFilePath), ExportOptions.WithDefaults);
    }
}
```

---

## 4. Import HMI tag table

```csharp
private static void ImportSingleHMITagTable(HmiTarget hmitarget)
{
    TagSystemFolder folder = hmitarget.TagFolder;
    TagTableComposition tables = folder.TagTables;
    FileInfo info = new FileInfo(@"D:\Samples\Import\myExportedTagTable.xml");
    tables.Import(info, ImportOptions.Override);
}
```

> If tag or referenced tag names contain `.` (period) or `\` (backslash), wrap the name in quotation marks in the XML: `<name>"My.Tag\Name"</name>`.

---

## 5. Export individual HMI tag

Sub-objects exported per tag: `MultilingualText` (Comment, TagValue, DisplayName), `TagArrayMemberTag`, `TagStructureMember`, `Event`, `MultiplexEntry`.

```csharp
private static void ExportSelectedTagFromTagTable(HmiTarget hmitarget)
{
    TagSystemFolder tagFolder = hmitarget.TagFolder;
    TagTable mytable = tagFolder.TagTables.Find("MyTagTable");
    Tag myTag = mytable.Tags.Find("MyTag");
    if (myTag != null)
    {
        FileInfo info = new FileInfo(string.Format(@"C:\OpennessSamples\Tags\{0}.xml", myTag.Name));
        myTag.Export(info, ExportOptions.WithDefaults);
    }
}
```

---

## 6. Import individual HMI tag

```csharp
private static void ImportTagIntoTagTable(HmiTarget hmitarget)
{
    TagSystemFolder tagFolder = hmitarget.TagFolder;
    TagTable myTable = tagFolder.DefaultTagTable;
    TagComposition tagComposition = myTable.Tags;
    FileInfo info = new FileInfo(@"D:\Samples\Import\myExportedTag.xml");
    tagComposition.Import(info, ImportOptions.Override);
}
```

---

## 7. Special considerations for HMI tag export/import

**External HMI tags with integrated connection**

Only the link to the PLC tag is exported — not the PLC tag data itself. Before import, ensure the PLC, PLC tags, and integrated connection exist. Names of external HMI tags must be unique across all tag tables.

XML structure for import:

```xml
<Hmi.Tag.Tag ID="1" CompositionName="Tags">
    <AttributeList>
        <Name>MyIntegratedHmiTag_1</Name>
    </AttributeList>
    <LinkList>
        <AcquisitionCycle TargetID="@OpenLink"><Name>1 s</Name></AcquisitionCycle>
        <Connection TargetID="@OpenLink"><Name>HMI_Connection_MP277_300400</Name></Connection>
        <ControllerTag TargetID="@OpenLink"><Name>Datablock_1.DBElement1</Name></ControllerTag>
    </LinkList>
</Hmi.Tag.Tag>
```

**HMI tags of UDT data type**

Only versioned UDTs stored in the project library (not global library) are supported. XML structure:

```xml
<Hmi.Tag.Tag ID="1" CompositionName="Tags">
    <LinkList>
        <DataType TargetID="@OpenLink"><Name>HmiUdt_1 V 1.0.0</Name></DataType>
    </LinkList>
</Hmi.Tag.Tag>
```

---

## 8. Export connections

Entry point: `hmiTarget.Connections` (`ConnectionComposition`)

> Export of integrated connections is **not** supported.

```csharp
private static void ExportConnectionsFromHMITarget(HmiTarget hmitarget)
{
    ConnectionComposition connections = hmitarget.Connections;
    foreach (Connection connection in connections)
    {
        FileInfo info = new FileInfo(string.Format(@"D:\Samples\Export\{0}.xml", connection.Name));
        connection.Export(info, ExportOptions.WithDefaults);
    }
}
```

---

## 9. Import connections

> If an integrated connection already exists, importing a connection with the same name is aborted with an exception.

```csharp
private static void ImportConnectionsToHMITarget(HmiTarget hmitarget)
{
    ConnectionComposition connections = hmitarget.Connections;
    IList<Connection> importedConnectionLists = connections.Import(
        new FileInfo(@"D:\Samples\Import\myConnectionImport.xml"), ImportOptions.Override);
}
```

---

## 10. Export text lists

Entry point: `hmiTarget.TextLists` (`TextListComposition`)

One XML file per text list. Formatted texts (text formatting, object references) produce an advanced XML format with Open Links.

```csharp
private static void ExportTextLists(HmiTarget hmitarget)
{
    TextListComposition text = hmitarget.TextLists;
    foreach (TextList textList in text)
    {
        FileInfo info = new FileInfo(string.Format(@"D:\Samples\Export\{0}.xml", textList.Name));
        textList.Export(info, ExportOptions.WithDefaults);
    }
}
```

---

## 11. Import text list

```csharp
private static void ImportSingleTextList(HmiTarget hmitarget)
{
    TextListComposition textListComposition = hmitarget.TextLists;
    IList<TextList> importedTextLists = textListComposition.Import(
        new FileInfo(@"D:\SamplesImport\myTextList.xml"), ImportOptions.Override);
}
```

---

## 12. Export graphic lists

Entry point: `hmiTarget.GraphicLists` (`GraphicListComposition`)

One XML file per graphic list. Global graphic objects are exported as Open Links.

```csharp
private static void ExportGraphicLists(HmiTarget hmitarget)
{
    GraphicListComposition graphic = hmitarget.GraphicLists;
    foreach (GraphicList graphicList in graphic)
    {
        FileInfo info = new FileInfo(string.Format(@"D:\Samples\Export\{0}.xml", graphicList.Name));
        graphicList.Export(info, ExportOptions.WithDefaults);
    }
}
```

---

## 13. Import graphic list

Referenced global graphics are not included but are re-linked if they exist in the target project.

```csharp
private static void ImportSingleGraphicList(HmiTarget hmitarget)
{
    GraphicListComposition graphicListComposition = hmitarget.GraphicLists;
    IList<GraphicList> importedGraphicLists = graphicListComposition.Import(
        new FileInfo(@"D:\Samples\Import\myGraphicList.xml"), ImportOptions.Override);
}
```

---

## 14. Export VB scripts

Entry point: `hmiTarget.VBScriptFolder` (`VBScriptSystemFolder`)

```csharp
// Export single script from system folder
private static void ExportSingleVBScriptOfHMITarget(HmiTarget hmitarget)
{
    VBScriptSystemFolder vbScriptFolder = hmitarget.VBScriptFolder;
    VBScript vbScript = vbScriptFolder.VBScripts.Find("MyVBScript");
    FileInfo info = new FileInfo(string.Format(@"C:\OpennessSamples\Export\Scripts\{0}.xml", vbScript.Name));
    vbScript.Export(info, ExportOptions.None);
}

// Export all scripts from a user-defined folder
private static void ExportVBScriptOfSelectedVBScriptSystemFolder(HmiTarget hmitarget)
{
    VBScriptSystemFolder vbScriptFolder = hmitarget.VBScriptFolder;
    VBScriptUserFolder vbUserFolder = vbScriptFolder.Folders.Find("MyVBUserFolder");
    foreach (VBScript script in vbUserFolder.VBScripts)
    {
        FileInfo info = new FileInfo(string.Format(@"C:\OpennessSamples\Export\Scripts\{0}.xml", script.Name));
        script.Export(info, ExportOptions.None);
    }
}

// Export all scripts from system folder
private static void ExportAllVBScripts(HmiTarget hmitarget)
{
    VBScriptComposition vbScripts = hmitarget.VBScriptFolder.VBScripts;
    if (vbScripts == null) return;
    foreach (VBScript script in vbScripts)
    {
        FileInfo info = new FileInfo(string.Format(@"C:\OpennessSamples\Export\Scripts\{0}.xml", script.Name));
        script.Export(info, ExportOptions.None);
    }
}
```

---

## 15. Import VB scripts

Bulk imports are supported.

```csharp
private static void ImportSingleVBScriptToHMITarget(HmiTarget hmitarget)
{
    VBScriptSystemFolder vbScriptFolder = hmitarget.VBScriptFolder;
    VBScriptComposition vbScripts = vbScriptFolder.VBScripts;
    if (vbScripts == null) return;
    FileInfo info = new FileInfo(@"D:\Samples\Import\VBScript.xml");
    vbScripts.Import(info, ImportOptions.None);
}
```
