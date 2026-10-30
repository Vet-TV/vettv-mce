# batocera-fork/

**Layer 1 — The Foundation.** Forked Batocera Linux source — Buildroot toolchain target.

This layer is the machine room: kernel, drivers, emulator backends, controller layer, audio/video stack, networking. The default Batocera EmulationStation frontend is **stripped** — it never boots. Godot owns the screen.

## What goes here

- Pinned upstream release image (see `UPSTREAM.md`) — Phase 1 forks at image level, no Buildroot rebuild yet
- VetTV overlay in `overlay/` (mirrors userdata paths): frontend user service, boot splash, settings
- A Batocera user service (`S99userservices` hook — Batocera is SysV-init, not systemd) that auto-launches the Godot frontend in place of EmulationStation
- Custom branding (boot splash, hostname, image metadata)
- Patches against upstream Batocera, kept reviewable

## What does NOT go here

- Anything user-facing — that's `frontend/`
- The Python daemon — that's `service-layer/`
- Build orchestration scripts — that's `scripts/`

## Build environment

Buildroot **must** run on the WSL2-native filesystem (`~/vettv-mce/...`), never on `/mnt/c/...`. See `docs/03_Windows11-Dev-Setup.md`.

## Phase status

- **Phase 0:** complete — vanilla Batocera boots in the test VM
- **Phase 1:** rebrand at image level (hostname, custom splash), ES replaced at runtime by the `vettv_frontend` user service, blank Godot app auto-launches, keyboard input verified in VM. Known limitation: ES can flash briefly during boot (see `UPSTREAM.md`)

## IP hygiene

- No Sony BIOS files bundled — user-sideloadable only
- No ROMs bundled, ever
- PS2/PS3 emulators (PCSX2, RPCS3) shipped as optional/sideloaded where legally prudent
- Track Switch (Ryujinx) legal status before v1.0
