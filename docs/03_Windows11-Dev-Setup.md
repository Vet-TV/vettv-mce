# VetTV MCE — Windows 11 Dev Setup

**Dev host:** Windows 11 Insider Dev build 26200
**Target OS being built:** Linux (Batocera fork)

---

## The Dual-Environment Model

You're building a Linux-based OS *from* Windows 11. Three workspaces run in parallel:

**Workspace A — WSL2 (Ubuntu 24.04 LTS)**
- Buildroot toolchain, Batocera source, Python service layer, Git, build scripts
- 80% of daily dev work happens here
- Accessed via Windows Terminal + VS Code Remote-WSL

**Workspace B — Hyper-V VM (image testing)**
- Boot and validate built OS images
- Saves the USB-flashing cycle during iteration
- UEFI-enabled, 8GB RAM, 4 vCPU, 64GB virtual disk

**Workspace C — Native Windows (Godot frontend dev)**
- Godot 4.3 editor runs natively on Windows for best performance
- Export Linux binaries for deployment to the VM and target hardware
- Asset creation tools (Blender, Figma, GIMP) also live here

---

## Insider Build 26200 — Specific Notes

**Advantage:** WSL2 on Insider builds gets the latest kernel and systemd improvements first. You're actually ahead of mainstream here.

**Watch-outs:**
- Insider builds occasionally ship WSL or Hyper-V regressions
- Set a system restore point before every Windows Update during active dev
- Document current build number in repo README as last-known-good reference
- If a build update breaks the toolchain, rollback is a valid first response — don't waste hours debugging a Microsoft-side regression

---

## Phase 0 Week 1 — Initial Setup Checklist

**PowerShell as Administrator:**
```powershell
wsl --install -d Ubuntu-24.04
wsl --update
wsl --set-default-version 2
```

**Enable Hyper-V** (Windows 11 Pro/Enterprise):
Control Panel → Programs → Turn Windows features on or off → check "Hyper-V" → reboot

**Alternative if on Windows 11 Home:** Install VirtualBox 7.0+ instead.

**Core Windows Installs:**
- Git for Windows (with credential manager)
- Windows Terminal (Microsoft Store, often pre-installed on Insider)
- VS Code
- Godot 4.3 stable (native Windows build) + Linux export templates
- .NET 8 SDK (for C# Godot modules)
- Python 3.11+ for Windows (optional — WSL2 Python is primary)

**VS Code Extensions:**
- Remote - WSL
- Godot Tools
- Python
- C#
- GitLens
- Markdown All in One

**Ubuntu 24.04 Inside WSL2:**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential git cmake python3-pip
sudo apt install -y libncurses-dev bc rsync unzip wget bison flex
git config --global user.name "Vet"
git config --global user.email "your-email-here"
```

---

## Folder Structure

**Windows side:** `C:\Dev\VetTV-MCE\`
- `frontend\` — Godot project
- `assets\` — Blender, Figma, design source files
- `docs\` — project documentation (mirror of Claude Project knowledge)
- `scripts\` — PowerShell build/deploy scripts

**WSL2 side:** `~/vettv-mce/`
- `batocera-fork/` — forked Batocera source
- `service-layer/` — Python daemon
- `build-output/` — compiled images
- `scripts/` — bash build scripts

**Tip:** Keep the two folder structures separate. Do NOT try to build Buildroot inside a Windows-mounted drive (`/mnt/c/...`) — massive performance hit. Keep Linux build work on the WSL2 native filesystem.

---

## Windows Defender Exclusions

Add to prevent build slowdowns:
- `C:\Dev\VetTV-MCE\`
- `\\wsl$\Ubuntu-24.04\home\<your-wsl-user>\vettv-mce\`

Path: Windows Security → Virus & threat protection → Manage settings → Add or remove exclusions

---

## The "Build and Deploy" Loop

Target iteration cycle:
1. Edit frontend in Godot (Windows)
2. Export Linux binary → `C:\Dev\VetTV-MCE\frontend\export\`
3. PowerShell script copies binary into WSL2 build tree
4. WSL2 rebuilds minimal image chunk (incremental, not full rebuild)
5. Hyper-V VM boots new image
6. Observe, iterate

Full rebuilds only for kernel/OS changes. Frontend iterations should feel fast — under 2 minutes end-to-end once the script is tuned.

---

## Git Strategy

- Private GitHub repo (public after v1.0 reveal, or keep frontend proprietary)
- `main` branch = releasable
- `dev` branch = integration
- Feature branches per phase milestone (`phase-2/dashboard-scaffolding`, etc.)
- Tag every phase completion: `v0.1-phase0`, `v0.2-phase1`, etc.
- Commit in WSL2 or Windows — credential manager syncs between them

---

## Backup Strategy

- OneDrive or local NAS mirror of `C:\Dev\VetTV-MCE\`
- Push to GitHub frequently (every working session minimum)
- WSL2 `~/vettv-mce/` also pushes to GitHub — no other local backup needed since source is in Git
- Godot project backed up via Git
- System restore point before Windows Updates
- Full disk image backup monthly (Macrium Reflect Free or similar)

---

## Known Pitfalls

- **WSL2 clock drift:** Occasionally WSL2 clock drifts from Windows. Fix: `sudo hwclock -s` inside WSL2.
- **Hyper-V and VirtualBox conflict:** Can't run both simultaneously. Pick one. Hyper-V recommended on Win11 Pro.
- **USB passthrough to Hyper-V:** Limited compared to VirtualBox. For controller testing in VM, consider Enhanced Session Mode or use VirtualBox with USB extensions.
- **Godot Windows vs. Linux export differences:** Shader behavior can differ slightly. Always test exported Linux build in the VM, not just the Windows editor preview.
- **Insider build updates:** Can temporarily break WSL2. Keep a parallel stable Windows 11 VM or second PC as fallback dev environment if critical.
