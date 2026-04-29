# licenses/

Third-party asset license tracking. **Every** non-original asset in this repo must have an entry here before it ships.

## Why this directory exists

Per `docs/02_IP-Hygiene-Rules.md`: every third-party asset (font, SFX, texture, shader, library) is logged with license type, source URL, and usage scope. No asset ships without a confirmed compatible license.

## Entry format

One Markdown file per asset (or per asset bundle from a single source). Filename: `<asset-or-bundle-slug>.md`.

```markdown
# <asset name>

- **Source:** <URL>
- **License:** <SPDX identifier, e.g. OFL-1.1, CC-BY-4.0, MIT>
- **License file:** <path within this directory, if redistributed>
- **Used in:** <repo paths consuming the asset>
- **Usage scope:** <what we use it for, in one sentence>
- **Attribution required:** <yes/no — and where the credit appears in-product>
- **Date added:** YYYY-MM-DD
- **Verified by:** <handle>
```

## Suno-generated audio

Log generation metadata (prompt, style preset, generation date, Suno track ID) so provenance is recoverable. Treat each generation as an asset with its own entry.

## What does NOT go here

- The repo's own `LICENSE` file — that's at the repo root
- License headers inside source files — those stay in source

## Verification

`scripts/verify-licenses.sh` (Phase 1+) cross-checks tracked licenses against assets in `frontend/` and `assets/`.
