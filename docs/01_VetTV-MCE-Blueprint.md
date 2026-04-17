# VetTV: Memory Card Edition — Master Blueprint

**Version:** 1.0
**Status:** Phase 0 — Toolchain Verification
**Last updated:** April 2026

---

## 1. Project Identity

**Product name:** VetTV: Memory Card Edition
**Short name:** VetTV MCE
**Tagline options:** *"Your memories, remastered."* / *"Press Start. Welcome Home."* / *"The dashboard that remembers."*
**Category:** Retro-futurist console OS with integrated cloud gaming
**License target:** GPLv2 (inherited from Batocera base) — custom frontend layer licensing TBD (MIT or proprietary)

---

## 2. The Three-Layer Architecture

**Layer 1 — The Foundation (Batocera fork, headless)**
Linux kernel, drivers, emulator backends, controller layer, audio/video stack, networking. Default Batocera EmulationStation frontend is stripped — it never boots. This layer provides the machine room only.

**Layer 2 — The Bridge (VetTV Service Layer)**
Lightweight Python daemon between the Godot frontend and Batocera backend. Responsibilities:
- Launching emulator cores with correct ROMs
- Launching cloud gaming wrappers
- Controller state management
- System metrics (CPU, GPU, network for streaming health)
- Save state sync and "Memory Card" persistence

**Layer 3 — The Face (Godot 4 Frontend)**
Entire user-facing experience. Boots directly after kernel init via a custom systemd service. Owns all rendering, animation, audio, input, navigation, theming.

---

## 3. Technical Stack

- **Base OS:** Batocera (forked) → Buildroot toolchain
- **Kernel:** Batocera's tuned gaming kernel
- **Init:** systemd (replaces Batocera default for Godot auto-launch)
- **Frontend engine:** Godot 4.3+ stable
- **Frontend language:** GDScript primary, C# for performance-critical modules
- **Service layer:** Python 3.11+ with FastAPI (local IPC via Unix sockets)
- **Emulator backends:** RetroArch (libretro cores) + standalones (PCSX2, RPCS3, Dolphin, Ryujinx, Citra)
- **Cloud gaming:** Chromium-based wrappers (Electron or CEF) for GFN, Xbox Cloud, Luna, Boosteroid
- **Controller layer:** SDL2 → Godot Input with unified mapping
- **Audio:** PipeWire (low-latency)
- **Graphics:** Vulkan primary, GL fallback
- **Asset pipeline:** Blender → glTF for 3D, Figma → SVG/PNG for 2D
- **Music/SFX:** Suno (default VetTV style preset) + commissioned UI SFX
- **Version control:** Git + private GitHub repo
- **Build system:** Buildroot for OS image, Godot export templates for frontend

---

## 4. Dashboard Architecture — The Six Memory Cards

Horizontal column navigation. D-pad L/R switches cards, U/D browses contents, A selects, B backs out.

1. **Retro Card** — emulated systems, era-grouped (8-bit, 16-bit, 32/64-bit, 128-bit, HD era)
2. **Cloud Card** — GFN / Xbox Cloud / Luna / Boosteroid as first-class tiles
3. **Media Card** — Channel82 TV, Rumble, YouTube, local media
4. **Creator Card** — OBS, Discord, stream tools, quick-launch (unique to VetTV)
5. **Library Card** — Steam, native games, Veilwalkers when ready
6. **System Card** — settings, themes, updates, about

Cards float in 3D Godot space with parallax on navigation. Ambient particles drift across scene. Selecting a card pushes it forward; contents fan out as tile grid.

**Idle behavior:** After 90 seconds no input → "Ambient Mode." Cards drift slowly, particle density increases, music swells, clock becomes prominent. Any button snaps back.

---

## 5. Boot Sequence Ritual

Target: boot-to-usable under 15 seconds. Skippable after step 4.

1. BIOS POST
2. VetTV Cold Boot — black screen, faint CRT hum building
3. CRT Power-On Effect — white flash, vertical collapse, static wash
4. Channel Tuning — rapid channel-flip through retro TV snippets (2 sec)
5. Channel82 Ident — branded ident (3-5 sec)
6. Memory Card Insert Animation — stylized card slots in with *thunk* SFX
7. Dashboard Materialize — cards fade from void, ambient loop starts, ready state

---

## 6. Six-Month Phase Plan

**Phase 0 — Foundation (Weeks 1-2)**
Dev environment setup, WSL2 + Hyper-V + Godot toolchain verified, Batocera clean build in VM, GitHub repo scaffolded.
*Deliverable:* Vanilla Batocera boots in Hyper-V VM from Windows 11 host.

**Phase 1 — Stripped Base (Weeks 3-4)**
Fork and rebrand Batocera at image level, strip EmulationStation, systemd service auto-launches blank Godot app, controller input verified.
*Deliverable:* Custom-branded image boots to black Godot window with working input.

**Phase 2 — Dashboard Scaffolding (Weeks 5-8)**
Godot scene architecture (MainDashboard → CardColumn → CardFace → TileGrid), ambient particle system, background shader, clock component.
*Deliverable:* Navigable dashboard with 6 placeholder cards running on VetTV MCE image.

**Phase 3 — Retro Card Integration (Weeks 9-12)**
Python service layer online, ROM scanning + metadata via ScreenScraper, era-grouping logic, RetroArch launch integration, save state "Memory Card" metaphor.
*Deliverable:* Select system → select game → launches → save/load works.

**Phase 4 — Cloud Card Integration (Weeks 13-16)**
Chromium wrappers for all four services (leverages Universal Cloud Gaming Steam App work), themed loading transitions, controller passthrough, connection health monitoring.
*Deliverable:* Seamless launch into GFN/Xbox Cloud/Luna/Boosteroid.

**Phase 5 — Polish & Content Layers (Weeks 17-20)**
Full boot ritual, Suno ambient loops integrated, UI SFX pass, Media Card wired to Channel82, Creator Card with OBS/Discord, theme system scaffolded.
*Deliverable:* Feels like a real product.

**Phase 6 — Beta, Release, Reveal (Weeks 21-24)**
Physical hardware testing, "First Card Holders" beta release, Rumble/YouTube reveal series, Steam partner submission prep, public v1.0 drop.

---

## 7. Content Flywheel

Every phase = content arc.

- **Phase 0-1:** "I'm building my own OS on Windows 11" — dev log series kickoff
- **Phase 2:** First dashboard reveal — thumbnail gold
- **Phase 3:** Retro library loading moment — emotional payoff
- **Phase 4:** "Cyberpunk 2077 on my retro OS via GFN" — mind-blown moment
- **Phase 5:** Boot sequence reveal — short-form across TikTok/Shorts/Reels
- **Phase 6:** Launch event — coordinated push, 4.5M X impressions amplifying

Beta testers branded as **"First Card Holders."**

---

## 8. Open Questions (resolve as we go)

- Final Godot frontend licensing (open source for community theming vs. proprietary)
- Monetization model (free OS, paid themes, Patreon beta gate, Steam companion app)
- Community infrastructure (dedicated VetTV MCE Discord vs. Channel82 integration)
- Beta tester selection criteria
- Hardware partnership potential post-v1 (pre-loaded handheld/mini PC partnerships)

---

## 9. First Three Moves

1. **Reserve the name** — vettv-mce.com, @VetTVMCE handles on all platforms, GitHub org
2. **Phase 0 Week 1 Day 1** — WSL2 + Hyper-V + Godot toolchain verification on Windows 11 Insider Dev 26200
3. **Project knowledge loaded** — this blueprint pinned, supporting docs uploaded, every session starts fully grounded
