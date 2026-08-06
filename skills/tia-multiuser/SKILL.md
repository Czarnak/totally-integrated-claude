---
name: tia-multiuser
description: >
  TIA Portal Multiuser Engineering operations. Use for managing server projects,
  local sessions, and multiuser commissioning workflows.
license: MIT
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
| `references/v21-api-surface.md` | Comprehensive installed surface for `Siemens.Engineering.Multiuser` types. |
| `references/workflows-and-safety.md` | Exact V21 roots, project-server/session workflows, marking, locking, save/close/commit semantics, and remote-write gates. |

---

## Key Workflows

### Managing Local Sessions

1. Resolve a project-server connection from `tiaPortal.ProjectServers` by exact alias.
2. Resolve the exact `ServerProjectInfo` returned by `ProjectServer.GetServerProjects()`.
3. Create a `LocalSessionInfo`, then open it through `tiaPortal.LocalSessions`.
4. Use `LocalSession.Save()`, `Close()`, `IsUptoDate()`, `MarkingService`, and—only for a supported server/exclusive session—`CloseAndCommit(comment)`.

Use only the direct compositions and the session methods listed here. Do not translate UI terms into an intermediate service, conflict-options object, or parameterless check-in/update calls.

### Project-server root

```csharp
ProjectServerComposition servers = tiaPortal.ProjectServers;
LocalSessionComposition sessions = tiaPortal.LocalSessions;
```

## Enforcement

1. Require explicit remote-write authorization before creating/deleting a connection or session, adding a project, changing host/protocol/port, saving, closing with discard, or committing a server revision.
2. Resolve server alias, project, group, session ID/path, and intended mode exactly; never select `.First()` or `[0]`.
3. Check server lock state, session freshness, markings/conflicts, active users, and path/version prerequisites before mutation.
4. Active monitoring or forcing jobs must be stopped before check-in/update workflows; non-markable edits can be lost in commissioning workflows.
5. `Close()` discards pending changes. `CloseAndCommit()` performs a remote commit and returns the created revision; neither is cleanup to call unconditionally.
6. Do not save or commit unless explicitly requested. Do not claim remote success without reading the returned revision/current server state.
