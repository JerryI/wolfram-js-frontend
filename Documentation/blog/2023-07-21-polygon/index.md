---
slug: practical-working-withlibs
title: Developing library function in a notebook
authors: jerryi
tags:
  - frontend
  - devnotes
enableComments: true
draft: true
---






In general, libraries shipped with WLJS Frontend are not reproducing even 20% of Mathematica's dynamic or graphics functions. Therefore, it is not a big deal to come back quite frequently to the source code of [wljs-graphics-d3](https://github.com/JerryI/wljs-graphics-d3) or [wljs-graphics3d-threejs](https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine) to write a polyfill or design a completely new feature to support backward compatibility.  

Luckily, since it is all running in a browser, we can take an advantage of using Javascript cells directly to build the missing functions. 

:::tip
There is no need in rebuilding libraries or compiling the source code of the library or plugin (or refreshing the browser's window) to make a prototype of a feature. 

Use `.js` cells in the notebook for that.
:::

<!--truncate-->

Here we will have a look at `Polygon` in the context of 2D graphics. Here is my (@JerryI, maintainer) dev-notes on that





Here is the original notebook
- [Cinematographer.wln](Cinematographer.wln)

Thanks for reading! Hope it helps ;)