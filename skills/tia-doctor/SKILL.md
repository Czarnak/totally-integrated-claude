---
name: tia-doctor
description: Manual prerequisite probe for TIA Portal, Openness, Python TIA Scripting, and TIA MCP.
disable-model-invocation: true
license: MIT
---

# tia-doctor

Use this skill only when the user explicitly asks to diagnose, verify, or debug
the local TIA Portal automation environment.

## Run

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File skills\tia-doctor\probe.ps1
```

For machine-readable output:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File skills\tia-doctor\probe.ps1 -Json
```

## Interpret Results

- `pass`: prerequisite is present and usable.
- `warn`: optional probe could not be completed, or a non-required item is missing.
- `fail`: required prerequisite is missing or unusable.

Report missing items with the remediation text from the probe output. Do not
invent installation commands if the probe already provided one.

## Checks

The probe checks:

- TIA Portal install and detected version.
- Openness assembly presence and version evidence.
- Current Windows user membership in the `Siemens TIA Openness` local group.
- `siemens_tia_scripting` importability through `py` or `python`.
- `tia-mcp` command or `TiaMcpServer` dotnet global tool.

The probe is read-only. It must not create projects, open TIA Portal, modify
registry keys, install tools, or change user configuration.
