# Changelog

All notable changes to VetTV: Memory Card Edition. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning will follow [SemVer](https://semver.org/) once v1.0 ships.

## [Unreleased]

### Added

- Phase 1 blank Godot frontend: `frontend/project.godot`, `main.tscn`, `main.gd` (dark window, title, live input readout, Esc quits), original `icon.svg`, Linux x86_64 export preset
- atocera-fork/overlay/userdata/system/services/vettv_service + scripts/inject-service.sh - runs the service in the VM next to ettv_frontend
- Phase 2 dashboard scaffolding: six Memory Cards with placeholder tile grids (`frontend/card_data.gd`, `card_face.gd`, dashboard controller in `main.gd`), D-pad/keyboard navigation (Left/Right cards, Enter opens, arrows browse tiles, Esc back), live clock, ambient particles, 90-second idle Ambient Mode, Windows export preset for host-side testing
- Phase 3 Retro service layer: service-layer/src/vettv_service/ (FastAPI on 127.0.0.1:8471) - ROM scanner with era grouping and clean titles, emulatorlauncher launch wrapper with path validation and single-game guard, Memory Card save listing (.state* / .srm), health/systems/games/saves/launch/stop/status endpoints, 6 API tests
- `scripts/boot-vm.ps1` — start / stop / status / screenshot the test VM (VirtualBox 7)
- `web/index.html` — parked-domain landing page for `vettv-mce.com`. Self-contained HTML, Space Grotesk + JetBrains Mono, IP-hygiene clean, Cloudflare Pages-ready
- `web/README.md` — deploy instructions and IP-hygiene review notes for the landing page

### Changed

- `docs/03_Windows11-Dev-Setup.md` — Git Strategy section now reflects **public repo from Phase 0**, protected `main` branch requiring `repo-checks` CI, and the Phase 5 frontend-license decision

### Verified

- **Phase 0 complete:** vanilla Batocera 43.1 (x86_64) boots to EmulationStation in the `VetTV-MCE-Phase0` VM (UEFI, 8 GB RAM, 4 vCPU, 64 GB disk); keyboard input verified (system carousel navigates). Evidence screenshots kept locally with the VM, outside the repo
- Dev host toolchain: Godot 4.7.2 Mono + Linux export templates, VS Code extensions, WSL2 build packages installed. Hyper-V role not enabled on this host (needs elevation + reboot); VirtualBox fallback in use per `docs/03`
- Phase 1 blank frontend exports for Linux x86_64 and smoke-runs under WSL (starts and stays running, no script errors)
- **Phase 1 complete:** Batocera 43.1 image-level fork in `batocera-fork/` (pinned upstream + userdata overlay). After a clean reboot the VM boots to the blank VetTV Godot frontend: `vettv_frontend` user service stops EmulationStation and launches the app fullscreen, hostname is `VETTV-MCE`, custom VetTV splash deployed, keyboard input verified in the frontend. Known limitations: ES is visible briefly during boot before the handoff; Godot load takes minutes under VirtualBox software rendering (VM-only)
- Phase 3 service verified live in the VM: /health ok, /systems returns 12 systems / 25 games (Batocera bundled homebrew) grouped as 8-bit, 16-bit, 32/64-bit and More Systems; Retro card drills era -> system -> games against the live service on host (dry-run launch) and in the VM (Commodore 64 / fix_it_felix_64). Real emulator takeover from the dashboard, ScreenScraper metadata and gamepad input not yet verified
- **Phase 2 complete:** dashboard verified live in the VM (card navigation, tile open/browse/activate/back, clock) and Ambient Mode verified on the Windows export (VirtualBox frame presentation stalls without input, so idle visuals were proven on host). Service hardened in the process: live X display detection (`:0`/`:1`), ES wrapper-aware stop, zombie-safe restart guard

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
