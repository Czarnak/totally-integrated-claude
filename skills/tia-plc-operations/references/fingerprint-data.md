# Quick-station fingerprint data (TIA Portal V21)

Use this reference for the V21 `FingerprintDataProvider` quick-station-compare
workflow. The provider is acquired from `TiaPortal`, but its target and callback
semantics are PLC online operations.

Source: Siemens V21, [Accessing fingerprint for quick station compare](https://docs.tia.siemens.cloud/r/en-us/v21/tia-portal-openness-api-for-automation-of-engineering-workflows/tia-portal-openness-api/functions-for-accessing-the-data-of-a-plc-device/functions-for-accessing-plc-service/accessing-fingerprint-for-quick-station-compare?contentId=KynDsDm9COhsdQPzFqPEjQ), checked against the installed
`Siemens.Engineering.Base.dll` and XML documentation.

## Preconditions and safety boundary

- The TIA Portal session and project are open, and the PLC is offline from the
  project session as required by the Siemens workflow.
- Resolve the exact PC interface and target address; never select the first
  available interface or reuse an address from another provider configuration.
- Obtain explicit authorization for network access to that target, including
  any credential or TLS decision.
- Handle every online callback shape deliberately and fail closed on an unknown
  configuration.
- Fingerprint retrieval does not write PLC configuration, but it is live access
  to a real target and may disclose configuration-derived identifiers. Protect
  stored values and provenance accordingly.

## Provider, address, and retrieval

```csharp
using Siemens.Engineering;
using Siemens.Engineering.Connection;
using Siemens.Engineering.FingerprintData;
using Siemens.Engineering.Online;
using Siemens.Engineering.Online.Configurations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security;

FingerprintDataProvider provider =
    tiaPortal.GetService<FingerprintDataProvider>();
if (provider == null)
    throw new InvalidOperationException("Fingerprint service is unavailable.");

ConnectionConfiguration configuration = provider.Configuration;
ConfigurationMode mode = configuration.Modes.Find("PN/IE");
ConfigurationPcInterface pcInterface =
    mode?.PcInterfaces.Find(approvedInterfaceName, approvedInterfaceNumber);
ConfigurationAddress address =
    pcInterface?.Addresses.Create(approvedTargetAddress);

if (address == null)
    throw new InvalidOperationException("Approved fingerprint target was not resolved.");

FingerprintDataResult result =
    provider.GetFingerprintData(address, ConfigureOnline);

Dictionary<string, string> values = result.FingerprintDataItems
    .ToDictionary(
        item => item.FingerprintDataIdentifier,
        item => item.FingerprintDataValue,
        StringComparer.Ordinal);
```

The `ConfigurationAddress` must be created from
`FingerprintDataProvider.Configuration`; do not pass an address object owned by
another provider.

## Callback handling

`GetFingerprintData(ConfigurationAddress, OnlineConfigurationDelegate)` invokes
the callback for password, authentication, or TLS decisions. Reuse the
certificate-pinning rules from `online-status.md`.

```csharp
private static void ConfigureOnline(OnlineConfiguration configuration)
{
    OnlineReadAccessPassword readPassword =
        configuration as OnlineReadAccessPassword;
    if (readPassword != null)
    {
        using (SecureString secret = GetApprovedReadPassword())
            readPassword.SetPassword(secret);
        return;
    }

    TlsVerificationConfiguration tls =
        configuration as TlsVerificationConfiguration;
    if (tls != null && VerifyApprovedPlcNameAndCertificates(
            tls.PlcName, tls.VerificationInfo, tls.Certificates))
    {
        tls.CurrentSelection =
            TlsVerificationConfigurationSelection.Trusted;
        return;
    }

    if (tls != null)
        tls.CurrentSelection =
            TlsVerificationConfigurationSelection.NonTrusted;

    throw new NotSupportedException(
        "Fingerprint retrieval aborted: unhandled or untrusted online configuration.");
}
```

Never embed a password or accept a certificate solely because the target
presented it. The helper methods above represent application-owned secret
retrieval and target-bound certificate verification, not permissive defaults.
An exception in the delegate cancels retrieval and is surfaced through the
Openness exception boundary.

## Comparison and evidence

Compare the complete identifier set as well as every value. Missing identifiers,
new identifiers, duplicates, callback warnings, a changed interface/address, or
a changed certificate identity make the comparison inconclusive until reviewed.

Fingerprint equality is a quick-change signal, not a full station comparison,
compile result, security attestation, or proof that PLC logic is safe. Record at
least TIA/API version, project identity, target address/interface, certificate
identity, UTC retrieval time, and the ordered identifier/value set. Use a safe,
versioned data format; do not copy the legacy binary-serialization helper from
documentation examples into an untrusted-data workflow.

## Installed V21 public type catalogue

These headings cover all four installed public types in
`Siemens.Engineering.FingerprintData`.

## 🛠️ Siemens.Engineering.FingerprintData.FingerprintDataItem

One `FingerprintDataIdentifier`/`FingerprintDataValue` pair.

## 🛠️ Siemens.Engineering.FingerprintData.FingerprintDataItemComposition

Read-only fingerprint-item collection.

## 🛠️ Siemens.Engineering.FingerprintData.FingerprintDataProvider

Portal service exposing `Configuration` and `GetFingerprintData`.

## 🛠️ Siemens.Engineering.FingerprintData.FingerprintDataResult

Retrieval result exposing `FingerprintDataItems`.
