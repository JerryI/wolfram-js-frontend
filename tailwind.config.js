const plugin = require('tailwindcss/plugin')
const platforms = [['Windows', 'win'], ['Unix', 'linux'], ['OSX', 'osx'], ['Browser', 'bro'], ['WindowsLegacy', 'owin']]
const sidebarStates = [['hidden', 'zen']]

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './**/*.wlx',
    './wljs_packages/wljs-inputs/src/kernel.js'
  ],
  theme: {
    extend: {
      // ...
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/container-queries'),  
    plugin(({ addVariant }) => {
      platforms.forEach((platform) => {
        addVariant(`${platform[1]}`, `[os="${platform[0]}"] &`)
      })
    }),
    plugin(({ addVariant }) => {
      sidebarStates.forEach((s) => {
        addVariant(`${s[1]}`, `[sidebar="${s[0]}"] &`)
      })
    }),    
  ],
  safelist: [
    'text-2xl',
    'text-3xl',
    'text-red-300',
    'table-auto',
    'flex-row-reverse',
    'border-spacing-x-0.5',
    'bg-teal-400',
    '-ml-2',
    '-ml-1',
    "bg-teal-500/15",
    "text-green-500",
    "hover:text-green-300",
    'bg-teal-300',
    'text-red-500',
    'ring-green-600/20',
    'bg-green-50',
    'ring-green-600/20',
    'bg-red-50',
    'text-red-700',
    'ring-red-600/20',
    'hover:text-red-300',
    'hover:bg-teal-400', 
    {
      pattern: /columns-.*/,
    }     
  ]  
}
