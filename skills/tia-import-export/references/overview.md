# Overview Reference

Source: TIA Portal Openness V21 — Basic Principles and Configuration Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. Field of application

Import/Export is useful for:
- Externally editing configuration data
- Importing externally-created data (e.g. text lists, tags)
- Distributing configuration data across projects
- Round-trip exchange with ECAD programs (AML/CAx)

## 2. Exportable and importable objects

| Category | Objects | Export | Import |
|---|---|---|---|
| Project | Project graphics | X | X |
| PLC | Blocks | X | X |
| PLC | Know-how protected blocks | X | – |
| PLC | Failsafe blocks | X | X |
| PLC | System blocks | X | – |
| PLC | PLC tag tables | X | X |
| PLC | Technology objects | X | X |
| PLC | PLC tags and constants | X | X |
| PLC | User data types | X | X |
| HMI | Screens, screen templates, global screens | X | X |
| HMI | Pop-up screens, slide-in screens | X | X |
| HMI | Scripts, text lists, graphic lists | X | X |
| HMI | Cycles, connections, tag tables, tags | X | X |

## 3. Export file format and options

File format is XML for all objects except CAx data (which uses AML).

```csharp
// ExportOptions — control what is written to the XML file
obj.Export(path, ExportOptions.None);                    // only modified/non-default data
obj.Export(path, ExportOptions.WithDefaults);            // include default values
obj.Export(path, ExportOptions.WithReadOnly);            // include read-only values
obj.Export(path, ExportOptions.WithDefaults | ExportOptions.WithReadOnly);  // combined
```

- Export content is always in English; project texts are exported in all configured languages.
- Each start object (root) is exported to a separate XML file.
- Object types from the library are **not** exportable. Instances are exported without type info and become detached on re-import.
- Only attributes changed from default are included with `ExportOptions.None`.
- Open references (to objects in other sub-trees) are included as references, not full data.

## 4. Import options

```csharp
// ImportOptions — control overwrite behavior
composition.Import(file, ImportOptions.None);                      // fail if object exists
composition.Import(file, ImportOptions.Override);                  // delete & recreate existing
composition.Import(file, ImportOptions.SkipInactiveCultures);      // skip text for inactive languages
composition.Import(file, ImportOptions.ActivateInactiveCultures);  // activate languages as needed

// Combine with bitwise OR (cannot combine ActivateInactiveCultures + SkipInactiveCultures)
composition.Import(file, ImportOptions.Override | ImportOptions.ActivateInactiveCultures);
```

> `ImportOptions.ActivateInactiveCultures` and `ImportOptions.SkipInactiveCultures` are **not** supported for Excel-based import APIs (e.g. `ImportSupervisionSettingsFromXlsx`).

Import rules:
- All root objects in the import file must be of the same kind (e.g. all blocks, all tag tables).
- If any root object is invalid, the entire file is rejected.
- Objects being overwritten must be in the same group; otherwise import is canceled with an exception.

## 5. Editing the XML file

Use an XML editor with auto-complete for structural changes. The schema definitions (XSD) are located at:
- HMI: project XML schema docs
- PLC: `C:\Program Files\Siemens\Automation\Portal V*\PublicAPI\V*\Schemas\SW.PlcBlocks.Graph_v4.xsd` (and similar)
- AML: AutomationML schema

> Only modify XML manually in exceptional cases — validation errors will abort import.

## 6. SIMATIC ML versioning

- The SimaticML file version always corresponds to the installed TIA Portal version, regardless of which Openness API version is used.
- **Until TIA Portal V18**: import requires Openness API version ≥ SimaticML version.
- **Since TIA Portal V19**: all SimaticML versions within the LTS scope (Vxx−3 to Vxx) can be imported with any Openness API version.

## 7. Exporting configuration data (general)

```csharp
// Generic pattern — applicable to any exportable composition member
FileInfo exportFile = new FileInfo(@"C:\Export\myObject.xml");
someObject.Export(exportFile, ExportOptions.WithDefaults);
```

## 8. Open references

- Referenced objects in **other sub-trees** are exported as open references (not full data).
- On import, open references are automatically re-linked if the referenced object exists at the same path and name in the target project.
- If the referenced object is missing, the open reference is not resolved and no new object is created.
