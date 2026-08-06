# Known runtime gotchas

These are issues that only surface when TIA Portal actually loads the Add-In —
they do not appear during local builds or unit tests.

---

## Do not resolve dependencies from the current assembly path

TIA Portal V21 explicitly does not support attempts by an Add-In or its
third-party components to resolve assemblies based on the current assembly path.
Treat `Assembly.GetExecutingAssembly().Location` as an unreliable package-data
root, even if it happens to return a path in a development setup.

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

## Managed dependency packaging

NuGet is only a build-time source of assemblies; TIA Portal does not restore
packages when an Add-In runs. A third-party **managed** .NET Framework 4.8
dependency may be used when its DLL is compatible with the Add-In permission
model and is included in the package through the publisher configuration:

```xml
<AdditionalAssemblies>
  <AssemblyInfo>
    <Assembly>lib\My.Managed.Dependency.dll</Assembly>
  </AssemblyInfo>
</AdditionalAssemblies>
```

Native assemblies are not supported. Do not add a custom resolver based on the
executing assembly's path. Prefer framework-provided types when they are
sufficient, and test every packaged dependency in the V21 Add-In sandbox;
successful compilation and publication do not prove runtime compatibility.

Low-dependency substitutions:

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

## Add-In version fields are independent

Do not couple the assembly version to TIA Portal V21. `AddInVersion` is the
independent Add-In version shown by the package metadata, while
`Product/Version` is product metadata and the CLR assembly version belongs to
the DLL. None of their major versions has to be `21`.

During debugging, verify the deployed `.addin` hash and the values shown in the
Add-Ins task card before attributing old behavior to caching. Change version
fields intentionally for a new package release, not as a substitute for
confirming which artifact TIA Portal loaded.

---

## Engineering objects as fields/properties — publisher warning

The V21 publisher warns when any Add-In type stores a Siemens engineering object
(`MasterCopy`, `Device`, `PlcBlock`, …) as a **field or property**:

```text
warning : '<TypeName>.<MemberName>' returns or accepts an engineering object.
```

Package creation still succeeds, but the field is a real correctness risk.
Engineering objects are bound to their TIA Portal project and Add-In execution
lifetime. Siemens states that an executed Add-In instance cannot be used after
execution; project changes can invalidate stored handles even earlier.

**Pattern:** treat all engineering objects as method-local. Pass them through
parameters; never persist them on the Add-In instance.
