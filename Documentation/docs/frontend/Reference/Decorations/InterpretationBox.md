---
env:
  - Wolfram Kernel
update: false
---



Make a formatting structure whose interpretation is not based on its appearance

```mathematica
InterpretationBox[display_, expr_]
```

where `display` will be shown in the output cell, instead of `expr`, keeping `expr` for the evaluation. 

:::info
`display` can be any Wolfram Expression wrapped in `MakeBoxes`
:::

:::danger
`display` must be Boxes, if you want to use regular WL expressions, consider [Interpretation](Interpretation.md)
:::

:::tip
Please see [BoxBox](Low%20level/BoxBox.md) and [ViewBox](Low%20level/ViewBox.md) for an advanced expression decorations
:::

## Applications
One of the examples is to make some definitions shorter by setting `UpValues` to  `MakeBoxes`, since the last one is recursively applied to everything in the output cell 

```mathematica
AVeryLongFunction /: MakeBoxes[AVeryLongFunction, StandardForm] := InterpretationBox[MakeBoxes[Ashort, StandardForm], AVeryLongFunction]
```

Now we can check the result by
```mathematica
AVeryLongFunction
```

if one define also this
```mathematica
AVeryLongFunction[expr__] := SpecialList[expr]
```

You can use it with the created alias `Ashort`

### Display graphics
Or one could use it as a data-preview





:::danger
There is a bug with `Graphics`, `Graphics3D` and `Image`. You should apply [`CreateFrontEndObject`](../Dynamics/CreateFrontEndObject.md) before, i.e.

```mathematica
formula /: MakeBoxes[formula[exp_], StandardForm] := With[{p = Plot[exp, {x,-1,1}, ImageSize->200] // CreateFrontEndObject},
  InterpretationBox[MakeBoxes[p, StandardForm], formula[exp]]
]
```

for [Plotly](../Plotting/Plotly.md) and some other user's defined function __it works without__ [CreateFrontEndObject](../Dynamics/CreateFrontEndObject.md) 
:::

:::tip
Use explicit `uid`, when creating a front-end objects ([CreateFrontEndObject](../Dynamics/CreateFrontEndObject.md)) based on a hash-value of the decorated expression. It will reduce the load to frontend and will keep all instances with the same `uid` to be up to date with the changing data.

See more in [dynamic-decorations](../../Advanced/Boxes%20and%20Decorations/dynamic-decorations.md) guide
:::

## Dev notes
This is a wrapper for [ViewBox](Low%20level/ViewBox.md) with a read-only [EditorView](../Inputs/EditorView.md) inside.