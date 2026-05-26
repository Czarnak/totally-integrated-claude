# Migrating an older Add-In (V20 → V21)

There is no automatic conversion path from earlier Add-In versions to V21. The
old monolithic `Siemens.Engineering.AddIn.dll` was split into segmented
assemblies, and several runtime constraints changed. This file walks the full
recovery and rebuild path.

---

## When the source is lost — recover from the `.addin` package

A `.addin` is a ZIP. The main assembly can be extracted and decompiled.

1. **Extract**

   ```
   Copy   MyAddIn.addin  →  MyAddIn.zip
   Unzip  MyAddIn.zip    →  <out>/
   ```

   The main `.dll` is the entry whose name encodes
   `<name>,version=...,culture=neutral,publickeytoken=null,processorarchitecture=msil`.
   Inspect `EngineeringVersion`, `Meta/Version`, and `Meta/PublisherTarget` to
   confirm the source TIA Portal version before starting.

2. **Decompile** with `ilspycmd` (dotnet tool):

   ```
   dotnet tool install -g ilspycmd
   ilspycmd -p MyAddIn.dll -o src
   ```

   ILSpy emits a minimal SDK-style csproj plus the recovered `.cs` and `.resx`
   files. The result will not build cleanly against V21 — see fixups below.

3. **Cross-check** the recovered type names with a reflection viewer
   (HandMirror, ILSpy GUI, dnSpy) against the V21 PublicAPI assemblies under
   `C:\Program Files\Siemens\Automation\Portal V21\PublicAPI\V21\net48`. This
   catches renames and moved namespaces before they become compile errors.

---

## Required fixups in the recovered project

### Reference migration (always)

Remove the old monolithic reference and add the V21 segmented assemblies. See
[`assembly-references.md`](assembly-references.md) for the namespace → assembly
map and the dual-`ItemGroup` csproj pattern, plus the line-break trap that
makes references silently fail to load.

The five assemblies auto-added by the V21 `addin-project` template are the
minimum set; add `Siemens.Engineering.Step7.dll` and friends only as needed.

### Menu delegate syntax (whenever the Add-In has menus)

ILSpy renders the delegate casts in the old top-level form:

```csharp
(OnClickDelegate<Device>)OnDoWork
(OnUpdateStatusDelegate<Device>)OnCanDoWork
```

V21 nests both delegate types inside `ActionItem<T>`:

```csharp
(ActionItem<Device>.OnClickDelegate)OnDoWork
(ActionItem<Device>.OnUpdateStatusDelegate)OnCanDoWork
```

Apply the rename across every `Add*ActionItem*<T>(...)` call site.

### Platform target

Set `<PlatformTarget>AnyCPU</PlatformTarget>` in the recovered csproj. The V21
publisher rejects `x86`/`x64`.

### Assembly version

Stamp the recovered assembly with a `21.x.y.z` version (`AssemblyInfo.cs` or
csproj `<AssemblyVersion>` property). The major must match the engineering
version. During iterative debugging, bump the patch on every build — see
[`runtime-gotchas.md`](runtime-gotchas.md) → "Add-In package identity is cached".

### WinForms resources

If the Add-In has any non-string `.resx` (icons, ImageList), do **not** let the
SDK build emit preserialized resources. Convert the recovered `.resx` files to
classic `.resources` and embed them directly. Full rationale and pattern in
[`runtime-gotchas.md`](runtime-gotchas.md) → "WinForms `.resx` resources".

### Callback threading

If the original Add-In blocked the menu callback (long modal loop, direct
`ShowDialog()`, request-handling loop), restructure it around the two-phase
collect/show pattern before publishing. The watchdog rules in V21 are the
same, but the recovered code likely violates them. See
[`threading-and-callbacks.md`](threading-and-callbacks.md).

Also watch for TIA Portal API calls that the recovered code makes from a
**background** thread (a request loop, a worker, a timer). API objects are
STA-bound to the callback thread; the calls return `null` or throw when made
elsewhere. Pre-collect all TIA data on the callback thread and pass only plain
.NET types to the background.

### Logging

Add a `%TEMP%` log file early — it is the only way to diagnose the partial-
trust and threading failures that the migration is about to trigger. Pattern
in [`threading-and-callbacks.md`](threading-and-callbacks.md) →
"Diagnosing silent failures".

Older templates often shipped a `LogMessageToFile` method with an **empty**
body. Replace it with a real implementation rather than leaving the silent
stub — otherwise the existing call sites give no information when the
migration runs into a runtime gotcha.

---

## Publish for V21

See [`package-and-publisher.md`](package-and-publisher.md) for the publisher
config XML, required package metadata, and the post-publish verification
checklist. Confirm `EngineeringVersion = V21` and that no
`System.Resources.Extensions` is bundled before shipping.

---

## Decompiler warnings to ignore

ILSpy-recovered code typically produces these benign warnings:

- `CS0219` for unused locals (`flag`, `deviceType`) — leftover from optimized
  builds; delete the lines or suppress.
- `CS0649` for never-assigned designer `IContainer components` fields — the
  WinForms designer pattern leaves these null and `Dispose()` guards for null.

Neither relates to the runtime issues above. Do not let them distract from
real failures in the log file.
