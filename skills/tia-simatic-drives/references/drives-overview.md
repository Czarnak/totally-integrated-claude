# Drives API Reference

Source: V21 IntelliSense XML documentation — `Siemens.Engineering.Startdrive.xml`

> C# only. Assembly: `Siemens.Engineering.Startdrive.dll`
> Namespace: `Siemens.Engineering.MC.Drives` (+ `.DFI`, `.Enums`, `.SecurityObjects`)
> Startdrive also extends `Siemens.Engineering.Download.Configurations` and
> `Siemens.Engineering.Upload.Configurations` with drive-specific check configurations.

---

## 1. Navigation — Device to DriveObject

Drive objects are accessed via a `DriveObjectContainer` service on the drive device item.
The container exposes a `DriveObjects` composition.

```csharp
using Siemens.Engineering.HW;
using Siemens.Engineering.HW.Features;
using Siemens.Engineering.MC.Drives;

// Find the drive device
Device driveDevice = project.Devices.Find("Drive_1");

// Get the DriveObjectContainer from the appropriate DeviceItem
foreach (DeviceItem item in driveDevice.DeviceItems)
{
    var container = item.GetService<DriveObjectContainer>();
    if (container != null)
    {
        foreach (DriveObject driveObj in container.DriveObjects)
        {
            Console.WriteLine($"DriveObject #{driveObj.DriveObjectNumber}");
        }
        break;
    }
}
```

For drive controllers with an integrated PLC, the CPU device item also exposes
`SoftwareContainer` — access `PlcSoftware` normally for the programming side:

```csharp
var sc = cpuItem.GetService<SoftwareContainer>();
PlcSoftware plcSw = sc?.Software as PlcSoftware;
// Standard PLC operations apply — see tia-plc-operations
```

---

## 2. Drive parameters

### Offline parameters

`DriveObject.Parameters` provides read-write access. `DriveObject.ReadParameters`
provides read-only access (returns `ReadDriveParameter` objects).

```csharp
DriveParameterComposition parameters = driveObj.Parameters;

// Find by name (e.g. "p100" for rated motor voltage)
DriveParameter param = parameters.Find("p100");
Console.WriteLine($"{param.Name}: {param.Value} {param.Unit}");
Console.WriteLine($"  Range: {param.MinValue} – {param.MaxValue}");
Console.WriteLine($"  Description: {param.ParameterText}");

// Find by numeric identifiers (parameter number, array index)
DriveParameter paramByNum = parameters.Find(100, 0);

// Write a parameter value
param.Value = 400;

// Enumerate all parameters
foreach (DriveParameter p in parameters)
{
    Console.WriteLine($"{p.Name} [{p.Number}] = {p.Value} {p.Unit}");
}
```

### DriveParameter properties

| Property | Type | Description |
| --- | --- | --- |
| `Name` | string | Parameter name (e.g. "p100") |
| `Number` | int | Numeric representation |
| `Value` | object | Current value (read-write on `DriveParameter`, read-only on `ReadDriveParameter`) |
| `Unit` | string | Engineering unit |
| `MinValue` | object | Minimum allowed value |
| `MaxValue` | object | Maximum allowed value |
| `ParameterText` | string | Description text |
| `EnumValueList` | list | Possible labels for enum parameters |
| `ArrayIndex` | int | Index if this is an array element |
| `ArrayLength` | int | Number of array elements (on parent only) |
| `Bits` | — | Bit-level access to the parameter value |

### Online parameters

Access online (live) parameters via `OnlineDriveObject`:

```csharp
var onlineContainer = deviceItem.GetService<OnlineDriveObjectContainer>();
if (onlineContainer != null)
{
    foreach (OnlineDriveObject onlineDriveObj in onlineContainer.OnlineDriveObjects)
    {
        ReadDriveParameterComposition onlineParams = onlineDriveObj.ReadParameters;
        ReadDriveParameter r100 = onlineParams.Find("r100");
        Console.WriteLine($"Online {r100.Name} = {r100.Value}");
    }
}
```

Online parameters are read-only (`ReadDriveParameter`). For write access, use the
offline `DriveObject.Parameters` and download.

---

## 3. Telegrams

Telegrams define the cyclic communication between PLC and drive.

```csharp
TelegramComposition telegrams = driveObj.Telegrams;

foreach (Telegram telegram in telegrams)
{
    Console.WriteLine($"Telegram #{telegram.TelegramNumber}, Type: {telegram.Type}");

    // Get I/O sizes
    int inputSize = telegram.GetSize(AddressIoType.Input);
    int outputSize = telegram.GetSize(AddressIoType.Output);
    int inputBytes = telegram.GetSizeInBytes(AddressIoType.Input);
    Console.WriteLine($"  Input: {inputSize} bits ({inputBytes} bytes)");
    Console.WriteLine($"  Output: {outputSize} bits");

    // Check if telegram can be changed
    if (telegram.CanChangeTelegram(1))
    {
        // Can switch to standard telegram 1
    }

    // Change telegram size
    if (telegram.CanChangeSize(AddressIoType.Input, 10, false))
    {
        telegram.ChangeSize(AddressIoType.Input, 10, false);
    }
}
```

### Finding, inserting, and erasing telegrams

`TelegramComposition` exposes typed helpers. Prefer the `Can*` method before
mutating the configuration.

```csharp
Telegram main = telegrams.Find(TelegramType.MainTelegram);

if (telegrams.CanInsertMainTelegram(1))
{
    telegrams.InsertMainTelegram(1);
}

if (telegrams.CanInsertSupplementaryTelegram(750))
{
    telegrams.InsertSupplementaryTelegram(750);
}

if (telegrams.CanInsertAdditionalTelegram(inputSize: 4, outputSize: 4))
{
    telegrams.InsertAdditionalTelegram(4, 4);
}

if (telegrams.CanInsertSafetyTelegram(30))
{
    telegrams.InsertSafetyTelegram(30);
}

// Removes the telegram of that type if supported by the drive object.
telegrams.EraseTelegram(TelegramType.SupplementaryTelegram);
```

Available composition operations include `CanInsertTelegram(number, type)`,
`InsertTelegram(number, type)`, type-specific helpers for main, supplementary,
additional, safety, and torque telegrams, plus `Find(TelegramType)`.

### Telegram types (`TelegramType` enum)

| Value | Description |
| --- | --- |
| `MainTelegram` | Primary process data telegram |
| `SupplementaryTelegram` | Additional process data |
| `AdditionalTelegram` | Extended telegram |
| `SafetyTelegram` | Safety-related telegram |
| `TorqueTelegram` | Torque-specific telegram |
| `EdgeTelegram` | Edge-specific telegram |

### Telegram properties

| Property | Description |
| --- | --- |
| `TelegramNumber` | Telegram identifier |
| `Type` | `TelegramType` enum value |
| `Addresses` | I/O address assignments |
| `HwIdentifiers` | Hardware identifiers |
| `PKW` | PKW relevant ActualValue channel |

---

## 4. Technology extensions

Manage technology extension packages (e.g. VIBX, positioning functions):

```csharp
// Get TechnologyExtensionContainer via GetService on the drive object
var teContainer = driveObj.GetService<TechnologyExtensionContainer>();

// Enumerate installed technology extensions
foreach (TechnologyExtension te in teContainer.TechnologyExtensions)
{
    Console.WriteLine($"{te.Name} ({te.DisplayName}) — Active: {te.IsActivated}");
    Console.WriteLine($"  Identifier: {te.Identifier}");

    // Read extension-specific parameters
    foreach (DriveParameter p in te.Parameters)
        Console.WriteLine($"  {p.Name} = {p.Value}");
}

// Activate / deactivate
TechnologyExtension vibx = teContainer.TechnologyExtensions.Find("VIBX");
vibx?.Activate();
vibx?.Deactivate();
```

### Installing extension packages

```csharp
var installer = driveObj.GetService<TechnologyExtensionInstallationProvider>();

// Install a package file
string pkgId = installer.InstallAndGetIdentifier(
    new FileInfo(@"C:\Packages\VIBX_V13SP1HF3.tep"));

// List installed packages
foreach (TechnologyExtensionPackage pkg in installer.TechnologyExtensionPackages)
    Console.WriteLine($"Package: {pkg.Name} ({pkg.Identifier})");

// Uninstall (force = true to remove even if in use)
installer.Uninstall(pkgId, true);
```

---

## 5. Drive Function Interface (DFI)

DFI provides commissioning, motor/encoder configuration, and domain functions.
Access via `GetService<DriveFunctionInterface>()` on `DriveObject`.

```csharp
using Siemens.Engineering.MC.Drives.DFI;
using Siemens.Engineering.MC.Drives.Enums;

var dfi = driveObj.GetService<DriveFunctionInterface>();
```

### Commissioning

```csharp
Commissioning comm = dfi.Commissioning;

// Set Siemens motor by code number for a motor data set.
bool motorCodeApplied = comm.SetMotorCode(motorCodeNumber, motorDataSetNumber);

// Configure a SIMOGEAR mounted device by MLFB.
comm.SetSimoGearMlfb(mlfb);
```

### Motor and encoder configuration

```csharp
HardwareProjection hwProj = dfi.HardwareProjection;

ushort driveDataSetNumber = 1;
ushort encoderNumber = 1;

// Fast path: set a known motor type directly.
bool motorTypeApplied = hwProj.SetMotorType(
    MotorType.InductionMotor,
    driveDataSetNumber);

// Non-Siemens motor path: edit the current configuration, then project it.
MotorConfiguration motorCfg =
    hwProj.GetCurrentMotorConfiguration(driveDataSetNumber);

foreach (ConfigurationEntry entry in motorCfg.RequiredConfigurationEntries)
{
    Console.WriteLine($"Required: {entry.Name} = {entry.Value} ({entry.Unit})");
}

foreach (ConfigurationEntry entry in motorCfg.OptionalConfigurationEntries)
{
    Console.WriteLine($"Optional: {entry.Name}");
}

if (motorCfg.CanSetEquivalentCircuitDiagramData())
{
    motorCfg.SetEquivalentCircuitDiagramData(true);
}

bool motorProjected =
    hwProj.ProjectMotorConfiguration(motorCfg, driveDataSetNumber);

// Encoder path: either set directly or project an edited configuration.
bool encoderApplied = hwProj.SetEncoder(
    EncoderInterface.DriveCliQ,
    EncoderType.DriveCliQ,
    AbsoluteIncrementalFlag.Absolute,
    RotaryLinearFlag.Rotary,
    encoderNumber);

EncoderConfiguration encCfg =
    hwProj.GetCurrentEncoderConfiguration(encoderNumber);

encCfg.SetEncoderType(RotaryLinearFlag.Rotary, AbsoluteIncrementalFlag.Absolute);

bool encoderProjected =
    hwProj.ProjectEncoderConfiguration(encCfg, encoderNumber);
```

### Drive object type management

```csharp
DriveObjectFunctions funcs = dfi.DriveObjectFunctions;
DriveObjectTypeHandler typeHandler = funcs.DriveObjectTypeHandler;

// Get current type
DriveObjectType currentType = typeHandler.CurrentDriveObjectType;
Console.WriteLine($"Current type: {currentType.Name} ({currentType.Number})");

// List possible types and change
foreach (DriveObjectType possibleType in typeHandler.PossibleDriveObjectTypes)
    Console.WriteLine($"  Possible: {possibleType.Name}");

bool changed = typeHandler.ChangeDriveObjectType(targetType);
```

### Drive object activation

```csharp
DriveObjectActivation activation = funcs.DriveObjectActivation;
Console.WriteLine($"Active: {activation.IsActive}, State: {activation.ActivationState}");

activation.ChangeActivationState(DriveObjectActivationState.Activate);
activation.ChangeActivationState(DriveObjectActivationState.Deactivate);
```

### Factory reset and RAM-to-ROM

```csharp
// Online DFI for domain-level functions
var onlineDfi = onlineDriveObj.GetService<OnlineDriveFunctionInterface>();
DriveDomainFunctions domainFuncs = onlineDfi.DriveDomainFunctions;

// Factory reset
domainFuncs.PerformFactoryReset(ResetMode.ParameterReset);
domainFuncs.PerformFactoryReset(ResetMode.SafetyParameterReset);

// RAM to ROM copy (all drive objects)
domainFuncs.PerformRAMtoROMCopyAllDriveObject();
```

### Functions in Use (FIU)

```csharp
FunctionInUse fiu = dfi.FunctionInUse;

// Activate/deactivate functions
fiu.Activate(FunctionKeys.BasicPositioner);       // EPOS
fiu.Activate(FunctionKeys.TechnologyController);  // PID
fiu.Deactivate(FunctionKeys.BasicPositioner);

// Configure axis interpretation for SI-related workflows.
fiu.SetSIAxisType(RotaryLinearFlag.Rotary);
```

---

## 6. Safety

### Safety acceptance test

```csharp
var safetyProvider = driveObj.GetService<SafetyAcceptanceTestProvider>();

// Get test functions
foreach (TestFunction test in safetyProvider.TestFunctions)
    Console.WriteLine($"Test: {test}");

// Reset test selections and results
safetyProvider.ResetTestFunctions();

// Generate safety acceptance test report
var report = driveObj.GetService<SafetyAcceptanceTestReport>();
report?.CreateProtocol(
    new FileInfo(@"C:\Reports\SafetyTest.pdf"),
    FileOperations.Overwrite);
```

### Safety commissioning (CRC)

```csharp
SafetyCommissioning safetyCrc = dfi.SafetyCommissioning;
safetyCrc.UpdateCheckSums(); // CRC calculation for all 3rd Gen drives
```

---

## 7. Security

### Drive data encryption

```csharp
using Siemens.Engineering.MC.Drives.SecurityObjects;
using System.Security;

Security security = driveObj.Security.First(); // from SecurityComposition

DriveDataEncryption dde = security.DriveDataEncryption;

// Activate/deactivate encryption (requires SecureString password)
var password = new SecureString();
foreach (char c in "MyDrivePassword") password.AppendChar(c);
password.MakeReadOnly();

dde.Activate(password);
dde.Deactivate(password);
```

### Drive UMAC

```csharp
UmacConfiguration umac = security.UmacConfiguration;
umac.Activate();
umac.Deactivate();
```

---

## 8. Hardware module information

```csharp
var hwModule = deviceItem.GetService<DriveItemHardwareModule>();
if (hwModule != null)
{
    Console.WriteLine($"Component: {hwModule.ComponentName}");
    Console.WriteLine($"Position: {hwModule.PositionNumber}");
    Console.WriteLine($"TypeId: {hwModule.TypeIdentifier}");
    Console.WriteLine($"TypeName: {hwModule.TypeName}");

    // Change module type
    hwModule.ChangeType("newTypeIdentifier");
}

var map = deviceItem.GetService<ModuleAccessPoint>();
if (map != null)
{
    foreach (HwIdentifier identifier in map.HwIdentifiers)
    {
        Console.WriteLine($"HW identifier: {identifier.Identifier}");
    }
}
```

### Drive terminal assignment enums

The base hardware API also exposes drive-specific terminal enum values for
integrated properties named like `DriveEnableOutput` and `DriveReadyInput`.

```csharp
deviceItem.SetAttribute("DriveEnableOutput", DriveEnableOutput.X11Clamp21);
deviceItem.SetAttribute("DriveReadyInput", DriveReadyInput.X11Clamp1);
```

`DriveEnableOutput` values include `None`, `X11Clamp21` through `X11Clamp28`,
`X11Clamp31` through `X11Clamp38`, corresponding `X12Clamp*` values, `Dq0`,
and `Diq2`.

`DriveReadyInput` values include `None`, `X11Clamp1` through `X11Clamp18`,
corresponding `X12Clamp*` values, `Di0`, `Di1`, and `Diq2`.

---

## 9. Download and upload check configurations

Startdrive adds drive-specific configuration objects to the common download and
upload workflows.

```csharp
using Siemens.Engineering.Download.Configurations;
using Siemens.Engineering.Upload.Configurations;

// Startdrive download check configuration marker types.
// They are used by the common download configuration workflow when a drive
// download reports Startdrive-specific checks.
Type sensitiveDataCheck = typeof(AcceptDownloadOfUnencryptedSensitiveData);
Type replaceDataCheck = typeof(ReplaceDownloadedData);
Type startdriveCheck = typeof(StartDriveDownloadCheckConfiguration);

// Startdrive upload check configuration objects expose Checked.
OverrideTelegramMismatch telegramMismatch = null;
OverwriteOfflineConfiguration offlineMismatch = null;

if (telegramMismatch != null)
{
    telegramMismatch.Checked = true;
}

if (offlineMismatch != null)
{
    offlineMismatch.Checked = true;
}
```

Use these only inside the normal `DownloadProvider` / `UploadProvider`
configuration flow. `OverrideTelegramMismatch.Checked = true` allows upload to
proceed despite telegram configuration mismatch; `OverwriteOfflineConfiguration`
allows upload to overwrite the offline device configuration mismatch.

See `references/download.md` for a comprehensive list of Startdrive-specific
and common configuration marker types.

---

## 10. Enums reference

### DriveObjectActivationState

`Activate`, `Deactivate`, `DeactivateAndNotPresent`

### TelegramType

`MainTelegram`, `SupplementaryTelegram`, `AdditionalTelegram`, `SafetyTelegram`, `TorqueTelegram`, `EdgeTelegram`

### ResetMode

`ParameterReset`, `SafetyParameterReset`

### FunctionKeys

`BasicPositioner` (EPOS), `TechnologyController` (PID)

### FileOperations

`None` (no overwrite), `Overwrite` (overwrite existing report)

### MotorType

`NoMotor`, `InductionMotor`, `SynchronousMotor`, `DriveCliqMotor`, `DriveCliqMotorDataSet`, plus Siemens-specific motor series (1LE1, 1PH7, 1PH8, 1FK7, etc.)

### EncoderType

`NoEncoder`, `Resolver`, `HTLTTL`, `SSIProtocoll`, `SinCos`, `EnDat`, `HTL`, `DriveCliQ`, plus combinations

### EncoderInterface

`None`, `Terminal`, `DSub`, `DriveCliQ`, `HTL`, `SSI`

### RotaryLinearFlag

`Rotary`, `Linear`

### AbsoluteIncrementalFlag

`Absolute`, `Incremental`
