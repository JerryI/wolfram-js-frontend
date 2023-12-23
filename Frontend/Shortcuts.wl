
Shortcuts["Create new cell"] := With[{notebook = $AssociatiedNotebook[Global`$Client]},
    AppendTo[ notebook["Cells"], CellObj[] ];
]

Shortcuts["Open notebook"][path_String] := With[{client = Global`$Client},
    EventHandler[notebook, {"New cell" -> }]
] 


CellObj["Evaluate"]

notebook["Kernel"] = LocalKernel[opts...]

EventHandler[notebook["Kernel"], {"started" -> }];
notebook["Kernel"] // Start;