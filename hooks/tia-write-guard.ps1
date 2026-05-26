$ErrorActionPreference = "Stop"

function Write-Allow {
    $response = @{
        decision = "allow"
        suppressOutput = $true
        hookSpecificOutput = @{
            hookEventName = "PreToolUse"
            permissionDecision = "allow"
        }
    }
    $response | ConvertTo-Json -Depth 10 -Compress
    exit 0
}

function Write-Deny {
    param([string] $Reason)

    $response = @{
        decision = "deny"
        reason = $Reason
        suppressOutput = $true
        hookSpecificOutput = @{
            hookEventName = "PreToolUse"
            permissionDecision = "deny"
            permissionDecisionReason = $Reason
        }
    }
    $response | ConvertTo-Json -Depth 10 -Compress
    exit 0
}

function Get-JsonProperty {
    param(
        [object] $Object,
        [string[]] $Names
    )

    if ($null -eq $Object) {
        return $null
    }

    foreach ($name in $Names) {
        $property = $Object.PSObject.Properties[$name]
        if ($null -ne $property) {
            return $property.Value
        }
    }

    return $null
}

$rawInput = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($rawInput)) {
    Write-Allow
}

try {
    $hookInput = $rawInput | ConvertFrom-Json
} catch {
    Write-Deny "TIA Portal write guard could not parse Claude Code hook input as JSON."
}

$toolName = [string](Get-JsonProperty -Object $hookInput -Names @("tool_name", "toolName"))
if ([string]::IsNullOrWhiteSpace($toolName)) {
    Write-Allow
}

$previewByWriteTool = @{
    "mcp__tia-portal__update_block_logic" = "preview_update_block_logic"
    "mcp__tia-portal__create_tag_table" = "preview_create_tag_table"
    "mcp__tia-portal__delete_tag_table" = "preview_delete_tag_table"
    "mcp__tia-portal__create_tag" = "preview_create_tag"
    "mcp__tia-portal__update_tag" = "preview_update_tag"
    "mcp__tia-portal__delete_tag" = "preview_delete_tag"
    "mcp__tia-portal__create_user_constant" = "preview_create_user_constant"
    "mcp__tia-portal__update_user_constant" = "preview_update_user_constant"
    "mcp__tia-portal__delete_user_constant" = "preview_delete_user_constant"
    "mcp__tia-portal__add_network_device" = "preview_add_network_device"
    "mcp__tia-portal__configure_network_device" = "preview_configure_network_device"
    "mcp__tia-portal__open_project" = "preview_open_project"
    "mcp__tia-portal__create_project" = "preview_create_project"
    "mcp__tia-portal__save_project" = "preview_save_project"
    "mcp__tia-portal__save_project_as" = "preview_save_project_as"
    "mcp__tia-portal__archive_project" = "preview_archive_project"
    "mcp__tia-portal__close_project" = "preview_close_project"
    "mcp_tia-portal_update_block_logic" = "preview_update_block_logic"
    "mcp_tia-portal_create_tag_table" = "preview_create_tag_table"
    "mcp_tia-portal_delete_tag_table" = "preview_delete_tag_table"
    "mcp_tia-portal_create_tag" = "preview_create_tag"
    "mcp_tia-portal_update_tag" = "preview_update_tag"
    "mcp_tia-portal_delete_tag" = "preview_delete_tag"
    "mcp_tia-portal_create_user_constant" = "preview_create_user_constant"
    "mcp_tia-portal_update_user_constant" = "preview_update_user_constant"
    "mcp_tia-portal_delete_user_constant" = "preview_delete_user_constant"
    "mcp_tia-portal_add_network_device" = "preview_add_network_device"
    "mcp_tia-portal_configure_network_device" = "preview_configure_network_device"
    "mcp_tia-portal_open_project" = "preview_open_project"
    "mcp_tia-portal_create_project" = "preview_create_project"
    "mcp_tia-portal_save_project" = "preview_save_project"
    "mcp_tia-portal_save_project_as" = "preview_save_project_as"
    "mcp_tia-portal_archive_project" = "preview_archive_project"
    "mcp_tia-portal_close_project" = "preview_close_project"
}

if (-not $previewByWriteTool.ContainsKey($toolName)) {
    Write-Allow
}

$toolInput = Get-JsonProperty -Object $hookInput -Names @("tool_input", "toolInput")
if ($null -eq $toolInput) {
    Write-Deny "TIA Portal write '$toolName' blocked: missing tool_input. Call $($previewByWriteTool[$toolName]) first, then retry with confirm=true and safetyToken."
}

$confirmProperty = $toolInput.PSObject.Properties["confirm"]
if ($null -eq $confirmProperty -or $confirmProperty.Value -ne $true) {
    Write-Deny "TIA Portal write '$toolName' blocked: confirm=true is required."
}

$tokenProperty = $toolInput.PSObject.Properties["safetyToken"]
if ($null -eq $tokenProperty -or [string]::IsNullOrWhiteSpace([string]$tokenProperty.Value)) {
    Write-Deny "TIA Portal write '$toolName' blocked: safetyToken is required. Call $($previewByWriteTool[$toolName]) first and pass the returned token."
}

Write-Allow
