# tia-openness-roadmap — reference catalogue

## Routing summary

| Implementation | Entry skill | Covers |
|---|---|---|
| Python | `tia-python` | All Python wrapper operations (project, PLC, HMI, library, import/export) |
| C# | domain skill | Operations beyond Python wrapper coverage |
| Add-In | `addin-operations` | TIA Portal Add-In development in VS Code |

## Python routing (single skill)

`tia-python` internally routes to the correct reference file:

| Reference file | Domain |
|---|---|
| `references/global_portal.md` | Portal open/attach, UMAC, credentials |
| `references/project.md` | Project lifecycle, transactions, CAx, TestSuite |
| `references/plc.md` | PLC blocks, tags, UDTs, online, download, compile |
| `references/hmi.md` | HMI screens, tags, scripts, alarms, connections |
| `references/library.md` | GlobalLibrary, ProjectLibrary, types, versions |

## C# routing (domain skills)

| Task pattern | Domain skill |
|---|---|
| topology / subnet / node / IO-system / port | `tia-networks` |
| Startdrive / SINAMICS / drive controller | `tia-simatic-drives` |
| device item slot/subslot/module manipulation | `tia-devices-general` |
| advanced PLC online/security/upload services | `tia-plc-operations` |
| deep Unified HMI / screen items / runtime | `tia-hmi-operations` |
| advanced multiuser / VCI / Teamcenter | `tia-project-general` |
| cross-domain import/export beyond wrapper | `tia-import-export` |

## Hard escalation triggers (always C#)
- device item slot/subslot operations
- subnet/node/IO-system/port/channel/address manipulation
- Teamcenter / ConnectSSO
- VCI / advanced multiuser
- advanced PLC online/security services
- advanced Unified internals
- drive-specific engineering
- diagnostics / event handlers / self-description APIs
