<script lang="ts">
  import { marked } from 'marked';
  import DOMPurify from 'dompurify';
  import { onMount } from 'svelte';
  import { calculateTilt } from '$lib/utils/tilt-calculator';
  import type { Card as CardType } from '$lib/types';

  let { card, markdown = '', expanded = false, onClose } = $props<{
    card: CardType;
    markdown?: string;
    expanded?: boolean;
    onClose?: () => void;
  }>();

  let content = $state('');
  let copied = $state(false);
  let element: HTMLElement;
  let rotateX = $state(0);
  let rotateY = $state(0);
  let isExpanded = $state(false);

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
    isExpanded = !isExpanded;
  }

  async function copyCode() {
    if (!card.copyable) return;
    
    const codeMatch = markdown?.match(/```bash\n([\s\S]*?)```/);
    const text = codeMatch ? codeMatch[1].trim() : markdown || '';
    
    await navigator.clipboard.writeText(text);
    copied = true;
    setTimeout(() => copied = false, 2000);
  }

  function handleClose() {
    isExpanded = false;
    onClose?.();
  }
</script>

{#if isExpanded}
  <div class="modal-overlay" onclick={handleClose}>
    <div class="modal-content" onclick={(e) => e.stopPropagation()}>
      <button class="close-btn" onclick={handleClose}>✕</button>
      <div class="modal-scroll">
        <div class="content prose prose-slate max-w-none">
          {@html content}
        </div>
        {#if card.copyable}
          <div class="modal-copy-area">
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
    style:transform="perspective(1000px) rotateX({rotateX}deg) rotateY({rotateY}deg)"
    role="button"
    tabindex="0"
    onkeydown={(e) => e.key === 'Enter' && toggleExpand()}
  >
    <div class="card-content">
      <div class="icon">{card.icon}</div>
      <h3 class="card-title">#{card.id}</h3>
      <span class="expand-hint">点击查看详情</span>
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
  }

  .card:hover {
    box-shadow: 0 8px 32px rgba(136, 192, 208, 0.3);
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
    font-size: 1.1rem;
    font-weight: 600;
    color: #2E3440;
    margin-bottom: 0.5rem;
  }

  .expand-hint {
    font-size: 0.75rem;
    color: #4C566A;
    opacity: 0.7;
  }

  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(46, 52, 64, 0.9);
    backdrop-filter: blur(10px);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    padding: 2rem;
    animation: fadeIn 0.2s ease;
  }

  .modal-content {
    background: #4C566A;
    border-radius: 20px;
    max-width: 800px;
    width: 100%;
    max-height: 80vh;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
    border: 1px solid rgba(136, 192, 208, 0.3);
    animation: scaleIn 0.3s ease;
  }

  .modal-scroll {
    flex: 1;
    overflow-y: auto;
    padding: 2rem;
  }

  .close-btn {
    position: absolute;
    top: 1rem;
    right: 1rem;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: rgba(46, 52, 64, 0.8);
    border: 1px solid rgba(136, 192, 208, 0.4);
    color: #ECEFF4;
    font-size: 1.2rem;
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
  }

  .modal-copy-area {
    margin-top: 2rem;
    display: flex;
    justify-content: center;
  }

  .copy-btn {
    padding: 12px 24px;
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

  @keyframes scaleIn {
    from { transform: scale(0.9); opacity: 0; }
    to { transform: scale(1); opacity: 1; }
  }
</style>