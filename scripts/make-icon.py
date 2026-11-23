#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成 App 图标：深色底 + 一枚键帽 + 底部青→琥珀的辉光。"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

S = 1024
ICONSET = Path("/tmp/Keyboardist.iconset")
PREVIEW = Path("/tmp/keyboardist-icon-preview.png")


def rounded_mask(size: int, radius: int) -> Image.Image:
    m = Image.new("L", (size, size), 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, size - 1, size - 1], radius=radius, fill=255)
    return m


def vgrad(size: int, top: tuple, bottom: tuple) -> Image.Image:
    strip = Image.new("RGB", (1, size))
    px = strip.load()
    for y in range(size):
        t = y / max(1, size - 1)
        px[0, y] = tuple(int(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
    return strip.resize((size, size), Image.NEAREST)


def hgrad_strip(width: int, height: int, left: tuple, right: tuple) -> Image.Image:
    strip = Image.new("RGB", (width, 1))
    px = strip.load()
    for x in range(width):
        t = x / max(1, width - 1)
        px[x, 0] = tuple(int(left[i] + (right[i] - left[i]) * t) for i in range(3))
    return strip.resize((width, height), Image.NEAREST)


def rounded_box(w: int, h: int, radius: int, top: tuple, bottom: tuple) -> Image.Image:
    """带圆角和垂直渐变的方块（在正确尺寸上做遮罩，不能先裁后圆角）。"""
    grad = Image.new("RGB", (w, h))
    px = grad.load()
    for y in range(h):
        t = y / max(1, h - 1)
        color = tuple(int(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
        for x in range(w):
            px[x, y] = color
    img = grad.convert("RGBA")
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, w - 1, h - 1], radius=radius, fill=255)
    img.putalpha(mask)
    return img


def main() -> None:
    canvas = vgrad(S, (7, 10, 15), (19, 29, 41)).convert("RGBA")

    # ── 辉光：椭圆内的横向渐变，模糊成光晕而不是色块 ──
    grad = hgrad_strip(S, S, (94, 234, 232), (255, 176, 96)).convert("RGBA")

    def soft_glow(x0, y0, x1, y1, alpha, blur):
        layer = grad.copy()
        mask = Image.new("L", (S, S), 0)
        ImageDraw.Draw(mask).ellipse([x0, y0, x1, y1], fill=alpha)
        layer.putalpha(mask)
        return layer.filter(ImageFilter.GaussianBlur(blur))

    canvas = Image.alpha_composite(canvas, soft_glow(S * 0.10, S * 0.60, S * 0.90, S * 0.82, 205, 58))
    canvas = Image.alpha_composite(canvas, soft_glow(S * 0.24, S * 0.66, S * 0.76, S * 0.78, 150, 22))

    # ── 键帽 ──
    cx0, cy0, cw, ch = 292, 236, 440, 440
    shadow = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        [cx0 + 4, cy0 + 26, cx0 + cw + 4, cy0 + ch + 26], radius=112, fill=(0, 0, 0, 170)
    )
    canvas = Image.alpha_composite(canvas, shadow.filter(ImageFilter.GaussianBlur(28)))

    cap = rounded_box(cw, ch, 112, (253, 255, 255), (152, 184, 214))
    canvas.paste(cap, (cx0, cy0), cap)

    # 顶部高光 / 底部暗边
    detail = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(detail)
    d.rounded_rectangle([cx0 + 22, cy0 + 18, cx0 + cw - 22, cy0 + ch * 0.52],
                        radius=96, fill=(255, 255, 255, 60))
    d.rounded_rectangle([cx0 + 18, cy0 + ch - 46, cx0 + cw - 18, cy0 + ch - 16],
                        radius=16, fill=(20, 36, 54, 85))
    canvas = Image.alpha_composite(canvas, detail.filter(ImageFilter.GaussianBlur(16)))

    canvas.putalpha(rounded_mask(S, 228))

    ICONSET.mkdir(parents=True, exist_ok=True)
    for size in (16, 32, 64, 128, 256, 512):
        canvas.resize((size, size), Image.LANCZOS).save(ICONSET / f"icon_{size}x{size}.png")
        canvas.resize((size * 2, size * 2), Image.LANCZOS).save(ICONSET / f"icon_{size}x{size}@2x.png")
    canvas.save(ICONSET / "icon_512x512@2x.png")
    canvas.resize((512, 512), Image.LANCZOS).save(PREVIEW)
    print(f"iconset: {ICONSET}")


if __name__ == "__main__":
    main()
