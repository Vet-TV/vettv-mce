"""VetTV MCE service daemon (Layer 2, the Bridge).

FastAPI over localhost HTTP for development and the Godot frontend, with
optional Unix-socket serving on the OS image (VETTV_SOCKET). The frontend
is the only intended client; nothing here binds beyond 127.0.0.1 by
default.

Config (environment):
  VETTV_ROMS_DIR   default /userdata/roms, else ~/roms
  VETTV_SAVES_DIR  default /userdata/saves, else ~/saves
  VETTV_HOST       default 127.0.0.1
  VETTV_PORT       default 8471
  VETTV_SOCKET     optional Unix socket path (takes precedence over TCP)
"""

from __future__ import annotations

import os
from pathlib import Path

import uvicorn
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from . import __version__
from .launcher import Launcher, LaunchError
from .memory_card import list_saves
from .rom_scanner import scan_roms


def _default_dir(env_name: str, userdata_path: str, home_name: str) -> str:
    if os.environ.get(env_name):
        return os.environ[env_name]
    if Path(userdata_path).is_dir():
        return userdata_path
    return str(Path.home() / home_name)


ROMS_DIR = _default_dir("VETTV_ROMS_DIR", "/userdata/roms", "roms")
SAVES_DIR = _default_dir("VETTV_SAVES_DIR", "/userdata/saves", "saves")

app = FastAPI(title="VetTV MCE Service", version=__version__)
launcher = Launcher(ROMS_DIR)


class LaunchRequest(BaseModel):
    system: str
    game_path: str


@app.get("/health")
def health() -> dict:
    return {
        "status": "ok",
        "service": "vettv-service",
        "version": __version__,
        "roms_dir": ROMS_DIR,
    }


@app.get("/systems")
def systems() -> dict:
    return scan_roms(ROMS_DIR)


@app.get("/systems/{system_id}/games")
def games(system_id: str) -> dict:
    scanned = scan_roms(ROMS_DIR)
    for system in scanned["systems"]:
        if system["id"] == system_id:
            return system
    raise HTTPException(status_code=404, detail=f"unknown or empty system: {system_id}")


@app.get("/saves/{system_id}")
def saves(system_id: str, game_path: str) -> dict:
    return list_saves(SAVES_DIR, system_id, game_path)


@app.post("/launch")
def launch(req: LaunchRequest) -> dict:
    try:
        return {"launched": launcher.launch(req.system, req.game_path)}
    except LaunchError as exc:
        raise HTTPException(status_code=409, detail=str(exc)) from exc


@app.post("/stop")
def stop() -> dict:
    return launcher.stop()


@app.get("/status")
def status() -> dict:
    return launcher.status()


def run() -> None:
    socket_path = os.environ.get("VETTV_SOCKET")
    if socket_path:
        uvicorn.run(app, uds=socket_path, log_level="info")
    else:
        uvicorn.run(
            app,
            host=os.environ.get("VETTV_HOST", "127.0.0.1"),
            port=int(os.environ.get("VETTV_PORT", "8471")),
            log_level="info",
        )


if __name__ == "__main__":
    run()
