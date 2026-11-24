import AppKit

/// 从一张截图里提取「线条掩膜」——只留长直线（分隔线、卡片边框），滤掉文字。
///
/// 做法（在缩小 2 倍的灰度图上跑，几十毫秒）：
///   水平线：逐行看纵向梯度 |v(x,y) - v(x,y+1)|，连续超过阈值的长度 > 30px 才算
///   垂直线：逐列看横向梯度，同理
/// 文字笔画在 2 倍缩放下通常只有几像素长，过不了 30px 的门槛。
enum LineMask {
    struct Mask {
        let width: Int
        let height: Int
        let pixels: [UInt8]      // 0 或 255
    }

    static func make(from image: CGImage, scale: Int = 2) -> Mask? {
        let w = image.width / scale
        let h = image.height / scale
        guard w > 64, h > 64 else { return nil }

        var gray = [UInt8](repeating: 0, count: w * h)
        let ok = gray.withUnsafeMutableBytes { raw -> Bool in
            guard let ctx = CGContext(data: raw.baseAddress,
                                      width: w, height: h,
                                      bitsPerComponent: 8, bytesPerRow: w,
                                      space: CGColorSpaceCreateDeviceGray(),
                                      bitmapInfo: CGImageAlphaInfo.none.rawValue) else { return false }
            ctx.interpolationQuality = .medium
            ctx.draw(image, in: CGRect(x: 0, y: 0, width: w, height: h))
            return true
        }
        guard ok else { return nil }

        // 实测：CGBitmapContext 的内存本来就是「第 0 行在顶部」，无需翻转

        let threshold = 18
        let minRun = 30
        var mask = [UInt8](repeating: 0, count: w * h)

        // 水平线
        for y in 0..<(h - 1) {
            var runStart = -1
            for x in 0..<w {
                let g = abs(Int(gray[y * w + x]) - Int(gray[(y + 1) * w + x]))
                let hit = g > threshold
                if hit, runStart < 0 { runStart = x }
                if (!hit || x == w - 1), runStart >= 0 {
                    let end = hit ? x : x - 1
                    if end - runStart + 1 >= minRun {
                        for xx in runStart...end {
                            mask[y * w + xx] = 255
                            mask[(y + 1) * w + xx] = 255
                        }
                    }
                    runStart = -1
                }
            }
        }

        // 垂直线
        for x in 0..<(w - 1) {
            var runStart = -1
            for y in 0..<h {
                let g = abs(Int(gray[y * w + x]) - Int(gray[y * w + x + 1]))
                let hit = g > threshold
                if hit, runStart < 0 { runStart = y }
                if (!hit || y == h - 1), runStart >= 0 {
                    let end = hit ? y : y - 1
                    if end - runStart + 1 >= minRun {
                        for yy in runStart...end {
                            mask[yy * w + x] = 255
                            mask[yy * w + x + 1] = 255
                        }
                    }
                    runStart = -1
                }
            }
        }

        return Mask(width: w, height: h, pixels: mask)
    }
}
