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

<section class="topic-region">
  <div class="region-header">
    <h2 class="region-title">{title}</h2>
    <p class="region-description">{description}</p>
  </div>
  
  <div class="cards-grid">
    {#each topic.cards as card, i}
      {@const markdown = cards.get(card.id) || ''}
      <div 
        class="card-wrapper"
        style="animation-delay: {i * 80}ms"
      >
        <Card {card} {markdown} />
      </div>
    {/each}
  </div>
</section>

<style>
  .topic-region {
    background: rgba(76, 86, 106, 0.4);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-radius: 24px;
    border: 1px solid rgba(136, 192, 208, 0.2);
    padding: 2rem;
    height: 100%;
    display: flex;
    flex-direction: column;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    animation: scaleIn 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
    opacity: 0;
  }

  .topic-region:hover {
    box-shadow: 0 10px 40px rgba(136, 192, 208, 0.15);
  }

  .region-header {
    text-align: center;
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid rgba(136, 192, 208, 0.15);
  }

  .region-title {
    font-size: 1.5rem;
    font-weight: 700;
    color: #ECEFF4;
    margin-bottom: 0.5rem;
  }

  .region-description {
    font-size: 0.9rem;
    color: #D8DEE9;
    opacity: 0.7;
  }

  .cards-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
    flex: 1;
  }

  .card-wrapper {
    animation: fadeInUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) forwards;
    opacity: 0;
    transform: translateY(20px);
  }

  @media (max-width: 480px) {
    .cards-grid {
      grid-template-columns: 1fr;
    }
  }

  @keyframes scaleIn {
    from {
      opacity: 0;
      transform: scale(0.95) translateY(10px);
    }
    to {
      opacity: 1;
      transform: scale(1) translateY(0);
    }
  }

  @keyframes fadeInUp {
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