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

| Reference file | When to use |
|---|---|
| `references/project-lifecycle.md` | Load when the task involves project-level lifecycle operations: Open, OpenWithUpgrade, Create, Save, SaveAs, Close, Archive, Retrieve, RetrieveWithUpgrade, delete, or copy. |
| `references/project-attributes.md` | Load when the task involves reading project metadata (Author, Name, Version, Path, Size, dates), project history entries, used products, simulation/virtual PLC properties, or accessing the VCI service entry point. |
| `references/language-settings.md` | Load when the task involves project languages, active/editing/reference languages, multilingual text (MultilingualText, MultilingualTextItem), CommentML on devices, or VCI language import options. |
| `references/umac-and-auth.md` | Load when the task involves UMAC-protected project operations, UmacDelegate, Authentication events, ProjectOpenMode (Primary/Secondary), or UMAC user types. |
| `references/compile.md` | Load when the task involves compiling any object (PlcSoftware, HmiTarget, Device, CodeBlock, etc.) via ICompilable or reading CompilerResult. |
| `references/portal-settings.md` | Load when the task involves TiaPortalSettingsFolder (UI language, search index), ObjectIdentifierProvider, SystemDiagnostics settings export/import, or read-only project access. |
| `references/vci-management.md` | Load when the task involves managing VCI workspaces, workspace groups, creating user groups, or connecting/exporting objects to a VCI workspace. |
| `references/vci-operations.md` | Load when the task involves VCI mapped objects, synchronizing changes between project and workspace, or performing object comparisons. |

For tasks spanning multiple areas, load all relevant reference files before generating code.

---

## Execution pattern

1. Create or attach to `TiaPortal` instance (see `tia-csharp-common`)
2. Open, create, or retrieve `Project`
3. Use `ExclusiveAccess` / `Transaction` where needed (see `tia-csharp-common`)
4. Perform project-level Openness operations
5. Save / archive / close at the correct synchronisation point
6. Dispose the TIA Portal session
