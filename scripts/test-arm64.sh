#!/bin/bash
set -euo pipefail
spectacle_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$spectacle_root"
mkdir -p build
xcodebuild -project Spectacle.xcodeproj -scheme Spectacle -configuration Debug \
  -destination 'platform=macOS,arch=arm64' -derivedDataPath build/DerivedData \
  -parallel-testing-enabled NO test > build/xctest.log 2>&1
# The XCTest target has no test host and never launches Spectacle.
tail -8 build/xctest.log
