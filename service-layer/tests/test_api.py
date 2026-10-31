"""Scanner, Memory Card, and API tests against a synthetic roms tree."""

from __future__ import annotations

import pytest
from fastapi.testclient import TestClient

from vettv_service.memory_card import list_saves
from vettv_service.rom_scanner import clean_title, scan_roms


@pytest.fixture()
def roms(tmp_path):
    root = tmp_path / "roms"
    (root / "nes").mkdir(parents=True)
    (root / "nes" / "Test Quest (USA).nes").write_bytes(b"\x00" * 128)
    (root / "nes" / "images").mkdir()
    (root / "nes" / "images" / "Test Quest-image.png").write_bytes(b"\x00")
    (root / "nes" / "gamelist.xml").write_text("<gameList/>")
    (root / "snes").mkdir()
    (root / "snes" / "Star Racer.smc").write_bytes(b"\x00" * 256)
    (root / "psx").mkdir()  # empty system must not appear
    (root / "unknownsys").mkdir()
    (root / "unknownsys" / "Mystery.bin").write_bytes(b"\x00" * 64)
    return root


def test_clean_title():
    assert clean_title("Test Quest (USA).nes") == "Test Quest"
    assert clean_title("Game [Beta].bin") == "Game"


def test_scan_groups_by_era_and_skips_media(roms):
    result = scan_roms(roms)
    assert result["system_count"] == 3
    assert result["game_count"] == 3
    eras = {g["era"]: [s["id"] for s in g["systems"]] for g in result["eras"]}
    assert eras["8-bit Era"] == ["nes"]
    assert eras["16-bit Era"] == ["snes"]
    assert eras["More Systems"] == ["unknownsys"]
    nes = next(s for s in result["systems"] if s["id"] == "nes")
    assert nes["games"][0]["title"] == "Test Quest"


def test_missing_dir_scans_empty(tmp_path):
    result = scan_roms(tmp_path / "nope")
    assert result["system_count"] == 0
    assert result["eras"] == []


def test_list_saves(tmp_path):
    saves = tmp_path / "saves" / "nes"
    saves.mkdir(parents=True)
    (saves / "Test Quest (USA).state1").write_bytes(b"\x00" * 10)
    (saves / "Test Quest (USA).srm").write_bytes(b"\x00" * 10)
    result = list_saves(tmp_path / "saves", "nes", "/roms/nes/Test Quest (USA).nes")
    assert result["battery_save"]["file"].endswith(".srm")
    assert result["states"][0]["slot"] == "1"


@pytest.fixture()
def client(roms, monkeypatch):
    monkeypatch.setenv("VETTV_LAUNCH_DRY_RUN", "1")
    import vettv_service.main as main

    main.ROMS_DIR = str(roms)
    main.launcher = main.Launcher(str(roms))
    return TestClient(main.app)


def test_health_and_systems(client, roms):
    assert client.get("/health").json()["status"] == "ok"
    body = client.get("/systems").json()
    assert body["game_count"] == 3
    games = client.get("/systems/nes/games").json()
    assert games["games"][0]["title"] == "Test Quest"
    assert client.get("/systems/psx/games").status_code == 404


def test_launch_dry_run_and_guard(client, roms):
    rom = str(roms / "nes" / "Test Quest (USA).nes")
    launched = client.post("/launch", json={"system": "nes", "game_path": rom})
    assert launched.status_code == 200
    assert client.get("/status").json()["running"] is True
    # Second launch while running conflicts.
    assert client.post("/launch", json={"system": "nes", "game_path": rom}).status_code == 409
    assert client.post("/stop").json()["stopped"] is True
    # Path outside roms is rejected.
    outside = client.post("/launch", json={"system": "nes", "game_path": "/etc/hostname"})
    assert outside.status_code == 409
