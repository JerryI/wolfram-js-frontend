BeginPackage["JerryI`Notebook`MasterKernel`", {"KirillBelov`Objects`", "JerryI`Misc`Async`", "JerryI`Misc`Events`", "JerryI`Notebook`Kernel`"}]

MasterKernel::usage = ""
Kernel`Init::usage = ""
Kernel`Start::usage = ""
Kernel`Submit::usage = ""

Begin["`Private`"]

CreateType[MasterKernel, Kernel, {}];

decryptor[ Hold[TextPacket[s_] ], handler_] := handler[s];
decryptor[ any_ , a_] := Print[any];

(* launch kernel *)
start[o_MasterKernel] := Module[{link},
    Print["Starting kernel...."];
    o["ReadyQ"] = True;
    o["State"]  = "Connected";

    Internal`Kernel`Stdout = Identity;
    Internal`Kernel`Host = "127.0.0.1";

    EventFire[o, "State", o["State"] ];
    EventFire[o, "Connected", True];
    o
]

MasterKernel /: Kernel`Submit[k_MasterKernel, t_] := With[{ev = t["Evaluator"], s = Transaction`Serialize[t]},
    ev[s];
]


MasterKernel /: Kernel`Init[k_MasterKernel, expr_] := With[{},
    expr // ReleaseHold
]

SetAttributes[Kernel`Init, HoldRest]

MasterKernel /: Kernel`Start[k_MasterKernel] := start[k];

restart[k_MasterKernel] := With[{},
    k["ReadyQ"] = False;

    k["State"] = "Stopped";
    EventFire[k, "State", k["State"] ];
    
    start[k];
]

MasterKernel /: Kernel`Restart[k_MasterKernel] := restart[k];
MasterKernel /: Kernel`Unlink[k_MasterKernel] := unlink[k];

unlink[k_MasterKernel] := With[{},
    k["ReadyQ"] = False;

    k["State"] = "Stopped";
    k["Dead"] = True;
    EventFire[k, "State", k["State"] ];
    EventFire[k, "Exit", True ];
]

End[]
EndPackage[]