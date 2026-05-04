---
name: plc-code-analysis
description: >
  Standalone skill for multi-perspective PLC code security and quality analysis.
  Triggers on: "review", "audit", "analyze", "security check", "vulnerability scan",
  "code review", "check this code", "is this safe", "find issues" when combined with
  PLC, SCL, ST, LAD, FBD, Structured Text, or block context. Also triggers when the user
  pastes PLC code and asks for feedback, or uploads exported SimaticML XML files.
  This skill is independent of tia-openness-roadmap — it does not perform engineering
  automation. It analyzes code that has already been exported, pasted, or is accessible
  via the TIA Portal MCP server.
---

# plc-code-analysis

## Goal

Perform structured, multi-perspective security and quality analysis of PLC code,
producing a severity-ranked findings report. Acts as an automated "second pair of eyes"
for automation engineers.

## Independence from tia-openness-roadmap

This skill is NOT routed by `tia-openness-roadmap`. It has its own trigger patterns and
operates independently. The Openness roadmap handles engineering automation (create, modify,
import/export via API). This skill handles analysis and review of existing code.

The skill CAN consume code retrieved via MCP tools or Python/C# Openness exports, but it
does not depend on them.

## Input recognition

Claude receives PLC code in one of three ways. Identify which applies before starting analysis.

### Format 1 — Raw SCL / Structured Text

The user pastes or uploads `.scl`, `.st`, or plain-text PLC code. This is the simplest case.
Parse directly as text. Look for FUNCTION_BLOCK, FUNCTION, ORGANIZATION_BLOCK, DATA_BLOCK
headers to identify block boundaries.

### Format 2 — SimaticML XML (exported LAD/FBD/SCL)

The user provides `.xml` files exported from TIA Portal. These follow the SimaticML schema.
Key navigation points:

- `<SW.Blocks.FB>`, `<SW.Blocks.FC>`, `<SW.Blocks.OB>`, `<SW.Blocks.DB>` — block type
- `<Interface>` → `<Section Name="Input|Output|InOut|Static|Temp|Constant">` — variable declarations
- `<ObjectList>` → `<CompileUnit>` — individual networks
- `<FlgNet>` inside CompileUnit — LAD/FBD network logic as a directed graph
- `<Access>` elements — variable references with scope and UID
- `<Part>` elements — instructions (contacts, coils, function calls)
- `<Wire>` elements — connections between parts (data/signal flow)
- `<StructuredText>` — inline SCL within LAD/FBD networks
- `<Comment>` — block and network comments (valuable for process context)
- Block attributes in root element: `BlockType`, `Number`, `Programming language`,
  `MemoryLayout` (Optimized/Standard), `HeaderAuthor`, `HeaderVersion`

For LAD/FBD analysis, reconstruct the logic flow from the `<FlgNet>` graph:
Parts are nodes, Wires are edges. Follow Powerrail → Contact chain → Coil/Function to
understand each network's behavior.

### Format 3 — MCP-assisted retrieval

If the TIA Portal MCP server is available, context retrieval is required before issuing
security findings. Use the current Totally Integrated Claude MCP tools:

1. `browse_project_tree` — map PLCs, block folders, block names, and execution entry points
2. `get_block_content` — retrieve SIMATIC SD YAML for each block under review
3. `list_tag_tables` — retrieve PLC tags, user constants, and externally writable names
4. `read_cross_references` — inspect call paths, unused blocks, and variable references
5. `read_hardware_config` — retrieve CPU, network, IP, subnet, and interface settings
6. `compile_check` — record compile errors/warnings when the user asks for remediation

Legacy source documents may name equivalent operations as `GetBlocksWithHierarchy`,
`ExportBlock`, `GetBlockInfo`, `GetTypes` / `GetTypeInfo`, or `GetHardwareConfig`.
Treat those as conceptual aliases, not callable tool names.

If MCP is unavailable or a required context item cannot be retrieved, continue only as a
limited review. The final report must include a context manifest and mark affected findings
as inference-based where missing declarations, UDTs, call paths, tag tables, or hardware
mapping prevent confirmation.

## Analysis workflow

The analysis is performed in sequential passes. Each pass loads one reference file,
analyzes the code through that specific lens, and produces findings.

**Critical instruction:** After each pass, Claude summarizes the findings from that pass
in a compact internal list before loading the next reference. This prevents token pressure
from accumulating raw analysis across all passes.

### Pass order

| Pass | Reference file | Focus |
|------|---------------|-------|
| 1 | `references/process-architect.md` | Physical plausibility and process context |
| 2 | `references/security-practices.md` | Top 20 Secure PLC Coding Practices + communication hardening |
| 3 | `references/threat-mapping.md` | MITRE ATT&CK for ICS technique identification |
| 4 | `references/compiler-critic.md` | Siemens platform bugs, CWE memory safety, safety boundary |
| 5 | `references/hardware-reviewer.md` | Hardware config, access settings, network security |

**Pass order rationale:** Process context comes first because understanding what the code
physically controls determines the severity of all subsequent findings. A missing range
check on a status indicator is Low; the same flaw on a chemical dosing pump is Critical.

### Per-pass procedure

Before starting the passes, build a compact context manifest:

- **Code:** pasted/exported blocks, block names, language, line/network references
- **Declarations:** VAR_INPUT, VAR_OUTPUT, VAR_IN_OUT, VAR_STATIC, VAR_TEMP, constants
- **Types:** UDTs, arrays, structures, optimized vs standard access metadata when known
- **Flows:** call tree, cross references, external write sources, HMI/SCADA inputs
- **Hardware:** CPU, communication settings, network interfaces, safety-related mapping
- **Verification:** baseline compile status if available, and whether simulation was run

For each pass:

1. Load the reference file
2. Work through every checklist item against the provided code
3. Record each finding with: severity, category tag, location, evidence, inference level,
   description, impact, remediation, and verification requirement
4. Produce a compact summary of findings from this pass
5. Proceed to next pass

After all passes, run a final verification synthesis:

- Challenge high/critical findings against the context manifest
- Downgrade or label findings that depend on missing UDTs, call paths, or hardware mapping
- Flag any proposed remediation that requires `compile_check`, simulation, or safety review
- Do not present generated PLC code as deployable without compile and engineering validation

### Hardware reviewer conditionality

If no hardware configuration data is available (user only provided code, no HW config,
no MCP access), the Hardware Reviewer pass still runs but produces a single finding:

```
#### [INFO] Hardware configuration not available
- **Category:** HW-REVIEW
- **Description:** No hardware configuration data was provided or retrievable.
  The following checks could not be performed: PUT/GET access status, web server
  settings, communication protocol security, access level configuration,
  protection level status.
- **Evidence:** No `read_hardware_config` result or hardware export was available.
- **Inference level:** Confirmed limitation
- **Verification required:** Provide hardware export or enable MCP hardware retrieval.
- **Remediation:** Provide hardware configuration export or enable MCP server
  access for a complete security assessment.
```

## Output format

After all passes complete, merge findings, deduplicate (same issue found by multiple passes
gets the highest severity assigned and cross-references both categories), and sort by severity.

```markdown
## PLC Code Analysis Report

**Analyzed:** [block names / file names]
**Input format:** SCL / SimaticML XML (LAD) / SimaticML XML (FBD)
**Analysis date:** [date]
**Passes completed:** Process Architect, Security Practices, Threat Mapping,
                      Compiler Critic, Hardware Reviewer, Verification Synthesis

### Context Manifest

| Context item | Status | Source |
|--------------|--------|--------|
| Block logic | Provided / Retrieved / Missing | Paste / file / `get_block_content` |
| Variable declarations | Complete / Partial / Missing | block interface / XML / YAML |
| UDT and array definitions | Complete / Partial / Missing | source / `get_block_content` |
| Call tree and cross references | Complete / Partial / Missing | `browse_project_tree` / `read_cross_references` |
| Tag tables and external inputs | Complete / Partial / Missing | `list_tag_tables` |
| Hardware and network config | Complete / Partial / Missing | `read_hardware_config` / export |
| Compile baseline | Clean / Warnings / Errors / Not run | `compile_check` / not available |

### Summary

| Severity | Count |
|----------|-------|
| CRITICAL | N |
| HIGH     | N |
| MEDIUM   | N |
| LOW      | N |
| INFO     | N |

### Findings

#### [CRITICAL] Finding title
- **Category:** TOP20-P08 / CWE-787 / T0836 / HW-PUTGET (one or more)
- **Location:** FB_MixerControl, Line 47 / Network 3
- **Evidence:** Direct source evidence or retrieved MCP context supporting the finding
- **Inference level:** Confirmed / Probable / Suspicious / Context-limited
- **Confidence:** High / Medium / Low
- **Description:** Clear explanation of the issue
- **Impact:** What could happen if this is exploited or left unaddressed
- **Remediation:** Specific, actionable fix with code example where applicable
- **Verification required:** compile_check / simulation / safety review / hardware review
- **References:** Relevant standard or practice citation

---

[... next finding ...]
```

### Severity definitions

| Severity | Criteria |
|----------|----------|
| CRITICAL | Direct risk to physical safety, process integrity, or enables remote code execution. Immediate action required. |
| HIGH | Significant security gap exploitable by network-level attacker, or logic flaw affecting process control under fault conditions. |
| MEDIUM | Violation of secure coding practice that increases attack surface or reduces defense-in-depth, but requires additional conditions to exploit. |
| LOW | Code quality or style issue that indirectly weakens security posture. Best-practice deviation without immediate risk. |
| INFO | Observation, recommendation, or note about missing context that prevented a complete check. |

## Limitations and honest reporting

Claude must NOT:

- Invent findings to fill the report — if a pass finds nothing, report "No issues identified"
- Speculate about code behavior without evidence from the provided source
- Claim certainty about runtime behavior that depends on CPU configuration not provided
- Hallucinate variable names, block numbers, or line references

Claude MUST:

- Clearly state when a finding is based on inference vs. direct evidence
- Note when analysis is limited by missing context (e.g., UDT definitions not provided)
- Distinguish between confirmed violations and suspicious patterns worth investigating
