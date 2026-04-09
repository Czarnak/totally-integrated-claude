---
name: tia-openness-roadmap
description: >
  Entry point for ALL TIA Portal engineering automation tasks. Always load this skill FIRST
  when the user mentions TIA Portal, TIA Openness, TIA Scripting, Siemens PLC, Siemens HMI,
  TIA Portal Add-In, or any automation/engineering task targeting TIA Portal.
  This skill routes to the correct domain skill and selects Python vs C# implementation.
  Do not skip this skill and jump directly to domain skills.
---

# tia-openness-roadmap

## Goal
Route the task to the correct implementation path and load the right skill files.

## Mandatory policy
1. Prefer **TIA Scripting Python**.
2. Use **C# TIA Portal Openness** only if Python is insufficient.
3. Do not invent Python wrapper methods.
4. For multi-domain tasks, select all required skills.

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

### Add-In path
Standalone skill for TIA Portal Add-In development (always C#, VS Code workflow):

| Skill | Location |
|---|---|
| `addin-operations` | `skills/addin-operations/SKILL.md` |

## Routing rules

| Task pattern | Implementation | Skill |
|---|---|---|
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
| deep Unified HMI / screen items / runtime | C# | `tia-hmi-operations` |
| advanced multiuser / VCI / Teamcenter | C# | `tia-project-general` |
| TIA Portal Add-In / addin-project / .addin | C# | `addin-operations` |

## Python vs C# decision rule
Choose **Python** when the exact required operation exists in the `tia-python` reference files.
Choose **C#** when:
- the required operation is absent from the Python reference catalogue
- the task needs low-level object model traversal
- the task needs topology/network object manipulation
- the task needs drive-specific APIs
- the task needs advanced online/security/session/event APIs
- the task needs Teamcenter, VCI, advanced multiuser, or unsupported safety/Unified features

## Multi-skill execution order
1. project / portal
2. device selection
3. domain work
4. import/export
5. compile / compare / download / validation

## Required response format
Use this exact structure:
- `Use skill(s): ...`
- `Implementation path: Python` or `Implementation path: C# Openness`
- `Reason: ...`
- `Execution order: ...`

## Post-routing action — MANDATORY

**If Python:** read `skills/tia-python/SKILL.md`, then load the reference file(s) it
points to for the task domain. Do NOT load domain skills — they are for C# only.

**If C#:**
1. Read `skills/tia-csharp-common/SKILL.md` first — always, for every C# task.
2. Read the SKILL.md and `reference_catalogue.md` of each selected domain skill.
   Use the file paths from the C# domain skills table above.

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
- diagnostics / event handlers / self-description APIs