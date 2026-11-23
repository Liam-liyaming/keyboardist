#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
键盘手 · 说唱版渲染器（Rap Mode）

为什么先做说唱：
  嘻哈的骨架是「鼓机 + 说话」，这两样恰好是合成器和本机 TTS 最擅长的；
  而摇滚要真吉他的失真质感，纯代码合成容易变成玩具音。

链路上的两个事实：
  * 鼓、贝斯、和声：全部 numpy 合成，离线、零采样库
  * 人声：调用 macOS 自带 `say`（本地 TTS，不联网），再降调 + 切片对齐到节拍网格

歌词来源：本脚本读取一个纯文本歌词文件，按标点切句。
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import tempfile
import wave
from pathlib import Path

import numpy as np

SR = 44100
BPM = 88.0
BEAT = 60.0 / BPM
BAR = BEAT * 4

PENTA = [0, 3, 5, 7, 10]
CHORDS = [[57, 60, 64], [53, 57, 60], [48, 52, 55], [55, 59, 62]]


# ---------------------------------------------------------------- TTS

def say_wav(text: str, voice: str, rate: int) -> np.ndarray:
    """调用本地 TTS，返回 mono float32。"""
    fd, path = tempfile.mkstemp(suffix=".wav")
    os.close(fd)
    try:
        subprocess.run(
            ["say", "-v", voice, "-r", str(rate), "-o", path,
             "--data-format=LEI16@44100", text],
            check=True, capture_output=True,
        )
        with wave.open(path, "rb") as w:
            data = np.frombuffer(w.readframes(w.getnframes()), dtype="<i2")
        return data.astype(np.float32) / 32768
    finally:
        try:
            os.unlink(path)
        except OSError:
            pass


def pitch_down(x: np.ndarray, factor: float = 0.9) -> np.ndarray:
    """重采样降调：低 factor = 更低更慢，接近说唱的低音区。"""
    n = max(1, int(len(x) / factor))
    idx = np.linspace(0, len(x) - 1, n)
    return np.interp(idx, np.arange(len(x)), x).astype(np.float32)


def trim_silence(x: np.ndarray, threshold: float = 0.012) -> np.ndarray:
    if len(x) == 0:
        return x
    env = np.abs(x)
    idx = np.where(env > threshold)[0]
    if len(idx) == 0:
        return x
    return x[max(0, idx[0] - 200): min(len(x), idx[-1] + 400)]


# ---------------------------------------------------------------- 鼓机

def kick(dur: float = 0.30) -> np.ndarray:
    n = int(dur * SR)
    t = np.arange(n) / SR
    freq = 118 * np.exp(-t * 26) + 44
    phase = 2 * np.pi * np.cumsum(freq) / SR
    body = np.sin(phase) * np.exp(-t * 8.5)
    click = np.random.default_rng(11).standard_normal(n) * np.exp(-t * 150) * 0.35
    return (body + click) * 0.95


def snare(dur: float = 0.24) -> np.ndarray:
    n = int(dur * SR)
    t = np.arange(n) / SR
    noise = np.random.default_rng(12).standard_normal(n)
    hp = np.diff(noise, prepend=0.0)
    tone = np.sin(2 * np.pi * 186 * t) * np.exp(-t * 26) * 0.45
    return hp * np.exp(-t * 19) * 0.55 + tone


def hat(dur: float = 0.055, decay: float = 65) -> np.ndarray:
    n = int(dur * SR)
    t = np.arange(n) / SR
    noise = np.random.default_rng(13).standard_normal(n)
    hp = np.diff(noise, prepend=0.0)
    return hp * np.exp(-t * decay) * 0.22


def crash(dur: float = 1.8) -> np.ndarray:
    n = int(dur * SR)
    t = np.arange(n) / SR
    noise = np.random.default_rng(14).standard_normal(n)
    hp = np.diff(noise, prepend=0.0)
    return hp * np.exp(-t * 2.6) * 0.18


# ---------------------------------------------------------------- 和声

def bass_note(freq: float, dur: float, amp: float) -> np.ndarray:
    n = int(dur * SR)
    t = np.arange(n) / SR
    tone = np.sin(2 * np.pi * freq * t) + 0.28 * np.sin(2 * np.pi * freq * 2 * t)
    env = np.exp(-t * 3.2) * np.clip(t / 0.012, 0, 1)
    return tone * env * amp


def stab(freqs: list[float], dur: float, amp: float) -> np.ndarray:
    n = int(dur * SR)
    t = np.arange(n) / SR
    out = np.zeros(n)
    for i, f in enumerate(freqs):
        out += np.sin(2 * np.pi * f * (1 + i * 0.0012) * t)
    out /= len(freqs)
    env = np.exp(-t * 9) * np.clip(t / 0.006, 0, 1)
    return out * env * amp


def midi_to_hz(n: int) -> float:
    return 440.0 * (2 ** ((n - 69) / 12))


# ---------------------------------------------------------------- 混响

def reverb(x: np.ndarray, mix: float = 0.18) -> np.ndarray:
    n_ir = int(1.6 * SR)
    rng = np.random.default_rng(21)
    t = np.arange(n_ir) / SR
    ir = rng.standard_normal(n_ir) * np.exp(-t * 3.4)
    ir /= np.sqrt(np.sum(ir ** 2))
    size = 1 << (len(x) + n_ir - 1).bit_length()
    wet = np.fft.irfft(np.fft.rfft(x, size) * np.fft.rfft(ir, size), size)[: len(x)]
    return x + wet * mix


# ---------------------------------------------------------------- 打包器

class Bus:
    def __init__(self, seconds: float):
        n = int(seconds * SR) + SR
        self.left = np.zeros(n)
        self.right = np.zeros(n)
        self.length = n

    def add(self, sig: np.ndarray, at: float, pan: float = 0.5, gain: float = 1.0):
        i = int(at * SR)
        if i >= self.length or len(sig) == 0:
            return
        j = min(self.length, i + len(sig))
        seg = sig[: j - i] * gain
        self.left[i:j] += seg * np.sqrt(1 - pan)
        self.right[i:j] += seg * np.sqrt(pan)

    def finish(self, peak: float = 0.9) -> np.ndarray:
        out = np.stack([self.left, self.right], axis=1)
        out = np.tanh(out * 1.05)
        m = float(np.max(np.abs(out))) or 1.0
        return out / m * peak


# ---------------------------------------------------------------- 编曲

def split_lyrics(text: str) -> list[str]:
    parts = re.split(r"[，,。.！!？?；;\n]+", text)
    return [p.strip() for p in parts if p.strip()]


def build(lyrics: list[str], voice: str, rate: int) -> tuple[np.ndarray, dict]:
    total_bars = 4 + 2 * max(4, len(lyrics)) + 4 + 2
    bus = Bus(total_bars * BAR + 2.0)

    def bar_at(b: int) -> float:
        return b * BAR

    # ---- 鼓 ----
    k, s, h, h8, cr = kick(), snare(), hat(), hat(0.055, 40), crash()
    for b in range(total_bars):
        start = bar_at(b)
        if b < 2:
            for i in range(4):
                bus.add(h, start + i * BEAT, 0.62, 0.45)
            if b == 1:
                bus.add(k, start, 0.5, 0.9)
            continue
        bus.add(k, start, 0.5, 1.0)
        bus.add(k, start + 2.5 * BEAT, 0.5, 0.85)
        if b % 2 == 1:
            bus.add(k, start + 3.75 * BEAT, 0.5, 0.7)
        bus.add(s, start + 1 * BEAT, 0.5, 0.9)
        bus.add(s, start + 3 * BEAT, 0.5, 0.9)
        for i in range(8):
            bus.add(h, start + i * BEAT / 2, 0.62, 0.55)
        if b % 4 == 0:
            bus.add(cr, start, 0.4, 0.6)

    # ---- 贝斯 + 和声 ----
    for b in range(total_bars):
        chord = CHORDS[b % len(CHORDS)]
        root = midi_to_hz(chord[0] - 12)
        for i in range(8):
            if i in (2, 5, 7):
                continue
            bus.add(bass_note(root, BEAT * 0.55, 0.34), bar_at(b) + i * BEAT / 2, 0.5)
        if 4 <= b < total_bars - 2:
            bus.add(stab([midi_to_hz(n) for n in chord], BEAT * 0.8, 0.10),
                    bar_at(b) + 1.5 * BEAT, 0.35)

    # ---- 人声 ----
    phrases = [trim_silence(pitch_down(say_wav(t, voice, rate), 0.9)) for t in lyrics[:4]]

    # 副歌：把最后一句切成 8 片，按八分音符重排（经典 vocal chop）
    hook_src = trim_silence(pitch_down(say_wav(lyrics[-1] if lyrics else "说唱", voice, rate), 0.88))
    if len(hook_src) > 4000:
        chunks = np.array_split(hook_src, 8)
        hook_bar = 4 + 2 * len(phrases)
        for b in range(4):
            for i in range(8):
                if (i + b) % 4 == 3:
                    continue
                piece = chunks[(i * 3 + b) % 8]
                bus.add(piece, bar_at(hook_bar + b) + i * BEAT / 2, 0.5, 1.05)

    for i, p in enumerate(phrases):
        at = bar_at(4 + 2 * i)
        bus.add(p, at, 0.5, 0.95)

    audio = bus.finish(0.9)
    audio = trim_and_fade(audio)
    audio[:, 0] = reverb(audio[:, 0], 0.12)
    audio[:, 1] = reverb(audio[:, 1], 0.12)
    m = float(np.max(np.abs(audio))) or 1.0
    audio = audio / m * 0.9

    meta = {
        "style": "rap",
        "bpm": BPM,
        "bars": total_bars,
        "duration": round(len(audio) / SR, 1),
        "phrases": len(phrases),
        "voice": voice,
        "lyrics": lyrics,
    }
    return audio, meta


def trim_and_fade(audio: np.ndarray, fade_seconds: float = 1.2) -> np.ndarray:
    env = np.max(np.abs(audio), axis=1)
    idx = np.where(env > 0.008)[0]
    if len(idx):
        audio = audio[: idx[-1] + int(0.25 * SR)]
    n = min(int(fade_seconds * SR), len(audio))
    if n > 0:
        audio[-n:] *= np.linspace(1, 0, n)[:, None]
    m = float(np.max(np.abs(audio))) or 1.0
    return audio / m * 0.9


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
    ap.add_argument("--lyrics", required=True, help="歌词文本文件")
    ap.add_argument("--out", required=True)
    ap.add_argument("--voice", default="Tingting")
    ap.add_argument("--rate", type=int, default=185)
    args = ap.parse_args()

    text = Path(args.lyrics).read_text(encoding="utf-8")
    lyrics = split_lyrics(text)
    audio, meta = build(lyrics, args.voice, args.rate)

    out = Path(args.out)
    write_wav(out, audio)
    out.with_suffix(".json").write_text(
        json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    print(f"🎤 {out}")
    print(f"   BPM {meta['bpm']} · {meta['bars']} 小节 · {meta['duration']}s · 人声 {meta['voice']}")
    for i, line in enumerate(lyrics, 1):
        print(f"   {i}. {line}")


if __name__ == "__main__":
    main()
