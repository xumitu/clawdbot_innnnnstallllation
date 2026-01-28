<script lang="ts">
  import { locale, SUPPORTED_LOCALES, LOCALE_FLAGS } from '$lib/stores/language.store';
  import type { SupportedLocale } from '$lib/types';

  let isOpen = $state(false);
  let currentLang = $derived($locale);
  
  const radius = 60;
  const expandedRadius = 100;

  function getPosition(index: number, total: number, r: number) {
    const angle = (index / total) * 2 * Math.PI - Math.PI / 2;
    return {
      x: Math.cos(angle) * r,
      y: Math.sin(angle) * r
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

<div class="language-picker">
  <button
    onclick={toggle}
    class="main-btn"
    aria-label="Select language"
  >
    {LOCALE_FLAGS[currentLang]}
  </button>

  {#if isOpen}
    <div class="menu-container">
      {#each SUPPORTED_LOCALES as lang, i}
        {@const pos = getPosition(i, SUPPORTED_LOCALES.length, expandedRadius)}
        <button
          onclick={() => selectLanguage(lang)}
          class="menu-item"
          style="transform: translate({pos.x}px, {pos.y}px) scale({isOpen ? 1 : 0});"
          aria-label={lang}
        >
          {LOCALE_FLAGS[lang]}
        </button>
      {/each}
    </div>
  {/if}
</div>

<style>
  .language-picker {
    position: fixed;
    top: 24px;
    right: 24px;
    z-index: 1000;
    width: 44px;
    height: 44px;
  }

  .main-btn {
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: #f44336;
    box-shadow: 0 4px 12px rgba(244, 67, 54, 0.3);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.25rem;
    transition: transform 0.2s, box-shadow 0.2s;
    cursor: pointer;
  }

  .main-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 6px 20px rgba(244, 67, 54, 0.4);
  }

  .menu-container {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    transform: translate(-50%, -50%);
  }

  .menu-item {
    position: absolute;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: white;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1rem;
    transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    cursor: pointer;
    opacity: 0;
  }

  .menu-item:hover {
    background: #ffebee;
    box-shadow: 0 4px 12px rgba(244, 67, 54, 0.2);
  }
</style>
