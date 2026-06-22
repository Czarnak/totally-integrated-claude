# Security Policy

## Supported Versions

Security fixes are provided for the latest release and the current `main`
branch. Older releases are not supported; users should upgrade before
reporting an issue.

| Version | Supported |
| --- | --- |
| Latest release | Yes |
| `main` | Yes |
| Older releases | No |

## Reporting a Vulnerability

Do not disclose vulnerability details in a public issue, discussion, pull
request, or social-media post.

Use GitHub's **Report a vulnerability** option on the repository's
[Security page](https://github.com/Czarnak/totally-integrated-claude/security)
when it is available. If private vulnerability reporting is unavailable,
open a [new issue](https://github.com/Czarnak/totally-integrated-claude/issues/new)
with the title `[Security] Private contact requested`. Do not include technical
details in that issue. A maintainer will establish a private channel for the
report.

Once a private channel is available, include:

- the affected version or commit;
- the vulnerability's impact and required preconditions;
- minimal reproduction steps or a proof of concept;
- any known mitigations or suggested remediation; and
- whether the issue has been disclosed elsewhere.

Reports should receive an initial response within seven days. The maintainer
will validate the report, coordinate remediation, and agree on a disclosure
timeline with the reporter. Confirmed vulnerabilities may be documented in a
GitHub Security Advisory after a fix is available.

## Scope

Security issues in this repository include vulnerabilities in its skills,
prompts, scripts, hooks, configuration, packaging, and documented automation
patterns. Examples include command or prompt injection, credential exposure,
unsafe file or process handling, authorization bypasses, supply-chain risks,
and guidance that can cause unintended destructive TIA Portal operations.

Vulnerabilities that exist solely in Siemens products, AI platforms,
third-party MCP servers, or other dependencies should be reported to the
responsible upstream project. Report them here only when this plugin's
integration introduces or materially worsens the vulnerability.

## Safe Research Guidelines

- Test only systems and projects you own or are explicitly authorized to use.
- Do not test against live production equipment, safety systems, PLCs, HMIs,
  drives, or operational industrial networks.
- Avoid destructive actions, persistence, service disruption, data access
  beyond what is necessary, and access to other users' information.
- Stop testing immediately if an action could affect physical processes,
  personnel safety, or equipment availability.
- Retain vulnerability details privately until remediation and disclosure are
  coordinated with the maintainer.

Good-faith research that follows these guidelines will be handled
constructively and with the goal of resolving the reported issue.
