# Device Attributes Reference

Source: TIA Portal Openness V21 — Functions on Devices (03/2026)

> C# only. Do not mix with Python wrapper calls.

---

## Namespaces

```csharp
using Siemens.Engineering;
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Extensions; // GsdDevice
```

---

## 1. Mandatory device and device-item attributes

All devices and device items expose these attributes. Write access varies by object type
and configuration state. PLC must be offline for write operations.

| Attribute | Type | Writable | Access | Notes |
| --- | --- | --- | --- | --- |
| `Name` | `string` | r/w (sometimes r/o) | modeled | Device/item name |
| `TypeIdentifier` | `string` | r/o | modeled | Full type identifier string |
| `TypeName` | `string` | r/o | dynamic | Human-readable type name |
| `IsGsd` | `bool` | r/o | modeled | `true` if installed via GSD/GSDML |
| `Author` | `string` | r/w | dynamic | Author field |
| `Comment` | `string` | r/w | dynamic | Single-language comment |
| `CommentML` | `MultilingualText` | r/w | dynamic | Multilingual comment |

```csharp
// Modeled attributes — direct property access
string name     = device.Name;
bool   isGsd    = device.IsGsd;
string typeId   = device.TypeIdentifier;

// Dynamic attributes — via GetAttribute
string typeName = (string)device.GetAttribute("TypeName");
string author   = (string)device.GetAttribute("Author");
string comment  = (string)device.GetAttribute("Comment");
device.SetAttribute("Author", "AutoTool");
device.SetAttribute("Comment", "Auto-generated");
```

---

## 2. GSD device service

Devices installed via GSD/GSDML provide additional identification via `GsdDevice`:

```csharp
// On a Device
GsdDevice gsdDev = ((IEngineeringServiceProvider)device).GetService<GsdDevice>();
if (gsdDev != null)
{
    string gsdId    = gsdDev.GsdId;      // e.g. "4"
    string gsdName  = gsdDev.GsdName;    // e.g. "SIEM8139.GSD"
    string gsdType  = gsdDev.GsdType;    // e.g. "M"
    bool isProfibus = gsdDev.IsProfibus;
    bool isProfinet = gsdDev.IsProfinet;
}

// On a DeviceItem
GsdDevice gsdItem = ((IEngineeringServiceProvider)deviceItem).GetService<GsdDevice>();
```

---

## 3. CustomIdentityProvider — Application IDs

Key-value pairs attached to a device or device-item, scoped to the current Openness
session. Not persisted in the project file.

**Constraints:** max 64 IDs per object; key and value max 128 characters each.
Duplicate keys overwrite the previous value.

```csharp
// Get the service
CustomIdentityProvider idService = device.GetService<CustomIdentityProvider>();

// Set an Application ID (key-value pair)
idService.Set("ToolId", "AutoGen-001");

// Retrieve
string value = idService.Get("ToolId"); // returns "AutoGen-001"

// Remove — throws CustomIdentityNotFoundException if key does not exist
try
{
    idService.Remove("ToolId");
}
catch (CustomIdentityNotFoundException ex)
{
    Console.WriteLine($"Key not found: {ex.Message}");
}
```

---

## 4. Bulk attribute change with error handler

Sets multiple attributes in one call. Dependency ordering between attributes is handled
automatically (V19+). The callback fires per attribute — use it to skip failures without
aborting the whole batch.

```csharp
private static void BulkSetAttributes(DeviceItem item)
{
    var attrs = new List<KeyValuePair<string, object>>
    {
        new KeyValuePair<string, object>("IsochronousTi",   (double)0.1),
        new KeyValuePair<string, object>("IsochronousTo",   (double)0.3),
        new KeyValuePair<string, object>("IsochronousTiToCalculationMode",
            Siemens.Engineering.HW.IsochronousTiToCalculationMode.Manual),
        new KeyValuePair<string, object>("IsochronousMode", true)
    };

    item.SetAttributes(attrs, config =>
    {
        // Ignore errors on individual attributes and continue with the rest
        config.CurrentSelection = AttributeChoiceSelection.Ignore;
    });
}
```

---

## 5. Dynamic object structure discovery

Useful for tooling that must inspect unknown objects:

```csharp
// List all composition names on an object
IList<EngineeringCompositionInfo> comps =
    ((IEngineeringObject)device).GetCompositionInfos();
foreach (var c in comps)
    Console.WriteLine(c.Name);

// Get a composition by name (when type is known)
DeviceItemComposition items =
    (DeviceItemComposition)((IEngineeringObject)device).GetComposition("DeviceItems");

// List all attributes with access modes
IList<EngineeringAttributeInfo> attrInfos =
    ((IEngineeringObject)deviceItem).GetAttributeInfos();
foreach (var ai in attrInfos)
    Console.WriteLine($"{ai.Name} — {ai.AccessMode}");
```

---

## API Reference (V21)

## 🛠️ Siemens.Engineering.HW.Features.CertificateManagementConfiguration
>
> Service for PLC dynamic certificate configurations

- 🔧 `CertificateSupportedServices`: Composition for CertificateSupportedServices
- 🔧 `CertificateExpirationEventActivated`: Enable or Disable the Certificate expiration setting of the Certificate Management Configuration .
- 🔧 `RemainingCertificateLifetime`: Get or Set the value for showing event for remaining certificate life time of the Certificate Management Configuration
- 🔧 `Usage`: Gets or sets the Usage of the Certificate Management Configuration . This property allows two options user to choose either certificates configured and download using TIA Portal or certificates provided by certificate management during runtime
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.DisplayProtection
>
> Represents the Display Protection Service

- 📦 `SetPassword(System.Security.SecureString)`: Sets password for display
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.FrontPanelDisplay
>
> Represents the Front Panel Display

- 🔧 `AdaptLogoActivated`: Adapt the logo to the display
- 🔧 `UserDefinedLogoActivated`: Activate or deactivate the User Defined Logo
- 📦 `SetUserDefinedLogo(System.IO.FileInfo)`: Sets the Logo on the Display
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.GsdDevice
>
> Represents a Gsd device

- 🔧 `GsdId`: The Gsd ID of the Gsd object
- 🔧 `GsdName`: The Gsd Name of the Gsd object
- 🔧 `GsdType`: The Gsd Type of the Gsd object
- 🔧 `IsProfibus`: Indicates if this Gsd device item supports Profibus
- 🔧 `IsProfinet`: Indicates if this Gsd object supports Profinet
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.GsdDeviceItem
>
> Represents a Gsd device item

- 🔧 `GsdId`: The Gsd ID of the Gsd object
- 🔧 `GsdName`: The Gsd Name of the Gsd object
- 🔧 `GsdType`: The Gsd Type of the Gsd object
- 🔧 `IsProfibus`: Indicates if this Gsd device item supports Profibus
- 🔧 `IsProfinet`: Indicates if this Gsd object supports Profinet
- 📦 `GetPrmData(System.Int32,System.Int32,System.Int32)`: Returns the Prm Data for this Gsd device item
- 📦 `SetPrmData(System.Int32,System.Int32,System.Collections.Generic.IEnumerable{System.Byte})`: Sets the Prm Data for this Gsd device item
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.PlcAccessControlConfigurationProvider
>
> Represents the Access Control Configuration of the PLC 3.1 onwards

- 🔧 `PlcAccessControlConfiguration`: To set the Access Control Configuration of the PLC
- 🔧 `UmcConnectionState`: To set the UMC connection state user management.
- 🔧 `UmcServerAddress`: To set the UMC server address for central user management
- 🔧 `UmcServerId`: To set the UMC server ID for central user management.
- 🔧 `UmcTrustedCertificateIds`: To set the UMC trusted certificate ID for central user management.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.PlcAccessLevelProvider
>
> Represents the Access level of the PLC Plus

- 🔧 `PlcProtectionAccessLevel`: To set the protection access level type
- 📦 `ResetPassword(Siemens.Engineering.HW.PlcProtectionAccessLevel)`: Reset the password for the specific Access Level Type
- 📦 `SetPassword(Siemens.Engineering.HW.PlcProtectionAccessLevel,System.Security.SecureString)`: set the password for the specific Access Level Type
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.PlcMasterSecretConfigurator
>
> Represents the Master Secret configuration for the PLC

- 🔧 `MasterSecretConfiguration`: Indicates the PLC protection type
- 📦 `ChangePassword(System.Security.SecureString,System.Security.SecureString)`: Change the Master Secret key for the protected PLC
- 📦 `Protect(System.Security.SecureString)`: Protect the PLC with the Master Secret key(password)
- 📦 `ProtectAllPlcConfiguration`: Enable additional protect downloadable configuration data
- 📦 `ProtectAllPlcConfigurationWithPassword(System.Security.SecureString)`: Enable additional protect downloadable configuration data including the PLC protect operation with the Master Secret key(password)
- 📦 `Reset`: Removes PLC configuration data from the TIA Portal project and the PLC
- 📦 `Unprotect`: Unprotects the PLC configuration data from the TIA Portal project and the PLC
- 📦 `Unprotect(System.Security.SecureString)`: Unprotects the PLC configuration data from the TIA Portal project and the PLC
- 📦 `UnprotectAllPlcConfiguration`: Disable additional protect downloadable configuration data
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.SimpleWebserverUserManagement
>
> Represent the webserver usermanagement

- 🔧 `WebserverUsers`: Composition of webserver users
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.WebserverUserManagement
>
> Represent the webserver usermanagement

- 🔧 `WebserverUsers`: Composition of webserver users
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.HardwareCatalog.CatalogEntry
>
> Hardware Catalog Entry

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 🔧 `ArticleNumber`: Article number of hardware object
- 🔧 `CatalogPath`: CatalogPath of item
- 🔧 `Description`: Hardware catalog entry&apos;s description
- 🔧 `TypeIdentifier`: TypeIdentifier of item
- 🔧 `TypeIdentifierNormalized`: Normalized TypeIdentifier of item
- 🔧 `TypeName`: Type name of the device
- 🔧 `Version`: Hardware catalog entry&apos;s version
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.HardwareCatalog.HardwareCatalog
>
> HardwareCatalog related features implemented here

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 📦 `Find(System.String)`: This action finds hardware catalog entries
- 📦 `Find(System.String,System.String)`: This action filter the search result for compatible/pluggable devices filtered for a given TypeIdentifier.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.ForceTableAccessRule
>
> Represents a ForceTableAccessRule object

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Access`: Represents webserver access
- 🔧 `ForceTable`: Represents Plc Force table
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.ForceTableAccessRuleComposition
>
> Composition of ForceTableAccessRule

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.ForceTableAccessRule)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.ForceTableAccessRule)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(Siemens.Engineering.SW.WatchAndForceTables.PlcForceTable,Siemens.Engineering.HW.WatchAndForceTableAccess)`: Creates a ForceTableAccessRule object
- 📦 `Find(Siemens.Engineering.SW.WatchAndForceTables.PlcForceTable)`: Finds a given ForceTableAccessRule by ForceTable
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.WatchAndForceTableAccess
>
> Possible values for WebAccess

## 🛠️ Siemens.Engineering.HW.WatchTableAccessRule
>
> Represents a Watch Table Access Rule

- 📦 `Siemens#Engineering#IEngineeringObject#GetComposition(System.String)`: Gets an <c>IEngineeringCompositionOrObject</c> with the given <paramref name="name"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCompositionInfos`: Gets the list of composition infos available for the object.
- 📦 `GetAttribute(System.String)`: Gets an attribute with the given <paramref name="name"/>.
- 📦 `GetAttributes(System.Collections.Generic.IEnumerable{System.String})`: Gets a list of attributes for the given <paramref name="names"/>.
- 📦 `GetAttributes(Siemens.Engineering.AttributeAccessOptions)`: Gets a list of attribute names/attribute values for the given access options.
- 📦 `GetAttributeInfos`: Returns a collection of EngineeringAttributeInfo objects describing the different attributes on this object.
- 📦 `SetAttribute(System.String,System.Object)`: Sets value of the attribute.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Sets a list of values for the given <paramref name="attributes"/>.
- 📦 `SetAttributes(System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}},Siemens.Engineering.AttributeDelegate)`: Sets the attributes with the given names to the given values as indicated in <paramref name="attributes"/>. Errors will be communicated through <paramref name="errorHandler"/>
- 📦 `Siemens#Engineering#IEngineeringObject#GetInvocationInfos`: Returns a collection of EngineeringInvocationInfo objects describing the different actions on this object.
- 📦 `Siemens#Engineering#IEngineeringObject#Invoke(System.String,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.Type,System.Object}})`: Invokes the method represented by the current instance, using the specified parameters.
- 📦 `Siemens#Engineering#IEngineeringObject#Create(System.String,System.Type,System.Collections.Generic.IEnumerable{System.Collections.Generic.KeyValuePair{System.String,System.Object}})`: Creates an <c>IEngineeringObject</c> of indicated <paramref name="type"/> initialized with values as indicated in <paramref name="compositionName"/> within the <paramref name="parameters"/>.
- 📦 `Siemens#Engineering#IEngineeringObject#GetCreationInfos(System.String)`:
- 🔧 `Parent`: EOM parent of this object
- 🔧 `Access`: Represents web server access
- 🔧 `WatchTable`: Represents Plc WatchTable
- 📦 `Delete`: Deletes this instance.
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.WatchTableAccessRuleComposition
>
> Composition of Watch Table Access

- 📦 `GetEnumerator`: Returns an enumerator that iterates through a collection.
- 📦 `System#Collections#IEnumerable#GetEnumerator`: Returns an enumerator that iterates through a collection.
- 🔧 `Parent`: Gets the parent.
- 🔧 `Count`: Gets the count.
- 🔧 `IsReadOnly`: Gets a value indicating whether this instance is read only.
- 🔧 `Item(System.Int32)`: Gets the element at the specified <paramref name="index"/>.
- 📦 `Any`: Determines if any item is contained within.
- 📦 `Contains(Siemens.Engineering.HW.WatchTableAccessRule)`: Determines if <paramref name="item"/> is contained within.
- 📦 `IndexOf(Siemens.Engineering.HW.WatchTableAccessRule)`: Searches for <paramref name="item"/> and returns the zero-based index of the first occurrence within.
- 📦 `Create(Siemens.Engineering.SW.WatchAndForceTables.PlcWatchTable,Siemens.Engineering.HW.WatchAndForceTableAccess)`: Creates a WatchTableAccessRule
- 📦 `Find(Siemens.Engineering.SW.WatchAndForceTables.PlcWatchTable)`: Finds a given WatchTableAccessRule by PlcWatchTable
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.

## 🛠️ Siemens.Engineering.HW.Features.WatchAndForceTableAccessManager
>
> Represents a Webserver watch And forceTables

- 🔧 `ForcetableAccessRules`: Composition of ForcetableAccess
- 🔧 `WatchtableAccessRules`: Composition of Watch Table Access Rules
- 📦 `Equals(System.Object)`: Determines whether the specified <see cref="T:System.Object"/> is equal to this instance.
- 📦 `GetHashCode`: Returns a hash code for this instance.
- 📦 `ToString`: Returns a <see cref="T:System.String"/> that represents the current <see cref="T:System.Object"/>.
