---
env:
  - Wolfram Kernel
---
```mathematica
CellPrint[str_String, opts___] _CellObj
```

prints an output cell after the evaluated input cell with a content `str` provided. Can be used for creating progress bars or other dynamics elements that can help to monitor the state. 

It returns a `CellObj` that refers to a created cell.

:::tip
To print an expression in a `StandardForm`, use
```mathematica
cell = CellPrint[ToString[1/Sqrt[2], StandardForm]];
"The regular output"
```

and then, one can easily delete a created cell
```mathematica
Delete[cell]
```
:::
## Options
### `"Type"`
default is `"Output"`  cell type. Possible value is also `"Input"`

### `"After"`
Specify a `CellObj`, that points to the cell after which it will be placed. 

## Applications
To make a temporal cell with a custom output use

```mathematica
EventHandler[InputButton["Click"], Function[Null,
  Module[{cell},
    cell = CellPrint["\"I will disappear in 3 seconds\""];
    Pause[3];
    Delete[cell];
  ]
]]
```

### Progress bar
This comes very helpful to monitor the evaluation state

*drawing function*
```mathematica
progressBar[callback_] := LeakyModule[{progress = -1},
  callback[num_] := (progress  = -1 + 2*(num / 100));
  Graphics[Rectangle[{-2,-1}, {progress // Offload,2}], PlotRange->{{-1,1}, {-1,1}}, ImageSize->{300,50}]
]
```

*an example*
```mathematica
Module[{cbk, cell},
  cell = CellPrint[ToString[progressBar[cbk], StandardForm]];
  
  (* some heavy computations *)
  Do[Pause[0.2]; cbk[i];, {i,0, 100, 10}];
  Delete[cell];
  "done"
]
```