ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<<JerryI`Misc`Events`
<<JerryI`Notebook`Kernel`
<<JerryI`Notebook`LocalKernel`
<<JerryI`Misc`Async`
<<JerryI`Notebook`Evaluator`
<<JerryI`Notebook`Transactions`

LocalKernel`LTPServerStart[];

kernel = LocalKernel[];
EventHandler[kernel, {
    "Connected" -> next, 
    any_ :> Function[data, Echo["Kernel: " <> any <> ": " <> ToString[data] ] ]
}];

kernel // Kernel`Start // Print;



next[_] := With[{},
    Pause[3];
    Kernel`Async[kernel, Unevaluated[Print["Boodabudu"] ] ] // Echo;
    Echo["Done"];
    Kernel`Async[kernel, Exit[-1] ];
    Kernel`Async[kernel, Identity[Print["Boodabudu"] ] ];
    Kernel`Async[kernel, Identity[Print["Boodabudu"] ] ];
    Kernel`Async[kernel, Identity[Echo["Boodabudu"] ] ];
    Kernel`Async[kernel, Identity[Print["Boodabudu"] ] ];

];


Looper[]
