import type { Topic, Locale, SupportedLocale } from '../types';

const topicCache = new Map<string, Topic>();

const topicModules: Record<string, () => Promise<{ default: unknown }>> = {
  setup: () => import('../content/topics/setup/index.json?url'),
  'api-config': () => import('../content/topics/api-config/index.json?url')
};

export async function loadTopics(): Promise<Topic[]> {
  const topics = ['setup', 'api-config'];
  const loaded: Topic[] = [];
  
  for (const topicId of topics) {
    if (!topicCache.has(topicId)) {
      try {
        const module = await topicModules[topicId]();
        const response = await fetch((module.default as string));
        topicCache.set(topicId, await response.json());
      } catch (e) {
        console.error(`Failed to load topic ${topicId}:`, e);
      }
    }
    const topic = topicCache.get(topicId);
    if (topic) loaded.push(topic);
  }
  
  return loaded.sort((a, b) => a.order - b.order);
}

export async function loadMarkdown(topicId: string, cardId: string): Promise<string> {
  const topic = topicCache.get(topicId);
  const card = topic?.cards.find(c => c.id === cardId);
  if (!card) return '';
  
  const fileName = card.markdownFile || `card${card.order}.md`;
  
  try {
    const modules: Record<string, () => Promise<{ default: string }>> = {
      'setup-card1': () => import('../content/topics/setup/card1.md?raw'),
      'setup-card2': () => import('../content/topics/setup/card2.md?raw'),
      'api-config-card1': () => import('../content/topics/api-config/card1.md?raw'),
      'api-config-card2': () => import('../content/topics/api-config/card2.md?raw')
    };
    
    const key = `${topicId}-${fileName.replace('.md', '')}`;
    if (modules[key]) {
      const module = await modules[key]();
      return module.default;
    }
    return '';
  } catch {
    return '';
  }
}

let localeCache: Record<string, Locale> = {};

export async function loadLocale(lang: SupportedLocale): Promise<Locale> {
  if (!localeCache[lang]) {
    try {
      const modules: Record<string, () => Promise<{ default: Locale }>> = {
        'en': () => import('../content/locales/en.json?url'),
        'zh-CN': () => import('../content/locales/zh-CN.json?url'),
        'fr': () => import('../content/locales/fr.json?url')
      };
      
      if (modules[lang]) {
        const module = await modules[lang]();
        const response = await fetch((module.default as unknown) as string);
        localeCache[lang] = await response.json();
      } else {
        localeCache[lang] = localeCache['en'] || {} as Locale;
      }
    } catch {
      localeCache[lang] = localeCache['en'] || {} as Locale;
    }
  }
  return localeCache[lang];
}
