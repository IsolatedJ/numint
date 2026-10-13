# numint — notes for Claude

Phone-number OSINT CLI (Typer) with optional FastAPI web UI and Discord bot.
Python >= 3.11; built with hatchling. Code lives in `src/numint/`.

## Setup / test

- `bash scripts/setup.sh` creates or repairs `.venv` and installs `-e ".[all,dev]"`. Safe to re-run.
- Tests: `.venv/bin/pytest -q` (fully offline; HTTP is mocked with respx).
- Lint: `.venv/bin/ruff check src tests`. Two existing `UP042` (`str, Enum` → `StrEnum`)
  findings come from newer ruff; ruff marks the fix unsafe, so it's left as is.

## Running safely

- `numint <number> --offline` makes no network calls. Use the reserved fictional
  number `+14155550123` for smoke tests.
- Don't run `--presence`, `--lookup`, `--dorking`, API-provider or AI lookups on
  real numbers unless the user explicitly asks and confirms they are authorized.
  These contact third-party sites.
- Start the web UI with `numint web --host 0.0.0.0 --port 8080`.

## Layout

- `core/engine.py` runs the layers (offline, api, ai, presence); `core/aggregator.py` merges results.
- `providers/` holds API data sources (auto-registered); `presence/` holds account checks;
  `ai/` holds LLM adapters.
- `data/*.yaml` holds the lookup, dork, and footprint link lists.
- Config precedence: env var → `~/.config/numint/config.toml` → project `.env`.

## Codespaces

See `docs/CODESPACES.md`. The devcontainer runs `scripts/setup.sh` on create and on start.
