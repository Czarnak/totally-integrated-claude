# Compile Reference

Source: TIA Portal Openness V21 — Functions for Projects and Project Data (03/2026)

> C# only. Do not mix with Python wrapper calls.
> All devices must be **offline** before compiling.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.Compiler;
using Siemens.Engineering.HW;
using Siemens.Engineering.Hmi;
using Siemens.Engineering.SW;
using Siemens.Engineering.SW.Blocks;
using Siemens.Engineering.SW.Types;
```

---

## 1. ICompilable — universal compile entry point

Any compilable object exposes `ICompilable` via `GetService<ICompilable>()`.
The compile type (HW, SW, or HW+SW) depends on the object type.

**Supported object types:**

| Object type | Compile scope |
|---|---|
| `Device` | HW + SW |
| `Device` with F-CPU (F-activation off) | SW only |
| `DeviceItem` | HW |
| `PlcSoftware` | SW |
| `HmiTarget` | SW |
| `CodeBlock` (`FB`, `FC`, `OB`) | SW |
| `DataBlock` (`GlobalDB`, `InstanceDB`, `ArrayDB`) | SW |
| `PlcBlockSystemGroup` | SW |
| `PlcBlockUserGroup` | SW |
| `PlcType` | SW |
| `PlcTypeSystemGroup` | SW |
| `PlcTypeUserGroup` | SW |

---

## 2. Compile — standard pattern

```csharp
private static CompilerResult Compile(IEngineeringServiceProvider target)
{
    ICompilable compileService = target.GetService<ICompilable>();
    if (compileService == null)
        throw new InvalidOperationException("Object does not support compilation.");

    return compileService.Compile();
}
```

**Concrete examples:**

```csharp
// Compile all software on a PLC
ICompilable plcCompile = plcSoftware.GetService<ICompilable>();
CompilerResult plcResult = plcCompile.Compile();

// Compile an HMI device
ICompilable hmiCompile = hmiTarget.GetService<ICompilable>();
CompilerResult hmiResult = hmiCompile.Compile();

// Compile a single code block
CodeBlock block = plcSoftware.BlockGroup.Blocks.Find("MyFB") as CodeBlock;
if (block != null)
{
    ICompilable blockCompile = block.GetService<ICompilable>();
    CompilerResult blockResult = blockCompile.Compile();
}

// Compile hardware of a device item (CPU slot)
ICompilable hwCompile = deviceItem.GetService<ICompilable>();
CompilerResult hwResult = hwCompile.Compile();
```

> **Safety note:** If the safety program has a password, you must log in to the safety
> program before compiling software changes. Otherwise, the compile is cancelled and an
> exception is thrown.

---

## 3. Reading CompilerResult

```csharp
private static void PrintCompilerResult(CompilerResult result)
{
    Console.WriteLine($"State:         {result.State}");
    Console.WriteLine($"Error count:   {result.ErrorCount}");
    Console.WriteLine($"Warning count: {result.WarningCount}");
    PrintMessages(result.Messages);
}

private static void PrintMessages(CompilerResultMessageComposition messages,
    string indent = "")
{
    indent += "  ";
    foreach (CompilerResultMessage msg in messages)
    {
        Console.WriteLine($"{indent}[{msg.State}] {msg.Path}");
        Console.WriteLine($"{indent}       {msg.Description}");
        Console.WriteLine($"{indent}       {msg.DateTime.ToLocalTime()}");
        // Recurse into nested messages
        PrintMessages(msg.Messages, indent);
    }
}
```

> **Note:** All `DateTime` values in `CompilerResult` are UTC.
> Use `DateTime.ToLocalTime()` to display local time.

---

## 4. Compile in a workflow

```csharp
using (ExclusiveAccess ea = tiaPortal.ExclusiveAccess("Compile all"))
{
    foreach (Device device in project.Devices)
    {
        ICompilable compile = device.GetService<ICompilable>();
        if (compile == null) continue;

        ea.Text = $"Compiling {device.Name}";
        CompilerResult result = compile.Compile();

        if (result.ErrorCount > 0)
            Console.WriteLine($"  {device.Name}: {result.ErrorCount} error(s)");
    }
}
```
