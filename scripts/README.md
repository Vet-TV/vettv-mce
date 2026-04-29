# scripts/

Build and deploy automation. Fast iteration is the goal — frontend changes should reach a booting VM in under two minutes.

## Planned scripts

| Script | Purpose |
| --- | --- |
| `build-image.sh` | Full Buildroot rebuild of the OS image (slow, kernel/OS-level changes only) |
| `inject-frontend.sh` | Drop a fresh Godot Linux export into the existing image without a full rebuild |
| `boot-vm.ps1` | Launch / reset the Hyper-V test VM with the latest image attached |
| `deploy-usb.sh` | Flash the image to a USB drive for hardware testing |
| `lint.sh` | Run all lint/format checks (markdown, Python, GDScript) before push |
| `verify-licenses.sh` | Sanity-check that everything in `licenses/` matches assets in tree |

## Conventions

- Bash for Linux/WSL2, PowerShell for Windows-host orchestration
- Every script has `--help`
- Every script is idempotent — safe to re-run
- No script writes outside the repo or build-output tree without confirmation

## Phase status

- **Phase 0:** placeholder
- **Phase 1:** `build-image.sh` and `boot-vm.ps1` go live
- **Phase 2+:** the iteration loop scripts come online
