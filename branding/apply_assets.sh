#!/usr/bin/env bash
# Regenerates platform-specific resources from the original Cinebox assets.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPLASH="$ROOT/branding/generated/cinebox-applaunch-screen.png"
ICON="$ROOT/branding/generated/cinebox-c-icon.png"

require_asset() {
  if [[ ! -f "$1" ]]; then
    echo "Required asset not found: $1" >&2
    exit 1
  fi
}

render_widescreen() {
  local destination="$1"
  local width="$2"
  local height="$3"
  ffmpeg -loglevel error -y -i "$SPLASH" \
    -vf "scale=${width}:${height}:force_original_aspect_ratio=decrease,pad=${width}:${height}:(ow-iw)/2:(oh-ih):color=0x170808" \
    -frames:v 1 "$destination"
}

render_icon() {
  local destination="$1"
  local size="$2"
  ffmpeg -loglevel error -y -i "$ICON" \
    -vf "scale=${size}:${size}:force_original_aspect_ratio=decrease,pad=${size}:${size}:(ow-iw)/2:(oh-ih):color=0x00000000" \
    -frames:v 1 "$destination"
}

require_asset "$SPLASH"
require_asset "$ICON"

render_widescreen "$ROOT/media/applaunch_screen.png" 1920 1080
render_widescreen "$ROOT/media/splash.jpg" 1920 1080
render_widescreen "$ROOT/media/banner.png" 320 180

for size in 16 32 48 80 120 256; do
  render_icon "$ROOT/media/icon${size}x${size}.png" "$size"
done

render_icon "$ROOT/tools/android/packaging/media/drawable-ldpi/ic_launcher.png" 36
render_icon "$ROOT/tools/android/packaging/media/drawable-mdpi/ic_launcher.png" 48
render_icon "$ROOT/tools/android/packaging/media/drawable-hdpi/ic_launcher.png" 72
render_icon "$ROOT/tools/android/packaging/media/drawable-xhdpi/ic_launcher.png" 96
render_icon "$ROOT/tools/android/packaging/media/drawable-xxhdpi/ic_launcher.png" 144
render_icon "$ROOT/tools/android/packaging/media/drawable-xxxhdpi/ic_launcher.png" 192

echo "Cinebox assets applied."
