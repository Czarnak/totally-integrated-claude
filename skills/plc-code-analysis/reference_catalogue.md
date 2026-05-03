# plc-code-analysis — reference catalogue

## Analysis passes

Each reference file represents one analysis pass. Claude loads them sequentially,
analyzes the code through that lens, summarizes findings, then moves to the next.

| Pass | Reference file | Role | Focus |
|------|---------------|------|-------|
| 1 | `process-architect.md` | Process Architect | Physical plausibility, process context, state-aware invariants, operational logic placement |
| 2 | `security-practices.md` | Security Auditor | Top 20 Secure PLC Coding Practices, input validation, register separation, communication hardening |
| 3 | `threat-mapping.md` | Threat Analyst | MITRE ATT&CK for ICS technique identification, adversarial pattern detection, evasion indicators |
| 4 | `compiler-critic.md` | Compiler Critic | Siemens platform-specific bugs, CWE memory safety, optimized access, safety program boundary |
| 5 | `hardware-reviewer.md` | Hardware Reviewer | CPU access settings, enabled services, protocol security, network exposure, protection levels |

## Pass order rationale

Process context **must** come first. Understanding what the code physically controls
(pump vs. indicator lamp, chemical reactor vs. conveyor belt) determines the severity
of every finding in subsequent passes. A missing bounds check is LOW on a display
variable but CRITICAL on a motor speed setpoint.

Security Practices and Threat Mapping are separated because they serve different
purposes: practices answer "does this code follow defensive coding standards?" while
threat mapping answers "does this code exhibit patterns associated with known attack
techniques?" A finding might violate no coding practice but still match a threat
technique pattern (e.g., unusual clock-based triggers).

Compiler Critic follows security passes because its findings are platform-specific —
they matter regardless of adversarial context. A V19 optimizer bug corrupts logic
whether or not an attacker is involved.

Hardware Reviewer runs last because it analyzes a different input (configuration, not
code) and may not always have data available.

## Category tags used in findings

| Prefix | Source | Example |
|--------|--------|---------|
| `PROC` | Process Architect | `PROC-PLAUSIBILITY`, `PROC-INTERLOCK`, `PROC-STATE` |
| `TOP20-P##` | Security Practices | `TOP20-P08` (Practice #8: Validate HMI Inputs) |
| `COMM` | Security Practices (comms) | `COMM-PUTGET`, `COMM-MODBUS`, `COMM-HARDCODED-IP` |
| `T####` | Threat Mapping (MITRE) | `T0836` (Modify Parameter), `T0856` (Spoof Reporting) |
| `CWE-###` | Compiler Critic | `CWE-787` (Out-of-bounds Write), `CWE-457` (Uninitialized Variable) |
| `PLATFORM` | Compiler Critic | `PLATFORM-OPTIMIZER`, `PLATFORM-NONOPTIMIZED` |
| `SAFETY` | Compiler Critic (safety boundary) | `SAFETY-BOUNDARY`, `SAFETY-FCYCLE` |
| `HW` | Hardware Reviewer | `HW-PUTGET`, `HW-WEBSERVER`, `HW-ACCESS-LEVEL` |

## Input requirements per pass

| Pass | Minimum input | Enhanced by |
|------|--------------|-------------|
| Process Architect | Code (any format) | Block comments, project documentation |
| Security Practices | Code (any format) | UDT definitions, DB structures, call tree |
| Threat Mapping | Code (any format) | Block metadata (timestamps, checksums), call tree |
| Compiler Critic | Code (any format) | TIA Portal version info, block attributes (MemoryLayout) |
| Hardware Reviewer | Hardware config data | MCP `GetHardwareConfig` output, CPU property screenshots |
