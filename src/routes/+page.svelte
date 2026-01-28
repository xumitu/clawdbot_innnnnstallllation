<script lang="ts">
  import { onMount } from 'svelte';
  import { theme } from '$lib/stores/theme.store';
  import { loadTopics, loadTopicMarkdown } from '$lib/utils/content-loader';
  import type { Topic } from '$lib/types';
  import TopicDisplay from '$lib/components/TopicDisplay.svelte';
  import MouseEffects from '$lib/components/MouseEffects.svelte';
  import ThemeSwitcher from '$lib/components/ThemeSwitcher.svelte';

  let topics = $state<Topic[]>([]);
  let topicContents = $state<Map<string, string>>(new Map());

  let mouseX = $state(0);
  let titleBounds: DOMRect | null = $state(null);

  async function loadContent() {
    topics = await loadTopics();
    topicContents = new Map();
    
    for (const topic of topics) {
      const md = await loadTopicMarkdown(topic.id);
      topicContents.set(topic.id, md);
    }
    topicContents = new Map(topicContents);
  }

  onMount(() => {
    loadContent();
  });

  $effect(() => {
    if ($theme) {
      loadContent();
    }
  });

  function onMouseMove(e: MouseEvent) {
    mouseX = e.clientX;
  }

  function getTitleStyle() {
    if (!titleBounds) return {};
    
    const centerX = titleBounds.left + titleBounds.width / 2;
    const distance = Math.abs(mouseX - centerX);
    const maxDistance = titleBounds.width / 2 + 100;
    const normalized = Math.max(0, 1 - distance / maxDistance);
    
    return {
      '--glow-intensity': normalized
    };
  }
</script>

<svelte:window onmousemove={onMouseMove} />
<svelte:head>
  <title>Clawdbot</title>
</svelte:head>

<div class="page-wrapper" class:examples={$theme === 'examples'}>
  <MouseEffects />
  <ThemeSwitcher />

  <main class="min-h-screen pb-20">
    <header class="py-16 text-center">
      <h1 
        bind:clientWidth={titleBounds}
        class="title"
        style={getTitleStyle()}
      >
        clawdbot 分享
      </h1>
    </header>

    <div class="regions-container">
      {#each topics as topic, i}
        <div 
          class="region-item"
          style="animation-delay: {i * 150}ms"
        >
          <TopicDisplay {topic} markdownContent={topicContents.get(topic.id) || ''} />
        </div>
      {/each}
    </div>

    <footer class="text-center py-12 text-nord-4 text-sm opacity-60">
      <p>© 2024 Clawdbot. All rights reserved.</p>
    </footer>
  </main>
</div>

<style>
  .page-wrapper {
    min-height: 100vh;
    background:
      radial-gradient(ellipse at 20% 30%, rgba(143, 188, 187, 0.2) 0%, transparent 50%),
      radial-gradient(ellipse at 80% 70%, rgba(136, 192, 208, 0.2) 0%, transparent 50%),
      radial-gradient(ellipse at 50% 50%, rgba(129, 161, 193, 0.15) 0%, transparent 60%),
      radial-gradient(ellipse at 70% 20%, rgba(94, 129, 172, 0.15) 0%, transparent 40%),
      linear-gradient(180deg, #4C566A 0%, #434C5E 50%, #3B4252 100%);
    transition: all 0.5s ease;
  }

  .page-wrapper.examples {
    background:
      radial-gradient(ellipse at 20% 30%, rgba(208, 135, 112, 0.25) 0%, transparent 50%),
      radial-gradient(ellipse at 80% 70%, rgba(235, 203, 139, 0.25) 0%, transparent 50%),
      radial-gradient(ellipse at 50% 50%, rgba(191, 97, 106, 0.2) 0%, transparent 60%),
      radial-gradient(ellipse at 70% 20%, rgba(180, 142, 173, 0.2) 0%, transparent 40%),
      linear-gradient(180deg, #5E81AC 0%, #4C566A 50%, #434C5E 100%);
  }

  .title {
    font-size: 3rem;
    font-weight: 700;
    letter-spacing: -0.02em;
    color: #ECEFF4;
    position: relative;
    display: inline-block;
    cursor: default;
    transition: color 0.3s ease;
  }

  .title::before {
    content: 'clawdbot 分享';
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(
      90deg,
      transparent 0%,
      rgba(136, 192, 208, 0.9) 30%,
      rgba(129, 161, 193, 0.95) 50%,
      rgba(136, 192, 208, 0.9) 70%,
      transparent 100%
    );
    background-size: 200% 100%;
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
    filter: blur(0px);
    opacity: calc(0.3 + (var(--glow-intensity, 0) * 0.7));
    transform: translateX(calc((var(--glow-intensity, 0) - 0.5) * -15%));
    animation: shimmer 3s ease-in-out infinite;
    animation-delay: 0.5s;
  }

  .title::after {
    content: 'clawdbot 分享';
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background: radial-gradient(
      ellipse at center,
      rgba(136, 192, 208, calc(var(--glow-intensity, 0) * 0.6)) 0%,
      transparent 70%
    );
    color: transparent;
    filter: blur(20px);
    z-index: -1;
  }

  @keyframes shimmer {
    0%, 100% {
      background-position: 100% 0;
    }
    50% {
      background-position: -100% 0;
    }
  }

  .regions-container {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1.5rem;
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 1.5rem;
  }

  .region-item {
    animation: fadeInUp 0.6s ease-out forwards;
    opacity: 0;
    transform: translateY(30px);
  }

  @keyframes fadeInUp {
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  @media (max-width: 1024px) {
    .regions-container {
      grid-template-columns: 1fr;
    }
  }
</style>