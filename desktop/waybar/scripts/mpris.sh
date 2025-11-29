#!/usr/bin/env bash

set -euo pipefail

player="$(playerctl -a status --format '{{playerName}} {{status}}' \
  | awk '$2=="Playing"{print $1; exit}')"

case "$player" in
  spotify) appid='Spotify' ;;
  firefox) appid='firefox-bin' ;;
  mpv)     appid='mpv' ;;
  *)       appid='' ;;
esac

if [ -n "$appid" ]; then
  id="$(niri msg -j windows | jq -r --arg app "$appid" '.[] | select(.app_id==$app) | .id' | head -n1)"
  [ -n "${id:-}" ] && exec niri msg action focus-window --id "$id"
fi
