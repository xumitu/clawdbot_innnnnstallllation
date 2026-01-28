<script lang="ts">
  import { onMount } from 'svelte';
  import { locale } from '$lib/stores/language.store';
  import { loadTopics, loadMarkdown, loadLocale } from '$lib/utils/content-loader';
  import type { Topic, Locale } from '$lib/types';
  import TopicDisplay from '$lib/components/TopicDisplay.svelte';
  import MouseEffects from '$lib/components/MouseEffects.svelte';
  import LanguagePicker from '$lib/components/LanguagePicker.svelte';

  let topics = $state<Topic[]>([]);
  let cardContents = $state<Map<string, string>>(new Map());
  let translations = $state<Locale | null>(null);

  let mouseX = $state(0);
  let titleBounds: DOMRect | null = $state(null);

  onMount(async () => {
    topics = await loadTopics();
    
    for (const topic of topics) {
      for (const card of topic.cards) {
        const md = await loadMarkdown(topic.id, card.id);
        cardContents.set(`${topic.id}-${card.id}`, md);
      }
    }
    cardContents = new Map(cardContents);
    
    translations = await loadLocale($locale);
  });

  $effect(() => {
    if ($locale && topics.length > 0) {
      loadLocale($locale).then(t => translations = t);
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
  <title>Clawdbot Installation</title>
  <meta name="description" content="Interactive installation guide for Clawdbot AI Agent" />
</svelte:head>

<MouseEffects />
<LanguagePicker />

<main class="min-h-screen pb-20">
  <header class="py-16 text-center">
    <h1 
      bind:clientWidth={titleBounds}
      class="title"
      style={getTitleStyle()}
    >
      Clawdbot
    </h1>
    <p class="text-xl text-nord-4 max-w-2xl mx-auto px-4 opacity-80">
      AI Agent Installation Guide
    </p>
  </header>

  <div class="regions-container">
    {#each topics as topic, i}
      <div 
        class="region-item"
        style="animation-delay: {i * 150}ms"
      >
        <TopicDisplay {topic} {cardContents} />
      </div>
    {/each}
  </div>

  <footer class="text-center py-12 text-nord-4 text-sm opacity-60">
    <p>© 2024 Clawdbot. All rights reserved.</p>
  </footer>
</main>

<style>
  .title {
    font-size: 3.5rem;
    font-weight: 700;
    letter-spacing: -0.02em;
    color: #ECEFF4;
    position: relative;
    display: inline-block;
    cursor: default;
    transition: color 0.3s ease;
  }

  .title::before {
    content: 'Clawdbot';
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
    transform: translateX(calc((var(--glow-intensity, 0) - 0.5) * -20%));
    animation: shimmer 3s ease-in-out infinite;
    animation-delay: 0.5s;
  }

  .title::after {
    content: 'Clawdbot';
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