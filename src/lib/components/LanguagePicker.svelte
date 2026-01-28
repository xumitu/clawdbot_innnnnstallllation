<script lang="ts">
  import { locale, SUPPORTED_LOCALES, LOCALE_FLAGS } from '$lib/stores/language.store';
  import type { SupportedLocale } from '$lib/types';

  let isOpen = $state(false);
  let currentLang = $derived($locale);
  
  const radius = 80;

  function getPosition(index: number, total: number) {
    const angle = (index / total) * 2 * Math.PI - Math.PI / 2;
    return {
      x: Math.cos(angle) * radius,
      y: Math.sin(angle) * radius
    };
  }

  function selectLanguage(lang: SupportedLocale) {
    locale.set(lang);
    isOpen = false;
    playSound();
  }

  function playSound() {
    const audio = new AudioContext();
    const osc = audio.createOscillator();
    const gain = audio.createGain();
    osc.connect(gain);
    gain.connect(audio.destination);
    osc.frequency.value = 800;
    gain.gain.setValueAtTime(0.1, audio.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.01, audio.currentTime + 0.1);
    osc.start();
    osc.stop(audio.currentTime + 0.1);
  }

  function toggle() {
    isOpen = !isOpen;
    if (isOpen) playSound();
  }
</script>

<div class="fixed top-6 right-6 z-40">
  <button
    onclick={toggle}
    class="w-14 h-14 rounded-full bg-md-red-500 shadow-lg flex items-center justify-center text-2xl transition-transform hover:scale-110"
    aria-label="Select language"
  >
    {LOCALE_FLAGS[currentLang]}
  </button>

  {#if isOpen}
    <div class="absolute top-0 left-0 w-14 h-14">
      {#each SUPPORTED_LOCALES as lang, i}
        {@const pos = getPosition(i, SUPPORTED_LOCALES.length)}
        <button
          onclick={() => selectLanguage(lang)}
          class="absolute w-10 h-10 rounded-full bg-white shadow-md flex items-center justify-center text-xl transition-all duration-300 hover:bg-md-red-100"
          style="transform: translate({pos.x}px, {pos.y}px) scale({isOpen ? 1 : 0}); opacity: {isOpen ? 1 : 0};"
          aria-label={lang}
        >
          {LOCALE_FLAGS[lang]}
        </button>
      {/each}
    </div>
  {/if}
</div>
