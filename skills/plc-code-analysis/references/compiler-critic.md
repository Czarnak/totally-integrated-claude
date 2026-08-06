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

**Review signal:** A DB or FB with non-optimized access. Standard access is valid
and sometimes required, for example for legacy absolute-address communication and
PUT/GET target areas. Do not report it as a vulnerability without an exposed
consumer, sensitive data, or an unjustified dependency on absolute layout.
**Default severity:** INFO; raise only from source-backed exposure and impact evidence.
**Tag:** `PLATFORM-NONOPTIMIZED`

#### 1.2 — **ANY pointer usage in optimized context**

Legacy pointer/ANY patterns depend on CPU family, instruction, and memory area.
For example, V21 `BLKMOV` on S7-1500 uses `VARIANT` but restricts actual operands
to non-optimized areas (with documented exceptions); S7-300/400 `BLKMOV` uses ANY.
The compiler normally rejects unsupported combinations.

**Review:** `ANY` declarations, `P#` pointer literals, and `BLKMOV` calls. Confirm
CPU family, optimized/standard memory, source/destination sizes, overlap rules,
return status, and compile result. Do not claim runtime memory corruption solely
from syntax that the compiler may reject.
**Default severity:** INFO or LOW; elevate only with a reachable unsafe operation.
**Tag:** `PLATFORM-ANYPOINTER`

#### 1.3 — **Absence of VARIANT for indirect addressing**

Where indirect data access is needed, VARIANT provides safe symbolic reference.

**Review:** Indirect addressing via absolute offsets where symbolic ARRAY access or
VARIANT would meet the same requirement. `MOVE_BLK_VARIANT` is specifically useful
for ARRAY ranges whose element type is known only at runtime; it is not a universal
replacement for every move.
**Severity:** LOW (recommendation)
**Tag:** `PLATFORM-VARIANT`

---

## Section 2 — Toolchain and CPU-Family Provenance

### 2.1 — Product advisories and project provenance

Do not infer a compiler defect from a code shape such as nested `IF`, `CASE`, or
UDT-member assignment. A precise compiler finding requires the project engineering
version/update, target CPU and firmware, compile mode, and an applicable Siemens
product note or reproducible compile/runtime difference.

For a V21 project, record the installed V21 update and perform a full compile when
the user authorizes verification. If the project was migrated, origin metadata alone
does not prove that code is still affected after recompilation in V21.

**Tag:** `PLATFORM-TOOLCHAIN`

### 2.2 — Error handling disparities between CPU generations

**Background:** S7-300/400 and S7-1200/1500 handle synchronous and asynchronous
errors differently. Code migrated between generations may have incorrect error
handling that causes the CPU to go to STOP on minor faults.

**What to check:**

- Which error/diagnostic OBs are supported and required by the exact CPU family and
  configured events (for example OB80, OB82, OB121, or OB122 where applicable)?
- What is the documented CPU response when the applicable OB is absent? Do not
  generalize one CPU generation's STOP behavior to every target.
- Is GET_ERROR or GET_ERR_ID used for local error handling within blocks?
- Are error OBs just empty stubs, or do they actually handle the error condition?

**Finding gate:** The exact CPU/event documentation shows an unhandled event can
produce an unacceptable response, and the relevant OB/local error handling is absent.
Do not prescribe a universal minimum set of OBs.
**Severity:** Contextual from the documented response and process consequence.
**Tag:** `PLATFORM-ERROROB`

---

## Section 3 — CWE-Based Memory Safety

### Bounds and status handling for block moves

**PLC context:** V21 typed `MOVE_BLK`/`MOVE_BLK_VARIANT` enforce data-type and
available-range conditions. `MOVE_BLK_VARIANT` is not executed when the requested
range exceeds available source/destination data; `MOVE_BLK` reports an invalid
output/ENO response depending on language. The primary review risk is unchecked
failure, stale/invalid downstream data, unit mistakes, or legacy raw-area behavior—not
an automatic out-of-bounds write finding.

**What to look for:**

- `COUNT`, source index, or destination index derived from external data without a
  same-unit element-range check
- failure/ENO/status ignored before the destination is consumed
- legacy `BLKMOV` areas with mismatched or overlapping source/destination ranges
- byte counts confused with element counts

**Compliant pattern:**

Validate element counts against source and destination capacities in the same unit,
then handle the instruction's failure indication before consuming output. `SIZEOF`
returns a size, while `COUNT` is an element count; do not compare them without an
explicit element-width conversion.

Assign `CWE-787` only when direct evidence demonstrates an actual out-of-bounds write
path for the exact CPU/instruction. Otherwise use `PLATFORM-BLOCKMOVE` and describe
the observed failure-handling risk.

---

### CWE-805 — Buffer Access with Incorrect Length Value

**PLC context:** Related to CWE-787 but specifically about length calculation errors.
Common when UDT structures are modified (fields added/removed) but MOVE_BLK lengths
are not updated accordingly.

**What to look for:**

- Hardcoded byte lengths in raw-area moves that drift from the declared layout
- hardcoded element counts in typed ARRAY moves that drift from array bounds
- Length calculations that don't account for UDT padding or alignment
- Copy operations between buffers of different sizes without explicit length limiting

**Severity:** Contextual; typed V21 moves that fail closed are not automatically HIGH.
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

```scl
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

### 4.1 — Direction-aware data exchange

V21 explicitly permits data exchange in both directions, with operand-specific
restrictions. Examples include:

- the standard program may read safety data (F-DBs, F-FB instance DBs, and allowed
  F-I/O process-image data), but may not write F-DB tags;
- the safety program may read standard DB tags, bit memory, and permitted standard
  process-image data; standard tags are unsafe and must be treated accordingly;
- the safety program can write permitted standard DB tags/bit memory and selected
  process-image outputs under the documented operand restrictions.

Siemens recommends dedicated transfer data blocks to decouple the standard and
safety programs. When unsafe standard data influences a safety function, verify
the required plausibility/range checks and that unsafe signals cannot alone enable
a hazardous action. A permitted data direction is not itself a vulnerability.

**Finding gate:** An actual access violates the V21 operand table, bypasses required
plausibility, or creates a source-backed unsafe influence on a safety function.
**Severity:** Derived from the specific safety consequence; do not default every
cross-boundary access to CRITICAL.
**Tag:** `SAFETY-BOUNDARY`

---

### 4.2 — Operand area restrictions

Bit memory and standard DB tags are permitted exchange mechanisms, but they are not
fail-safe data. Review whether they are used only in a way allowed by the exact
F-CPU/Safety instruction restrictions and whether unsafe values receive the required
plausibility and safety logic treatment.

**What to look for:**

- `%M`/standard DB values treated as intrinsically fail-safe
- unsafe exchange tags that can enable a hazardous output without a fail-safe condition
- standard code writing an F-DB (not permitted)

**Severity:** Contextual from the reachable safety effect.
**Tag:** `SAFETY-OPERAND`

---

### 4.3 — Array restrictions in safety programs

For the V21 F-array instructions on supported S7-1200 G2/S7-1500 targets:

- the array is one-dimensional in an F-DB;
- the low limit is `0` and the high limit is at most `10000`;
- element type is `INT` or `DINT` according to the matching instruction;
- `ARRAY[*]` is permitted as an `InOut` parameter of F-FCs/F-FBs for this use.

**What to look for:**

- fixed arrays outside the permitted F-DB location
- a low limit other than 0 or high limit above 10000
- unsupported dimensions or element types
- `ARRAY[*]` used outside the allowed `InOut` interface/instruction context
- failure to handle the array instruction's `ERROR` output and safe substitute at index 0

**Severity:** HIGH (compiler may reject, but code review should catch it first)
**Tag:** `SAFETY-ARRAY`

---

### 4.4 — Safety timing and response-time evidence

Do not equate PROFIsafe `F-monitoring time`, the F-runtime-group execution interval,
and the standard OB1 cycle. There is no universal rule that one must be a fixed ratio
or simply shorter than another. Validate the configured F-runtime group, PROFIsafe
monitoring times, CPU/F-I/O response-time calculation, process safety time, watchdog
diagnostics, and the exact cyclic-interrupt assignment against the safety design.

The configured PROFIsafe monitoring time must be high enough to avoid fault-free
trips yet low enough for the accepted safety response, using Siemens' response-time
calculation and commissioning checks. Missing configuration evidence yields an INFO
verification gap, not an assumed HIGH defect.
**Tag:** `SAFETY-FCYCLE`

---

### 4.5 — F-CPU restart and re-integration patterns

After faults requiring reintegration, Siemens' `ACK_REI`/`ACK_GL` mechanisms require
a user acknowledgment with a manual signal and positive edge where the instruction
or device configuration requires it. The safety requirements and hazard analysis
determine the operator interaction; V21 does not impose a universal two-action pattern.

**What to look for:**

- automatic acknowledgment or a timer-generated acknowledgment where manual action is required
- acknowledgment logic without positive-edge behavior
- restart/reintegration that can immediately create hazardous motion without the
  separately required start/restart interlock and operator procedure

**Severity:** Contextual; automatic acknowledgment contrary to the applicable
Safety requirement is normally HIGH and may be CRITICAL only with a demonstrated
hazardous restart path.
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
