# SiVArc Rules and Libraries — V21

Sources: TIA Portal V21 SiVArc Openness manual (03/2026) and installed `Siemens.Engineering.Sivarc.xml` / reflection.

## Six rule roots

`Sivarc` exposes six independent roots, each with `Tables` and recursive `Folders`:

| Root | Table | Group | Rule |
| --- | --- | --- | --- |
| `ScreenRules` | `ScreenRuleTable` | `ScreenRuleGroup` | `ScreenRule` |
| `AlarmRules` | `AlarmRuleTable` | `AlarmRuleGroup` | `AlarmRule` |
| `CopyRules` | `CopyRuleTable` | `CopyRuleGroup` | `CopyRule` |
| `TagRules` | `TagRuleTable` | `TagRuleGroup` | `TagRule` |
| `AdvancedTagRules` | `AdvancedTagRuleTable` | `AdvancedTagRuleGroup` | `AdvancedTagRule` |
| `TextlistRules` | `TextlistRuleTable` | `TextlistRuleGroup` | `TextlistRule` |

Each table has `Rules`, `Groups`, `Name`, `IsDefault`, and `Delete()`. Each folder has `Tables`, recursive `Folders`, `Name`, and `Delete()`. Groups expose recursive `Groups`, child `Rules`, common condition properties, and `Delete()`.

## Exact navigation and creation

```csharp
ScreenRuleTable table = sivarc.ScreenRules.Tables.Find("Default screen rule table");
if (table == null)
    throw new InvalidOperationException("The exact screen-rule table was not found.");

ScreenRuleGroup group = table.Groups.Find("ProcessArea_1");
if (group == null)
    group = table.Groups.Create("ProcessArea_1");

ScreenRule rule = group.Rules.Find("MotorFaceplate");
if (rule == null)
    rule = group.Rules.Create("MotorFaceplate");
```

Create tables and recursive folders from their owning compositions:

```csharp
ScreenRuleFolder folder = sivarc.ScreenRules.Folders.Create("AreaRules");
ScreenRuleFolder child = folder.Folders.Create("Line1");
ScreenRuleTable newTable = child.Tables.Create("Line1 screen rules");
```

The same shape applies to alarm, copy, tag, advanced-tag, and text-list rule families. Do not silently fall back to an `IsDefault` table, and do not delete a table/folder merely because it is empty without explicit authorization.

## Rule-specific properties

All rules expose `Name`, `Comment`, `Condition`, `ConditionOperator`, `Enabled`, and `Delete()`. Installed V21 adds these family-specific properties:

| Rule | Additional properties/methods |
| --- | --- |
| `ScreenRule` | `LayoutField`, `LibraryScreen`, `LoopCount`, `ProgramBlock`, `ScreenObjectLibraryItem`, `GetLayoutFields()` |
| `AlarmRule` | `AlarmLibraryItem`, `ProgramBlock` |
| `CopyRule` | `FolderStructure`, `LibraryObject` |
| `TagRule` | `TagGroupHierarchy`, `TagTable` |
| `AdvancedTagRule` | `ProgramBlock`, `TagGroupHierarchy`, `TagLibraryItem`, `TagTable` |
| `TextlistRule` | `ProgramBlock`, `TextlistLibraryItem` |

`ConditionOperator` values are `None`, `And`, `Equal`, `NotEqual`, `GreaterThan`, `GreaterThanOrEqual`, `LessThan`, and `LessThanOrEqual`.

Condition and comment strings are limited by SiVArc; the V21 manual documents a 500-character limit for tag-rule fields. Validate expressions and lengths before applying them.

## Master copies and rule-table library types

Rule and group compositions can create from a `MasterCopy`:

```csharp
ScreenRule copied = table.Rules.CreateFrom(masterCopy, CreateOptions.Rename);
```

The installed create options are:

- `CreateOptions.Rename` — rename the new object when a name conflicts.
- `CreateOptions.Replace` — overwrite the existing object; require explicit destructive authorization.

Rule-table compositions instantiate a family-specific type version:

```csharp
ScreenRuleTableTypeVersion version = /* exact project/global library version */;
ScreenRuleTable instance = sivarc.ScreenRules.Tables.CreateFrom(version);
```

Corresponding version types exist for all six families. An instantiated table exposes `LibraryTypeInstanceInfo`; editing a released library-backed rule-table instance can throw. Do not present a released instance as freely editable.

Updating project-library instances uses the SiVArc root as an update scope:

```csharp
project.ProjectLibrary.UpdateProject(
    project.ProjectLibrary.TypeFolder.Types,
    new List<IUpdateProjectScope> { sivarc });
```

Inventory the connected version and affected rule tables before updating. Global-library update uses the matching library operation and must not be inferred from this project-library example.

## Dynamic PLC/HMI columns

Screen, alarm, and copy rules expose device-selection columns through dynamic `GetAttribute`/`SetAttribute` names. Tag and text-list rules do not support those dynamic device columns. Use the exact resolved PLC name or HMI runtime/device key from the current project; V21 normalizes unsupported special characters and can append counters when normalized names collide.

Never synthesize a dynamic attribute name from a raw device name and immediately write it. Inventory attribute metadata/current values, bind the resolved key to the exact device identity, and fail on collisions or unsupported rule types.

## Mutation gate

Create, copy, replace, update, rename, edit, or delete only after exact selection and explicit authorization. Inventory nested groups/rules and library-instance dependencies before table/folder deletion. Use `ExclusiveAccess`; compile/validate the affected PLC/HMI artifacts and save only when explicitly requested.
