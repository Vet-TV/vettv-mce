"""Scan a Batocera-style roms directory into era-grouped systems and games.

Layout expected: <roms_dir>/<system_id>/<game files>. Media, saves, and
gamelist metadata are ignored. No ROMs ship with VetTV MCE - this only
ever reads what the user sideloaded (docs/02_IP-Hygiene-Rules.md).
"""

from __future__ import annotations

import re
from pathlib import Path

# Batocera system id -> (display name, era). Eras follow the blueprint's
# era-grouped Retro card. Systems not listed fall into "More Systems".
SYSTEM_INFO: dict[str, tuple[str, str]] = {
    # 8-bit
    "nes": ("NES", "8-bit Era"),
    "gb": ("Game Boy", "8-bit Era"),
    "gbc": ("Game Boy Color", "8-bit Era"),
    "sms": ("Master System", "8-bit Era"),
    "gamegear": ("Game Gear", "8-bit Era"),
    "atari2600": ("Atari 2600", "8-bit Era"),
    "c64": ("Commodore 64", "8-bit Era"),
    "msx": ("MSX", "8-bit Era"),
    "zxspectrum": ("ZX Spectrum", "8-bit Era"),
    # 16-bit
    "snes": ("SNES", "16-bit Era"),
    "megadrive": ("Mega Drive", "16-bit Era"),
    "genesis": ("Genesis", "16-bit Era"),
    "pcengine": ("PC Engine", "16-bit Era"),
    "pcenginecd": ("PC Engine CD", "16-bit Era"),
    "segacd": ("Sega CD", "16-bit Era"),
    "amiga": ("Amiga", "16-bit Era"),
    "atarist": ("Atari ST", "16-bit Era"),
    "neogeo": ("Neo Geo", "16-bit Era"),
    # 32/64-bit
    "psx": ("PlayStation", "32/64-bit Era"),
    "n64": ("Nintendo 64", "32/64-bit Era"),
    "saturn": ("Saturn", "32/64-bit Era"),
    "gba": ("Game Boy Advance", "32/64-bit Era"),
    "sega32x": ("32X", "32/64-bit Era"),
    "jaguar": ("Jaguar", "32/64-bit Era"),
    "3do": ("3DO", "32/64-bit Era"),
    # 128-bit
    "ps2": ("PlayStation 2", "128-bit Era"),
    "gamecube": ("GameCube", "128-bit Era"),
    "xbox": ("Xbox", "128-bit Era"),
    "dreamcast": ("Dreamcast", "128-bit Era"),
    # HD era
    "ps3": ("PlayStation 3", "HD Era"),
    "xbox360": ("Xbox 360", "HD Era"),
    "wii": ("Wii", "HD Era"),
    "wiiu": ("Wii U", "HD Era"),
    "switch": ("Switch", "HD Era"),
    "windows": ("Windows", "HD Era"),
}

ERA_ORDER = ["8-bit Era", "16-bit Era", "32/64-bit Era", "128-bit Era", "HD Era", "More Systems"]

# Directories inside a system folder that never contain launchable ROMs.
SKIP_DIRS = {"images", "media", "videos", "manuals", "saves", "downloaded_images", "themes"}
SKIP_FILES = {"gamelist.xml", "gameslist.xml"}
SKIP_SUFFIXES = {".xml", ".txt", ".md", ".png", ".jpg", ".jpeg", ".dat", ".cfg", ".ini"}

_PAREN_RE = re.compile(r"\s*(\(|\[)[^)\]]*(\)|\])")


def clean_title(filename: str) -> str:
    """Turn a ROM filename into a display title (drop region/version tags)."""
    stem = Path(filename).stem
    title = _PAREN_RE.sub("", stem).strip()
    return title or stem


def scan_system(system_dir: Path) -> dict | None:
    """Scan one system folder. Returns None when it holds no games."""
    games: list[dict] = []
    for entry in sorted(system_dir.rglob("*")):
        if not entry.is_file():
            continue
        rel = entry.relative_to(system_dir)
        if any(part.lower() in SKIP_DIRS for part in rel.parts[:-1]):
            continue
        if entry.name.startswith(".") or entry.name.lower() in SKIP_FILES:
            continue
        if entry.suffix.lower() in SKIP_SUFFIXES:
            continue
        games.append(
            {
                "title": clean_title(entry.name),
                "file": entry.name,
                "path": str(entry),
                "size_bytes": entry.stat().st_size,
            }
        )
    if not games:
        return None
    name, era = SYSTEM_INFO.get(system_dir.name, (system_dir.name.upper(), "More Systems"))
    return {
        "id": system_dir.name,
        "name": name,
        "era": era,
        "game_count": len(games),
        "games": games,
    }


def scan_roms(roms_dir: str | Path) -> dict:
    """Scan the whole roms tree. Missing dir scans as empty, never errors."""
    root = Path(roms_dir)
    systems: list[dict] = []
    if root.is_dir():
        for child in sorted(root.iterdir()):
            if child.is_dir() and not child.name.startswith("."):
                scanned = scan_system(child)
                if scanned:
                    systems.append(scanned)
    eras: dict[str, list[dict]] = {}
    for system in systems:
        eras.setdefault(system["era"], []).append(
            {k: system[k] for k in ("id", "name", "era", "game_count")}
        )
    era_groups = [
        {"era": era, "systems": eras[era]} for era in ERA_ORDER if era in eras
    ]
    return {
        "roms_dir": str(root),
        "system_count": len(systems),
        "game_count": sum(s["game_count"] for s in systems),
        "eras": era_groups,
        "systems": systems,
    }
