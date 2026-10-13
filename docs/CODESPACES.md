# Running Numint in GitHub Codespaces (iPhone-friendly)

## Why the iPhone / a-Shell install failed

- `BackendUnavailable: Cannot import 'maturin'` — numint itself builds with
  `hatchling`, but its dependency `pydantic-core` is written in Rust. PyPI has no
  prebuilt iOS wheels, so pip tried to compile it and needed `maturin` + Rust,
  which a-Shell can't provide.
- `FileNotFoundError: python3` / `No module named 'numint'` — follow-on failures
  after the install never completed.

On Codespaces (Linux x86_64), every dependency has a prebuilt wheel, so no Rust
toolchain or compilation is needed.

## First start

The repo ships `.devcontainer/devcontainer.json`. When a Codespace is created from
this branch it uses Python 3.12 and runs `scripts/setup.sh`, which creates `.venv`
and installs `numint` with every extra (web, pdf, discord, dev tools).

If your Codespace was created **before** these files existed, rebuild it once:
Command Palette (`⌘⇧P`, or **☰ → Command Palette** on iPhone) →
**Codespaces: Rebuild Container**.

## After the Codespace sleeps

Codespaces stop after inactivity (default 30 min). Your files and `.venv` are kept.

1. Open <https://github.com/codespaces> in Safari and tap the codespace to resume it.
2. On each start, `scripts/setup.sh` runs again. It checks the venv, repairs it if
   it's broken, and does nothing otherwise.
3. If anything looks wrong, run the task **numint: setup / repair venv**.

Tip: add `github.com/codespaces` to your iPhone Home Screen (Share → Add to Home
Screen) so reopening takes one tap.

## Running things without typing commands

Command Palette → **Tasks: Run Task**, then pick:

| Task | What it does |
| --- | --- |
| numint: setup / repair venv | create or fix `.venv` and install |
| numint: run tests | offline pytest suite |
| numint: lint | `ruff check` |
| numint: list providers & keys | shows which API keys are configured |
| numint: offline lookup (prompt for number) | libphonenumber-only lookup, no network |
| numint: start web UI (port 8080) | starts the browser UI |

For the web UI, open the **Ports** tab and tap the globe icon next to port 8080.
The port stays **private** (only your GitHub login can open it). Don't make it
public: anyone with the URL could run lookups.

## API keys (secrets)

Pick one of these:

- **Codespaces secrets (recommended):** github.com → Settings → Codespaces →
  Secrets. Add e.g. `NUMVERIFY_API_KEY` and give it access to this repo. It shows
  up as an environment variable the next time the codespace starts.
- **Local `.env`:** copy `.env.example` to `.env` and fill it in. `.env` and
  `.env.*` (except `.env.example`) are git-ignored.

Never paste keys into chat with Claude or into committed files.

## Working with Claude

`CLAUDE.md` at the repo root tells Claude how to set up, test, and run the
project. Ask things like "run the tests and fix any failures" or "the web UI
won't start, debug it".
