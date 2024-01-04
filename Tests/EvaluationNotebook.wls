ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<<JerryI`Notebook`Packages`
<<JerryI`Misc`Events`
<<JerryI`Notebook`Kernel`
<<JerryI`Notebook`LocalKernel`
<<JerryI`Misc`Async`
<<JerryI`Notebook`Evaluator`
<<JerryI`Notebook`Transactions`

LoadPluginsConfiguration["Root" -> Directory[]];

Includes["frontend"];
Includes["kernel"];

LocalKernel`LTPServerStart[];

Get[FileNameJoin[{"Packages", #}] ] &/@ Includes["frontend"];

kernel = LocalKernel[];
EventHandler[kernel, {
    "Connected" -> next, 
    any_ :> Function[data, Echo["Kernel: " <> any <> ": " <> ToString[data] ] ]
}];

kernel // Kernel`Start // Print;

next[_] := With[{},
    (*  load scripts *)
    With[{p = Import[FileNameJoin[{"Packages", #}], {"Package", "HeldExpressions"}]},
        Kernel`Init[kernel,  ReleaseHold /@ p; ];
    ] &/@ Includes["kernel"];

    (* create transaction *)
    transaction = Transaction[];
    transaction["Data"] = "1+1";

    (* subscript to events of transaction *)
    EventHandler[transaction, {any_ :> Function[data, Echo["Transaction: " <> any <> ": " <> ToString[data] ] ]}];

    (* run *)
    container = StandardEvaluator`Container[kernel];
    container[transaction];
];

Looper[]
