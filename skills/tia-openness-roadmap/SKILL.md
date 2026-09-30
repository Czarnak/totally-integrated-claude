---
name: tia-openness-roadmap
description: >
  Entry point for TIA Portal engineering automation tasks. Routes to the requested
  or appropriate MCP, Python, C#, MAC Module Builder, diagnostic, or Add-In
  implementation. Pure review of already supplied/exported PLC code uses the
  standalone plc-code-analysis skill.
license: MIT
---

# tia-openness-roadmap

## Goal

Route the task to the correct implementation path and load the right skill files.

## Mandatory policy

1. Honor the user's explicit implementation and scope constraints (including a
   request to skip Python, C#, or live operations).
2. Prefer **TIA Scripting Python** for scripted/multi-step automation only when the exact wrapper operation is documented.
3. Use **C# TIA Portal Openness** when requested or when its exact installed API is the appropriate/required surface.
4. Use **MAC Module Builder** for Modular Application Creator modules, lifecycle
   phases, `.tiares`, generated/custom ownership, and MAC packaging or qualification.
5. Do not invent wrapper, Openness, MAC, or Module Builder methods.
6. For multi-domain tasks, select all required skills.

## Standalone analysis exclusion

For review/security/quality analysis of pasted or exported PLC code, use
`plc-code-analysis` as a standalone skill and do not load this roadmap. That skill
accepts raw SCL/ST, SIMATIC SD, and SimaticML without authorizing engineering writes
or live TIA operations.

## Implementation paths

### Python path

Single skill owns all Python implementation:

| Skill | Location |
|---|---|
| `tia-python` | `skills/tia-python/SKILL.md` |

`tia-python` contains its own reference file table that routes to the correct
`references/*.md` file based on the task domain (PLC, HMI, library, project, portal).

### C# path

Always starts with the common foundation skill, then domain skill(s):

| Skill | Location | Role |
|---|---|---|
| `tia-csharp-common` | `skills/tia-csharp-common/SKILL.md` | Mandatory first load for every C# task |
| `tia-project-general` | `skills/tia-project-general/SKILL.md` | Domain skill |
| `tia-devices-general` | `skills/tia-devices-general/SKILL.md` | Domain skill |
| `tia-hmi-operations` | `skills/tia-hmi-operations/SKILL.md` | Domain skill |
| `tia-plc-operations` | `skills/tia-plc-operations/SKILL.md` | Domain skill |
| `tia-networks` | `skills/tia-networks/SKILL.md` | Domain skill |
| `tia-simatic-drives` | `skills/tia-simatic-drives/SKILL.md` | Domain skill |
| `tia-import-export` | `skills/tia-import-export/SKILL.md` | Domain skill |
| `tia-multiuser` | `skills/tia-multiuser/SKILL.md` | Domain skill |
| `tia-teamcenter` | `skills/tia-teamcenter/SKILL.md` | Domain skill |
| `tia-testsuite` | `skills/tia-testsuite/SKILL.md` | Domain skill |
| `tia-sivarc` | `skills/tia-sivarc/SKILL.md` | Domain skill |

### MAC Module Builder path

Dedicated higher-level path for Siemens Modular Application Creator source and
Module Builder workflows:

| Skill | Location |
|---|---|
| `tia-mac-module-builder` | `skills/tia-mac-module-builder/SKILL.md` |

Use it for `TiaEquipmentModule`, MAC lifecycle/model/use-case code, `.tiares`,
generated library wrappers, packaging, `MacFunctionTest`, and
`MacGenerationTest`. If the module directly uses raw `Siemens.Engineering`
objects, also route that part through the C# common and domain skills.

### Add-In path

Standalone skill for TIA Portal Add-In development (always C#, VS Code workflow):

| Skill | Location |
|---|---|
| `addin-operations` | `skills/addin-operations/SKILL.md` |

## Routing rules

| Task pattern | Implementation | Skill |
|---|---|---|
| prerequisite / environment / missing install diagnostics | Diagnostic probe | `tia-doctor` |
| open/create/save/archive/retrieve project | Python | `tia-python` |
| project server / local session / portal attach | Python | `tia-python` |
| PLC blocks / tags / UDTs / sources / compile | Python | `tia-python` |
| PLC online / download / compare-to-online | Python | `tia-python` |
| HMI tags / screens / scripts / alarms / lists | Python | `tia-python` |
| HMI import/export / compile | Python | `tia-python` |
| library types / versions / instantiate / update | Python | `tia-python` |
| XML / SimaticML / AML / CAx import/export | Python | `tia-python` |
| generic device compile / upgrade / properties | Python | `tia-python` |
| topology / subnet / node / IO-system / port | C# | `tia-networks` |
| Startdrive / SINAMICS / drive controller | C# | `tia-simatic-drives` |
| device item slot/subslot/module manipulation | C# | `tia-devices-general` |
| advanced PLC online/security/upload services | C# | `tia-plc-operations` |
| advanced Classic or Unified HMI / screen items / runtime | C# | `tia-hmi-operations` |
| VCI / version control interface | C# | `tia-project-general` |
| project/global libraries, master copies, library types/versions, library update or harmonization | C# | `tia-project-general` |
| multiuser engineering / server projects / local sessions | C# | `tia-multiuser` |
| Teamcenter integration / managed projects | C# | `tia-teamcenter` |
| automated testing / TestSuite / application test / style guide / system test | C# | `tia-testsuite` |
| SiVArc rules / definitions / expression resolver / layout data / generation | C# | `tia-sivarc` |
| Modular Application Creator / MAC / Module Builder / `TiaEquipmentModule` / `.tiares` | MAC Module Builder | `tia-mac-module-builder` |
| MAC function tests / generation tests / packaging | MAC Module Builder | `tia-mac-module-builder` |
| TIA Portal Add-In / addin-project / .addin | C# | `addin-operations` |

## Python vs C# vs MAC Module Builder decision rule

Apply the user's explicit implementation/scope choice before these defaults.

Choose **Python** when the exact required operation exists in the `tia-python` reference files.

Choose **MAC Module Builder** when the task's primary artifact is a Modular
Application Creator module, Module Builder resource/generation input, or MAC
package/test project. This path is source-first; it does not itself authorize a
live generation run.

Choose **C#** when:

- the required operation is absent from the Python reference catalogue
- the task needs low-level object model traversal
- the task needs topology/network object manipulation
- the task needs drive-specific APIs
- the task needs advanced online/security/session/event APIs
- the task needs Teamcenter, VCI, advanced multiuser, or unsupported safety/Unified features
- the task needs SiVArc rules, definitions, layout exchange, expression resolution, or generation

## Multi-skill execution order

1. project / portal
2. device selection
3. domain work
4. import/export
5. compile / compare / download / validation

## Required response format

Use this exact structure:

- `Use skill(s): ...`
- `Implementation path: Python` or `Implementation path: C# Openness` or `Implementation path: MAC Module Builder` or `Implementation path: Diagnostic probe`
- `Reason: ...`
- `Execution order: ...`

## Post-routing action — MANDATORY

**If Diagnostic probe:** read `skills/tia-doctor/SKILL.md` and run its probe command.
Report the probe output and remediation items. Do not create or modify projects.

**If Python:** read `skills/tia-python/SKILL.md`, then load the reference file(s) it
points to for the task domain. Do NOT load domain skills — they are for C# only.

**If MAC Module Builder:** read `skills/tia-mac-module-builder/SKILL.md`, then
load only the reference file(s) selected by its reference table. If direct raw
Openness work is required, additionally follow the C# path for that domain.

**If C#:**

1. Read `skills/tia-csharp-common/SKILL.md` first — always, for every C# task.
2. Read the `SKILL.md` of each selected domain skill, then load only the
   `references/*.md` file(s) that skill's own reference table (or its
   `reference_catalogue.md`, where present) points to for the task.

**If Add-In:** read `skills/addin-operations/SKILL.md`. No other skills needed.

Do NOT write code based solely on the routing response — always load the skill files first.

## Escalation rule

If implementation starts in Python and the required call is not documented:

- stop
- switch to the corresponding C# domain skill
- load `tia-csharp-common` first, then the domain skill
- keep the same task decomposition

## Hard escalation triggers (always C#)

- device item slot/subslot operations
- subnet/node/IO-system/port/channel/address manipulation
- Teamcenter / ConnectSSO
- VCI / advanced multiuser
- advanced PLC online/security services
- advanced Unified internals
- drive-specific engineering
- SiVArc engineering or generation
- diagnostics / event handlers / self-description APIs
