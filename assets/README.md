# assets/

Design source files. Inputs to the asset pipeline — *not* the exported binaries the Godot project consumes.

## What goes here

- Blender source files (`.blend`) → exported to glTF for Godot
- Figma exports / SVG / layered PNG sources → exported to PNG for Godot
- Font source files (only when the license allows redistribution of the source)
- Suno-generated audio with provenance metadata → exported to OGG/WAV for Godot
- UI SFX source / commissioned audio sessions

## What does NOT go here

- Final game-ready assets consumed by Godot — those live in `frontend/` next to the scenes that use them
- Anything without a confirmed license entry in `licenses/`

## Pipeline rule

Every asset that lands in `frontend/` must have:
1. A source file here (or a documented external source)
2. A license entry in `licenses/`
3. IP-hygiene clearance per `docs/02_IP-Hygiene-Rules.md`

## Large files

Big binary sources (Blender scenes, multi-track audio sessions) are candidates for Git LFS. Don't enable LFS until we hit the first file >50 MB — keep the repo lean while it's empty.
