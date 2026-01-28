import { writable } from 'svelte/store';

export type ThemeMode = 'install' | 'examples';

export const theme = writable<ThemeMode>('install');

export const themeConfig = {
  install: {
    primaryColor: '#88C0D0',
    borderGlow: 'linear-gradient(135deg, #D08770 0%, #EBCB8B 25%, #D08770 50%, #BF616A 75%, #D08770 100%)',
    hoverGlowColor: 'rgba(208, 135, 112, 0.4)',
    codeColor: '#EBCB8B',
    buttonActiveBg: 'rgba(136, 192, 208, 0.3)',
    buttonInactiveText: '#D8DEE9'
  },
  examples: {
    primaryColor: '#D08770',
    borderGlow: 'linear-gradient(135deg, #88C0D0 0%, #81A1C1 25%, #88C0D0 50%, #5E81AC 75%, #88C0D0 100%)',
    hoverGlowColor: 'rgba(136, 192, 208, 0.4)',
    codeColor: '#88C0D0',
    buttonActiveBg: 'rgba(208, 135, 112, 0.3)',
    buttonInactiveText: '#D8DEE9'
  }
};