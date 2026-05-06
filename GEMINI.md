# Totally Integrated Gemini

Use the bundled Agent Skills as the primary source of guidance for Siemens TIA
Portal work. For any TIA Portal, TIA Openness, TIA Scripting, PLC, HMI,
devices, networks, drives, import/export, or Add-In task, activate the
`tia-openness-roadmap` skill first and follow its routing instructions.

The roadmap skill selects the right implementation path.

The extension also declares the `tia-portal` MCP server using the `tia-mcp`
command. The MCP server must be installed separately on the user's machine.

This can be done with

```sh
dotnet tool install -g TiaMcpServer
```
