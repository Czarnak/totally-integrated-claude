# Compiler Critic — Analysis Pass 4

## Role

Analyze the code for Siemens platform-specific risks that exist regardless of
adversarial intent. Compiler bugs, memory safety issues, initialization flaws,
and safety/standard boundary violations can cause process failures or create
exploitable conditions even in well-intentioned code.

Sources: Siemens TIA Portal documentation, Siemens Industry Online Support advisories,
CWE (Common Weakness Enumeration), Siemens Programming Guidelines for S7-1200/S7-1500,
Programming Guideline Safety for SIMATIC S7-1200/1500.

---

## Section 1 — Optimized vs Non-Optimized Block Access

### Background

"Optimized Block Access" lets the TIA Portal compiler arrange DB memory for CPU
efficiency while providing symbolic-only variable access. This is the recommended
mode for S7-1200/S7-1500.

Non-optimized access preserves absolute (byte-offset) addressing for backward
compatibility but exposes memory layout to manipulation.

### What to check

#### 1.1 — **Non-optimized blocks without justification**

In SimaticML XML, check the block attribute: `MemoryLayout="Standard"` indicates
non-optimized access. In SCL source, look for `{MemoryLayout := 'Standard'}` pragma
or explicit `AT` overlay declarations.

**Flag:** Any DB or FB with non-optimized access.
**Exception:** Legacy communication blocks requiring fixed byte layout (documented).
**Severity:** MEDIUM
**Tag:** `PLATFORM-NONOPTIMIZED`

#### 1.2 — **ANY pointer usage in optimized context**

ANY pointers (`P#...`) are deprecated in optimized blocks. They reference physical
memory offsets that are undefined when the compiler rearranges variables.

**Flag:** `ANY` type declarations, `P#` pointer literals, `SFC 20 BLKMOV` with ANY params.
**Severity:** HIGH — runtime memory corruption possible.
**Tag:** `PLATFORM-ANYPOINTER`

#### 1.3 — **Absence of VARIANT for indirect addressing**

Where indirect data access is needed, VARIANT provides safe symbolic reference.

**Flag:** Indirect addressing via absolute offsets instead of VARIANT.
**Recommend:** Replace with `VARIANT` type and `MOVE_BLK_VARIANT`.
**Severity:** LOW (recommendation)
**Tag:** `PLATFORM-VARIANT`

---

## Section 2 — Compiler-Induced Logic Vulnerabilities

### 2.1 — V18/V19 SCL Optimizer Bug

**Affected versions:** TIA Portal V18 (before Update 5), V19 (before Update 3).

**Bug description:** The SCL code optimizer incorrectly generates MC7 assignments
within nested control statements when structure variables (UDTs) are assigned values
outside a control instruction and then reused within nested IF-ELSE or CASE blocks.
The generated machine code swaps or duplicates assignments, causing the PLC to execute
different logic than what the SCL source shows.

**What to look for:**

```scl
// HIGH-RISK PATTERN: UDT assignment before nested control flow
MyStruct.Field1 := Value1;

IF Condition1 THEN
    IF Condition2 THEN
        MyStruct.Field2 := Value2;
    ELSE
        MyStruct.Field2 := Value3;  // May execute with wrong value
    END_IF;
END_IF;
```

**Flag:** Nested IF-ELSE or CASE structures that operate on UDT/struct members,
especially when assignments to the same structure occur before the control block.
**Severity:** HIGH (safety-critical logic: CRITICAL)
**Remediation:** Install Update 3 (V19) or Update 5 (V18). Perform "Software
(rebuild all)" — not incremental compile. Verify MC7 behavior matches source.
**Tag:** `PLATFORM-OPTIMIZER`

### 2.2 — V12 SCL Monitoring Issues

**Affected versions:** TIA Portal V12 and earlier.

**Bug description:** SCL monitoring (inline debugging) in V12 has timing conflicts
and symbol resolution errors that produce "blank" (##) values. This isn't a logic
bug per se, but relying on V12 monitoring for verification is unreliable.

**Flag:** If project metadata indicates V12 origin, note as INFO with upgrade
recommendation (V14+ resolves monitoring issues).
**Severity:** INFO
**Tag:** `PLATFORM-V12`

### 2.3 — Error handling disparities between CPU generations

**Background:** S7-300/400 and S7-1200/1500 handle synchronous and asynchronous
errors differently. Code migrated between generations may have incorrect error
handling that causes the CPU to go to STOP on minor faults.

**What to check:**
- Are error OBs present? Specifically OB80 (time error), OB82 (diagnostic interrupt),
  OB121 (programming error), OB122 (I/O access error).
- If error OBs are missing, a runtime error will cause the CPU to STOP.
- Is GET_ERROR or GET_ERR_ID used for local error handling within blocks?
- Are error OBs just empty stubs, or do they actually handle the error condition?

**Flag:** Missing error OBs for production code.
**Severity:** MEDIUM (safety-critical: HIGH)
**Remediation:** Implement OB80, OB82, OB121, OB122 at minimum. Use GET_ERROR for
local handling within complex blocks.
**Tag:** `PLATFORM-ERROROB`

---

## Section 3 — CWE-Based Memory Safety

### CWE-787 — Out-of-bounds Write

**PLC context:** The instructions `MOVE_BLK` and `MOVE_BLK_VARIANT` invoke internal
memory copy without fully validating source/destination positions. When handling
dynamic data from communication blocks (TSEND/TRCV), the received data length may
exceed the destination buffer size.

**What to look for:**

- `MOVE_BLK` or `MOVE_BLK_VARIANT` where the `COUNT` parameter is derived from
  received data length rather than destination buffer size
- `BLKMOV` (SFC 20) with length parameters from external sources
- Any block-move operation where `COUNT > (destination size - destination offset)`

**Compliant pattern:**

```
// Safe: Count limited to destination capacity
MoveCount := MIN(ReceivedLength, SIZEOF(DestBuffer));
MOVE_BLK(SRC := SourceData, COUNT := MoveCount, DEST => DestBuffer);
```

**Severity:** HIGH
**Tag:** `CWE-787`

---

### CWE-805 — Buffer Access with Incorrect Length Value

**PLC context:** Related to CWE-787 but specifically about length calculation errors.
Common when UDT structures are modified (fields added/removed) but MOVE_BLK lengths
are not updated accordingly.

**What to look for:**

- Hardcoded byte lengths in MOVE operations that should reference `SIZEOF()`
- Length calculations that don't account for UDT padding or alignment
- Copy operations between buffers of different sizes without explicit length limiting

**Severity:** HIGH
**Tag:** `CWE-805`

---

### CWE-190 — Integer Overflow (Wrap-Around)

**PLC context:** In ICS, integer overflow can cause a pressure setpoint to jump from
MAX to MIN (or vice versa), a counter to wrap to zero, or a timer to expire immediately.

**What to look for:**

- Arithmetic operations on INT/DINT values near their limits without overflow checks
- Counters (especially runtime hour counters, totalizers) without rollover handling
- Multiplication results assigned to same-size integers without range validation
- Setpoint calculations that could produce values outside physical range

**Critical scenario:**

```
// DANGEROUS: Unsigned counter wrapping
ProductionCount := ProductionCount + 1;
// If ProductionCount is INT and reaches 32767, next increment = -32768
```

**Severity:** MEDIUM (safety-critical values: HIGH)
**Tag:** `CWE-190`

---

### CWE-457 — Use of Uninitialized Variable

**PLC context:** In S7-1500, temporary local variables (`VAR_TEMP`) retain stale data
from the previous scan cycle or from whatever previously occupied that memory region.
This is especially dangerous in safety programs where an uninitialized boolean could
be interpreted based on leftover memory.

**What to look for:**

- `VAR_TEMP` variables where the first access in execution flow is a READ, not a WRITE
- Blocks using `JMP` / `GOTO` / conditional jumps that could skip initialization sections
- Temporary variables used in safety-related decisions

**Compliant pattern:** The very first statement involving any `VAR_TEMP` must be an
assignment (write). This must hold true for ALL possible execution paths, including
paths reached via jumps.

**Severity:** HIGH (in safety programs: CRITICAL)
**Tag:** `CWE-457`

---

## Section 4 — Standard / Safety Program Boundary

Applies to Siemens F-Systems (Fail-Safe) using F-CPUs with safety programs.

### 4.1 — Read-only standard access from safety program

**Rule:** The safety (F-) program may only READ data from the standard program.
Any write from F-program to standard tags is a potential integrity violation.

**What to look for:**

- F-FB or F-FC blocks that write to variables declared outside the safety context
- F-DB variables that are also written to by standard blocks (bidirectional access)
- Shared memory areas used as write buffers between standard and safety programs

**Severity:** CRITICAL
**Tag:** `SAFETY-BOUNDARY`

---

### 4.2 — Operand area restrictions

**Rule:** Certain operand areas (bit memory / Merker %M) can only be used for data
exchange between standard and safety programs. They must NOT be used as internal
buffers within safety-critical logic.

**What to look for:**

- `%M` operands used as intermediate results within F-blocks
- Bit memory used for safety-critical interlocking (should use F-DB variables instead)

**Severity:** HIGH
**Tag:** `SAFETY-OPERAND`

---

### 4.3 — Array restrictions in safety programs

**Rule:** In F-DBs, arrays are limited to:

- Maximum 10,000 elements
- Types: INT or DINT only
- Not permitted in F-FBs or F-FCs (only in F-DBs)

**What to look for:**

- Arrays declared in F-FBs or F-FCs
- Arrays exceeding 10,000 elements in F-DBs
- Arrays of types other than INT/DINT in F-DBs

**Severity:** HIGH (compiler may reject, but code review should catch it first)
**Tag:** `SAFETY-ARRAY`

---

### 4.4 — F-Cycle time vs standard cycle time

**Rule:** The safety cycle (F-monitoring time) must be significantly shorter than
the standard cycle time to prevent non-deterministic behavior in safety responses.

**What to look for:**

- If timing configuration is available: compare F-cycle time to standard OB1 cycle time
- Safety logic in OB1 instead of dedicated F-OB (wrong execution priority)
- F-runtime warnings about cycle time overruns

**Severity:** HIGH
**Tag:** `SAFETY-FCYCLE`

---

### 4.5 — F-CPU restart and re-integration patterns

**Rule:** After a safety fault, F-CPU restart and F-I/O re-integration must use
proper "User Acknowledgment" patterns — typically a two-step "Arm and Fire"
procedure requiring deliberate operator action.

**What to look for:**

- Automatic F-CPU restart without operator acknowledgment
- F-I/O re-integration triggered by timer instead of operator confirmation
- Single-button restart (should require two distinct actions to prevent accidental restart)

**Severity:** HIGH
**Tag:** `SAFETY-RESTART`

---

## Section 5 — LAD/FBD-Specific Patterns (XML Analysis)

When analyzing SimaticML XML for LAD/FBD programs, check for these structural issues
in addition to the logic-level checks above:

### 5.1 — Unused networks

Networks with no output coils, no function block calls, and no write operations.
May indicate dead code or incomplete implementation.

**Severity:** LOW
**Tag:** `PLATFORM-DEADNETWORK`

### 5.2 — Coil conflicts

Multiple networks writing to the same output. In LAD, the last network in execution
order wins — earlier writes are overwritten. This is sometimes intentional (conditional
override) but often a bug.

**Severity:** MEDIUM
**Tag:** `PLATFORM-COILCONFLICT`

### 5.3 — Unconnected pins on function blocks

FB/FC instances with required input pins that have no wire connection. The pin uses
its default or last-cycle value, which may not be the intended behavior.

**Severity:** LOW (safety blocks: HIGH)
**Tag:** `PLATFORM-UNWIRED`
