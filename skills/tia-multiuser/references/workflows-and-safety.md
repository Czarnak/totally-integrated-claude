# Multiuser V21 Workflows and Safety

Sources: TIA Portal Openness V21 Multiuser functions (03/2026), V21 project-server documentation, and installed `Siemens.Engineering.Base.xml` / reflection.

## Installed entry points

Multiuser is part of `Siemens.Engineering.Base.dll` under `Siemens.Engineering.Multiuser`. The navigators are direct properties of `TiaPortal`:

```csharp
ProjectServerComposition projectServers = tiaPortal.ProjectServers;
LocalSessionComposition localSessions = tiaPortal.LocalSessions;
```

There is no installed service object between `TiaPortal` and these compositions.

## Exact project-server selection

```csharp
List<ProjectServer> matches = tiaPortal.ProjectServers
    .Where(server => string.Equals(server.ServerName, requiredAlias, StringComparison.Ordinal))
    .ToList();

if (matches.Count != 1)
    throw new InvalidOperationException(
        $"Expected exactly one project-server alias '{requiredAlias}', found {matches.Count}.");

ProjectServer server = matches[0];

List<ServerProjectInfo> projectMatches = server.GetServerProjects()
    .Where(info => string.Equals(info.ProjectName, requiredProjectName, StringComparison.Ordinal))
    .ToList();

if (projectMatches.Count != 1)
    throw new InvalidOperationException(
        $"Expected exactly one server project '{requiredProjectName}', found {projectMatches.Count}.");

ServerProjectInfo serverProject = projectMatches[0];
```

The `ProjectServer` properties are `ServerName` (alias), `Host`, and `Port`. V21 connection creation is:

```csharp
ProjectServer created = tiaPortal.ProjectServers.Create(
    alias,
    Protocol.Https,
    host,
    port);
```

Use HTTPS unless a documented environment constraint and explicit security approval require otherwise. Authentication uses the current Windows user; protected project authentication is handled through `tiaPortal.Authentication`.

`SetHostName`, `SetPort`, `SetProtocol`, and `DeleteConnection` change local TIA Portal project-server connection settings. `AddProjectToServer`, `CreateLocalSession`, and `DeleteLocalSessionFromServer` change server/session state. Each requires explicit remote-write authorization for the exact target.

## Create and open a session

Installed `SessionCreationMode` members are `Multiuser` and `Exclusive`:

```csharp
LocalSessionInfo info = server.CreateLocalSession(
    serverProject,
    requiredSessionName,
    exactSessionDirectory,
    SessionCreationMode.Multiuser);

LocalSession localSession = tiaPortal.LocalSessions.Open(info.ProjectFileInfo);
```

Use `SessionCreationMode.Exclusive` only after verifying the server-project lock state and authorization to take the lock. The exact returned `ProjectFileInfo` is the session identity; validate that it remains under the approved session directory before opening it.

`tiaPortal.LocalSessions.OpenServerProject(fileInfo)` opens a server project through the returned local-session file. Do not confuse it with `Open(fileInfo)`, which opens a local/exclusive session.

## State, locks, and markings

```csharp
LockStateProvider locks = server.GetLockStateProvider(serverProject);
bool locked = locks.IsProjectLocked();
string owner = locks.GetLockOwner();

bool current = localSession.IsUptoDate();
MarkingService marking = localSession.MarkingService;
MarkStateInfo state = marking.GetMarkStateInfo(exactEngineeringObject);
```

Before marking, require `state.IsMarkable` and inspect `state.MarkState` (`None`, `IsUptoDate`, `IsMarkedByMe`, `IsMarkedByOthers`). `MarkObjects` and `UnmarkObjects` accept `IEnumerable<IEngineeringObject>` and throw `MultiuserException` when objects are not markable or the operation fails.

Marking objects is not itself proof of a successful check-in. Re-read markings and server/session state after the operation.

## Save, discard, and commit

- `localSession.Save()` persists a Multiuser/engineering or exclusive local session. Calling it on an opened server project raises `MultiuserException`.
- `localSession.Close()` closes a server project, Multiuser session, or exclusive session and discards all pending changes. It is destructive.
- `int revision = localSession.CloseAndCommit(comment)` is the installed remote commit API. Siemens documents it for opened server projects and exclusive sessions; it closes the session and returns the created server revision.

```csharp
if (!localSession.IsUptoDate())
    throw new InvalidOperationException("The local session is not up to date; stop before commit.");

// Stop active monitoring or forcing jobs before a check-in/update workflow.
// Require explicit remote-write authorization for this exact session and comment.
int revisionCreated = localSession.CloseAndCommit(requiredComment);
if (revisionCreated < 0)
    throw new InvalidOperationException("The project server did not return a valid revision.");
```

The public V21 type surface does not expose parameterless `CheckIn()` or `Update()` calls and has no conflict `AccessOptions` type. If a workflow requires an operation not represented here, stop and route it through the supported TIA Portal/project-server UI or a separately verified API; do not fabricate a method.

## Preconditions and loss prevention

- Multiuser clients need compatible TIA Portal/product versions. A local session is version-specific.
- Project-server access, project membership, licenses, HTTPS/network reachability, certificates, and Windows authentication must be valid.
- Total path/file length is constrained by the product; validate the destination before session creation.
- Stop active monitoring or forcing jobs before check-in/update workflows.
- In commissioning workflows, edits to objects that cannot be marked can be lost and are not downloaded.
- Deleting a local session from the server, deleting a connection, closing with pending changes, and committing are externally visible/destructive actions. Inventory and authorize them explicitly.

## Evidence boundary

Installed XML/reflection proves names and signatures. Server reachability, identity, permissions, locks, version compatibility, successful revision creation, and conflict/loss behavior require a credentialed, authorized live project-server test.
