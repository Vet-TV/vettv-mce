# Upstream pin — Batocera

Phase 1 is an **image-level fork**: we start from the official Batocera
release image and apply the VetTV overlay in `overlay/`. No Buildroot
source rebuild yet; that arrives when we need kernel/driver changes.

| Field | Value |
| --- | --- |
| Upstream | Batocera Linux — <https://batocera.org> |
| Version | 43.1 |
| Target | x86_64 |
| File | `batocera-x86_64-43.1-20260529.img.gz` |
| Download | <https://mirrors.o2switch.fr/batocera/x86_64/stable/last/batocera-x86_64-43.1-20260529.img.gz> |
| Size | 4,334,005,632 bytes (4.04 GiB) |
| SHA-256 | `7ac08d5fcf6f9c00e85e71b6d0c68ddffe710f1e0667aab2931c5bf1509018b8` |
| License | GPL family (see upstream); our overlay files keep repo licensing |

## What the overlay changes

All changes live in userdata, so they survive Batocera's read-only
rootfs and are fully reviewable in this repo:

- `userdata/vettv/frontend/` — Godot Linux export (deployed, not tracked; built from `frontend/`)
- `userdata/system/services/vettv_frontend` — user service that stops EmulationStation after X is up and launches the Godot frontend fullscreen (Batocera is SysV-init; `S99userservices` is the supported hook)
- `userdata/splash/vettv-mce.png` — original VetTV boot splash (replaces the stock splash video at image level)
- `batocera.conf`: `system.hostname=VETTV-MCE`, `system.services` enables `vettv_frontend`

Phase 1 limitation: EmulationStation still starts during boot and is
then replaced by the service, so it can flash briefly. Fully preventing
ES from starting (`system.es.atstartup=0`) also stops `startx`, leaving
no display for Godot — removing that coupling is later-phase work.

VM quirk found in Phase 1: the stock splash video (mpv on DRM) can hold
DRM master long enough that X fails with `drmSetMaster: Device or
resource busy`. The `vettv_frontend` service detects the missing X
socket, clears mpv, and restarts `S31emulationstation` once.
