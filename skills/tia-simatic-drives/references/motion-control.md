# Startdrive Motion Control and Drives API Reference

Comprehensive reference for the `Siemens.Engineering.MC` namespaces in TIA Portal V21.

---

## 1. Siemens.Engineering.MC.Drives

Core drive object model and services.

### DriveObject

- `DriveObjectNumber`: Numeric identifier of the drive object.
- `Parameters`: Offline parameter access.
- `ReadParameters`: Offline read-only parameter access.
- `Telegrams`: Telegram configuration.
- `GetService<T>()`: Access services like `TechnologyExtensionContainer`, `SafetyAcceptanceTestProvider`, `DriveFunctionInterface`.

### DriveParameter

- `Name`, `Number`, `Value`, `Unit`.
- `MinValue`, `MaxValue`, `ParameterText`.
- `EnumValueList`: List of valid labels for enum parameters.

### OnlineDriveObject

- `ReadParameters`: Online live parameter access.
- `GetService<OnlineDriveFunctionInterface>()`: Access online-only drive functions.

### Telegram

- `TelegramNumber`, `Type`.
- `GetSize(AddressIoType)`, `GetSizeInBytes(AddressIoType)`.
- `CanChangeTelegram(int number)`, `ChangeTelegram(int number)`.

### TechnologyExtension

- `Name`, `DisplayName`, `Identifier`, `IsActivated`.
- `Parameters`: Extension-specific parameters.
- `Activate()`, `Deactivate()`.

---

## 2. Siemens.Engineering.MC.Drives.DFI

Drive Function Interface for commissioning and hardware projection.

### DriveFunctionInterface

- `Commissioning`: Siemens motor and SIMOGEAR configuration.
- `HardwareProjection`: Motor and encoder configuration.
- `DriveObjectFunctions`: Type management and activation.
- `FunctionInUse`: EPOS and PID activation.
- `SafetyCommissioning`: CRC update functions.

### HardwareProjection

- `SetMotorType(MotorType, ushort ddsNumber)`
- `SetEncoder(EncoderInterface, EncoderType, ...)`
- `ProjectMotorConfiguration(MotorConfiguration, ushort ddsNumber)`
- `ProjectEncoderConfiguration(EncoderConfiguration, ushort encoderNumber)`

### DriveObjectTypeHandler

- `CurrentDriveObjectType`
- `PossibleDriveObjectTypes`
- `ChangeDriveObjectType(DriveObjectType targetType)`

### DriveObjectActivation

- `IsActive`, `ActivationState`.
- `ChangeActivationState(DriveObjectActivationState state)`

---

## 3. Siemens.Engineering.MC.Drives.SecurityObjects

Drive-specific security features.

### DriveDataEncryption

- `Activate(SecureString password)`
- `Deactivate(SecureString password)`

### UmacConfiguration

- `Activate()`, `Deactivate()`

---

## 4. Enums Reference

| Enum | Key Values |
| --- | --- |
| `DriveObjectActivationState` | `Activate`, `Deactivate`, `DeactivateAndNotPresent` |
| `TelegramType` | `MainTelegram`, `SupplementaryTelegram`, `AdditionalTelegram`, `SafetyTelegram`, `TorqueTelegram` |
| `MotorType` | `InductionMotor`, `SynchronousMotor`, `DriveCliqMotor` |
| `EncoderType` | `Resolver`, `HTLTTL`, `SSIProtocoll`, `DriveCliQ` |
| `EncoderInterface` | `None`, `Terminal`, `DSub`, `DriveCliQ` |
| `FunctionKeys` | `BasicPositioner`, `TechnologyController` |
| `ResetMode` | `ParameterReset`, `SafetyParameterReset` |
