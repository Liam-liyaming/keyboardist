# ripppl 接法设计

> 把「回车冲击波」从自研 canvas 换成 ripppl（MIT，WebGL + DOM 快照）。
> 结论：**前四层它都包了，第五层由裁切天然产生，第六层要自己补**。

---

## 一、为什么选它

| 我们手写要做的 | ripppl 的对应参数 |
|---|---|
| 页面快照 | 内置（dom-to-image 抓 DOM 再上传为纹理） |
| 透镜扭曲 | `amplitude` / `frequency` / `speed` / `damping` / `decay` |
| 通道分离 | `chromatic` + `chromaticIntensity` |
| 色环 | `shimmer` + `shimmerGlowColor`（OKLCH） |
| 边缘折射 | 由 `scope` 裁切天然产生 |
| 边线反光 | ❌ 不支持，需补一层 CSS |

它比自研版强的地方：**扭曲的是真实 DOM**，文字会跟着形变，而不是只扭曲一张画布。

---

## 二、参数设计

三档预设，按「打扰程度」分：

| 参数 | subtle（轻） | balanced（中） | dramatic（重） | 依据 |
|---|---|---|---|---|
| `amplitude` | 1.4 | 2.2 | 3.4 | 超过 3 文字开始读不清 |
| `frequency` | 0.012 | 0.014 | 0.010 | 越小环越宽，越像水波 |
| `speed` | 780 | 900 | 1050 | 我们实测 0.45s 跨屏 |
| `damping` | 0.06 | 0.05 | 0.035 | 拖尾长度 |
| `decay` | 2.0 | 1.6 | 1.2 | 越大消失越快 |
| `duration` | 1100 | 1250 | 1500 | 默认 3500 太拖沓 |
| `chromatic` | ✓ | ✓ | ✓ | 色散是「高级感」的主要来源 |
| `chromaticIntensity` | 0.22 | 0.35 | 0.5 | 对应设计稿的 ±8% |
| `shimmer` | `oklch(0.62 0.22 295)` | 同左 | `oklch(0.72 0.19 355)` | Aurora 紫 / 粉 |
| `shimmerWidth` | 1.0 | 1.4 | 2.0 | 光带宽度 |
| `shimmerDuration` | 800 | 900 | 1100 | 略短于 duration，收得干净 |
| `shimmerGlowColor` | `oklch(0.65 0.20 265)` | 同左 | `oklch(0.62 0.22 295)` | Aurora 蓝 / 紫 |

**Aurora 四色的 OKLCH 换算**（近似）：

```
#508CFF → oklch(0.65 0.20 265)
#A06EFF → oklch(0.62 0.22 295)
#FF6EB4 → oklch(0.72 0.19 355)
#FFBE8C → oklch(0.82 0.12 60)
```

---

## 三、和自研版的差距

| 差距 | 影响 | 补偿方案 |
|---|---|---|
| **只能单色 shimmer** | 做不出「四色环」 | 用紫做主环、蓝做 glow；四色环留给 native 版本 |
| **没有边线反光** | 少了第六层 | trigger 后叠一层 CSS `box-shadow` 边框，600ms 内渐亮渐灭 |
| **坐标是 scope 内归一化** | 起点要对准底边 | `trigger({ x: 0.5, y: 1.0 })` |
| **快照有成本** | 首帧可能空 | `prefetchCapture()` 预热；DOM 变了再 `invalidateCapture()` |

---

## 四、集成 checklist

1. **初始化**：`attachRipple(container, { scope: container, ...PRESET })`
2. **预热**：页面稳定后立刻 `prefetchCapture()`
3. **触发**：回车 → `trigger({ x: 0.5, y: 1.0 })`
4. **失效**：内容变化（切页、加载完）→ `invalidateCapture()`，下次触发前再 `prefetchCapture()`
5. **降级**：`prefers-reduced-motion` 时不挂载，只留边框反光

---

## 五、补丁：把匀速波前改成「先快后慢」

ripppl 原版 shader 是匀速的：

```glsl
float front = t * u_speed;                        // 线性，调 speed 只能改快慢
float phase = dist * u_freq - t * u_speed * u_freq;
```

改成指数逼近（`demo/vendor/ripppl.global.js` 里已打补丁，文件头有标注）：

```glsl
float front = (u_speed / 2.4) * (1.0 - exp(-2.4 * t));   // 起始速度 u_speed，渐慢
float phase = (dist - front) * u_freq;                   // 环随波前一起减速
```

**语义变化**：`u_speed` 从「恒定速度」变成「初始速度」，最终波前停在 `u_speed / 2.4` 像素处。

- `u_speed = 2600` → 最远推到约 1083px，1200 宽的视口刚好扫完
- 系数 `2.4` 决定减速快慢：越大停得越快，越小滑得越远

这就是「先快后慢」的来源——不是缓动函数套在外面，而是波前的运动方程本身带阻尼。

## 六、验证说明

**headless Chrome + swiftshader 下 ripppl 产不出画面**：它的 DOM 快照（SVG foreignObject → canvas → WebGL 纹理）在无 GPU 环境里输出空纹理，画布全透明。这不是参数问题——最小复现页（一个渐变 div）同样全空。

所以自动截图验证这条路对 ripppl 不可用，**必须在真实浏览器里看**：

```
python3 -m http.server 8787 --bind 127.0.0.1
open http://127.0.0.1:8787/ripppl-demo.html
```

回车触发，`1/2/3` 切三档预设。
