# VetTV: Memory Card Edition

**A retro-futurist console operating system.**
Inspired by the console dashboards of the early 2000s, remastered for 2026.

[![Phase](https://img.shields.io/badge/phase-2%20%E2%80%94%20dashboard%20scaffolding-blue)](docs/01_VetTV-MCE-Blueprint.md#6-six-month-phase-plan)
[![Roadmap](https://img.shields.io/badge/roadmap-6%20months%20to%20v1.0-orange)](docs/01_VetTV-MCE-Blueprint.md#6-six-month-phase-plan)
[![Base](https://img.shields.io/badge/base-batocera%20(forked)-1f6feb)](https://batocera.org)
[![Frontend](https://img.shields.io/badge/frontend-godot%204-478cbf)](https://godotengine.org)
[![Service](https://img.shields.io/badge/service%20layer-python%203.11%20%2B%20fastapi-3776ab)](https://fastapi.tiangolo.com)
[![License](https://img.shields.io/badge/license-GPLv2%20(target)-green)](LICENSE)
[![Repo checks](https://github.com/vet-tv/vettv-mce/actions/workflows/repo-checks.yml/badge.svg)](.github/workflows/repo-checks.yml)

---

## What it is

VetTV MCE is a custom Linux-based operating system that unifies:

- **Retro emulation** — NES through PS3/Switch era
- **Cloud gaming** — GeForce NOW, Xbox Cloud, Amazon Luna, Boosteroid
- **Media and creator tools** — Channel82 TV, Rumble, YouTube, OBS, Discord

…into a single dashboard built around a "Memory Card" metaphor.

## Architecture

Three layers, in order of stack:

| Layer | What | Where in this repo |
| --- | --- | --- |
| **1. Foundation** | Forked Batocera — kernel, drivers, emulator backends. Default frontend stripped. | [`batocera-fork/`](batocera-fork/) |
| **2. Bridge** | Python daemon (FastAPI) launching cores, syncing saves, monitoring metrics. | [`service-layer/`](service-layer/) |
| **3. Face** | Godot 4 dashboard — six Memory Cards, ambient particles, the whole user experience. | [`frontend/`](frontend/) |

Supporting trees:

- [`scripts/`](scripts/) — build / deploy automation (bash + PowerShell)
- [`assets/`](assets/) — design source files (Blender, Figma, Suno provenance)
- [`licenses/`](licenses/) — third-party asset license tracking
- [`web/`](web/) — parked landing page for `vettv-mce.com` (Cloudflare Pages-ready)
- [`docs/`](docs/) — blueprint, IP hygiene rules, dev setup, comms, hardware

## Status

**Phase 2 — Dashboard Scaffolding.** Phase 1 complete: the branded image boots straight to the blank Godot frontend. 6-month roadmap to v1.0.

| # | Phase | Weeks | Deliverable |
| --- | --- | --- | --- |
| 0 | Foundation | 1–2 | Vanilla Batocera boots in a VM from Windows 11 host — **done** (VirtualBox fallback; Hyper-V pending host elevation) |
| 1 | Stripped base | 3–4 | Custom-branded image boots to a blank Godot window with working input — **done** (ES hands off to Godot after boot) |
| 2 | Dashboard scaffolding | 5–8 | Navigable dashboard with six placeholder cards |
| 3 | Retro card | 9–12 | Select system → select game → launch → save / load works |
| 4 | Cloud card | 13–16 | Seamless launch into GFN / Xbox Cloud / Luna / Boosteroid |
| 5 | Polish & content layers | 17–20 | Boot ritual, ambient loops, themes — feels like a real product |
| 6 | Beta & reveal | 21–24 | First Card Holders beta, Rumble/YouTube reveal, v1.0 drop |

Full plan: [`docs/01_VetTV-MCE-Blueprint.md`](docs/01_VetTV-MCE-Blueprint.md)

## Read first

- [Master blueprint](docs/01_VetTV-MCE-Blueprint.md)
- [**IP hygiene rules** — non-negotiable](docs/02_IP-Hygiene-Rules.md)
- [Windows 11 dev setup](docs/03_Windows11-Dev-Setup.md)
- [Communication preferences](docs/04_Communication-Preferences.md)
- [Hardware specs and target tiers](docs/05_Hardware-Specs.md)

## Contributing

Single-maintainer until Phase 5. Issues are open; PRs from outside the maintainer will redirect to the docs. See [`CONTRIBUTING.md`](CONTRIBUTING.md), [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md), and [`SECURITY.md`](SECURITY.md).

Beta interest? The **First Card Holders** beta opens at Phase 6 — DM [@Vet_TV](https://x.com/Vet_TV) on X.

## Related projects

- [boomerbox-os](https://github.com/Vet-TV/boomerbox-os) — sibling distro, Windows 98 aesthetic
- [openps-stream](https://github.com/Vet-TV/openps-stream) — cloud streaming foundation work

## Created by

Vet — [@Vet_TV](https://x.com/Vet_TV) on X · VetTV / Channel82 TV creator ecosystem

---

*PS2-era inspired. No Sony IP used.*
