<script lang="ts">
  import MouseEffects from '$lib/components/MouseEffects.svelte';
  import ThemeSwitcher from '$lib/components/ThemeSwitcher.svelte';
  import TiltCard from '$lib/components/TiltCard.svelte';

  const comingSoonText = '尽请期待';
</script>

<svelte:head>
  <title>案例 - MoltBot</title>
</svelte:head>

<div class="page-wrapper examples-page">
  <MouseEffects />
  <ThemeSwitcher />

  <main class="centered-content">
    <header class="page-header">
      <h1 class="page-title">
        MoltBot <span class="subtitle">案例</span>
      </h1>
      <p class="title-note">官方把 ClawdBot 改成了 MoltBolt</p>
    </header>

    <section class="content-region">
      <div class="card-wrapper">
        <TiltCard>
          <div class="coming-soon-content">
            <span class="coming-soon-text">{comingSoonText}</span>
          </div>
        </TiltCard>
      </div>
    </section>
  </main>
</div>

<style>
  .page-wrapper {
    min-height: 100vh;
    background:
      radial-gradient(ellipse at 20% 30%, rgba(208, 135, 112, 0.25) 0%, transparent 50%),
      radial-gradient(ellipse at 80% 70%, rgba(235, 203, 139, 0.25) 0%, transparent 50%),
      radial-gradient(ellipse at 50% 50%, rgba(191, 97, 106, 0.2) 0%, transparent 60%),
      radial-gradient(ellipse at 70% 20%, rgba(180, 142, 173, 0.2) 0%, transparent 40%),
      linear-gradient(180deg, #5E81AC 0%, #4C566A 50%, #434C5E 100%);
  }

  .centered-content {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 3rem 1rem;
  }

  .page-header {
    text-align: center;
    margin-bottom: 2rem;
  }

  .page-title {
    font-size: 2.5rem;
    font-weight: 700;
    color: #ECEFF4;
    margin: 0;
    letter-spacing: -0.02em;
  }

  .page-title .subtitle {
    font-size: 1.8rem;
    font-weight: 400;
    color: #D08770;
    margin-left: 0.5rem;
  }

  .title-note {
    font-size: 0.85rem;
    color: #D8DEE9;
    opacity: 0.7;
    margin-top: 0.5rem;
  }

  .content-region {
    width: 50%;
    max-width: 600px;
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .card-wrapper {
    width: 100%;
    aspect-ratio: 16/9;
    max-height: 280px;
  }

  .coming-soon-content {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
  }

  .coming-soon-text {
    font-size: 2rem;
    font-weight: 600;
    color: #D08770;
    letter-spacing: 0.5em;
  }

  @media (max-width: 768px) {
    .content-region {
      width: 90%;
    }

    .page-title {
      font-size: 2rem;
    }

    .page-title .subtitle {
      font-size: 1.5rem;
    }
  }
</style>