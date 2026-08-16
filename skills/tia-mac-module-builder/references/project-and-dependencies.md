# Project and dependencies

## Audited V21.0.5 baseline

The clean local `ControlModule1` V21.0.5 sample establishes this baseline:

| Concern | Audited value |
|---|---|
| TIA Portal generation target | TIA Portal V21 |
| Target framework | .NET Framework 4.8 |
| Module Builder tasks | `Siemens.EquipmentModule.Build.Tasks` 21.0.5 |
| MAC basics | `Siemens.ModularApplicationCreator.Basics` 21.0.5 |
| MAC core | `Siemens.ModularApplicationCreator.Core` 21.0.5 |
| JSON support | `Newtonsoft.Json` 13.0.3 |
| NuGet packaging helper | `NuGetizer` 1.2.1 |

Treat this as a compatible MAC V21.0.5 baseline, not a universal template and
not proof of the latest versions. The broader local example set contains mixed
V19, V20, and V21 projects; do not copy dependencies across them without an
explicit migration review.

## Project inspection checklist

Before adding or changing code, capture:

- solution and project path;
- target framework and platform/build configuration;
- MAC and Module Builder package IDs and exact versions;
- target TIA Portal PublicAPI major/version and how the project resolves its location;
- package feeds and restore provenance;
- `.tiares`, `.nuspec`, `.license`, XAML, localization, and help resources;
- generated-file markers and custom extension conventions; and
- the test projects and runner actually present in the solution.

Prefer the registered PublicAPI location that matches the established target
version, or the repository's existing validated resolver, over a
machine-specific hard-coded path. For the audited MAC V21.0.5 baseline, that is
the registered V21 Openness PublicAPI. If the reference cannot be resolved,
diagnose it with `tia-doctor`; do not silently fall back to another installed
TIA major version.

## Version gate

Keep these version axes aligned unless authoritative migration guidance says
otherwise:

1. target TIA Portal major version;
2. referenced `Siemens.Engineering` PublicAPI assembly;
3. MAC/Module Builder package version;
4. generated resource-wrapper version;
5. target .NET Framework; and
6. test/generation host.

A successful NuGet restore or C# compile proves only that the selected inputs
are syntactically and binary compatible enough for that step. It does not prove
that Module Builder can generate against the intended TIA project.

## Migration procedure

For a version change:

1. inventory every project and package version in the solution;
2. obtain the target version's installed payload or authoritative package/docs;
3. compare project properties, package metadata, lifecycle interfaces,
   resources, and generated outputs;
4. update generator inputs and dependencies together;
5. regenerate rather than hand-edit generated wrappers;
6. run static/build tests; and
7. perform a separately authorized generation qualification against an exact
   disposable or backed-up TIA project.

Do not mix a V21 PublicAPI reference with V19/V20 MAC packages merely because a
sample builds. Record any intentional deviation and its direct test evidence.

## Restore and build hygiene

Use the repository's existing restore/build commands. Do not add an untrusted
feed, disable package signature/provenance controls, or copy Siemens binaries
into the repository to make a build succeed. When the local package source is
required, report that environmental prerequisite rather than disguising it as
a source-code failure.
