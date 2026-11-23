#!/bin/bash
# 打包成可分发的 DMG
#
#   ./scripts/package-dmg.sh
#
# 说明：
#   本地构建用的是自签名证书（只在开发机上受信任）。
#   拷进 DMG 的那份会被重新签成 ad-hoc —— 对别人的机器来说两者一样是
#   「无法验证开发者」，但 ad-hoc 给出的提示更标准，不会误报「已损坏」。
#   真正的免打扰分发需要 Apple Developer ID + 公证（见 README）。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$ROOT/Resources/Info.plist")"
STAGE="$ROOT/.build/dmg-stage"
OUT="$ROOT/dist/键盘手-${VERSION}.dmg"

echo "→ 构建 $VERSION"
"$ROOT/scripts/build-app.sh" >/dev/null

echo "→ 准备分发目录"
rm -rf "$STAGE"
mkdir -p "$STAGE"
cp -R "$ROOT/dist/键盘手.app" "$STAGE/键盘手.app"
cp "$ROOT/Resources/安装说明.txt" "$STAGE/安装说明.txt"
ln -s /Applications "$STAGE/Applications"

echo "→ 分发版改签 ad-hoc（对方的 Gatekeeper 本来就只认 Developer ID）"
codesign --force --sign - --identifier "com.liyaming.keyboardist" "$STAGE/键盘手.app" 2>/dev/null

echo "→ 生成 DMG"
rm -f "$OUT"
hdiutil create -volname "键盘手 $VERSION" \
    -srcfolder "$STAGE" -ov -format UDZO \
    "$OUT" >/dev/null

SIZE="$(du -h "$OUT" | cut -f1)"
echo "✅ $OUT ($SIZE)"
