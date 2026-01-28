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
  let isExpanded = $state(false);
  let isAnimating = $state(false);

  onMount(async () => {
    if (markdown) {
      const raw = await marked.parse(markdown);
      content = DOMPurify.sanitize(raw as string);
    }
  });

  function onMouseMove(e: MouseEvent) {
    if (!element || isExpanded) return;
    const { rotateX: x, rotateY: y } = calculateTilt(e, element);
    rotateX = x;
    rotateY = y;
  }

  function onMouseLeave() {
    rotateX = 0;
    rotateY = 0;
  }

  function toggleExpand() {
    if (isAnimating) return;
    isAnimating = true;
    isExpanded = !isExpanded;
    if (!isExpanded) {
      setTimeout(() => {
        rotateX = 0;
        rotateY = 0;
        isAnimating = false;
      }, 300);
    } else {
      isAnimating = false;
    }
  }

  function handleClose() {
    if (isAnimating) return;
    isAnimating = true;
    isExpanded = false;
    setTimeout(() => {
      rotateX = 0;
      rotateY = 0;
      isAnimating = false;
    }, 300);
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

{#if isExpanded}
  <div 
    class="expanded-overlay"
    role="dialog"
    aria-modal="true"
  >
    <div 
      class="expanded-card"
      class:bounce-in={isExpanded}
      class:bounce-out={!isExpanded}
    >
      <button 
        class="close-btn" 
        onclick={handleClose}
        aria-label="关闭"
      >
        ✕
      </button>
      <div class="expanded-scroll">
        <div class="content prose prose-slate max-w-none">
          {@html content}
        </div>
        {#if card.copyable}
          <div class="copy-area">
            <button onclick={copyCode} class="copy-btn">
              {copied ? '已复制!' : '复制命令'}
            </button>
          </div>
        {/if}
      </div>
    </div>
  </div>
{:else}
  <div 
    bind:this={element}
    onmousemove={onMouseMove}
    onmouseleave={onMouseLeave}
    onclick={toggleExpand}
    class="card"
    class:bounce-out={!isExpanded}
    style:transform="perspective(1000px) rotateX({rotateX}deg) rotateY({rotateY}deg)"
    role="button"
    tabindex="0"
    onkeydown={(e) => e.key === 'Enter' && toggleExpand()}
  >
    <div class="card-content">
      <div class="icon">{card.icon}</div>
      <h3 class="card-title">#{card.id}</h3>
    </div>
  </div>
{/if}

<style>
  .card {
    position: relative;
    background: #D8DEE9;
    border-radius: 16px;
    padding: 0;
    aspect-ratio: 1;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
    transition: box-shadow 0.3s ease, transform 0.3s ease;
    cursor: pointer;
    overflow: hidden;
    animation: cardAppear 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
  }

  .card:hover {
    box-shadow: 0 8px 32px rgba(136, 192, 208, 0.4);
  }

  .card-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    padding: 1.5rem;
    text-align: center;
  }

  .icon {
    font-size: 2.5rem;
    margin-bottom: 1rem;
  }

  .card-title {
    font-size: 1rem;
    font-weight: 600;
    color: #2E3440;
  }

  .expanded-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(46, 52, 64, 0.3);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    animation: fadeIn 0.2s ease forwards;
  }

  .expanded-card {
    width: 65%;
    max-width: 900px;
    height: 75vh;
    background: #4C566A;
    border-radius: 24px;
    overflow: hidden;
    box-shadow: 0 25px 80px rgba(0, 0, 0, 0.5);
    border: 1px solid rgba(136, 192, 208, 0.3);
    display: flex;
    flex-direction: column;
    animation: expandCard 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
  }

  .expanded-scroll {
    flex: 1;
    overflow-y: auto;
    padding: 3rem 2.5rem 2rem;
  }

  .close-btn {
    position: absolute;
    top: 1rem;
    right: 1rem;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: rgba(46, 52, 64, 0.9);
    border: 1px solid rgba(136, 192, 208, 0.4);
    color: #ECEFF4;
    font-size: 1.3rem;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
    z-index: 10;
  }

  .close-btn:hover {
    background: #BF616A;
    border-color: #BF616A;
    transform: scale(1.1);
  }

  .copy-area {
    margin-top: 2rem;
    display: flex;
    justify-content: center;
  }

  .copy-btn {
    padding: 12px 28px;
    font-size: 1rem;
    border-radius: 10px;
    background: rgba(94, 129, 172, 0.6);
    border: 1px solid rgba(136, 192, 208, 0.4);
    color: #ECEFF4;
    cursor: pointer;
    transition: all 0.2s;
  }

  .copy-btn:hover {
    background: rgba(136, 192, 208, 0.4);
    transform: scale(1.05);
  }

  :global(.prose pre) {
    background: #2E3440;
    color: #D8DEE9;
    padding: 1.25rem;
    border-radius: 12px;
    overflow-x: auto;
    margin: 1.25rem 0;
    border: 1px solid rgba(136, 192, 208, 0.2);
  }

  :global(.prose code) {
    font-family: 'Fira Code', 'Consolas', monospace;
  }

  :global(.prose h1) {
    font-size: 1.75rem;
    font-weight: 700;
    margin-bottom: 1rem;
    color: #ECEFF4;
  }

  :global(.prose h2) {
    font-size: 1.35rem;
    font-weight: 600;
    margin-top: 1.5rem;
    margin-bottom: 0.75rem;
    color: #E5E9F0;
  }

  :global(.prose p) {
    color: #D8DEE9;
    line-height: 1.7;
    margin: 0.75rem 0;
  }

  :global(.prose ul) {
    padding-left: 1.5rem;
    color: #D8DEE9;
  }

  :global(.prose li) {
    margin: 0.5rem 0;
  }

  :global(.prose blockquote) {
    background: rgba(46, 52, 64, 0.6);
    border-left: 4px solid #88C0D0;
    padding: 1rem 1.25rem;
    border-radius: 0 12px 12px 0;
    margin: 1.25rem 0;
    color: #D8DEE9;
  }

  :global(.prose strong) {
    color: #ECEFF4;
  }

  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  @keyframes cardAppear {
    from {
      opacity: 0;
      transform: scale(0.8) translateY(20px);
    }
    to {
      opacity: 1;
      transform: scale(1) translateY(0);
    }
  }

  @keyframes expandCard {
    from {
      opacity: 0;
      transform: scale(0.85) translateY(20px);
    }
    to {
      opacity: 1;
      transform: scale(1) translateY(0);
    }
  }

  .bounce-out {
    animation: collapseCard 0.3s cubic-bezier(0.36, 0, 0.66, -0.56) forwards !important;
  }

  .bounce-in {
    animation: expandCard 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) forwards !important;
  }

  @keyframes collapseCard {
    from {
      opacity: 1;
      transform: scale(1);
    }
    to {
      opacity: 0;
      transform: scale(0.85);
    }
  }

  @keyframes scaleUp {
    0% { transform: scale(1); }
    50% { transform: scale(1.08); }
    100% { transform: scale(1); }
  }
</style>