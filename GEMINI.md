# Totally Integrated Claude for Gemini CLI

Use the bundled Agent Skills as the primary source of guidance for Siemens TIA
Portal work. For any TIA Portal, TIA Openness, TIA Scripting, PLC, HMI,
devices, networks, drives, import/export, or Add-In task, activate the
`tia-openness-roadmap` skill first and follow its routing instructions.

The roadmap skill selects the right implementation path:

- `tia-python` for Python TIA Scripting tasks.
- `tia-csharp-common` plus the relevant C# domain skill for TIA Openness API
  tasks.
- `addin-operations` for TIA Portal Add-In development.

The extension also declares the `tia-portal` MCP server using the `tia-mcp`
command. The MCP server must be installed separately on the user's machine.
