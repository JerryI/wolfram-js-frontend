
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
A good hint how the internal data structure looks like can be seen in [Compress](https://mathematica.stackexchange.com/questions/104660/what-algorithm-do-the-compress-and-uncompress-functions-use)

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
					["List",
						0.0,
						0.0,
						1.0
					]
					,
```

In principle it can convert an arbitary WL expression without loosing any data. Which is acually much faster, than `ToString` method

```mathematica
test = SphericalPlot3D[
    Sin[t] Cos[p]^6, {t, 0, Pi}, {p, 0, 
     2 Pi}][[1]];
     
((s = ExportString[test, "ExpressionJSON"]) // RepeatedTiming)[[1]]
((s = ToString[test]) // RepeatedTiming)[[1]]

0.03471
0.16478
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
	if (typeof d === 'string') {
		return d.slice(1, -1);
	}
	if (typeof d === 'number') {
		return d;
	}
	this.name = d[0];
	this.args = d.slice(1, d.length);
	return core[this.name](this.args, env);
}
```

threfore one can define a minimal set of functions to serve WL expressions like lists, colors, and etc...

```js
core.List = (args, env) => {
	let copy, i, len, list;
	list = [];
	copy = Object.assign({}, env);
	
	for (i = 0, len = args.length; i < len; i++) {
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

For me as a maintener of this project @JerryI, the idea of bridging JS and Wolfram Language was very insiprational. Especcially, when I discovered how flexible and easy was the writting static and dynamic web-pages using Wolfram Language - [TinyWEB & WSP](). 

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

using websockets to connect Wolfram Kernel and a page in realtime the ==intergration looks seamless==. In principle, the API and all UI functions are implemented in a such way on the present version of Wolfram JS Frontend.

==The separation on modules / packages was not done on purpose== to make it straight and simple - definning any kind of function anywhere on the page / whatever.

By the default JS script interprets everything that arrives via websockets using `interpretate(json, env)`, therefore for the creation of notebook cells it uses the Wolfram-like function `FrontEndCreateCell[]`. 

## Features

In the present version the interpreter looks a bit more complex, however the ideas are the same. You can have a look at the implementation

```shell
JSFrontend/interpreter.js
```

Let us the most essential parts

### Symbol definition
For more information see detailed docs - [Frontend functions](Frontend%20functions.md), in general the rule is

```js
context.Symbol = (arguments, env) => {
	//evaluating arguments
	const a = interpretate(arguments[0], env);
	//body
	some calculations
	//may return or not
	return result;
}
```

### Contextes
To prevent the mess of duplicated function names and etc, you can specify the context or let's say library of symbols using

```js
var library = {};
interpretate.extendContext(library);

library.Symbol = (args, env) => {/*...*/}
```

The interpreter will check all available contextes and find the first match. However, you ==can prioritize the context== providing the information in `env` object

```js
core.GrandSymbol = (args, env) => {
	const data = interpretate(args, {...env, context: library});
	//...
}
```

More about `env` object is here [Meta Data](#Meta%20Data).

In the same manner the separation between `Line[]` used in `Graphics3D` and in `Graphics` functions was made.

### Meta Data
To share some data between functions, to use local and global memory of the executable objects (see [Frontend objects](Frontend%20objects.md)), specifying methods of evaluation and DOM access the following object is provided

```js
env = {
	element: document.element, /* a Code Mirror widget */

	context: core,             /* default context      */
							   /* subsymbol            */
	method:  undefined | 'update' | 'destory',
	
	/* global and local memory of front-end objects*/
	local: {},
	global: {},

	numerical: false,          /* keep symbolic or not */
	hold: false                /* keep exps in a List  */
	/* anything you want to share */
	...
}
```

I highlighted only the most usable for now, in principle the most influence to the process of interpreting have
- `context` - prioritises the context to fetch the symbol to evaluate. See section [Contextes](#Contextes)
- `method` - it is ment to specify a sub-symbol for the whole three of WL expression (or in practice so-called method of interpreting)

The rest is described here [Frontend objects](Frontend%20objects.md).

#### Methods | Sub symbols
- `undefined` (leave empty)
- `update`
- `destroy`

The following subsymbols can be defined as

```js
core.MySymbol         = (args, env) => {}
core.MySymbol.update  = (args, env) => {}
core.MySymbol.destory = (args, env) => {}
```

You can think about it if it was a class definition with a constructor and several methods.

For the sake of perfomance, when something changes with the data inside the plot, there is no need to reevaluate the whole tree of WL expressions. Therefore, we can specify the method of reevaluation

```js
//to create a plot
core.ListLinePlotly = (args, env) => {
	...
	Plotly.newPlot(env.element, data)
}

//to update only the data
core.ListLinePlotly.update = (args, env) => {
	...
	Plotly.restyle(env.element, newdata)
}
```

Then, in the update function we can specify the "method"

```js
core.UpdatePlot = (args, env) => {
	...
	interpretate(exprThree, {...env, method:'update');
}
```

In principle, interpreter has no idea about what `update` and etc means, one can write any "method", which is basically just a subsymbol. 

The update of expressions, when something changes is already automatised using a separate type of objects - see [Frontend objects](Frontend%20objects.md)

`destroy` method is used, when `Graphics3D` object has removed from the editor

```js
core.Graphics3D.destroy = (args, env) => {
	cancelAnimationFrame(env.local.aid);
	//to cancel the animation
}
```

To read about it more - see [Frontend functions](Frontend%20functions.md)

#### DOM
When the WL expressing is called via `FrontEndExecutable` on editor's side it automatically creates a placeholder DOM element and provides it to `env` variable. I.e. all graphical objects appends the content to

```js
core.Canvas = (args, env) => {
	const canvas = document.createElement('canvas');
	env.element.append(canvas);
	//....
}
```


#### Global and local memory
It is realted to [Frontend objects](Frontend%20objects.md), where the functions can store the data associated with its instance. 

- `env.global` is visible to all `FrontEndExecutable` and its inner WL expressions, where `env.global.stack` contains the call-tree
- `env.local` is isolated memeory related to individual `FrontEndExecutable` or virtual functios.



