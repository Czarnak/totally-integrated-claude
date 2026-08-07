# totally-integrated-claude

A Claude Code plugin for **Siemens TIA Portal engineering automation**.

Provides a routed skill framework covering the full TIA Portal Openness API surface — Python TIA Scripting for everyday tasks and C# Openness for advanced object-model work.

![image](img/repo_graphic.png)

---

## Features

- **Scoped automation routing** - `tia-openness-roadmap` honors an explicit implementation choice, then selects MCP, Python, C#, diagnostic, or Add-In skills
- **Python TIA Scripting** - full coverage of PLC blocks/tags, HMI, libraries, devices, project lifecycle via `tia-python`
- **C# Openness** - eleven domain skills covering the V21 Openness domain assemblies (see table below)
- **TIA Portal Add-In development** — VS Code–based Add-In authoring workflow
- **TIA Portal MCP server** - work with your agent directly in TIA Portal V21 (separate installation required, see below)
- **MCP write safety hooks** - Claude Code blocks TIA Portal writes unless the call includes `confirm=true` and a server-issued `safetyToken`
- **Environment diagnostics** - `tia-doctor` verifies the exact V21 executable, modular Openness core, and user group, with optional Python/MCP checks

---

## Skills

| Skill | Purpose |
| --- | --- |
| `tia-openness-roadmap` | **Automation entry point.** Honors explicit scope/path constraints and routes engineering tasks. Pure exported-code review uses `plc-code-analysis` directly. |
| `tia-doctor` | **Manual diagnostic.** Read-only V21 executable/modular API/group probe, with optional Python and MCP checks. |
| `plc-code-analysis` | **Standalone.** Evidence-gated PLC security/quality analysis for raw SCL/ST, V21 SIMATIC SD, or schema-valid SimaticML. |
| `tia-portal-mcp` | **Interactive.** Direct TIA Portal interaction via MCP tools (browse tree, read/write logic, list tags, hardware config). |
| `tia-python` | Python TIA Scripting: PLC blocks/tags/UDTs, HMI tags/screens, library types/versions, project lifecycle, CAx import/export. |
| `tia-csharp-common` | C# foundation: TIA Portal process attach, `ExclusiveAccess`, `Transaction`, disposable patterns. Required first load for every C# task. |
| `tia-project-general` | C# project, portal, and library lifecycle: open/create/save/archive/retrieve, project/global libraries, master copies, type/version workflows, UMAC/UMC, language settings, diagnostics. |
| `tia-devices-general` | C# device & device-item operations: hardware catalog, device creation/deletion, slot/subslot traversal, software containers, network connections, hardware parameters. |
| `tia-plc-operations` | C# PLC software engineering: program/system blocks, PLC tags/UDTs, software units, Safety, alarms, OPC-UA, technological objects, watch/force tables, online/download, compare. |
| `tia-hmi-operations` | C# HMI Classic and Unified: separate object models for targets/software, screens/items, tags, alarms, scripts, connections, logging, runtime settings, and compile/import/export. |
| `tia-networks` | C# topology: subnets, nodes, IO systems, port channels, addresses, IO timing. |
| `tia-simatic-drives` | C# Startdrive / SINAMICS: drive controller access, drive engineering, motion control, download. |
| `tia-import-export` | C# & Python import/export: SimaticML, AML/CAx, PLC blocks, HMI screens/tags/alarms, hardware AML, project data. |
| `tia-multiuser` | C# Multiuser Engineering: project-server connections, server-project identity, local/exclusive sessions, marking, locking, save/discard/commit. |
| `tia-teamcenter` | C# provider-based Teamcenter Gateway: connection, search/download, dataset locking, and project/global-library save workflows. |
| `tia-testsuite` | C# TestSuite & Application Test: test sets, application tests, style-guide rules, automated system testing. |
| `tia-sivarc` | C# SiVArc: rule tables and libraries, definitions, expression resolution, layout exchange, and guarded visualization generation. |
| `addin-operations` | TIA Portal Add-In development: project structure, VS Code workflow, Add-In lifecycle, menus, permissions, deployment. |

---

## Prerequisites

### For Python TIA Scripting

- Siemens TIA Portal V17 or later
- TIA Scripting Python downloaded from Siemens Industry Online Support
- Python 3.12.x for the current `siemens_tia_scripting` wheel

### For C# Openness

- Siemens TIA Portal V21 for these audited API references
- V21 modular Openness API, including `Siemens.Engineering.Base.dll` under `PublicAPI\V21\net48`
- .NET Framework 4.8 or later

### For Add-In development

- Visual Studio 2022 or VS Code with C# Dev Kit
- TIA Portal Add-In SDK (available from Siemens Industry Online Support)

TIA Scripting Python is not installed from PyPI by package name. Download the
TIA Scripting Python ZIP from Siemens, then use one of Siemens' supported setup
paths:

- File import: unzip it and set `TIA_SCRIPTING` to the extracted `binaries`
  directory.
- Wheel install: from the extracted `binaries` directory, install the matching
  wheel file, for example:

```powershell
cd C:\Path\To\Your\TIA_Scripting_Python\binaries
py -3.12 -m pip install .\siemens_tia_scripting-x.x.x-cp312-cp312-win_amd64.whl
```

To check a local machine, run the bundled doctor probe:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File skills\tia-doctor\probe.ps1 -RequiredMajorVersion 21
```

For machine-readable output:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File skills\tia-doctor\probe.ps1 -RequiredMajorVersion 21 -Json
```

For a C#-only V21 check while Python and MCP are intentionally out of scope:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File skills\tia-doctor\probe.ps1 -RequiredMajorVersion 21 -SkipPython -SkipMcp
```

---

## Installation

Install from GitHub or clone this repository and link it locally while developing.

### Claude Code

```bash
/plugin marketplace add Czarnak/totally-integrated-claude
```

### Codex

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

### TIA Portal MCP write safety

TIA Portal MCP write tools use a preview-then-apply workflow. First call the matching `preview_*` tool, review the summary/diff and `currentStateHash`, then pass the returned `safetyToken` to the write tool with `confirm=true`.

Examples:

| Write | Required preview |
| --- | --- |
| `update_block_logic` | `preview_update_block_logic` |
| `create_tag_table`, `delete_tag_table` | `preview_create_tag_table`, `preview_delete_tag_table` |
| `create_tag`, `update_tag`, `delete_tag` | `preview_create_tag`, `preview_update_tag`, `preview_delete_tag` |
| `create_user_constant`, `update_user_constant`, `delete_user_constant` | matching `preview_*_user_constant` tool |
| `add_network_device`, `configure_network_device` | `preview_add_network_device`, `preview_configure_network_device` |
| `open_project`, `create_project`, `save_project`, `save_project_as`, `archive_project`, `close_project` | matching `preview_*_project` tool |

Claude Code also loads `hooks/tia-write-guard.ps1` through `hooks/hooks.json` as defense-in-depth. The MCP server is still the authority: other clients must use the same preview token flow.

### Environment diagnostics

Use `tia-doctor` when TIA Portal automation fails because of missing local
prerequisites. It is a read-only PowerShell probe that checks the exact V21 Portal
executable, `Siemens.Engineering.Base.dll` and installed modular API metadata, and
membership in the `Siemens TIA Openness` Windows user group. Python TIA Scripting
and `tia-mcp` checks are optional and can be skipped independently.

### Routing examples

| Task | Path | Domain skill |
| --- | --- | --- |
| Explore project structure interactively | MCP | `tia-portal-mcp` |
| Analyze raw SCL/ST, SIMATIC SD, or SimaticML for security issues | Standalone | `plc-code-analysis` |
| Read/write PLC blocks and tags | Python | `tia-python` |
| HMI screen access and export | Python | `tia-python` |
| Device slot/subslot manipulation | C# | `tia-devices-general` |
| Subnet and IO-system configuration | C# | `tia-networks` |
| SINAMICS drive engineering | C# | `tia-simatic-drives` |
| Advanced PLC online/security services | C# | `tia-plc-operations` |
| Multiuser Engineering (server projects) | C# | `tia-multiuser` |
| Teamcenter managed projects | C# | `tia-teamcenter` |
| Automated PLC/HMI testing | C# | `tia-testsuite` |
| SiVArc rules or visualization generation | C# | `tia-sivarc` |
| TIA Portal Add-In project | C# | `addin-operations` |

---

## Worth installing to boost your workflow

- C# LSP plugin from [Claude Plugins Official](https://github.com/anthropics/claude-plugins-official)
- [Tia Portal MCP Server](https://github.com/Czarnak/tia-portal-mcp)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contributor setup, validation
commands, test expectations, skill authoring rules, and safety requirements.

## Sources

- [TIA Portal Openness docs](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/)
- [TIA Scripting Python](https://support.industry.siemens.com/cs/document/109742322/tool-for-easier-use-of-the-tia-portal-openness-interface-(tia-scripting-python))

## Examples

- [PLC Block Scanner](https://github.com/Czarnak/plc-block-scanner) - as simple as possible, strictly as an example.
- [TIA Git Add-In](https://github.com/Czarnak/tia-git-addin) - Add-In for TIA Portal V21 making version control comfortable for PLC engineers.

## License

MIT — see [LICENSE](LICENSE).
