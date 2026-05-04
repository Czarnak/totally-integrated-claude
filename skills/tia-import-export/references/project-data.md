# Project Data Reference

Source: TIA Portal Openness V21 — Project Texts and Graphics (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. Export project texts (XLSX)

Entry point: `project.ExportProjectTexts(...)` — found under "Languages & resources" node.

Parameters:

- `path` — `FileInfo` for the `.xlsx` output file
- `sourceLanguage` — reference language (`CultureInfo`)
- `targetLanguage` — target translation language (`CultureInfo`)

```csharp
project.ExportProjectTexts(
    new FileInfo(@"D:\Test\ProjectText.xlsx"),
    new CultureInfo("en-US"),
    new CultureInfo("de-DE"));
```

**Limitations:**

- Exported texts can only be re-imported into the same project.
- After "Save as…", import is no longer possible.
- Only existing texts can be re-imported. Deleted or re-created texts will fail on import.
- Multilingual texts are exported together with their parent object — they cannot be exported explicitly.

---

## 2. Import project texts (XLSX)

```csharp
ProjectTextResult result = project.ImportProjectTexts(
    new FileInfo(@"D:\Test\ProjectText.xlsx"),
    true);   // updateSourceLanguage: if true, updates reference language text from file

ProjectTextResultState resultState = result.State;
FileInfo logFilePath = result.Path;
```

---

## 3. Export project graphics

Entry point: `project.GetService<GraphicsProvider>().Graphics` (`MultiLingualGraphicComposition`)

Export creates an XML descriptor file + the referenced graphic files (`*.jpg`, `*.bmp`, `*.png`, `*.ico`, etc.) in the same directory. Graphics are not write-protected after export.

```csharp
// Export a single graphic (all language variants)
Project project = …;
MultiLingualGraphicComposition graphicsComposition = project.GetService<GraphicsProvider>().Graphics;
MultiLingualGraphic graphic = graphicsComposition.Find("graphicName");
graphic.Export(new FileInfo(@"D:\ExportFolder\graphicName.xml"), ExportOptions.WithDefaults);

// Export all graphics
foreach (MultiLingualGraphic graphic in graphicsComposition)
{
    graphic.Export(
        new FileInfo(string.Format(@"D:\Graphics\{0}.xml", graphic.Name)),
        ExportOptions.WithDefaults);
}
```

---

## 4. Import project graphics

The XML file references graphics via relative paths. All language variants in the XML are imported.

```csharp
Project project = …;
MultiLingualGraphicComposition graphicComposition = project.GetService<GraphicsProvider>().Graphics;
graphicComposition.Import(new FileInfo(@"D:\Graphics\Graphic1.xml"), ImportOptions.Override);
```
