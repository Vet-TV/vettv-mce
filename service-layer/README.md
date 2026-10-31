# service-layer/

**Layer 2 — The Bridge.** Python daemon between the Godot frontend and the Batocera backend.

## Responsibilities

- Launching emulator cores with the correct ROMs
- Launching cloud gaming wrappers (GFN, Xbox Cloud, Luna, Boosteroid)
- Controller state management
- System metrics (CPU, GPU, network — for streaming health)
- Save state sync and "Memory Card" persistence

## Stack

- Python 3.11+
- FastAPI
- Localhost HTTP on `127.0.0.1:8471` (optional Unix socket via `VETTV_SOCKET` on the OS image)

## Layout

```text
service-layer/
├── pyproject.toml
├── src/vettv_service/
│   ├── __init__.py
│   ├── main.py            # FastAPI app (127.0.0.1:8471, optional Unix socket)
│   ├── rom_scanner.py     # ROM discovery, era grouping, clean titles
│   ├── launcher.py        # emulatorlauncher wrapper, path validation
│   └── memory_card.py     # save-state / battery-save listing
└── tests/
    └── test_api.py        # API tests (run: .venv/Scripts/python -m pytest tests -q)
```

## API (Phase 3)

- `GET /health` — service status, version, ROM directory
- `GET /systems` — systems grouped by era, with game counts
- `GET /systems/{id}/games` — game list for one system
- `GET /saves/{system}?game_path=<path>` — `.state*` / `.srm` saves for a game
- `POST /launch` `{system, game_path}` — launch via Batocera `emulatorlauncher`; paths must stay inside the ROM directory; one game at a time
- `POST /stop` — stop the running game
- `GET /status` — current launch state
- Set `VETTV_LAUNCH_DRY_RUN=1` to exercise the API without starting an emulator (host development)

## Phase status

- **Phase 0–2:** not active
- **Phase 3:** online — ROM scanning + era grouping, launch/stop/status, Memory Card save listing; runs in the VM as the `vettv_service` Batocera user service alongside `vettv_frontend`. ScreenScraper metadata is still to come
- **Phase 4:** cloud wrapper launches, controller passthrough, connection health
