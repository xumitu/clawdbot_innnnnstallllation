<script lang="ts">
  import MouseEffects from '$lib/components/MouseEffects.svelte';
  import ThemeSwitcher from '$lib/components/ThemeSwitcher.svelte';
  import TiltCard from '$lib/components/TiltCard.svelte';

  const introText = '在写教程的时候还是觉得安装有一些门槛，尤其是国外网站和我们的DNS配置导致安装在国内失败率很高。于是写了这个在Apple Mac系列的Apple Silicon M系列处理器上面的安装器。这是第一个版本只适用于干净的系统初次安装，后续会迭代。请耐心等待';
</script>

<svelte:head>
  <title>MoltBot 安装</title>
</svelte:head>

<div class="page-wrapper install-page">
  <MouseEffects />
  <ThemeSwitcher />

  <main class="centered-content">
    <header class="page-header">
      <h1 class="page-title">
        MoltBot <span class="subtitle">安装</span>
      </h1>
      <p class="title-note">官方把 ClawdBot 改成了 MoltBolt</p>
    </header>

    <section class="content-region">
      <h2 class="download-title">点击下载 MoltBot 安装器 Beta</h2>

      <div class="card-wrapper">
        <TiltCard href="/files/Moltbot-Installer.zip">
          <div class="app-card-content">
            <img src="/images/install.png" alt="Moltbot Installer" class="app-icon glass-effect" />
            <div class="app-info">
              <span class="app-name">Moltbot Installer.zip</span>
              <span class="app-desc">点击下载 · 解压后安装</span>
            </div>
          </div>
        </TiltCard>
      </div>

      <div class="info-card orange">
        <p class="info-text glow-text">{introText}</p>
      </div>

      <div class="info-card blue">
        <p class="info-text">本网页和 APP 均由 MoltBot 生成</p>
      </div>
    </section>
  </main>
</div>

<style>
  .page-wrapper {
    min-height: 100vh;
    background:
      radial-gradient(ellipse at 20% 30%, rgba(143, 188, 187, 0.2) 0%, transparent 50%),
      radial-gradient(ellipse at 80% 70%, rgba(136, 192, 208, 0.2) 0%, transparent 50%),
      radial-gradient(ellipse at 50% 50%, rgba(129, 161, 193, 0.15) 0%, transparent 60%),
      radial-gradient(ellipse at 70% 20%, rgba(94, 129, 172, 0.15) 0%, transparent 40%),
      linear-gradient(180deg, #4C566A 0%, #434C5E 50%, #3B4252 100%);
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
    color: #88C0D0;
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
    gap: 1.5rem;
  }

  .download-title {
    font-size: 1.2rem;
    font-weight: 600;
    color: #ECEFF4;
    text-align: center;
    margin: 0;
  }

  .card-wrapper {
    width: 100%;
    aspect-ratio: 16/9;
    max-height: 280px;
  }

  .app-card-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    height: 100%;
  }

  .app-icon {
    width: 100px;
    height: 100px;
    flex-shrink: 0;
    border-radius: 24px;
  }

  .glass-effect {
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.2);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  }

  .app-info {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.25rem;
  }

  .app-name {
    font-size: 1.1rem;
    font-weight: 600;
    color: #ECEFF4;
  }

  .app-desc {
    font-size: 0.85rem;
    color: #88C0D0;
    opacity: 0.8;
  }

  .info-card {
    width: 100%;
    padding: 1.25rem;
    border-radius: 12px;
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
  }

  .info-card.orange {
    background: rgba(208, 135, 112, 0.2);
    border: 1px solid rgba(208, 135, 112, 0.3);
  }

  .info-card.blue {
    background: rgba(136, 192, 208, 0.15);
    border: 1px solid rgba(136, 192, 208, 0.3);
  }

  .info-text {
    font-size: 0.8rem;
    color: #D8DEE9;
    opacity: 0.85;
    text-align: center;
    line-height: 1.7;
    margin: 0;
  }

  .glow-text {
    text-shadow: 0 0 8px rgba(208, 135, 112, 0.5), 0 0 16px rgba(208, 135, 112, 0.3);
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