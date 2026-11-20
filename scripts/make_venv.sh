#!/usr/bin/env bash
# Usage: make_venv.sh gpu|cpu
set -euo pipefail
KIND="$1"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
BASE="$HOME/.virtualenvs/UT_AICITY2025_Track4"
VENV="$BASE/.venv-$KIND"
if [ "$KIND" = gpu ]; then FORK=YoloV10; else FORK=YoloV13; fi

mkdir -p "$BASE"
rm -rf "$VENV"
python3.12 -m venv "$VENV"
"$VENV/bin/python" -m pip install -q --upgrade pip setuptools wheel
"$VENV/bin/python" -m pip install -r "$REPO/requirements-$KIND.txt"
"$VENV/bin/python" -m pip install -r "$REPO/requirements-models.txt" -e "$REPO/train/$FORK"

SITE=$("$VENV/bin/python" -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')
echo "$REPO/train/YoloR" > "$SITE/aicity_yolor.pth"

ln -sfn "$VENV" "$REPO/.venv-$KIND"
echo "DONE $KIND"
