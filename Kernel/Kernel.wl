BeginPackage["JerryI`Notebook`Kernel`", {"JerryI`Misc`Events`", "KirillBelov`Objects`"}]

Kernel::usage = ""
KernelQ::usage = ""

Kernel`Start::usage = ""
Kernel`Init::usage = ""
Kernel`Submit::usage = ""

Begin["`Private`"]

Kernel`HashMap = <||>

init[o_] := With[{uid = CreateUUID[]},
    o["Hash"] = uid;
    Kernel`HashMap[uid] = o;
    o
];

CreateType[Kernel, init, {"Packages"->{}}]

Kernel /: KernelQ[_Kernel] := True

Kernel /: EventHandler[n_Kernel, opts__] := EventHandler[n["Hash"], opts] 
Kernel /: EventFire[n_Kernel, opts__] := EventFire[n["Hash"], opts]
Kernel /: EventRemove[n_Kernel, opts__] := EventRemove[n["Hash"], opts] 

Kernel`Submit[k_, t_] := Print["Dummy Kernel`Submit"]

Kernel`Init[k_, expr_] := Print["Dummy Kernel`Init"]

SetAttributes[Kernel`Init, HoldRest]

Kernel`Start[k_] := Print["Dummy start"];


End[]
EndPackage[]