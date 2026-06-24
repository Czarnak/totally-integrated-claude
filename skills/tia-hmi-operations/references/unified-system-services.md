## 4. Scripts

```csharp
using Siemens.Engineering.HmiUnified.Scripts;

// Enumerate script modules
foreach (HmiScriptModule script in hmiSoftware.Scripts)
    Console.WriteLine(script.Name);

// Export scripts
hmiSoftware.Scripts.Export(new DirectoryInfo(@"C:\Export\Scripts\"));

// Import scripts
hmiSoftware.Scripts.Import(new DirectoryInfo(@"C:\Import\Scripts\"));
hmiSoftware.Scripts.Import("importFileName");

// Export individual script module
HmiScriptModule module = hmiSoftware.Scripts.First();
module.Export(new DirectoryInfo(@"C:\Export\"));
module.Export("fileName");
```

---

## 🛠️ Siemens.Engineering.HmiUnified.Scripts.HmiScriptModule
>
> Dummy Description

- 🔧 `Name`: Name attribute description
- 📦 `Export(System.IO.DirectoryInfo)`: Export script module
- 📦 `Export(System.IO.DirectoryInfo,System.String)`: Export script module with specific file name

## 🛠️ Siemens.Engineering.HmiUnified.Scripts.HmiScriptModuleComposition
>
> Script Module Description

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.Scripts.HmiScriptModule)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.Scripts.HmiScriptModule)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Export(System.IO.DirectoryInfo)`: Export scripts
- 📦 `Import(System.IO.DirectoryInfo)`: Import scripts
- 📦 `Import(System.IO.DirectoryInfo,System.String)`: Import scripts

## 5. Text and graphic lists

```csharp
using Siemens.Engineering.HmiUnified.TextGraphicList;

// Text lists
foreach (HmiTextList tl in hmiSoftware.HmiTextLists)
    Console.WriteLine($"TextList: {tl}");

// System text lists (read-only)
foreach (HmiSystemTextList stl in hmiSoftware.HmiSystemTextLists)
    Console.WriteLine($"SystemTextList: {stl}");

// Graphic lists
foreach (HmiGraphicList gl in hmiSoftware.HmiGraphicLists)
    Console.WriteLine($"GraphicList: {gl}");
```

---

## 🛠️ Siemens.Engineering.HmiUnified.TextGraphicList.HmiGraphicList
>
> Hmi graphic list

- 🔧 `Name`: Name of the hmi graphic list
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HmiUnified.TextGraphicList.HmiGraphicListComposition
>
> Hmi graphic list composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.TextGraphicList.HmiGraphicList)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.TextGraphicList.HmiGraphicList)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Export(System.IO.DirectoryInfo,System.String)`: Export hmi graphic lists
- 📦 `Import(System.IO.DirectoryInfo,System.String)`: Import hmi graphic lists
- 📦 `Find(System.String)`: Finds the hmi graphic list based on the given name

## 🛠️ Siemens.Engineering.HmiUnified.TextGraphicList.HmiSystemTextList
>
> Hmi system text list

- 🔧 `Name`: Name of the hmi text list

## 🛠️ Siemens.Engineering.HmiUnified.TextGraphicList.HmiSystemTextListComposition
>
> Hmi system text list composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.TextGraphicList.HmiSystemTextList)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.TextGraphicList.HmiSystemTextList)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Export(System.IO.DirectoryInfo,System.String)`: Export hmi system text lists
- 📦 `Import(System.IO.DirectoryInfo,System.String)`: Import hmi system text lists
- 📦 `Find(System.String)`: Finds the hmi system text list based on the given name

## 🛠️ Siemens.Engineering.HmiUnified.TextGraphicList.HmiTextList
>
> Hmi text list

- 🔧 `Name`: Name of the hmi text list
- 📦 `Delete`: Deletes this instance.

## 🛠️ Siemens.Engineering.HmiUnified.TextGraphicList.HmiTextListComposition
>
> Hmi text list composition

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HmiUnified.TextGraphicList.HmiTextList)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HmiUnified.TextGraphicList.HmiTextList)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Export(System.IO.DirectoryInfo,System.String)`: Export hmi text lists
- 📦 `Import(System.IO.DirectoryInfo,System.String)`: Import hmi text lists
- 📦 `Find(System.String)`: Finds the hmi text list based on the given name
