import { mdsvex, escapeSvelte } from 'mdsvex';
import remarkUnwrapImages from 'remark-unwrap-images';
import remarkToc from 'remark-toc';
import rehypeSlug from 'rehype-slug';

import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import { bundledLanguages, createHighlighter } from 'shiki/bundle/web';

const highlighterPromise = createHighlighter({
  themes: ['vesper'],
  langs: Object.keys(bundledLanguages)
});

/** @type {import('mdsvex').MdsvexOptions} */
const mdsvexOptions = {
  extensions: ['.md'],
  layout: {
    _: './src/mdsvex.svelte'
  },
  highlight: {
    highlighter: async (code, lang = 'text') => {
      // Reuse the same highlighter instance
      const highlighter = await highlighterPromise;
      const html = escapeSvelte(
        highlighter.codeToHtml(code, {
          lang,
          theme: 'vesper'
        })
      );
      return `{@html \`${html}\` }`;
    }
  },
  remarkPlugins: [remarkUnwrapImages, [remarkToc, { tight: true }]],
  rehypePlugins: [rehypeSlug]
};

export { mdsvexOptions };

/** @type {import('@sveltejs/kit').Config} */
const config = {
  // Consult https://kit.svelte.dev/docs/integrations#preprocessors
  // for more information about preprocessors
  preprocess: [vitePreprocess(), mdsvex(mdsvexOptions)],

  extensions: ['.svelte', '.md'],

  kit: {
    // Using static adapter for GitHub Pages / Codeberg Pages deployment
    adapter: adapter({
      pages: 'build',
      assets: 'build',
      fallback: undefined,
      precompress: false,
      strict: true
    })
  }
};

export default config;
