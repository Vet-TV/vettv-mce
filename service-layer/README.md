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
- Local IPC via Unix sockets (no network exposure by default)

## Layout (planned)

```text
service-layer/
├── pyproject.toml
├── src/vettv_service/
│   ├── __init__.py
│   ├── main.py            # FastAPI app + Unix-socket server
│   ├── launchers/         # emulator + cloud wrappers
│   ├── memory_card/       # save state sync, persistence
│   ├── metrics/           # CPU/GPU/network monitors
│   └── controllers/       # SDL2-side state mirror
└── tests/
```

## Phase status

- **Phase 0–2:** not yet active
- **Phase 3:** comes online — ROM scanning, ScreenScraper metadata, RetroArch launch, save-state Memory Card
- **Phase 4:** cloud wrapper launches, controller passthrough, connection health
