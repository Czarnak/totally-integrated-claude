# Contributing

Thanks for improving `totally-integrated-claude`. This repository ships agent
skills, manifests, hooks, and bundled language-server configuration for Siemens
TIA Portal automation. Changes should stay portable across Claude Code, Codex,
and Antigravity unless a file is explicitly client-specific.

## Development Setup

Work from a local checkout on Windows when changing TIA-specific behavior. The
repository has no required package install step for normal validation.

Recommended tools:

- PowerShell 7 (`pwsh`) for validation and tests.
- Windows PowerShell 5.1 compatibility for `skills/tia-doctor/probe.ps1`.
- Pester 5.7.1 for PowerShell tests. CI installs this pinned version.
- TIA Portal V17 or later when manually verifying Openness, TIA Scripting, or MCP
  behavior.

Optional local environment check:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\skills\tia-doctor\probe.ps1
```

## Validation Before Pull Requests

Run these commands before opening a PR:

```powershell
pwsh -NoProfile -File .\scripts\validate-repo.ps1
pwsh -NoProfile -Command "Invoke-Pester -Path .\tests -ExcludeTagFilter ReferenceAudit -CI"
git diff --check
```

The validator checks:

- Manifest JSON shape for Claude, Codex, Antigravity, and marketplace metadata.
- Version sync across `.claude-plugin/plugin.json`,
  `.codex-plugin/plugin.json`, and `plugin.json`.
- Referenced paths in manifests and `tia-openness-roadmap`.
- `SKILL.md` frontmatter with `name` and `description`.
- The committed V21 API baselines and their documentation catalogue mappings.

## Skill Authoring Rules

- Keep each skill focused on one domain or routing responsibility.
- Every `SKILL.md` must start with YAML frontmatter containing `name` and
  `description`.
- Add reference files under the skill's own `references/` directory when the
  skill needs detailed API tables or long examples.
- Update `skills/tia-openness-roadmap/SKILL.md` whenever a new skill should be
  reachable through routing.
- For C# Openness changes, preserve the mandatory safety guidance in
  `skills/tia-csharp-common/SKILL.md`.
- For Python TIA Scripting changes, preserve the mandatory destructive-operation
  guidance in `skills/tia-python/SKILL.md`.

## Safety Requirements

TIA Portal automation can mutate real engineering projects. Treat safety checks
as part of the public interface.

- Do not weaken the preview-token flow for MCP write tools.
- Do not bypass `confirm=true` and `safetyToken` requirements in
  `hooks/tia-write-guard.ps1`.
- Never document bare destructive calls such as `.Delete()` or `delete()` as
  safe examples.
- Generated C# Openness mutations must use `ExclusiveAccess` and `Transaction`
  where the API permits it.
- Generated Python TIA Scripting mutations must use
  `project.start_transaction()` / `project.end_transaction()` where supported.
- Require compile or validation checks before presenting generated project
  changes as deployable.

## Tests

Add or update tests with behavior changes:

- Hook logic: `tests/tia-write-guard.Tests.ps1`.
- Portable skill safety contracts: `tests/safety-contract.Tests.ps1`.
- Certified API baseline behavior: `tests/api-baseline.Tests.ps1`.
- Hosted/manual test boundaries: `tests/ci-scope.Tests.ps1`.
- Exact installed-V21 reference audit: `tests/skill-content.Tests.ps1` with the
  `ReferenceAudit` tag.
- Doctor probe helper behavior: `tests/tia-doctor.Tests.ps1`.
- Repository metadata validation: `scripts/validate-repo.ps1`.

Hosted CI runs all tests except `ReferenceAudit` and validates committed API
evidence without requiring TIA Portal. Run the strict audit after an intentional
Openness/documentation update:

```powershell
pwsh -NoProfile -Command "Invoke-Pester -Path .\tests -TagFilter ReferenceAudit -CI"
```

The installed-API extractor and comparison workflow is documented in
[`api-baselines/README.md`](api-baselines/README.md). Any check that needs a real
TIA Portal process, license, project, or device remains an explicit manual step.

## Manifest And Release Notes

When changing user-facing capabilities:

- Update the relevant manifest descriptions if the capability changes.
- Keep all manifest versions synchronized.
- Update `README.md` when installation, usage, prerequisites, routing, or safety
  behavior changes.
- Avoid adding new top-level docs unless the content does not fit the README,
  this contributor guide, or an existing skill reference.

## Pull Request Checklist

- [ ] `pwsh -NoProfile -File .\scripts\validate-repo.ps1` passes.
- [ ] `pwsh -NoProfile -Command "Invoke-Pester -Path .\tests -ExcludeTagFilter ReferenceAudit -CI"` passes.
- [ ] `ReferenceAudit` was run when installed V21 API or exact reference content changed.
- [ ] `git diff --check` passes.
- [ ] New or changed skills are reachable from the roadmap when appropriate.
- [ ] Safety-sensitive changes include tests or a documented manual verification.
- [ ] No hardcoded secrets, credentials, machine-specific paths, or private
      project data are committed.
