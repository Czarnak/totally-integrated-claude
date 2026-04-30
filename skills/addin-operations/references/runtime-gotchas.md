# Known runtime gotchas

These are issues that only surface when TIA Portal actually loads the Add-In —
they do not appear during local builds or unit tests.

---

## Assembly location is unreliable

`Assembly.GetExecutingAssembly().Location` can return an empty string or a path
with illegal characters when TIA Portal loads the Add-In through its custom loader
(which may shadow-copy assemblies into memory). Any call to `Path.GetDirectoryName`
or `Path.Combine` on such a value throws `ArgumentException`.

**Pattern:** Always guard assembly-location resolution in a try-catch and fall back
to a safe default rather than propagating the exception:

```csharp
string assemblyDir = null;
try
{
    string loc = Assembly.GetExecutingAssembly().Location;
    assemblyDir = Path.GetDirectoryName(loc);
}
catch (ArgumentException)
{
    // TIA Portal loaded this assembly without a resolvable path.
    // Fall back to built-in defaults — no external config available.
}
```

---

## No NuGet packages — GAC assemblies only

TIA Portal's process cannot resolve NuGet packages at runtime. Any dependency that
is not in the .NET 4.8 Global Assembly Cache (GAC) will throw `FileNotFoundException`
the moment the Add-In is invoked — even if the build succeeds and the `.addin` file
looks correct.

**Rule:** Never add a NuGet package reference to an Add-In project. Use only
framework-provided types.

Common substitutions:

| Avoid (NuGet) | Use instead (GAC) | Assembly to reference |
|---|---|---|
| `Newtonsoft.Json` | `System.Web.Script.Serialization.JavaScriptSerializer` | `System.Web.Extensions` |
| `Newtonsoft.Json` | `System.Runtime.Serialization.Json.DataContractJsonSerializer` | `System.Runtime.Serialization` |
| `YamlDotNet` | No built-in equivalent — parse JSON or XML instead | — |

Adding `System.Web.Extensions` to the csproj:
```xml
<Reference Include="System.Web.Extensions" />
```
No `HintPath` needed — it is a standard GAC assembly.

---

## WinForms `SplitContainer` — defer all size-dependent assignments

Setting `SplitterDistance` or `Panel2MinSize` in a constructor causes an immediate
`InvalidOperationException` because the control's size is 0 at construction time.
The constraint `Panel1MinSize ≤ SplitterDistance ≤ Size − SplitterWidth − Panel2MinSize`
is unsatisfiable on a zero-sized control. This happens even if `SplitterDistance` is
moved to the `Load` event — nested `SplitContainer` controls inside panels may not
yet be sized when `Load` fires.

**Pattern:** Use `BeginInvoke` from `OnLoad` to defer all size-dependent assignments
until after the message pump has completed layout:

```csharp
protected override void OnLoad(EventArgs e)
{
    base.OnLoad(e);
    BeginInvoke(new Action(ApplySplitterDistances));
}

private void ApplySplitterDistances()
{
    // Set Panel2MinSize BEFORE SplitterDistance — order matters
    splitMain.Panel2MinSize = 200;
    splitMain.SplitterDistance = splitMain.Height - 250;

    splitDetails.Panel2MinSize = 150;
    splitDetails.SplitterDistance = splitDetails.Width / 2;
}
```

Never assign `Panel2MinSize` or `SplitterDistance` in the constructor — not even
to 0 or a small value.
