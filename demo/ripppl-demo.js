/*
 * ripppl 接入 · 按「键盘手」的规格配置
 *
 * 映射关系
 *   1 页面快照   → ripppl 内置（dom-to-image 抓 DOM）
 *   2 透镜扭曲   → amplitude / frequency / speed / damping / decay
 *   3 通道分离   → chromatic + chromaticIntensity
 *   4 色环       → shimmer + shimmerGlowColor（只支持单色）
 *   5 边缘折射   → 由 scope 裁切天然产生
 *   6 边线反光   → 不支持，需要自己补
 */

// 抓帧用：强制 WebGL 保留绘制缓冲，否则 toDataURL 是空白
const origGetContext = HTMLCanvasElement.prototype.getContext;
HTMLCanvasElement.prototype.getContext = function (type, attrs) {
  if (type === 'webgl' || type === 'webgl2' || type === 'experimental-webgl') {
    attrs = Object.assign({}, attrs, { preserveDrawingBuffer: true });
  }
  return origGetContext.call(this, type, attrs);
};

const params = new URLSearchParams(location.search);
const SHOT = params.has('shot') ? parseInt(params.get('shot'), 10) : null;
const PRESET = params.get('preset') || 'dramatic';

// Aurora 四色换算到 OKLCH（近似值）
const AURORA = {
  blue: 'oklch(0.65 0.20 265)',
  violet: 'oklch(0.62 0.22 295)',
  pink: 'oklch(0.72 0.19 355)',
  peach: 'oklch(0.82 0.12 60)',
};

const PRESETS = {
  subtle: {
    amplitude: 1.4, frequency: 0.012, speed: 780, damping: 0.06, decay: 2.0,
    duration: 1100, chromatic: true, chromaticIntensity: 0.22,
    shimmer: AURORA.violet, shimmerWidth: 1.0, shimmerDuration: 800,
    shimmerGlowColor: AURORA.blue,
  },
  balanced: {
    amplitude: 2.2, frequency: 0.014, speed: 900, damping: 0.05, decay: 1.6,
    duration: 1250, chromatic: true, chromaticIntensity: 0.35,
    shimmer: AURORA.violet, shimmerWidth: 1.4, shimmerDuration: 900,
    shimmerGlowColor: AURORA.blue,
  },
  dramatic: {
    amplitude: 5.0, frequency: 0.008, speed: 1050, damping: 0.035, decay: 1.2,
    duration: 1500, chromatic: true, chromaticIntensity: 0.5,
    shimmer: AURORA.pink, shimmerWidth: 2.0, shimmerDuration: 1100,
    shimmerGlowColor: AURORA.violet,
  },
};

const app = document.getElementById('app');
const handle = window.Ripppl.attachRipple(app, {
  scope: app,
  ...PRESETS[PRESET],
});

// 提前抓一次快照，避免第一次触发时卡顿
handle.prefetchCapture();

// 从键盘出发：归一化坐标 (0.5, 1)
function fire() {
  // 不 invalidate：复用预抓的快照，首帧就不会因为等待截图而空掉
  handle.trigger({ x: 0.5, y: 1.0 });
}

window.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') { e.preventDefault(); fire(); setTimeout(showAudit, 320); }
  if (e.key === ' ') { e.preventDefault(); fire(); }
});

document.getElementById('audit').addEventListener('click', showAudit);
document.getElementById('fire').addEventListener('click', (e) => {
  const r = app.getBoundingClientRect();
  handle.trigger({
    x: (e.clientX - r.left) / r.width,
    y: (e.clientY - r.top) / r.height,
  });
});

// ---- 自检横幅：触发后 320ms 采样覆盖层，判断到底有没有渲染 ----
const banner = document.getElementById('banner');
function audit() {
  const c = document.querySelector('canvas');
  if (!c) return { ok: false, why: '没有 canvas（脚本没加载？）' };
  const gl = c.getContext('webgl2') || c.getContext('webgl');
  let nz = 0;
  try {
    const t = document.createElement('canvas');
    t.width = c.width; t.height = c.height;
    const g = t.getContext('2d');
    g.drawImage(c, 0, 0);
    const d = g.getImageData(0, 0, c.width, c.height).data;
    for (let i = 0; i < d.length; i += 4) {
      if (d[i] + d[i + 1] + d[i + 2] > 6) nz++;
    }
  } catch (err) {
    return { ok: false, why: '读取画布失败：' + err.message };
  }
  return {
    ok: nz > 200,
    why: nz > 200
      ? `渲染正常（${nz} 个非空像素）`
      : `画布全空（${nz} 像素）→ 快照纹理没生成，ripppl 在你这个浏览器里没工作`,
  };
}

function showAudit() {
  const r = audit();
  banner.style.display = 'block';
  banner.textContent = (r.ok ? '✅ ' : '❌ ') + r.why;
  banner.style.borderColor = r.ok ? 'rgba(94,234,232,.45)' : 'rgba(255,96,96,.5)';
  banner.style.color = r.ok ? '#9ff0ee' : '#ffb4b4';
}

// 局部改参数：1/2/3 切预设
const keys = { '1': 'subtle', '2': 'balanced', '3': 'dramatic' };
window.addEventListener('keydown', (e) => {
  const name = keys[e.key];
  if (!name) return;
  handle.update(PRESETS[name]);
  document.getElementById('preset').textContent = name;
});

// 截图模式
if (SHOT !== null) {
  setTimeout(() => {
    fire();
    setTimeout(() => {
      const canvas = document.querySelector('canvas');
      try {
        document.getElementById('dump').textContent = canvas.toDataURL('image/png');
      } catch (err) {
        document.getElementById('dump').textContent = 'ERR ' + err.message;
      }
    }, SHOT);
  }, 500);
}
