# Architecture and lifecycle

## Position in the TIA stack

Modular Application Creator (MAC) is a higher-level engineering framework. A
module describes reusable engineering intent; Module Builder translates that
intent into operations against a matching TIA Portal/Openness environment. Keep
these layers distinct:

1. **module contract** — entry point, parameters, model, and declared resources;
2. **use-case logic** — custom orchestration and domain decisions;
3. **generated integration** — typed resource and library wrappers;
4. **raw Openness** — direct `Siemens.Engineering` access; and
5. **live TIA result** — concrete project objects created or changed at runtime.

The concrete entry class derives from or implements the version-appropriate
`TiaEquipmentModule` contract. Inspect the installed MAC V21.0.5 assemblies and
the target project before writing a signature; do not recreate a lifecycle API
from memory.

## Lifecycle phases

The audited V21.0.5 examples organize generation around these ordered phases:

1. `CleanUp` — remove or reset module-owned intermediate state when the module
   contract calls for it;
2. `Init` — resolve initial context and create the first module state;
3. `PostInit` — finish initialization that depends on the initial objects;
4. `Build` — create or configure the main engineering content;
5. `Refine` — resolve relationships or details that require built objects; and
6. `Complete` — finish module-owned work and produce final status/evidence.

Do not assume every phase is safe to repeat or that failure is transactional.
For the target module, inspect what each phase reads, creates, changes, and
deletes; identify its retry and partial-failure behavior before a live run.

## Recommended source shape

Keep custom intent close to its owning layer:

- the concrete module entry class coordinates lifecycle phases;
- model types hold configuration and stable domain state;
- `Model/UseCases` holds focused orchestration rather than UI concerns;
- UI/view-model code collects and validates user input;
- `.tiares` and related resource inputs describe generated integrations; and
- direct Openness helpers remain domain-focused and follow the routed TIA skill.

Prefer small use cases with explicit inputs and results over one lifecycle
method that directly traverses the whole TIA object graph. Resolve objects by
stable identity or exact validated name; never select the first object merely
because a collection is non-empty.

## Generated and custom ownership

Treat the following as Module Builder output unless the local project supplies
contrary evidence:

- `Base*GeneratedItems.cs`;
- `TiaImports/ResourceManagement.cs`;
- `TiaImports/GeneratedClasses`.

Typical custom areas are:

- the concrete module entry class;
- `Model/UseCases`;
- UI and view-model implementations; and
- `TiaImports/CustomLibraryClasses`, usually as supported partial/custom
  extensions around generated library types.

Never patch a generated type to add custom behavior. Put the behavior in the
supported custom/partial surface or change the generator input, regenerate with
the matching Module Builder version, and review the complete generated diff.

## Crossing into raw Openness

When a use case directly manipulates `Siemens.Engineering` objects, load
`tia-csharp-common` plus the relevant domain skill. MAC lifecycle knowledge does
not replace project, PLC, device, network, HMI, drive, library, Test Suite, or
other Openness contracts. Keep direct mutations behind the same permission,
identity, save, and evidence gates as standalone Openness automation.

