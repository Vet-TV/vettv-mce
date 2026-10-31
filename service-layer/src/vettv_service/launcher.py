"""Launch games through Batocera's emulatorlauncher and track the run.

Batocera already owns core selection, bezels, and controller config via
emulatorlauncher - the service wraps it instead of reinventing it. Set
VETTV_LAUNCH_DRY_RUN=1 to exercise the API without launching (dev/tests).
"""

from __future__ import annotations

import os
import shutil
import subprocess
import time
from pathlib import Path


class LaunchError(RuntimeError):
    pass


class Launcher:
    def __init__(self, roms_dir: str | Path):
        self.roms_dir = Path(roms_dir).resolve()
        self.process: subprocess.Popen | None = None
        self.current: dict | None = None

    @property
    def dry_run(self) -> bool:
        return os.environ.get("VETTV_LAUNCH_DRY_RUN") == "1"

    def _validate(self, system: str, game_path: str) -> Path:
        path = Path(game_path).resolve()
        if self.roms_dir not in path.parents and path != self.roms_dir:
            raise LaunchError("game path is outside the roms directory")
        if not path.is_file():
            raise LaunchError("game file does not exist")
        if path.parent.name != system and system not in path.parts:
            raise LaunchError("game does not belong to the requested system")
        return path

    def launch(self, system: str, game_path: str) -> dict:
        if self.status()["running"]:
            raise LaunchError("a game is already running; stop it first")
        path = self._validate(system, game_path)
        if self.dry_run:
            self.current = {
                "system": system,
                "game": path.name,
                "path": str(path),
                "pid": None,
                "dry_run": True,
                "started_at": time.time(),
            }
            return self.current
        binary = shutil.which("emulatorlauncher")
        if binary is None:
            raise LaunchError("emulatorlauncher not found (not running on Batocera?)")
        self.process = subprocess.Popen(
            [binary, "-console", system, "-rom", str(path)],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        self.current = {
            "system": system,
            "game": path.name,
            "path": str(path),
            "pid": self.process.pid,
            "dry_run": False,
            "started_at": time.time(),
        }
        return self.current

    def status(self) -> dict:
        if self.current is None:
            return {"running": False, "current": None}
        if self.current.get("dry_run"):
            return {"running": True, "current": self.current}
        if self.process is not None and self.process.poll() is None:
            return {"running": True, "current": self.current}
        finished = self.current
        self.current = None
        self.process = None
        return {"running": False, "current": None, "last_finished": finished}

    def stop(self) -> dict:
        was = self.status()
        if self.process is not None and self.process.poll() is None:
            self.process.terminate()
            try:
                self.process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                self.process.kill()
        self.current = None
        self.process = None
        return {"stopped": was["running"], "was": was.get("current")}
