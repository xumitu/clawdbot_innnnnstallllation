<script lang="ts">
  import { theme } from '$lib/stores/theme.store';

  function setTheme(t: 'install' | 'examples') {
    theme.set(t);
  }
</script>

<div class="theme-switcher">
  <button
    class="switch-btn install-btn"
    class:active={$theme === 'install'}
    onclick={() => setTheme('install')}
  >
    安装
  </button>
  <button
    class="switch-btn examples-btn"
    class:active={$theme === 'examples'}
    onclick={() => setTheme('examples')}
  >
    案例
  </button>
</div>

<style>
  .theme-switcher {
    position: fixed;
    top: 1.5rem;
    right: 1.5rem;
    display: flex;
    gap: 0;
    background: rgba(46, 52, 64, 0.5);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    padding: 4px;
    border: 1px solid rgba(136, 192, 208, 0.2);
    z-index: 100;
  }

  .switch-btn {
    padding: 10px 24px;
    font-size: 0.9rem;
    font-weight: 500;
    color: #D8DEE9;
    background: transparent;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .switch-btn:first-child {
    border-right: 1px solid rgba(136, 192, 208, 0.2);
  }

  .switch-btn:hover {
    background: rgba(136, 192, 208, 0.1);
  }

  .switch-btn.active {
    color: #ECEFF4;
  }

  .install-btn.active {
    background: rgba(136, 192, 208, 0.3);
    box-shadow: 0 0 20px rgba(136, 192, 208, 0.3);
  }

  .install-btn.active:hover {
    background: rgba(136, 192, 208, 0.4);
  }

  .examples-btn.active {
    background: rgba(208, 135, 112, 0.3);
    box-shadow: 0 0 20px rgba(208, 135, 112, 0.3);
  }

  .examples-btn.active:hover {
    background: rgba(208, 135, 112, 0.4);
  }
</style>