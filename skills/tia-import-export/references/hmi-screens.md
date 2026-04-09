# HMI Screens Reference

Source: TIA Portal Openness V21 — Functions for Accessing HMI Device Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## 1. Overview of exportable screen objects

All screen types support export/import: Screen, Global screen, Screen template, Permanent area, Pop-up screen, Slide-in screen.

Exportable screen items include: Line, Polyline, Polygon, Ellipse, Circle, Rectangle, Text field, Graphic view, I/O field, Graphic I/O field, Button, Illuminated button, Switch, Symbolic I/O field, Date/time field, Bar, Symbol library, Slider, Gauge, Clock, Softkeys, Groups, Faceplate instances, User view.

Not exportable: Screen window, Recipe view, Alarm view, Alarm window, Trend views, Table view, Camera view, etc.

---

## 2. Export a single screen from a folder

Entry point: `hmiTarget.ScreenFolder` (`ScreenSystemFolder` / `ScreenUserFolder`)

```csharp
private static void ExportSingleScreenFromScreenFolder(HmiTarget hmitarget)
{
    ScreenUserFolder folder = hmitarget.ScreenFolder.Folders.Find("MyScreenFolder");
    //or ScreenSystemFolder folder = hmitarget.ScreenFolder;
    ScreenComposition screens = folder.Screens;
    Screen screen = screens.Find("Screen_1.xml");
    if (screen == null) return;
    FileInfo info = new FileInfo(string.Format(@"D:\Samples\Screens\{0}\{1}.xml", folder.Name, screen.Name));
    screen.Export(info, ExportOptions.WithDefaults);
}
```

---

## 3. Export all screens of an HMI device (recursive)

```csharp
public static void ExportScreens(string screenPath, HmiTarget target)
{
    foreach (Screen screen in target.ScreenFolder.Screens)
    {
        screen.Export(new FileInfo(Path.Combine(screenPath, screen.Name + ".xml")), ExportOptions.WithDefaults);
    }
    foreach (ScreenUserFolder subfolder in target.ScreenFolder.Folders)
    {
        ExportScreenUserFolder(Path.Combine(screenPath, subfolder.Name), subfolder);
    }
}

private static void ExportScreenUserFolder(string screenPath, ScreenUserFolder folder)
{
    foreach (Screen screen in folder.Screens)
    {
        screen.Export(new FileInfo(Path.Combine(screenPath, screen.Name + ".xml")), ExportOptions.WithDefaults);
    }
    foreach (ScreenUserFolder subfolder in folder.Folders)
    {
        ExportScreenUserFolder(Path.Combine(screenPath, subfolder.Name), subfolder);
    }
}
```

---

## 4. Import screens to an HMI device

> Source device type and target device type must match.

```csharp
// Import to existing user folder
private static void ImportScreensToHMITarget(HmiTarget hmitarget)
{
    FileInfo[] exportedScreens = new FileInfo[]
    {
        new FileInfo(@"D:\Samples\Import\Screen_1.xml"),
        new FileInfo(@"D:\Samples\Import\Screen_2.xml")
    };
    ScreenUserFolder folder = hmitarget.ScreenFolder.Folders.Find("MyScreenFolder");
    foreach (FileInfo screenFileInfo in exportedScreens)
    {
        folder.Screens.Import(screenFileInfo, ImportOptions.Override);
    }
}

// Import to a newly created folder
private static void ImportSingleScreenToNewFolderOfHMITarget(HmiTarget hmitarget)
{
    ScreenUserFolder folder = hmitarget.ScreenFolder.Folders.Create("MyFolder");
    folder.Screens.Import(new FileInfo(@"D:\Samples\Import\myScreens.xml"), ImportOptions.Override);
}
```

---

## 5. Export screen templates (all, recursive)

```csharp
private static void ExportScreenTemplates(string templatePath, HmiTarget hmiTarget)
{
    foreach (ScreenTemplate screen in hmiTarget.ScreenTemplateFolder.ScreenTemplates)
    {
        screen.Export(new FileInfo(Path.Combine(templatePath, screen.Name + ".xml")), ExportOptions.WithDefaults);
    }
    foreach (ScreenTemplateUserFolder folder in hmiTarget.ScreenTemplateFolder.Folders)
    {
        ExportScreenTemplates(Path.Combine(templatePath, folder.Name), hmiTarget);
    }
}
```

---

## 6. Export single screen template from a folder

```csharp
private static void ExportSingleScreenTemplate(string templatePath, HmiTarget hmiTarget)
{
    ScreenTemplateUserFolder folder = hmiTarget.ScreenTemplateFolder.Folders.Find("MyTemplateFolder");
    //or ScreenTemplateSystemFolder folder = hmiTarget.ScreenTemplateFolder;
    ScreenTemplateComposition templates = folder.ScreenTemplates;
    ScreenTemplate template = templates.Find("templateName");
    if (template == null) return;
    FileInfo info = new FileInfo(string.Format(@"D:\Samples\Templates\{0}\{1}.xml", folder.Name, template.Name));
    template.Export(info, ExportOptions.WithDefaults);
}
```

---

## 7. Import screen templates

```csharp
// Import to existing folder
private static void ImportScreenTemplatesToHMITarget(HmiTarget hmiTarget)
{
    ScreenTemplateUserFolder folder = hmiTarget.ScreenTemplateFolder.Folders.Find("MyTemplateFolder");
    FileInfo[] exportedTemplates = new FileInfo[]
    {
        new FileInfo(@"D:\Samples\Import\Template_1.xml"),
        new FileInfo(@"D:\Samples\Import\Template_n.xml")
    };
    foreach (FileInfo templateFileName in exportedTemplates)
    {
        folder.ScreenTemplates.Import(templateFileName, ImportOptions.Override);
    }
}

// Import to a new subfolder
private static void ImportScreenTemplatesToFolderOfHMITarget(HmiTarget hmiTarget)
{
    ScreenTemplateUserFolder screenTemplateFolder = hmiTarget.ScreenTemplateFolder.Folders.Find("MyTemplateFolder");
    ScreenTemplateUserFolder folder = screenTemplateFolder.Folders.Create("MyNewFolder");
    folder.ScreenTemplates.Import(new FileInfo(@"D:\Samples\Import\ScreenTemplate.xml"), ImportOptions.Override);
}
```

---

## 8. Export pop-up screen

Entry point: `hmiTarget.ScreenPopupFolder` (`ScreenPopupSystemFolder` / `ScreenPopupUserFolder`)

```csharp
private static void ExportSinglePopUpScreen(HmiTarget hmitarget)
{
    ScreenPopupUserFolder folder = hmitarget.ScreenPopupFolder.Folders.Find("MyPopupFolder");
    //or ScreenPopupSystemFolder folder = hmitarget.ScreenPopupFolder;
    ScreenPopupComposition popups = folder.ScreenPopups;
    ScreenPopup popup = popups.Find("popupName");
    if (popup == null) return;
    FileInfo info = new FileInfo(string.Format(@"D:\Samples\Screens\{0}\{1}.xml", folder.Name, popup.Name));
    popup.Export(info, ExportOptions.WithDefaults);
}
```

---

## 9. Import pop-up screen

```csharp
private static void ImportPopupScreenToHMITarget(HmiTarget hmitarget)
{
    FileInfo info = new FileInfo(string.Format(@"D:\Samples\Screens\PopupScreen.xml"));
    hmitarget.ScreenPopupFolder.ScreenPopups.Import(info, ImportOptions.None);
}
```

> Throws exception if device does not support pop-up screens, or if dimensions exceed device limits.

---

## 10. Export slide-in screen

Entry point: `hmiTarget.ScreenSlideinFolder` (`ScreenSlideinSystemFolder`)

Slide-in screens have no name; they are identified by `SlideinType` (Top, Bottom, Left, Right).

```csharp
private static void ExportSingleSlideinScreen(HmiTarget hmitarget)
{
    ScreenSlideinSystemFolder systemFolder = hmitarget.ScreenSlideinFolder;
    var screens = systemFolder.ScreenSlideins;
    ScreenSlidein slidein = screens.Find(SlideinType.Bottom);
    if (slidein == null) return;
    FileInfo info = new FileInfo(string.Format(@"D:\Samples\Screens\{0}\{1}.xml"));
    slidein.Export(info, ExportOptions.WithDefaults);
}
```

---

## 11. Import slide-in screen

> `SlideinType` is mandatory in the import file. When referenced via system function `ShowSlideinScreen`, use the openlink name (e.g. `GraphX_Slidein_Bottom`), not `SlideinType`.

```csharp
private static void ImportSlideinScreenToHMITarget(HmiTarget hmitarget)
{
    FileInfo info = new FileInfo(@"D:\Samples\Screens\SlideInScreen.xml");
    hmitarget.ScreenSlideinFolder.ScreenSlideins.Import(info, ImportOptions.None);
}
```

---

## 12. Export permanent area (screen overview)

```csharp
private static void ExportScreenoverview(HmiTarget hmitarget)
{
    ScreenOverview overview = hmitarget.ScreenOverview;
    if (overview == null) return;
    FileInfo info = new FileInfo(@"D:\Samples\Screens\ExportedOverview.xml");
    overview.Export(info, ExportOptions.WithDefaults);
}
```

---

## 13. Import permanent area

```csharp
private static void ImportScreenOverview(HmiTarget hmiTarget)
{
    FileInfo info = new FileInfo(@"D:\Samples\Screens\ExportedOverview.xml");
    hmiTarget.ImportScreenOverview(info, ImportOptions.Override);
}
```

> Note: uses `hmiTarget.ImportScreenOverview(...)`, not a composition method.

---

## 14. Export screen with faceplate instance

`FaceplateTypeName` identifies the type and version, e.g. `"Faceplate_1 V 0.0.2"`. For library faceplate: `"Folder_1@$@SubFolder_1@$@Faceplate_1 V 0.0.2"`.

```csharp
private static void ExportSingleScreenWithFaceplateInstance(HmiTarget hmitarget)
{
    ScreenFolder folder = hmitarget.ScreenFolder.Folders.Find("MyScreenFolder");
    ScreenComposition screens = folder.Screens;
    Screen screen = screens.Find("ScreenWithFaceplateName");
    if (screen == null) return;
    FileInfo info = new FileInfo(string.Format(@"D:\Samples\Faceplates\{0}\{1}.xml", folder.Name, screen.Name));
    screen.Export(info, ExportOptions.WithDefaults);
}
```

---

## 15. Import screen with faceplate instance

Mandatory attributes in import file: `ObjectName`, `FaceplateTypeName`.

```csharp
private static void ImportSingleScreenWithFaceplateInstance(HmiTarget hmitarget)
{
    FileInfo info = new FileInfo(@"D:\Samples\Screens\ScreenFaceplate.xml");
    hmitarget.ScreenFolder.Screens.Import(info, ImportOptions.None);
}
```

> Throws exception if `FaceplateTypeName` does not exist in the project. `Resizing` is always imported regardless of export options.
