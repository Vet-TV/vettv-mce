# Security Policy

## Supported versions

VetTV MCE is pre-release. There are no supported versions yet. Once v1.0 ships, the latest stable image is the only supported line.

| Version | Supported |
| --- | --- |
| Phase 0–6 (pre-release) | development snapshots only |
| v1.0+ | latest stable image only |

## Reporting a vulnerability

**Do not open a public issue for security problems.** Use one of the following:

1. **Preferred:** GitHub private security advisory — *Security* tab on this repo → *Report a vulnerability*
2. DM `@Vet_TV` on X with the words "security report" in the first line; expect a follow-up channel for details

Include:
- A clear description of the issue
- Steps to reproduce, or a proof of concept
- The image build / commit hash where you observed it
- Your suggested severity, if you have an opinion

## What's in scope

- The OS image (kernel/userspace as shipped by VetTV MCE — not vanilla upstream Batocera bugs)
- The Python service layer (Unix-socket IPC, save-state handling, launcher behavior)
- The Godot frontend (input handling, controller passthrough, anything that crosses a trust boundary)
- Build, packaging, and update mechanisms once they exist

## What's out of scope

- Issues only reachable by a user with physical access and admin intent (this is a console OS — that's expected)
- Vulnerabilities in upstream emulators, RetroArch cores, or cloud-gaming wrappers — report those upstream
- Reports that depend on user-sideloaded BIOS files or ROMs

## Response targets

Single-maintainer project. Realistic targets:

- Acknowledgement: within 7 days
- Severity assessment: within 14 days
- Fix or mitigation plan: within 30 days for high/critical

## Disclosure

Coordinated disclosure. We'll agree on a date together; default is fix-available + 14 days.
