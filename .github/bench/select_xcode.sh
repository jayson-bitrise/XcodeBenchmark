#!/usr/bin/env bash
# Select the same Xcode on every runner (BENCH_XCODE, e.g. 27.2). Build Hub's osx-tahoe-27 image defaults to 27.2;
# GitHub's xcode-27 image ships 27.0, 27.1 (default) and 27.2 side by side.
set -euo pipefail
want="${BENCH_XCODE:?}"
have=$(xcodebuild -version | awk '/^Xcode /{print $2}')
if [ "$have" = "$want" ]; then echo "Xcode $have already selected"; exit 0; fi
for app in "/Applications/Xcode_${want}.app" "/Applications/Xcode-${want}.app" "/Applications/Xcode_${want}.0.app" "/Applications/Xcode-${want}.0.app"; do
  if [ -d "$app" ]; then sudo xcode-select -s "$app/Contents/Developer"; xcodebuild -version; exit 0; fi
done
echo "❌ Xcode $want not found (current: $have)"; ls -d /Applications/Xcode* || true; exit 1
