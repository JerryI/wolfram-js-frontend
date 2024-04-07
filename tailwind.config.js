const plugin = require('tailwindcss/plugin')
const platforms = [['Windows', 'win'], ['Unix', 'linux'], ['OSX', 'osx'], ['Browser', 'bro'], ['WindowsLegacy', 'owin']]

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './**/*.wlx'
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
  ],
  safelist: [
    'text-2xl',
    'text-3xl',
    'text-red-300',
    'table-auto',
    'border-spacing-x-0.5',
    'bg-teal-400',
    "bg-teal-500/15",
    "text-green-500",
    "hover:text-green-300",
    'bg-teal-300',
    'text-red-500',
    'hover:text-red-300',
    'hover:bg-teal-400', 
    {
      pattern: /columns-.*/,
    }     
  ]  
}
