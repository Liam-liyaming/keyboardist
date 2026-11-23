/*
 * 键盘手 · 每日之歌可视化原型
 *
 * 设计约束（来自调研）：
 *   1. 音高 → 高度（对数频率），跨度 ≥2 个八度才可辨
 *   2. 响度 → 尺寸/不透明度，用 sqrt 压缩，不用线性
 *   3. 颜色不承担编码，只承担情绪：固定青→琥珀双色调
 *   4. 视觉脉冲上限 ≤2Hz，用缓动不用瞬跳；快攻慢放
 *   5. 用音频时钟驱动（audio.currentTime），帧率无关
 *   6. 夜间：低色温、呼吸式缓变、无全屏闪烁
 */

const SONG = window.SONG;
const canvas = document.getElementById('c');
const ctx = canvas.getContext('2d');
const audio = document.getElementById('audio');
const hud = document.getElementById('hud');

const CYAN = [94, 234, 232];
const AMBER = [255, 206, 150];

let W = 0, H = 0, DPR = 1;
let mode = 1;
const params = new URLSearchParams(location.search);
const SHOT_T = params.has('shot') ? parseFloat(params.get('shot')) : null;
if (params.has('mode')) mode = Math.max(1, Math.min(3, Number(params.get('mode'))));
let particles = [];
let spawnedIndex = 0;
let spectroCache = null;
let lastTime = 0;

const notes = SONG.notes.slice().sort((a, b) => a.t - b.t);
const duration = SONG.seconds || (notes.length ? notes[notes.length - 1].t + 2 : 1);

/* ---------------- 工具 ---------------- */

function resize() {
  DPR = Math.min(window.devicePixelRatio || 1, 2);
  W = canvas.clientWidth;
  H = canvas.clientHeight;
  canvas.width = Math.round(W * DPR);
  canvas.height = Math.round(H * DPR);
  ctx.setTransform(DPR, 0, 0, DPR, 0, 0);
  spectroCache = null;
}

function mix(a, b, t) {
  return [
    Math.round(a[0] + (b[0] - a[0]) * t),
    Math.round(a[1] + (b[1] - a[1]) * t),
    Math.round(a[2] + (b[2] - a[2]) * t),
  ];
}

// 音高 → 归一化高度（0 低，1 高），对数映射
const MIDI_LO = 40, MIDI_HI = 100;
function pitch01(m) {
  return Math.max(0, Math.min(1, (Math.log2(m / MIDI_LO) / Math.log2(MIDI_HI / MIDI_LO))));
}

// 响度 → 尺寸：sqrt 压缩，避免动态范围全挤在两端
function ampScale(a) {
  return Math.sqrt(Math.max(0, Math.min(1, a * 6)));
}

function glow(x, y, r, color, alpha) {
  const g = ctx.createRadialGradient(x, y, 0, x, y, r);
  g.addColorStop(0, `rgba(${color[0]},${color[1]},${color[2]},${alpha})`);
  g.addColorStop(0.45, `rgba(${color[0]},${color[1]},${color[2]},${alpha * 0.35})`);
  g.addColorStop(1, `rgba(${color[0]},${color[1]},${color[2]},0)`);
  ctx.fillStyle = g;
  ctx.beginPath();
  ctx.arc(x, y, r, 0, Math.PI * 2);
  ctx.fill();
}

/* ---------------- 模式 1：光河 ---------------- */

function spawn(note) {
  const x = 0.06 * W + note.p * 0.88 * W;
  const y = H * 0.94 - pitch01(note.m) * H * 0.55;
  particles.push({
    x, y,
    r: 18 + ampScale(note.a) * 46,
    age: 0,
    life: note.k === 'pad' ? 3.2 : 2.0,
    a: ampScale(note.a),
    amber: pitch01(note.m) > 0.55,       // 高音偏暖，仅情绪编码
    isPad: note.k === 'pad',
  });
}

function drawRiver(dt) {
  const horizon = H * 0.93;

  // 底色
  const bg = ctx.createLinearGradient(0, 0, 0, H);
  bg.addColorStop(0, '#06080c');
  bg.addColorStop(0.55, '#080b11');
  bg.addColorStop(1, '#0a0f15');
  ctx.fillStyle = bg;
  ctx.fillRect(0, 0, W, H);

  // 地平线：一条极淡的光带，标出「键盘」的位置
  const lineGrad = ctx.createLinearGradient(0, horizon - 26, 0, horizon);
  lineGrad.addColorStop(0, 'rgba(94,234,232,0)');
  lineGrad.addColorStop(1, 'rgba(94,234,232,0.16)');
  ctx.fillStyle = lineGrad;
  ctx.fillRect(0, horizon - 26, W, 26);
  ctx.fillStyle = 'rgba(94,234,232,0.20)';
  ctx.fillRect(0, horizon, W, 1);

  ctx.globalCompositeOperation = 'lighter';

  // 第一层：和声铺底 —— 底部一条随 amp 呼吸的宽带，不做点状反馈
  for (const p of particles) {
    if (!p.isPad || p.age > p.life) continue;
    const t = p.age / p.life;
    const fade = Math.pow(1 - t, 1.2);
    const w = W * 0.42;
    ctx.save();
    ctx.translate(p.x, horizon);
    ctx.scale(1, 0.18);
    glow(0, 0, w / 2, CYAN, 0.16 * fade);
    ctx.restore();
  }

  // 第二层：光柱（结构）
  for (const p of particles) {
    if (p.isPad || p.age > p.life) continue;
    const t = p.age / p.life;
    const fade = Math.pow(1 - t, 1.6);
    const color = p.amber ? AMBER : CYAN;
    const height = horizon - p.y;
    if (height <= 4) continue;

    const col = ctx.createLinearGradient(p.x, p.y, p.x, horizon);
    col.addColorStop(0, `rgba(${color[0]},${color[1]},${color[2]},${0.55 * fade})`);
    col.addColorStop(0.55, `rgba(${color[0]},${color[1]},${color[2]},${0.10 * fade})`);
    col.addColorStop(1, `rgba(${color[0]},${color[1]},${color[2]},0)`);
    ctx.fillStyle = col;
    ctx.fillRect(p.x - 2, p.y, 4, height);
  }

  for (const p of particles) {
    p.age += dt;
    if (p.isPad || p.age > p.life) continue;
    const t = p.age / p.life;
    const attack = Math.min(1, t / 0.08);
    const fade = Math.pow(1 - t, 1.6);
    const alpha = p.a * attack * fade * 2.2;
    const color = p.amber ? AMBER : CYAN;
    glow(p.x, p.y - t * 26, p.r * (0.75 + t * 0.9), color, alpha);
  }

  ctx.globalCompositeOperation = 'source-over';
  particles = particles.filter(p => p.age <= p.life);
}

/* ---------------- 模式 2：声谱地形 ---------------- */

function buildSpectro() {
  const cols = 1400;
  const rows = 96;
  const off = document.createElement('canvas');
  off.width = cols;
  off.height = rows;
  const o = off.getContext('2d');
  o.fillStyle = '#06080c';
  o.fillRect(0, 0, cols, rows);

  for (const n of notes) {
    const x = Math.round((n.t / duration) * (cols - 1));
    const row = Math.round((1 - pitch01(n.m)) * (rows - 1));
    const strength = Math.min(1, n.a * 7);
    const w = Math.max(1, Math.round((n.d / duration) * cols * 0.5));
    for (let dx = 0; dx < w && x + dx < cols; dx++) {
      const a = strength * Math.pow(1 - dx / w, 1.6);
      o.fillStyle = `rgba(94,234,232,${a * 0.85})`;
      o.fillRect(x + dx, row, 1, 1);
      if (row + 1 < rows) o.fillRect(x + dx, row + 1, 1, 1);
    }
  }
  spectroCache = off;
}

function drawSpectro() {
  if (!spectroCache) buildSpectro();

  ctx.fillStyle = '#06080c';
  ctx.fillRect(0, 0, W, H);

  const t = audio.currentTime || 0;
  const windowSec = 14;                     // 只看最近 14 秒
  const srcW = (windowSec / duration) * spectroCache.width;
  const srcX = Math.max(0, (t / duration) * spectroCache.width - srcW);

  // 八度参考线（低频在下，高频在上）
  ctx.strokeStyle = 'rgba(94,234,232,0.07)';
  ctx.lineWidth = 1;
  for (let m = 40; m <= 100; m += 12) {
    const y = H * 0.08 + (1 - pitch01(m)) * H * 0.72;
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(W, y);
    ctx.stroke();
  }

  ctx.globalAlpha = 0.95;
  ctx.imageSmoothingEnabled = false;
  ctx.drawImage(spectroCache, srcX, 0, srcW, spectroCache.height, 0, H * 0.08, W, H * 0.72);
  ctx.globalAlpha = 1;

  // 播放头：一条细线 + 极淡的光晕
  const px = W - 1;
  const g = ctx.createLinearGradient(px - 24, 0, px, 0);
  g.addColorStop(0, 'rgba(255,206,150,0)');
  g.addColorStop(1, 'rgba(255,206,150,0.28)');
  ctx.fillStyle = g;
  ctx.fillRect(px - 24, H * 0.08, 24, H * 0.72);
  ctx.fillStyle = 'rgba(255,206,150,0.85)';
  ctx.fillRect(px, H * 0.08, 1, H * 0.72);

  // 时间刻度
  ctx.fillStyle = 'rgba(138,148,166,0.75)';
  ctx.font = '12px -apple-system, sans-serif';
  for (let s = Math.max(0, Math.ceil(t - windowSec)); s < t; s += 2) {
    const x = W - ((t - s) / windowSec) * W;
    ctx.fillRect(x, H * 0.8, 1, 6);
  }
}

/* ---------------- 模式 3：呼吸 ---------------- */

function drawBreath(now) {
  ctx.fillStyle = '#05070a';
  ctx.fillRect(0, 0, W, H);

  const t = audio.currentTime || 0;
  const active = notes.filter(n => n.t <= t && n.t + n.d > t && n.k === 'pad');

  ctx.globalCompositeOperation = 'lighter';
  active.forEach((n, i) => {
    const phase = (t * 0.12 + i * 0.8) % 1;
    const r = Math.min(W, H) * (0.35 + 0.12 * Math.sin(2 * Math.PI * phase));
    glow(W * 0.5, H * 0.62, r, mix(CYAN, AMBER, pitch01(n.m)), 0.11 + 0.06 * Math.sin(2 * Math.PI * phase));
  });
  ctx.globalCompositeOperation = 'source-over';

  ctx.fillStyle = 'rgba(138,148,166,0.5)';
  ctx.font = '13px -apple-system, sans-serif';
  ctx.textAlign = 'center';
  ctx.fillText('呼吸模式 · 低亮度、无闪烁', W / 2, H * 0.9);
  ctx.textAlign = 'left';
}

/* ---------------- 主循环 ---------------- */

function frame() {
  const now = performance.now();
  const dt = Math.min(0.1, (now - lastTime) / 1000 || 0.016);
  lastTime = now;

  const t = audio.currentTime || 0;

  // 按音频时钟推进事件指针（帧率无关）
  while (spawnedIndex < notes.length && notes[spawnedIndex].t <= t) {
    if (mode === 1) spawn(notes[spawnedIndex]);
    spawnedIndex++;
  }

  if (mode === 1) drawRiver(dt);
  else if (mode === 2) drawSpectro();
  else drawBreath(now);

  hud.textContent =
    `${SONG.day || ''}  ·  BPM ${Math.round(SONG.bpm || 0)}  ·  ${t.toFixed(1)}s / ${duration.toFixed(0)}s  ·  模式 ${mode}`;

  requestAnimationFrame(frame);
}

/* ---------------- 交互 ---------------- */

function restartIfNeeded() {
  const t = audio.currentTime;
  if (t < 0.05) {
    spawnedIndex = 0;
    particles = [];
  }
}

audio.addEventListener('seeked', () => {
  spawnedIndex = 0;
  particles = [];
  while (spawnedIndex < notes.length && notes[spawnedIndex].t <= audio.currentTime) {
    if (mode === 1) spawn(notes[spawnedIndex]);
    spawnedIndex++;
  }
});
audio.addEventListener('play', restartIfNeeded);

document.getElementById('start').addEventListener('click', () => {
  document.getElementById('start').style.display = 'none';
  audio.play();
});

document.addEventListener('keydown', e => {
  if (e.key === ' ') {
    e.preventDefault();
    if (audio.paused) audio.play(); else audio.pause();
  }
  if (e.key === '1' || e.key === '2' || e.key === '3') {
    mode = Number(e.key);
    particles = [];
    spectroCache = null;
    spawnedIndex = 0;
    const t = audio.currentTime;
    while (spawnedIndex < notes.length && notes[spawnedIndex].t <= t) spawnedIndex++;
  }
});

window.addEventListener('resize', resize);

resize();

// ---- 静态截图模式（用于自动化验证）----
function renderStill(t) {
  if (mode === 1) {
    particles = [];
    for (const n of notes) {
      if (n.t <= t && n.t > t - 3) {
        spawn(n);
        const p = particles[particles.length - 1];
        p.age = Math.max(t - n.t, 0.12 * p.life);   // 跳过起手瞬间，便于静态验证
      }
    }
  }
  if (mode === 1) {
    drawRiver(0.016);
  }
  else if (mode === 2) { if (!spectroCache) buildSpectro(); drawSpectro(); }
  else drawBreath(performance.now());
  hud.textContent = `${SONG.day || ''}  ·  BPM ${Math.round(SONG.bpm || 0)}  ·  ${t.toFixed(1)}s / ${duration.toFixed(0)}s  ·  模式 ${mode}`;
}

if (SHOT_T !== null) {
  document.getElementById('start').style.display = 'none';
  audio.currentTime = SHOT_T;
  renderStill(SHOT_T);
  setTimeout(() => {
    renderStill(SHOT_T);
    // 把画布导出成 dataURL，交给自动化脚本取回（headless 截图抓不到 canvas）
    try { document.getElementById('dump').textContent = canvas.toDataURL('image/png'); }
    catch (e) { document.getElementById('dump').textContent = 'ERR ' + e.message; }
  }, 80);
} else {
  requestAnimationFrame(frame);
}
