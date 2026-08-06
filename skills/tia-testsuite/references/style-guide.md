# V21 API Reference: Style Guide

## 🛠️ Siemens.Engineering.TestSuite.StyleGuide.RSLoadOptions
>
> Rule set load options.

- `RSLoadOptions.None`
- `RSLoadOptions.IgnorePropertyErrors`
- `RSLoadOptions.IgnoreMissingAttributes`
- `RSLoadOptions.SkipInvalidObjects`

## 🛠️ Siemens.Engineering.TestSuite.StyleGuide.RuleSet
>
> Represents a rule set under Style Guide.

- 📦 `GetService<T>()`: Gets an instance of service type `T`.
- 🔧 `Name`: Name of the rule set.
- 📦 `CopyScope(RuleSet)`: Copies scope from another rule set.
- 📦 `SaveToFile(FileInfo)`: Saves the rule set to an external source file.
- 📦 `SetScope(UpdateOptions, IEnumerable<IEngineeringObject>)`: Updates scope.
- 📦 `ShowInEditor()`: Shows the rule set in the editor.
- 📦 `Delete()`: Deletes the rule set.

## 🛠️ Siemens.Engineering.TestSuite.StyleGuide.RuleSetComposition
>
> Collection of Style Guide rule sets.

- 🔧 `Count`, `IsReadOnly`, `Parent`, `Item(Int32)`
- 📦 `Any()`, `Contains(RuleSet)`, `IndexOf(RuleSet)`
- 📦 `CreateFrom(MasterCopy)`: Creates a rule set from a master copy.
- 📦 `LoadFromFile(FileInfo, ImportOptions, RSLoadOptions)`: Imports a rule set.
- 📦 `Find(String)`: Finds a rule set by name.

## 🛠️ Siemens.Engineering.TestSuite.StyleGuide.RuleSetExecutor
>
> Provides the Style Guide execution service.

- 📦 `Run(RuleSet)`: Executes one rule set and returns `TestResults`.
- 📦 `Run(StyleGuideSystemGroup)`: Executes the Style Guide group and returns `TestResults`.
- 📦 `Run(IEnumerable<RuleSet>)`: Executes selected rule sets and returns `TestResults`.

## 🛠️ Siemens.Engineering.TestSuite.StyleGuide.StyleGuideSystemGroup
>
> Style Guide system folder.

- 📦 `GetService<T>()`: Gets an instance of service type `T`.
- 🔧 `RuleSets`: Rule-set composition.

## 🛠️ Siemens.Engineering.TestSuite.StyleGuide.UpdateOptions
>
> Rule-set scope update mode.

- `UpdateOptions.Add`
- `UpdateOptions.Override`

## V21 workflow and safety

```csharp
TestSuiteService service = project.GetService<TestSuiteService>();
StyleGuideSystemGroup group = service.StyleGuideGroup;

List<RuleSet> matches = group.RuleSets
    .Where(ruleSet => string.Equals(ruleSet.Name, exactRuleSetName, StringComparison.Ordinal))
    .ToList();
if (matches.Count != 1)
    throw new InvalidOperationException(
        $"Expected exactly one Style Guide rule set '{exactRuleSetName}', found {matches.Count}.");

RuleSet ruleSet = matches[0];
RuleSetExecutor executor = group.GetService<RuleSetExecutor>();
TestResults results = executor.Run(ruleSet);
```

`RuleSetComposition.LoadFromFile` imports external rule-set data. Treat the file
as untrusted and validate its provenance and resulting identity. The load flags
can suppress specific invalid inputs; report every skipped property, missing
attribute, or invalid object rather than claiming a complete import.

`UpdateOptions.Add` adds objects to the current scope. `UpdateOptions.Override`
replaces the current scope and is destructive. `ImportOptions.Override` may also
replace existing project content. Both require the V21 `Edit Test Suite data`
right, explicit project-write authorization, and an affected-object inventory.

Style Guide `Run` is static analysis. It does not prove compile, simulation,
download, OPC UA behavior, or live controller behavior.
