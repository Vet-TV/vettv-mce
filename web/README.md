# web/

Parked-domain landing page for `vettv-mce.com`. Single self-contained `index.html` — no build step, no dependencies, no JavaScript.

## Deploy

### Cloudflare Pages (recommended)

1. Cloudflare dashboard → Pages → **Create a project** → **Connect to Git**
2. Pick this repo, branch `main`
3. Build settings:
   - Framework preset: **None**
   - Build command: *(leave empty)*
   - Build output directory: `web`
4. Deploy. Add `vettv-mce.com` and `www.vettv-mce.com` in **Custom domains**.

### GitHub Pages (alternative)

Settings → Pages → Source: **Deploy from a branch** → branch `main`, folder `/web`. (Requires moving `index.html` to `/docs` *or* configuring a Pages action — Cloudflare is simpler for `/web`.)

## What's on the page

- VetTV MCE wordmark + tagline
- Phase 0 status badge
- Two CTAs: GitHub repo, `@Vet_TV` on X
- Three-layer architecture cards (Foundation / Bridge / Face)
- Footer: repo link, blueprint link, IP-hygiene reminder

## IP hygiene

This page is reviewed against `docs/02_IP-Hygiene-Rules.md`. Specifically:

- Fonts: **Space Grotesk** (approved) + **JetBrains Mono** (free OFL/Apache) — no Sony SST
- No Memory Card visual reproduction — the card metaphor is verbal only
- No DualShock/Sixaxis glyphs — no controller glyphs at all
- No PS2 boot animation, no PS2 ambient audio
- Approved language: "retro-futurist console OS", "PS2-era inspired", "remastered for 2026"
- Closing line: *"PS2-era inspired. No Sony IP used."*

## Updating

Edit `web/index.html` directly. CSS is inline. No JS. Changes ship the moment Cloudflare Pages picks up the next commit on `main`.

## Performance budget

- Single HTML file, ~10 KB uncompressed
- Two Google Fonts subsets (preconnected)
- No images yet — add an OG image at `web/og.png` (1200×630) before any reveal-tier social share

## Future work

- `web/og.png` — branded social card
- `web/favicon.svg` — wordmark glyph
- Phase 6: replace this parked page with the real product page (download links, screenshots, beta sign-up)
