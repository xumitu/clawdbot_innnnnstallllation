import { writable } from 'svelte/store';
import { browser } from '$app/environment';
import type { SupportedLocale } from '../types';

export const SUPPORTED_LOCALES: SupportedLocale[] = ['en', 'zh-CN', 'zh-TW', 'ko', 'ja', 'es', 'ru'];

export const LOCALE_FLAGS: Record<SupportedLocale, string> = {
  en: '🇺🇸',
  'zh-CN': '🇨🇳',
  'zh-TW': '🇹🇼',
  ko: '🇰🇷',
  ja: '🇯🇵',
  es: '🇪🇸',
  ru: '🇷🇺'
};

const DEFAULT_LOCALE: SupportedLocale = 'zh-CN';

function getInitialLocale(): SupportedLocale {
  if (browser) {
    const saved = localStorage.getItem('clawdbot-locale') as SupportedLocale;
    if (saved && SUPPORTED_LOCALES.includes(saved)) return saved;
    const browserLang = navigator.language;
    if (browserLang.startsWith('zh-TW') || browserLang.startsWith('zh-HK')) return 'zh-TW';
    if (browserLang.startsWith('zh')) return 'zh-CN';
    if (browserLang.startsWith('ko')) return 'ko';
    if (browserLang.startsWith('ja')) return 'ja';
    if (browserLang.startsWith('es')) return 'es';
    if (browserLang.startsWith('ru')) return 'ru';
  }
  return DEFAULT_LOCALE;
}

export const locale = writable<SupportedLocale>(getInitialLocale());

if (browser) {
  locale.subscribe((value) => {
    localStorage.setItem('clawdbot-locale', value);
    document.documentElement.lang = value;
  });
}
