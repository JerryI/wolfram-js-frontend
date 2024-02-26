---
sidebar_position: 1
---
# How it works

## The idea
Originally it was done as a sort of [utility](https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine) to parse Graphics3D objects and recreate them as a set of commands of ThreeJS - a JS graphics library. Have a look at this example

```mathematica
SphericalPlot3D[1, {t, 0, Pi}, {p, 0, 2 Pi}] // InputForm
```

it produces the following output

```mathematica
Graphics3D[{
	GraphicsComplex[{{1,0,0}, ...}, {
...
	Polygon[{{2, 1, 11, 12}, ...}}]
}]
```

where, in principle it tells us that one should plot polygons using the set of 4 vertices indexed as `2,1,11,12` with absolute coordinates stored in an array located in the first argument of `GraphicsComplex`.

### Internal representaion
A good hint how the internal data structure looks like can be seen in [Compress](https://mathematica.stackexchange.com/questions/104660/what-algorithm-do-the-compress-and-uncompress-functions-use). See also [mma-uncompress](https://github.com/JerryI/uncompress).

### Parser
Taking advantage of the standart library packed with Wolfram Kernel we can use directly a `ExportString` function

```mathematica
ExportString[%, "ExpressionJSON"]
```

```js
[
	"Graphics3D",
	[
		"List",
		[
			"List",
			[
				"GraphicsComplex",
				[
					"List",
					[
						"List",
							0.0,
							0.0,
							1.0
						]
,
```

In principle it can convert an arbitary WL expression without loosing any data. Which is acually much faster, than `ToString` method

```mathematica
test = SphericalPlot3D[Sin[t] Cos[p]^6, {t, 0, Pi}, {p, 0, 2 Pi}][[1]];

((s = ExportString[test, "ExpressionJSON"]) // RepeatedTiming)[[1]]
((s = ToString[test]) // RepeatedTiming)[[1]]

> 0.03471
> 0.16478
```

that gives us a clue, where the internal Mathematica's expressions representation might be a sort of `ExpressionJSON` like structure
  
```mathematica
(a+b)[[0]] === Plus
```

i.e., the structure is following

```js
this.name = expr[0]
this.args = expr.slice(1, expr.length)
```

Then it looks relatively easy to use it for calling a defined function

```js
var core = {};
var interpretate = (d, env) => {
	if (typeof d === 'string')
		return d.slice(1, -1);
		
	if (typeof d === 'number') 
		return d;

	this.name = d[0];
	this.args = d.slice(1, d.length);
	return core[this.name](this.args, env);
}
```

threfore one can define a minimal set of functions to serve WL expressions like lists, colors, and etc...

```js
core.List = (args, env) => {
	const copy = {..env};
	const list = [];
	for (let i = 0, len = args.length; i < args.length; i++) {
		list.push(interpretate(args[i], copy));
	}
	return list;
};
```

```js
core.RGBColor = (args, env) => {
	const r = interpretate(args[0], env);
	const g = interpretate(args[1], env);
	const b = interpretate(args[2], env);
	env.color = new three.Color(r, g, b);
};
```

The second argument `env` is a mutable object, which stores information to be shared with other WL expressions, for example color

```mathematica
{Blue, {Red, Sphere[] (*RED*)}, Cuboid[] (*BLUE*)}
```

Here you can see, that `env` can be localized (a deep copy) inside `List` expression.

## Generalization
For me as a maintener of this project @JerryI, the idea of bridging JS and Wolfram Language was very insiprational. Especcially, when I discovered how flexible and easy was the writting static and dynamic web-pages using Wolfram Language - [TinyWEB & WSP](https://github.com/JerryI/tinyweb-mathematica).

The reason
*somewhere on HTML page*
```html
<input type="text" id="form" value="Hello!">
<script>
	core.UpdateText = (args, env) => {
		const i = interpretate(args[0], env);
		document.getElementById('form').value = i;
	}
</script>
```

*somewhere in WL*
```mathematica
WebSocketBroadcast[server, UpdateText[RandomWord[]]]
```

using websockets to link Wolfram Kernel and a page in realtime the intergration looks seamless. In principle, the API and all UI functions are implemented in a such way on the present version of Wolfram JS Frontend.

> In the present version the interpreter looks a bit more complex, however the ideas are the same.

