# totally-integrated-claude

A Claude Code plugin for **Siemens TIA Portal engineering automation**.

Provides a routed skill framework covering the full TIA Portal Openness API surface — Python TIA Scripting for everyday tasks and C# Openness for advanced object-model work — plus an LSP server for Siemens PLC source languages.

---

## Features

- **Automatic routing** — one entry-point skill (`tia-openness-roadmap`) selects Python or C# and loads the right domain skill
- **Python TIA Scripting** — full coverage of PLC blocks/tags, HMI, libraries, devices, project lifecycle via `tia-python`
- **C# Openness** — nine domain skills covering every Openness API area (see table below)
- **TIA Portal Add-In development** — VS Code–based Add-In authoring workflow
- **LSP language server** — syntax highlighting, diagnostics, and code intelligence for Siemens PLC source files

---

## Skills

| Skill | Purpose |
| --- | --- |
| `tia-openness-roadmap` | **Entry point.** Routes all TIA Portal tasks to the correct implementation path and domain skill. Load this first for every TIA Portal task. |
| `tia-python` | Python TIA Scripting: PLC blocks/tags/UDTs, HMI tags/screens, library types/versions, project lifecycle, CAx import/export. |
| `tia-csharp-common` | C# foundation: TIA Portal process attach, `ExclusiveAccess`, `Transaction`, disposable patterns. Required first load for every C# task. |
| `tia-project-general` | C# project & portal lifecycle: open, create, save, archive, retrieve, UMAC/UMC, multiuser (VCI/Teamcenter), language settings, diagnostics. |
| `tia-devices-general` | C# device & device-item operations: hardware catalog, device creation/deletion, slot/subslot traversal, software containers, network connections. |
| `tia-plc-operations` | C# PLC software engineering: program blocks, system blocks, PLC tags/UDTs, software units, Safety unit, online/offline, download, compare, security. |
| `tia-hmi-operations` | C# Unified HMI: screens, screen items, HMI tags, scripts, cycles, connections, runtime behavior. |
| `tia-networks` | C# topology: subnets, nodes, IO systems, port channels, addresses, IO timing. |
| `tia-simatic-drives` | C# Startdrive / SINAMICS: drive controller access, drive engineering, Startdrive-specific Openness APIs. |
| `tia-import-export` | C# & Python import/export: SimaticML, AML/CAx, PLC blocks, HMI screens/tags/alarms, hardware AML, project data. |
| `addin-operations` | TIA Portal Add-In development: project structure, VS Code workflow, Add-In lifecycle, deployment. |

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

Install via the Claude Code plugin marketplace or clone this repository and point Claude Code at the directory:

```bash
claude --plugin-dir /path/to/totally-integrated-claude
```

---

## Usage

Start every TIA Portal task by asking Claude to load the routing skill:

```
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
| Teamcenter / VCI / multiuser sessions | C# | `tia-project-general` |
| TIA Portal Add-In project | C# | `addin-operations` |

---

## csharp-lsp

C# language server for Claude Code, providing code intelligence and diagnostics.

### Supported Extensions

`.cs`

### Installation

#### Via .NET tool (recommended)

```bash
dotnet tool install --global csharp-ls
```

#### Via Homebrew (macOS)

```bash
brew install csharp-ls
```

### Requirements

- .NET SDK 6.0 or later

### More Information

- [csharp-ls GitHub](https://github.com/razzmatazz/csharp-language-server)
- [.NET SDK Download](https://dotnet.microsoft.com/download)

## TODO

1. Add missing Openness API skills
2. Add Siemens languages skills (SCL, LAD, SimaticML)

## Sources

- [TIA Portal Openness docs](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/)
- [TIA Scripting Python](https://support.industry.siemens.com/cs/document/109742322/tool-for-easier-use-of-the-tia-portal-openness-interface-(tia-scripting-python))
- [Siemens LSP](https://marketplace.visualstudio.com/items?itemName=DynamicEngineering.dynamic-siemens-language-support)

## License

MIT — see [LICENSE](LICENSE).
