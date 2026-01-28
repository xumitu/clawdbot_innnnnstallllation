import type { Topic, Locale, SupportedLocale } from '../types';
import { get } from 'svelte/store';
import { theme } from '../stores/theme.store';

const topicCache = new Map<string, Topic>();
const markdownCache = new Map<string, string>();

const topicModules: Record<string, () => Promise<{ default: unknown }>> = {
  setup: () => import('../content/install/setup/index.json?url'),
  'api-config': () => import('../content/install/api-config/index.json?url'),
  'quick-start': () => import('../content/install/quick-start/index.json?url')
};

const examplesTopicModules: Record<string, () => Promise<{ default: unknown }>> = {
  setup: () => import('../content/examples/setup/index.json?url'),
  'api-config': () => import('../content/examples/api-config/index.json?url'),
  'quick-start': () => import('../content/examples/quick-start/index.json?url')
};

export async function loadTopics(): Promise<Topic[]> {
  const currentTheme = get(theme);
  const contentDir = currentTheme === 'examples' ? 'examples' : 'install';
  const topics = ['setup', 'api-config', 'quick-start'];
  const loaded: Topic[] = [];
  const modules = currentTheme === 'examples' ? examplesTopicModules : topicModules;
  
  topicCache.clear();
  
  for (const topicId of topics) {
    const cacheKey = `${contentDir}-${topicId}`;
    if (!topicCache.has(cacheKey)) {
      try {
        const module = await modules[topicId]();
        const response = await fetch((module.default as string));
        topicCache.set(cacheKey, await response.json());
      } catch (e) {
        console.error(`Failed to load topic ${topicId} from ${contentDir}:`, e);
      }
    }
    const topic = topicCache.get(cacheKey);
    if (topic) loaded.push(topic);
  }
  
  return loaded.sort((a, b) => a.order - b.order);
}

export async function loadMarkdown(topicId: string, cardId: string): Promise<string> {
  const currentTheme = get(theme);
  const contentDir = currentTheme === 'examples' ? 'examples' : 'install';
  const cacheKey = `${contentDir}-${topicId}-${cardId}`;
  
  if (markdownCache.has(cacheKey)) {
    return markdownCache.get(cacheKey)!;
  }
  
  const topic = topicCache.get(`${contentDir}-${topicId}`);
  const card = topic?.cards.find(c => c.id === cardId);
  if (!card) return '';
  
  const fileName = card.markdownFile || `card${card.order}.md`;
  
  try {
    const modules: Record<string, () => Promise<{ default: string }>> = {
      [`install-setup-card1`]: () => import('../content/install/setup/card1.md?raw'),
      [`install-setup-card2`]: () => import('../content/install/setup/card2.md?raw'),
      [`install-api-config-card1`]: () => import('../content/install/api-config/card1.md?raw'),
      [`install-quick-start-card1`]: () => import('../content/install/quick-start/card1.md?raw'),
      [`examples-setup-card1`]: () => import('../content/examples/setup/card1.md?raw'),
      [`examples-setup-card2`]: () => import('../content/examples/setup/card2.md?raw'),
      [`examples-api-config-card1`]: () => import('../content/examples/api-config/card1.md?raw'),
      [`examples-quick-start-card1`]: () => import('../content/examples/quick-start/card1.md?raw')
    };
    
    const key = `${contentDir}-${topicId}-${fileName.replace('.md', '')}`;
    if (modules[key]) {
      const module = await modules[key]();
      markdownCache.set(cacheKey, module.default);
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
        'zh-CN': () => import('../content/locales/zh-CN.json?url')
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