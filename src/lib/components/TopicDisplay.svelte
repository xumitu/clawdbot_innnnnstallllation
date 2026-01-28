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

  let htmlContent = $state('');
  let element: HTMLElement;
  let isHovered = $state(false);

  onMount(async () => {
    const markdown = cardContents.get(`${topic.id}-${topic.cards[0]?.id}`) || '# ' + title;
    const raw = await marked.parse(markdown);
    htmlContent = DOMPurify.sanitize(raw as string);
  });
</script>

<section 
  bind:this={element}
  onmouseenter={() => isHovered = true}
  onmouseleave={() => isHovered = false}
  class="topic-display"
  class:hovered={isHovered}
  role="article"
>
  <div class="glow-overlay"></div>
  <div class="content-wrapper">
    <h2 class="topic-title">{title}</h2>
    <div class="markdown-content prose">
      {@html htmlContent}
    </div>
  </div>
</section>

<style>
  .topic-display {
    position: relative;
    background: rgba(76, 86, 106, 0.4);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border-radius: 16px;
    border: 1px solid rgba(136, 192, 208, 0.2);
    overflow: hidden;
    transition: all 0.4s ease;
    animation: regionAppear 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
    opacity: 0;
  }

  .glow-overlay {
    position: absolute;
    inset: -8px;
    background: radial-gradient(
      ellipse at center,
      rgba(208, 135, 112, 0.5) 0%,
      rgba(235, 203, 139, 0.3) 40%,
      transparent 70%
    );
    border-radius: 24px;
    opacity: 0;
    transition: opacity 0.4s ease;
    pointer-events: none;
    z-index: 0;
    filter: blur(12px);
  }

  .topic-display.hovered .glow-overlay {
    opacity: 1;
    animation: ambientGlow 3s ease-in-out infinite;
  }

  @keyframes ambientGlow {
    0%, 100% { transform: scale(1); opacity: 0.8; }
    50% { transform: scale(1.05); opacity: 1; }
  }

  .topic-display:hover {
    border-color: rgba(208, 135, 112, 0.4);
  }

  .content-wrapper {
    position: relative;
    z-index: 1;
    padding: 1.5rem;
  }

  .topic-title {
    font-size: 1.1rem;
    font-weight: 600;
    color: #ECEFF4;
    margin-bottom: 1rem;
    padding-bottom: 0.75rem;
    border-bottom: 1px solid rgba(136, 192, 208, 0.2);
  }

  .markdown-content {
    font-size: 0.85rem;
    line-height: 1.6;
    color: #D8DEE9;
  }

  :global(.prose h1) {
    font-size: 1rem;
    font-weight: 600;
    color: #ECEFF4;
    margin: 0.75rem 0 0.5rem;
  }

  :global(.prose h2) {
    font-size: 0.9rem;
    font-weight: 600;
    color: #E5E9F0;
    margin: 0.6rem 0 0.3rem;
  }

  :global(.prose p) {
    margin: 0.4rem 0;
  }

  :global(.prose code) {
    font-family: 'Fira Code', 'Consolas', monospace;
    background: rgba(208, 135, 112, 0.2);
    padding: 0.1rem 0.35rem;
    border-radius: 4px;
    font-size: 0.8em;
    color: #EBCB8B;
  }

  :global(.prose pre) {
    background: rgba(46, 52, 64, 0.6);
    color: #D8DEE9;
    padding: 0.75rem;
    border-radius: 8px;
    overflow-x: auto;
    margin: 0.75rem 0;
    border: 1px solid rgba(208, 135, 112, 0.2);
    font-size: 0.8rem;
  }

  :global(.prose pre code) {
    background: transparent;
    padding: 0;
    color: inherit;
  }

  :global(.prose ul) {
    padding-left: 1.25rem;
    margin: 0.5rem 0;
  }

  :global(.prose li) {
    margin: 0.25rem 0;
  }

  :global(.prose blockquote) {
    background: rgba(208, 135, 112, 0.1);
    border-left: 3px solid #D08770;
    padding: 0.5rem 1rem;
    border-radius: 0 8px 8px 0;
    margin: 0.75rem 0;
  }

  :global(.prose strong) {
    color: #ECEFF4;
  }

  :global(.prose a) {
    color: #88C0D0;
    text-decoration: none;
  }

  :global(.prose a:hover) {
    text-decoration: underline;
  }

  @keyframes regionAppear {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
</style>