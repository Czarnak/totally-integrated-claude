# totally-integrated-claude

A Claude Code plugin for **Siemens TIA Portal engineering automation**.

Provides a routed skill framework covering the full TIA Portal Openness API surface — Python TIA Scripting for everyday tasks and C# Openness for advanced object-model work — plus an LSP server for Siemens PLC source languages.

---

## Features

- **Automatic routing** - one entry-point skill (`tia-openness-roadmap`) selects Python or C# and loads the right domain skill
- **Python TIA Scripting** - full coverage of PLC blocks/tags, HMI, libraries, devices, project lifecycle via `tia-python`
- **C# Openness** - nine domain skills covering every Openness API area (see table below)
- **TIA Portal Add-In development** — VS Code–based Add-In authoring workflow
- **LSP language server** - syntax highlighting, diagnostics, and code intelligence for Siemens PLC source files
- **TIA Portal MCP server** - work with your agent directly in TIA Portal V21 (separate installation required, see below)

---

## Skills

| Skill | Purpose |
| --- | --- |
| `tia-openness-roadmap` | **Entry point.** Routes all TIA Portal tasks to the correct implementation path and domain skill. Load this first for every TIA Portal task. |
| `tia-python` | Python TIA Scripting: PLC blocks/tags/UDTs, HMI tags/screens, library types/versions, project lifecycle, CAx import/export. |
| `tia-csharp-common` | C# foundation: TIA Portal process attach, `ExclusiveAccess`, `Transaction`, disposable patterns. Required first load for every C# task. |
| `tia-project-general` | C# project & portal lifecycle: open, create, save, archive, retrieve, UMAC/UMC, language settings, diagnostics. |
| `tia-devices-general` | C# device & device-item operations: hardware catalog, device creation/deletion, slot/subslot traversal, software containers, network connections, hardware parameters. |
| `tia-plc-operations` | C# PLC software engineering: program/system blocks, PLC tags/UDTs, software units, Safety, alarms, OPC-UA, technological objects, watch/force tables, online/download, compare. |
| `tia-hmi-operations` | C# Unified HMI: screens, screen items, elements, parts, tags, alarms, scripts, cycles, connections, dynamization, events, runtime settings, system services. |
| `tia-networks` | C# topology: subnets, nodes, IO systems, port channels, addresses, IO timing. |
| `tia-simatic-drives` | C# Startdrive / SINAMICS: drive controller access, drive engineering, motion control, download. |
| `tia-import-export` | C# & Python import/export: SimaticML, AML/CAx, PLC blocks, HMI screens/tags/alarms, hardware AML, project data. |
| `tia-multiuser` | C# Multiuser Engineering: server project management, local sessions, multiuser commissioning workflows. |
| `tia-teamcenter` | C# Teamcenter Integration: Teamcenter storage management and Teamcenter-managed project operations. |
| `tia-testsuite` | C# TestSuite & Application Test: test sets, application tests, style-guide rules, automated system testing. |
| `addin-operations` | TIA Portal Add-In development: project structure, VS Code workflow, Add-In lifecycle, menus, permissions, deployment. |

---

## LSP Language Server

The plugin ships a compiled LSP server (`bin/siemens-lsp.exe`) providing language intelligence for Siemens PLC source files:

| Extension | Language |
| --- | --- |
| `.scl` | Structured Control Language |
| `.st` | Structured Text (IEC 61131-3) |
| `.s7res` | S7 Resource |
| `.s7dcl` | S7 Declaration |
| `.udt` | User-Defined Type |
| `.db` | Data Block |
| `.awl` | Statement List (AWL/STL) |

---

## Prerequisites

### For Python TIA Scripting

- Siemens TIA Portal V17 or later
- TIA Scripting Python package installed (shipped with TIA Portal)

### For C# Openness

- Siemens TIA Portal V17 or later
- TIA Portal Openness assemblies (installed with TIA Portal)
- .NET Framework 4.8 or later

### For Add-In development

- Visual Studio 2022 or VS Code with C# Dev Kit
- TIA Portal Add-In SDK (available from Siemens Industry Online Support)

---

## Installation

Install from GitHub or clone this repository and link it locally while developing.

### Claude Code

```bash
/plugin marketplace add Czarnak/totally-integrated-claude
```

### Gemini CLI

Gemini CLI reads `gemini-extension.json`, bundled `skills/`, `GEMINI.md`, and
the inline `mcpServers` configuration from the extension root.

Install from GitHub:

```bash
gemini extensions install https://github.com/Czarnak/totally-integrated-claude
```

For local development, link the checkout instead:

```bash
gemini extensions link .
gemini extensions validate .
```

### Codex

Codex reads `.codex-plugin/plugin.json`, which points at the bundled `skills/`,
`.mcp.json`, and `.lsp.json` files.

Install the marketplace from GitHub:

```bash
codex plugin marketplace add Czarnak/totally-integrated-claude
```

From inside an interactive Codex session, you can use the slash-command form:

```bash
/plugin marketplace add Czarnak/totally-integrated-claude
```

---

## Usage

Start every TIA Portal task by asking Claude to load the routing skill:

```text
How do I read all PLC tag tables from an open TIA Portal project?
```

Claude will load `tia-openness-roadmap`, select the correct implementation path (Python or C#), and load the matching domain skill automatically.

### Routing examples

| Task | Path | Domain skill |
| --- | --- | --- |
| Read/write PLC blocks and tags | Python | `tia-python` |
| HMI screen access and export | Python | `tia-python` |
| Device slot/subslot manipulation | C# | `tia-devices-general` |
| Subnet and IO-system configuration | C# | `tia-networks` |
| SINAMICS drive engineering | C# | `tia-simatic-drives` |
| Advanced PLC online/security services | C# | `tia-plc-operations` |
| Multiuser Engineering (server projects) | C# | `tia-multiuser` |
| Teamcenter managed projects | C# | `tia-teamcenter` |
| Automated PLC/HMI testing | C# | `tia-testsuite` |
| TIA Portal Add-In project | C# | `addin-operations` |

---

## Worth installing to boost your workflow

- C# LSP plugin from [Claude Plugins Official](https://github.com/anthropics/claude-plugins-official)
- [Tia Portal MCP Server](https://github.com/Czarnak/tia-portal-mcp)

## TODO

- Add Siemens languages skills (SCL, LAD, SimaticML)

## Sources

- [TIA Portal Openness docs](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/)
- [TIA Scripting Python](https://support.industry.siemens.com/cs/document/109742322/tool-for-easier-use-of-the-tia-portal-openness-interface-(tia-scripting-python))
- [Siemens LSP](https://marketplace.visualstudio.com/items?itemName=DynamicEngineering.dynamic-siemens-language-support)

## Examples

- [PLC Block Scanner](https://github.com/Czarnak/plc-block-scanner)

## License

MIT — see [LICENSE](LICENSE).
