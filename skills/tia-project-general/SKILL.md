---
name: tia-project-general
description: >
  Routed by tia-openness-roadmap. C# Openness implementation of project and portal lifecycle:
  opening, attaching, creating, archiving, retrieving, saving, copying, closing, deleting
  projects, project server sessions, transactions, exclusive access, UMAC/UMC, project library
  entry points, project-level CAx exchange, authentication events, project history, language
  settings, diagnostics, and advanced multiuser/VCI workflows.
---

# tia-project-general

## Scope
Project and portal lifecycle — full C# Openness implementation.

When the roadmap routes here, the entire solution is C#.
Do not mix with Python wrapper calls.
Always load `tia-csharp-common` first (done by roadmap).

---

## Reference files

Load ONLY the reference file(s) relevant to the task. Do not load all files at once.

| Reference file | Load when the task involves |
|---|---|
| `references/project-lifecycle.md` | Open, OpenWithUpgrade, Create, Save, SaveAs, Close, Archive, Retrieve, RetrieveWithUpgrade, delete, copy |
| `references/project-attributes.md` | Reading project metadata (Author, Name, Version, Path, Size, dates), history entries, used products, simulation/virtual PLC properties |
| `references/language-settings.md` | Project languages, active/editing/reference language, multilingual text (MultilingualText, MultilingualTextItem), CommentML on devices |
| `references/umac-and-auth.md` | UMAC-protected project open, UmacDelegate, Authentication event, ProjectOpenMode (Primary/Secondary), UMAC user type |
| `references/compile.md` | Compiling any object (PlcSoftware, HmiTarget, Device, CodeBlock, PlcBlockGroup, PlcType, etc.) via ICompilable, reading CompilerResult |
| `references/portal-settings.md` | TiaPortalSettingsFolder (UI language, search index), ObjectIdentifierProvider, SystemDiagnostics settings export/import, read-only project access |

For tasks spanning multiple areas, load all relevant reference files before generating code.

---

## Execution pattern

1. Create or attach to `TiaPortal` instance (see `tia-csharp-common`)
2. Open, create, or retrieve `Project`
3. Use `ExclusiveAccess` / `Transaction` where needed (see `tia-csharp-common`)
4. Perform project-level Openness operations
5. Save / archive / close at the correct synchronisation point
6. Dispose the TIA Portal session
