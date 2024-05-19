const plugin = require('tailwindcss/plugin')
const platforms = [['Windows', 'win'], ['Unix', 'linux'], ['OSX', 'osx'], ['Browser', 'bro'], ['WindowsLegacy', 'owin']]
const sidebarStates = [['hidden', 'zen']]

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './**/*.html'
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
  ] 
}
