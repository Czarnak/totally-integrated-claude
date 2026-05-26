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

Minimum publisher config (`PublisherConfig.V21.xml`):

```xml
<?xml version="1.0" encoding="utf-8"?>
<AddInPublisherConfig
    xmlns="http://www.siemens.com/automation/Openness/AddIn/Publisher/V21">
  <EngineeringVersion>V21</EngineeringVersion>
  <Assembly>MyAddIn.dll</Assembly>
  <OutputPackage>MyAddIn V21.addin</OutputPackage>
</AddInPublisherConfig>
```

---

## Required project settings for V21

- `<TargetFramework>net48</TargetFramework>` — V21 still loads under .NET 4.8.
- `<PlatformTarget>AnyCPU</PlatformTarget>` — the V21 publisher rejects `x86`
  and `x64` packages.
- Assembly version stamped via `[assembly: AssemblyVersion("21.x.y.z")]`. The
  major must match the engineering version (`21` for V21 packages) or TIA
  Portal will refuse to load it.

---

## Verifying a published package

Open the `.addin` as a ZIP and confirm:

1. `EngineeringVersion` entry contains exactly `V21` (no whitespace, no BOM).
2. `Meta/PublisherTarget` ends with `/V21`.
3. The assembly entry name contains `version=21.x.y.z`.
4. No `System.Resources.Extensions.dll` or `System.Runtime.CompilerServices.Unsafe.dll`
   is bundled — both fail under partial trust. See
   [`runtime-gotchas.md`](runtime-gotchas.md) → "WinForms `.resx` resources".
