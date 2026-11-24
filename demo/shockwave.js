/*
 * 冲击波 · 六层原型
 *
 * 1 页面快照 → 在「自己拥有像素」的前提下才成立
 * 2 透镜扭曲 → 环带缩放近似径向位移
 * 3 通道分离 → 红蓝各多/少 8%，绿不动
 * 4 色环     → 四色平滑过渡，随扩散淡出
 * 5 边缘折射 → 到达边界时内容被拉伸，窗框保持
 * 6 边线反光 → 波前经过时描边短暂提亮
 */

const canvas = document.getElementById('c');
const ctx = canvas.getContext('2d');

const PALETTES = {
  aurora: { name: 'Aurora', colors: ['#5EE7FF', '#8B7CFF', '#FF7AC6', '#FFB07A'] },
  halo:   { name: 'Halo',   colors: ['#FFD27A', '#FF9E52', '#FFC46B', '#FFF0C9'] },
  frost:  { name: 'Frost',  colors: ['#9CF5E4', '#6FE7FF', '#B7FFF0', '#DFFFF9'] },
  spark:  { name: 'Spark',  colors: ['#B98CFF', '#FFC94A', '#E0A8FF', '#FFE49A'] },
};

let W = 0, H = 0, DPR = 1;
let base = null;          // 页面快照
let tints = [];           // 红/绿/蓝三通道版本
let wave = null;          // 当前冲击波
let paletteKey = 'aurora';

/* ---------------- 快照 ---------------- */

function buildBase() {
  const c = document.createElement('canvas');
  c.width = Math.round(W * DPR);
  c.height = Math.round(H * DPR);
  const g = c.getContext('2d');
  g.scale(DPR, DPR);

  // 一块「文档」：标题 + 若干行文字 + 两个面板
  g.fillStyle = '#0b0f15';
  g.fillRect(0, 0, W, H);

  const pad = Math.min(96, W * 0.08);
  g.fillStyle = 'rgba(232,238,248,0.92)';
  g.font = '600 44px -apple-system, "PingFang SC", sans-serif';
  g.fillText('每日之歌', pad, pad + 44);

  g.font = '15px -apple-system, sans-serif';
  g.fillStyle = 'rgba(138,148,166,0.85)';
  g.fillText('2026-11-23 · BPM 82 · 88 秒', pad, pad + 78);

  // 正文行
  const lineH = 26;
  let y = pad + 130;
  const widths = [0.72, 0.86, 0.64, 0.78, 0.5, 0.83, 0.69, 0.74, 0.42];
  g.font = '16px -apple-system, "PingFang SC", sans-serif';
  for (let i = 0; i < widths.length; i++) {
    const w = (W - pad * 2) * widths[i];
    g.fillStyle = 'rgba(232,238,248,0.20)';
    g.fillRect(pad, y, w, 10);
    y += lineH;
  }

  // 两个面板
  y += 20;
  const panelW = (W - pad * 2 - 24) / 2;
  for (let i = 0; i < 2; i++) {
    g.fillStyle = 'rgba(94,234,232,0.06)';
    g.strokeStyle = 'rgba(94,234,232,0.18)';
    g.lineWidth = 1;
    g.beginPath();
    g.roundRect(pad + i * (panelW + 24), y, panelW, 120, 14);
    g.fill();
    g.stroke();
    g.fillStyle = 'rgba(94,234,232,0.55)';
    g.font = '600 13px -apple-system, sans-serif';
    g.fillText(i === 0 ? '字数 179' : '击键 1012', pad + 20 + i * (panelW + 24), y + 34);
  }

  base = c;
  tints = [
    makeTint(c, 'rgb(255,60,60)'),
    makeTint(c, 'rgb(60,255,120)'),
    makeTint(c, 'rgb(70,90,255)'),
  ];
}

function makeTint(src, color) {
  const c = document.createElement('canvas');
  c.width = src.width;
  c.height = src.height;
  const g = c.getContext('2d');
  g.drawImage(src, 0, 0);
  g.globalCompositeOperation = 'multiply';
  g.fillStyle = color;
  g.fillRect(0, 0, c.width, c.height);
  g.globalCompositeOperation = 'source-over';
  return c;
}

/* ---------------- 冲击波 ---------------- */

function fire(now) {
  wave = { born: now, life: 1.25, cx: W * 0.5, cy: H * 0.56 };
}

function drawWave(now) {
  if (!wave) return;
  const t = (now - wave.born) / wave.life;
  if (t > 1) { wave = null; return; }

  const maxR = Math.hypot(Math.max(wave.cx, W - wave.cx), Math.max(wave.cy, H - wave.cy));
  const R = 40 + t * maxR * 1.05;
  const sigma = 34 + t * 40;
  const amp = 26 * Math.pow(1 - t, 1.5);          // 位移量随时间衰减
  const palette = PALETTES[paletteKey];

  // ---- 2/5 透镜扭曲：只重绘波前附近的环带 ----
  const bands = 9;
  const span = sigma * 2.6;
  for (let i = 0; i < bands; i++) {
    const r0 = Math.max(1, R - span / 2 + (span / bands) * i);
    const r1 = r0 + span / bands + 1;
    const rc = (r0 + r1) / 2;
    const d = amp * Math.exp(-Math.pow((rc - R) / sigma, 2));
    const sBase = 1 + d / rc;
    if (Math.abs(sBase - 1) < 0.0015) continue;

    ctx.save();
    ctx.beginPath();
    ctx.arc(wave.cx, wave.cy, r1, 0, Math.PI * 2);
    ctx.arc(wave.cx, wave.cy, r0, 0, Math.PI * 2, true);
    ctx.clip();

    if (i % 3 === 0) {
      // ---- 3 通道分离：红蓝各偏 8%，绿不动 ----
      const passes = [
        [tints[0], 1 + (d * 1.08) / rc, 0.55],
        [tints[2], 1 + (d * 0.92) / rc, 0.55],
        [tints[1], sBase, 1.0],
      ];
      ctx.globalCompositeOperation = 'lighter';
      for (const [src, factor, alpha] of passes) {
        ctx.save();
        ctx.translate(wave.cx, wave.cy);
        ctx.scale(factor, factor);
        ctx.translate(-wave.cx, -wave.cy);
        ctx.globalAlpha = alpha;
        ctx.drawImage(src, 0, 0, W, H);
        ctx.restore();
      }
      ctx.globalAlpha = 1;
      ctx.globalCompositeOperation = 'source-over';
    } else {
      ctx.translate(wave.cx, wave.cy);
      ctx.scale(sBase, sBase);
      ctx.translate(-wave.cx, -wave.cy);
      ctx.drawImage(base, 0, 0, W, H);
    }
    ctx.restore();
  }

  // ---- 4 色环 ----
  ctx.save();
  ctx.globalCompositeOperation = 'lighter';
  for (let k = 0; k < 4; k++) {
    const rr = R - k * 9;
    if (rr <= 2) continue;
    const a = Math.pow(1 - t, 2.1) * (0.42 - k * 0.07);
    ctx.strokeStyle = hexA(palette.colors[k], a);
    ctx.lineWidth = 5 - k * 0.9;
    ctx.beginPath();
    ctx.arc(wave.cx, wave.cy, rr, 0, Math.PI * 2);
    ctx.stroke();
  }
  ctx.restore();

  // ---- 6 边线反光：波前接近边缘时窗框提亮 ----
  const edgeDist = Math.min(W, H) * 0.5;
  const reach = Math.max(0, 1 - Math.abs(R - edgeDist) / (edgeDist * 0.6));
  if (reach > 0.01) {
    ctx.strokeStyle = hexA(palette.colors[0], 0.35 * reach * (1 - t));
    ctx.lineWidth = 2;
    ctx.strokeRect(1, 1, W - 2, H - 2);
  }
}

/* ---------------- 工具 ---------------- */

function hexA(hex, a) {
  const r = parseInt(hex.slice(1, 3), 16);
  const g = parseInt(hex.slice(3, 5), 16);
  const b = parseInt(hex.slice(5, 7), 16);
  return `rgba(${r},${g},${b},${a})`;
}

function resize() {
  DPR = Math.min(window.devicePixelRatio || 1, 2);
  W = canvas.clientWidth;
  H = canvas.clientHeight;
  canvas.width = Math.round(W * DPR);
  canvas.height = Math.round(H * DPR);
  ctx.setTransform(DPR, 0, 0, DPR, 0, 0);
  buildBase();
}

/* ---------------- 主循环 ---------------- */

function frame(now) {
  now = now / 1000;
  ctx.setTransform(DPR, 0, 0, DPR, 0, 0);
  ctx.drawImage(base, 0, 0, W, H);
  drawWave(now);
  requestAnimationFrame(frame);
}

/* ---------------- 交互/截图 ---------------- */

const params = new URLSearchParams(location.search);
if (params.has('palette')) paletteKey = params.get('palette');
const SHOT = params.has('t') ? parseFloat(params.get('t')) : null;

if (SHOT !== null) {
  resize();
  const born = 0.2;
  wave = { born, life: 1.25, cx: W * 0.5, cy: H * 0.56 };
  ctx.setTransform(DPR, 0, 0, DPR, 0, 0);
  ctx.drawImage(base, 0, 0, W, H);
  drawWave(SHOT);
  setTimeout(() => {
    ctx.setTransform(DPR, 0, 0, DPR, 0, 0);
    ctx.drawImage(base, 0, 0, W, H);
    drawWave(SHOT);
    document.getElementById('dump').textContent = canvas.toDataURL('image/png');
  }, 60);
} else {
  resize();
  requestAnimationFrame(frame);
  window.addEventListener('keydown', e => {
    if (e.key === 'Enter') { e.preventDefault(); fire(performance.now() / 1000); }
    if (e.key === '1') paletteKey = 'aurora';
    if (e.key === '2') paletteKey = 'halo';
    if (e.key === '3') paletteKey = 'frost';
    if (e.key === '4') paletteKey = 'spark';
  });
  window.addEventListener('resize', resize);
  setTimeout(() => fire(performance.now() / 1000), 400);
}
