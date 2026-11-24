/*
 * 键盘手 · 打字游戏化原型
 *
 * 核心机制：
 *   连击（combo）= 连续成功的输入
 *   修正（correction）= 击键后 1.2s 内的退格 → 打错了，断连击，红光
 *   改写（revision）= 停顿后的退格 → 正常编辑，不断连击，琥珀光
 *   提交（enter）= 把连击兑现成分数 → 全屏涟漪 + 边缘辉光
 *
 * 设计依据：把「删除」一律当错误是错的——改写是写作的正常部分。
 */

const canvas = document.getElementById('c');
const ctx = canvas.getContext('2d');
const hud = document.getElementById('hud');
const ring = document.getElementById('ring');

const CYAN = [94, 234, 232];
const AMBER = [255, 206, 150];
const RED = [255, 96, 96];

let W = 0, H = 0;
let back = null;          // 离屏画布（承载上一帧，做拖影）

const state = {
  combo: 0,
  best: 0,
  corrections: 0,
  revisions: 0,
  banked: 0,
  lastKeyAt: 0,
  lastCorrectionAt: 0,
  sparks: [],
  flashes: [],
  ripples: [],
  comboPop: 0,            // 连击数字的弹性
  edgePulseAt: -99,       // 上次「连续修正」的时刻
  time: 0,
};

/* ---------------- 初始化 ---------------- */

function resize() {
  const dpr = Math.min(window.devicePixelRatio || 1, 2);
  W = canvas.clientWidth;
  H = canvas.clientHeight;
  canvas.width = Math.round(W * dpr);
  canvas.height = Math.round(H * dpr);
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

  back = document.createElement('canvas');
  back.width = canvas.width;
  back.height = canvas.height;

  // 画布必须是不透明的，否则导出的 PNG 会带透明通道
  ctx.fillStyle = '#06080c';
  ctx.fillRect(0, 0, W, H);
}

function glow(x, y, r, color, alpha) {
  const g = ctx.createRadialGradient(x, y, 0, x, y, r);
  g.addColorStop(0, `rgba(${color[0]},${color[1]},${color[2]},${alpha})`);
  g.addColorStop(0.5, `rgba(${color[0]},${color[1]},${color[2]},${alpha * 0.3})`);
  g.addColorStop(1, `rgba(${color[0]},${color[1]},${color[2]},0)`);
  ctx.fillStyle = g;
  ctx.beginPath();
  ctx.arc(x, y, r, 0, Math.PI * 2);
  ctx.fill();
}

// 用字符码粗略映射到键盘横向位置
function xForChar(ch) {
  if (!ch) return W * 0.5;
  const code = ch.charCodeAt(0);
  const n = code % 40;
  return W * (0.12 + (n / 40) * 0.76);
}

/* ---------------- 事件处理 ---------------- */

function press(key, now) {
  const gap = state.lastKeyAt ? now - state.lastKeyAt : 1;

  if (key === 'Backspace') {
    if (gap < 1.2) {
      // 修正：打错了。单次用中性琥珀，短时间内连续修正才升级为红色
      const repeated = state.lastCorrectionAt && now - state.lastCorrectionAt < 4;
      state.corrections++;
      state.combo = 0;
      state.lastCorrectionAt = now;
      const color = repeated ? RED : AMBER;
      state.flashes.push({ color, born: now, life: repeated ? 0.6 : 0.5, strength: repeated ? 0.42 : 0.20 });
      state.sparks.push({ x: W * 0.5, born: now, life: 0.5, color, size: repeated ? 100 : 60, amp: repeated ? 1 : 0.5 });
      if (repeated) state.edgePulseAt = now;
    } else {
      // 改写：主动编辑，不惩罚
      state.revisions++;
      state.flashes.push({ color: AMBER, born: now, life: 0.7, strength: 0.18 });
    }
    state.lastKeyAt = now;
    return;
  }

  if (key === 'Enter') {
    state.banked += state.combo;
    state.ripples.push({ born: now, life: 1.05, power: Math.min(1, state.combo / 40) });
    state.flashes.push({ color: CYAN, born: now, life: 0.9, strength: 0.16 });
    if (state.combo > state.best) state.best = state.combo;
    state.combo = 0;
    state.lastKeyAt = now;
    return;
  }

  if (key === ' ') {
    state.sparks.push({ x: W * 0.5, born: now, life: 0.35, color: CYAN, size: 40, amp: 0.35 });
    state.combo++;
    state.comboPop = 1;
  } else if (key.length === 1) {
    state.combo++;
    state.comboPop = 1;
    state.sparks.push({
      x: xForChar(key), born: now, life: 0.65,
      color: CYAN, size: 26 + Math.min(28, state.combo * 1.2), amp: 0.5,
    });
  }
  if (state.combo > state.best) state.best = state.combo;
  state.lastKeyAt = now;
}

/* ---------------- 渲染 ---------------- */

function draw(now, dt) {
  // 拖影：上一帧淡出
  ctx.save();
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  ctx.fillStyle = 'rgba(6,8,12,0.22)';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.restore();

  // 底部地平线
  const horizon = H * 0.945;
  const line = ctx.createLinearGradient(0, horizon - 90, 0, horizon);
  line.addColorStop(0, 'rgba(94,234,232,0)');
  line.addColorStop(1, 'rgba(94,234,232,0.10)');
  ctx.fillStyle = line;
  ctx.fillRect(0, horizon - 90, W, 90);
  ctx.fillStyle = `rgba(94,234,232,${0.12 + Math.min(0.35, state.combo / 160)})`;
  ctx.fillRect(0, horizon, W, 1);

  ctx.globalCompositeOperation = 'lighter';

  // 击键火花
  for (const s of state.sparks) {
    const t = (now - s.born) / s.life;
    if (t > 1) continue;
    const a = (1 - t) * (1 - t) * s.amp;
    glow(s.x, horizon - 4, s.size * (0.7 + t * 0.9), s.color, a);
  }

  // 全屏涟漪（回车）：三层波前 + 椭圆压扁，像水面而不是圆环
  for (const r of state.ripples) {
    const t = (now - r.born) / r.life;
    if (t > 1) continue;
    const cx = W / 2;
    const cy = H * 0.72;

    ctx.save();
    ctx.translate(cx, cy);
    ctx.scale(1, 0.42);            // 压扁成水平面
    for (let k = 0; k < 3; k++) {
      const tt = t - k * 0.08;
      if (tt <= 0) continue;
      const radius = 60 + tt * Math.max(W, H) * 1.05;
      const a = Math.pow(1 - tt, 2.2) * (0.34 + r.power * 0.3) / (1 + k * 0.9);
      ctx.strokeStyle = `rgba(94,234,232,${a})`;
      ctx.lineWidth = (3 + (1 - tt) * 9) / (1 + k * 0.5);
      ctx.beginPath();
      ctx.arc(0, 0, radius, 0, Math.PI * 2);
      ctx.stroke();
    }
    ctx.restore();

    // 中心的一下亮点
    const flash = Math.pow(1 - t, 3) * 0.5;
    if (flash > 0.01) glow(cx, H * 0.72, 120 + t * 260, CYAN, flash);
  }

  // 闪光（修正=红 / 改写=琥珀 / 提交=青）
  for (const f of state.flashes) {
    const t = (now - f.born) / f.life;
    if (t > 1) continue;
    const a = Math.pow(1 - t, 1.8) * f.strength;
    const isRed = f.color === RED;
    const top = isRed ? H * 0.78 : H * 0.55;      // 红色只染底边，不淹没屏幕
    const g = ctx.createLinearGradient(0, H, 0, top);
    g.addColorStop(0, `rgba(${f.color[0]},${f.color[1]},${f.color[2]},${a})`);
    g.addColorStop(1, `rgba(${f.color[0]},${f.color[1]},${f.color[2]},0)`);
    ctx.fillStyle = g;
    ctx.fillRect(0, top, W, H - top);
  }

  ctx.globalCompositeOperation = 'source-over';

  // 清理
  state.sparks = state.sparks.filter(s => now - s.born < s.life);
  state.flashes = state.flashes.filter(f => now - f.born < f.life);
  state.ripples = state.ripples.filter(r => now - r.born < r.life);

  const edge = Math.max(0, 1 - (now - state.edgePulseAt) / 0.9);
  if (edge > 0.01) {
    // 只留一条细边线，不做整屏泛红
    ctx.strokeStyle = `rgba(255,96,96,${0.22 * edge})`;
    ctx.lineWidth = 2;
    ctx.strokeRect(1, 1, W - 2, H - 2);
  }

  drawCombo(now);
  drawStats();
}

function drawCombo(now) {
  const pop = Math.max(0, state.comboPop);
  const scale = 1 + pop * 0.22;
  const y = H * 0.30;

  ctx.save();
  ctx.translate(W / 2, y);
  ctx.scale(scale, scale);

  if (state.combo > 0) {
    const heat = Math.min(1, state.combo / 60);
    ctx.globalCompositeOperation = 'lighter';
    glow(0, 0, 150 + heat * 120, CYAN, 0.05 + heat * 0.16);
    ctx.globalCompositeOperation = 'source-over';

    ctx.fillStyle = `rgba(232,238,248,${0.55 + heat * 0.45})`;
    ctx.font = '600 92px -apple-system, "PingFang SC", sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText(String(state.combo), 0, 30);

    ctx.fillStyle = 'rgba(138,148,166,0.75)';
    ctx.font = '13px -apple-system, sans-serif';
    ctx.letterSpacing = '0.3em';
    ctx.fillText('连 击', 0, 62);
  }
  ctx.restore();
}

function drawStats() {
  const items = [
    ['最佳', state.best],
    ['修正', state.corrections],
    ['改写', state.revisions],
    ['兑现', state.banked],
  ];
  ctx.font = '12px -apple-system, sans-serif';
  ctx.textAlign = 'left';
  items.forEach(([label, value], i) => {
    const x = 28 + i * 120;
    ctx.fillStyle = 'rgba(93,104,120,0.9)';
    ctx.fillText(label, x, H - 52);
    ctx.fillStyle = 'rgba(232,238,248,0.92)';
    ctx.font = '600 18px -apple-system, sans-serif';
    ctx.fillText(String(value), x, H - 30);
    ctx.font = '12px -apple-system, sans-serif';
  });
}

/* ---------------- 主循环 ---------------- */

let last = performance.now();
function loop(now) {
  const dt = Math.min(0.05, (now - last) / 1000);
  last = now;
  state.comboPop *= Math.pow(0.001, dt * 6);
  draw(now / 1000, dt);
  requestAnimationFrame(loop);
}

/* ---------------- 输入 ---------------- */

window.addEventListener('keydown', e => {
  if (e.metaKey || e.ctrlKey || e.altKey) return;
  if (e.key === 'Backspace' || e.key === 'Enter' || e.key === ' ' || e.key.length === 1) {
    e.preventDefault();
    press(e.key, performance.now() / 1000);
  }
});

/* ---------------- 演示/截图模式 ---------------- */

const params = new URLSearchParams(location.search);
const SHOT = params.has('t') ? parseFloat(params.get('t')) : null;

function buildScript() {
  const events = [];
  let t = 0.3;
  const sentences = [
    '键盘不只是输入工具，它可以是一场游戏。',
    '每一次敲击都应该有回声。',
  ];
  for (const s of sentences) {
    for (let i = 0; i < s.length; i++) {
      // 第 8 个字故意打错再退回（制造一次修正）
      if (i === 8 || i === 12) {
        events.push({ t, key: 'x' }); t += 0.14;
        events.push({ t, key: 'Backspace' }); t += 0.16;
      }
      events.push({ t, key: s[i] });
      t += 0.10 + (i % 5 === 0 ? 0.12 : 0);   // 轻微节奏变化
    }
    events.push({ t, key: 'Enter' }); t += 0.8;
  }
  return events;
}

if (SHOT !== null) {
  const script = buildScript();
  for (const ev of script) {
    if (ev.t <= SHOT) press(ev.key, ev.t);
  }
  // 用固定时间渲染，避免动画相位不可复现
  resize();
  draw(SHOT, 0.016);
  setTimeout(() => {
    draw(SHOT, 0.016);
    document.getElementById('dump').textContent = canvas.toDataURL('image/png');
  }, 60);
} else {
  resize();
  requestAnimationFrame(loop);
}

window.addEventListener('resize', () => { resize(); });
