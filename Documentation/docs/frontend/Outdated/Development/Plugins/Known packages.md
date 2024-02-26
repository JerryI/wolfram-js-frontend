---
sidebar_position: 1
---

:::note
Here the symbol 🔶 means, that the package is shipped together with a basic WLJS Frontend distribution. Anything else can be installed separately from the `Settings` menu
:::
### Core packages
Independent from WLJS Frontend
- [wljs-interpreter](https://github.com/JerryI/wljs-interpreter) - [Javascript interpreter](../../../../interpreter/intro.md) of Wolfram Language 🔶
- [wljs-editor](https://github.com/JerryI/wljs-editor) - input/output cell editor for Wolfram Language with syntax sugar and etc 🔶

Can be used only together with WLJS Frontend
- [wljs-cells](https://github.com/JerryI/wljs-cells) - a cell container and manager. Contains all UI of the frontend and logic 🔶

### UI Elements
Can be used independently
- [wljs-inputs](https://github.com/JerryI/wljs-inputs) - sliders, checkboxes and etc. 🔶

### Graphics
Can be used independently
- [wljs-graphics-d3](https://github.com/JerryI/wljs-graphics-d3) - a package for 2D graphics 🔶
- [wljs-graphics3d-threejs](https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine) - a package for 3D graphics 🔶
- [wljs-plotly](https://github.com/JerryI/wljs-plotly) - a separate package for 2D plots based on Plotly 🔶

### Extensions for the editor
- [wljs-html-support](https://github.com/JerryI/wljs-html-support) - HTML type cells. Allows to write plain HTML + CSS and mix/generate it using Wolfram Language 🔶
- [wljs-js-support](https://github.com/JerryI/wljs-js-support)- Javascript type cells. Allows to write in JS and run the code in the output cell. This is extremely powerful tool, since there is no sandbox and a user can affect the way how frontend work. 🔶
- [wljs-esm-support](https://github.com/JerryI/wljs-esm-support) - similar to JS cells, but uses NodeJS and ESBuild to bundle files and allows to use `imports` for packages and local files.
- [wljs-chatbook-support](https://github.com/KirillBelovTest/wljs-chatbook-support) - adds LLM cel type, that uses Open AI GPT language model to bring AI assistant 🔶
- [wljs-markdown-support](https://github.com/JerryI/wljs-markdown-support) - a well-known language used as the second after WL for comments, equations, embedding pictures and etc. 🔶
- [wljs-mermaid-support](https://github.com/JerryI/wljs-mermaid-support) - a Mermaid language used for coding diagrams 🔶
- [wljs-magic](https://github.com/JerryI/wljs-magic-support)- an extension used for fast file importing into the cell as well as exporting 🔶
- [wljs-wlx-support](https://github.com/JerryI/wljs-wlx-support) - adds Wolfram Language XML cell type, where a user can write in a [superset language](../../../../wlx/basics.md), that allows to decorate data, use component approach and etc 🔶
- [wljs-revealjs](https://github.com/JerryI/wljs-revealjs) - makes possible to make presentations using WL and Markdown/HTML/WLX languages. 🔶
- [wljs-dev-tools](https://github.com/JerryI/wljs-dev-tools) - make possible to use the frontend kernel (master kernel) to evaluate cells. Comes useful while debugging plugins 🔶
- [wljs-hydrator](https://github.com/JerryI/wljs-hydrator) - a precursor to WLX, currently unmaintained.
- [wljx-svgbob-support](https://github.com/JerryI/wljs-svgbob-support) - adds ASCII-SVG language support that transforms symbols into SVG graphs.

### Global
Affects the entire frontend, involving menus, key-bindings and etc
- [wljs-snippets](https://github.com/JerryI/wljs-snippets) adds snippets to the frontend 🔶

### Themes
soon!

### Template
- [wljs-template](https://github.com/JerryI/wljs-template) a template for writing plugins