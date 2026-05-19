#!/usr/bin/env bash
# Triggered by yabai signals on window_resized / window_destroyed.
# When a window enters zoom-fullscreen, minimize the other tiled windows on
# the same space and record their ids. When it leaves zoom-fullscreen (or is
# destroyed), restore exactly those windows.

set -u

state_dir="/tmp/yabai-zoom-hide"
mkdir -p "$state_dir"

wid="${YABAI_WINDOW_ID:-}"
[ -z "$wid" ] && exit 0

state_file="$state_dir/$wid"
event="${YABAI_EVENT:-}"

restore() {
  [ -f "$state_file" ] || return 0
  while read -r id; do
    [ -n "$id" ] && yabai -m window "$id" --deminimize 2>/dev/null
  done < "$state_file"
  rm -f "$state_file"
}

if [ "$event" = "window_destroyed" ]; then
  restore
  exit 0
fi

info=$(yabai -m query --windows --window "$wid" 2>/dev/null) || exit 0
[ -z "$info" ] && exit 0

zoomed=$(printf '%s' "$info" | jq -r '."has-fullscreen-zoom"')
space=$(printf '%s' "$info" | jq -r '.space')

if [ "$zoomed" = "true" ] && [ ! -f "$state_file" ]; then
  yabai -m query --windows --space "$space" \
    | jq -r --argjson w "$wid" '
        .[]
        | select(.id != $w)
        | select(."is-minimized" == false)
        | select(."is-floating" == false)
        | select(."is-sticky" == false)
        | .id' \
    > "$state_file"
  while read -r id; do
    [ -n "$id" ] && yabai -m window "$id" --minimize 2>/dev/null
  done < "$state_file"
elif [ "$zoomed" = "false" ]; then
  restore
fi
