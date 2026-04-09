# Scripts, Cycles, Connections, Text Lists, and Graphic Lists Reference

Source: TIA Portal Openness V21 — Functions for Accessing HMI Device Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## VB Scripts

### 1. Create a user-defined script folder

Entry point: `hmiTarget.VBScriptFolder` (`VBScriptSystemFolder`)

```csharp
private static void CreateFolderInScriptfolder(HmiTarget hmitarget)
{
    VBScriptSystemFolder vbScriptFolder = hmitarget.VBScriptFolder;
    VBScriptUserFolderComposition vbScriptFolders = vbScriptFolder.Folders;
    VBScriptUserFolder vbScriptSubFolder = vbScriptFolder.Folders.Create("mySubfolder");
}
```

### 2. Delete a VB script from a folder

```csharp
private static void DeleteVBScriptFromScriptFolder(HmiTarget hmitarget)
{
    VBScriptUserFolder vbscriptfolder = hmitarget.VBScriptFolder.Folders.Find("MyScriptFolder");
    var vbScripts = vbscriptfolder.VBScripts;
    if (null != vbScripts)
    {
        var vbScript = vbScripts.Find("MyScript");
        vbScript.Delete();
    }
}
```

---

## Cycles

### 3. Delete a cycle

Entry point: `hmiTarget.Cycles` (`CycleComposition`)

> You cannot delete standard cycles.

```csharp
public static void DeleteCycle(HmiTarget hmiTarget)
{
    CycleComposition cycles = hmiTarget.Cycles;
    Cycle cycle = cycles.Find("myCycle");
    cycle.Delete();
}
```

---

## Connections

### 4. Delete a connection

Entry point: `hmiTarget.Connections` (`ConnectionComposition`)

```csharp
private static void DeleteConnection(HmiTarget hmiTarget)
{
    ConnectionComposition connections = hmiTarget.Connections;
    Connection connection = connections.Find("HMI_connection_1");
    connection.Delete();
}
```

---

## Text Lists

### 5. Delete a text list

Entry point: `hmiTarget.TextLists` (`TextListComposition`)

Deletes the selected text list and all associated list entries.

```csharp
public static void DeleteTextList(HmiTarget hmiTarget)
{
    TextListComposition textLists = hmiTarget.TextLists;
    TextList textList = textLists.Find("myTextList");
    textList.Delete();
}
```

---

## Graphic Lists

### 6. Delete a graphic list

Entry point: `hmiTarget.GraphicLists` (`GraphicListComposition`)

Deletes the selected graphic list and all associated list entries.

```csharp
private static void DeleteGraphicList(HmiTarget hmiTarget)
{
    GraphicListComposition graphicLists = hmiTarget.GraphicLists;
    GraphicList graphicList = graphicLists.Find("myGraphicList");
    graphicList.Delete();
}
```
