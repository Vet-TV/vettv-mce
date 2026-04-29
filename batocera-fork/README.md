# batocera-fork/

**Layer 1 — The Foundation.** Forked Batocera Linux source — Buildroot toolchain target.

This layer is the machine room: kernel, drivers, emulator backends, controller layer, audio/video stack, networking. The default Batocera EmulationStation frontend is **stripped** — it never boots. Godot owns the screen.

## What goes here

- The forked Batocera tree (added as a subtree or submodule once Phase 1 begins)
- VetTV-specific Buildroot package overlays
- systemd unit that auto-launches the Godot frontend in place of EmulationStation
- Custom branding (boot splash, hostname, image metadata)
- Patches against upstream Batocera, kept reviewable

## What does NOT go here

- Anything user-facing — that's `frontend/`
- The Python daemon — that's `service-layer/`
- Build orchestration scripts — that's `scripts/`

## Build environment

Buildroot **must** run on the WSL2-native filesystem (`~/vettv-mce/...`), never on `/mnt/c/...`. See `docs/03_Windows11-Dev-Setup.md`.

## Phase status

- **Phase 0:** vanilla Batocera builds and boots in Hyper-V VM
- **Phase 1:** rebrand at image level, strip ES, systemd auto-launches blank Godot app, controller input verified

## IP hygiene

- No Sony BIOS files bundled — user-sideloadable only
- No ROMs bundled, ever
- PS2/PS3 emulators (PCSX2, RPCS3) shipped as optional/sideloaded where legally prudent
- Track Switch (Ryujinx) legal status before v1.0
