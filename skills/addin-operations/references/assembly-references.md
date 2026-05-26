# Assembly references for TIA object access

The `addin-project` template auto-references five Add-In framework assemblies:
`Siemens.Engineering.Base`, `Siemens.Engineering.AddIn.Base`, `Siemens.Engineering.AddIn.Step7`,
`Siemens.Engineering.AddIn.Utilities`, `Siemens.Engineering.AddIn.Permissions`.

These provide the Add-In framework types (`ContextMenuAddIn`, `ProjectTreeAddInProvider`, etc.)
but **do not expose the full TIA Portal object model**. If the Add-In needs to access PLC
software, blocks, tags, or devices, additional assemblies must be added manually.

---

## Namespace → assembly map

| Namespace | Assembly to add to csproj | Key types |
| --- | --- | --- |
| `Siemens.Engineering.HW` | already in `Base` | `Device`, `DeviceItem`, `DeviceItemComposition` |
| `Siemens.Engineering.HW.Features` | already in `Base` | `SoftwareContainer` |
| `Siemens.Engineering.SW` | `Siemens.Engineering.Step7.dll` | `PlcSoftware` |
| `Siemens.Engineering.SW.Blocks` | `Siemens.Engineering.Step7.dll` | `PlcBlock`, `PlcBlockGroup`, `PlcBlockSystemGroup`, `PlcBlockUserGroup`, `PlcSystemBlockGroup`, `OB`, `FB`, `FC`, `GlobalDB`, `InstanceDB` |
| `Siemens.Engineering.SW.Tags` | `Siemens.Engineering.Step7.dll` | `PlcTagTable`, `PlcTag` |
| `Siemens.Engineering.SW.Types` | `Siemens.Engineering.Step7.dll` | `PlcTypeComposition` |

> **Note:** `Siemens.Engineering.AddIn.Step7.dll` (included by the template) is **not** the
> same as `Siemens.Engineering.Step7.dll`. The `AddIn.Step7` dll provides Add-In framework
> integration only — it does not expose `PlcSoftware` or block types.

---

## How to add an extra assembly reference to the csproj

The template generates **two** `ItemGroup` blocks with references — one inside a `<Target>`
element (condition `== ''`) and one at the outer level (condition `!= ''`). Add the new
`<Reference>` entry to **both** blocks, immediately after the last existing `<Reference>`.

```xml
<!-- Inside <Target Name="SetEngineeringAddinReferences"> / <ItemGroup> -->
<Reference Condition="'$(TiaPortalLocation)' == ''" Include="Siemens.Engineering.Step7">
  <HintPath>$(TiaPortalLocation)\PublicAPI\V21\net48\Siemens.Engineering.Step7.dll</HintPath>
  <Private>False</Private>
</Reference>

<!-- In the outer <ItemGroup> below the <Target> blocks -->
<Reference Condition="'$(TiaPortalLocation)' != ''" Include="Siemens.Engineering.Step7">
  <HintPath>$(TiaPortalLocation)\PublicAPI\V21\net48\Siemens.Engineering.Step7.dll</HintPath>
  <Private>False</Private>
</Reference>
```

`<Private>False</Private>` means Copy Local = false — mandatory for all Siemens assemblies.

> **csproj formatting trap:** keep each `<HintPath>` on a single line. A line
> break inside `Portal V21` (or any other path segment) makes MSBuild treat the
> reference as invalid. The build then fails with **cascading missing-type
> errors** (`MasterCopy`, `ImportOptions`, `LibraryTypeVersionState`, …) that
> look like API mismatches but are actually load failures.
>
> To keep paths readable, define a shared property once and use it in every
> `<HintPath>`:
>
> ```xml
> <PropertyGroup>
>   <TiaPortalPublicApiV21>$(TiaPortalLocation)\PublicAPI\V21\net48</TiaPortalPublicApiV21>
> </PropertyGroup>
>
> <Reference Include="Siemens.Engineering.Step7">
>   <HintPath>$(TiaPortalPublicApiV21)\Siemens.Engineering.Step7.dll</HintPath>
>   <Private>False</Private>
> </Reference>
> ```
