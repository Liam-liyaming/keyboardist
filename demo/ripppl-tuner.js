/* 冲击波调参器：把 ripppl 的参数暴露成滑杆，实时看效果 */

const app = document.getElementById('app');

const DEFAULTS = {
  amplitude: 6.0,
  frequency: 0.020,
  speed: 2600,   // 新语义：初始速度，波前最终停在 speed/2.4 像素处
  damping: 0.02,
  decay: 1.0,
  duration: 2200,
  chromatic: true,
  chromaticIntensity: 0.5,
  shimmer: 'oklch(0.62 0.22 295)',
  shimmerGlowColor: 'oklch(0.65 0.20 265)',
  shimmerWidth: 1.4,
  shimmerDuration: 1400,
};

const handle = window.Ripppl.attachRipple(app, { scope: app, ...DEFAULTS });
handle.prefetchCapture();

const SLIDERS = ['amplitude', 'frequency', 'speed', 'damping', 'decay', 'duration', 'chromaticIntensity'];

SLIDERS.forEach((key) => {
  const input = document.getElementById(key);
  const label = document.getElementById('v-' + key);
  input.value = DEFAULTS[key];
  label.textContent = DEFAULTS[key];
  input.addEventListener('input', () => {
    const value = parseFloat(input.value);
    label.textContent = value;
    handle.update({ [key]: value });
  });
});

function fire() {
  handle.trigger({ x: 0.5, y: 1.0 });
}

document.getElementById('fire').addEventListener('click', fire);
window.addEventListener('keydown', (e) => {
  if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); fire(); }
});

document.getElementById('copy').addEventListener('click', async () => {
  const out = {};
  SLIDERS.forEach((k) => (out[k] = parseFloat(document.getElementById(k).value)));
  out.chromatic = true;
  const text = JSON.stringify(out, null, 2);
  try { await navigator.clipboard.writeText(text); } catch {}
  const btn = document.getElementById('copy');
  btn.textContent = '已复制';
  setTimeout(() => (btn.textContent = '复制当前参数'), 1200);
  console.log(text);
});

// 自检：触发后采样画布，确认真的在渲染
window.__audit = () => {
  const c = document.querySelector('canvas');
  if (!c) return 'no canvas';
  const t = document.createElement('canvas');
  t.width = c.width; t.height = c.height;
  const g = t.getContext('2d');
  g.drawImage(c, 0, 0);
  const d = g.getImageData(0, 0, c.width, c.height).data;
  let nz = 0;
  for (let i = 0; i < d.length; i += 4) if (d[i] + d[i + 1] + d[i + 2] > 6) nz++;
  return nz;
};
