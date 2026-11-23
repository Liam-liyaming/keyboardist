import Foundation

// MARK: - 数据模型

struct SongNote {
    enum Kind { case pad, pluck, vibes, bass }
    let start: Double
    let dur: Double
    let midi: Int
    let amp: Float
    let pan: Float
    let kind: Kind
}

struct SongSummary {
    let bpm: Double
    let bars: Int
    let seconds: Double
    let sessions: Int
    let motif: [Int]
    let peakSession: Int
}

/// 确定性随机（同一天永远生成同一首）
private struct SeededRandom {
    private var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 0x9E37_79B9_7F4A_7C15 : seed }

    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }

    mutating func unit() -> Double { Double(next() >> 11) / Double(1 << 53) }

    mutating func int(_ range: ClosedRange<Int>) -> Int {
        range.lowerBound + Int(unit() * Double(range.count))
    }
}

// MARK: - 作曲

enum SongComposer {
    static let sampleRate = 44100.0
    private static let chords: [[Int]] = [[57, 60, 64], [53, 57, 60], [48, 52, 55], [55, 59, 62]]

    static func compose(_ record: DayRecord) -> (notes: [SongNote], summary: SongSummary) {
        let activeMinutes = max(1, record.minuteKeys.count)
        let kpm = Double(record.keystrokes) / Double(activeMinutes)
        let bpm = min(132, max(56, 56 + kpm * 0.32))
        let beat = 60.0 / bpm
        let bar = beat * 4

        var sessions = record.sessions
        if sessions.isEmpty {
            sessions = [Session(start: Date(), end: Date(),
                                keystrokes: max(1, record.keystrokes),
                                chars: record.netChars)]
        }

        // 一天可能有几十段会话，全写进来会变成十分钟的流水账。
        // 均匀抽样到最多 8 段，保留一天的时间跨度。
        let maxSessions = 8
        if sessions.count > maxSessions {
            let step = Double(sessions.count - 1) / Double(maxSessions - 1)
            sessions = (0..<maxSessions).map { i in
                sessions[min(sessions.count - 1, Int((Double(i) * step).rounded()))]
            }
        }

        var weights = [0.2, 0.2, 0.2, 0.2, 0.2]
        for (key, count) in record.keyCodes {
            guard let code = Int64(key), let degree = KeyLayout.degree(for: code) else { continue }
            weights[degree] += Double(count)
        }

        var rng = SeededRandom(seed: fnv(record.day))
        let motif = makeMotif(weights: weights, rng: &rng)

        let busiest = sessions.max(by: { $0.keystrokes < $1.keystrokes })!
        let peakIndex = sessions.firstIndex(where: { $0.keystrokes == busiest.keystrokes }) ?? 0

        let barsPerSession = sessions.count <= 3 ? 5 : (sessions.count <= 5 ? 4 : 3)
        var notes: [SongNote] = []
        var t = 0.0

        // 前奏
        for b in 0..<3 {
            let chord = chords[b % chords.count]
            for n in chord {
                notes.append(SongNote(start: t + Double(b) * bar, dur: bar * 1.05, midi: n,
                                      amp: 0.075, pan: 0.5, kind: .pad))
            }
            notes.append(SongNote(start: t + Double(b) * bar, dur: bar * 0.9, midi: chord[0] - 12,
                                  amp: 0.17, pan: 0.5, kind: .bass))
        }
        t += 3 * bar

        // 主体
        for (si, session) in sessions.enumerated() {
            let isPeak = sessions.count > 1 && si == peakIndex
            let gain = isPeak ? 1.0 : 0.85
            let density = min(16, max(3, Double(session.keystrokes) / 14.0))
            let slots = Int(min(8, max(2, density * 0.5)))
            let amp = (isPeak ? 0.26 : 0.20) * gain

            for b in 0..<barsPerSession {
                let start = t + Double(b) * bar
                let chord = chords[(si + b) % chords.count]
                for n in chord {
                    notes.append(SongNote(start: start, dur: bar, midi: n,
                                          amp: Float(0.088 * gain), pan: 0.5, kind: .pad))
                }
                notes.append(SongNote(start: start + (rng.unit() - 0.5) * 0.006,
                                      dur: bar * 0.85, midi: chord[0] - 12,
                                      amp: Float(0.095 * gain), pan: 0.5, kind: .bass))

                if b % 4 != 3 {
                    for s in 0..<slots {
                        if rng.unit() < 0.30 { continue }
                        let degree = (motif[(b * slots + s) % motif.count] + si) % 5
                        let octave = (isPeak && rng.unit() < 0.25) ? 12 : 0
                        let midi = 69 + KeyLayout.pentatonic[degree] + octave
                        let pan = 0.5 + (rng.unit() - 0.5) * 0.5
                        let dur = beat * (rng.unit() > 0.35 ? 1.0 : 1.6)
                        let jittered = start + Double(s) * (bar / Double(slots))
                            + (rng.unit() - 0.5) * 0.012
                        let velocity = amp * (0.9 + rng.unit() * 0.2)
                        notes.append(SongNote(start: jittered,
                                              dur: dur, midi: midi,
                                              amp: Float(velocity), pan: Float(pan),
                                              kind: s % 2 == 0 ? .pluck : .vibes))
                    }
                }

                // 高频闪光：补 2–6kHz，否则整首频谱会"暗"到发闷
                let sparkle = 69 + KeyLayout.pentatonic[motif[(b + si) % motif.count]] + 36
                notes.append(SongNote(start: start + (rng.unit() - 0.5) * 0.008,
                                      dur: beat * 0.9, midi: sparkle,
                                      amp: Float(0.038 * gain), pan: 0.42,
                                      kind: .pluck))

                if isPeak && b % 2 == 1 {
                    for s in 0..<6 {
                        let degree = motif[(s * 2) % motif.count]
                        let midi = 69 + KeyLayout.pentatonic[degree] + 12
                        notes.append(SongNote(start: start + Double(s) * (beat / 2)
                                                + (rng.unit() - 0.5) * 0.010,
                                              dur: beat * 0.45, midi: midi,
                                              amp: Float(0.075 * gain * (0.9 + rng.unit() * 0.2)),
                                              pan: Float(0.5 + Double(s - 3) * 0.09),
                                              kind: .pluck))
                    }
                }
            }
            t += Double(barsPerSession) * bar
        }

        // 尾奏
        for b in 0..<3 {
            let chord = chords[0]
            let fade = 0.075 * (1 - Double(b) / 3.5)
            for n in chord {
                notes.append(SongNote(start: t + Double(b) * bar, dur: bar * 1.4, midi: n,
                                      amp: Float(fade), pan: 0.5, kind: .pad))
            }
            notes.append(SongNote(start: t + Double(b) * bar, dur: bar * 1.2, midi: chord[0] - 12,
                                  amp: Float(0.14 * (1 - Double(b) / 3.5)), pan: 0.5, kind: .bass))
        }
        let total = t + 3 * bar

        let summary = SongSummary(
            bpm: (bpm * 10).rounded() / 10,
            bars: Int(total / bar),
            seconds: (total * 10).rounded() / 10,
            sessions: sessions.count,
            motif: motif,
            peakSession: peakIndex + 1
        )
        return (notes, summary)
    }

    private static func makeMotif(weights: [Double], rng: inout SeededRandom) -> [Int] {
        let total = weights.reduce(0, +)
        var current = weightedPick(weights, total: total, rng: &rng)
        var seq: [Int] = []
        for _ in 0..<6 {
            seq.append(current)
            let step = [-2, -1, -1, 0, 0, 1, 1, 2][rng.int(0...7)]
            current = min(4, max(0, current + step))
        }
        return seq
    }

    private static func weightedPick(_ weights: [Double], total: Double, rng: inout SeededRandom) -> Int {
        var r = rng.unit() * total
        for (i, w) in weights.enumerated() {
            r -= w
            if r <= 0 { return i }
        }
        return weights.count - 1
    }

    private static func fnv(_ string: String) -> UInt64 {
        var hash: UInt64 = 0xcbf2_9ce4_8422_2325
        for byte in string.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 0x0000_0100_0000_01B3
        }
        return hash
    }
}

// MARK: - 合成与渲染

enum SongSynth {
    static let sr = 44100.0

    static func midiToHz(_ note: Int) -> Double {
        440.0 * pow(2.0, Double(note - 69) / 12.0)
    }

    static func render(notes: [SongNote], seconds: Double) -> [Float] {
        let total = Int(seconds * sr) + Int(sr)
        var left = [Float](repeating: 0, count: total)
        var right = [Float](repeating: 0, count: total)

        for note in notes {
            let freq = midiToHz(note.midi)
            let dur = min(note.dur * 1.4, 4.0)
            let samples = voice(note.kind, freq: freq, dur: dur, amp: note.amp)
            let start = Int(note.start * sr)
            guard start < total else { continue }
            let count = min(samples.count, total - start)
            let pan = min(1, max(0, note.pan))
            let l = sqrt(1 - pan)
            let r = sqrt(pan)
            for i in 0..<count {
                left[start + i] += samples[i] * l
                right[start + i] += samples[i] * r
            }
        }

        left = reverb(left)
        right = reverb(right)

        // 高架提亮：一阶高通 + 叠加，抬 2.5kHz 以上。
        // 纯正弦配器天然缺高频，不补会显得发闷。
        left = shelf(left, cutoff: 2500, gain: 1.15)
        right = shelf(right, cutoff: 2500, gain: 1.15)

        // 动态弧线：前段稍收、中段最满、尾部收束。
        // 一整段恒定音量是"练习曲"最明显的特征。
        for i in 0..<total {
            let t = Double(i) / Double(max(1, total - 1))
            var gain = 0.74 + 0.26 * smoothstep(0.02, 0.45, t)
            gain *= 1.0 - 0.32 * smoothstep(0.72, 1.0, t)
            left[i] *= Float(gain)
            right[i] *= Float(gain)
        }

        var out = [Float](repeating: 0, count: total * 2)
        var peak: Float = 0
        for i in 0..<total {
            let l = tanh(left[i] * 1.05)
            let r = tanh(right[i] * 1.05)
            out[i * 2] = l
            out[i * 2 + 1] = r
            peak = max(peak, max(abs(l), abs(r)))
        }
        if peak > 0 {
            let scale = 0.89 / peak
            for i in 0..<out.count { out[i] *= scale }
        }

        // 响度标准化：目标 -18 dBFS RMS（对应约 -15 LUFS）。
        // 不做这一步，同一天的不同数据会一响一轻，分享出去很业余。
        var sumSquares: Float = 0
        for v in out { sumSquares += v * v }
        let rms = sqrt(sumSquares / Float(max(1, out.count)))
        let target: Float = 0.126
        if rms > 0.0001 {
            let gain = target / rms
            for i in 0..<out.count {
                out[i] = max(-0.98, min(0.98, out[i] * gain))
            }
        }
        return out
    }

    /// 一阶高架滤波：y = x + gain * highpass(x)
    private static func shelf(_ input: [Float], cutoff: Double, gain: Float) -> [Float] {
        let a = Float(exp(-2 * Double.pi * cutoff / sr))
        var output = [Float](repeating: 0, count: input.count)
        var previousIn: Float = 0
        var previousOut: Float = 0
        for i in 0..<input.count {
            let x = input[i]
            previousOut = a * (previousOut + x - previousIn)
            previousIn = x
            output[i] = x + gain * previousOut
        }
        return output
    }

    private static func smoothstep(_ edge0: Double, _ edge1: Double, _ x: Double) -> Double {
        let t = min(1, max(0, (x - edge0) / max(1e-6, edge1 - edge0)))
        return t * t * (3 - 2 * t)
    }

    private static func voice(_ kind: SongNote.Kind, freq: Double, dur: Double, amp: Float) -> [Float] {
        let n = max(1, Int(dur * sr))
        var buffer = [Float](repeating: 0, count: n)
        let dt = 1.0 / sr

        switch kind {
        case .pluck:
            // FM 马林巴：击打 + 极短衰减
            for i in 0..<n {
                let t = Double(i) * dt
                let mod = sin(2 * .pi * freq * 3.01 * t) * 2.2
                let body = sin(2 * .pi * freq * t + mod)
                let env = exp(-t * 6.5)
                buffer[i] = Float((0.55 * body + 0.45 * sin(2 * .pi * freq * t)) * env) * amp
            }
        case .vibes:
            for i in 0..<n {
                let t = Double(i) * dt
                let tone = sin(2 * .pi * freq * t) + 0.25 * sin(2 * .pi * freq * 2.01 * t)
                let trem = 1 + 0.18 * sin(2 * .pi * 4.2 * t)
                let env = exp(-t * 1.6)
                buffer[i] = Float(tone * trem * env * 0.5) * amp
            }
        case .pad:
            let attack = 0.9, release = 1.2
            for i in 0..<n {
                let t = Double(i) * dt
                let tone = sin(2 * .pi * freq * t) + 0.7 * sin(2 * .pi * freq * 1.5 * t)
                let a = min(1, t / attack)
                let r = min(1, (dur - t) / release)
                buffer[i] = Float(tone * a * r) * amp
            }
        case .bass:
            for i in 0..<n {
                let t = Double(i) * dt
                let tone = sin(2 * .pi * freq * t) + 0.2 * sin(2 * .pi * freq * 2 * t)
                let env = min(1, t / 0.08) * min(1, (dur - t) / 0.35)
                buffer[i] = Float(tone * env) * amp
            }
        }
        return buffer
    }

    /// Schroeder 混响：4 个并联梳状 + 2 个串联全通
    private static func reverb(_ input: [Float]) -> [Float] {
        let combs = [1557, 1617, 1491, 1422]
        let allpasses = [225, 556]
        var output = [Float](repeating: 0, count: input.count)

        for (index, delay) in combs.enumerated() {
            let feedback: Float = 0.82 - Float(index) * 0.02
            var buffer = [Float](repeating: 0, count: delay)
            var idx = 0
            var damp: Float = 0
            for i in 0..<input.count {
                let y = buffer[idx]
                damp = y * 0.7 + damp * 0.3
                buffer[idx] = input[i] + damp * feedback
                output[i] += y * 0.25
                idx = (idx + 1) % delay
            }
        }

        for delay in allpasses {
            var buffer = [Float](repeating: 0, count: delay)
            var idx = 0
            for i in 0..<output.count {
                let bufOut = buffer[idx]
                let y = -output[i] + bufOut
                buffer[idx] = output[i] + bufOut * 0.5
                output[i] = y
                idx = (idx + 1) % delay
            }
        }

        for i in 0..<input.count {
            output[i] = input[i] + output[i] * 0.30
        }
        return output
    }
}

// MARK: - 落盘

enum SongRenderer {
    static func render(_ record: DayRecord, to url: URL) throws -> SongSummary {
        let (notes, summary) = SongComposer.compose(record)
        let samples = SongSynth.render(notes: notes, seconds: summary.seconds)
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                                withIntermediateDirectories: true)
        try writeWAV(samples, to: url)
        return summary
    }

    static func defaultURL(for day: String) -> URL {
        let base = FileManager.default.urls(for: .musicDirectory, in: .userDomainMask).first
            ?? FileManager.default.homeDirectoryForCurrentUser
        return base.appendingPathComponent("键盘手", isDirectory: true)
            .appendingPathComponent("\(day).wav")
    }

    private static func writeWAV(_ interleaved: [Float], to url: URL) throws {
        var data = Data()
        let sampleRate = UInt32(SongSynth.sr)
        let channels: UInt16 = 2
        let bits: UInt16 = 16
        let byteRate = sampleRate * UInt32(channels) * UInt32(bits / 8)
        let blockAlign = channels * (bits / 8)
        let dataBytes = UInt32(interleaved.count * 2)

        func appendString(_ s: String) { data.append(contentsOf: Array(s.utf8)) }
        func appendU32(_ v: UInt32) { withUnsafeBytes(of: v.littleEndian) { data.append(contentsOf: $0) } }
        func appendU16(_ v: UInt16) { withUnsafeBytes(of: v.littleEndian) { data.append(contentsOf: $0) } }

        appendString("RIFF")
        appendU32(36 + dataBytes)
        appendString("WAVE")
        appendString("fmt ")
        appendU32(16)
        appendU16(1)
        appendU16(channels)
        appendU32(sampleRate)
        appendU32(byteRate)
        appendU16(blockAlign)
        appendU16(bits)
        appendString("data")
        appendU32(dataBytes)

        var pcm = [Int16](repeating: 0, count: interleaved.count)
        for i in 0..<interleaved.count {
            pcm[i] = Int16(max(-1, min(1, interleaved[i])) * 32767)
        }
        pcm.withUnsafeBufferPointer { buffer in
            data.append(UnsafeBufferPointer(start: UnsafeRawPointer(buffer.baseAddress!)
                .assumingMemoryBound(to: UInt8.self), count: buffer.count * 2))
        }
        try data.write(to: url, options: .atomic)
    }
}
