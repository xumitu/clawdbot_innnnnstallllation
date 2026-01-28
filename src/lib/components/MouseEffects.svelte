<script lang="ts">
  import { onMount, onDestroy } from 'svelte';
  import { browser } from '$app/environment';

  let canvas: HTMLCanvasElement;
  let ctx: CanvasRenderingContext2D | null = null;
  let particles: Array<{
    x: number;
    y: number;
    vx: number;
    vy: number;
    life: number;
    maxLife: number;
    size: number;
    hue: number;
  }> = [];
  let mouseX = 0;
  let mouseY = 0;
  let animationId: number;
  let isVisible = true;

  const PARTICLE_COUNT = 25;

  onMount(() => {
    if (!browser) return;

    ctx = canvas.getContext('2d');
    resize();
    window.addEventListener('resize', resize);
    window.addEventListener('mousemove', onMouseMove);
    document.addEventListener('visibilitychange', () => {
      isVisible = !document.hidden;
      if (isVisible) animate();
    });

    animate();
  });

  onDestroy(() => {
    if (browser) {
      window.removeEventListener('resize', resize);
      window.removeEventListener('mousemove', onMouseMove);
      if (animationId) cancelAnimationFrame(animationId);
    }
  });

  function resize() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  }

  function onMouseMove(e: MouseEvent) {
    mouseX = e.clientX;
    mouseY = e.clientY;
    
    if (particles.length < PARTICLE_COUNT) {
      for (let i = 0; i < 2; i++) {
        createParticle();
      }
    }
  }

  function createParticle() {
    if (!ctx) return;
    
    const hue = (Date.now() / 40) % 360;
    const angle = Math.random() * Math.PI * 2;
    const speed = 3 + Math.random() * 5;
    
    particles.push({
      x: mouseX,
      y: mouseY,
      vx: Math.cos(angle) * speed,
      vy: Math.sin(angle) * speed,
      life: 1,
      maxLife: 0.5 + Math.random() * 0.5,
      size: 5 + Math.random() * 5,
      hue: hue
    });
  }

  function animate() {
    if (!ctx || !isVisible) return;

    ctx!.clearRect(0, 0, canvas.width, canvas.height);
    
    particles = particles.filter(p => p.life > 0);
    
    particles.forEach((p) => {
      p.x += p.vx;
      p.y += p.vy;
      p.vx *= 0.94;
      p.vy *= 0.94;
      p.life -= 0.03;
      
      if (p.life > 0) {
        ctx!.globalAlpha = p.life * 0.8;
        ctx!.fillStyle = `hsl(${p.hue}, 100%, 60%)`;
        
        ctx!.beginPath();
        ctx!.arc(p.x, p.y, p.size * p.life, 0, Math.PI * 2);
        ctx!.fill();
        
        ctx!.shadowBlur = 20;
        ctx!.shadowColor = `hsl(${p.hue}, 100%, 60%)`;
      }
    });

    animationId = requestAnimationFrame(animate);
  }
</script>

<div class="cursor-follower" style="left: {mouseX}px; top: {mouseY}px;">⭐</div>

<canvas
  bind:this={canvas}
  class="fixed top-0 left-0 w-full h-full pointer-events-none z-50"
></canvas>

<style>
  .cursor-follower {
    position: fixed;
    font-size: 24px;
    pointer-events: none;
    z-index: 9999;
    transform: translate(-50%, -50%);
    filter: drop-shadow(0 0 10px rgba(255, 200, 0, 0.8));
    animation: pulse 1s ease-in-out infinite;
  }

  @keyframes pulse {
    0%, 100% { transform: translate(-50%, -50%) scale(1); }
    50% { transform: translate(-50%, -50%) scale(1.2); }
  }
</style>
