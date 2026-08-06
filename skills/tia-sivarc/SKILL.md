---
name: tia-sivarc
description: >
  C# TIA Portal Openness V21 automation for SIMATIC Visualization Architect (SiVArc):
  rule tables, rules and groups, library instances, tag/text definitions, tag member
  settings, expression resolution, layout exchange, definition upgrade, and generation.
license: MIT
---

# tia-sivarc

## Scope

Use this skill for SiVArc engineering through the V21 C# Openness API.

- Assembly: `Siemens.Engineering.Sivarc.dll`
- Namespace: `Siemens.Engineering.SiVArc` (the namespace capitalization differs from the assembly filename)
- Entry point: `Sivarc sivarc = project.GetService<Sivarc>()`
- Prerequisite: load `tia-csharp-common` first

Do not substitute WinCC/HMI APIs for SiVArc rule or generation APIs. SiVArc generation creates, updates, renames, and may remove generated HMI objects; it is a live project mutation, not a read-only build step.

## Reference files

Load only the reference required by the task.

| Reference | Use for |
| --- | --- |
| `references/generation.md` | SiVArc license and generation preflight; exact `GenerationOptions`; result and recursive message handling |
| `references/rules-and-libraries.md` | All six rule families; tables, folders, groups, rules; library copies, type instances, and dynamic device columns |
| `references/definitions-expression-layout.md` | Tag/text definitions, tag member settings, definition upgrade, expression resolution, and screen layout YML import/export |
| `references/api-catalogue.md` | Complete inventory of all 92 installed V21 public SiVArc types |

## V21 service acquisition

```csharp
using Siemens.Engineering;
using Siemens.Engineering.SiVArc;

Sivarc sivarc = project.GetService<Sivarc>();
if (sivarc == null)
    throw new InvalidOperationException("SiVArc is unavailable for the selected project or installation.");
```

Any modification of SiVArc data, including generation, requires a valid SiVArc license. V21 reports a missing license as a recoverable `LicenseNotFound` exception; do not convert that into a successful no-op.

## Safety boundary

- Require explicit authorization for the exact project, HMI runtime/device names, PLC device names, rule objects, generation options, and mutation type.
- Resolve every table, folder, group, rule, block, screen, and library item by an exact selector. Fail on zero or ambiguous matches; never use `.First()`, index zero, or a silent fallback to a default table.
- Before generation, inventory the HMI-to-PLC connections, source PLC compile status, previous/frozen generation selection, rules included by the selected flags, and generated objects that may be replaced or removed.
- `GenerationOptions.None` means “use project settings”; it is not a preview or dry run. `CreateOptions.Replace` can overwrite an existing object.
- Imports, rule expressions, dynamic attribute names, library objects, and YML files are untrusted engineering input. Validate path, provenance, identity, and destination.
- Inspect returned result objects and recursive feedback. Exceptions and error counts fail the operation. Never infer success from a non-null return value.
- Do not claim generation rollback from a transaction without live V21 evidence. Use `ExclusiveAccess` for mutations and only use a transaction for calls proven compatible with it.
- Do not save the project unless persistence was explicitly requested. If validation fails, leave the project unsaved and report that live recovery/rollback was not proven.

## Execution pattern

1. Load `tia-csharp-common` and this skill.
2. Open or attach to the exact project and acquire `Sivarc`.
3. Perform a read-only inventory and resolve exact identities.
4. State the effective rule/generation scope and destructive consequences.
5. Obtain explicit authorization for the mutation.
6. Acquire `ExclusiveAccess`, perform the smallest operation, and capture all results/exceptions.
7. Compile or validate affected PLC/HMI artifacts where the API supports it.
8. Save only when explicitly requested and verification passed.

## Evidence boundary

Static inspection against `Siemens.Engineering.Sivarc.xml` and reflection proves names and signatures only. License availability, project compatibility, generation behavior, retained manual edits, station-selection state, and produced HMI objects require an authorized live TIA Portal V21 run.
