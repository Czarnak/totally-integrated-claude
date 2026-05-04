# Threat Mapping — Analysis Pass 3

## Role

Shift perspective from defensive coding standards to adversarial thinking. Look at the
code through the lens of the MITRE ATT&CK for ICS framework and ask: "If an attacker
had access to this code or this network, which techniques could they leverage? Does
this code contain patterns that resemble known attack indicators?"

This pass is NOT about finding bugs — it's about finding patterns that an adversary
could exploit or that indicate existing compromise.

Source: MITRE ATT&CK for ICS (attack.mitre.org/matrices/ics/),
CISA ICS advisories, Claroty Team82 research, Dragos ICS threat intelligence.

---

## Tactic: Initial Access / Execution

These techniques represent how an adversary gets code running on or interacting with
the PLC.

### T0858 — Unauthorized Command Message

**Code indicators:**

- Logic branches that accept commands from sources other than the documented HMI/SCADA
- "Backdoor" or "test" modes that bypass normal safety interlocks
- Debug commands that remain active in production code
- Undocumented function codes or command values in communication handling blocks

**What to look for in SCL:**

```scl
// SUSPICIOUS: Bypass interlock for "testing"
IF Debug_Mode THEN
    Motor_Start := TRUE;  // Skips all interlock checks
END_IF;
```

**What to look for in LAD/FBD XML:**

- Networks with comments containing "test," "debug," "bypass," "temporary" that
  control actuator outputs
- Parallel branches that provide alternative paths around interlock contacts

**Severity:** HIGH (active bypass in production code: CRITICAL)
**Tag:** `T0858`

---

### T0836 — Modify Parameter

**Code indicators:**

- Variables controlling motor speeds, valve positions, chemical concentrations, pressure
  setpoints, or temperature limits that are writable from external sources without
  bounds checking
- Setpoints stored in globally accessible DBs without write protection
- Parameters that can be modified while the process is running without operator
  confirmation

**What to look for:**

- All `VAR_INPUT` and `VAR_IN_OUT` parameters that directly or transitively control
  physical actuators
- DB variables tagged for HMI access that contain process-critical setpoints
- Missing range validation (overlaps with TOP20-P08 but the perspective here is
  adversarial: what could an attacker SET these to?)

**Severity assessment:**

- Parameter controls a safety-critical actuator → CRITICAL
- Parameter affects process quality/efficiency → HIGH
- Parameter affects non-critical auxiliary function → MEDIUM

**Tag:** `T0836`

---

## Tactic: Impair Process Control

Techniques that directly affect the physical process.

### T0827 — Inhibit Response Function

**Code indicators:**

- Logic that can disable or suppress safety system responses
- Standard program code that writes to or influences safety program variables
- Interlock bypass logic without time limitation or automatic re-engagement
- Alarm suppression without timeout

**What to look for:**

- Any path in standard (non-safety) code that can affect F-program behavior
- Variables that gate safety interlock evaluation (e.g., `Interlock_Bypass := TRUE`)
- Logic that prevents OB35 (safety cyclic interrupt) from executing or that modifies
  F-DB values from standard context

**Severity:** CRITICAL when safety functions are inhibitable from standard code
**Tag:** `T0827`

---

### T0831 — Manipulation of Control

**Code indicators:**

- Logic that allows unrestricted modification of control loop parameters (PID gains,
  setpoints, output limits) from external interfaces
- Control mode switches without authentication or logging
- Auto/Manual transitions that don't preserve safety constraints in manual mode

**What to look for:**

- PID block instances where `KP`, `TI`, `TD`, `LMN_HLM`, `LMN_LLM` are writable
  from HMI without validation
- Mode transitions that disable output limiting in manual mode
- Cascade control where inner loop setpoint can be overridden externally

**Severity:** HIGH
**Tag:** `T0831`

---

## Tactic: Evasion

Techniques to hide adversarial activity from operators and monitoring systems.

### T0856 — Spoof Reporting Message

**Code indicators:**

- Code that "freezes" or "replays" old sensor values during specific operations
- Logic that substitutes actual readings with stored/calculated values
- Timer-gated value replacement (show old data while performing unauthorized action)

**What to look for in SCL:**

```scl
// SUSPICIOUS: Value freezing pattern
IF Special_Operation THEN
    HMI_Display_Temperature := Stored_Temperature;  // Frozen value
ELSE
    HMI_Display_Temperature := Actual_Temperature;   // Real value
END_IF;
```

**What to look for in LAD/FBD XML:**

- MOVE instructions that copy values from static/stored variables to HMI output
  variables, conditioned on specific triggers
- Parallel paths where one writes actual values and another writes stored values,
  selected by a condition

**Severity:** CRITICAL — this is a classic attack indicator (Stuxnet used this pattern)
**Tag:** `T0856`

---

### T0833 — Modify Control Logic

**Code indicators:**

- Unexpected changes in block checksums or modification timestamps without
  corresponding change requests
- Logic blocks with suspiciously recent modification dates compared to the rest
  of the project
- Code patterns that don't match the project's coding style

**What to look for:**

- If block metadata is available (via `get_block_content`, `browse_project_tree`, or exported attributes):
  compare modification timestamps across blocks. Outliers may indicate unauthorized
  modification.
- Blocks with know-how protection disabled when project standard requires it
- Inconsistent coding patterns within a block (mixed naming conventions, different
  comment styles) suggesting multiple authors or post-deployment modification

**Severity:** HIGH
**Tag:** `T0833`

---

## Tactic: Persistence

Techniques to maintain presence in the PLC after initial access.

### Logic bombs and time-based triggers

**Code indicators:**

- System clock reads (`RD_SYS_T`, `RD_LOC_T`) used for non-standard purposes
- Logic that only executes on specific dates, times, or after elapsed durations
  unrelated to the process
- Counters that increment across cycles and trigger actions at specific values
  without clear process justification

**What to look for in SCL:**

```scl
// SUSPICIOUS: Date-based conditional execution
RD_SYS_T(OUT => CurrentTime);
IF (CurrentTime.YEAR = 2026) AND (CurrentTime.MONTH = 6) AND (CurrentTime.DAY = 15) THEN
    // Logic that only runs on a specific date
END_IF;
```

```scl
// SUSPICIOUS: Cycle-counting trigger
CycleCounter := CycleCounter + 1;
IF CycleCounter >= 1000000 THEN
    // Logic that fires after ~N hours of runtime
END_IF;
```

**Exceptions (not suspicious):**

- Scheduled maintenance reminders based on runtime hours
- Time-of-day energy management (load shedding during peak hours)
- Batch timing and recipe sequencing
- Data logging with timestamps

**The key question:** Does the time-based logic serve a documented process purpose?

**Severity:** HIGH (if no process justification found)
**Tag:** `T0856-TIMEBOMB`

---

### T0806 — Brute Force I/O

**Code indicators:**

- Logic that iterates through a wide range of I/O addresses using indirect addressing
- Loops that scan peripheral inputs (%I) or write to outputs (%Q) using computed
  addresses
- State machine patterns that systematically test I/O combinations

**What to look for:**

- `FOR` loops with `PEEK` or `POKE` over address ranges
- Indirect addressing patterns that sweep through I/O areas
- Array-based I/O mapping where the array is externally writable

**Severity:** HIGH
**Tag:** `T0806`

---

### T0855 — PLC Mode Control

**Code indicators:**

- Use of system functions that can change PLC operating mode (RUN/STOP/PROGRAM)
- Logic that triggers CPU stop under conditions other than safety emergencies
- Remote-triggered mode transitions

**What to look for:**

- SFC 46 (`STP`) calls or equivalent stop commands
- `SET_SW` usage triggered by non-safety events
- Logic that conditionally forces STOP mode based on external input values

**Severity:** CRITICAL
**Tag:** `T0855`

---

## Analysis procedure for this pass

For each technique listed above:

1. Search the code for the specified indicators
2. If a pattern is found, assess whether there is a legitimate process justification
3. If justified (e.g., time-based load shedding), note as INFO with explanation
4. If not justified or suspicious, flag with the technique's tag and severity
5. For ambiguous cases, flag as MEDIUM with a note recommending manual review

### Cross-referencing with previous passes

Some findings from this pass will overlap with the Security Practices pass (especially
TOP20-P08 and T0836). When this happens:

- Keep both findings — they serve different purposes (compliance vs. threat model)
- Cross-reference them in the description: "See also: TOP20-P08"
- Use the higher severity of the two
- Do not deduplicate until the final merge step in SKILL.md
