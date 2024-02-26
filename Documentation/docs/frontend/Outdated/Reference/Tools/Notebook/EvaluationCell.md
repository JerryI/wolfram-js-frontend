---
env:
  - Wolfram Kernel
---
```mathematica
EvaluationCell[] _CellObj
```
takes an identifier of an output cell generated after the evaluation. Can be used as [EventObject](../../Events/EventObject.md) for [EventHandler](../../Events/EventHandler.md) to attach handlers to an output cell or to print another cell after.

:::info
You do not need to clone [EvaluationCell](EvaluationCell.md) to assign many handlers to it. it is cloned automatically once appeared in [EventHandler](../../Events/EventHandler.md).
:::
## Application
### Fire an event after the cell has been reevaluated or removed
This is a common case, if you need to purge event listeners or clean up memory after every evaluation of the same cell

```mathematica
With[{},
  EventHandler[EvaluationCell[], {"destroy" -> (Print["Destroyed!"] &)}];
  "Lovely day"
]
```

*try to evaluate the cell above > 1 times*

### Remove an input / output cell after some event
Here is the code for removing the output cell after pressing the button

```mathematica
With[{cell = EvaluationCell[]},
  EventHandler[InputButton["Bye"],
    Function[Null,
      cell // Delete;
    ]
  ]
]
```

or to remove completely the pair of input-output cells, use [ParentCell](ParentCell.md)

```mathematica
With[{cell = EvaluationCell[]},
  EventHandler[InputButton["Bye"],
    Function[Null,
      cell // ParentCell // Delete;
    ]
  ]
]
```

### Print progress bar or other dynamics
Please, see [CellPrint](CellPrint.md) for this purpose

