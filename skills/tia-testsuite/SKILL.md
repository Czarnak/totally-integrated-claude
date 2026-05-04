---
name: tia-testsuite
description: >
  TIA Portal TestSuite and Application Test operations. Use for managing test sets,
  application tests, style guide rules, and automated system testing workflows.
---

# TIA Portal TestSuite — Automated Testing

## Scope

Automated testing using the TIA Portal TestSuite Openness API.
Covers Application Tests (PLC-based), Style Guide (Static analysis), and System Tests (OPC UA based).

---

## Reference files

Load ONLY the reference file(s) relevant to the task. Do not load all files at once.

| Reference file | Load when the task involves |
|---|---|
| `references/application-test.md` | Managing PLC Application Test sets, groups, and cases; executing tests on simulation. |
| `references/style-guide.md` | Managing and executing Style Guide rule sets; updating rule set files. |
| `references/system-test.md` | Managing System Test cases; OPC UA server interface validation. |
| `references/test-results.md` | Accessing and interpreting TestSuite service results and execution states. |

---

## Key Workflows

### Application Testing

1. Locate the `TestSuiteService` on the Project.
2. Access `ApplicationTestSets` composition.
3. Manage `ApplicationTestSet` and `TestCase` objects.
4. Execute tests via `TestCaseExecutor`.

### Style Guide

1. Access `StyleGuideSystemGroups` on the `TestSuiteService`.
2. Manage `RuleSet` objects and compositions.
3. Execute checks via `RuleSetExecutor`.

### System Testing

1. Access `SystemTestSystemGroups` on the `TestSuiteService`.
2. Manage `SystemTestCase` objects.
3. Execute tests via `SystemTestCaseExecutor`.

## Enforcement

1. Verify the existence of the target PLC software or OPC UA server before running tests.
2. Properly handle test failures using the `TestResults` and `TestResultsMessage` properties.
