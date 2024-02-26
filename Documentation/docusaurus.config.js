// @ts-check
// `@type` JSDoc annotations allow editor autocompletion and type checking
// (when paired with `@ts-check`).
// There are various equivalent ways to declare your Docusaurus config.
// See: https://docusaurus.io/docs/api/docusaurus-config

import {themes as prismThemes} from 'prism-react-renderer';


const math = require('remark-math');
const katex = require('rehype-katex');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'WLJS Notebook',
  tagline: 'Documentation',
  favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: 'http://127.0.0.1',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'JerryI & KirillBelovTest', // Usually your GitHub org/user name.
  projectName: 'wljs-notebook', // Usually your repo name.

  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },
  markdown: {
    mermaid: true,
  },
  themes: ['@docusaurus/theme-mermaid'],

  stylesheets: [
    {
      href: 'https://cdn.jsdelivr.net/npm/katex@0.12.0/dist/katex.min.css',
      type: 'text/css',
      integrity:
        'sha384-AfEj0r4/OFrOo5t7NnNe46zW/tFgW6x/bCJG8FqQCEo3+Aro6EYUG4+cU+KJWu/X',
      crossorigin: 'anonymous',
    },
  ],

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: './sidebars.js',
          remarkPlugins: [math],
        rehypePlugins: [katex],

        exclude: ['/docs/Excalidraw', 'Excalidraw', '/blog', '/docs/imgs'],

        showLastUpdateTime: true,
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      }),
    ],
  ],
  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      remarkPlugins: [math],
      rehypePlugins: [katex],
      // Replace with your project's social card
      navbar: {
        title: 'WLJS',
        logo: {
          alt: 'WLJS Notebook',
          src: 'img/logo3.svg',
          srcDark: "img/logo2.svg"
        },
        items: [
          {
            type: 'docSidebar',
            sidebarId: 'tutorialSidebar',
            position: 'left',
            label: 'Notebook',
          },
          {to: "https://github.com/JerryI/wl-wlx/discussions", label: "Discuss", style: {"border": 0, "border-radius": "6px"} , position: 'right'},
          {
            href: 'https://github.com/JerryI/wl-wlx',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                label: 'Docs',
                to: '/docs/WLX/install',
              },
            ],
          },
          {
            title: 'Community',
            items: [
              {
                label: 'Twitter',
                href: 'https://twitter.com/docusaurus',
              },
            ],
          },
        ],
        copyright: `WLX Project is open-source and licensed under GPL3`,
      },
      prism: {
        theme: prismThemes.github,
        darkTheme: prismThemes.dracula,
        additionalLanguages: ['wolfram']

      },
      markdown: {
        mermaid: true,
      },
      themes: ['@docusaurus/theme-mermaid'],

      
    }),
    plugins: [[ require.resolve('docusaurus-lunr-search'), {
      disableVersioning: true
    }]]
};

export default config;
