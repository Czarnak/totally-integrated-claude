---
name: tia-mac-module-builder
description: >
  Siemens Modular Application Creator (MAC) and Module Builder development for
  TIA Portal V21. Use for TiaEquipmentModule lifecycle code, module models and
  use cases, generated/custom ownership, .tiares resources, packaging, and MAC
  qualification. Baseline: MAC V21.0.5 on .NET Framework 4.8.
license: MIT
---

# TIA MAC Module Builder

## Scope

Use this skill for source-level development and review of Siemens Modular
Application Creator modules built with Module Builder. It covers the framework
above raw TIA Portal Openness: module lifecycle orchestration, model/use-case
code, generated resource wrappers, UI/help resources, package construction, and
qualification evidence.

The audited baseline is **MAC V21.0.5 for TIA Portal V21 on .NET Framework
4.8**. Treat those versions as a known-compatible baseline, not as a claim that
they are the newest available versions.

Do not use this skill as authority for unrelated raw Openness automation. When
a task crosses into direct `Siemens.Engineering` object access, load
`tia-csharp-common` and the relevant domain skill selected by
`tia-openness-roadmap` alongside this skill.

## Reference files

Load only the reference file(s) needed for the current task.

| Reference file | Load when the task involves |
|---|---|
| `references/architecture-and-lifecycle.md` | `TiaEquipmentModule`, phase ordering, model/use-case structure, or generated/custom ownership. |
| `references/project-and-dependencies.md` | Project creation, V21 references, NuGet dependencies, version migration, or build diagnosis. |
| `references/resources-packaging-and-trust.md` | `.tiares`, generated library wrappers, XAML/help localization, `.nuspec`, `.nupkg`, licensing, or package provenance. |
| `references/testing-and-qualification.md` | `MacFunctionTest`, `MacGenerationTest`, test design, generation qualification, or evidence claims. |

## Required workflow

1. **Establish authority.** Locate the target solution/project, MAC and Module
   Builder versions, TIA Portal major version, target framework, package sources,
   and the file or artifact that proves each value. Do not infer compatibility
   from a nearby sample.
2. **Classify the task.** State whether it is lifecycle/model code, generated
   resource integration, packaging, static review, or authorized generation.
3. **Map ownership before editing.** Separate generated files from custom
   extension points. Never hand-edit generated output to make a build pass.
4. **Load focused references.** Read only the table entries that match the task.
   If direct Openness code is required, load `tia-csharp-common` and the routed
   device, PLC, project, network, HMI, drive, or other domain skill.
5. **Make the smallest source change.** Preserve the module's phase boundaries,
   naming, resources, package metadata, and existing extension patterns.
6. **Verify in layers.** Run project/static tests first. Run Module Builder or
   TIA generation only when the environment and authority are explicit. Report
   static, generated, and live evidence separately.

## Generated ownership gate

Treat these as generated unless the target project proves otherwise:

- `Base*GeneratedItems.cs`;
- `TiaImports/ResourceManagement.cs`;
- `TiaImports/GeneratedClasses` and its descendants.

Typical custom extension points include the concrete module entry class,
`Model/UseCases`, UI/view-model code, and
`TiaImports/CustomLibraryClasses`. Confirm the local project convention before
editing any of them.

If a generated file is wrong, fix the owning source (`.tiares`, model/resource
definition, template input, or supported partial/custom extension), regenerate
with the matching toolchain, and review the generated diff.

## Safety and evidence boundary

- Source edits, package creation, and static tests do not authorize opening,
  modifying, generating into, saving, or closing a TIA Portal project.
- Any Module Builder action that opens or mutates a TIA project requires
  explicit live-operation authorization, exact project identity, exact module
  and target identity, intended save/close behavior, and a recovery plan.
- Package restore or execution requires an approved source and provenance.
  Local Siemens binaries and examples are evidence, not permission to
  redistribute proprietary packages or generated customer artifacts.
- Static inspection, compilation, and mocked tests do not prove live TIA
  behavior. A generation run does not prove commissioning or hardware behavior.
- Never invent `.tiares` keys, package IDs, lifecycle signatures, resource
  identifiers, or test-runner switches. Derive them from the target version's
  project, installed payload, or authoritative documentation.

## Response contract

For implementation guidance or a completed change, report:

1. implementation path: `MAC Module Builder`;
2. verified MAC/TIA/framework baseline and its evidence source;
3. generated files avoided or regenerated and custom files changed;
4. validation actually run and its result;
5. remaining Module Builder, live TIA, commissioning, or hardware proof.

