# SiVArc Definitions, Expression Resolution, and Layout Data — V21

Sources: TIA Portal V21 SiVArc Openness manual (03/2026) and installed `Siemens.Engineering.Sivarc.xml` / reflection.

## Block definitions and member settings

`SivarcDataProvider` is a service of a PLC code block/compile unit that supports SiVArc data. It exposes `TagDefinitions`, `TextDefinitions`, and `TagMemberSettings`.

```csharp
CodeBlock block = plcSoftware.BlockGroup.Blocks.Find("Block_1") as CodeBlock;
if (block == null)
    throw new InvalidOperationException("The exact code block was not found.");

SivarcDataProvider provider = block.GetService<SivarcDataProvider>();
if (provider == null)
    throw new InvalidOperationException("The selected block has no SiVArc data provider.");

TagDefinition tagDefinition = provider.TagDefinitions.Find("SIVARCCOND_1")
    ?? provider.TagDefinitions.Create("SIVARCCOND_1");
tagDefinition.Value = "Block.Name";
tagDefinition.Comment = "Reviewed SiVArc tag definition";

TextDefinition textDefinition = provider.TextDefinitions.Find("SIVARCTEXT_1")
    ?? provider.TextDefinitions.Create("SIVARCTEXT_1");
textDefinition.Expression = "Block.SymbolicName";

// Text is a read-only MultilingualText container; write a language item.
MultilingualTextItem localizedText = textDefinition.Text.Items.Find(englishLanguage);
if (localizedText == null)
    throw new InvalidOperationException("The exact active project language was not found.");
localizedText.Text = "Generated label";
```

Here `englishLanguage` is the exact `Language` resolved from `project.LanguageSettings.ActiveLanguages`; do not select a language by index.

`TagMemberSetting` exposes `UseCommonConfiguration`, `CommonParameters`, and `BlockParameters`. Each `TagMember` has `Name`, `AcquisitionCycle`, `AcquisitionMode`, and `Comment`. Installed `AcquisitionMode` members are `None`, `CyclicContinuous`, `CyclicInOperation`, and `OnDemand`.

```csharp
TagMemberSetting settings = provider.TagMemberSettings;
settings.UseCommonConfiguration = true;
settings.CommonParameters.AcquisitionCycle = "T1s";
settings.CommonParameters.AcquisitionMode = AcquisitionMode.CyclicContinuous;

TagMember input = settings.BlockParameters.Find("Input_1");
if (input == null)
    throw new InvalidOperationException("The exact block member was not found.");
```

Definition and member writes require explicit authorization and a valid SiVArc license. Validate expressions, cycles, and block/member identity before mutation.

## Upgrading legacy definitions

The upgrader is a service of `PlcSoftware`:

```csharp
SivarcDefinitionsUpgrader upgrader =
    plcSoftware.GetService<SivarcDefinitionsUpgrader>();
if (upgrader == null)
    throw new InvalidOperationException("SiVArc definition upgrade is unavailable.");

UpgradeDefinitionsResult result = upgrader.Upgrade();
RecursivelyWriteMessages(result.Messages, 0);
Console.WriteLine($"Upgrade warnings: {result.WarningCount}");
```

The exact installed result type is `UpgradeDefinitionsResult` (plural “Definitions”). The rendered V21 example uses the inconsistent singular spelling `UpgradeDefinitionResult`; do not copy that typo. The result exposes warnings and messages but no error-count property, so an exception and recursive messages are part of the failure gate.

## Expression resolver

Acquire the resolver from the project-level `Sivarc` service using an exact PLC code block, an exact HMI `DeviceItem`, and an exact project-library item (`IEngineeringObject`):

```csharp
ExpressionResolver resolver = sivarc.GetExpressionResolver(
    codeBlock,
    hmiDeviceItem,
    sivarcLibraryItem);

IList<ExpressionResult> results = resolver.Resolve(expression);
foreach (ExpressionResult item in results)
{
    Console.WriteLine($"{item.InstanceName}: {item.Result} ({item.CallPath})");
}
```

The PLC call structure must be compiled. Resolution errors are reported as recoverable exceptions. Treat zero results as a distinct outcome, not proof that the expression is correct.

## Layout YML import/export

`LayoutData` is a service of both classic/Advanced `Screen` and Unified `HmiScreen` objects:

```csharp
LayoutData layout = exactScreen.GetService<LayoutData>();
if (layout == null)
    throw new InvalidOperationException("LayoutData is unavailable for the selected screen.");

layout.Export(exportFile);

LayoutDataImportResult importResult = layout.Import(importFile);
if (importResult.State == LayoutImportResultState.None)
    throw new InvalidOperationException("Layout import did not complete.");
if (importResult.State == LayoutImportResultState.Warning)
    Console.WriteLine("Layout import completed with warnings; review the destination screen.");

Console.WriteLine($"Imported layouts: {importResult.NumberOfLayouts}");
```

Installed `LayoutImportResultState` members are only `None`, `Success`, and `Warning`; the enum has no `Error` member. Import/export errors raise recoverable exceptions. Require explicit authorization for import, validate the YML path and provenance, resolve the exact destination screen/model, and inspect the screen after import before saving.
