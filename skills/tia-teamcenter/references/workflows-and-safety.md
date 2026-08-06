# Teamcenter Gateway V21 Workflows and Safety

Sources: TIA Portal Openness V21 Teamcenter Gateway documentation and the
installed `Siemens.Engineering.TeamcenterGateway.dll` XML/reflection surface.

## Provider ownership

Acquire the portal-scoped providers from the same `TiaPortal` instance:

```csharp
TeamcenterConnectionProvider connectionProvider =
    tiaPortal.GetService<TeamcenterConnectionProvider>();
TcGatewayLockProvider lockProvider =
    tiaPortal.GetService<TcGatewayLockProvider>();
TcGatewaySearchAndDownloadProvider searchProvider =
    tiaPortal.GetService<TcGatewaySearchAndDownloadProvider>();
```

Acquire `TcGatewayWorkflowProvider` from the exact opened `Project` or global
library that is to be saved. It is not a portal-level storage collection:

```csharp
TcGatewayWorkflowProvider workflowProvider =
    project.GetService<TcGatewayWorkflowProvider>();
```

## Connect and protect credentials

The password overload has this installed order:

```csharp
TcGatewayConnectionInfo connection = connectionProvider.Connect(
    userName,
    password,       // System.Security.SecureString
    group,
    role,
    hostUrl,
    instance);
```

The SSO alternative is:

```csharp
TcGatewayConnectionInfo connection = connectionProvider.ConnectSSO(
    hostUrl,
    instance,
    loginUrl,
    applicationId);
```

- Prefer HTTPS endpoints and the environment's approved certificate policy.
- Do not construct a plaintext password merely to convert it to `SecureString`.
- `TcGatewayConnectionInfo.SessionToken` is an authentication secret: never log,
  persist, serialize, include it in exceptions, or return it to an agent/tool result.
- Do not log password, SSO response data, or credential-bearing URLs.
- Catch `LicenseNotFoundException` separately from `TcGatewayException` so a
  missing TIA Portal Teamcenter Gateway license is not misreported as bad credentials.

Disconnect only a session established by the current owner:

```csharp
TcGatewayConnectionInfo connection = null;
bool ownsConnection = false;
try
{
    connection = connectionProvider.Connect(
        userName, password, group, role, hostUrl, instance);
    ownsConnection = true;
    // Authorized work.
}
finally
{
    if (ownsConnection && connection != null)
        connectionProvider.Disconnect(connection);
}
```

## Search and download

Installed item kinds are `ItemType.Project` and `ItemType.GlobalLibrary`.
`Search` accepts the connection, item type, item ID, item name, revision ID, and
project name. An empty collection means no match; it does not authorize a broader
or fallback match.

Filter the returned `SearchResult` values to the exact expected `ItemId` and
revision. Require exactly one match before download; never select the first result.

```csharp
searchProvider.Download(
    connection,
    exactItemId,
    exactRevisionId,
    ItemType.Project,
    LocalCacheOption.DoNotOverwrite);
```

`LocalCacheOption.Overwrite` can replace the TIA project/global library in the
Teamcenter cache. Require explicit remote-write authorization and an exact,
pre-inventoried cache target before selecting it. Verify the returned local file
identity before opening it.

## Dataset checkout and check-in

Installed dataset kinds are `DatasetType.T4TiaProjectDataset` and
`DatasetType.T4TiaLibraryDataset`. The lock-provider operations are:

```csharp
lockProvider.CheckoutDataset(
    connection, itemId, revisionId, datasetType, comment);

lockProvider.CheckinDataset(
    connection, itemId, revisionId, datasetType, comment);

lockProvider.CancelCheckoutDataset(
    connection, itemId, revisionId, datasetType, comment);
```

Checkout, check-in, and cancellation modify shared Teamcenter state. Require
explicit remote-write authorization for the exact item, revision, dataset kind,
and comment. Do not infer lock ownership from a successful earlier step; verify
the current authoritative state where the environment exposes it.

`CancelCheckoutDataset` cancels the dataset checkout but does not discard local changes
in the TIA project/global library. It is not rollback and must not be called as
automatic failure cleanup. Preserve the local artifact and report the split state.

## Save workflows

The object-scoped workflow provider supports:

- `Save` and `SaveWithProxyObject`
- `SaveAsNewItem` and `SaveAsNewItemWithProxyObject`
- `SaveAsNewRevision` and `SaveAsNewRevisionWithProxyObject`
- `SaveToItem` and `SaveToItemWithProxyObject`
- `GetTeamcenterCustomAttributes`

All save methods are remote writes. Require an approved operation kind and exact
target identity before calling one. For new items/revisions, validate every
`ItemDetails`, `RevisionDetails`, and `TeamcenterProperty`, including required,
read-only, type, bounds, maximum length, and list-of-values constraints.

`TeamcenterProperty.SetValue` reports per-property errors through `ErrorCallback`.
Collect and fail on callback errors; do not treat method return as full success
when property validation failed.

`LocalCacheOption.Overwrite` is destructive for save operations too. Default to
`DoNotOverwrite` unless replacement of the exact approved cache artifact is part
of the request.

After a save, validate returned `ItemInfo` (`ItemId`, `RevisionId`, `ItemType`,
and `ItemName`) against the requested target. After check-in, re-search the exact
item/revision or use another authoritative Teamcenter read to confirm persistence.

## Failure and recovery rules

- Do not automatically check in after a failed save.
- Do not automatically cancel a checkout after a failure; local changes remain.
- Do not retry mutating calls blindly because the first call may have reached the
  server before the client received an exception.
- Preserve item ID, revision ID, dataset kind, operation kind, and non-secret
  correlation details for reconciliation. Never preserve the session token.
- A successful local project save is not proof of a successful Teamcenter save.

## Evidence boundary

Static XML/reflection validation proves the installed API contract only. A live,
credentialed, explicitly authorized test is required for licenses, SSO/password
authentication, server permissions, dataset locks, proxy behavior, cache overwrite,
custom-property mapping, save/check-in persistence, and recovery semantics.
