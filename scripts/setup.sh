#!/usr/bin/env bash
# Create/repair the local virtualenv and install numint with all extras.
# Safe to re-run: reuses .venv if it is healthy, rebuilds it if it is broken.
set -euo pipefail

cd "$(dirname "$0")/.."

PY="${PYTHON:-}"
if [ -z "$PY" ]; then
  for cand in python3.12 python3.13 python3.11 python3; do
    if command -v "$cand" >/dev/null 2>&1; then PY="$cand"; break; fi
  done
fi
[ -n "$PY" ] || { echo "No python3 found" >&2; exit 1; }

if [ -x .venv/bin/python ] && ! .venv/bin/python -c "import sys" >/dev/null 2>&1; then
  echo "Existing .venv is broken; rebuilding it"
  rm -rf .venv
fi
[ -x .venv/bin/python ] || "$PY" -m venv .venv

.venv/bin/python -m pip install --quiet --upgrade pip
.venv/bin/pip install --quiet -e ".[all,dev]"

.venv/bin/numint --version
echo "Ready. Run: source .venv/bin/activate"
