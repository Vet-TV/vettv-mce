# Changelog

All notable changes to VetTV: Memory Card Edition. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning will follow [SemVer](https://semver.org/) once v1.0 ships.

## [Unreleased]

### Added
- `web/index.html` — parked-domain landing page for `vettv-mce.com`. Self-contained HTML, Space Grotesk + JetBrains Mono, IP-hygiene clean, Cloudflare Pages-ready
- `web/README.md` — deploy instructions and IP-hygiene review notes for the landing page

### Changed
- `docs/03_Windows11-Dev-Setup.md` — Git Strategy section now reflects **public repo from Phase 0**, protected `main` branch requiring `repo-checks` CI, and the Phase 5 frontend-license decision

## [0.1.0] — 2026-04 — Phase 0 launch-ready

### Added
- Per-folder READMEs for `frontend/`, `service-layer/`, `batocera-fork/`, `scripts/`, `assets/`, `licenses/`
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`
- GitHub issue templates: bug, feature, IP-hygiene flag
- GitHub PR template with phase + IP-hygiene checklist
- `CHANGELOG.md` and `.editorconfig`
- CI workflow: markdown lint + license-tracking sanity check + foundation-doc presence
- Main README polished with status, phase navigation, doc index

## [0.0.1] — 2026-04 — Phase 0 scaffold

### Added
- Initial repo scaffolding: `frontend/`, `service-layer/`, `batocera-fork/`, `scripts/`, `assets/`, `licenses/`, `docs/`
- Foundation docs: blueprint, IP hygiene rules, Windows 11 dev setup, communication preferences, hardware specs
- Project README and identity
- License (GPLv2 inherited target)
