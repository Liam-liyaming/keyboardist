/*
 * 冲击波光环 · 完整六层（WebGL2）
 *
 * 按 RedSkill《冲击波光环》第 013 期的规格实现：
 *   1 页面快照  → 自己画的 2D canvas（同源，可上传为纹理）
 *   2 透镜扭曲  → push = 7 * 2.33 * z * exp(-z²)，z = x * 0.75
 *   3 通道分离  → 红 1.08 / 蓝 0.92
 *   4 四环      → x = (d - R)/W，第 i 环中心 i-1.5，高斯 σ=0.8
 *   5 边缘折射  → 最后 56px 淡出镜头位移，60px 内做 bevel
 *   6 边线反光  → 暂缺（需要第二张「只有线条」的快照）
 */

const canvas = document.getElementById('gl');
const gl = canvas.getContext('webgl2', { preserveDrawingBuffer: true, antialias: false });
const hud = document.getElementById('hud');

const PALETTES = {
  aurora: ['#508CFF', '#A06EFF', '#FF6EB4', '#FFBE8C'],
  halo:   ['#FF963C', '#FFBE46', '#FFE178', '#FFF5D2'],
  frost:  ['#50DCAF', '#46C3E1', '#B4F096', '#EBFFF5'],
  spark:  ['#8C64FF', '#C882FF', '#FFC86E', '#FFEBAA'],
};

const params = new URLSearchParams(location.search);
const SHOT = params.has('shot') ? parseFloat(params.get('shot')) : null;
const paletteKey = params.get('palette') || 'aurora';

let W = 0, H = 0, DPR = 1;
let scene = null;
let texture = null;
let program = null;
let uniforms = {};
const t0 = performance.now();

/* ---------------- 1. 页面快照 ---------------- */

function buildScene() {
  const c = document.createElement('canvas');
  c.width = Math.round(W * DPR);
  c.height = Math.round(H * DPR);
  const g = c.getContext('2d');
  g.scale(DPR, DPR);

  g.fillStyle = '#0b0f15';
  g.fillRect(0, 0, W, H);

  const pad = Math.min(96, W * 0.08);
  g.fillStyle = 'rgba(240,244,250,0.95)';
  g.font = '600 44px -apple-system, "PingFang SC", sans-serif';
  g.fillText('每日之歌', pad, pad + 44);

  g.font = '15px -apple-system, sans-serif';
  g.fillStyle = 'rgba(138,148,166,0.9)';
  g.fillText('2026-11-23 · BPM 82 · 88 秒', pad, pad + 78);

  const widths = [0.72, 0.86, 0.64, 0.78, 0.5, 0.83, 0.69, 0.74];
  let y = pad + 130;
  g.font = '16px -apple-system, "PingFang SC", sans-serif';
  for (const w of widths) {
    g.fillStyle = 'rgba(232,238,248,0.20)';
    g.fillRect(pad, y, (W - pad * 2) * w, 10);
    y += 26;
  }

  y += 24;
  const panelW = (W - pad * 2 - 24) / 2;
  for (let i = 0; i < 2; i++) {
    g.fillStyle = 'rgba(94,234,232,0.05)';
    g.strokeStyle = 'rgba(94,234,232,0.20)';
    g.lineWidth = 1;
    g.beginPath();
    if (g.roundRect) g.roundRect(pad + i * (panelW + 24), y, panelW, 120, 14);
    else g.rect(pad + i * (panelW + 24), y, panelW, 120);
    g.fill();
    g.stroke();
    g.fillStyle = 'rgba(94,234,232,0.7)';
    g.font = '600 13px -apple-system, sans-serif';
    g.fillText(i === 0 ? '字数 179' : '击键 1012', pad + 20 + i * (panelW + 24), y + 34);
  }

  return c;
}

/* ---------------- 着色器 ---------------- */

const VERT = `#version 300 es
in vec2 a_pos;
void main() { gl_Position = vec4(a_pos, 0.0, 1.0); }`;

const FRAG = `#version 300 es
precision highp float;
uniform sampler2D u_tex;
uniform vec2 u_res;
uniform float u_t;
uniform vec3 u_c0, u_c1, u_c2, u_c3;
uniform float u_startR, u_growth, u_ringW;
uniform float u_k;
uniform float u_reduce;   // 1 = prefers-reduced-motion
uniform vec2 u_center;
out vec4 outColor;

float ease(float t) { return (1.0 - pow(2.0, -u_k * t)) / (1.0 - pow(2.0, -u_k)); }

void main() {
  vec2 px = gl_FragCoord.xy;
  vec2 uv = px / u_res;
  vec2 p = (px - u_center);
  float d = length(p);

  float t = u_t;
  float R = u_startR + u_growth * ease(t);
  float strength = min(1.0, t / 0.03) * (1.0 - pow(t, 2.2));

  float x = (d - R) / u_ringW;

  // ---- 4 四环：高斯权重 ----
  float w0 = exp(-pow((x + 1.5) / 0.8, 2.0));
  float w1 = exp(-pow((x + 0.5) / 0.8, 2.0));
  float w2 = exp(-pow((x - 0.5) / 0.8, 2.0));
  float w3 = exp(-pow((x - 1.5) / 0.8, 2.0));
  float ws = w0 + w1 + w2 + w3 + 1e-4;
  vec3 ring = (u_c0 * w0 + u_c1 * w1 + u_c2 * w2 + u_c3 * w3) / ws;
  float alpha = strength * exp(-1.1 * pow(x / 2.0, 2.0)) * 0.45 * (1.0 - 0.35 * u_reduce);

  // ---- 2 透镜：整片一起弯，不逐环 ----
  float z = x * 0.75;
  float push = 14.0 * 2.33 * z * exp(-z * z) * strength * (1.0 - 0.9 * u_reduce);
  vec2 dir = d > 0.5 ? normalize(p) : vec2(0.0);

  // ---- 5 边缘：最后 56px 关掉镜头，60px 内做 bevel ----
  float edge = min(min(px.x, u_res.x - px.x), min(px.y, u_res.y - px.y));
  float lensGain = smoothstep(0.0, 56.0, edge);
  float bevel = 22.0 * pow(1.0 - clamp(edge / 60.0, 0.0, 1.0), 2.0) * strength;

  vec2 offset = (dir * push * lensGain - dir * bevel) / u_res;
  vec2 suv = uv - offset;

  // ---- 3 通道分离：红 1.08 / 蓝 0.92 ----
  vec3 col;
  float split = mix(1.08, 1.0, u_reduce);
  col.r = texture(u_tex, uv - offset * split).r;
  col.g = texture(u_tex, suv).g;
  col.b = texture(u_tex, uv - offset * (2.0 - split)).b;

  // ---- 深色模式：加光 ----
  vec3 lit = 1.0 - (1.0 - col) * (1.0 - ring * alpha * 1.5);
  outColor = vec4(lit, 1.0);
}`;

function compile(type, src) {
  const s = gl.createShader(type);
  gl.shaderSource(s, src);
  gl.compileShader(s);
  if (!gl.getShaderParameter(s, gl.COMPILE_STATUS)) {
    throw new Error(gl.getShaderInfoLog(s));
  }
  return s;
}

function initGL() {
  program = gl.createProgram();
  gl.attachShader(program, compile(gl.VERTEX_SHADER, VERT));
  gl.attachShader(program, compile(gl.FRAGMENT_SHADER, FRAG));
  gl.linkProgram(program);
  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    throw new Error(gl.getProgramInfoLog(program));
  }
  gl.useProgram(program);

  const buffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 3, -1, -1, 3]), gl.STATIC_DRAW);
  const loc = gl.getAttribLocation(program, 'a_pos');
  gl.enableVertexAttribArray(loc);
  gl.vertexAttribPointer(loc, 2, gl.FLOAT, false, 0, 0);

  ['u_tex', 'u_res', 'u_t', 'u_c0', 'u_c1', 'u_c2', 'u_c3',
   'u_startR', 'u_growth', 'u_ringW', 'u_center', 'u_k', 'u_reduce'].forEach((name) => {
    uniforms[name] = gl.getUniformLocation(program, name);
  });

  texture = gl.createTexture();
  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
  gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
}

function uploadScene() {
  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
  gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, scene);
}

/* ---------------- 渲染 ---------------- */

function hexToVec3(hex) {
  return [parseInt(hex.slice(1, 3), 16) / 255,
          parseInt(hex.slice(3, 5), 16) / 255,
          parseInt(hex.slice(5, 7), 16) / 255];
}

function render(t) {
  const colors = PALETTES[paletteKey] || PALETTES.aurora;
  gl.viewport(0, 0, canvas.width, canvas.height);
  gl.uniform2f(uniforms.u_res, canvas.width, canvas.height);
  gl.uniform1f(uniforms.u_t, t);
  gl.uniform3fv(uniforms.u_c0, hexToVec3(colors[0]));
  gl.uniform3fv(uniforms.u_c1, hexToVec3(colors[1]));
  gl.uniform3fv(uniforms.u_c2, hexToVec3(colors[2]));
  gl.uniform3fv(uniforms.u_c3, hexToVec3(colors[3]));
  // 圆心在页面下方约一个屏高处，起点半径刚好在底边
  gl.uniform2f(uniforms.u_center, canvas.width * 0.82, -canvas.height * 0.97);
  gl.uniform1f(uniforms.u_startR, canvas.height * 0.97);
  gl.uniform1f(uniforms.u_growth, canvas.height * 1.28);
  gl.uniform1f(uniforms.u_ringW, canvas.height * 0.115);
  gl.uniform1f(uniforms.u_k, 4.0);
  gl.uniform1f(uniforms.u_reduce, reduceMotion ? 1 : 0);   // 9 = skill 原版（200ms 走完 79%），演示用 4
  gl.activeTexture(gl.TEXTURE0);
  gl.bindTexture(gl.TEXTURE_2D, texture);
  gl.uniform1i(uniforms.u_tex, 0);
  gl.drawArrays(gl.TRIANGLES, 0, 3);
}

/* ---------------- 主循环 ---------------- */

const DURATION = 1600;    // 演示放慢；skill 原版是 1000ms
const COOLDOWN = 150;     // 跑完之后再留一点，防止按住回车的连发
const reduceMotion = matchMedia('(prefers-reduced-motion: reduce)').matches;

let startAt = -1;
let endAt = -1;
let composing = false;    // 中文输入法组合态：回车是「上屏」，不该触发

function progress(now) {
  if (startAt < 0) return 1;
  return Math.min(1, (now - startAt) / DURATION);
}

/* 触发闸门：返回 true 表示这次真的放了 */
function tryTrigger(source) {
  const now = performance.now();

  if (document.hidden) { note('跳过：页面不可见'); return false; }
  if (composing) { note('跳过：输入法正在组合'); return false; }
  if (progress(now) < 1) { note('跳过：上一次还没跑完'); return false; }
  if (now < endAt + COOLDOWN) { note('跳过：冷却中'); return false; }

  startAt = now;
  endAt = now + DURATION;
  note('触发 · ' + source);
  return true;
}

window.__halo = { progress: () => progress(performance.now()), trigger: tryTrigger };

function note(text) {
  hud.dataset.note = text;
}

function loop() {
  const now = performance.now();
  const t = progress(now);
  render(t);

  const tail = now < endAt + COOLDOWN && t >= 1 ? ' · 冷却中' : (t >= 1 ? ' · 回车可重放' : '');
  hud.textContent = `t=${t.toFixed(2)} · ${paletteKey}${reduceMotion ? ' · 减弱动态' : ''}${tail}`;
  requestAnimationFrame(loop);
}

/* ---------------- 触发条件 ---------------- */

window.addEventListener('keydown', (e) => {
  if (e.isComposing || composing) return;          // 输入法回车＝上屏，放行
  if (e.repeat) return;                            // 按住不放不连发
  if (e.metaKey || e.ctrlKey || e.altKey) return;  // ⌘↩ 这类组合键交给页面自己处理
  if (e.key === 'Enter') {
    e.preventDefault();
    tryTrigger('回车');
  }
});

window.addEventListener('compositionstart', () => { composing = true; });
window.addEventListener('compositionend', () => { composing = false; });


document.addEventListener('visibilitychange', () => {
  // 切走再回来不要继续跑一半：直接收干净
  if (document.hidden) { startAt = -1; endAt = -1; }
});

function resize() {
  DPR = Math.min(window.devicePixelRatio || 1, 2);
  W = window.innerWidth;
  H = window.innerHeight;
  canvas.width = Math.round(W * DPR);
  canvas.height = Math.round(H * DPR);
  canvas.style.width = W + 'px';
  canvas.style.height = H + 'px';
  scene = buildScene();
  if (texture) uploadScene();
}

/* ---------------- 启动 / 截图 ---------------- */

initGL();
resize();          // resize 内部会 buildScene + uploadScene

if (SHOT !== null) {
  // 静态帧：渲染一次，用 readPixels 取回（不依赖页面合成）
  render(Math.min(1, SHOT));
  const pixels = new Uint8Array(canvas.width * canvas.height * 4);
  gl.readPixels(0, 0, canvas.width, canvas.height, gl.RGBA, gl.UNSIGNED_BYTE, pixels);

  const out = document.createElement('canvas');
  out.width = canvas.width;
  out.height = canvas.height;
  const ctx2d = out.getContext('2d');
  const img = ctx2d.createImageData(canvas.width, canvas.height);
  for (let y = 0; y < canvas.height; y++) {
    const src = (canvas.height - 1 - y) * canvas.width * 4;
    const dst = y * canvas.width * 4;
    img.data.set(pixels.subarray(src, src + canvas.width * 4), dst);
  }
  ctx2d.putImageData(img, 0, 0);
  document.getElementById('dump').textContent = out.toDataURL('image/png');
  hud.textContent = `t=${SHOT} · ${paletteKey}`;
} else {
  window.addEventListener('resize', () => resize());   // 只重建资源，不重放
  loop();
  setTimeout(() => tryTrigger('首次进入'), 400);
}
