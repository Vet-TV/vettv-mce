# VetTV MCE — IP Hygiene Rules

**Status:** Non-negotiable. Review before every asset, commit, and public reveal.

---

## The Core Principle

VetTV: Memory Card Edition is **PS2-era inspired**, never **PS2-derived**. Every design decision must pass this test: *Could Sony's legal team look at this and claim it's a reproduction of their IP?* If yes, redesign.

Sony is aggressive about UI imitation. One cease-and-desist damages the entire VetTV brand, Channel82, the ID@Xbox submission pipeline, and the Steam partner standing.

---

## Absolute Prohibitions

**Naming & Branding**
- No "PlayStation," "PS2," "PS3," or any Sony console name in product name, marketing, UI, code comments, commit messages, or filenames
- No "Cross Media Bar" / "XMB" references in product-facing copy (the term is widely used internally in the RetroArch world, so internal dev references are okay, but never public-facing)
- No "DualShock," "DualSense," or Sony controller names

**Typography**
- No Sony SST font family (their system font)
- **Approved alternatives:** Inter, Manrope, Space Grotesk, Rubik, or a commissioned custom font
- Font licensing verified and logged before use

**Visual Assets**
- No reproduction of the actual PS2 Memory Card shape or color scheme
  - Use the *metaphor* and *word*, design an original card visual
- No DualShock/Sixaxis button glyphs (the ○ ✕ □ △ symbols in Sony's exact style)
  - Design an original controller glyph set for VetTV MCE
- No PS2 "floating columns" geometry reproduced 1:1 — abstract the *feel*, not the shapes
- No PS2 boot logo, startup animation, or ident reproduction
- No PlayStation wave/blob particle effects copied pixel-for-pixel

**Audio**
- No PS2 startup chime, boot audio, or system sounds sampled, remixed, or referenced
- No PS2 Browser ambient loop reproduced
- **Approved source:** Suno with VetTV default style preset for ambient loops, commissioned or original UI SFX only

**Motion & Animation**
- No exact reproduction of PS2 Browser column animations, cursor pulse patterns, or transition timings
- Reinterpret the *atmosphere* (ambient, meditative, liminal) with original motion design

---

## Safe Creative Territory

What you *can* do freely:

- Floating UI elements in 3D space (industry standard, not PS2-exclusive)
- Ambient particle systems (universal)
- Gradient backgrounds with depth (universal)
- Card-based organizational metaphors (broadly used across many platforms)
- Clock/calendar as prominent UI element (universal)
- Column-based navigation (broadly used)
- Synthwave/ambient music aesthetics (not Sony IP)
- Y2K/early-2000s design language references (era, not brand)
- CRT visual effects (era, not brand)

---

## Marketing Language — Approved Phrases

Use these:
- "Retro-futurist console OS"
- "Y2K console dashboard aesthetic"
- "Early-2000s console menu inspired"
- "PS2-era inspired" *(used sparingly — the word "era" is load-bearing)*
- "A love letter to the console dashboards of the 2000s"

Avoid these:
- "PS2 remake"
- "PS2 clone"
- "PlayStation-style"
- "Like the PS2 Browser but..."
- Anything that positions VetTV MCE as a *substitute for* or *replica of* Sony product

---

## Asset & License Tracking

- Every third-party asset (font, SFX, texture, shader, library) logged in `/licenses/` directory in the repo
- License type, source URL, and usage scope documented per asset
- No asset used without a confirmed license compatible with the project license
- Suno generations logged with their generation metadata for provenance

---

## Emulation-Specific IP Notes

- No Sony BIOS files bundled in the image — user-sideloadable only for any emulator requiring BIOS
- No ROMs bundled ever
- PS2/PS3 emulation (via PCSX2/RPCS3) requires specific care — ship the emulator as an optional install or user-sideloaded component where legally prudent
- Nintendo Switch emulation (Ryujinx) legal status remains evolving — monitor and adjust distribution strategy before v1.0 release
- Xbox emulation is fine; Microsoft's ID@Xbox relationship is actually an asset here

---

## Public Reveal Checklist

Before any public asset drop (trailer, screenshot, dev log, tweet):

1. Does this show any Sony IP? — if yes, redo
2. Is the language PS2-*inspired* not PS2-*derived*? — verify
3. Are fonts, glyphs, sounds all original/licensed? — verify
4. Is the "Memory Card" metaphor used as *concept*, not visual copy? — verify
5. Is any bundled content (ROMs, BIOS) shown? — if yes, remove

---

## When in Doubt

Redesign. The creative space outside Sony's IP is enormous — the 2000s console aesthetic is a *vibe*, not a Sony trademark. Lean into retro-futurism, Channel82's CRT/VHS DNA, and Y2K design language. That's legally bulletproof and visually distinctive.
