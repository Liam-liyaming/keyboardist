#!/bin/bash
# 把最新构建装到 /Applications，并重启
#
#   ./scripts/install.sh          # 装最新版本
#   ./scripts/install.sh 0.3.0    # 装某个历史版本（回滚）
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$ROOT/Resources/Info.plist")}"

SRC="$ROOT/dist/versions/键盘手-$VERSION.app"
TARGET="/Applications/键盘手.app"

[ -d "$SRC" ] || { echo "找不到 $SRC（先跑 ./scripts/release.sh）"; exit 1; }

echo "→ 退出正在运行的版本"
pkill -f "键盘手.app/Contents/MacOS/Keyboardist" 2>/dev/null || true
sleep 1

echo "→ 安装 $VERSION 到 /Applications"
rm -rf "$TARGET"
cp -R "$SRC" "$TARGET"

echo "→ 启动"
open -n "$TARGET"
sleep 2
pgrep -f "/Applications/键盘手.app/Contents/MacOS/Keyboardist" >/dev/null \
  && echo "✅ 已运行：$("$TARGET/Contents/MacOS/Keyboardist" --version 2>/dev/null || echo "$VERSION")" \
  || echo "⚠️ 没起来，检查崩溃日志"
