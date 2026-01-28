export interface Topic {
  id: string;
  order: number;
  title: Record<string, string>;
  description: Record<string, string>;
  cards: Card[];
}

export interface Card {
  id: string;
  order: number;
  markdownFile: string;
  type: 'terminal' | 'info' | 'code';
  icon: string;
  copyable?: boolean;
}

export interface Locale {
  language: string;
  selectLanguage: string;
  installation: string;
  apiConfig: string;
  copy: string;
  copied: string;
  close: string;
}

export type SupportedLocale = 'en' | 'zh-CN' | 'fr' | 'ko' | 'ja' | 'es' | 'ru';

export const SUPPORTED_LOCALES: SupportedLocale[] = ['en', 'zh-CN', 'fr', 'ko', 'ja', 'es', 'ru'];

export const LOCALE_FLAGS: Record<SupportedLocale, string> = {
  en: '🇺🇸',
  'zh-CN': '🇨🇳',
  'fr': '🇫🇷',
  ko: '🇰🇷',
  ja: '🇯🇵',
  es: '🇪🇸',
  ru: '🇷🇺'
};
