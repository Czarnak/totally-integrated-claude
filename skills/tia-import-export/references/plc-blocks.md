# PLC Blocks Reference

Source: TIA Portal Openness V21 — Functions for Accessing PLC Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. Export a block

Entry point: `plcSoftware.BlockGroup.Blocks` (`PlcBlockComposition`)

Supported languages for export/import: LAD, FBD, GRAPH, SCL, STL. Supported types: FB, FC, OB, DB.

```csharp
private static void ExportRegularBlock(PlcSoftware plcSoftware)
{
    PlcBlock plcBlock = plcSoftware.BlockGroup.Blocks.Find("MyBlock");
    plcBlock.Export(new FileInfo(string.Format(@"D:\Samples\{0}.xml", plcBlock.Name)), ExportOptions.WithDefaults);
}
```

Import rules:

- Optimized DBs only supported on S7-1200/1500. Importing to S7-300/400 throws exception.
- Missing instance DBs are not created automatically.
- If no block number is in the XML, it is assigned automatically.
- Attributes with `ReadOnly=True` and `Informative=True` are not imported.

---

## 2. Import a block

```csharp
private static void ImportBlocks(PlcSoftware plcSoftware)
{
    PlcBlockGroup blockGroup = plcSoftware.BlockGroup;
    IList<PlcBlock> blocks = blockGroup.Blocks.Import(new FileInfo(@"D:\Blocks\myBlock.xml"), ImportOptions.Override);
}
```

---

## 3. Export system blocks

Only visible system blocks appear in the block composition (no FB/FC). F-system blocks cannot be exported.

```csharp
private static void ExportSystemBlocks(PlcSoftware plcsoftware)
{
    PlcSystemBlockGroup sbSystemGroup = plcsoftware.BlockGroup.SystemBlockGroups[0];
    foreach (PlcSystemBlockGroup group in sbSystemGroup.Groups)
    {
        foreach (PlcBlock block in group.Blocks)
        {
            block.Export(new FileInfo(string.Format(@"D:\Samples\{0}.xml", block.Name)), ExportOptions.WithDefaults);
        }
    }
}
```

Import system blocks:

```csharp
private static void ImportSystemBlocks(PlcSoftware plcSoftware)
{
    PlcBlockSystemGroup systemblockGroup = plcSoftware.BlockGroup.SystemBlockGroups[0].Groups[0];
    IList<PlcBlock> blocks = systemblockGroup.Blocks.Import(new FileInfo(@"D:\Blocks\myBlock.xml"), ImportOptions.Override);
}
```

---

## 4. Export/import user data type (UDT)

Entry point: `plcSoftware.TypeGroup.Types` (`PlcTypeComposition`)

```csharp
private static void ExportUserDefinedType(PlcSoftware plcSoftware)
{
    PlcTypeComposition types = plcSoftware.TypeGroup.Types;
    PlcType udt = types.Find("udt name XYZ");
    udt.Export(new FileInfo(string.Format(@"C:\OpennessSamples\udts\{0}.xml", udt.Name)), ExportOptions.WithDefaults);
}

private static void ImportUserDataType(PlcSoftware plcSoftware)
{
    FileInfo fullFilePath = new FileInfo(@"C:\OpennessSamples\Import\ExportedPlcType.xml");
    IList<PlcType> importedTypes = plcSoftware.TypeGroup.Types.Import(fullFilePath, ImportOptions.Override);
}
```

> In the import XML, user-defined data type member names must be quoted with `";"`.

---

## 5. Export blocks with know-how protection

Without unlocking, only the public block interface is exported. Use `PlcBlockProtectionProvider` to unlock before export, then re-lock after import.

```csharp
private static void ExportBlock(PlcSoftware plcSoftware)
{
    PlcBlock plcBlock = plcSoftware.BlockGroup.Blocks.Find("MyBlock");
    plcBlock.Export(new FileInfo(string.Format(@"D:\Samples\{0}.xml", plcBlock.Name)), ExportOptions.WithDefaults);
}
```

---

## 6. Export/import failsafe (F-) blocks

Consistent F-blocks can be exported and re-imported — they will be created as F-blocks. F-system blocks cannot be exported.

To import as a standard (non-F) block, remove the `F_` prefix from all `ProgrammingLanguage` attribute values in the XML.

---

## 7. Export DB snapshot values

Supported for Global DBs, Instance DBs, and Array DBs. Uses the `InterfaceSnapshot` service. The snapshot export is independent of the standard interface export and cannot be re-imported.

```csharp
PlcBlock dataBlock = ...;
InterfaceSnapshot interfaceSnapshot = dataBlock.GetService<InterfaceSnapshot>();
interfaceSnapshot.Export(new FileInfo(@"C:\temp\MyInterfaceSnapshot.xml"), ExportOptions.WithReadOnly);
```

---

## 8. Create instance DB

```csharp
PlcSoftware plc = ...;
plc.BlockGroup.Blocks.CreateInstanceDB("ConveyerDB", true, 5, "Conveyer_SCL_Block");
plc.BlockGroup.Blocks.CreateInstanceDB("RelayDB", true, 6, "Relay_LAD_Block");
```

> Throws `DataBlockCreationNotAllowedException` for FC, OB, or non-FB/SFB block types.

---

## 9. Access DB member values without export

Read/write `StartValue`, `ExternalAccessible`, `ExternalVisible`, `ExternalWritable`, `Retain`, `SetPoint`, `DataTypePoint` directly on `Member` objects.

```csharp
// Read
PlcBlockInterface bi = dbbblock.Interface;
Member member = bi.Members.Find("Room_Temperature");
string startValue = member.StartValue;
// or: member.GetAttribute("StartValue")

// Write
member.StartValue = 10.2;
// or: member.SetAttribute("StartValue", 20.3)

// Nested path (array/struct)
Member initialSpeedvar = bi.Members.Find("Motor.InitialSpeed[0]");
initialSpeedvar.StartValue = 36;

// Set string value
PlcSoftware myPlcSoftware = tiaProject.Devices[0].DeviceItems[1].GetService<SoftwareContainer>().Software as PlcSoftware;
DataBlock myDatablock = myPlcSoftware.BlockGroup.Blocks[1] as DataBlock;
myDatablock.Interface.Members[0].SetAttribute("StartValue", "'myTest'");
```

---

## 10. Export program block as document (SIMATIC SD format)

```csharp
private void ExportPLCBlockAsDocument(PlcSoftware plcSoftware)
{
    DocumentExportResult documentExportResult = plcSoftware.BlockGroup.Blocks[0]
        .ExportAsDocuments(new DirectoryInfo(@"D:\Project\Exported Files"), "LAD_Block");
    DocumentResultState documentResultState = documentExportResult.State;
    IEnumerable<FileInfo> exportedDocuments = documentExportResult.ExportedDocuments;
}
```

---

## 11. Import program block from document

```csharp
private void ImportProgramBlockFromDocument(PlcSoftware plcSoftware)
{
    DocumentImportResult documentImportResultForBlocks = plcSoftware.BlockGroup.Blocks
        .ImportFromDocuments(new DirectoryInfo(@"D:\Project\Exported Files"),
            "LAD_Block", ImportDocumentOptions.Override);
    DocumentResultState documentResultState = documentImportResultForBlocks.State;
    PlcBlockAssociation importedPlcBlocks = documentImportResultForBlocks.ImportedPlcBlocks;
}
```

`ImportDocumentOptions` values: `None`, `Override`, `Skipinactiveculture`, `ActiveInactiveculture`.

---

## 12. Export/import UDT as document

Follows the same `ExportAsDocuments` / `ImportFromDocuments` pattern applied to a `PlcType` object.

---

## 13. Export PLC data in OPC UA XML format

```csharp
private static void OpcUaExport(Project project, DeviceItem plc)
{
    OpcUaExportProvider opcUaExportProvider = project.HwUtilities.Find("OPCUAExportProvider") as OpcUaExportProvider;
    if (opcUaExportProvider == null) return;
    opcUaExportProvider.Export(plc, new FileInfo(string.Format(@"D:\OPC UA export files\{0}.xml", plc.Name)));
}
```

---

## 14. Import with open reference (missing referenced object)

```csharp
// Allow import even if referenced object (FB, UDT) is missing
PlcBlockComposition.Import(file, ImportOptions.None, SWImportOptions.IgnoreMissingReferencedObjects);
PlcTypeComposition.Import(file, ImportOptions.None, SWImportOptions.IgnoreMissingReferencedObjects);
```

`SWImportOptions` enum: `None = 0`, `IgnoreStructuralChanges = 1`, `IgnoreMissingReferencedObjects = 2`.

---

## 15. Import with structural change (instance data loss)

```csharp
// Allow import even if structural change causes instance data loss
PlcBlockComposition.Import(file, ImportOptions.None, SWImportOptions.IgnoreStructuralChanges);
PlcTypeComposition.Import(file, ImportOptions.None, SWImportOptions.IgnoreStructuralChanges);
```

Supported for: Tag→UDT, UDT→UDT, DB(global)→UDT, IDBofUDT→UDT, IDBofFB→FB, ArrayDB→Array of UDT, FB→UDT/Multi-instance, FC→UDT.
