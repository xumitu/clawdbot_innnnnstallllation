<script lang="ts">
  import { marked } from 'marked';
  import DOMPurify from 'dompurify';
  import { onMount } from 'svelte';
  import type { Topic } from '$lib/types';
  import { theme } from '$lib/stores/theme.store';

  let { topic, markdownContent = '' } = $props<{
    topic: Topic;
    markdownContent?: string;
  }>();

  let htmlContent = $state('');
  let element: HTMLElement;
  let isHovered = $state(false);

  let currentTheme = $derived($theme);
  let isExamples = $derived(currentTheme === 'examples');

  onMount(async () => {
    if (markdownContent) {
      const raw = await marked.parse(markdownContent);
      htmlContent = DOMPurify.sanitize(raw as string);
    }
  });

  $effect(() => {
    async function updateContent() {
      if (markdownContent) {
        const raw = await marked.parse(markdownContent);
        htmlContent = DOMPurify.sanitize(raw as string);
      }
    }
    updateContent();
  });
</script>

<section 
  bind:this={element}
  onmouseenter={() => isHovered = true}
  onmouseleave={() => isHovered = false}
  class="topic-display"
  class:hovered={isHovered}
  class:examples={isExamples}
  role="article"
>
  <div class="border-glow"></div>
  <div class="content-wrapper">
    <h2 class="topic-title">{topic.title.en}</h2>
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
    transition: all 0.3s ease;
    animation: regionAppear 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
    opacity: 0;
  }

  .topic-display.examples {
    background: rgba(94, 129, 172, 0.35);
    border-color: rgba(208, 135, 112, 0.25);
  }

  .border-glow {
    position: absolute;
    inset: 0;
    border-radius: 16px;
    padding: 2px;
    background: linear-gradient(135deg, #D08770 0%, #EBCB8B 25%, #D08770 50%, #BF616A 75%, #D08770 100%);
    -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    -webkit-mask-composite: xor;
    mask-composite: exclude;
    opacity: 0;
    transition: opacity 0.3s ease;
    pointer-events: none;
  }

  .topic-display.examples .border-glow {
    background: linear-gradient(135deg, #5E81AC 0%, #81A1C1 25%, #88C0D0 50%, #5E81AC 75%, #88C0D0 100%);
  }

  .topic-display.hovered .border-glow {
    opacity: 1;
  }

  .topic-display:hover {
    box-shadow: 0 0 30px rgba(208, 135, 112, 0.4);
  }

  .topic-display.examples:hover {
    box-shadow: 0 0 30px rgba(136, 192, 208, 0.5);
    border-color: rgba(136, 192, 208, 0.4);
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

  .topic-display.examples .topic-title {
    border-bottom-color: rgba(208, 135, 112, 0.25);
  }

  .markdown-content {
    font-size: 0.85rem;
    line-height: 1.6;
    color: #D8DEE9;
  }

  .markdown-content :global(img) {
    max-width: 100%;
    height: auto;
    border-radius: 8px;
    margin: 1rem 0;
  }

  .markdown-content :global(video) {
    max-width: 100%;
    border-radius: 8px;
    margin: 1rem 0;
  }

  .markdown-content :global(h1) {
    font-size: 1rem;
    font-weight: 600;
    color: #ECEFF4;
    margin: 0.75rem 0 0.5rem;
  }

  .markdown-content :global(h2) {
    font-size: 0.9rem;
    font-weight: 600;
    color: #E5E9F0;
    margin: 0.6rem 0 0.3rem;
  }

  .markdown-content :global(p) {
    margin: 0.4rem 0;
  }

  .markdown-content :global(code) {
    font-family: 'Fira Code', 'Consolas', monospace;
    background: rgba(208, 135, 112, 0.2);
    padding: 0.1rem 0.35rem;
    border-radius: 4px;
    font-size: 0.8em;
    color: #EBCB8B;
  }

  .topic-display.examples :global(code) {
    background: rgba(136, 192, 208, 0.2);
    color: #88C0D0;
  }

  .markdown-content :global(pre) {
    background: rgba(46, 52, 64, 0.6);
    color: #D8DEE9;
    padding: 0.75rem;
    border-radius: 8px;
    overflow-x: auto;
    margin: 0.75rem 0;
    border: 1px solid rgba(208, 135, 112, 0.2);
    font-size: 0.8rem;
  }

  .topic-display.examples :global(pre) {
    border-color: rgba(136, 192, 208, 0.25);
  }

  .markdown-content :global(pre code) {
    background: transparent;
    padding: 0;
    color: inherit;
  }

  .markdown-content :global(ul), .markdown-content :global(ol) {
    padding-left: 1.25rem;
    margin: 0.5rem 0;
  }

  .markdown-content :global(li) {
    margin: 0.25rem 0;
  }

  .markdown-content :global(blockquote) {
    background: rgba(208, 135, 112, 0.1);
    border-left: 3px solid #D08770;
    padding: 0.5rem 1rem;
    border-radius: 0 8px 8px 0;
    margin: 0.75rem 0;
  }

  .topic-display.examples :global(blockquote) {
    background: rgba(136, 192, 208, 0.1);
    border-left-color: #88C0D0;
  }

  .markdown-content :global(strong) {
    color: #ECEFF4;
  }

  .markdown-content :global(a) {
    color: #88C0D0;
    text-decoration: none;
  }

  .markdown-content :global(a:hover) {
    text-decoration: underline;
  }

  .topic-display.examples :global(a) {
    color: #D08770;
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