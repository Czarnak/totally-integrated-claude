# TIA Portal Add-In — Permissions & Process API Reference

Source: TIA Portal Add-In Development Tools Manual (V21)

This reference covers security permissions and process management within Add-Ins.

## Process Start Permissions

TIA Portal Add-Ins run in a sandbox. To launch external processes, you must use the specialized permission classes and utility wrappers.

### ProcessStartPermission
>
> Custom Permission to control external process execution.

- `ProcessStartPermission(PermissionState)`: Sets the restriction state.
- `ProcessStartPermission(bool)`: Explicitly sets restricted/unrestricted state.
- `IsUnrestricted()`: Returns true if the Add-In has permission to start processes.

### ProcessStartPermissionAttribute
>
> Declarative attribute for process start permissions.

- `ProcessStartPermissionAttribute(SecurityAction)`: Used on classes or methods to declare permission requirements.

## Process Utilities

Do NOT use `System.Diagnostics.Process` directly; it will likely be blocked by the sandbox unless the Add-In is highly privileged. Use the Siemens utility wrapper instead.

### Siemens.Engineering.AddIn.Utilities.Process
>
> Wrapper for process management in Add-Ins.

- `Start(string fileName)`: Starts a process.
- `Start(string fileName, string arguments)`: Starts a process with arguments.
- `Kill()`: Terminates the process.
- `WaitForExit()`: Waits indefinitely for the process to exit.
- `StandardOutput`: Access to the process output stream.
- `StandardError`: Access to the process error stream.

### Siemens.Engineering.AddIn.Utilities.ProcessStartInfo
>
> Configuration for starting processes via the wrapper.

- `FileName`: The path to the executable.
- `Arguments`: Command line arguments.
- `WorkingDirectory`: The initial directory for the process.
- `UseShellExecute`: Whether to use the OS shell to start the process.
- `RedirectStandardOutput / RedirectStandardError`: Control stream redirection.
