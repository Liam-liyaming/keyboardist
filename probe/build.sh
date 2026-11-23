#!/bin/bash
# 构建 M0 探针 .app（本地 ad-hoc 签名；TCC 会以这个 bundle 的身份弹窗）
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
APP="$DIR/KeyboardistProbe.app"

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"

# 沙箱环境下默认 module cache 不可写，必须指到工作区内
mkdir -p "$DIR/.build/modulecache"

swiftc -O "$DIR/Probe.swift" \
    -module-cache-path "$DIR/.build/modulecache" \
    -o "$APP/Contents/MacOS/KeyboardistProbe" \
    -framework Cocoa -framework ApplicationServices -framework Carbon

cp "$DIR/Info.plist" "$APP/Contents/Info.plist"

codesign --force --sign - --identifier "com.liyaming.keyboardist.probe" --timestamp=none "$APP" 2>/dev/null \
  || codesign --force --sign - --identifier "com.liyaming.keyboardist.probe" "$APP"

echo "built: $APP"
