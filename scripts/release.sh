#!/bin/bash
# 发版：构建 → 归档到 dist/versions → 更新快捷方式 → 打 DMG → 打 git tag
#
#   ./scripts/release.sh             # 用当前版本号
#   ./scripts/release.sh 0.4.0       # 顺便改版本号
#
# 版本管理的约定：
#   dist/versions/键盘手-<ver>.app   每个版本留一份，不覆盖
#   dist/键盘手.app                  符号链接，永远指向最新版
#   git tag v<ver>                   代码与二进制对得上
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLIST="$ROOT/Resources/Info.plist"

if [ $# -ge 1 ]; then
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $1" "$PLIST"
    BUMP=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$PLIST")
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $((BUMP + 1))" "$PLIST"
fi

VERSION="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$PLIST")"
BUILD="$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$PLIST")"
STAMP="$(date +%Y%m%d-%H%M)"

echo "→ 构建 键盘手 $VERSION (build $BUILD)"
"$ROOT/scripts/build-app.sh" >/dev/null

mkdir -p "$ROOT/dist/versions"
ARCHIVE="$ROOT/dist/versions/键盘手-$VERSION.app"
rm -rf "$ARCHIVE"
cp -R "$ROOT/dist/键盘手.app" "$ARCHIVE"

# 快捷方式指向最新版
rm -rf "$ROOT/dist/键盘手.app"
ln -s "versions/键盘手-$VERSION.app" "$ROOT/dist/键盘手.app"

# 打 DMG（用归档副本，避免符号链接进包）
DMG="$ROOT/dist/键盘手-$VERSION.dmg"
if [ "${SKIP_DMG:-0}" != "1" ]; then
    STAGE="$ROOT/.build/dmg-stage"
    rm -rf "$STAGE"; mkdir -p "$STAGE"
    cp -R "$ARCHIVE" "$STAGE/键盘手.app"
    cp "$ROOT/Resources/安装说明.txt" "$STAGE/安装说明.txt"
    ln -s /Applications "$STAGE/Applications"
    codesign --force --sign - --identifier "com.liyaming.keyboardist" "$STAGE/键盘手.app" 2>/dev/null || true
    rm -f "$DMG"
    hdiutil create -volname "键盘手 $VERSION" -srcfolder "$STAGE" -ov -format UDZO "$DMG" >/dev/null
    echo "→ DMG: $DMG"
fi

if [ "${SKIP_DMG:-0}" != "1" ]; then
# 更新通道：DMG 进 releases/，appcast.json 给「检查更新」用
mkdir -p "$ROOT/releases"
cp "$DMG" "$ROOT/releases/keyboardist-$VERSION.dmg"
ls -t "$ROOT/releases"/keyboardist-*.dmg 2>/dev/null | tail -n +4 | xargs -r rm -f

NOTES="${2:-$(git -C "$ROOT" log -1 --pretty=%s 2>/dev/null || echo "")}"
cat > "$ROOT/appcast.json" <<JSON
{
  "version": "$VERSION",
  "build": $BUILD,
  "url": "https://raw.githubusercontent.com/Liam-liyaming/keyboardist/main/releases/keyboardist-$VERSION.dmg",
  "notes": "$NOTES",
  "releasedAt": "$(date +%Y-%m-%d)"
}
JSON
echo "→ appcast.json: $VERSION"
fi

# 代码与二进制对齐
cd "$ROOT"
if git rev-parse --git-dir >/dev/null 2>&1; then
    git add -A
    if ! git diff --cached --quiet; then
        git commit -q -m "release: v$VERSION (build $BUILD)"
    fi
    git tag -f "v$VERSION" >/dev/null
    echo "→ git tag v$VERSION"
fi

echo
echo "✅ v$VERSION  build $BUILD  $STAMP"
echo "   最新:  $ROOT/dist/键盘手.app  →  versions/键盘手-$VERSION.app"
echo "   归档:  $(ls -1 "$ROOT/dist/versions" | tail -5 | tr '\n' '  ')"
