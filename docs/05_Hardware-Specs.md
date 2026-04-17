# VetTV MCE — Hardware Specifications

---

## Dev PC (Windows 11 Insider Dev 26200)

Primary build machine. Not the target — this is where the work happens.

- **OS:** Windows 11 Insider Dev build 26200
- **Role:** Buildroot compilation, Godot editor, VM host, asset creation
- **Dev environments:** WSL2 (Ubuntu 24.04), Hyper-V, native Windows
- **Expected load:** sustained multi-core compilation, GPU for Godot editor preview, VM resource allocation

---

## Secondary Rig (Bazzite Linux)

- **CPU:** AMD Ryzen 5 9600X
- **GPU:** NVIDIA RTX 5060
- **OS:** Bazzite (Linux)
- **Role:** Target-class hardware testing, Linux-native development sanity checks, cloud gaming performance baseline
- **Status:** Ongoing kernel tuning, Proton configuration, NVIDIA open driver setup

This rig validates that VetTV MCE runs well on real enthusiast-tier hardware, not just in a Hyper-V VM.

---

## Target Hardware Tiers

VetTV MCE should run across a spread of hardware. Three tiers defined:

### Tier 1 — Minimum Spec
- **CPU:** Any x86_64, dual-core minimum
- **RAM:** 4 GB
- **GPU:** Integrated graphics acceptable
- **Storage:** 32 GB
- **Target devices:** Cheap mini PCs, budget handhelds, thin clients repurposed as retro boxes
- **Expected experience:** Full dashboard, emulation through PS1/N64 era smoothly, cloud gaming works at 720p/1080p, 128-bit era emulation may struggle

### Tier 2 — Recommended
- **CPU:** AMD Ryzen 5 / Intel Core i5 (current or last-gen)
- **RAM:** 8 GB
- **GPU:** Entry-level discrete (GTX 1650 class or better)
- **Storage:** 128 GB SSD
- **Target devices:** Mid-range mini PCs, modern handhelds, older gaming PCs repurposed
- **Expected experience:** Full dashboard at 60fps, emulation through Gamecube/Wii/PS2 solid, cloud gaming at 1080p/60, PS3/Switch emulation workable

### Tier 3 — Enthusiast (Vet's secondary rig class)
- **CPU:** Ryzen 7/9, Core i7/i9 current gen
- **RAM:** 16 GB+
- **GPU:** RTX 5060 / RX 7700 XT or better
- **Storage:** 512 GB+ NVMe
- **Target devices:** Gaming PCs, high-end mini PCs, enthusiast handhelds (ROG Ally X, Legion Go class)
- **Expected experience:** 4K HDR output, max settings everywhere, all cloud services at peak quality, all emulators full speed including PS3/Switch, Godot dashboard with all visual effects enabled

---

## Future Platform Targets (Post-v1.0)

Not in Phase 0-6 scope, but on the radar:

- **ARM64** — Raspberry Pi 5, Anbernic handhelds, other SBC-class devices. Godot 4 runs on ARM, but requires separate build targets and testing. Phase 7+ work.
- **Steam Deck** — Interesting angle as a SteamOS companion app rather than full OS replacement. Steam partner program context.
- **Pre-loaded hardware partnerships** — mini PC or handheld vendors pre-loading VetTV MCE. Post-v1, once the brand has traction.

---

## Test Hardware Needs During Dev

For Phase 6 beta, want access to:

- At least one Tier 1 device (cheap Intel N100 mini PC works)
- At least one Tier 2 device (likely your Bazzite rig can dual-boot or USB-boot)
- At least one handheld (borrowed or purchased for test)
- Variety of controllers: Xbox (official + knockoff), PlayStation, 8BitDo, Switch Pro — verify SDL2 mapping works across the spectrum

---

## Controller Support Targets

Must support out of the box:
- Xbox controllers (wired + wireless, all gens)
- PlayStation controllers (DualShock 4, DualSense) — via generic HID
- 8BitDo full lineup
- Switch Pro Controller
- Generic HID gamepads
- Keyboard + mouse (as fallback, not primary)

Should support with config:
- Retro-style USB controllers (SNES/Genesis replicas)
- Arcade sticks
- Steam Controller (legacy but has an audience)
