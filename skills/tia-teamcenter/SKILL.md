---
name: tia-teamcenter
description: >
  TIA Portal V21 Teamcenter Gateway operations. Use for connecting to Teamcenter,
  searching/downloading managed projects or libraries, dataset locking, and
  saving projects or global libraries through the installed provider APIs.
license: MIT
---

# TIA Portal Teamcenter Gateway

## Scope

Teamcenter Gateway workflows exposed by `Siemens.Engineering.TeamcenterGateway`.
The V21 API is provider-based: connection, lock, search/download, and workflow
operations are separate services.

## Reference files

Load ONLY the reference file(s) relevant to the task.

| Reference file | Load when the task involves |
|---|---|
| `references/workflows-and-safety.md` | Provider acquisition, credentials, connection ownership, search/download, checkout/check-in, save workflows, cache overwrite, and remote-write safety. |
| `references/v21-api-surface.md` | Complete installed V21 `Siemens.Engineering.TeamcenterGateway` type and member surface. |

## Installed V21 entry points

Portal-scoped providers:

```csharp
TeamcenterConnectionProvider connections =
    tiaPortal.GetService<TeamcenterConnectionProvider>();
TcGatewayLockProvider locks =
    tiaPortal.GetService<TcGatewayLockProvider>();
TcGatewaySearchAndDownloadProvider searchAndDownload =
    tiaPortal.GetService<TcGatewaySearchAndDownloadProvider>();
```

The save provider belongs to the opened project or global library:

```csharp
TcGatewayWorkflowProvider workflow =
    project.GetService<TcGatewayWorkflowProvider>();
```

Do not introduce an intermediate service or storage composition that is absent
from these installed entry points.

## Enforcement

1. Require the exact endpoint, Teamcenter instance, user/group/role or SSO application identity, and expected item/revision/dataset identity.
2. Keep passwords in `SecureString`; treat `TcGatewayConnectionInfo.SessionToken` as a secret and never log or serialize it.
3. Require explicit remote-write authorization for checkout, check-in, checkout cancellation, overwrite download, and every save/new-item/new-revision operation.
4. Treat `LocalCacheOption.Overwrite` as destructive. Use it only for an exact, pre-inventoried cache target.
5. Resolve search results to exactly one expected item and revision. Never use `.First()` or `[0]` as selection logic.
6. Disconnect in `finally` only when the current operation established the connection; do not terminate a caller-owned Teamcenter session.
7. Checkout cancellation is not rollback and does not discard local project/library changes. Do not use it as unconditional cleanup.
8. Do not claim a save, check-in, download, or disconnect succeeded without checking the returned result and/or re-reading authoritative Teamcenter state.

## Evidence boundary

Installed V21 assemblies and XML documentation prove provider names, signatures,
types, and enum members. Endpoint reachability, license, credentials, permissions,
dataset locks, cache behavior, and remote persistence require an authorized live
Teamcenter Gateway test.
