#!/usr/bin/env bash
# Regenerates platform-specific branding resources from the Cinebox source assets.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FANART="$ROOT/branding/generated/cinebox-fanart-ruby-shadow.png"
ICON="$ROOT/branding/generated/cinebox-red-c-reel-icon.png"
WORDMARK="$ROOT/branding/generated/cinebox-logo-transparent.png"

require_asset() {
  if [[ ! -f "$1" ]]; then
    echo "Required asset not found: $1" >&2
    exit 1
  fi
}

image_dimensions() {
  ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$1"
}

render_fanart() {
  local destination="$1"
  local width="$2"
  local height="$3"
  ffmpeg -nostdin -loglevel error -y -i "$FANART" \
    -vf "scale=${width}:${height}:force_original_aspect_ratio=decrease,pad=${width}:${height}:(ow-iw)/2:(oh-ih):color=0x090708" \
    -frames:v 1 "$destination"
}

render_icon() {
  local destination="$1"
  local size="$2"
  ffmpeg -nostdin -loglevel error -y -i "$ICON" \
    -vf "scale=${size}:${size}:force_original_aspect_ratio=decrease,pad=${size}:${size}:(ow-iw)/2:(oh-ih):color=0x00000000" \
    -frames:v 1 "$destination"
}

render_wordmark() {
  local destination="$1"
  local width="$2"
  local height="$3"
  ffmpeg -nostdin -loglevel error -y -i "$WORDMARK" \
    -vf "scale=${width}:${height}:force_original_aspect_ratio=decrease,pad=${width}:${height}:(ow-iw)/2:(oh-ih):color=0x00000000" \
    -frames:v 1 "$destination"
}

render_transparent_canvas() {
  local destination="$1"
  local width="$2"
  local height="$3"
  ffmpeg -nostdin -loglevel error -y -f lavfi -i "color=c=black@0.0:s=${width}x${height},format=rgba" \
    -frames:v 1 "$destination"
}

require_asset "$FANART"
require_asset "$ICON"
require_asset "$WORDMARK"

# Shared application art used by the in-app skin, desktop startup and Android.
render_fanart "$ROOT/media/applaunch_screen.png" 1920 1080
render_fanart "$ROOT/media/splash.jpg" 1920 1080
render_fanart "$ROOT/media/banner.png" 320 180
render_icon "$ROOT/media/vendor_icon.png" 128
render_wordmark "$ROOT/media/vendor_logo.png" 465 128
render_icon "$ROOT/media/qr/kodilove/qr-logo.png" 256

for size in 16 32 48 80 120 256; do
  render_icon "$ROOT/media/icon${size}x${size}.png" "$size"
done

# Android and Android TV launcher, recommendation and store assets.
render_icon "$ROOT/tools/android/packaging/media/drawable-ldpi/ic_launcher.png" 36
render_icon "$ROOT/tools/android/packaging/media/drawable-mdpi/ic_launcher.png" 48
render_icon "$ROOT/tools/android/packaging/media/drawable-hdpi/ic_launcher.png" 72
render_icon "$ROOT/tools/android/packaging/media/drawable-xhdpi/ic_launcher.png" 96
render_icon "$ROOT/tools/android/packaging/media/drawable-xxhdpi/ic_launcher.png" 144
render_icon "$ROOT/tools/android/packaging/media/drawable-xxxhdpi/ic_launcher.png" 192
render_fanart "$ROOT/tools/android/packaging/media/drawable-xhdpi/banner.png" 320 180
render_icon "$ROOT/tools/android/packaging/media/playstore.png" 512
render_icon "$ROOT/tools/android/packaging/xbmc/res/drawable/notif_icon.png" 48
render_icon "$ROOT/tools/android/packaging/xbmc/res/drawable/ic_recommendation_80dp.png" 80

# Linux desktop icons, including its scalable icon.
for asset in "$ROOT"/tools/Linux/packaging/media/icon*.png; do
  dims="$(image_dimensions "$asset")"
  width="${dims%,*}"
  render_icon "$asset" "$width"
done
svg_icon="$ROOT/tools/Linux/packaging/media/iconScalable.svg"
svg_png="$(mktemp --suffix=.png)"
render_icon "$svg_png" 512
encoded_png="$(base64 -w 0 "$svg_png")"
cat > "$svg_icon" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">
  <image width="512" height="512" href="data:image/png;base64,${encoded_png}" />
</svg>
EOF
rm -f "$svg_png"

# Apple platform icons and macOS disk image artwork.
find "$ROOT/tools/darwin/packaging/media/ios" -type f -name '*.png' | while IFS= read -r asset; do
  dims="$(image_dimensions "$asset")"
  width="${dims%,*}"
  render_icon "$asset" "$width"
done
find "$ROOT/tools/darwin/packaging/media/osx" -type f -path '*iconset*' -name '*.png' | while IFS= read -r asset; do
  dims="$(image_dimensions "$asset")"
  width="${dims%,*}"
  render_icon "$asset" "$width"
done
render_fanart "$ROOT/tools/darwin/packaging/media/osx/background/DiskImageBackgroundKodi.png" 610 400

# tvOS wordmark stack and top-shelf art.
render_wordmark "$ROOT/xbmc/platform/darwin/tvos/Assets.xcassets/Assets.brandassets/icon.imagestack/Layer1.imagestacklayer/Content.imageset/image@2x.png" 800 480
render_transparent_canvas "$ROOT/xbmc/platform/darwin/tvos/Assets.xcassets/Assets.brandassets/icon.imagestack/Layer2.imagestacklayer/Content.imageset/image@2x.png" 800 480
render_fanart "$ROOT/xbmc/platform/darwin/tvos/Assets.xcassets/Assets.brandassets/topshelf_wide.imageset/image.png" 2320 720

# Windows Store and webOS package art.
render_fanart "$ROOT/tools/windows/packaging/uwp/media/SplashScreen.scale-200.png" 1240 600
render_fanart "$ROOT/tools/windows/packaging/uwp/media/banner310x150.png" 310 150
for asset in "$ROOT"/tools/windows/packaging/uwp/media/icon*.png; do
  dims="$(image_dimensions "$asset")"
  width="${dims%,*}"
  render_icon "$asset" "$width"
done
render_icon "$ROOT/tools/webOS/packaging/icon.png" 80
render_icon "$ROOT/tools/webOS/packaging/largeIcon.png" 130

echo "Cinebox branding assets applied."
