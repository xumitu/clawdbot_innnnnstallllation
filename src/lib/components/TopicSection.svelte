<script lang="ts">
  import type { Topic } from '$lib/types';
  import { locale } from '$lib/stores/language.store';
  import Card from './Card.svelte';

  let { topic, cards = [] } = $props<{
    topic: Topic;
    cards: Map<string, string>;
  }>();

  let currentLang = $derived($locale);
  let title = $derived(topic.title[currentLang] || topic.title['en'] || '');
  let description = $derived(topic.description[currentLang] || topic.description['en'] || '');
</script>

<section class="py-12">
  <div class="text-center mb-8">
    <h2 class="text-3xl font-bold text-nord-6 mb-2">{title}</h2>
    <p class="text-nord-4 max-w-2xl mx-auto opacity-80">{description}</p>
  </div>

  <div class="card-container">
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 max-w-7xl">
      {#each topic.cards as card, i}
        {@const markdown = cards.get(card.id) || ''}
        <div 
          class="topic-card"
          style="animation-delay: {i * 100}ms"
        >
          <Card {card} {markdown} />
        </div>
      {/each}
    </div>
  </div>
</section>

<style>
  .card-container {
    display: flex;
    justify-content: center;
    width: 100%;
    padding: 0 1rem;
  }

  .topic-card {
    animation: fadeInUp 0.6s ease-out forwards;
    opacity: 0;
    transform: translateY(20px);
  }

  @keyframes fadeInUp {
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
</style>