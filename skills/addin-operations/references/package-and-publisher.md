# Add-In package format and V21 publisher

## Package shape

A compiled `.addin` file is a ZIP archive containing the Add-In assembly plus
small metadata entries. It can be inspected with any ZIP tool.

Key entries:

| Entry | Purpose |
| --- | --- |
| `<name>,version=...,culture=...,publickeytoken=...,processorarchitecture=msil` | URL-encoded assembly entry — the main `.dll` |
| `EngineeringVersion` | Single text token (e.g. `V20`, `V21`) — gates which TIA Portal version will load the package |
| `Meta/Version` | Package version (matches `AddInVersion`) |
| `Meta/PublisherTarget` | XML namespace URL of the publisher schema used |

For V21, the publisher target is:

```
http://www.siemens.com/automation/Openness/AddIn/Publisher/V21
```

For V20, it was the corresponding `/V20` URL.

---

## V21 publisher

V21 ships its own Add-In publisher (separate from the build tools). The
publisher consumes a config XML and the compiled assembly, then emits a
versioned `.addin` package.

Minimum read-only publisher config (`PublisherConfig.V21.xml`):

```xml
<?xml version="1.0" encoding="utf-8"?>
<PackageConfiguration
    xmlns="http://www.siemens.com/automation/Openness/AddIn/Publisher/V21">
  <AddInVersion>V0.1</AddInVersion>
  <Product>
    <Name>My Add-In</Name>
    <Id>com.example.my-addin</Id>
    <Version>0.0.1.0</Version>
  </Product>
  <FeatureAssembly>
    <AssemblyInfo>
      <Assembly>MyAddIn.dll</Assembly>
    </AssemblyInfo>
  </FeatureAssembly>
  <RequiredPermissions>
    <TIAPermissions>
      <TIA.ReadOnly />
    </TIAPermissions>
  </RequiredPermissions>
</PackageConfiguration>
```

`PackageConfiguration`, `Product`, `FeatureAssembly`, and
`RequiredPermissions` are required by the installed V21 publisher schema.
`EngineeringVersion`, `Assembly`, and `OutputPackage` are not root-level V21
configuration elements. Use the XSD shipped beside the publisher as the
authoritative shape:

```text
C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\
  Siemens.Engineering.AddIn.Publisher.xsd
```

---

## Required project settings for V21

- `<TargetFramework>net48</TargetFramework>` — V21 still loads under .NET 4.8.
- The Siemens V21 template default is `AnyCPU` (it does not set
  `PlatformTarget`). V21 Add-In development and execution are unsupported on
  32-bit computers, so do not target `x86`. The V21 publisher schema does not
  impose an `x64` rejection rule.
- Assembly version, `AddInVersion`, and `Product/Version` are separate values.
  `AddInVersion` is independent of the TIA Portal and project versions; there
  is no requirement for an assembly-version major of `21`.

---

## Verifying a published package

Open the `.addin` as a ZIP and confirm:

1. `EngineeringVersion` entry contains exactly `V21` (no whitespace, no BOM).
2. `Meta/PublisherTarget` ends with `/V21`.
3. The feature-assembly entry contains the assembly version and processor
   architecture that were actually built; neither must encode `21`.
4. Every non-framework managed dependency is listed under
   `AdditionalAssemblies`; no native DLL is bundled. See
   [`runtime-gotchas.md`](runtime-gotchas.md) → "Managed dependency packaging".
