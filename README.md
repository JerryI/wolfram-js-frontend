## Wolfram Engine JS Frontend
*the synergy of web technologies and symbolic computations*
This is a minimalistic, opensource, portable and lightweight notebook interface with syntax sugar, interactive objects built for freeware __Wolfram Engine__

![](imgs/ezgif.com-crop.gif)

### Motivation
The idea is to implement a minimalistic, opensource, portable and lightweight notebook interface with syntax sugar, interactive objects for freeware Wolfram Engine, which can be easily extended to any user's defined functions and exported as a standalone `.html` application. __There is no aim to copy Mathematica__ (it will never be possible), but make the notebook interface in a different and unique way relying on the web-technology stack with its own features.

The target community can probably divided by two groups
- who like and can write in Javascript and Mathematica
- who uses Jypiter with Wolfram Language and needs *much more* features

#### Crossplatform
The frontened is an HTTP & Websockets server, which runs locally on your PC and the notebook interface built from opensource components is entirely in your browser. Which also makes possible to do all work remotely attaching different wolfram kernels to the notebook.

#### Performance
Web technologies nowadays are aimed to be extremely efficient in order to compete with a native desktop applications. Therfore we are using classical HTML5 + JS stack to brind life to UI and all graphical objects by recreating some of Mathematica's function using `plotly.js`, `d3.js` and `Three.js` (add your own one! this is easy) libraries. 

#### Flexibillity
Want to make fancy WebGl RTX animated figures of your brilliant calculaltions? Sure! - Use modern stack of __Javascript__ and `three.js` or any other framework you like, by typing `.js` in the beginning of a cell or write your own Wolfram Language function and attach it to the core library. 

Several data transfer method between Wolfram Kernel and Javascript are already implemented. __HTML__, __Markdown__ cells are the part of frontened. You can define your own evaluators kernels (processors) and add new languages used in frontened.

Built-in Wolfram Language JS engine will serve the purpose by interpreting Wolfram expressions in your browser.

Edit the CSS files and make your own look you like more, or do it in a runtime from the cells using well-known and well-documented HTML/JS/CSS technics.

#### Control
Runtime, evaluators are not black boxes, you can edit everyhting and make it work in a way you like. Everyhting is splitted into modules, which can be reused somewhere else. 

In principle, one can perform hetero-calculations, splittting your code between parts evaluated on the frontned and backend to optimize the perfomance.

> The project is in __alpha stage__, some features might be changed. Some experimental features can be buggy. Check your browser's console

## How to install/test
This is quite simple. All that you need is

- Freeware WolframEngine
- NodeJS (only for devs)

the rest will be downloaded via the internet. Then `cd` to the project folder and

```shell
git clone --branch indev https://github.com/JerryI/wolfram-js-frontend
cd wolfram-js-frontend
npm i
wolframscript -f Scripts/dev.wls
```

Wait until the bundle will be finished and open your browser with `http://127.0.0.1:8090`

There is a `Introduction` notebook, which shows most gems...

### Cell types
- Wolfram Language
- Markdown
- Javascript (with DOM)
- HTML
- *define your own type or language extension*

### Supported features
#### Syntax sugar
- greek symbols
- autocomplete

#### Graphics
- `Graphics3D` without styling, axes and etc. see [repo](https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine)
- `SVGForm`, `HTMLForm` to show any objects as the corresponding forms
- `Plotly` interactive replacement to `Plot`
- `ListLinePlotly` replacement for `ListLinePlot`
- `ListPlotly`
- `RequestAnimationFrame` method for real-time animated graphics

#### Input
- editable output cells
- inline graphical objects (as a single symbol)
- truncated output for the large data (no actual data transfer happens)



