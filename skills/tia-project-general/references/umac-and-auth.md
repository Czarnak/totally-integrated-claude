# UMAC & Authentication Reference

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using System.Security;
using Siemens.Engineering;
```

---

## 1. Opening a UMAC-protected project — credentials via delegate

The classic approach: supply username and password through a `UmacDelegate`.

```csharp
private struct UmacParams
{
    public UmacUserType Type;   // UmacUserType.Project or UmacUserType.Global
    public string Name;
    public SecureString Password;
}

private static Project OpenProtectedProject(TiaPortal tiaPortal,
    string projectPath, UmacParams umac)
{
    void MyUmacDelegate(UmacCredentials creds)
    {
        creds.Type = umac.Type;
        creds.Name = umac.Name;
        creds.SetPassword(umac.Password);
    }

    return tiaPortal.Projects.Open(
        new FileInfo(projectPath), MyUmacDelegate);
}
```

| `UmacUserType` | Scope |
|---|---|
| `UmacUserType.Project` | UMAC managed at project level |
| `UmacUserType.Global` | UMAC managed by a UMC server |

---

## 2. Opening a UMAC-protected project — Authentication event (V17+)

Use the `Authentication` event on the `TiaPortal` object for flexible authentication
without hardcoding credentials:

```csharp
private static Project OpenWithAuthEvent(TiaPortal tiaPortal, string projectPath)
{
    void OnAuthentication(object sender, AuthenticationEventArgs e)
    {
        // Choose auth method — no credentials needed for SSO/Anonymous
        e.AuthenticationTypeProvider = AuthenticationTypeProvider.DesktopSso;

        // For Credentials mode, still supply via UmacDelegate on the Open call
        // e.AuthenticationTypeProvider = AuthenticationTypeProvider.Credentials;
    }

    tiaPortal.Authentication += OnAuthentication;
    try
    {
        return tiaPortal.Projects.Open(new FileInfo(projectPath));
    }
    finally
    {
        tiaPortal.Authentication -= OnAuthentication;
    }
}
```

| `AuthenticationTypeProvider` | Behaviour |
|---|---|
| `DesktopSso` | Current Windows user; no password prompt |
| `Anonymous` | Anonymous user account; no password prompt |
| `Interactive` | TIA Portal shows login dialog |
| `Credentials` | Read from the `UmacDelegate` supplied to `Open()` |

---

## 3. ProjectOpenMode — primary vs secondary

```csharp
// Primary: visible in UI, full access for authenticated user
Project primary = tiaPortal.Projects.Open(
    new FileInfo(primaryPath),
    null,                        // no UMAC delegate for unprotected project
    ProjectOpenMode.Primary);

// Secondary: hidden from UI, always read-only
Project secondary = tiaPortal.Projects.Open(
    new FileInfo(secondaryPath),
    null,
    ProjectOpenMode.Secondary);

bool isPrimary = secondary.IsPrimary; // false

// Enumerate all open projects
foreach (Project p in tiaPortal.Projects)
    Console.WriteLine($"{p.Name}  primary={p.IsPrimary}");
```

**Rules:**

- A primary project does not need to be open to open a secondary project.
- Write-privileged UMAC users still get read-only access on a secondary project.
- `OpenWithUpgrade`, `Retrieve`, `RetrieveWithUpgrade` all accept a `ProjectOpenMode`
  parameter in their full overloads.

---

## 4. Read-only project access

When opening a UMAC-protected project with read-only credentials, the following Openness
operations are available without error:

**Always permitted (inherent):**

- `GetAttribute(s)` / getter properties on any accessible object
- `GetComposition` / `GetService` / `Find` navigation
- `foreach` enumeration
- `System.Object` methods

**Also permitted (enabled non-modifying):**

- `Project.Close(...)`
- `PlcBlock.ShowInEditor()`
- `CaxProvider.Export(Device, ...)` / `CaxProvider.Export(Project, ...)`

Any write operation on a read-only project throws `EngineeringSecurityException`.

---

## 5. Modify project via Openness API — UMAC function right

In UMAC-protected projects, even read-write users must have the **"Modify project via
Openness API"** function right assigned to their role to perform data-modifying operations
(import, create, delete, compile). Without it, write calls throw `EngineeringSecurityException`.

UI-navigation calls (`ShowInEditor`, `ShowHwEditor`) are exempt from this function right
and depend on the corresponding UI function rights instead.
