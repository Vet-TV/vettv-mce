"""Memory Card persistence: list Batocera save states for a game.

Batocera/RetroArch saves live under <saves_dir>/<system>/<rom stem>.state*
plus .srm battery saves. This is the read side of the blueprint's
virtual Memory Card; sync arrives in later phases.
"""

from __future__ import annotations

from pathlib import Path


def list_saves(saves_dir: str | Path, system: str, game_path: str) -> dict:
    root = Path(saves_dir) / system
    stem = Path(game_path).stem
    states: list[dict] = []
    battery: dict | None = None
    if root.is_dir():
        for entry in sorted(root.iterdir()):
            if not entry.is_file():
                continue
            if entry.name == f"{stem}.srm":
                battery = {"file": entry.name, "size_bytes": entry.stat().st_size}
            elif entry.name.startswith(f"{stem}.state"):
                states.append(
                    {
                        "file": entry.name,
                        "slot": entry.suffix.lstrip(".").removeprefix("state") or "auto",
                        "size_bytes": entry.stat().st_size,
                        "modified": entry.stat().st_mtime,
                    }
                )
    return {"system": system, "game": Path(game_path).name, "states": states, "battery_save": battery}
