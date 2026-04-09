# Language Settings Reference

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using System.Globalization;
using Siemens.Engineering;
```

---

## 1. LanguageSettings object model

`project.LanguageSettings` is the root. From it:

- `Languages` — `LanguageComposition` of all supported languages (read-only catalogue)
- `ActiveLanguages` — `LanguageAssociation` of languages currently active in the project
- `EditingLanguage` — the language used when editing text (set via assignment)
- `ReferenceLanguage` — the reference language for translation work

---

## 2. Reading languages

```csharp
private static void ReadLanguages(Project project)
{
    LanguageSettings ls = project.LanguageSettings;

    // All supported languages
    foreach (Language lang in ls.Languages)
    {
        CultureInfo culture = lang.Culture;
        Console.WriteLine(culture.Name); // e.g. "en-US", "de-DE"
    }

    // Active languages
    foreach (Language lang in ls.ActiveLanguages)
    {
        Console.WriteLine($"Active: {lang.Culture.Name}");
    }

    Console.WriteLine($"Editing:   {ls.EditingLanguage?.Culture.Name}");
    Console.WriteLine($"Reference: {ls.ReferenceLanguage?.Culture.Name}");
}
```

---

## 3. Adding and activating a language

Setting an inactive language via `EditingLanguage` or `ReferenceLanguage` automatically
adds it to the active languages collection.

```csharp
private static void ActivateLanguage(Project project)
{
    LanguageSettings ls = project.LanguageSettings;

    // Find German in the supported catalogue
    Language german = ls.Languages.Find(CultureInfo.GetCultureInfo("de-DE"));

    // Add to active set
    ls.ActiveLanguages.Add(german);

    // Set as editing and reference language
    ls.EditingLanguage  = german;
    ls.ReferenceLanguage = german;
}
```

---

## 4. Removing an active language

If the removed language was the editing or reference language, TIA Portal adjusts those
settings consistently with its UI behaviour.

```csharp
private static void DeactivateLanguage(Project project)
{
    LanguageSettings ls = project.LanguageSettings;
    Language german = ls.ActiveLanguages.Find(CultureInfo.GetCultureInfo("de-DE"));
    if (german != null)
        ls.ActiveLanguages.Remove(german);
}
```

---

## 5. MultilingualText model

Many project and device objects carry multilingual text. The structure is:

```
MultilingualText
  └── Items  (MultilingualTextItemComposition)
        └── MultilingualTextItem  { Language, Text }
```

### Reading a multilingual text

```csharp
private static string GetCommentText(Project project, string cultureName = "en-US")
{
    Language lang = project.LanguageSettings.ActiveLanguages
        .Find(CultureInfo.GetCultureInfo(cultureName));

    MultilingualTextItem item = project.Comment.Items.Find(lang);
    return item?.Text ?? string.Empty;
}
```

### Writing a multilingual text

```csharp
private static void SetProjectComment(Project project)
{
    Language english = project.LanguageSettings.Languages
        .Find(CultureInfo.GetCultureInfo("en-US"));

    MultilingualTextItem item = project.Comment.Items.Find(english);
    if (item != null)
        item.Text = "Auto-generated project";
}
```

### Multilingual text on devices (CommentML)

Devices and device items use a dynamic attribute `CommentML` instead of a direct property:

```csharp
private static void SetDeviceComment(Device device, Project project)
{
    MultilingualText ml = device.GetAttribute("CommentML") as MultilingualText;
    if (ml == null) return;

    Language english = project.LanguageSettings.Languages
        .Find(CultureInfo.GetCultureInfo("en-US"));

    MultilingualTextItem item = ml.Items.Find(english);
    if (item != null)
        item.Text = "PLC Station 1";
}
```

---

## 6. TIA Portal UI language (portal-level setting)

Changing the UI language affects how HistoryEntry text is returned (always English in
headless mode). See `portal-settings.md` for `TiaPortalSettingsFolder` usage.
