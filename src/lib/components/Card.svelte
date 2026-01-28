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
    background: #4C566A;
    border-radius: 16px;
    padding: 2rem;
    min-height: 280px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    transition: box-shadow 0.3s ease, transform 0.3s ease;
    cursor: default;
    border: 1px solid #5E81AC;
  }

  .card:hover {
    box-shadow: 0 8px 32px rgba(136, 192, 208, 0.2);
  }

  .copy-btn {
    position: absolute;
    bottom: 16px;
    right: 16px;
    padding: 8px 16px;
    font-size: 0.875rem;
    border-radius: 8px;
    background: #434C5E;
    border: 1px solid #5E81AC;
    color: #ECEFF4;
    cursor: pointer;
    transition: all 0.2s;
  }

  .copy-btn:hover {
    background: #5E81AC;
    color: #ECEFF4;
  }

  :global(.prose pre) {
    background: #2E3440;
    color: #D8DEE9;
    padding: 1rem;
    border-radius: 8px;
    overflow-x: auto;
    margin: 1rem 0;
    border: 1px solid #434C5E;
  }

  :global(.prose code) {
    font-family: 'Fira Code', 'Consolas', monospace;
  }

  :global(.prose h1) {
    font-size: 1.5rem;
    font-weight: 600;
    margin-bottom: 0.75rem;
    color: #ECEFF4;
  }

  :global(.prose h2) {
    font-size: 1.25rem;
    font-weight: 600;
    margin-top: 1.25rem;
    margin-bottom: 0.5rem;
    color: #E5E9F0;
  }

  :global(.prose p) {
    color: #D8DEE9;
    line-height: 1.6;
  }

  :global(.prose ul) {
    padding-left: 1.25rem;
    color: #D8DEE9;
  }

  :global(.prose li) {
    margin: 0.25rem 0;
  }

  :global(.prose blockquote) {
    background: #3B4252;
    border-left: 4px solid #88C0D0;
    padding: 1rem;
    border-radius: 0 8px 8px 0;
    margin: 1rem 0;
    color: #D8DEE9;
  }

  :global(.prose strong) {
    color: #ECEFF4;
  }
</style>