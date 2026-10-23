#!/bin/bash
set -euo pipefail
spectacle_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$spectacle_root"
mkdir -p build/apple-silicon
xcodebuild -project Spectacle.xcodeproj -scheme Spectacle -configuration Release \
  -destination 'platform=macOS,arch=arm64' -derivedDataPath build/DerivedData build \
  > build/release-build.log 2>&1
spectacle_product="$spectacle_root/build/DerivedData/Build/Products/Release/Spectacle.app"
spectacle_app="$spectacle_root/build/apple-silicon/Spectacle.app"
spectacle_zip="$spectacle_root/build/apple-silicon/spectacle_apple_silicon_ver_1.0.zip"
# This path is always our generated staging product, never the installed application.
if [[ -e "$spectacle_app" ]]; then rm -rf "$spectacle_app"; fi
ditto "$spectacle_product" "$spectacle_app"
cp LICENSE.md "$spectacle_app/Contents/Resources/LICENSE.md"
codesign --force --sign - "$spectacle_app"
python3 scripts/verify-app.py "$spectacle_app"
ditto -c -k --norsrc --keepParent "$spectacle_app" "$spectacle_zip"
python3 scripts/verify-app.py "$spectacle_zip"
(
  cd "$(dirname "$spectacle_zip")"
  shasum -a 256 "$(basename "$spectacle_zip")" > "$(basename "$spectacle_zip").sha256"
)
