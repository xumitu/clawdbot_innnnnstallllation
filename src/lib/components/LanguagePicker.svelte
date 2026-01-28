<script lang="ts">
  import { locale, SUPPORTED_LOCALES, LOCALE_FLAGS } from '$lib/stores/language.store';
  import type { SupportedLocale } from '$lib/types';

  let isOpen = $state(false);
  let currentLang = $derived($locale);

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
    <div class="menu-bar">
      {#each SUPPORTED_LOCALES as lang}
        <button
          onclick={() => selectLanguage(lang)}
          class="menu-item"
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
    display: flex;
    align-items: center;
    gap: 8px;
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
    flex-shrink: 0;
  }

  .main-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 6px 20px rgba(244, 67, 54, 0.4);
  }

  .menu-bar {
    display: flex;
    gap: 6px;
    background: white;
    padding: 6px 10px;
    border-radius: 24px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    animation: slideIn 0.3s ease-out;
  }

  @keyframes slideIn {
    from {
      opacity: 0;
      transform: translateX(-10px);
    }
    to {
      opacity: 1;
      transform: translateX(0);
    }
  }

  .menu-item {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: #f5f5f5;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1rem;
    transition: all 0.2s;
    cursor: pointer;
  }

  .menu-item:hover {
    background: #ffebee;
    transform: scale(1.1);
  }

  .menu-item[aria-current="true"] {
    background: #f44336;
  }
</style>
