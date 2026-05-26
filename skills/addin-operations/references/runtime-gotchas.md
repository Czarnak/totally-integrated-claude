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
| --- | --- | --- |
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

---

## WinForms `.resx` resources — avoid preserialized format

SDK-style projects with **non-string** `.resx` resources (icons, images, `ImageList`
entries) emit **preserialized** `.resources` files at build time. The runtime then
demands `System.Resources.Extensions`, which transitively requires
`System.Runtime.CompilerServices.Unsafe`. TIA Portal's Add-In sandbox runs under
partial trust and rejects `Unsafe`'s verification-skipping IL with:

```text
System.Security.VerificationException: Operation could destabilize the runtime.
   at System.Resources.Extensions.TypeNameComparer...
```

The failure surfaces only when the affected form/menu item is first instantiated
— the Add-In loads fine, then dies silently on first use.

**Pattern:** convert each `.resx` to a classic .NET Framework `.resources` binary
ahead of time and embed it directly. Drop both `System.Resources.Extensions` and
`System.Runtime.CompilerServices.Unsafe` from project references.

```xml
<ItemGroup>
  <EmbeddedResource Include="Forms\MainForm.resources">
    <LogicalName>MyAddIn.Forms.MainForm.resources</LogicalName>
  </EmbeddedResource>
</ItemGroup>
```

A small converter using `ResXResourceReader` + `ResourceWriter` (GAC types in
`System.Windows.Forms` / `mscorlib`) can produce the `.resources` files as a
pre-build step.

The `LogicalName` must exactly match what `ComponentResourceManager` requests
(`<namespace>.<formname>.resources`), otherwise the form falls back to an empty
resource set and designer-bound icons/images go missing with no exception.

---

## Add-In package identity is cached

TIA Portal caches loaded Add-In assemblies by package identity. Building a new
`.addin` with the same `AddInVersion` + assembly version produces a package that
TIA Portal silently ignores in favour of the cached copy — code changes appear
to have no effect, even after closing and reopening TIA Portal.

**Pattern during iterative debugging:** bump **both** the assembly
`[assembly: AssemblyVersion(...)]` and the package version field
(`Config.xml` → `AddInVersion`, or the V21 publisher config equivalent) on every
build that needs to be reloaded. Patch-version bumps (`21.0.0.1` → `21.0.0.2`)
are sufficient.

The cache survives process restarts; only an identity change forces a reload.

---

## Engineering objects as fields/properties — publisher warning

The V21 publisher warns when any Add-In type stores a Siemens engineering object
(`MasterCopy`, `Device`, `PlcBlock`, …) as a **field or property**:

```text
warning : '<TypeName>.<MemberName>' returns or accepts an engineering object.
```

Package creation still succeeds, but the field is a real correctness risk.
Add-Ins are not unloaded between executions, so the cached Add-In instance
outlives the project that owned the object — the stored reference becomes
invalid the moment the user closes/reopens the project, and the next call into
the Add-In faults on the stale handle.

**Pattern:** treat all engineering objects as method-local. Pass them through
parameters; never persist them on the Add-In instance.
