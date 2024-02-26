---
sidebar_position: 1
title: ''
---

<h1 style={{'text-align': 'center'}}>Minimal Wolfram Language Interpreter</h1>
<div style={{'text-align': 'center'}}>

***written in Javascript***

</div>
<h4 style={{'text-align': 'center'}}><a href="https://github.com/JerryI/wljs-interpreter">Github repository</a> of the project</h4>

:::note
This code is executing in your browser now
:::


<iframe style={{border: 'none', 'border-radius': '10px', width: '100%', height: '100%', 'min-height': '500px'}} src="https://jerryi.github.io/wljs-interpreter/?example=boat.txt&logs=false&full=true"></iframe> 

This project is originally a base for `Graphics3D` to [ThreeJS converter](https://mathematica.stackexchange.com/a/215025/53728) that interprets the results produced by Wolfram Kernel (Wolfram Engine, Mathematica) using the same symbolic expressions for functions, procedures and plots the results using Javascript. Later on it became in integral part of Web Applications framework such as WLX and WLJS Notebook aka Frontend.

It was generalized to a standalone interpreter that works in the browser and acts like a bridge between Javascript world and Wolfram Language.

:::info

This is not meant for the heavy computations, pattern matching is missing as well as an entire standard library.

:::

*Symbolic computing is not possible*
*Only `JSONExpression` format is supported* 

## Quick start
To run a sandbox you need to have only `wolframscript`, `nodejs` and any modern browser installed

:::caution
Wolfram Kernel only runs HTTP server and provides the transpiling from WL language syntax to JSON representation, since __there is no freeware WL parser on the internet so far__. All computations happens inside your browser
:::

```bash
git clone https://github.com/JerryI/wolfram-js-frontend
cd wljs-interpreter
npm i
npm start
wolframscript -f transpile.wls
```

A page similar to one at the top will pop up (with a boat). Then you can freely edit the code and any changes will be shown on the right.

### Using as a standalone interpreter
Load as a script to the HTML page using CDN. The core components is less than 10kb

```html
<script type="module" src="https://cdn.statically.io/gh/JerryI/wljs-interpreter/main/src/interpreter.js"></script>
<script type="module" src="https://cdn.statically.io/gh/JerryI/wljs-interpreter/main/src/core.js"></script>
```

To run the code it uses JSON format to represent WL expressions

```js
interpretate(["Print", "'Hello World!'"], {})
```

You have an access to global context using `core` object. The list of defined functions can be seen by calling `core` in the browser's console.

The core context can be expanded by simply putting this core in any place in the page. No class definition of imports are needed

```js
window.onload = () => {
	core.MyFunction = async (args, env) {
		alert('Called! with ' + args[0]);
	}
}
```

The wrapper `onload` is only needed to make sure that the page with all scripts was fully loaded. Then you can call it naturally

```js
interpretate(["MyFunction", "'whatever'"], {})
```

## Extensions

The interpreter provides only the minimum-necessary set of functions, to bring `Graphics` and `Graphics3D` (or if you are using [Wolfram JS Frontend](https://github.com/JerryI/wolfram-js-frontend) you need set of sliders and other building blocks for GUI) you should consider to use it together with the following packages

- [wljs-graphics-d3](https://github.com/JerryI/wljs-graphics-d3) (see Docs here)
- [wljs-graphics3d-threejs](https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine) (see Docs here)

Just simply include `dist/kernel.js` file into the web-page as a module using CDN (JSDelivr, StaticIO). Some of [build-in examples](#Quick%20start) already uses those packages. NO installation needed.

### Applications
The animation running on [Wolfram Conference St. Piter 2023](https://wolfram-language-russian-conference.github.io) website was made using this interpreter. The overall overhead for Javascript engine is relatively small, since it relies on the plain JS objects as an internal data structure.

In a combination with web sockets a web platform for processing and storing experimental data from THz spectrometers was made in [Augsburg University](https://www.uni-augsburg.de/en/) (link is not available, since this is internal application).

<iframe
  style={{ margin: "auto" }}
  width={560}
  height={315}
  src="https://www.youtube.com/embed/S_qANSuhVH0"
  title="YouTube video player"
  frameBorder={0}
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
  allowFullScreen=""
/>

## Partial support of the native WL expressions

There is no aim to recreate all Wolfram Language functions, you can think about this interpreter more like as a bridge between `Javascript` ecosystem and `Wolfram Language`. The interpreter can easily be expanded via packages or explicitly defined functions inside the HTML page. One can write your own symbols based on the application you have.

__To help maintain this project__ 

[kirill.vasin@uni-a.de](https://www.paypal.com/donate/?hosted_button_id=BN9LWUUUJGW54) [PayPal](https://www.paypal.com/donate/?hosted_button_id=BN9LWUUUJGW54) 

Thank you 🍺
