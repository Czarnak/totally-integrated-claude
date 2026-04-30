# Attribute helper pattern for Add-Ins and workflow info objects

The V21 PublicAPI graph shows `AttributeAccessOptions` and `AttributeDelegate` as central
bridge types across Add-In VCI objects, hardware, HMI, software, libraries, download
configuration, and Teamcenter-related APIs. When a selected object or workflow info object
does not expose a strongly typed property, inspect attributes before hard-coding names.

```csharp
using System.Collections.Generic;
using Siemens.Engineering;

private static IReadOnlyList<EngineeringAttributeInfo> GetWritableAttributes(
    IEngineeringObject obj)
{
    var result = new List<EngineeringAttributeInfo>();
    foreach (EngineeringAttributeInfo info in obj.GetAttributeInfos())
    {
        if ((info.AccessMode & AttributeAccessOptions.ReadWrite) ==
            AttributeAccessOptions.ReadWrite)
        {
            result.Add(info);
        }
    }
    return result;
}

private static bool TrySetAttributes(
    IEngineeringObject obj,
    IEnumerable<KeyValuePair<string, object>> values)
{
    bool hadError = false;
    AttributeDelegate onError = attributeConfiguration =>
    {
        hadError = true;
        attributeConfiguration.CurrentSelection = AttributeChoiceSelection.Abort;
    };

    obj.SetAttributes(values, onError);
    return !hadError;
}
```

---

## Rules

- Prefer strongly typed properties when the PublicAPI exposes them (`ObjectToExport`,
  `ImportTarget`, `ImportedObject`, `FileInfo`, etc.).
- Use `GetAttributeInfos()` to discover optional/version-specific attributes.
- Use `GetAttributes(AttributeAccessOptions.ReadOnly|ReadWrite)` for diagnostics or
  generic inspectors.
- Use `SetAttributes(..., AttributeDelegate)` for bulk writes so an invalid attribute is
  reported through one callback path. Set `AttributeConfiguration.CurrentSelection` to
  `Abort` unless you explicitly want to ignore that attribute and continue.
- Do not run broad attribute scans in status callbacks; do them in action/workflow callbacks.
