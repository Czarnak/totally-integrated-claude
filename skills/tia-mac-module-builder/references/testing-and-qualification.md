# Testing and qualification

## Evidence ladder

Keep each result at its proper level:

| Level | Suitable evidence | What it does not prove |
|---|---|---|
| Contract/static | Skill tests, schema/resource checks, generated/custom ownership checks | Compilation or generation |
| Build/package | Restore, compile, package inspection | Module Builder execution or live TIA behavior |
| Function | Focused module/use-case tests, including the solution's `MacFunctionTest` surface | Generated TIA project state |
| Generation | The solution's `MacGenerationTest` or equivalent against an exact controlled project | Commissioning or hardware behavior |
| Live/commissioning | Authorized runtime inspection and approved plant/hardware tests | Broader targets not exercised |

Static inspection, compilation, package creation, mocks, and fake project
fixtures do not prove live TIA behavior. A successful generation run proves
only the exact toolchain, input, project, and assertions exercised.

## Test discovery

The audited local payload contains test surfaces named `MacFunctionTest` and
`MacGenerationTest`. Treat those names as evidence of available test categories,
not as universal command-line contracts. Inspect the target solution to find:

- the actual test projects and framework;
- required configuration files, packages, and build targets;
- whether a test starts TIA Portal, attaches to an instance, or uses a fixture;
- project/archive identity and reset behavior;
- whether it writes, generates, saves, closes, or deletes anything; and
- how results and diagnostics are persisted.

Never invent runner switches. Use the checked-in command, project metadata, or
the installed version's authoritative instructions.

## MAC GUI/CLI execution boundary

Treat MAC GUI/CLI execution that creates, opens, imports, updates, or generates
a project—or changes package-source, module, template, or variant state—as an
external state-changing operation. Before it runs, require explicit
live-operation authorization, the exact executable and version, the exact
project/module/template/variant identities, intended mutations, overwrite/save
behavior, and a backup or recovery plan.

Read-only help or version discovery is diagnostic evidence only and does not
authorize a follow-on operation. Do not invent MAC CLI commands or switches.
Obtain the exact command surface from version-matching bundled documentation or
the executable's own help, and report help/runtime failures instead of guessing.
Do not translate a GUI label into a presumed CLI verb.

## Minimum source-change verification

For lifecycle, model, or use-case changes:

1. add or update a focused test before production behavior when feasible;
2. observe the relevant failure;
3. implement the smallest change;
4. run focused tests, then the solution's static/build suite;
5. inspect generated/custom ownership and the source diff; and
6. report generation and live qualification as unrun unless they actually ran.

For `.tiares` or generated-resource changes, also compare generated output and
verify stable identities, expected additions/removals, and packaging contents.

## Authorized generation gate

Before `MacGenerationTest`, Module Builder, or any equivalent live generation:

- obtain explicit live-operation authorization;
- identify the installed TIA Portal and MAC/Module Builder versions;
- identify the exact input module/package and target project/archive;
- use a disposable target or confirm backup/recovery;
- inventory intended objects and expected mutations;
- state save, close, and cleanup behavior;
- confirm no production controller or endpoint is implicitly targeted; and
- capture diagnostics without exposing secrets or customer data.

If any identity or recovery condition is unresolved, stop before opening or
mutating the project.

## Qualification report

Record:

- source commit/diff identity;
- MAC, Module Builder, TIA Portal, PublicAPI, and framework versions;
- package sources and hashes where available;
- test command and exit/result summary;
- target project identity and precondition for generation tests;
- generated object identities and meaningful diff; and
- limitations: untested TIA versions, commissioning, hardware, credentials, or
  environmental dependencies.
