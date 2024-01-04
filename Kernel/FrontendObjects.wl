BeginPackage["JerryI`Notebook`FrontendObject`", {"KirillBelov`Objects`"}]

FrontendObject::usage = ""

Begin["`Private`"]

Unprotect[FrontendObject]
ClearAll[FrontendObject]

init[o_] := With[{uid = CreateUUID[]},
    Print["Init"];
    o["Hash"] = uid;
    Print["Hash"];
    FrontendObject`HashMap[uid] = o;
    Print["Fobject"];
    o["Date"] = Now; 
    o
]
(* GLOBAL. Is not connected to any notebook *)
(* Has to be independant from the notebook, exists separately *)
FrontendObject`HashMap = <||>;
CreateType[FrontendObject, init, {"JSON"->Null}]

End[]
EndPackage[]