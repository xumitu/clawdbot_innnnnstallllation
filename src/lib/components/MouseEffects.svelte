<script lang="ts">
  import { onMount, onDestroy } from 'svelte';
  import { browser } from '$app/environment';

  let canvas: HTMLCanvasElement;
  let ctx: CanvasRenderingContext2D | null = null;
  let trail: Array<{ x: number; y: number; life: number }> = [];
  let mouseX = 0;
  let mouseY = 0;
  let animationId: number;
  let isVisible = true;

  const TRAIL_LENGTH = 40;
  const TRAIL_WIDTH = 60;

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
    
    trail.unshift({ x: mouseX, y: mouseY, life: 1 });
    if (trail.length > TRAIL_LENGTH) {
      trail.pop();
    }
  }

  function animate() {
    if (!ctx || !isVisible) return;

    ctx!.clearRect(0, 0, canvas.width, canvas.height);

    trail = trail.filter(t => t.life > 0);
    trail.forEach(t => t.life -= 0.025);

    if (trail.length > 1) {
      ctx!.globalCompositeOperation = 'lighter';
      
      for (let i = 1; i < trail.length; i++) {
        const current = trail[i];
        const previous = trail[i - 1];
        const life = current.life * (1 - i / trail.length);
        
        if (life <= 0) continue;

        ctx!.globalAlpha = life * 0.4;
        
        const gradient = ctx!.createLinearGradient(
          previous.x, previous.y,
          current.x, current.y
        );
        gradient.addColorStop(0, 'rgba(255, 230, 150, 0)');
        gradient.addColorStop(0.5, 'rgba(255, 220, 100, 0.6)');
        gradient.addColorStop(1, 'rgba(255, 200, 50, 0.8)');
        
        ctx!.strokeStyle = gradient;
        ctx!.lineWidth = TRAIL_WIDTH * life;
        ctx!.lineCap = 'round';
        ctx!.lineJoin = 'round';
        
        ctx!.beginPath();
        ctx!.moveTo(previous.x, previous.y);
        ctx!.lineTo(current.x, current.y);
        ctx!.stroke();
        
        ctx!.shadowBlur = 30;
        ctx!.shadowColor = 'rgba(255, 220, 100, 0.8)';
      }

      ctx!.globalCompositeOperation = 'source-over';
    }

    ctx!.globalAlpha = 1;
    ctx!.shadowBlur = 0;

    animationId = requestAnimationFrame(animate);
  }
</script>

<div class="cursor-glow" style="left: {mouseX}px; top: {mouseY}px;"></div>

<canvas
  bind:this={canvas}
  class="fixed top-0 left-0 w-full h-full pointer-events-none z-50"
></canvas>

<style>
  .cursor-glow {
    position: fixed;
    width: 20px;
    height: 20px;
    pointer-events: none;
    z-index: 9999;
    transform: translate(-50%, -50%);
    background: radial-gradient(
      circle,
      rgba(255, 230, 150, 0.9) 0%,
      rgba(255, 200, 100, 0.6) 40%,
      transparent 70%
    );
    filter: blur(4px);
    animation: glowPulse 1.5s ease-in-out infinite;
  }

  @keyframes glowPulse {
    0%, 100% { 
      transform: translate(-50%, -50%) scale(1);
      opacity: 0.9;
    }
    50% { 
      transform: translate(-50%, -50%) scale(1.3);
      opacity: 1;
    }
  }
</style>