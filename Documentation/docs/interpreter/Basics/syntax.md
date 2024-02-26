---
sidebar_position: 1
---
# Syntax
For the simplicity it is better to use `wolframscript` or Mathematica to [transpile](../intro.md) the source code to `JSONExpression` format using `ExportString` command.

:::tip
The parsing from WL expressions to `JSONExpression` can be done automatically using [WLJS Playground](../intro.md) (see *Quick start*)
:::

The raw syntax is dictated by this format

- symbols `"Print"`, `"While"` ... - double quotes
- numbers `1.003`, `-33.0` - no quotes
- strings `"'Hello World'"` - double and single quotes
- functions / symbols with arguments inside `["Print", "'Hello'"]` - wrapped as array elements

Example
```mathematica
Print["Hello World"];
i = RandomReal[{-1, 1}];
Alert[i];
```

```js
	[
		CompoundExpression,
		[
			Print,
			"'Hello World'"
		],
		[
			Set,
			i,
			[
				RandomReal,
				[
					List,
					-1,
					1
				]
			]
		],
		[
			Alert,
			i
		],
		null
	]
```

## Libraries
The interpreter provides only the minimum-necessary set of functions, to bring `Graphics` and `Graphics3D` (or if you are using [Wolfram JS Frontend](https://github.com/JerryI/wolfram-js-frontend) you need set of sliders and other building blocks for GUI) you should consider to use it together with the following packages

- [wljs-graphics-d3](https://github.com/JerryI/wljs-graphics-d3) (see Docs here)
- [wljs-graphics3d-threejs](https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine) (see Docs here)

Just simply include `dist/kernel.js` file into the web-page as a module using CDN

```html
<script type="module" src="https://cdn.statically.io/gh/JerryI/wljs-interpreter/main/src/interpreter.js"></script>
```