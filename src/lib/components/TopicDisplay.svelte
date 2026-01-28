<script lang="ts">
  import { marked } from 'marked';
  import DOMPurify from 'dompurify';
  import { onMount } from 'svelte';
  import type { Topic } from '$lib/types';
  import { locale } from '$lib/stores/language.store';

  let { topic, cardContents } = $props<{
    topic: Topic;
    cardContents: Map<string, string>;
  }>();

  let currentLang = $derived($locale);
  let title = $derived(topic.title[currentLang] || topic.title['en'] || '');
  let description = $derived(topic.description[currentLang] || topic.description['en'] || '');

  let htmlContents = $state<Map<string, string>>(new Map());
  let element: HTMLElement;
  let rotateX = $state(0);
  let rotateY = $state(0);
  let mouseX = $state(0);
  let mouseY = $state(0);

  onMount(async () => {
    const newContents = new Map<string, string>();
    for (const card of topic.cards) {
      const markdown = cardContents.get(`${topic.id}-${card.id}`) || '# ' + card.id;
      const raw = await marked.parse(markdown);
      newContents.set(card.id, DOMPurify.sanitize(raw as string));
    }
    htmlContents = newContents;
  });

  function onMouseMove(e: MouseEvent) {
    if (!element) return;
    
    const rect = element.getBoundingClientRect();
    mouseX = e.clientX - rect.left;
    mouseY = e.clientY - rect.top;

    const centerX = rect.width / 2;
    const centerY = rect.height / 2;
    
    const deltaX = (mouseX - centerX) / centerX;
    const deltaY = (mouseY - centerY) / centerY;
    
    rotateX = deltaY * 6;
    rotateY = -deltaX * 6;
  }

  function onMouseLeave() {
    rotateX = 0;
    rotateY = 0;
  }
</script>

<section 
  bind:this={element}
  onmousemove={onMouseMove}
  onmouseleave={onMouseLeave}
  class="topic-display"
  style:transform="perspective(1200px) rotateX({rotateX}deg) rotateY({rotateY}deg)"
>
  <div class="glow-edge glow-left" style:opacity={Math.min(mouseX / 100, 1)}></div>
  <div class="glow-edge glow-right" style:opacity={Math.min((element ? element.clientWidth - mouseX : 0) / 100, 1)}></div>
  <div class="glow-edge glow-top" style:opacity={Math.min(mouseY / 100, 1)}></div>
  <div class="glow-edge glow-bottom" style:opacity={Math.min((element ? element.clientHeight - mouseY : 0) / 100, 1)}></div>

  <div class="content-wrapper">
    <header class="topic-header">
      <h2 class="topic-title">{title}</h2>
      {#if description}
        <p class="topic-description">{description}</p>
      {/if}
    </header>

    <div class="cards-container">
      {#each topic.cards as card, i}
        {@const htmlContent = htmlContents.get(card.id) || '<span style="opacity:0.5">Loading...</span>'}
        <div 
          class="card-item"
          style="animation-delay: {i * 100}ms"
        >
          <div class="card-icon">{card.icon}</div>
          <div class="card-content prose">
            {@html htmlContent}
          </div>
        </div>
      {/each}
    </div>
  </div>
</section>

<style>
  .topic-display {
    position: relative;
    background: rgba(76, 86, 106, 0.5);
    backdrop-filter: blur(24px);
    -webkit-backdrop-filter: blur(24px);
    border-radius: 20px;
    border: 1px solid rgba(136, 192, 208, 0.25);
    padding: 0;
    overflow: hidden;
    transition: box-shadow 0.3s ease, border-color 0.3s ease;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
    animation: regionAppear 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
    opacity: 0;
    transform-origin: center center;
  }

  .topic-display:hover {
    border-color: rgba(136, 192, 208, 0.5);
    box-shadow: 0 12px 48px rgba(136, 192, 208, 0.2);
  }

  .glow-edge {
    position: absolute;
    pointer-events: none;
    transition: opacity 0.1s ease;
  }

  .glow-left {
    top: 0;
    left: 0;
    width: 4px;
    height: 100%;
    background: linear-gradient(180deg, rgba(136, 192, 208, 0.8), rgba(136, 192, 208, 0.3), rgba(136, 192, 208, 0.8));
  }

  .glow-right {
    top: 0;
    right: 0;
    width: 4px;
    height: 100%;
    background: linear-gradient(180deg, rgba(136, 192, 208, 0.8), rgba(136, 192, 208, 0.3), rgba(136, 192, 208, 0.8));
  }

  .glow-top {
    top: 0;
    left: 0;
    width: 100%;
    height: 4px;
    background: linear-gradient(90deg, rgba(136, 192, 208, 0.8), rgba(136, 192, 208, 0.3), rgba(136, 192, 208, 0.8));
  }

  .glow-bottom {
    bottom: 0;
    left: 0;
    width: 100%;
    height: 4px;
    background: linear-gradient(90deg, rgba(136, 192, 208, 0.8), rgba(136, 192, 208, 0.3), rgba(136, 192, 208, 0.8));
  }

  .content-wrapper {
    position: relative;
    z-index: 1;
    padding: 2rem;
  }

  .topic-header {
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid rgba(136, 192, 208, 0.2);
  }

  .topic-title {
    font-size: 1.4rem;
    font-weight: 700;
    color: #ECEFF4;
    margin-bottom: 0.3rem;
  }

  .topic-description {
    font-size: 0.85rem;
    color: #D8DEE9;
    opacity: 0.7;
  }

  .cards-container {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
  }

  .card-item {
    display: flex;
    gap: 1rem;
    padding: 1.25rem;
    background: rgba(46, 52, 64, 0.5);
    border-radius: 12px;
    border: 1px solid rgba(136, 192, 208, 0.15);
    animation: cardSlideIn 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
    opacity: 0;
    transform: translateX(-20px);
  }

  .card-item:hover {
    border-color: rgba(136, 192, 208, 0.35);
    background: rgba(46, 52, 64, 0.7);
  }

  .card-icon {
    font-size: 1.5rem;
    flex-shrink: 0;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(136, 192, 208, 0.2);
    border-radius: 10px;
  }

  .card-content {
    flex: 1;
    min-width: 0;
  }

  :global(.prose) {
    color: #D8DEE9;
    line-height: 1.6;
  }

  :global(.prose h1) {
    font-size: 1.2rem;
    font-weight: 600;
    color: #ECEFF4;
    margin-bottom: 0.5rem;
  }

  :global(.prose h2) {
    font-size: 1rem;
    font-weight: 600;
    color: #E5E9F0;
    margin: 0.75rem 0 0.25rem;
  }

  :global(.prose p) {
    margin: 0.4rem 0;
  }

  :global(.prose code) {
    font-family: 'Fira Code', 'Consolas', monospace;
    background: rgba(136, 192, 208, 0.15);
    padding: 0.15rem 0.4rem;
    border-radius: 4px;
    font-size: 0.85em;
  }

  :global(.prose pre) {
    background: #2E3440;
    color: #D8DEE9;
    padding: 0.75rem 1rem;
    border-radius: 8px;
    overflow-x: auto;
    margin: 0.75rem 0;
    border: 1px solid rgba(136, 192, 208, 0.2);
  }

  :global(.prose pre code) {
    background: transparent;
    padding: 0;
  }

  :global(.prose ul) {
    padding-left: 1.25rem;
    margin: 0.5rem 0;
  }

  :global(.prose li) {
    margin: 0.25rem 0;
  }

  :global(.prose blockquote) {
    background: rgba(136, 192, 208, 0.1);
    border-left: 3px solid #88C0D0;
    padding: 0.5rem 1rem;
    border-radius: 0 8px 8px 0;
    margin: 0.75rem 0;
  }

  :global(.prose strong) {
    color: #ECEFF4;
  }

  @keyframes regionAppear {
    from {
      opacity: 0;
      transform: scale(0.95) translateY(20px);
    }
    to {
      opacity: 1;
      transform: scale(1) translateY(0);
    }
  }

  @keyframes cardSlideIn {
    from {
      opacity: 0;
      transform: translateX(-20px);
    }
    to {
      opacity: 1;
      transform: translateX(0);
    }
  }
</style>