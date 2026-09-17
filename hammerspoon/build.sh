#!/bin/sh
# Build the Hammerspoon "spaceswitch" helper from source (macOS only).
# Called after `dotter deploy` on macOS. Safe no-op elsewhere.
set -e

[ "$(uname)" = "Darwin" ] || { echo "spaceswitch: not macOS, skipping"; exit 0; }

DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$DIR/bin/spaceswitch.swift"
OUT="$HOME/.hammerspoon/bin/spaceswitch"

mkdir -p "$HOME/.hammerspoon/bin"
swiftc -O "$SRC" -o "$OUT"
echo "spaceswitch: built -> $OUT"
