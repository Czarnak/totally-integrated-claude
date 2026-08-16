# Resources, packaging, and trust

## Resource flow

MAC projects use declarative resource inputs and Module Builder-generated C#
integration. In the audited examples, the important ownership flow is:

```text
.tiares and project resource inputs
    -> Module Builder generation
    -> TiaImports/ResourceManagement.cs
    -> TiaImports/GeneratedClasses
    -> custom use through TiaImports/CustomLibraryClasses and Model/UseCases
```

Confirm that flow in the target project. Do not invent `.tiares` keys, schemas,
library identities, resource IDs, or generator metadata from a similar module.

## Generated resource wrappers

`TiaImports/ResourceManagement.cs` and
`TiaImports/GeneratedClasses` are generated integration surfaces. If they are
missing or stale:

1. identify the owning `.tiares` or other generator input;
2. confirm the exact MAC/Module Builder version;
3. run the supported generator only in an approved environment;
4. inspect additions, removals, and identity changes in the generated diff; and
5. keep custom logic in supported partial/custom files.

`TiaImports/CustomLibraryClasses` is the expected place for project-owned
library extensions when the generated type design supports them. Validate the
partial type, namespace, and constructor/API contract against the generated
output before adding code.

## UI, help, and localization

Treat XAML, images, help pages, and localized strings as versioned module
resources. Preserve resource build actions, culture suffixes, stable lookup
keys, and fallback behavior. Verify both missing-key handling and at least one
non-default locale when localization changes.

Do not embed environment-specific absolute paths or customer identifiers in
resources. Validate any rich text or externally sourced help content before it
is rendered by the module UI.

## Packaging

MAC/Module Builder solutions may contain `.nuspec`, `.nupkg`, `.license`, or
NuGetizer-driven metadata. Before producing a package, verify:

- package ID and version source;
- included assemblies, generated files, `.tiares`, UI/help resources, and
  transitive dependencies;
- target framework and TIA/MAC compatibility metadata;
- license and notices for content actually shipped; and
- absence of local paths, credentials, project archives, logs, or customer data.

Inspect the resulting archive, not only the project file. A successful pack
command does not prove that required resources are present or that proprietary
inputs may be redistributed.

## Trust boundary

- Treat private feeds, local Siemens installers/packages, generated library
  wrappers, and example repositories as separate provenance domains.
- Public example source under a permissive license does not grant rights to
  redistribute Siemens binaries, private feeds, or customer-generated assets.
- Do not execute package build targets from an unapproved source.
- Pin or otherwise record the exact package source and version used for
  reproducible evidence.
- If provenance or redistribution rights are unclear, stop at a local build or
  draft package and state the unresolved boundary.

