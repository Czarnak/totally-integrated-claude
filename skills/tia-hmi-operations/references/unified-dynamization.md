## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.DynamizationBase
>
> Base dynamization

- 🔧 `DynamizationType`: Dynamization type
- 🔧 `PropertyName`: Property name
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.DynamizationBaseComposition
>
> Dynamization collection

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Dynamization.DynamizationBase)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Dynamization.DynamizationBase)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create``1(System.String)`: Creates dynamization object
- 📦 `Find(System.String)`: Finds the dynamization

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.DynamizationType
>
> Type of dynamization

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.ExpressionDynamization
>
> Expression dynamization

- 🔧 `ValueConverter`: Value converter

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.ResourceListDynamization
>
> Resource list dynamization

- 🔧 `ResourceList`: Resource list object name
- 🔧 `Tag`: Tag object name

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.TagDynamization
>
> Tag dynamization

- 🔧 `Address`: Address of the tag
- 🔧 `DataType`: Data type of the tag
- 🔧 `PlcTag`: Plc Tag Name associated with Hmi Tag
- 🔧 `ReadOnly`: Read only
- 🔧 `Tag`: Tag for the dynamization
- 🔧 `UseIndirectAddressing`: Use indirect addressing
- 🔧 `ValueConverter`: Value Converter

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.TagParameterDynamization
>
> Tag parameter dynamization

- 🔧 `DynamicTagName`: Dynamic tag name for the dynamization

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Flashing.FlashingCondition
>
> Flashing condition

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Flashing.FlashingDynamization
>
> Flashing dynamization

- 🔧 `AlternateColor`: Alternate color
- 🔧 `Color`: Default color
- 🔧 `FlashingCondition`: Flashing condition
- 🔧 `FlashingRate`: Flashing rate

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Flashing.FlashingRate
>
> Flashing rate

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Script.IHmiScript
>
> Hmi Script interface

- 🔧 `Async`: Script method is async
- 🔧 `GlobalDefinitionAreaScriptCode`: Global definition area script
- 🔧 `ScriptCode`: Script code
- 📦 `SyntaxCheck`: Checks the syntax of the script

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Script.ScriptDynamization
>
> Script dynamization

- 🔧 `Async`: Script method is async
- 🔧 `GlobalDefinitionAreaScriptCode`: Global definition area script
- 🔧 `ScriptCode`: Script code
- 🔧 `Trigger`: Trigger for script
- 📦 `SyntaxCheck`: Checks the syntax of the script

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Script.Trigger
>
> Trigger for script dynamization

- 🔧 `CustomDuration`: Cycle for duration
- 🔧 `Tags`: Tags for trigger
- 🔧 `Type`: Type of trigger

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Script.TriggerType
>
> Type of trigger

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.BitDynamizationType
>
> Bitmask type for bitmask entry

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.ConditionType
>
> Condition Type for Mapping Table

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.MappingTable
>
> Mapping Table for Tag Dynamization

- 🔧 `Entries`: Mapping Entries
- 🔧 `ConditionType`: Condition Type

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.MappingTableEntryBase
>
> Mapping Table Entries

- 🔧 `AlternateValue`: Alternate Value
- 🔧 `Flashing`: Property Flashing
- 🔧 `FlashingRate`: Flashing Rate
- 🔧 `Value`: Property Value
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.MappingTableEntryBaseComposition
>
> Mapping Table Composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.MappingTableEntryBase)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.MappingTableEntryBase)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.BitDynamizationType)`: Create singlbit entry and multibit entry
- 📦 `Create``1`: Create Tag dynamization entries

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.MappingTableEntryBitmask
>
> MappingTable Entry Bitmask

- 🔧 `BitDynamizationType`: BitDynamizationType
- 🔧 `Condition`: Multiple Bits: Condition value is 2 to the power of the bit number which is being configured.Example: For configuring Bit no. 3, condition value will be : 2^3 = 8. Single Bit :Condition value for State 0 of the bit will always be 0. And Condition Value for State 1 will be 2 to the power of the bit number which is being configured. Example : If configuring Bit No. 15, State 0 Condition will be 0 &amp; State 1 Condition will be 2^15 = 32768.
- 🔧 `Relevant`: Multiple Bits: Relevant value is the Decimal equivalent of all the bits configured. Example : If Bit 2 &amp; 4 are being configured, then Relevant value will be : 2^4 OR 2^2 = 20. Single Bit: Relevant value is the Decimal equivalent of the Single bit being configured. Example : If Bit 15 is being configured, then Relevant value will be : 2^15 = 32768.

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.MappingTableEntryRange
>
> Mapping Entry Range

- 🔧 `From`: From
- 🔧 `RangeType`: Range Type
- 🔧 `To`: To

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.MappingTableEntrySimple
>
> Mapping Entry Simple

- 🔧 `Condition`: Condition

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.RangeType
>
> Range Type

## 🛠️ Siemens.Engineering.HmiUnified.UI.Dynamization.Tag.ValueConverter
>
> Value converter for Tag Dynamization

- 🔧 `Formula`: Formula
- 🔧 `IsFormulaSelected`: IsFormulaSelected
- 🔧 `MappingTable`: Returns Mapping Table information
