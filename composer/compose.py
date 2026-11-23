#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
键盘手 · 每日之歌渲染器

读一天的输入画像（JSON），生成一首极简电子的曲子（WAV）。

数据 → 音乐 映射
  BPM          ← 每分钟击键数（活跃分钟）
  调式          ← A 小调五声音阶（永远是谐和的）
  音高          ← 键盘物理行：数字排 +2 八度、QWERTY +1、ASDF 0、ZXCV -1
  音级          ← 键位横向列 → 五声音阶的第 n 级
  动机          ← 最常敲的键位分布，加权抽样出的 6 音主题
  段落          ← 会话（sessions）：每段一个乐句，最忙的段落进入高潮
  力度          ← 该会话的击键量
  时长          ← 会话数决定

用法:
  python3 compose.py                 # 今天
  python3 compose.py --day 2026-11-23
  python3 compose.py --wav out.wav
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import wave
from dataclasses import dataclass, field
from datetime import date
from pathlib import Path

import numpy as np

SR = 44100

# ---------------------------------------------------------------- 键盘布局

GRID = {
    # 数字排
    18: (0, 0), 19: (0, 1), 20: (0, 2), 21: (0, 3), 23: (0, 4),
    22: (0, 5), 26: (0, 6), 28: (0, 7), 25: (0, 8), 29: (0, 9),
    27: (0, 10), 24: (0, 11), 51: (0, 12),
    # QWERTY
    12: (1, 0), 13: (1, 1), 14: (1, 2), 15: (1, 3), 17: (1, 4),
    16: (1, 5), 32: (1, 6), 34: (1, 7), 31: (1, 8), 35: (1, 9),
    33: (1, 10), 30: (1, 11), 42: (1, 12),
    # ASDF
    0: (2, 0), 1: (2, 1), 2: (2, 2), 3: (2, 3), 5: (2, 4),
    4: (2, 5), 38: (2, 6), 40: (2, 7), 37: (2, 8), 41: (2, 9), 39: (2, 10),
    # ZXCV
    6: (3, 0), 7: (3, 1), 8: (3, 2), 9: (3, 3), 11: (3, 4),
    45: (3, 5), 46: (3, 6), 43: (3, 7), 47: (3, 8), 44: (3, 9),
    49: (3, 5), 36: (2, 11), 48: (1, 0),
}

ROW_BASE = {0: 81, 1: 69, 2: 57, 3: 45}      # 数字排最高，ZXCV 最低
PENTATONIC = [0, 3, 5, 7, 10]                 # A 小调五声
CHORDS = [[57, 60, 64], [53, 57, 60], [48, 52, 55], [55, 59, 62]]  # Am F C G


def key_to_note(keycode: int) -> int:
    cell = GRID.get(keycode)
    if cell is None:
        return 69
    row, col = cell
    degree = int(round(min(col, 12) / 12 * 4))
    return ROW_BASE[row] + PENTATONIC[degree]


# ---------------------------------------------------------------- 数据

@dataclass
class Day:
    day: str
    keystrokes: int = 0
    chars: int = 0
    deletions: int = 0
    sessions: list = field(default_factory=list)
    minute_keys: dict = field(default_factory=dict)
    key_codes: dict = field(default_factory=dict)

    @property
    def net_chars(self) -> int:
        return max(0, self.chars - self.deletions)


def load_day(path: Path) -> Day:
    raw = json.loads(path.read_text(encoding="utf-8"))
    return Day(
        day=raw.get("day", path.stem),
        keystrokes=raw.get("keystrokes", 0),
        chars=raw.get("chars", 0),
        deletions=raw.get("deletions", 0),
        sessions=raw.get("sessions", []),
        minute_keys=raw.get("minuteKeys", {}),
        key_codes=raw.get("keyCodes", {}),
    )


# ---------------------------------------------------------------- 合成器

def env_exp(n: int, decay: float) -> np.ndarray:
    t = np.arange(n) / SR
    return np.exp(-t * decay)


def env_pad(n: int, attack: float = 0.9, release: float = 1.2) -> np.ndarray:
    t = np.arange(n) / SR
    a = np.clip(t / attack, 0, 1)
    r = np.clip((t[-1] - t) / release, 0, 1) if n > 1 else np.ones(1)
    return a * r


def pluck(freq: float, dur: float, amp: float) -> np.ndarray:
    """FM 马林巴：木槌击打，短衰减。"""
    n = max(1, int(dur * SR))
    t = np.arange(n) / SR
    mod = np.sin(2 * np.pi * freq * 3.01 * t) * 2.2
    body = np.sin(2 * np.pi * freq * t + mod)
    tone = 0.55 * body + 0.45 * np.sin(2 * np.pi * freq * t)
    return tone * env_exp(n, 6.5) * amp


def vibes(freq: float, dur: float, amp: float) -> np.ndarray:
    """颤音琴：金属延音 + 电机颤音。"""
    n = max(1, int(dur * SR))
    t = np.arange(n) / SR
    tone = np.sin(2 * np.pi * freq * t) + 0.25 * np.sin(2 * np.pi * freq * 2.01 * t)
    trem = 1.0 + 0.18 * np.sin(2 * np.pi * 4.2 * t)
    return tone * trem * env_exp(n, 1.6) * amp * 0.5


def pad(freqs: list[float], dur: float, amp: float) -> np.ndarray:
    """长音和声：轻微失谐的正弦堆叠。"""
    n = max(1, int(dur * SR))
    t = np.arange(n) / SR
    out = np.zeros(n)
    for i, f in enumerate(freqs):
        detune = 1.0 + (i - len(freqs) / 2) * 0.0016
        out += np.sin(2 * np.pi * f * detune * t + i * 1.7)
    out /= max(1, len(freqs))
    return out * env_pad(n) * amp


def sub_bass(freq: float, dur: float, amp: float) -> np.ndarray:
    n = max(1, int(dur * SR))
    t = np.arange(n) / SR
    tone = np.sin(2 * np.pi * freq * t) + 0.2 * np.sin(2 * np.pi * freq * 2 * t)
    return tone * env_pad(n, 0.08, 0.35) * amp


def midi_to_hz(note: int) -> float:
    return 440.0 * (2 ** ((note - 69) / 12))


# ---------------------------------------------------------------- 混响

def make_ir(seconds: float = 2.4, decay: float = 2.6) -> np.ndarray:
    n = int(SR * seconds)
    rng = np.random.default_rng(7)
    noise = rng.standard_normal(n)
    t = np.arange(n) / SR
    ir = noise * np.exp(-t * decay)
    pre = int(0.015 * SR)
    ir[:pre] *= np.linspace(0, 1, pre)
    return ir / np.sqrt(np.sum(ir ** 2))


def convolve(x: np.ndarray, h: np.ndarray) -> np.ndarray:
    n = len(x) + len(h) - 1
    size = 1 << (n - 1).bit_length()
    y = np.fft.irfft(np.fft.rfft(x, size) * np.fft.rfft(h, size), size)
    return y[: len(x)]


# ---------------------------------------------------------------- 作曲

@dataclass
class Note:
    start: float
    dur: float
    midi: int
    amp: float
    pan: float
    kind: str


def build_day_features(day: Day) -> dict:
    active_minutes = max(1, len(day.minute_keys))
    kpm = day.keystrokes / active_minutes
    bpm = float(np.clip(56 + kpm * 0.32, 56, 132))

    sessions = day.sessions
    if not sessions:
        sessions = [{
            "start": "", "end": "",
            "keystrokes": day.keystrokes or 1,
            "chars": day.net_chars,
        }]

    weights = {0: 0.2, 1: 0.2, 2: 0.2, 3: 0.2, 4: 0.2}
    for code, count in day.key_codes.items():
        note = key_to_note(int(code))
        idx = (note - 45) % 12
        degree = min(range(5), key=lambda i: abs(PENTATONIC[i] - idx))
        weights[degree] += count

    return {
        "bpm": bpm,
        "kpm": kpm,
        "sessions": sessions,
        "weights": weights,
        "net_chars": day.net_chars,
        "keystrokes": day.keystrokes,
    }


def make_motif(weights: dict, rng: np.random.Generator, length: int = 6) -> list[int]:
    p = np.array([weights[i] for i in range(5)], dtype=float)
    p /= p.sum()
    seq: list[int] = []
    cur = int(rng.choice(5, p=p))
    for _ in range(length):
        seq.append(cur)
        step = int(rng.choice([-2, -1, -1, 0, 0, 1, 1, 2]))
        cur = int(np.clip(cur + step, 0, 4))
    return seq


def compose(day: Day) -> tuple[list[Note], dict]:
    feats = build_day_features(day)
    bpm = feats["bpm"]
    beat = 60.0 / bpm
    bar = beat * 4

    seed = int(hashlib.sha256(day.day.encode()).hexdigest()[:8], 16)
    rng = np.random.default_rng(seed)
    motif = make_motif(feats["weights"], rng)

    sessions = feats["sessions"]
    # 一天可能有几十段会话，均匀抽样到最多 8 段
    if len(sessions) > 8:
        step = (len(sessions) - 1) / 7
        sessions = [sessions[min(len(sessions) - 1, round(i * step))] for i in range(8)]

    busiest = max(sessions, key=lambda x: x.get("keystrokes", 0))
    n_sessions = len(sessions)
    bars_per_session = 5 if n_sessions <= 3 else (4 if n_sessions <= 5 else 3)

    notes: list[Note] = []
    t = 0.0

    # ---- 前奏：只有铺底，留白 ----
    for b in range(3):
        chord = CHORDS[b % len(CHORDS)]
        for n in chord:
            notes.append(Note(t + b * bar, bar * 1.05, n, 0.075, 0.5, "pad"))
        notes.append(Note(t + b * bar, bar * 0.9, chord[0] - 12, 0.17, 0.5, "bass"))
    t += 3 * bar

    # ---- 主体：每个会话一个乐句 ----
    for si, session in enumerate(sessions):
        is_peak = (session is busiest) and n_sessions > 1
        gain = 1.0 if is_peak else 0.85
        density = float(np.clip(session.get("keystrokes", 40) / 14.0, 3, 16))
        slots = int(np.clip(density * 0.5, 2, 8))
        amp = 0.26 if is_peak else 0.20

        for b in range(bars_per_session):
            start = t + b * bar
            chord = CHORDS[(si + b) % len(CHORDS)]
            for n in chord:
                notes.append(Note(start, bar, n, 0.070 * gain, 0.5, "pad"))
            notes.append(Note(start, bar * 0.85, chord[0] - 12, 0.155 * gain, 0.5, "bass"))

            # 每 4 小节留一小节呼吸，避免声墙
            if b % 4 != 3:
                for s in range(slots):
                    if rng.random() < 0.30:
                        continue
                    deg = (motif[(b * slots + s) % len(motif)] + si) % 5
                    octave = 12 if (is_peak and rng.random() < 0.25) else 0
                    midi = 69 + PENTATONIC[deg] + octave
                    pan = 0.5 + (rng.random() - 0.5) * 0.5
                    dur = beat * (1.0 if rng.random() > 0.35 else 1.6)
                    kind = "pluck" if s % 2 == 0 else "vibes"
                    notes.append(Note(start + s * (bar / slots), dur, midi,
                                      amp * gain, pan, kind))

            # 高潮段：八分音符琶音，位置交替左右
            if is_peak and b % 2 == 1:
                for s in range(6):
                    deg = motif[(s * 2) % len(motif)]
                    notes.append(Note(
                        start + s * (beat / 2),
                        beat * 0.45,
                        69 + PENTATONIC[deg] + 12,
                        0.075 * gain,
                        0.5 + (s - 3) * 0.09,
                        "pluck",
                    ))
        t += bars_per_session * bar

    # ---- 尾奏：留一个长尾 ----
    for b in range(3):
        chord = CHORDS[0]
        fade = 0.075 * (1 - b / 3.5)
        for n in chord:
            notes.append(Note(t + b * bar, bar * 1.4, n, fade, 0.5, "pad"))
        notes.append(Note(t + b * bar, bar * 1.2, chord[0] - 12, 0.14 * (1 - b / 3.5), 0.5, "bass"))
    total = t + 3 * bar

    meta = {
        "day": day.day,
        "bpm": round(bpm, 1),
        "bars": int(total / bar),
        "duration": round(total, 1),
        "sessions": n_sessions,
        "motif": motif,
        "peak_session": sessions.index(busiest) + 1,
        "kpm": round(feats["kpm"], 1),
        "net_chars": feats["net_chars"],
        "keystrokes": feats["keystrokes"],
    }
    return notes, meta


# ---------------------------------------------------------------- 渲染

def render(notes: list[Note], total: float) -> np.ndarray:
    length = int(total * SR) + SR
    left = np.zeros(length)
    right = np.zeros(length)

    for note in notes:
        freq = midi_to_hz(note.midi)
        dur = min(note.dur * 1.4, 4.0)

        if note.kind == "pluck":
            sig = pluck(freq, dur, note.amp)
        elif note.kind == "vibes":
            sig = vibes(freq, dur, note.amp)
        elif note.kind == "pad":
            sig = pad([freq, freq * 1.5], dur, note.amp)
        else:
            sig = sub_bass(freq, dur, note.amp)

        i = int(note.start * SR)
        j = min(length, i + len(sig))
        if i >= length:
            continue
        sig = sig[: j - i]

        pan = float(np.clip(note.pan, 0, 1))
        left[i:j] += sig * math.sqrt(1 - pan)
        right[i:j] += sig * math.sqrt(pan)

    ir = make_ir()
    wet_l = convolve(left, ir) * 0.30
    wet_r = convolve(right, ir) * 0.30

    out = np.stack([left + wet_l, right + wet_r], axis=1)
    out = np.tanh(out * 1.1)
    peak = float(np.max(np.abs(out))) or 1.0
    out = out / peak * 0.85
    return out


def write_wav(path: Path, audio: np.ndarray) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    pcm = np.clip(audio, -1, 1)
    pcm = (pcm * 32767).astype("<i2")
    with wave.open(str(path), "wb") as w:
        w.setnchannels(2)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(pcm.tobytes())


# ---------------------------------------------------------------- 入口

def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--day", default=date.today().isoformat())
    ap.add_argument("--data", default=None, help="数据目录")
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    data_dir = Path(args.data) if args.data else (
        Path.home() / "Library/Application Support/Keyboardist/days"
    )
    src = data_dir / f"{args.day}.json"
    if not src.exists():
        raise SystemExit(f"找不到数据：{src}")

    day = load_day(src)
    notes, meta = compose(day)
    audio = render(notes, float(meta["duration"]))
    meta["duration"] = round(len(audio) / SR, 1)

    out = Path(args.out) if args.out else (
        Path.home() / "Music" / "键盘手" / f"{day.day}.wav"
    )
    write_wav(out, audio)

    summary = out.with_suffix(".json")
    summary.write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"🎵 {out}")
    print(f"   BPM {meta['bpm']} · {meta['bars']} 小节 · {meta['duration']}s")
    print(f"   主题 {meta['motif']} · 会话 {meta['sessions']} 段 · 高潮第 {meta['peak_session']} 段")
    print(f"   数据：{meta['net_chars']} 字 / {meta['keystrokes']} 击键 / {meta['kpm']} 击键每分")


if __name__ == "__main__":
    main()
