---
name: tia-multiuser
description: >
  TIA Portal Multiuser Engineering operations. Use for managing server projects,
  local sessions, and multiuser commissioning workflows.
---

# TIA Portal Multiuser Engineering

## Scope

Multiuser Engineering workflows using the TIA Portal Openness API.
Covers Local Sessions, Server Projects, and Multiuser Commissioning.

---

## Reference files

Load ONLY the reference file(s) relevant to the task.

| Reference file | Load when the task involves |
|---|---|
| `references/v21-api-surface.md` | Comprehensive reference for `Siemens.Engineering.Multiuser` (LocalSession, ServerProject, MultiuserService). |

---

## Key Workflows

### Managing Local Sessions

1. Locate the `MultiuserService` on the Project.
2. Use `LocalSession` to interact with server projects.
3. Perform `Update()` to sync with the server.
4. `CheckIn()` changes to the server project.

### Multiuser Commissioning

1. Access `MultiuserCommissioningService` for commissioning tasks.
2. Manage asynchronous execution states.

## Enforcement

1. Always verify the `LocalSession` state before performing a `CheckIn`.
2. Use `AccessOptions` to handle conflicts during `Update`.
