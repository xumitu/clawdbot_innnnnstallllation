<script lang="ts">
  let { text = '' } = $props<{ text?: string }>();
</script>

<div class="glow-text">
  {text}
</div>

<style>
  .glow-text {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 0.05em;
    color: #D8DEE9;
    font-size: 0.8rem;
    line-height: 1.7;
    text-align: center;
    text-shadow: 0 0 8px rgba(208, 135, 112, 0.5), 0 0 16px rgba(208, 135, 112, 0.3);
  }
</style>