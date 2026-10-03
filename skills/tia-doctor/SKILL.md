---
name: tia-doctor
description: Manual, read-only prerequisite probe for TIA Portal V21 and its modular Openness API, with an optional Python TIA Scripting check.
disable-model-invocation: true
license: MIT
---

# tia-doctor

Use this skill only when the user explicitly asks to diagnose, verify, or debug
the local TIA Portal automation environment.

## Run

Full probe:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File skills\tia-doctor\probe.ps1 -RequiredMajorVersion 21
```

V21 C# Openness core only (the audit mode while Python is intentionally out of scope):

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File skills\tia-doctor\probe.ps1 -RequiredMajorVersion 21 -SkipPython
```

Add `-Json` to either command for machine-readable output.

## Interpret results

- `pass`: the scoped prerequisite is present and usable by the static probe.
- `warn`: an optional probe could not be completed or a non-required item is missing.
- `fail`: a required prerequisite for the requested scope is missing or unusable.

Report missing items using the probe's remediation text. Do not invent an
installation command when the result already supplies one.

## V21 checks

The core probe verifies:

- the exact TIA Portal V21 executable under a common Siemens installation path;
- the V21 modular Public API path (`PublicAPI\V21\net48`);
- the required modular core `Siemens.Engineering.Base.dll`, plus file/assembly
  version evidence and the installed optional `Siemens.Engineering.*` modules;
- current Windows-user membership in the `Siemens TIA Openness` local group.

Registry entries are supplemental evidence only; they do not replace the exact
Portal executable or modular core assembly checks.

Unless skipped, the full probe also checks `siemens_tia_scripting`
importability through `py` or `python`.

Python is a client/tooling choice, not a prerequisite for direct C# Openness.
Use `-SkipPython` whenever that integration is outside scope.

## Safety and evidence boundary

The probe is read-only. It must not open TIA Portal, create projects, load an
Openness assembly into the current process, modify registry keys or groups,
install tools, or change user configuration. Static presence, version metadata,
and group membership do not prove that a project can be opened or that a
credentialed/live operation will succeed.
