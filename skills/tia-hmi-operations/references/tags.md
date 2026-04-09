# HMI Tags Reference

Source: TIA Portal Openness V21 — Functions for Accessing HMI Device Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. Create a user-defined folder for HMI tags

Entry point: `hmiTarget.TagFolder` (`TagSystemFolder`)

```csharp
private static void CreateUserfolderForHMITags(HmiTarget hmitarget)
{
    TagSystemFolder folder = hmitarget.TagFolder;
    TagUserFolder myCreatedFolder = folder.Folders.Create("MySubFolder");
}
```

---

## 2. Enumerate tags of an HMI tag table

```csharp
private static void EnumerateTagsInTagtable(HmiTarget hmitarget)
{
    TagTable table = hmitarget.TagFolder.TagTables.Find("MyTagtable");

    // Alternatively, access the default tag table:
    // TagTable defaulttable = hmitarget.TagFolder.DefaultTagTable;

    TagComposition tagComposition = table.Tags;
    foreach (Tag tag in tagComposition)
    {
        // process tag
    }
}
```

---

## 3. Delete an individual tag from an HMI tag table

```csharp
private static void DeleteATag(HmiTarget hmiTarget)
{
    string tagName = "MyTag";
    TagTable defaultTagTable = hmiTarget.TagFolder.DefaultTagTable;
    TagComposition tags = defaultTagTable.Tags;
    Tag tag = tags.Find(tagName);
    tag.Delete();
}
```

---

## 4. Delete a tag table from a folder

> You cannot delete the default tag table.

```csharp
private static void DeleteTagTable(HmiTarget hmiTarget)
{
    string tableName = "myTagTable";
    TagSystemFolder tagSystemFolder = hmiTarget.TagFolder;
    TagTableComposition tagTables = tagSystemFolder.TagTables;
    TagTable tagTable = tagTables.Find(tableName);
    tagTable.Delete();
}
```
