---
env:
  - Wolfram Kernel
---


```mathematica
MakeBoxes[expr_, form_]
```
is a general expression used in `UpValues` of other expressions to change the visual representation (see [Decorations](../../Development/Decorations.md)) in the notebook.

:::info
`MakeBoxes[..., StandardForm]` is applied to any visible output from the cell. It is also a part of a pipeline for `ToString[..., StandardForm]` used in [CellPrint](../Tools/Notebook/CellPrint.md), and [EditorView](../Input/EditorView.md) for various applications
:::

:::tip
Please see [BoxBox](Low%20level/BoxBox.md) and [ViewBox](Low%20level/ViewBox.md) for an advanced expression decorations
:::
## Applications

### Styling symbols | Custom representation
Please consider to use `StandardForm` for `form` argument to achieve those effects. __The best example is__ [InterpretationBox](InterpretationBox.md). However one can do also your own 



:::warning
For the case of `RowBox` you have to be careful, that it does not keep the original expression
:::

Or one can better, by keeping the original expression inside



### Data preview
One can make a preview of the data content length for example



:::tip
Please check the official Wolfram Language documentation on `MakeBoxes` 
:::

### Force expressions to be executed on WLJS Interpreter
This is basically the way on how to automatically apply [CreateFrontEndObject](../Dynamics/CreateFrontEndObject.md) on some common objects like [Graphics](../Graphics/Graphics.md), [ListLinePlotly](../Plotting/ListLinePlotly.md) meant for executing on WLJS Interpreter

This is how it is done for [ListLinePlotly](../Plotting/ListLinePlotly.md)

```mathematica
sym /: MakeBoxes[sym[agrs__], StandardForm] := With[{o = CreateFrontEndObject[sym[agrs]]},
	MakeBoxes[o, StandardForm]
];
```

For example, `Alert` is a WLJS Interpreter function and if one evaluate
```mathematica
Alert["Hi Dude!"]
```

nothing will happen. However
```mathematica
Alert /: MakeBoxes[Alert[agrs__], StandardForm] := With[{o = CreateFrontEndObject[Alert[agrs]]},
	MakeBoxes[o, StandardForm]
];

Alert["Hi Dude"]
```

:::info
Please consider to read an API docs for custom function if you are making an extension - see [Basics](../../Development/Plugins/Basics.md)
:::

