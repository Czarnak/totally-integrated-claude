# Project Lifecycle Reference

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using System.IO;
using Siemens.Engineering;
```

---

## 1. Opening a project

### Standard open

```csharp
Project project = tiaPortal.Projects.Open(new FileInfo(@"D:\Projects\MyProject.ap21"));
```

`Open()` only accepts projects at the current TIA Portal version. Use `OpenWithUpgrade()`
for projects created with a previous version.

### Open with upgrade (previous version)

```csharp
Project project = tiaPortal.Projects.OpenWithUpgrade(
    new FileInfo(@"D:\Projects\OldProject.ap18"));
```

Creates a new upgraded project file. Original is not modified.

### Open with missing products (V18+)

If the project requires TIA Portal products not installed, `Open` and `OpenWithUpgrade`
throw `MissingProductsException`. Always catch this when opening arbitrary projects:

```csharp
try
{
    Project project = tiaPortal.Projects.Open(new FileInfo(projectPath));
}
catch (MissingProductsException ex)
{
    Console.WriteLine($"Cannot open — missing products: {ex.Message}");
}
```

---

## 2. Creating a project

```csharp
// Minimal — name and directory only
Project project = tiaPortal.Projects.Create(
    new DirectoryInfo(@"D:\TiaProjects"), "MyProject");
// Creates D:\TiaProjects\MyProject\MyProject.ap21

// With optional metadata
var createParams = new List<KeyValuePair<string, object>>
{
    new KeyValuePair<string, object>("TargetDirectory", new DirectoryInfo(@"D:\TiaProjects")),
    new KeyValuePair<string, object>("Name", "MyProject"),     // mandatory
    new KeyValuePair<string, object>("Author", "AutoTool"),    // optional
    new KeyValuePair<string, object>("Comment", "Generated")   // optional
};
Project project = ((IEngineeringComposition)tiaPortal.Projects)
    .Create(typeof(Project), createParams) as Project;
```

---

## 3. Saving a project

```csharp
// Save in place
project.Save();

// Save to a new location (does not change the active project path)
project.SaveAs(new DirectoryInfo(@"D:\TiaProjects\MyProjectCopy"));
```

---

## 4. Closing a project

```csharp
project.Close();
```

Always close in a `finally` block to ensure cleanup on exception.

---

## 5. Archiving a project

Project must be **saved** before archiving. Unsaved changes throw
`EngineeringTargetInvocationException`.

```csharp
project.Archive(
    new DirectoryInfo(@"D:\Archives"),
    "MyProject_2024-01-15",          // target file name (extension optional)
    ProjectArchivationMode.Compressed);
```

**`ProjectArchivationMode` enum:**

| Value | Description |
|---|---|
| `None` | Copy without compression — similar to SaveAs but does not change persistence location |
| `DiscardRestorableData` | Reorganises storage, removes intermediate/temp files. No zip created. |
| `Compressed` | Creates a zip-compatible archive. Temp folder removed after zipping. |
| `DiscardRestorableDataAndCompressed` | Discards restorable data, then compresses. Most compact output. |

> **Note:** Only `Compressed` and `DiscardRestorableDataAndCompressed` produce a file
> that can be retrieved via `Projects.Retrieve()`.

---

## 6. Retrieving an archived project

```csharp
// Basic retrieve (unprotected, compressed archive)
Project project = tiaPortal.Projects.Retrieve(
    new FileInfo(@"D:\Archives\MyProject.zap21"),
    new DirectoryInfo(@"D:\RetrievedProjects"));

// With UMAC credentials
Project project = tiaPortal.Projects.Retrieve(
    new FileInfo(archivePath),
    new DirectoryInfo(targetDir),
    MyUmacDelegate);

// With UMAC + ProjectOpenMode
Project project = tiaPortal.Projects.Retrieve(
    new FileInfo(archivePath),
    new DirectoryInfo(targetDir),
    MyUmacDelegate,               // pass null if not protected
    ProjectOpenMode.Primary);

// Retrieve and upgrade from previous version
Project project = tiaPortal.Projects.RetrieveWithUpgrade(
    new FileInfo(archivePath),
    new DirectoryInfo(targetDir));

// RetrieveWithUpgrade + UMAC + ProjectOpenMode
Project project = tiaPortal.Projects.RetrieveWithUpgrade(
    new FileInfo(archivePath),
    new DirectoryInfo(targetDir),
    MyUmacDelegate,
    ProjectOpenMode.Primary);
```

> `umacDelegate` can be `null` for unprotected projects. Admin credentials required
> for `RetrieveWithUpgrade` on a protected project.

---

## 7. Deleting a project

Projects are deleted by deleting their directory via standard `System.IO`. There is no
dedicated Openness API for deletion — close the project first, then delete the folder.

---

## Complete lifecycle pattern

```csharp
Project project = null;
try
{
    project = tiaPortal.Projects.Open(new FileInfo(projectPath));

    using (ExclusiveAccess ea = tiaPortal.ExclusiveAccess("Processing"))
    {
        // ... do work ...
        project.Save();
    }

    project.Archive(
        new DirectoryInfo(archiveDir),
        "Backup",
        ProjectArchivationMode.Compressed);
}
catch (MissingProductsException ex)
{
    Console.WriteLine($"Missing products: {ex.Message}");
}
finally
{
    project?.Close();
}
```
