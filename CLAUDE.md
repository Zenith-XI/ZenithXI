# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**LandSandBoat** is an open-source server emulator for Final Fantasy XI (FFXI). It is a multi-process C++20 game server with Lua scripting and a MariaDB database backend.

## Build Commands

```bash
# Configure (Release)
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Release

# Configure (Debug)
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Debug

# Build
cmake --build build

# Build specific target (e.g., xi_map)
cmake --build build --target xi_map
```

CMake presets are defined in `CMakeSettings.json` for MSVC: `x64-Release`, `x64-Debug`, `x64-Release-Tracy`, `x64-Debug-Tracy`.

## Testing

```bash
# Run all unit tests
./xi_test

# Run with output report
./xi_test --keep-going --output tests.ctrf.json
```

Full CI test suite also includes:
- `./tools/ci/sanity_checks.sh` — code sanity checks
- `python ./tools/ci/lua_lang_server.py` — Lua language server lint
- `python -m tools.ci.startup_checks` — server startup integration tests (requires running servers)

## Linting / Formatting

```bash
# Format C++ code
python ./tools/run_clang_format.py

# Clang-tidy (static analysis, slow — used in CI)
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Debug -DENABLE_CLANG_TIDY=ON
cmake --build build
```

Style is configured via `.clang-format` (WebKit base + Allman braces) and `.clang-tidy`.

## Architecture

### Server Processes

The emulator runs as five separate processes that communicate via **ZeroMQ (ZMQ)**:

| Binary | Role | Key Ports |
|--------|------|-----------|
| `xi_connect` | Login/auth server | 54001, 54230–54231 |
| `xi_map` | Game world simulation (combat, AI, entities) | 54230 UDP |
| `xi_world` | Global coordination between map instances; HTTP API | 8088 |
| `xi_search` | Auction house / search | 54002 |
| `xi_test` | Test executable | — |

Source for each lives under `src/<name>/`. Shared utilities are in `src/common/`.

### IPC Stubs

Inter-process RPC stubs are **auto-generated** from definitions. After modifying IPC definitions, regenerate with:
```bash
python tools/generate_ipc_stubs.py
```

### Scripting Layer

Game content is implemented in **Lua (LuaJIT)**. Lua scripts are in `scripts/` and era-specific content overrides live in `modules/`. Modules are enabled via `modules/init.txt`.

### Database

MariaDB is used for persistence. Schema migrations are managed with:
```bash
python ./tools/dbtool.py update
```

SQL scripts are in `sql/`.

### Key Directories

| Path | Purpose |
|------|---------|
| `src/common/` | Shared C++ utilities, DB layer, crypto, logging, types |
| `src/map/` | Core game logic — entities, combat, AI, zones |
| `src/login/` | Authentication flow |
| `src/world/` | Cross-map coordination, global state |
| `modules/` | Era/custom content modules (Lua + optional C++) |
| `settings/` | Lua-based server configuration |
| `tools/` | Build helpers, DB management, CI scripts |
| `sql/` | Database schema and migrations |
| `navmeshes/` | AI pathfinding data (git submodule) |
| `losmeshes/` | Line-of-sight mesh data |
| `documentation/` | Game mechanics docs, animation/ID reference data |

## Code Conventions

- C++20 throughout; avoid older patterns when modern equivalents exist.
- Run `python ./tools/run_clang_format.py` before committing C++ changes.
- Lua files should pass the Lua language server check (`tools/ci/lua_lang_server.py`).
- New IPC messages require regenerating stubs via `tools/generate_ipc_stubs.py`.
