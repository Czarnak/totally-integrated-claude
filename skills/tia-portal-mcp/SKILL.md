---
name: tia-portal-mcp
description: >
  Use when the TIA Portal MCP server is available for focused, guarded project
  reads and writes. Use TIA Openness skills for complex multi-step automation.
license: MIT
---

# tia-portal-mcp

## Scope

Use this skill for direct TIA Portal interaction through the MCP server. The
server exposes exactly ten public MCP tools: three batch tools and seven project
lifecycle tools. Internal worker operations, including lifecycle probes, are not
MCP-visible tools.

Use MCP for exploration, inspection, and bounded changes. For loops, bulk
automation, or an operation outside this surface, use `tia-openness-roadmap`.

## Public tool surface

### Data operations

| Tool | Purpose |
|---|---|
| `execute_read_batch` | Run up to 50 independent read operations. |
| `preview_write_batch` | Preview up to 50 data-write operations and obtain one batch safety token. |
| `apply_write_batch` | Apply the exact previewed write batch sequentially; stop on the first failure and mark remaining items skipped. There is no transaction or rollback. |

Read-operation names include `browse_project_tree`, `get_block_content`,
`list_tag_tables`, `read_hardware_config`, `read_cross_references`,
`search_equipment_catalog`, `compile_check`, and `get_project_status`. Data-write
operation names include block, tag-table, tag, user-constant, and network-device
operations such as `update_block_logic`, `create_block`, `create_tag`, and
`add_network_device`.

### Project lifecycle

| Tool | Purpose |
|---|---|
| `get_project_status` | Inspect the currently open project. |
| `open_project` | Deliberately open or switch to a project. |
| `create_project` | Create a project. |
| `save_project` | Save the open project. |
| `save_project_as` | Copy the open project and rebind to the copy. |
| `archive_project` | Create an archive of the open project. |
| `close_project` | Close the open project. |

`get_project_status(projectPath)` is read-only and non-binding. It never opens
or switches a project, including when `projectPath` names a different project.
Use `open_project` for deliberate session switching. If a bound session names a
different path in a status request, the result is `binding_conflict`; do not use
status as a switching mechanism.

## Safety convention

All writes use single-use, short-lived safety tokens bound to the normalized
project path, exact input, target, and current project state. Never invent or
reuse a token.

For data writes:

1. Send the full ordered `operations` array to `preview_write_batch`.
2. Review the preview and its `safetyToken`.
3. Send the unchanged array to `apply_write_batch` with `confirm:true` and that token.

For lifecycle writes, the tool previews itself: call the lifecycle tool without
a `safetyToken` to receive a preview and token, then call the same tool with the
same input, `confirm:true`, and the token to apply. Lifecycle writes remain
single-tool only and cannot be placed in a data batch.

`save_project_as` requires `rebind:true`. Passing `rebind:false` is rejected as
`validation_error` before preview, token issuance, Siemens `SaveAs`, or audit
effects. After a successful SaveAs, continue with the worker-reported copied
project path; do not assume a caller-supplied path is authoritative.

Never automatically retry a write after `worker_timeout`, `worker_crashed`, or
protocol loss. The outcome may be uncertain: inspect current state before a new,
separately authorized request.

## Failures and warnings

Write failures return `failureCategory` with a human-readable error. Supported
categories: `validation_error`, `binding_conflict`, `state_changed`,
`worker_operation_failed`, `worker_timeout`, `worker_crashed`, and
`postcondition_failed`.

`warnings` is a separate array of non-fatal degradation notes. A warning never
turns a failure into a success, and a failure category is never hidden by
warnings. Treat any warning as a signal that the returned payload can be partial.

## Block write guidance

Read a block through `execute_read_batch` using `get_block_content`; use the
returned SIMATIC ML documents as the source for a change. For
`update_block_logic`, send a validated document bundle in a guarded data batch.
The verified flow performs one import, compilation verification, and a non-empty
re-export. Preserve unchanged documents exactly where possible; duplicate,
malformed, or unsafe documents are rejected before any Siemens import, leaving
the existing block unchanged.

For `create_block` with SCL, provide the requested block type and language in a
guarded batch. The generated source has a non-empty Structured Text compile unit.
After apply, resolve the requested block path and run `compile_check` to confirm
it exists and compiles.

## Common execution patterns

### Inspect a block

1. Run `execute_read_batch` with `browse_project_tree` to find the block path.
2. Run `execute_read_batch` with `get_block_content` for that path.
3. Analyze the returned documents before deciding whether a write is needed.

### Modify a block

1. Read the current documents with `execute_read_batch`.
2. Make one focused, validated document change.
3. Preview `update_block_logic` with `preview_write_batch`.
4. Confirm intent, then apply the unchanged batch with `apply_write_batch`,
   `confirm:true`, and the returned token.
5. Review compilation and re-export verification. On an uncertain outcome, read
   current state instead of retrying automatically.

### Switch projects safely

1. Inspect the open project with `get_project_status` if needed.
2. Preview `open_project` by calling it without a `safetyToken`.
3. Apply the same request with `confirm:true` and its token.
4. Verify the worker-reported path with `get_project_status`.

### Add and configure a device

1. Read the hardware catalog through `execute_read_batch` and copy the exact
   `typeIdentifier`.
2. Preview ordered add/configure operations in one `preview_write_batch` request.
3. Confirm the identity and network values, then apply the unchanged batch.
4. Read hardware configuration and compile results to verify the change.

### Audit unused objects

1. Run `execute_read_batch` with `read_cross_references` and `filter="UnusedObjects"`.
2. Present the findings before proposing any deletion.
