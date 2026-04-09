# Screens Reference

Source: TIA Portal Openness V21 — Functions for Accessing HMI Device Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. Create a user-defined screen folder

Entry point: `hmiTarget.ScreenFolder` (`HmiScreenFolder` / `ScreenSystemFolder`)

```csharp
private static void CreateScreenFolder(HmiTarget hmitarget)
{
    ScreenUserFolder myCreatedFolder = hmitarget.ScreenFolder.Folders.Create("myScreenFolder");
}
```

---

## 2. Delete a screen from a folder

> You cannot delete a permanent area (system screen that is always present).

```csharp
public static void DeleteScreenFromFolder(HmiTarget hmiTarget)
{
    ScreenUserFolder screenUserFolder = hmiTarget.ScreenFolder.Folders.Find("myScreenFolder");
    ScreenComposition screens = screenUserFolder.Screens;
    Screen screen = screens.Find("myScreenName");
    if (screen != null)
    {
        screen.Delete();
    }
}
```

---

## 3. Delete all screens from a folder

> You cannot delete a permanent area. Collect into a list first — do not modify the composition while iterating.

```csharp
private static void DeleteAllScreensFromFolder(HmiTarget hmitarget)
{
    ScreenUserFolder folder = hmitarget.ScreenFolder.Folders.Find("myScreenFolder");
    // or: ScreenSystemFolder folder = hmitarget.ScreenFolder;

    ScreenComposition screens = folder.Screens;
    List<Screen> list = new List<Screen>();

    foreach (Screen screen in screens)
    {
        list.Add(screen);
    }

    foreach (Screen screen in list)
    {
        screen.Delete();
    }
}
```

---

## 4. Delete a screen template from a folder

Entry point: `hmiTarget.ScreenTemplateFolder` (`ScreenTemplateSystemFolder`)

```csharp
private static void DeleteScreenTemplateFromFolder(HmiTarget hmiTarget)
{
    string templateName = "MyScreenTemplate";
    ScreenTemplateUserFolder folder = hmiTarget.ScreenTemplateFolder.Folders.Find("myScreenTemplateFolder");
    ScreenTemplateComposition templates = folder.ScreenTemplates;
    ScreenTemplate template = templates.Find(templateName);
    if (template != null)
    {
        template.Delete();
    }
}
```

---

## 5. Delete a user-defined screen folder

```csharp
ScreenUserFolder screenUserGroup = hmiTarget.ScreenFolder.Folders.Find("MyUserFolder");
screenUserGroup.Delete();
```
