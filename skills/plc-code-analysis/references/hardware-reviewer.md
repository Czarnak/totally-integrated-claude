# Hardware Reviewer — Analysis Pass 5

## Role

Analyze the PLC hardware configuration for security weaknesses — enabled services,
access settings, communication protocol choices, and protection levels. This pass
examines infrastructure security rather than code logic.

This pass requires hardware configuration data. Sources may include:

- MCP `read_hardware_config` output
- Exported hardware configuration files (AML, HW config screenshots)
- CPU property settings visible in code comments or documentation
- Information embedded in SimaticML XML block attributes

If no hardware configuration data is available from any source, produce the standard
"Hardware configuration not available" INFO finding as defined in SKILL.md and skip
all checks below. Mark any code-only hardware observations as inference-based.

Sources: Siemens S7-1200/S7-1500 system manuals, Top 20 Secure PLC Coding Practices,
CISA ICS advisories, Siemens security configuration guides.

---

## Section 1 — CPU Access Settings

### 1.1 — PUT/GET Remote Access

**Setting:** "Permit access with PUT/GET communication from remote partner"
(CPU Properties → Protection & Security → Connection mechanisms).

**Risk:** This setting enables the local CPU's passive/server-side PUT/GET access
from remote partners. The reachable data and permitted read/write behavior also
depend on CPU family/firmware, access control, the anonymous user's rights, standard
block access, partner configuration, and network reachability. PUT/GET itself does
not provide modern cryptographic peer authentication.

**What to flag:**

- setting enabled: review exposure and justification; do not assign HIGH from the
  checkbox alone
- enabled, reachable from an untrusted zone, and anonymous/equivalent rights permit
  sensitive access: severity HIGH
- a demonstrated unauthenticated write path to a safety/process-critical setpoint:
  severity derived from the reachable process consequence (potentially CRITICAL)

**Remediation:** Disable PUT/GET. Replace with TSEND_C/TRCV_C or OPC UA with
certificate-based authentication. If PUT/GET is required for legacy compatibility,
document the business justification and implement network-level access control.

---

### 1.2 — Access Level Configuration

**Setting:** CPU Protection Level (CPU Properties → Protection & Security → Access level).

V21 has two models that must be distinguished by CPU firmware and configuration:

- S7-1500 up to firmware V3.0 uses password-based access levels.
- From firmware V3.1, local users, roles, and CPU function rights (UMAC) are the
  normal model. Access control must be enabled. Anonymous is disabled by default;
  if activated, its assigned rights define unauthenticated access-level behavior.
- From firmware V4.0, supported S7-1500 configurations can use central UMC-backed
  user management as well.

**What to flag:**

- anonymous user with `Full access` or `Full access including fail-safe` in production
- access control disabled without a documented requirement
- overly broad role/function-right assignments, especially F-admin rights
- legacy access-level/password configuration inconsistent with the exact firmware
- central/local user management configured without its required server/trust evidence

**Remediation:** Apply least-privilege users/roles/function rights for the exact
firmware. Keep anonymous disabled or minimally privileged, protect F-admin rights,
and follow the project's password/central-identity policy.

---

### 1.3 — Know-How Protection and Copy Protection

**What to check:**

- Is know-how protection required by the intellectual-property/threat model?
- Is copy protection required to bind protected blocks to a memory card/CPU?
- Which specific FB/DB/instance DB has `DownloadWithoutReinit` enabled, and is its
  online-change behavior approved for that stateful block?

**What to flag:**

- Missing know-how/copy protection is not automatically a safety vulnerability;
  report only when an explicit protection requirement is unmet
- `DownloadWithoutReinit` enabled on a stateful block without an approved online-change
  and retained-state rationale: contextual severity, tag `HW-DOWNLOAD`

---

## Section 2 — Enabled Services and Attack Surface

### 2.1 — Web Server

**Setting:** CPU Properties → Web server → "Enable web server on this module."

**Risk:** The built-in web server provides diagnostic access but also expands the
attack surface. HTTP (unencrypted) access allows credential sniffing. The web server
may expose process data to unauthorized viewers.

**What to flag:**

- Web server enabled: severity LOW (informational), tag `HW-WEBSERVER`
- Web server enabled with HTTP (not HTTPS-only): severity MEDIUM
- Web server enabled without access control (no user management): severity HIGH
- Web server enabled on an F-CPU: verify justification, users/roles, HTTPS, exposed
  pages, and segmentation; F-CPU status alone does not make it HIGH

**Remediation:** Disable if not required. If required, enforce HTTPS-only, configure
user authentication, restrict to diagnostic VLANs.

---

### 2.2 — SNMP (Simple Network Management Protocol)

**Setting:** SNMP configuration in network interface properties.

**Risk:** The integrated S7 CPU agent uses plaintext community strings when SNMP is
enabled. Current S7-1500 firmware defaults SNMP to disabled, but migrated predecessor
projects can retain enabled/default `public`/`private` behavior. Other Siemens network
modules may support different SNMP versions, including v3; identify the exact device.

**What to flag:**

- plaintext-community SNMP enabled and reachable: contextual severity, tag `HW-SNMP`
- SNMP with default community string ("public"/"private"): severity HIGH
- SNMP write access enabled: severity HIGH

**Remediation:** Disable SNMP if not required. Otherwise change default community
strings, restrict network reachability, minimize write access, and use SNMPv3 only
on the exact module/firmware that supports it; do not prescribe an unsupported upgrade.

---

### 2.3 — Time Synchronization (NTP)

**What to check:**

- Is NTP configured? Unsynchronized PLCs produce unreliable timestamps for logging
  and diagnostics.
- Is NTP using authenticated mode? Unauthenticated NTP can be spoofed to manipulate
  time-based logic.

**What to flag:**

- No time synchronization configured: severity LOW, tag `HW-NTP`
- NTP configured without authentication: severity LOW (if time-based logic exists:
  MEDIUM)

---

### 2.4 — OPC UA Server

**What to check:**

- Is OPC UA enabled? If so, what security policies are configured?
- Certificate-based authentication vs. anonymous access
- Encryption mode (None, Sign, SignAndEncrypt)

**What to flag:**

- OPC UA with anonymous access enabled: severity HIGH, tag `HW-OPCUA`
- OPC UA with security policy "None" (no encryption): severity HIGH
- OPC UA with "Sign" only (no encryption of payload): severity MEDIUM
- OPC UA properly configured with SignAndEncrypt + certificate auth: no finding

---

## Section 3 — Communication Protocol Security

### 3.1 — Profinet Configuration

**What to check:**

- Profinet IO controller/device configuration
- Shared device support (multiple controllers accessing same device)
- Profinet security features (if available in firmware version)

**What to flag:**

- Shared device configuration without clear ownership documentation:
  severity MEDIUM, tag `HW-PROFINET`
- Profinet devices on the same VLAN as office/IT network: severity HIGH

---

### 3.2 — Profibus Configuration

**What to check:**

- Profibus DP master/slave configuration
- Access to Profibus segment from external networks

**What to flag:**

- Profibus master with diagnostic access from unsegmented network:
  severity LOW, tag `HW-PROFIBUS`

---

### 3.3 — Modbus TCP Configuration

**What to check:**

- Is MB_SERVER or MB_CLIENT configured?
- network/firewall allowlisting around the Modbus endpoint (not an invented
  `MB_SERVER` source-IP filter parameter)
- Which holding registers are mapped to the Modbus address space?
- Are safety-critical variables accessible via Modbus?

**What to flag:**

- MB_SERVER reachable from an untrusted zone without an external allowlist:
  severity HIGH, tag `HW-MODBUS`
- Safety-critical variables mapped to Modbus registers: severity CRITICAL
- Modbus TCP on the same network segment as untrusted devices: severity HIGH

Note: Code-level Modbus analysis is also covered in security-practices.md (COMM-MODBUS).
The hardware reviewer focuses on the configuration context.

---

## Section 4 — Network Architecture Assessment

### 4.1 — Network segmentation evidence

**What to check:**

- Are control network and enterprise/IT network separated?
- Is there evidence of DMZ architecture for data exchange?
- Does the cybersecurity zoning match the architecture? PROFIsafe is designed to
  share a standard/"black channel" network; a separate physical safety network is
  not a universal functional-safety requirement.
- Is there firewall or router configuration between zones?

**What to flag:**

- No architecture/segmentation evidence in the supplied artifact: INFO verification
  gap, not proof of a flat network
- A shared safety/standard PROFINET segment is not automatically a finding; assess
  untrusted ingress, zones/conduits, device hardening, and availability requirements
- Direct connection between control network and internet-accessible systems:
  severity CRITICAL

Note: Network architecture may not be fully visible from PLC configuration alone.
Flag as INFO if assessment is limited by available data.

---

### 4.2 — Redundancy and availability

**What to check:**

- Is CPU redundancy configured (H-system)?
- Are communication paths redundant (MRP, MRPD)?
- Is there a standby controller for critical processes?

**What to flag:**

- A safety/availability requirement calls for redundancy but the verified architecture
  lacks it: severity derived from the requirement and failure consequence
- No redundancy requirement or hazard/availability analysis supplied: INFO gap only

---

## Analysis procedure for this pass

1. Identify all available hardware configuration data
2. If no data is available, produce the standard INFO finding and end this pass
3. Work through each section, checking every applicable setting
4. For each finding, distinguish direct configuration evidence from a code-observed
   service/instruction that only creates a hardware verification question
5. When a setting cannot be verified, emit an INFO verification gap; do not promote
   instruction presence into a configuration finding

### Code observations are not configuration evidence

| Code observation | What it justifies checking |
| ------------- | -------------------------- |
| Local PUT/GET instruction | The *partner CPU* must permit the intended remote access; it cannot establish that the local CPU's passive PUT/GET setting is enabled. |
| `MB_SERVER` instance | Intended Modbus server use; it cannot establish current reachability, firewall state, download state, or execution. |
| `TCON` with an external address | Intended connection configuration; it cannot establish a routed/live path. |
| OPC UA-related blocks | Intended OPC UA use; it cannot establish that the CPU's OPC UA server is enabled or reachable. |
| Web-related logic | A web feature dependency; it cannot establish the CPU web-server configuration. |

When hardware configuration is absent, report the missing evidence and the exact
setting to verify. Do not claim that code proves a local CPU service, firewall port,
network path, or downloaded runtime state.
