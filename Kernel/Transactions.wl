BeginPackage["JerryI`Notebook`Transactions`", {"KirillBelov`Objects`"}]

Transaction::usage = "creates transaction for Notebook <-> Kernel / Evaluator communication"

Begin["`Private`"]

initTransaction[t_] := With[{},
    Print["Create transaction"];
    t["Hash"] = CreateUUID[];
    t
]

CreateType[Transaction, initTransaction, {}]

Transaction /: EventHandler[n_Transaction, opts__] := EventHandler[n["Hash"], opts] 
Transaction /: EventFire[n_Transaction, opts__] := EventFire[n["Hash"], opts]
Transaction /: EventRemove[n_Transaction, opts__] := EventRemove[n["Hash"], opts] 

End[]
EndPackage[]