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
  }> = [];
  let mouseX = 0;
  let mouseY = 0;
  let animationId: number;
  let isVisible = true;

  const PARTICLE_COUNT = 15;
  const TRAIL_LENGTH = 8;

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
      for (let i = 0; i < 3; i++) {
        createParticle();
      }
    }
  }

  function createParticle() {
    if (!ctx) return;
    
    const hue = (Date.now() / 50) % 360;
    particles.push({
      x: mouseX,
      y: mouseY,
      vx: (Math.random() - 0.5) * 8,
      vy: (Math.random() - 0.5) * 8,
      life: 1,
      maxLife: 0.8 + Math.random() * 0.4,
      size: 3 + Math.random() * 4
    });
  }

  function animate() {
    if (!ctx || !isVisible) return;

    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    particles = particles.filter(p => p.life > 0);
    
    particles.forEach((p, index) => {
      p.x += p.vx;
      p.y += p.vy;
      p.vx *= 0.95;
      p.vy *= 0.95;
      p.life -= 0.02;
      
      if (p.life > 0) {
        const hue = (Date.now() / 20 + index * 20) % 360;
        ctx!.globalAlpha = p.life * 0.8;
        ctx!.fillStyle = `hsl(${hue}, 100%, 60%)`;
        
        ctx!.beginPath();
        ctx!.arc(p.x, p.y, p.size * p.life, 0, Math.PI * 2);
        ctx!.fill();
        
        ctx!.shadowBlur = 10;
        ctx!.shadowColor = `hsl(${hue}, 100%, 60%)`;
      }
    });

    animationId = requestAnimationFrame(animate);
  }
</script>

<canvas
  bind:this={canvas}
  class="fixed top-0 left-0 w-full h-full pointer-events-none z-50"
></canvas>
