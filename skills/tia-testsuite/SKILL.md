---
name: tia-testsuite
description: >
  TIA Portal V21 Test Suite operations. Use for Application Tests with PLCSIM,
  Style Guide rules, System Tests through OPC UA, import/scope management,
  execution, and recursive result evaluation.
license: MIT
---

# TIA Portal Test Suite — Automated Testing

## Scope

The installed `Siemens.Engineering.TestSuite` API covers Application Test,
Style Guide, and System Test. These are different execution environments and
must not share safety assumptions.

## Reference files

Load ONLY the reference file(s) relevant to the task. Do not load all files at once.

| Reference file | Load when the task involves |
|---|---|
| `references/application-test.md` | Application Test sets/cases, PLCSIM execution modes, import, scope, and execution. |
| `references/style-guide.md` | Style Guide rule sets, import, scope update, and execution. |
| `references/system-test.md` | System Test cases, OPC UA endpoints/interfaces, import, scope, and execution. |
| `references/test-results.md` | Recursive result/message interpretation and pass/fail gates. |

## Installed V21 root

```csharp
TestSuiteService service = project.GetService<TestSuiteService>();

ApplicationTestSystemGroup application = service.ApplicationTestGroup;
StyleGuideSystemGroup styleGuide = service.StyleGuideGroup;
SystemTestSystemGroup system = service.SystemTestGroup;
```

The groups are singular properties. Resolve test sets, cases, and rule sets by
exact name and expected scope; never select `.First()` or `[0]`.

## Executor ownership

Executors are group services:

```csharp
TestCaseExecutor applicationExecutor =
    service.ApplicationTestGroup.GetService<TestCaseExecutor>();
RuleSetExecutor styleExecutor =
    service.StyleGuideGroup.GetService<RuleSetExecutor>();
SystemTestCaseExecutor systemExecutor =
    service.SystemTestGroup.GetService<SystemTestCaseExecutor>();
```

Every `Run(...)` returns `TestResults`. Apply the recursive result gate from
`references/test-results.md`; a returned object alone is not a passing test.

## Permission and safety enforcement

1. V21 introduces the `Edit Test Suite data` user right. Require it before importing, deleting, or changing test sets, cases, rule sets, or scope.
2. Treat imported test/rule files as untrusted input. Validate the exact file, provenance, intended objects, load options, and resulting identities before saving the project.
3. `ImportOptions.Override` and scope replacement are destructive. Require explicit project-write authorization and an inventory of affected objects.
4. Application Tests execute through PLCSIM. Require explicit simulator-execution authorization and distinguish system-managed from externally managed instances.
5. System Tests use OPC UA and may target a live controller or other production endpoint. Require explicit live-operation authorization, the exact OPC UA endpoint/interface, credential/security expectations, and an approved test case. Never assume simulation.
6. Style Guide execution is static, but imports and scope changes still mutate the project.
7. Do not save the project unless requested. Do not claim success until top-level and nested result states, counts, and messages all pass the result gate.

## Evidence boundary

Installed V21 assemblies/XML prove API names, signatures, types, and enum members.
Project permissions, PLCSIM availability/identity, OPC UA reachability/security,
test side effects, and actual results require an authorized runtime test.
