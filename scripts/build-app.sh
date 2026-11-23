#!/bin/bash
# 构建「键盘手」.app（universal：arm64 + x86_64）
#
# 为什么不用 swift build --arch：
#   多架构构建依赖 Xcode 的 xcbuild，只有 Command Line Tools 的机器上会报
#   "xcbuild executable does not exist"。这里直接用 swiftc 交叉编译两个
#   架构，再用 lipo 合并，效果一样且不依赖 Xcode。
#
# 签名：
#   自动检测本地证书 "Keyboardist Dev"，没有就 ad-hoc。
#   可以用 KEYBOARDIST_IDENTITY / KEYBOARDIST_ADHOC=1 覆盖。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SDK="$(xcrun --show-sdk-path)"
SRC="$(find "$ROOT/Sources" -name '*.swift' | tr '\n' ' ')"
WORK="$ROOT/.build/universal"
DEPLOY="12.0"

mkdir -p "$WORK" "$ROOT/.build/caches/clang"

build_arch() {
    local arch="$1" out="$2"
    swiftc -O -target "${arch}-apple-macosx${DEPLOY}" -sdk "$SDK" \
        -module-cache-path "$ROOT/.build/caches/clang" \
        $SRC -o "$out" \
        -framework AppKit -framework ApplicationServices \
        -framework Carbon -framework QuartzCore
}

echo "→ 编译 arm64"
build_arch arm64 "$WORK/Keyboardist-arm64"
echo "→ 编译 x86_64"
build_arch x86_64 "$WORK/Keyboardist-x86_64"
lipo -create "$WORK/Keyboardist-arm64" "$WORK/Keyboardist-x86_64" \
    -output "$WORK/Keyboardist"
echo "→ 架构：$(lipo -info "$WORK/Keyboardist" | sed 's/.*are: //')"

APP="$ROOT/dist/键盘手.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$WORK/Keyboardist" "$APP/Contents/MacOS/Keyboardist"
cp "$ROOT/Resources/Info.plist" "$APP/Contents/Info.plist"
if [ -f "$ROOT/Resources/AppIcon.icns" ]; then
    cp "$ROOT/Resources/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"
fi
chmod +x "$APP/Contents/MacOS/Keyboardist"

IDENTITY="${KEYBOARDIST_IDENTITY:-}"
if [ "${KEYBOARDIST_ADHOC:-0}" = "1" ]; then
    IDENTITY=""
fi
if [ -z "$IDENTITY" ] && security find-identity -v -p codesigning 2>/dev/null | grep -q "Keyboardist Dev"; then
    IDENTITY="Keyboardist Dev"
fi

if [ -n "$IDENTITY" ]; then
    codesign --force --sign "$IDENTITY" \
        --identifier "com.liyaming.keyboardist" "$APP"
    echo "signed with: ${IDENTITY}（重新编译不会掉权限）"
else
    codesign --force --sign - --identifier "com.liyaming.keyboardist" "$APP" 2>/dev/null
    echo "signed: ad-hoc（改代码重新编译后需重新授权）"
fi

echo "built: $APP"
