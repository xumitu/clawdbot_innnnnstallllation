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
  class="card relative bg-white rounded-2xl shadow-md p-6 transition-shadow duration-200 hover:shadow-xl"
  style:transform="perspective(1000px) rotateX({rotateX}deg) rotateY({rotateY}deg)"
>
  <div class="content prose prose-slate max-w-none">
    {@html content}
  </div>

  {#if card.copyable}
    <button
      onclick={copyCode}
      class="absolute top-4 right-4 px-3 py-1 text-xs rounded-lg bg-gray-100 hover:bg-md-red-100 transition-colors"
    >
      {copied ? '已复制!' : '复制'}
    </button>
  {/if}
</div>

<style>
  :global(.prose pre) {
    background: #1e1e1e;
    color: #d4d4d4;
    padding: 1rem;
    border-radius: 0.5rem;
    overflow-x: auto;
  }

  :global(.prose code) {
    font-family: 'Fira Code', monospace;
  }
</style>
