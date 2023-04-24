If you use Mathematica quite often, you might probably familliar with `MakeBoxes` interface, where you can make a fancy representation for the symbolic expressions

🚧  **Warning this chapter is in early development** 

## Low-level implementation

For example, you have an object like this
`
```mathematica
Mesh[<|"vertices", "polygons"->...|>]
```

And you want to make a nice representation of it in the cell. Since to all cell's output expressions the operation `CM6Form` is applied (see [Evaluation](Evaluation.md), [WLJS Interpreter](WLJS%20Interpreter.md)) you can write it directly 

```mathematica
CM6Form[Mesh[assoc_]] ^:= CreateFrontEndObject[Mesh[assoc_], "may be an id"]
```
For example `Slider` is implemented in a simmilar a way.

It is important to note, that there is no postprocessing preformed, since afterwards we want to use it if it was just a `Mesh`, i.e.

```mathematica
FrontEndExecutable["may be an id"] === Mesh[...] === True
```
For `Slider` object it wont work, since the posprocessing is applied.

Then all magic has to happend in JS. You need to define the corresponding function in pure JS

```js
.js
core.Mesh = (args, env) => {
	env.element //draw something
}
core.Mesh.update => {}
core.Mesh.destroy => {}
```



To read about it in more details, please see [Frontend functions](Frontend%20functions.md) and [Frontend objects](Frontend%20objects.md). 
It principle it gives you much more flexibillity, but is also harder to do.

#### Example


## High-level | Easy
Since it is about Wolfram Language we need something better. Therefore you can use build-in helper function

```mathematica
CreateFrontEndView[symbolHead, viewFunction];
```

What it does

```mathematica
CM6Form[symbolHead[any__]] ^:= 
CreateFrontEndObject[	
	FrontEndViewWrapper[symbolHead[any], viewFunction@(symbolHead[any])]
];
```

where

```mathematica
FrontEndView[a_,post_] := a;
```

Therefore, when we make an output to the cell, it automatically provides both the original version and postprocessed one, which is going to be use on fronend

```js
core.FrontEndView = (args, env) => {
	interpretate(args[1], env);
}
```

Then one can sumply put any graphical function into `viewFunction` as ease.

```mathematica
CreateFrontEndView[Mesh, Function[mesh, Graphics3D[Polygons[mesh]]]];
```

viola