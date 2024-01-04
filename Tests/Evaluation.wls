ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<<JerryI`Misc`Events`
<<JerryI`Notebook`Kernel`
<<JerryI`Notebook`MasterKernel`
<<JerryI`Misc`Async`
<<JerryI`Notebook`Evaluator`
<<JerryI`Notebook`Transactions`

kernel = MasterKernel[];
EventHandler[kernel, {any_ :> Function[data, Echo["Kernel: " <> any <> ": " <> ToString[data] ] ]}];

kernel // Kernel`Start // Print;

(* create transaction *)
transaction = Transaction[];
transaction["Data"] = "1+1";

(* subscript to events of transaction *)
EventHandler[transaction, {any_ :> Function[data, Echo["Transaction: " <> any <> ": " <> ToString[data] ] ]}];

(* run *)
container = StandardEvaluator`Container[kernel];
container[transaction];

Pause[2];
