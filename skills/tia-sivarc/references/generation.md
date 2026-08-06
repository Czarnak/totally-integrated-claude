# SiVArc Generation — V21

Sources: TIA Portal V21 SiVArc Openness manual (03/2026) and installed `Siemens.Engineering.Sivarc.xml` / reflection.

## Preconditions

- A valid SiVArc license is installed. Modification without it raises a recoverable `LicenseNotFound` exception.
- The exact HMI/panel and PLC devices exist, are supported, and are connected as required by the configured rules.
- The selected PLCs compile without errors. Do not recommend or create the undocumented-support file `SivarcDisableCompileClean` to bypass this gate.
- The caller understands the previous/frozen station selection. Later generation can reuse earlier PLC selections, and topology or PLC deletion can cause generated objects to be removed.
- Explicit authorization covers the exact device names, PLC names, and flags. There is no preview-only generation call.

## Installed V21 flags

`GenerationOptions` is a flags enum:

| Member | Meaning |
| --- | --- |
| `GenerationOptions.None` | Use the project generation settings; not a no-op |
| `GenerationOptions.AllTags` | Generate all tags |
| `GenerationOptions.UsedHmiTags` | Generate only used/relevant HMI tags |
| `GenerationOptions.FullGeneration` | Force full rather than SiVArc-selected full/delta generation |
| `GenerationOptions.UserCreatedRules` | Execute user-created rules |
| `GenerationOptions.EnergySuiteRules` | Execute Energy Suite rules |
| `GenerationOptions.AllRules` | Execute all rules |
| `GenerationOptions.AdvancedTags` | Generate advanced tags; present in the installed V21 assembly even though the rendered generation table omits it |

Do not use the incorrect type name `GenerateOptions`. Avoid contradictory tag modes (`AllTags` plus `UsedHmiTags`) and state the effective rule precedence: `AllRules` takes priority over narrower rule-set flags, while user-created rules take priority over Energy Suite rules when combined.

## Guarded generation

```csharp
using System;
using System.Collections.Generic;
using Siemens.Engineering.SiVArc;

private static SivarcGenerationResult GenerateAuthorizedSelection(
    Sivarc sivarc,
    string hmiDeviceName,
    IReadOnlyCollection<string> plcDeviceNames)
{
    if (sivarc == null) throw new ArgumentNullException(nameof(sivarc));
    if (string.IsNullOrWhiteSpace(hmiDeviceName))
        throw new ArgumentException("An exact HMI device/runtime name is required.", nameof(hmiDeviceName));
    if (plcDeviceNames == null || plcDeviceNames.Count == 0)
        throw new ArgumentException("At least one exact PLC device name is required.", nameof(plcDeviceNames));

    // Only call after inventory and explicit authorization for this exact scope.
    GenerationOptions options =
        GenerationOptions.AllTags |
        GenerationOptions.FullGeneration |
        GenerationOptions.UserCreatedRules;

    SivarcGenerationResult result = sivarc.Generate(
        hmiDeviceName,
        plcDeviceNames,
        options);

    RecursivelyWriteMessages(result.Messages, 0);

    if (!result.IsGenerationSuccessful || result.ErrorCount > 0)
        throw new InvalidOperationException(
            $"SiVArc generation failed with {result.ErrorCount} error(s) and " +
            $"{result.WarningCount} warning(s).");

    return result;
}

private static void RecursivelyWriteMessages(
    SivarcFeedbackMessageComposition messages,
    int depth)
{
    foreach (SivarcFeedbackMessage message in messages)
    {
        Console.WriteLine(
            $"{new string(' ', depth * 2)}[{message.MessageType}] " +
            $"{message.Path} {message.Description} " +
            $"(errors={message.ErrorCount}, warnings={message.WarningCount})");
        RecursivelyWriteMessages(message.Messages, depth + 1);
    }
}
```

For multiple HMIs, use the exact installed overload:

```csharp
SivarcGenerationResult result = sivarc.Generate(
    hmiDeviceNames,   // IEnumerable<string>
    plcDeviceNames,   // IEnumerable<string>
    generationOptions);
```

## Result gate

`SivarcGenerationResult` exposes `IsGenerationSuccessful`, `ErrorCount`, `WarningCount`, and `Messages`. Always walk nested `SivarcFeedbackMessage.Messages`; header messages may carry counts while their description is empty. Treat false success, any error count, an exception, or incomplete result traversal as failure. Warnings require review and must not be silently presented as clean generation.

Generation can partially affect devices before cancellation or a later-device failure. Static checks cannot prove atomicity or rollback. Verify affected HMI objects in the live project and save only if the caller requested persistence.
