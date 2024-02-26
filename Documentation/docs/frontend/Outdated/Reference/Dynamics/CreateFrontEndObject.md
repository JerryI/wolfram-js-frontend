---
env:
  - Wolfram Kernel
---
Creates a [container](../../../../interpreter/Advanced/containers.md) for the inner expression and stores it into frontend objects storage shared with Kernel and Notebook
```mathematica
CreateFrontEndObject[expr, "uid" | Empty, OptionsPattern[]]
```

Returns [`FrontEndExecutable`](Internals/FrontEndExecutable.md) object with a given id or generated.

See more about it in __[Executables](../../Advanced/Frontend%20interpretation/executables.md)__

:::info
Is used to force Wolfram Kernel to execute an expression on the frontend ([WLJS](../../../../interpreter/intro.md)) with an HTML element provided to the output cell
:::

This is a fundament  for serving `Graphics`, `InputRange`... and other interactive elements. Event `EventObject` that comes from [event-generators](../../Advanced/Events%20system/event-generators.md) use it to show the UI element.

In general, containers is a huge fundamental building blocks for almost everything. 

## Applications

### To execute WLJS functions, which are not registered
Some of build-in expressions that represent some low-level UI elements, such as [TextView](../Input/TextView.md) __require a container__ before being executed on frontend's side (WLJS).

For instance, normally `TextView` is an element that shows editable text on frontend, and is not registered in Wolfram Kernel to have a container being in the output cell. Therefore we can make one manually for the purpose to show some [dynamic](../../Tutorial/Dynamics.md) text

*cell 1*
```mathematica
dynText = RandomWord[];
TextView[dynText // Offload] // CreateFrontEndObject
```

<Wl data={`WyJUZXh0VmlldyIsWyJPZmZsb2FkIiwiJ2FwcGxlJyJdXQ==
`}>{`TextView[RandomSample[{"apple", "orange", "truck"}] // First // Offload]`}</Wl>

then, one can update the symbol `dynText` and see that the field above will also be updated

*cell 2*
```mathematica
dynText = RandomWord[];
```

### As a container generator for WLJS functions
Use for custom defined WLJS functions i.e.

```js
.js
core.MyCustomStuff = async (args, env) => {
	env.element.innerText = "Hi dude!";
}
```

and then in the next cell
```mathematica
CreateFrontEndObject[MyCustomStuff[]]
```

<Wl data={`WyJDcmVhdGVGcm9udEVuZE9iamVjdCIsWyJUZXh0VmlldyIsIidIaSBkdWRlISciXV0=
`}>{`CreateFrontEndObject[TextView["Hi dude!"]]`}</Wl>

If you apply it to a regular function, which is already registered in the system to have an automatic container generation, it __it will not have any effect__

```mathematica
Graphics[Text["Hi", {0,0}]] // CreateFrontEndObject
```

### For low-level dynamic
:::tip
If you are looking for dynamic expressions and etc, please, better see modern way of doing that using [Offload](Offload.md) in the tutorial section [Dynamics](../../Tutorial/Dynamics.md).
:::

It can also acts as a reference to any expression

*cell 1*
```mathematica
CreateFrontEndObject[RandomReal[{-1,1}, 2], "data"]
```

Then one can create a graph and use it with a reference (using [`FrontEndRef`](Internals/FrontEndRef.md)) to it

*cell 2*
```mathematica
Graphics[{Red, PointSize[0.1], Point[FrontEndRef["data"]]}]
```

<Wl data={`WyJHcmFwaGljcyIsWyJMaXN0IixbIlJHQkNvbG9yIiwxLDAsMF0sWyJQb2ludFNpemUiLDAuMV0s
WyJQb2ludCIsWyJPZmZsb2FkIixbIkxpc3QiLC0wLjExODY3NTU0MTYxNzI4OTc3LC0wLjM1OTcz
MjQ1NDQ4MzY2Nl1dXV0sWyJSdWxlIiwiSW1hZ2VTaXplIiw1MDBdXQ==
`}>{`Graphics[{Red, PointSize[0.1], Point[RandomReal[{-1,1}, 2] // Offload]}, ImageSize->500]`}</Wl>

If one change the object `data` in other cell, the position of a point will be changed as well dynamically with no reevaluation involved, i.e.

*cell 3*
```mathematica
CreateFrontEndObject[RandomReal[{-1,1}, 2], "data"];
```
or in a shorter form

*cell 3*
```mathematica
FrontEndRef["data"] = RandomReal[{-1,1}, 2];
```

Basically, there are three containers involved
1. Graphics - normal container (automatically created)
2. Point - virtual container (automatically implicitly created, see [containers](../../../../interpreter/Advanced/containers.md))
3. data - normal container (manually created)

Only 3 and 2 are effectively connected to each other, 1 and 2 are connected as well, but it does not make sense, since 1 does not support updates.

> Back at the times it was the only way of making dynamics possible. Nowadays virtual containers did overtake normal ones and made the process much easier. 

## Options
### Private and shared storage
Taken from [Evaluation / Static](../../Development/Evaluation/Static.md) 

>Each time you evaluate `Graphics` or whatever frontend object, it creates two copies of its representation: one is stored on frontend kernel (master Wolfram Kernel), which is shared with a browser (WLJS), while there is other *private* copy of it on the secondary Wolfram Kernel. When Wolfram Kernel encounters a `FrontEndExecutable` during the evaluation, it uses (if available) its private copy, and if not it downloads the shared one into the private storage.  **See how it can be used [HERE](https://jerryi.github.io/wljs-docs/blog/feobjects-example)**

```mathematica
CreateFrontEndObject[expr, "uid", "Type"->"Private"];
```

It __will override the private copy__. Consider an example

```mathematica
Magic := With[{uid = CreateUUID[]},
	With[{o = CreateFrontEndObject[TextView["Hello World"], uid]},
		(* a trick to sublimate a private copy *)
		CreateFrontEndObject["Cucumbers", uid, "Type"->"Private"];
		o
	]
]
```

Try this example
```mathematica
Magic
```
evaluate in place and, then, evaluate the result as a cell.

## Notes
There is another way of making containers on WLJS's side. For example
```mathematica
{
  dpt = {0,0},
  cnt = 0;
  FrontEndVirtual[{
	AttachDOM["dom-id"],
	Graphics[{Red, Point[dpt]}]
  }],
  While[cnt < 10,
    dpt = RandomReal[{-1,1}, 2];
    cnt = cnt + 1;
    Pause[1];
  ]
} // Offload // FrontSubmit;
```

This will send a direct message to evaluate the inner expression on the frontend (WLJS) entirely (no Wolfram Kernel is involved). However, __you should not forget to create a DOM element__ for graphics with `dom-id`, i.e. create a new cell beforehand

```mathematica
.html
<div id="dom-id"></div>
```

<Wl data={`WyJPZmZsb2FkIixbIkxpc3QiLFsiTGlzdCIsMCwwXSwwLFsiR3JhcGhpY3MiLFsiTGlzdCIsWyJS
R0JDb2xvciIsMSwwLDBdLFsiUG9pbnRTaXplIiwwLjFdLFsiUG9pbnQiLFsiTGlzdCIsMCwwXV1d
LFsiUnVsZSIsIkltYWdlU2l6ZSIsNTAwXV0sWyJTdGF0aWMiLG51bGxdXV0=
`}>{`List[dpt = {0,0}, cnt = 0, Graphics[{Red, PointSize[0.1],Point[dpt]}, ImageSize->500], While[Less[cnt,10],
    {dpt = RandomReal[{-1,1}, 2],
    cnt = cnt + 1,
    Pause[1]}
  ] // Static
] // Offload`}</Wl>

Then, your graphics will pop up the the output of this [HTML](../../Cell%20types/HTML.md) cell


