# tia-import-export — reference catalogue

> **This is a C# Openness reference for the import/export domain.**
> When routed here, the entire solution is C# — do not mix with Python.

## C# references

Main Openness areas:

- project texts / graphics
- HMI XML import/export
- PLC SimaticML import/export
- technology object import/export
- AML / CAx hardware and topology import/export
- library archive/retrieve
- object-specific import/export compositions

## Post-import validation

1. refresh object references
2. compile relevant hardware/software
3. inspect consistency state
4. validate fingerprints or paths where available

## Escalation triggers (what forces C# over Python)
- object type not covered by Python wrapper
- import/export mixed with low-level object edits
- unsupported SimaticML / AML behavior
- explicit Openness-only import/export control
