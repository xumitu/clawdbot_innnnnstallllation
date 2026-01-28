<script lang="ts">
  import { onMount } from 'svelte';
  import { locale } from '$lib/stores/language.store';
  import { loadTopics, loadMarkdown, loadLocale } from '$lib/utils/content-loader';
  import type { Topic, Locale } from '$lib/types';
  import TopicSection from '$lib/components/TopicSection.svelte';
  import MouseEffects from '$lib/components/MouseEffects.svelte';
  import LanguagePicker from '$lib/components/LanguagePicker.svelte';

  let topics = $state<Topic[]>([]);
  let cardContents = $state<Map<string, string>>(new Map());
  let translations = $state<Locale | null>(null);

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
</script>

<svelte:head>
  <title>Clawdbot Installation</title>
  <meta name="description" content="Interactive installation guide for Clawdbot AI Agent" />
</svelte:head>

<MouseEffects />
<LanguagePicker />

<main class="min-h-screen pb-20">
  <header class="py-20 text-center bg-gradient-to-b from-md-red-50 to-transparent">
    <h1 class="text-5xl font-bold text-gray-900 mb-4 tracking-tight">
      Clawdbot
    </h1>
    <p class="text-xl text-gray-600 max-w-2xl mx-auto px-4">
      AI Agent Installation Guide
    </p>
  </header>

  {#each topics as topic}
    <TopicSection {topic} cards={cardContents} />
  {/each}

  <footer class="text-center py-12 text-gray-500 text-sm">
    <p>© 2024 Clawdbot. All rights reserved.</p>
  </footer>
</main>
