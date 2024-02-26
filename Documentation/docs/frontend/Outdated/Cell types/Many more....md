---
sidebar_position: 22
---
You can extend output cell types via a few lines of code and you favorite framework / package

:::info
Please, see [Known packages](../Development/Plugins/Known%20packages.md) page __for more information__
:::

#### Mermaid
__[Github repo](https://github.com/JerryI/wljs-mermaid-support)__
Draw beautiful diagrams by code 
```bash
.mermaid
pie title NETFLIX
         "Time spent looking for movie" : 90
         "Time spent watching it" : 10
```

![](../../../imgs/Screenshot%202023-03-31%20at%2016.01.28.png)

##### SVG Art

:::warning
This plugin is not shipped together with WLJS Frontend. One need to install it manually from Github repo
:::

__[Github repo](https://github.com/JerryI/wljs-svgbob-support)__
This feature was added mostly for fun. If you like to draw using symbols, you should definitely try a new creating - [SVGBob](https://github.com/ivanceras/svgbob). Written in Rust and packed as a WASM module

```shell
.svgbob
--------->
```

![](../../../imgs/Screenshot%202023-03-31%20at%2015.59.37.png)

