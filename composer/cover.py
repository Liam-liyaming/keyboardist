#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""键盘手 · 每日之歌封面卡：把一天的输入画像画成一张可分享的图。"""

from __future__ import annotations

import argparse
import json
import wave
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont

W, H = 1200, 630
BG = (10, 13, 18)
INK = (240, 244, 250)
MUTED = (138, 148, 166)
ACCENT = (94, 234, 232)
WARM = (255, 176, 96)

FONT_CANDIDATES = [
    "/System/Library/Fonts/Hiragino Sans GB.ttc",
    "/System/Library/Fonts/STHeiti Medium.ttc",
    "/System/Library/Fonts/STHeiti Light.ttc",
]


def font(size: int) -> ImageFont.FreeTypeFont:
    for path in FONT_CANDIDATES:
        if Path(path).exists():
            try:
                return ImageFont.truetype(path, size, index=0)
            except Exception:
                continue
    return ImageFont.load_default()


def load_wave(path: Path) -> np.ndarray:
    with wave.open(str(path), "rb") as w:
        n, ch = w.getnframes(), w.getnchannels()
        data = np.frombuffer(w.readframes(n), dtype="<i2").astype(np.float32) / 32768
    return data.reshape(-1, ch).mean(axis=1)


def draw_glow(img: Image.Image) -> None:
    """底部一层柔光，和 App 里的辉光呼应。"""
    glow = Image.new("RGB", (W, 260), (0, 0, 0))
    g = glow.load()
    for y in range(260):
        t = y / 259
        strength = (1 - t) ** 2.2
        r = int(10 + 90 * strength)
        gg = int(13 + 120 * strength)
        b = int(18 + 150 * strength)
        for x in range(W):
            g[x, y] = (r, gg, b)
    mask = Image.new("L", (W, 260), 0)
    m = mask.load()
    for y in range(260):
        for x in range(W):
            m[x, y] = int(120 * (y / 259) ** 1.4)
    img.paste(glow, (0, H - 260), mask)


def draw_wave(draw: ImageDraw.ImageDraw, wave_data: np.ndarray, top: int, height: int) -> None:
    """RMS 包络波形：比峰值包络更能看出呼吸感。"""
    points = 220
    left, width = 80, W - 160
    step = max(1, len(wave_data) // points)

    vals = []
    for i in range(points):
        seg = wave_data[i * step:(i + 1) * step]
        vals.append(float(np.sqrt(np.mean(seg ** 2))) if len(seg) else 0.0)

    k = np.array([1, 2, 3, 2, 1], dtype=float)
    vals = np.convolve(vals, k / k.sum(), mode="same")
    peak = max(vals) or 1.0

    mid = top + height / 2
    upper, lower = [], []
    for i, v in enumerate(vals):
        x = left + i * (width / points)
        h = (v / peak) ** 0.8 * (height / 2)
        upper.append((x, mid - h))
        lower.append((x, mid + h))

    draw.polygon(upper + lower[::-1], fill=ACCENT + (60,))
    draw.line(upper, fill=ACCENT + (215,), width=2)
    draw.line(lower, fill=ACCENT + (110,), width=2)
    draw.line([(left, mid), (left + width, mid)], fill=WARM + (70,), width=1)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--wav", required=True)
    ap.add_argument("--meta", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    meta = json.loads(Path(args.meta).read_text(encoding="utf-8"))
    wave_data = load_wave(Path(args.wav))

    img = Image.new("RGB", (W, H), BG)
    draw_glow(img)

    layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)

    d.text((80, 64), "键 盘 手", font=font(26), fill=ACCENT + (255,))
    d.text((80, 110), "每日之歌", font=font(64), fill=INK + (255,))

    day = meta.get("day", "")
    d.text((80, 196), day, font=font(34), fill=MUTED + (255,))

    stats = [
        ("字数", f"{meta.get('net_chars', 0)}"),
        ("击键", f"{meta.get('keystrokes', 0)}"),
        ("会话", f"{meta.get('sessions', 0)}"),
        ("速度", f"{meta.get('kpm', 0)}/分"),
        ("BPM", f"{meta.get('bpm', 0)}"),
    ]
    x = 80
    for label, value in stats:
        d.text((x, 268), value, font=font(38), fill=INK + (255,))
        d.text((x, 318), label, font=font(20), fill=MUTED + (255,))
        x += 190

    draw_wave(d, wave_data, 400, 130)

    d.text((80, 560), "本地生成 · 不联网 · 数据只存在这台机器上", font=font(18), fill=MUTED + (255,))
    d.text((W - 80 - 120, 560), f"{meta.get('duration', 0)}s", font=font(18), fill=MUTED + (255,))

    img = Image.alpha_composite(img.convert("RGBA"), layer).convert("RGB")
    img.save(args.out)
    print(f"🖼  {args.out}")


if __name__ == "__main__":
    main()
