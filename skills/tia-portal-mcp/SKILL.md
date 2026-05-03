---
name: tia-portal-mcp
description: >
  Use when the TIA Portal MCP server is available and the task involves reading
  or modifying a TIA Portal project interactively: browsing the project tree,
  reading or writing PLC block logic (SIMATIC SD YAML), listing tag tables,
  inspecting hardware config, running cross-reference diagnostics, searching the
  equipment catalog, adding/configuring network devices, or running compile checks.
  Prefer MCP tools over TIA Openness scripts for single read/write operations;
  use TIA Openness (tia-python or C# skills) for complex multi-step automation.
---

# tia-portal-mcp

## Scope

Direct TIA Portal interaction via MCP tools — no code generation required.
Use MCP tools for exploration, inspection, and targeted single-step modifications.
For bulk automation, looped operations, or scripted workflows, fall back to `tia-openness-roadmap`.

---

## When MCP is the right choice

| Situation | Use |
|---|---|
| Explore project structure before writing code | MCP `browse_project_tree` |
| Read a block to understand logic or generate code | MCP `get_block_content` |
| Apply a focused, one-shot block edit | MCP `update_block_logic` |
| List tags for context or documentation | MCP `list_tag_tables` |
| Inspect hardware topology / IP addresses | MCP `read_hardware_config` |
| Find unused or unreferenced objects | MCP `read_cross_references` |
| Add a single device to the project | MCP `search_equipment_catalog` → `add_network_device` |
| Check compile errors before or after edits | MCP `compile_check` |
| Complex loops / bulk changes over many blocks | `tia-openness-roadmap` instead |

---

## Safety convention

Three tools are **write-protected** and require the caller to pass `confirm: true` explicitly.
Never pass `confirm: true` without first reading back the current state and confirming intent with the user.

| Tool | Write-protected |
|---|---|
| `update_block_logic` | yes — requires `confirm: true` |
| `add_network_device` | yes — requires `confirm: true` |
| `configure_network_device` | yes — requires `confirm: true` |

---

## Tool reference

### browse_project_tree
Recursively enumerates the project: devices, PLC software, block folders, blocks, tag tables, types.

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `projectPath` | string | no | Path to `.ap21` file; defaults to currently open project |

Returns JSON tree. Use returned `Path` values as `blockPath` input for other tools.

---

### get_block_content
Exports a PLC block as a **SIMATIC SD YAML** document. Supports SCL, LAD, FBD, GRAPH, STL, and Data Blocks.

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `blockPath` | string | yes | `BlockName`, `PLC_1/BlockName`, or `PLC_1/Blocks/Folder/.../BlockName` |
| `projectPath` | string | no | |

Returns YAML string. Parse or display as-is; pass back (modified) to `update_block_logic`.

---

### update_block_logic
Imports SIMATIC SD YAML to update or create a PLC block. Always call `get_block_content` first
to obtain the current YAML before editing, unless creating a block from scratch.

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `blockPath` | string | yes | Target block path |
| `yamlContent` | string | yes | Valid SIMATIC SD YAML |
| `confirm` | bool | yes | Must be `true` to execute — default `false` is a no-op |
| `projectPath` | string | no | |

---

### list_tag_tables
Retrieves all PLC tag tables with tags and user constants.

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `plcName` | string | no | Filter to a specific PLC |
| `projectPath` | string | no | |

Returns JSON array of tag tables.

---

### read_hardware_config
Exports hardware configuration and network topology: devices, rack modules, network interfaces,
IP addresses, PROFINET device names, subnets, and IO systems.

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `projectPath` | string | no | |

---

### read_cross_references
Exports PLC cross-reference diagnostics with source objects, referenced objects, locations,
access types, and reference types.

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `projectPath` | string | no | |
| `plcName` | string | no | Filter to a specific PLC |
| `filter` | string | no | `AllObjects` \| `ObjectsWithReferences` \| `ObjectsWithoutReferences` \| `UnusedObjects` |

Use `UnusedObjects` to find dead code before cleanup.

---

### search_equipment_catalog
Searches the installed TIA Portal V21 hardware catalog (including GSD/HSP packages) by type
name, article number, or description. Always run before `add_network_device`.

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `query` | string | yes | Free-text search |
| `projectPath` | string | no | |

Returns entries with `typeIdentifier` values — copy the exact identifier into `add_network_device`.

---

### add_network_device
Inserts a device from the hardware catalog into the project.

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `typeIdentifier` | string | yes | Exact value from `search_equipment_catalog` |
| `deviceName` | string | yes | Name for the new device in the project |
| `deviceItemName` | string | no | Name for root device item; defaults to `deviceName` |
| `confirm` | bool | yes | Must be `true` to execute |
| `projectPath` | string | no | |

---

### configure_network_device
Sets network identity and interface properties for a device already present in the project.

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `deviceName` | string | yes | Device to configure |
| `ipAddress` | string | no | IPv4 address |
| `subnetMask` | string | no | Subnet mask |
| `pnDeviceName` | string | no | PROFINET device name |
| `subnetName` | string | no | Subnet to connect to |
| `ioSystemName` | string | no | IO system to connect to |
| `confirm` | bool | yes | Must be `true` to execute |
| `projectPath` | string | no | |

---

### compile_check
Invokes TIA Portal compile on PLC software and returns errors and warnings.

| Parameter | Type | Required | Notes |
|---|---|---|---|
| `blockPath` | string | no | Compile a single block; omit to compile full PLC software |
| `plcName` | string | no | Target a specific PLC; omit to compile all PLCs |
| `projectPath` | string | no | |

---

## Common execution patterns

### Read and understand a block
1. `browse_project_tree` — find the block path
2. `get_block_content(blockPath)` — read SIMATIC SD YAML
3. Analyze or present the content

### Modify a block
1. `get_block_content(blockPath)` — capture current YAML
2. Edit the YAML (preserve structure and indentation)
3. Show the diff to the user and confirm
4. `update_block_logic(blockPath, yamlContent, confirm=true)`
5. `compile_check(blockPath)` — verify no errors introduced

### Add and configure a new device
1. `search_equipment_catalog(query)` — find the exact `typeIdentifier`
2. Confirm device and name with user
3. `add_network_device(typeIdentifier, deviceName, confirm=true)`
4. `configure_network_device(deviceName, ipAddress, ..., confirm=true)`
5. `read_hardware_config` — verify result

### Audit unused objects
1. `read_cross_references(filter="UnusedObjects")` — list unreferenced objects
2. Present findings to user before any removal action

### Pre-edit compile baseline
1. `compile_check` — record baseline errors/warnings
2. Apply changes
3. `compile_check` again — compare to baseline
