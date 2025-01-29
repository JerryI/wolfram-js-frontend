BeginPackage["CoffeeLiqueur`Notebook`Kernel`", {"JerryI`Misc`Events`", "KirillBelov`Objects`"}]

Kernel::usage = ""
KernelQ::usage = ""

Kernel`Start::usage = ""
Kernel`Init::usage = ""
Kernel`Submit::usage = ""
Kernel`Async::usage = ""
Kernel`Stdout::usage = ""

Begin["`Private`"]

Kernel`HashMap = <||>

init[o_] := With[{uid = CreateUUID[]},
    o["Hash"] = uid;
    Kernel`HashMap[uid] = o;
    o
];

CreateType[Kernel, init, {"Packages"->{}, "Name"->"Unknown Kernel", "Dead"->True}]

Kernel /: KernelQ[_Kernel] := True

Kernel /: EventHandler[n_Kernel, opts__] := EventHandler[n["Hash"], opts] 
Kernel /: EventFire[n_Kernel, opts__] := EventFire[n["Hash"], opts]
Kernel /: EventClone[n_Kernel] := EventClone[n["Hash"] ]
Kernel /: EventRemove[n_Kernel, opts__] := EventRemove[n["Hash"], opts] 

Kernel`Submit[k_, t_] := Print["Dummy Kernel`Submit"]

Kernel`Async[k_, e_] := Print["Dummy Kernel`Async"]
SetAttributes[Kernel`Async, HoldRest]

Kernel`Stdout[k_][any_] := Print["Dummy Kernel`Stdout"]

Kernel`Init[k_, expr_, OptionsPattern[]] := Print["Dummy Kernel`Init"]

SetAttributes[Kernel`Init, HoldRest]

Kernel`Start[k_] := Print["Dummy start"];
Kernel`Restart[k_] := Print["Restart start"];
Kernel`Unlink[k_] := Print["Unlink start"];

Kernel`Abort[k_] := Print["Dymmu abort"];

End[]
EndPackage[]