---
name: tia-teamcenter
description: >
  TIA Portal Teamcenter Integration operations. Use for managing Teamcenter
  storage and interacting with Teamcenter managed projects.
---

# TIA Portal Teamcenter Integration

## Scope

Teamcenter Integration workflows using the TIA Portal Openness API.
Covers Teamcenter storage access and service management.

---

## Reference files

Load ONLY the reference file(s) relevant to the task.

| Reference file | Load when the task involves |
|---|---|
| `references/v21-api-surface.md` | Comprehensive reference for `Siemens.Engineering.Teamcenter` (TeamcenterService, TeamcenterStorage). |

---

## Key Workflows

### Teamcenter Storage

1. Locate the `TeamcenterService` on the Project.
2. Access `TeamcenterStorage` composition.
3. Manage storage objects and project associations.

## Enforcement

1. Ensure the `TeamcenterService` is available before attempting storage operations.
2. Handle Teamcenter-specific exceptions for connection or permission issues.
