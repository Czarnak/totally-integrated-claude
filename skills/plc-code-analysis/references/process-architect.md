# Process Architect — Analysis Pass 1

## Role

Think like a process engineer before thinking like a security analyst. Establish what
physical process the code controls, what the actuators and sensors are, what operating
states exist, and what physical constraints apply. Every subsequent finding from other
passes inherits its severity from the process context established here.

## Step 1 — Process identification

Extract from the code (comments, tag names, block names, variable naming conventions):

- **Process type:** What is being controlled? Chemical dosing, water treatment, conveyor
  system, HVAC, packaging line, press, furnace, pump station, etc.
- **Actuators:** Motors, valves, heaters, solenoids, variable frequency drives — anything
  that affects the physical world. Note which outputs (%Q) drive safety-critical actuators.
- **Sensors:** Temperature, pressure, flow, level, position, speed, current — anything
  that reads the physical world. Note which inputs (%I) monitor safety-critical conditions.
- **Control strategy:** PID loops, on/off control, cascade control, sequencing, batch
  control, state machines. Understanding the strategy reveals expected code patterns.

If the code's physical purpose cannot be determined from available context, record this
as an INFO finding — the analysis can proceed, but severity assignments will be conservative.

## Step 2 — Operating mode and state analysis

Identify the operating modes/states in the code:

- **Startup / Initialization:** Is there a defined startup sequence? Are actuators held
  in safe positions until initialization completes?
- **Normal operation:** What does steady-state look like? What ranges are expected?
- **Maintenance / Manual mode:** Can operators override automatic control? Are overrides
  bounded and logged?
- **Emergency / Fault state:** What happens when things go wrong? Do actuators go to
  fail-safe positions?
- **Shutdown / Controlled stop:** Is there an orderly shutdown sequence, or does the code
  just kill outputs?

### What to flag

| Pattern | Severity | Tag |
| --------- | ---------- | ----- |
| No identifiable startup sequence for process with physical inertia (heaters, pumps) | MEDIUM | `PROC-STARTUP` |
| No defined fault/emergency state | HIGH | `PROC-FAULT-STATE` |
| Manual mode without bounds on overridden setpoints | HIGH | `PROC-MANUAL-BOUNDS` |
| Actuator outputs not forced to safe state on transition to fault mode | CRITICAL | `PROC-FAILSAFE` |
| State transitions without precondition checks (e.g., start pump without checking valve) | HIGH | `PROC-INTERLOCK` |

## Step 3 — Physical plausibility checks

For every setpoint, limit, or threshold constant found in the code, ask:

- **Is the range physically reasonable?** A temperature setpoint of 5000°C for a water
  heater is obviously wrong. A motor speed of -100 RPM when the drive doesn't support
  reverse is a logic error.
- **Are complementary actuators properly interlocked?** Opening an inlet valve without
  checking that the outlet is clear. Starting a pump without verifying valve position.
  Running a heater without flow confirmation.
- **Do timer durations match the process?** A 10ms debounce on a mechanical relay (too
  short). A 30-minute timeout on an emergency stop acknowledgment (too long). Timer values
  should be proportional to the physical dynamics of the process.
- **Are there missing physical constraints?** A VFD speed reference without ramp limits.
  A valve command without position feedback timeout. A dosing pump without totalizer limits.

### What to flag

| Pattern | Severity | Tag |
| --------- | ---------- | ----- |
| Setpoint constant outside physically plausible range | HIGH | `PROC-PLAUSIBILITY` |
| Missing interlock between physically coupled actuators | HIGH–CRITICAL | `PROC-INTERLOCK` |
| Timer duration inconsistent with physical process dynamics | MEDIUM | `PROC-TIMING` |
| Control output without corresponding feedback monitoring | MEDIUM | `PROC-FEEDBACK` |
| Actuator command without rate limiting / ramp control | MEDIUM | `PROC-RAMP` |

## Step 4 — State-aware invariant analysis

This is the most advanced check. For each operating state identified in Step 2, define
what sensor values and actuator states are valid *in that specific state*:

- **In startup:** Tank level should be below setpoint, heater should be off until flow
  is confirmed, mixer speed should be zero until level is sufficient.
- **In normal operation:** Temperature should be within ±N of setpoint, flow should be
  above minimum threshold, pressure should be below safety limit.
- **In shutdown:** All actuators should be transitioning to off/safe positions, no new
  commands should be accepted.

A value that is within its absolute physical range but impossible for the current state
is a strong anomaly indicator. If the code does not enforce state-aware bounds, flag it.

### What to flag

| Pattern | Severity | Tag |
| --------- | ---------- | ----- |
| Setpoint accepted in a state where the actuator should be inactive | HIGH | `PROC-STATE` |
| No state-dependent validation of sensor readings | MEDIUM | `PROC-STATE` |
| Variables writable in states where they should be frozen (e.g., recipe parameters during batch execution) | MEDIUM | `PROC-STATE` |

## Step 5 — Operational logic placement (Top 20 Practice #3)

Check whether control logic is executed in the PLC or delegated to the HMI/SCADA:

- **Totalizing / integrating calculations:** Must be in the PLC. HMI scan rates are too
  slow and interruptions cause data loss.
- **Sequencing / step logic:** Must be in the PLC. HMI communication failure during a
  sequence causes undefined state.
- **Interlock logic:** Must be in the PLC. Never rely on the HMI to enforce interlocks.
- **Alarm generation:** Alarm conditions should be evaluated in the PLC, even if displayed
  on the HMI.

### What to flag

| Pattern | Severity | Tag |
| --------- | ---------- | ----- |
| Control logic that depends on HMI cycle for execution (polling-based interlocks) | HIGH | `PROC-LOGIC-PLACEMENT` |
| Totalizing / integration performed outside PLC scan cycle | MEDIUM | `PROC-LOGIC-PLACEMENT` |
| Interlock conditions evaluated only at HMI layer | HIGH | `PROC-LOGIC-PLACEMENT` |

## Severity weighting guidance for downstream passes

After completing this pass, Claude establishes a **process risk profile** used by all
subsequent passes:

| Process risk | Characteristics | Severity adjustment |
| ------------- | ---------------- | ------------------- |
| Safety-critical | Human proximity, hazardous materials, high energy, pressure vessels | Upgrade findings one level |
| Process-critical | Production continuity, expensive materials, environmental discharge | Keep findings at nominal level |
| Non-critical | Status display, logging, non-production auxiliary systems | Downgrade findings one level (minimum: INFO) |

Record the assessed process risk level in the findings summary for this pass. It applies
globally to all subsequent findings.
