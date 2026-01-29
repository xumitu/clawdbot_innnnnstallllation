<script lang="ts">
  let { text = '' } = $props<{ text?: string }>();
</script>

<div class="firefly-text">
  {#each text.split('') as char, i}
    <span class="firefly" style="animation-delay: {Math.random() * 3}s; animation-duration: {2 + Math.random() * 2}s">
      {char}
    </span>
  {/each}
</div>

<style>
  .firefly-text {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 0.05em;
  }

  .firefly {
    display: inline-block;
    color: #D8DEE9;
    animation: flicker 3s ease-in-out infinite;
  }

  @keyframes flicker {
    0%, 100% {
      opacity: 0.6;
      text-shadow: 0 0 2px rgba(136, 192, 208, 0.3);
      transform: translateY(0);
    }
    10% {
      opacity: 1;
      text-shadow: 0 0 8px rgba(136, 192, 208, 0.8), 0 0 16px rgba(136, 192, 208, 0.4);
      transform: translateY(-1px);
    }
    20% {
      opacity: 0.7;
      text-shadow: 0 0 4px rgba(136, 192, 208, 0.4);
      transform: translateY(0);
    }
    30% {
      opacity: 1;
      text-shadow: 0 0 12px rgba(136, 192, 208, 0.9), 0 0 20px rgba(136, 192, 208, 0.5);
      transform: translateY(-2px);
    }
    50% {
      opacity: 0.8;
      text-shadow: 0 0 6px rgba(136, 192, 208, 0.5);
      transform: translateY(0);
    }
    60% {
      opacity: 1;
      text-shadow: 0 0 10px rgba(136, 192, 208, 0.85), 0 0 18px rgba(136, 192, 208, 0.45);
      transform: translateY(-1px);
    }
    80% {
      opacity: 0.65;
      text-shadow: 0 0 3px rgba(136, 192, 208, 0.35);
      transform: translateY(0);
    }
  }
</style>