<script lang="ts">
  import { marked } from 'marked';
  import DOMPurify from 'dompurify';
  import { onMount } from 'svelte';
  import { calculateTilt } from '$lib/utils/tilt-calculator';
  import type { Card as CardType } from '$lib/types';

  let { card, markdown = '' } = $props<{
    card: CardType;
    markdown?: string;
  }>();

  let content = $state('');
  let copied = $state(false);
  let element: HTMLElement;
  let rotateX = $state(0);
  let rotateY = $state(0);

  onMount(async () => {
    if (markdown) {
      const raw = await marked.parse(markdown);
      content = DOMPurify.sanitize(raw as string);
    }
  });

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

  async function copyCode() {
    if (!card.copyable) return;
    
    const codeMatch = markdown?.match(/```bash\n([\s\S]*?)```/);
    const text = codeMatch ? codeMatch[1].trim() : markdown || '';
    
    await navigator.clipboard.writeText(text);
    copied = true;
    setTimeout(() => copied = false, 2000);
  }
</script>

<div 
  bind:this={element}
  onmousemove={onMouseMove}
  onmouseleave={onMouseLeave}
  class="card"
  style:transform="perspective(1000px) rotateX({rotateX}deg) rotateY({rotateY}deg)"
>
  <div class="content prose prose-slate max-w-none">
    {@html content}
  </div>

  {#if card.copyable}
    <button
      onclick={copyCode}
      class="copy-btn"
    >
      {copied ? '已复制!' : '复制'}
    </button>
  {/if}
</div>

<style>
  .card {
    position: relative;
    background: white;
    border-radius: 16px;
    padding: 2rem;
    min-height: 280px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    transition: box-shadow 0.3s ease, transform 0.3s ease;
    cursor: default;
  }

  .card:hover {
    box-shadow: 0 8px 32px rgba(244, 67, 54, 0.15);
  }

  .copy-btn {
    position: absolute;
    bottom: 16px;
    right: 16px;
    padding: 8px 16px;
    font-size: 0.875rem;
    border-radius: 8px;
    background: #f5f5f5;
    border: none;
    cursor: pointer;
    transition: all 0.2s;
  }

  .copy-btn:hover {
    background: #f44336;
    color: white;
  }

  :global(.prose pre) {
    background: #1e1e1e;
    color: #d4d4d4;
    padding: 1rem;
    border-radius: 8px;
    overflow-x: auto;
    margin: 1rem 0;
  }

  :global(.prose code) {
    font-family: 'Fira Code', 'Consolas', monospace;
  }

  :global(.prose h1) {
    font-size: 1.5rem;
    font-weight: 600;
    margin-bottom: 0.75rem;
    color: #1a1a1a;
  }

  :global(.prose h2) {
    font-size: 1.25rem;
    font-weight: 600;
    margin-top: 1.25rem;
    margin-bottom: 0.5rem;
    color: #333;
  }

  :global(.prose p) {
    color: #555;
    line-height: 1.6;
  }

  :global(.prose ul) {
    padding-left: 1.25rem;
    color: #555;
  }

  :global(.prose li) {
    margin: 0.25rem 0;
  }

  :global(.prose blockquote) {
    background: #fff3f3;
    border-left: 4px solid #f44336;
    padding: 1rem;
    border-radius: 0 8px 8px 0;
    margin: 1rem 0;
    color: #666;
  }
</style>
