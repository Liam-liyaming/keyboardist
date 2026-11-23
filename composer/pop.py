#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
键盘手 · 流行版渲染器（Pop Mode）

为什么流行能做得住、摇滚不行：
  流行靠「四踩鼓 + 明亮合成器和弦 + 侧链压缩的泵感」，这些都是合成器的强项；
  摇滚的灵魂在真吉他失真，代码合成骗不过耳朵。

数据 → 音乐
  BPM      ← 每分钟击键数（96–124）
  和弦     ← Am–F–C–G（就是最经典的那条流行进行）
  旋律     ← 今天的键位分布加权抽样出动机，移到高八度
  段落     ← intro / verse / chorus / outro，会话数决定长度
  泵感     ← 侧链：每次底鼓把和弦压下去再弹回来
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import wave
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).parent))
from compose import CHORDS, PENTATONIC, build_day_features, load_day, make_motif  # noqa: E402

SR = 44100


# ---------------------------------------------------------------- 基本波形

def saw(freq: float, t: np.ndarray, harmonics: int = 6) -> np.ndarray:
    out = np.zeros_like(t)
    for h in range(1, harmonics + 1):
        if freq * h > 15000:
            break
        out += np.sin(2 * np.pi * freq * h * t + (h * 0.7)) / h
    return out


def supersaw(freqs: list[float], dur: float, amp: float) -> np.ndarray:
    n = int(dur * SR)
    t = np.arange(n) / SR
    out = np.zeros(n)
    for f in freqs:
        for detune in (0.997, 1.0, 1.003):
            out += saw(f * detune, t, 5)
    out /= max(1, len(freqs) * 3)
    env = np.clip(t / 0.04, 0, 1) * np.clip((dur - t) / 0.25, 0, 1)
    return out * env * amp


def pluck(freq: float, dur: float, amp: float) -> np.ndarray:
    n = int(dur * SR)
    t = np.arange(n) / SR
    tone = (np.sin(2 * np.pi * freq * t)
            + 0.30 * np.sin(2 * np.pi * freq * 2 * t)
            + 0.20 * np.sin(2 * np.pi * freq * 3 * t)
            + 0.12 * np.sin(2 * np.pi * freq * 5 * t))
    return tone * np.exp(-t * 11) * np.clip(t / 0.004, 0, 1) * amp


def bass(freq: float, dur: float, amp: float) -> np.ndarray:
    n = int(dur * SR)
    t = np.arange(n) / SR
    tone = np.sin(2 * np.pi * freq * t) + 0.35 * np.sin(2 * np.pi * freq * 2 * t)
    return tone * np.exp(-t * 2.2) * np.clip(t / 0.006, 0, 1) * amp


def midi_to_hz(n: int) -> float:
    return 440.0 * (2 ** ((n - 69) / 12))


# ---------------------------------------------------------------- 鼓

def kick() -> np.ndarray:
    n = int(0.3 * SR)
    t = np.arange(n) / SR
    freq = 130 * np.exp(-t * 24) + 48
    phase = 2 * np.pi * np.cumsum(freq) / SR
    body = np.sin(phase) * np.exp(-t * 7.5)
    click = np.random.default_rng(31).standard_normal(n) * np.exp(-t * 190) * 0.4
    return (body + click) * 0.95


def clap() -> np.ndarray:
    n = int(0.26 * SR)
    t = np.arange(n) / SR
    noise = np.random.default_rng(32).standard_normal(n)
    hp = np.diff(noise, prepend=0.0)
    env = np.exp(-t * 26) * (1 + 0.6 * np.exp(-t * 90))
    return hp * env * 0.42


def hat(decay: float = 70) -> np.ndarray:
    n = int(0.07 * SR)
    t = np.arange(n) / SR
    noise = np.random.default_rng(33).standard_normal(n)
    hp = np.diff(noise, prepend=0.0)
    hp = np.convolve(hp, np.ones(4) / 4, mode="same")
    return hp * np.exp(-t * decay) * 0.30


def riser(dur: float) -> np.ndarray:
    n = int(dur * SR)
    t = np.arange(n) / SR
    noise = np.random.default_rng(34).standard_normal(n)
    hp = np.diff(noise, prepend=0.0)
    env = (t / dur) ** 2
    return hp * env * 0.10


# ---------------------------------------------------------------- 编曲

class Bus:
    def __init__(self, seconds: float):
        self.n = int(seconds * SR) + SR
        self.left = np.zeros(self.n)
        self.right = np.zeros(self.n)

    def add(self, sig: np.ndarray, at: float, pan: float = 0.5, gain: float = 1.0):
        i = int(at * SR)
        if i >= self.n or len(sig) == 0:
            return
        j = min(self.n, i + len(sig))
        seg = sig[: j - i] * gain
        self.left[i:j] += seg * np.sqrt(1 - pan)
        self.right[i:j] += seg * np.sqrt(pan)


def build(day, bpm: float, motif: list[int]) -> tuple[np.ndarray, dict]:
    beat = 60.0 / bpm
    bar = beat * 4

    intro_bars, verse_bars, chorus_bars, outro_bars = 4, 8, 8, 4
    total_bars = intro_bars + verse_bars + chorus_bars + outro_bars
    bus = Bus(total_bars * bar + 1.5)

    def at(b: float) -> float:
        return b * bar

    # 段落边界
    verse_start = intro_bars
    chorus_start = intro_bars + verse_bars
    outro_start = chorus_start + chorus_bars

    k, cl, h = kick(), clap(), hat()

    # ---- 鼓 ----
    for b in range(total_bars):
        if b < verse_start or b >= outro_start:
            if b >= outro_start and b < outro_start + 1:
                pass
            continue
        start = at(b)
        # 四踩
        for i in range(4):
            bus.add(k, start + i * beat, 0.5, 0.68)
        # 拍手在 2、4
        bus.add(cl, start + beat, 0.5, 0.9)
        bus.add(cl, start + 3 * beat, 0.5, 0.9)
        # 八分高帽，反拍开一点
        for i in range(8):
            bus.add(h, start + i * beat / 2, 0.62, 0.55 if i % 2 == 0 else 0.8)
        # 副歌加反拍底鼓 + 16 分高帽
        if b >= chorus_start:
            bus.add(k, start + 2.5 * beat, 0.5, 0.6)
            for i in range(16):
                bus.add(h, start + i * beat / 4, 0.7, 0.14)

    # 副歌前的 riser
    bus.add(riser(bar * 0.9), at(chorus_start) - bar * 0.9, 0.5, 1.0)

    # ---- 和声与低音 ----
    pad_bus = Bus(total_bars * bar + 1.5)
    bass_bus = Bus(total_bars * bar + 1.5)

    for b in range(total_bars):
        chord = CHORDS[b % len(CHORDS)]
        start = at(b)

        # 铺底和弦（越靠后越亮）
        gain = 0.22 if b < verse_start else (0.20 if b < chorus_start else 0.26)
        if b >= outro_start:
            gain = 0.16 * (1 - (b - outro_start) / (outro_bars + 1))
        freqs = [midi_to_hz(n + 12) for n in chord]
        pad_bus.add(supersaw(freqs, bar * 1.02, gain), start, 0.5)

        # 贝斯：八分音符根音
        if b >= verse_start:
            root = midi_to_hz(chord[0] - 12)
            for i in range(8):
                if i == 3:
                    continue
                bass_bus.add(bass(root, beat * 0.45, 0.21), start + i * beat / 2, 0.5)

    # ---- 侧链：每次底鼓把和声压下去 ----
    sc = np.ones(bus.n)
    for b in range(verse_start, outro_start):
        for i in range(4):
            t0 = int((at(b) + i * beat) * SR)
            span = int(0.24 * SR)
            if t0 + span >= bus.n:
                continue
            x = np.arange(span) / SR
            curve = 1 - 0.72 * np.exp(-x / 0.075)
            sc[t0:t0 + span] = np.minimum(sc[t0:t0 + span], curve)
    pad_bus.left *= sc
    pad_bus.right *= sc
    bass_bus.left *= sc
    bass_bus.right *= sc

    # ---- 琶音 ----
    for b in range(total_bars):
        chord = CHORDS[b % len(CHORDS)]
        start = at(b)
        if b < verse_start:
            steps = 8
        elif b < chorus_start:
            steps = 8
        elif b < outro_start:
            steps = 16
        else:
            steps = 4
        for s in range(steps):
            note = chord[s % len(chord)] + 24
            pan = 0.35 + 0.3 * ((s % 2) == 0)
            bus.add(pluck(midi_to_hz(note), beat * 0.28, 0.12), start + s * (bar / steps), pan)

    # ---- 旋律（副歌才出现）----
    for b in range(chorus_start, outro_start):
        start = at(b)
        for s in range(8):
            deg = motif[(b * 8 + s) % len(motif)]
            note = 69 + PENTATONIC[deg] + 12
            if s % 4 == 3 and b % 2 == 1:
                continue
            pan = 0.5 + (0.18 if s % 2 == 0 else -0.18)
            bus.add(pluck(midi_to_hz(note), beat * 0.5, 0.165), start + s * beat / 2, pan)

    left = bus.left + pad_bus.left + bass_bus.left
    right = bus.right + pad_bus.right + bass_bus.right

    out = np.stack([left, right], axis=1)
    out = shelf_eq(out)
    out = np.tanh(out * 1.05)
    out = trim_and_fade(out, 2.0)
    m = float(np.max(np.abs(out))) or 1.0
    out = out / m * 0.9

    meta = {
        "style": "pop",
        "bpm": round(bpm, 1),
        "bars": total_bars,
        "duration": round(len(out) / SR, 1),
        "sections": {"intro": intro_bars, "verse": verse_bars, "chorus": chorus_bars, "outro": outro_bars},
        "motif": motif,
    }
    return out, meta


def shelf_eq(x: np.ndarray, low_gain: float = 0.85, high_gain: float = 1.45,
             fc: float = 1800.0) -> np.ndarray:
    """频域搁架 EQ：低频略压、高频平滑抬起，避免一阶差分那种「全频嘶」。"""
    n = len(x)
    spec = np.fft.rfft(x, axis=0)
    freqs = np.fft.rfftfreq(n, 1 / SR)
    t = np.clip((freqs - fc * 0.4) / (fc * 1.2), 0, 1)
    gain = low_gain + (high_gain - low_gain) * t
    return np.fft.irfft(spec * gain[:, None], n, axis=0)


def trim_and_fade(audio: np.ndarray, fade_seconds: float) -> np.ndarray:
    env = np.max(np.abs(audio), axis=1)
    idx = np.where(env > 0.008)[0]
    if len(idx):
        audio = audio[: idx[-1] + int(0.3 * SR)]
    n = min(int(fade_seconds * SR), len(audio))
    if n > 0:
        audio[-n:] *= np.linspace(1, 0, n)[:, None]
    return audio


def write_wav(path: Path, audio: np.ndarray) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    pcm = np.clip(audio, -1, 1)
    pcm = (pcm * 32767).astype("<i2")
    with wave.open(str(path), "wb") as w:
        w.setnchannels(2)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(pcm.tobytes())


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--day", required=True)
    ap.add_argument("--data", default=str(Path.home() / "Library/Application Support/Keyboardist/days"))
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    src = Path(args.data) / f"{args.day}.json"
    day = load_day(src)
    feats = build_day_features(day)

    kpm = feats["kpm"]
    bpm = float(np.clip(96 + kpm * 0.12, 96, 124))

    rng = np.random.default_rng(int(hashlib.sha256(args.day.encode()).hexdigest()[:8], 16))
    motif = make_motif(feats["weights"], rng)

    audio, meta = build(day, bpm, motif)
    out = Path(args.out)
    write_wav(out, audio)
    out.with_suffix(".json").write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"🎧 {out}")
    print(f"   BPM {meta['bpm']} · {meta['bars']} 小节 · {meta['duration']}s")
    print(f"   结构 {meta['sections']} · 主题 {meta['motif']}")


if __name__ == "__main__":
    main()
