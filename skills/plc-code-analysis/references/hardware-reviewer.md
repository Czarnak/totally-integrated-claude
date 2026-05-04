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

**Risk:** When enabled, this is a GLOBAL setting — any device on the network that
can reach the PLC can read from or write to any memory area not explicitly protected.
There is no per-connection authentication for PUT/GET.

**What to flag:**

- PUT/GET access enabled: severity HIGH, tag `HW-PUTGET`
- PUT/GET enabled AND no evidence of compensating controls (firewall, VLAN
  segmentation): severity CRITICAL
- PUT/GET enabled AND safety-critical setpoints in accessible memory: severity CRITICAL

**Remediation:** Disable PUT/GET. Replace with TSEND_C/TRCV_C or OPC UA with
certificate-based authentication. If PUT/GET is required for legacy compatibility,
document the business justification and implement network-level access control.

---

### 1.2 — Access Level Configuration

**Setting:** CPU Protection Level (CPU Properties → Protection & Security → Access level).

**Levels (S7-1500):**

- Level 1 — Full access (no protection): Anyone can read and modify
- Level 2 — Read access: Read-only without password, write requires password
- Level 3 — HMI access: Only HMI communication without password, all else requires password
- Level 4 — No access: All access requires password

**What to flag:**

- Access level 1 (full access) on production CPUs: severity HIGH, tag `HW-ACCESS-LEVEL`
- Access level 1 or 2 on safety CPUs: severity CRITICAL
- No password configured for protected access levels: severity HIGH
- Weak or default passwords (if detectable from config): severity CRITICAL

**Remediation:** Set access level 3 or 4 for production systems. Configure strong
passwords. Use individual user management (UMAC) where supported.

---

### 1.3 — Know-How Protection and Copy Protection

**What to check:**

- Are safety-critical blocks know-how protected?
- Is copy protection enabled (binds program to specific MMC/CPU serial)?
- Are blocks compiled with "Permit download without reinitialization" (allows online
  changes that skip initialization — risky for production)?

**What to flag:**

- Safety blocks without know-how protection: severity MEDIUM, tag `HW-KNOWHOW`
- No copy protection on production firmware: severity LOW, tag `HW-COPY-PROTECT`
- "Download without reinitialization" enabled globally: severity MEDIUM, tag `HW-DOWNLOAD`

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
- Web server enabled on safety CPU without documented justification: severity HIGH

**Remediation:** Disable if not required. If required, enforce HTTPS-only, configure
user authentication, restrict to diagnostic VLANs.

---

### 2.2 — SNMP (Simple Network Management Protocol)

**Setting:** SNMP configuration in network interface properties.

**Risk:** SNMP v1/v2c uses community strings (effectively cleartext passwords) for
device management. An attacker with SNMP write access can modify network settings.

**What to flag:**

- SNMP v1/v2c enabled: severity MEDIUM, tag `HW-SNMP`
- SNMP with default community string ("public"/"private"): severity HIGH
- SNMP write access enabled: severity HIGH

**Remediation:** Upgrade to SNMPv3 with authentication and encryption. Change default
community strings. Disable SNMP write access if not required.

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
- IP address filtering in MB_SERVER parameters
- Which holding registers are mapped to the Modbus address space?
- Are safety-critical variables accessible via Modbus?

**What to flag:**

- MB_SERVER without IP filtering: severity HIGH, tag `HW-MODBUS`
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
- Are safety networks isolated from standard control networks?
- Is there firewall or router configuration between zones?

**What to flag:**

- No evidence of network segmentation: severity HIGH, tag `HW-SEGMENTATION`
- Safety and standard control on the same flat network: severity HIGH
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

- Safety-critical process without redundant communication paths:
  severity MEDIUM, tag `HW-REDUNDANCY`
- No CPU redundancy for continuous process with high availability requirements:
  severity LOW (recommendation)

---

## Analysis procedure for this pass

1. Identify all available hardware configuration data
2. If no data is available, produce the standard INFO finding and end this pass
3. Work through each section, checking every applicable setting
4. For each finding, note whether the assessment is based on direct evidence from
   configuration data or inferred from code patterns (e.g., PUT/GET instructions
   in code imply PUT/GET is enabled on the CPU)
5. When hardware settings cannot be directly verified, flag as "inferred" and
   recommend explicit verification

### Inference rules (when only code is available)

Even without explicit hardware configuration, some settings can be inferred:

| Code pattern | Inferred hardware setting |
| ------------- | -------------------------- |
| PUT/GET instructions in code | PUT/GET access enabled on CPU |
| MB_SERVER block instances | Modbus TCP enabled, firewall port open |
| TCON with external IPs | Network connectivity to external systems |
| OPC UA client/server blocks | OPC UA server enabled |
| Web-related instructions | Web server potentially enabled |

Flag inferred findings with the note: "Inferred from code — verify against actual
CPU configuration."
