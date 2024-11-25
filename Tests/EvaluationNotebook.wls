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

Exit[-1];
(*not adapted!!!!!!!!!!*)

Includes["frontend"];
Includes["kernel"];

LocalKernel`LTPServerStart[];

kernel = LocalKernel[];
EventHandler[kernel, {
    "Connected" -> next, 
    any_ :> Function[data, Echo["Kernel: " <> any <> ": " <> ToString[data] ] ]
}];

Echo[Includes["kernel"]];

kernel // Kernel`Start // Print;

next[_] := With[{},


    (* create transaction *)
    transaction = Transaction[];
    transaction["Data"] = "1/0";

    (* subscript to events of transaction *)
    EventHandler[transaction, {any_ :> Function[data, Echo["Transaction: " <> any <> ": " <> ToString[data] ] ]}];

    (* run *)
    container = StandardEvaluator`Container[kernel];
    container[transaction];
];

Looper[]
