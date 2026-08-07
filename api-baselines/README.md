# Certified TIA Portal V21 API baseline

This directory stores portable evidence extracted from a real TIA Portal V21
`PublicAPI\V21\net48` installation. GitHub-hosted runners validate these files;
they do not probe for TIA Portal and they do not claim runtime, licensing, or
hardware evidence.

Each module baseline records the assembly and file versions, DLL and XML
SHA-256 hashes, documented member-surface hash, namespaces, and exact
XML-documented type names. `modules.json` defines which assemblies belong to each product
module and whether its documentation catalogue is complete or partial.

## Module policy

| Module | Required on extraction machine | Documentation coverage |
| --- | --- | --- |
| Base | Yes | Partial |
| Add-In | No | Partial |
| STEP 7 | No | Partial |
| Safety | No | Partial |
| HMI Classic and Unified | No | Complete |
| Startdrive | No | Complete |
| SiVArc | No | Complete |
| Teamcenter Gateway | No | Complete |
| Test Suite | No | Complete |

An optional module is considered installed only when all DLL/XML pairs listed
for it are present. Its absence is recorded in the extraction manifest and does
not fail extraction or comparison. Missing Base evidence is blocking. This
allows a maintainer to certify a base TIA installation without requiring every
separately installed Siemens option.

For complete catalogues, portable validation requires every certified type to
have a documentation heading and rejects headings that are not in the certified
surface. Partial catalogues reject invented headings but do not require every
API type to be documented.

## Hosted validation

The following command uses only repository files and is safe on a runner with
no TIA installation:

```powershell
pwsh -NoProfile -File .\scripts\api-baseline.ps1 -Mode Validate
```

`scripts/validate-repo.ps1` runs the same check. It validates baseline schema,
module/assembly membership, deterministic type ordering and counts, hash shape,
duplicate types, and documentation headings.

## Maintainer certification

Run extraction on a Windows machine with the relevant V21 products installed:

```powershell
pwsh -NoProfile -File .\scripts\api-baseline.ps1 `
  -Mode Extract `
  -CandidateRoot .\build\api-baseline-candidate\v21 `
  -Force

pwsh -NoProfile -File .\scripts\api-baseline.ps1 `
  -Mode Compare `
  -CandidateRoot .\build\api-baseline-candidate\v21
```

Pass `-PublicApiPath` when V21 is installed outside the standard Siemens path.
Add `-JsonOutput` for machine-readable extraction or comparison results.

Comparison reports changed assembly metadata, member surfaces, and added or
removed types for every installed module. An absent optional module is skipped;
its committed baseline remains the last certified evidence for that product.

## Intentional baseline update

Review the comparison and the relevant skill documentation before promoting a
candidate. Then copy only candidates that were actually extracted:

```powershell
$config = Get-Content .\api-baselines\v21\modules.json -Raw | ConvertFrom-Json
foreach ($moduleId in $config.modules.id) {
    $candidate = ".\build\api-baseline-candidate\v21\$moduleId.json"
    if (Test-Path -LiteralPath $candidate) {
        Copy-Item -LiteralPath $candidate -Destination .\api-baselines\v21 -Force
    }
}
```

Do not promote `extraction-manifest.json`; it describes one workstation, not the
repository contract. If Siemens adds or reorganizes assemblies, update
`modules.json` deliberately, extract again, and review the resulting module
boundaries. Finish with portable validation, the opt-in reference audit, and a
clean diff:

```powershell
pwsh -NoProfile -File .\scripts\validate-repo.ps1
pwsh -NoProfile -Command "Invoke-Pester -Path .\tests -ExcludeTagFilter ReferenceAudit -CI"
pwsh -NoProfile -Command "Invoke-Pester -Path .\tests -TagFilter ReferenceAudit -CI"
git diff --check
```
