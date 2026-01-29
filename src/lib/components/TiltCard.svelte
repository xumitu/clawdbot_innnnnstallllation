<script lang="ts">
  import { onMount } from 'svelte';
  import { calculateTilt } from '$lib/utils/tilt-calculator';

  let { children, href = '#', cardType = 'default' } = $props<{
    children?: import('svelte').Snippet;
    href?: string;
    cardType?: 'default' | 'orange';
  }>();

  let element: HTMLElement;
  let rotateX = $state(0);
  let rotateY = $state(0);

  function onMouseMove(e: MouseEvent) {
    if (!element) return;
    const { rotateX: x, rotateY: y } = calculateTilt(e, element);
    rotateX = x;
    rotateY = y;
  }

  function onMouseLeave() {
    rotateX = 0;
    rotateY = 0;
  }

  function onClick(e: MouseEvent) {
    if (href && href !== '#') {
      e.preventDefault();
      if (href.includes('bilibili.com')) {
        window.open(href, '_blank');
      } else {
        const link = document.createElement('a');
        link.href = href;
        link.download = '';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      }
    }
  }
</script>

<div
  bind:this={element}
  onmousemove={onMouseMove}
  onmouseleave={onMouseLeave}
  onclick={onClick}
  class="tilt-card"
  class:orange={cardType === 'orange'}
  style:transform="perspective(1000px) rotateX({rotateX}deg) rotateY({rotateY}deg)"
  role="button"
  tabindex="0"
>
  {@render children?.()}
</div>

<style>
  .tilt-card {
    display: block;
    position: relative;
    background: linear-gradient(135deg, rgba(136, 192, 208, 0.15) 0%, rgba(129, 161, 193, 0.2) 100%);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    border-radius: 16px;
    border: 1px solid rgba(136, 192, 208, 0.3);
    padding: 2rem;
    text-decoration: none;
    cursor: pointer;
    transition: box-shadow 0.3s ease, border-color 0.3s ease;
    overflow: hidden;
  }

  .tilt-card::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(
      135deg,
      rgba(136, 192, 208, 0.1) 0%,
      transparent 50%,
      rgba(129, 161, 193, 0.1) 100%
    );
    pointer-events: none;
  }

  .tilt-card:hover {
    border-color: rgba(136, 192, 208, 0.6);
    box-shadow: 0 8px 32px rgba(136, 192, 208, 0.3);
  }

  .tilt-card.orange {
    background: linear-gradient(135deg, rgba(208, 135, 112, 0.15) 0%, rgba(191, 97, 106, 0.2) 100%);
    border: 1px solid rgba(208, 135, 112, 0.3);
  }

  .tilt-card.orange::before {
    background: linear-gradient(
      135deg,
      rgba(208, 135, 112, 0.1) 0%,
      transparent 50%,
      rgba(191, 97, 106, 0.1) 100%
    );
  }

  .tilt-card.orange:hover {
    border-color: rgba(208, 135, 112, 0.6);
    box-shadow: 0 8px 32px rgba(208, 135, 112, 0.3);
  }
</style>