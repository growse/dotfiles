#!/bin/bash
# Rebuilds the top panel and its widgets from plasma-panel-layout.js.
# Safe to re-run: it removes any existing panels first.
set -euo pipefail

layout="$HOME/.config/plasma-panel-layout.js"

qdbus_bin=$(command -v qdbus6 || command -v qdbus || true)
if [[ -z "$qdbus_bin" ]]; then
  echo "qdbus6/qdbus not found (install qt6-tools)" >&2
  exit 1
fi

"$qdbus_bin" org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat "$layout")"

echo "Panel layout applied. Pin the system tray icons you want always-visible"
echo "(network, bluetooth, volume, battery, brightness, clipboard,"
echo "notifications, keyboard layout/indicator, weather, camera, media"
echo "controller) via the system tray's chevron -> right-click -> 'Show'."
