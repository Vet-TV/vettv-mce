# frontend/

**Layer 3 — The Face.** Godot 4 dashboard project. The entire user-facing experience lives here.

## What goes here

- Godot 4.3+ project files (`project.godot`, scenes, scripts)
- GDScript primary, C# for performance-critical modules
- Scene architecture: `MainDashboard` → `CardColumn` → `CardFace` → `TileGrid`
- Shaders, particle systems, theme resources
- Linux export presets for deployment to the OS image

## What does NOT go here

- Buildroot / kernel work → `batocera-fork/`
- Python service daemon → `service-layer/`
- Build/deploy automation → `scripts/`
- Design source files (Blender, Figma) → `assets/`

## Phase status

- **Phase 0:** complete — vanilla Batocera boots in the test VM (see `CHANGELOG.md`)
- **Phase 1:** complete — blank Godot app auto-launches on the custom Batocera image via the `vettv_frontend` user service (see `batocera-fork/`); input verified in VM
- **Phase 2:** complete — navigable dashboard: six Memory Cards (`card_data.gd`, `card_face.gd`, dashboard in `main.gd`), placeholder tile grids, ambient particles, live clock, 90 s idle Ambient Mode. Verified in VM and on a Windows build. Note: idle detection counts deliberate presses only — pointer-motion events can arrive continuously in VMs and starve Ambient Mode
- **Phase 3+:** card-by-card feature integration

## IP hygiene

Read `docs/02_IP-Hygiene-Rules.md` before adding any visual asset, font, glyph, or audio. PS2-*era inspired*, never PS2-*derived*.
