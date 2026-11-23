#!/bin/bash
# 生成某一天的歌：数据 → WAV/M4A + 封面卡
#
#   ./scripts/make-song.sh            # 今天
#   ./scripts/make-song.sh 2026-11-23
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DAY="${1:-$(date +%Y-%m-%d)}"
OUT="$ROOT/composer/out"
PY="${KEYBOARDIST_PYTHON:-python3}"

mkdir -p "$OUT"

"$PY" "$ROOT/composer/compose.py" --day "$DAY" --out "$OUT/$DAY.wav"
"$PY" "$ROOT/composer/cover.py" \
    --wav "$OUT/$DAY.wav" \
    --meta "$OUT/$DAY.json" \
    --out "$OUT/$DAY.png"

if command -v afconvert >/dev/null 2>&1; then
    afconvert -f m4af -d aac -b 192000 "$OUT/$DAY.wav" "$OUT/$DAY.m4a" >/dev/null 2>&1 || true
fi

echo "完成：$OUT/$DAY.m4a"
echo "封面：$OUT/$DAY.png"
