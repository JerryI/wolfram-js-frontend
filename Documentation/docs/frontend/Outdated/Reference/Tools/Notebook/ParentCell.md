---
env:
  - Wolfram Kernel
---
```mathematica
ParentCell[inputCell_CellObj | Null] _CellObj
```

asks master kernel to find an identifier of the parent cell (usually an input cell) of the given output cell.

Or gets the input cell id of the argument is `Null`.

:::danger
Common pitfall is to use
```mathematica
EvaluationCell[] // ParentCell
```
__will not work__, since `EvaluationCell` refers to the output cell, which is not created yet. Please, use it after an output is already visible, or with a `Null` argument
```mathematica
ParentCell[]
```
:::

## Application
To find and remove in input cell of the current cell (aka suicide)

```mathematica
With[{cell = EvaluationCell[]},
  EventHandler[InputButton["Bye"],
    Function[Null,
      cell // ParentCell // Delete;
    ]
  ]
]
```

here we use `With` to capture an id of the output cell, that will be created later.