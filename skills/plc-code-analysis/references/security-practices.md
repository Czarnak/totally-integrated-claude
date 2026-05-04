# Security Practices — Analysis Pass 2

## Role

Evaluate the code against the Top 20 Secure PLC Coding Practices and communication
security standards. Focus on defensive coding: does the code protect itself against
invalid inputs, unauthorized modifications, and unsafe communication patterns?

Source: "Top 20 Secure PLC Coding Practices" (plc-security.com), industry consensus
from ICS security community.

---

## Top 20 Secure PLC Coding Practices Checklist

For each practice, the checklist defines: what to look for, what compliance looks like,
what violation looks like, and the default severity.

### Practice #1 — Modularize PLC Code

**Look for:** Monolithic blocks with hundreds of networks doing everything. Long blocks
that mix unrelated functionality (e.g., pump control + alarm management + recipe handling
in a single FB).

**Compliant:** Functionality separated into purpose-specific FBs/FCs with clear interfaces.
Each block has a single well-defined responsibility.

**Violation:** Single blocks exceeding ~200 networks or mixing three or more unrelated
functions. God-blocks that are impossible to audit meaningfully.

**Severity:** LOW — code quality issue, but large blocks obscure vulnerabilities.
**Tag:** `TOP20-P01`

---

### Practice #2 — Track Operating Modes

**Look for:** State variables, mode selectors, enumerated operating states.

**Compliant:** Explicit state machine with defined transitions. Mode variable is
protected against arbitrary writes. All outputs are governed by current mode.

**Violation:** No explicit mode tracking. Outputs controlled without reference to
operating state. Mode variable writable from external sources without validation.

**Severity:** MEDIUM
**Tag:** `TOP20-P02`

---

### Practice #3 — Leave Operational Logic in the PLC

**Look for:** Logic that relies on HMI polling, totalizing calculations outside the
PLC scan cycle, interlocks evaluated only at SCADA layer.

**Compliant:** All control decisions, interlocks, sequencing, and accumulation logic
executes in the PLC regardless of HMI availability.

**Violation:** HMI-dependent control logic, integration performed at HMI scan rate,
interlock conditions that fail-open when HMI communication drops.

**Severity:** HIGH
**Tag:** `TOP20-P03`

Note: Detailed patterns also covered in Process Architect pass (Step 5).

---

### Practice #4 — Use PLC Flags for Runtime Changes

**Look for:** Mechanisms to detect when PLC logic or configuration has been modified
at runtime.

**Compliant:** Checksums or hash values computed over critical logic blocks and compared
against stored baselines. PLC flags monitored for unauthorized state changes.

**Violation:** No runtime integrity monitoring. Changes to block content or mode state
go undetected.

**Severity:** MEDIUM
**Tag:** `TOP20-P04`

---

### Practice #5 — Use Cryptographic and/or Checksum Integrity for PLC Code

**Look for:** Integrity verification of PLC logic beyond basic runtime flags.

**Compliant:** Checksum computation over safety-critical blocks with comparison to
known-good values. Discrepancy triggers alarm or controlled shutdown.

**Violation:** No checksum or integrity check on logic blocks. Modification of control
logic would go unnoticed until process deviation occurs.

**Severity:** MEDIUM (safety-critical processes: HIGH)
**Tag:** `TOP20-P05`

---

### Practice #6 — Restrict Third-Party Data Block Access

**Look for:** Data blocks that allow unrestricted read/write from external devices.
HMI interface DBs that contain both operator-writable and safety-critical variables.

**Compliant:** Interface DBs have clear separation between "writable from HMI" and
"internal PLC use only" sections. Write access is restricted by access control lists
or architectural separation.

**Violation:** DBs containing safety-critical variables (setpoints, interlock overrides)
are fully exposed to external partners via PUT/GET or HMI direct access.

**Severity:** HIGH
**Tag:** `TOP20-P06`

---

### Practice #7 — Restrict the Use of Dynamic and Online Changes

**Look for:** Logic that facilitates online changes without safeguards. Force tables
left active. Blocks compiled with "Permit download without reinitialization" for
production systems.

**Compliant:** Online change procedures documented and controlled. Force tables
cleared after maintenance. Download behavior configured appropriately.

**Violation:** Evidence of persistent force operations (forced I/O). Blocks structured
to accept online patches without validation.

**Severity:** MEDIUM
**Tag:** `TOP20-P07`

---

### Practice #8 — Validate HMI Input Variables at PLC Level

**This is the most frequently violated practice and the highest priority check.**

**Look for:** Every `VAR_INPUT` or `VAR_IN_OUT` that receives values from an HMI or
external source. Check if there is a range check (MIN/MAX comparison) BEFORE the value
is used in control logic.

**Compliant pattern in SCL:**

```scl
IF (HMI_Setpoint >= MIN_ALLOWED) AND (HMI_Setpoint <= MAX_ALLOWED) THEN
    Active_Setpoint := HMI_Setpoint;
ELSE
    Active_Setpoint := SAFE_DEFAULT;
    // Alarm or log the out-of-range attempt
END_IF;
```

**Violation indicators:**

- Direct assignment: `Motor_Speed := HMI_SpeedRef;` without range check
- Setpoint used in calculation without validation: `Flow_Rate := HMI_Factor * Base_Flow;`
- Array index from external source without bounds check
- Type conversion from external source without overflow check

**In LAD/FBD (XML):** Look for direct wires from input parameters to actuator function
blocks without intervening comparison/limit blocks (LIMIT, MIN, MAX, or compare contacts).

**Severity:** HIGH (safety-critical actuators: CRITICAL)
**Tag:** `TOP20-P08`

---

### Practice #9 — Validate Indirections (Array/Pointer Access)

**Look for:** Dynamic array indexing, PEEK/POKE operations, indirect addressing via
VARIANT or ANY pointer.

**Compliant:** Every array access with a variable index has a preceding bounds check:

```scl
IF (Index >= 0) AND (Index <= UPPER_BOUND(MyArray)) THEN
    Value := MyArray[Index];
ELSE
    Value := SAFE_DEFAULT;
END_IF;
```

**Violation indicators:**

- `MyArray[ExternalIndex]` without bounds check
- `MOVE_BLK` or `MOVE_BLK_VARIANT` with length derived from external input
- Pointer arithmetic without validation
- PEEK/POKE with computed offsets

**Severity:** HIGH (CWE-787 / CWE-805 implications)
**Tag:** `TOP20-P09`

---

### Practice #10 — Assign Register Blocks by Function (Read/Write Separation)

**Look for:** Data Block structure — are read-only process values mixed with writable
setpoints in the same DB?

**Compliant:** Separate DBs for:

- HMI-writable setpoints (operator interface DB)
- PLC-internal status and calculations (process DB, read-only to external)
- Configuration parameters (protected config DB)

**Violation indicators:**

- Single DB containing both `Motor_Speed_Setpoint` (writable) and
  `Motor_Current_Actual` (read-only status) in the same structure
- No architectural separation between operator inputs and process outputs
- Safety-critical parameters in the same DB as diagnostic counters

**Severity:** MEDIUM
**Tag:** `TOP20-P10`

---

### Practice #11 — Instrument Every Input and Output with Integrity Checks

**Look for:** I/O diagnostics usage. Are analog inputs checked for wire-break (sensor
fault)? Are digital outputs monitored for feedback?

**Compliant:** Analog inputs compared against physically impossible values (e.g.,
4-20mA sensor reading below 3.5mA indicates wire break). Output commands compared
with position feedback within a timeout.

**Violation:** Raw analog values used directly without plausibility checks.
Output commands issued without feedback verification.

**Severity:** MEDIUM (safety I/O: HIGH)
**Tag:** `TOP20-P11`

---

### Practice #12 — Monitor and Log PLC Activity

**Look for:** Logging mechanisms — does the code record setpoint changes, mode
transitions, alarm events, operator actions?

**Compliant:** Event logging for: mode changes, setpoint modifications, alarm
activations/acknowledgments, start/stop commands, error conditions.

**Violation:** No logging or audit trail. Operator actions leave no trace.
Security-relevant events (failed access, parameter changes) are not recorded.

**Severity:** MEDIUM
**Tag:** `TOP20-P12`

---

### Practice #13 — Monitor the Scan Cycle

**Look for:** Scan cycle time monitoring. Does the code detect abnormal cycle times
that might indicate unauthorized logic injection or denial of service?

**Compliant:** Cycle time compared against expected bounds. Deviation triggers alarm.

**Violation:** No cycle time monitoring. An attacker could inject computationally
expensive logic without detection.

**Severity:** LOW
**Tag:** `TOP20-P13`

---

### Practice #14 — Trap False Negatives and False Positives for Critical Alerts

**Look for:** Alarm management quality. Can critical alarms be suppressed? Are alarms
validated before acting on them?

**Compliant:** Critical alarms use redundant sensor validation. Alarm suppression
requires explicit operator action and is time-limited. Failed sensors trigger
separate diagnostic alarms rather than silently disabling process alarms.

**Violation:** Single-sensor alarms that can be defeated by sensor spoofing.
Permanent alarm suppression without timeout. Alarm conditions that fail silently.

**Severity:** MEDIUM (safety alarms: HIGH)
**Tag:** `TOP20-P14`

---

### Practices #15–#20 — Summary checks

| Practice | Check | Severity | Tag |
| ---------- | ------- | ---------- | ----- |
| #15 — Validate Timer, Pulse, and Counter Usage | Timers/counters with external presets without validation. Counters without overflow handling. | MEDIUM | `TOP20-P15` |
| #16 — Validate and Alert for Paired Inputs/Outputs | Complementary signals (open/close) without consistency check. Both states active simultaneously. | MEDIUM | `TOP20-P16` |
| #17 — Encode Raise/Lower Commands with State | Commands without position tracking. Move commands without target confirmation. | LOW | `TOP20-P17` |
| #18 — Implement Minimum Viable Physical Sensor Checks | No sensor range validation. 4-20mA signals used without wire-break detection. | MEDIUM | `TOP20-P18` |
| #19 — Implement Data and Code Signing where Possible | No integrity verification on downloaded blocks or received data. | LOW | `TOP20-P19` |
| #20 — Leverage Firmware-Based Protections | Known-vulnerable firmware features enabled without mitigation. | LOW | `TOP20-P20` |

---

## Communication Logic Hardening

Analyze all communication-related code for security weaknesses.

### PUT/GET instructions

**Risk:** PUT/GET bypasses block-level access control. When enabled, ANY device on the
network can read/write ANY memory area on the PLC.

**What to flag:**

- Any use of PUT or GET instructions: severity HIGH, tag `COMM-PUTGET`
- Recommend replacement with TSEND_C / TRCV_C or OPC UA with certificate auth
- If PUT/GET is present and justified, check for compensating controls (IP filtering,
  network segmentation documentation)

### TCON with hardcoded IP addresses

**Risk:** Hardcoded IPs prevent dynamic network reconfiguration and simplify spoofing.

**What to flag:**

- Static IP literals in TCON connection parameters: severity MEDIUM, tag `COMM-HARDCODED-IP`
- Recommend symbolic addressing or configuration DB with protected access

### MB_SERVER (Modbus TCP)

**Risk:** Modbus TCP has no built-in authentication. Any client can read/write holding
registers.

**What to flag:**

- MB_SERVER usage without IP address filtering in block parameters: severity HIGH,
  tag `COMM-MODBUS`
- Modbus holding registers mapped to safety-critical setpoints: severity CRITICAL,
  tag `COMM-MODBUS`

### TSEND / TRCV without validation

**Risk:** Received data from TSEND/TRCV may be corrupted, truncated, or maliciously
crafted.

**What to flag:**

- TRCV data used directly without length validation: severity MEDIUM, tag `COMM-RECV`
- Received buffer not checked against expected message structure: severity MEDIUM
- No timeout handling on TRCV (stale data risk): severity LOW

### Communication security preference order

For recommendations, prefer protocols in this order:

1. OPC UA with certificate-based authentication (most secure)
2. TSEND_C / TRCV_C with connection monitoring (good)
3. PUT/GET with network segmentation (acceptable only if legacy requirement)
4. Modbus TCP (avoid for safety-critical data, use only with IP filtering)
