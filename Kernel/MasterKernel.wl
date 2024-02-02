BeginPackage["JerryI`Notebook`MasterKernel`", {"KirillBelov`Objects`", "JerryI`Misc`Async`", "JerryI`Misc`Events`", "JerryI`Notebook`Kernel`"}]

MasterKernel::usage = ""
Kernel`Init::usage = ""
Kernel`Start::usage = ""
Kernel`Submit::usage = ""

Begin["`Private`"]

CreateType[MasterKernel, Kernel, {"InitList"-> {}}];

decryptor[ Hold[TextPacket[s_] ], handler_] := handler[s];
decryptor[ any_ , a_] := Print[any];

(* launch kernel *)
start[o_MasterKernel] := Module[{link},
    Print["Starting kernel...."];
    o["Dead"] = False;
    o["ReadyQ"] = True;
    o["State"]  = "Connected";

    Internal`Kernel`Stdout = Identity;
    Internal`Kernel`Host = "127.0.0.1";
    Internal`Kernel`Hash = o["Hash"];

    Unprotect[FileNameJoin];
    FileNameJoin[{Internal`RemoteFS[url_], any__}] := With[{split = FileNameJoin[{any}] // FileNameSplit},
      URLBuild[{url, split} // Flatten] // Internal`RemoteFS
    ];
    Protect[FileNameJoin];      
    Internal`RemoteFS /: Get[Internal`RemoteFS[url_] ] := Get[url]; 
    Internal`RemoteFS /: StringTake[Internal`RemoteFS[url_], n_] := StringTake[url,n];   
    Internal`RemoteFS /: Import[Internal`RemoteFS[url_], w_] := Import[url, w];

    Pause[0.5];
    EventFire[o, "State", o["State"] ];
    EventFire[o, "Connected", "Please wait until initialization is complete!"];
    
    o
]

MasterKernel /: Kernel`Submit[k_MasterKernel, t_] := With[{ev = t["Evaluator"], s = Transaction`Serialize[t]},
    Looper`Submit[ ev[s] ];
]

MasterKernel /: Kernel`Async[k_MasterKernel, expr_] := With[{},
    expr
]

Kernel`Stdout[k_MasterKernel][any_] := any

SetAttributes[Kernel`Async, HoldRest]


MasterKernel /: Kernel`Init[k_MasterKernel, expr_, OptionsPattern[] ] := With[{once = OptionValue["Once"]},
    If[once,
        If[MemberQ[ k["InitList"], Hash[expr // Hold] ], 
            Echo["MasterKernel Init >> Already initialized..."];
        ,
            Echo["MasterKernel Init >> Once"];
            EventFire[k, "Info", "Initialization has started. Please, wait a bit..."];
            Looper`Submit[expr // ReleaseHold];
            k["InitList"] = Append[k["InitList"], Hash[expr // Hold] ];
        ]    
    ,
        Looper`Submit[expr // ReleaseHold];
    ]
]

Options[Kernel`Init] = {"Once" -> False, "TrackingProgress"->Null}

SetAttributes[Kernel`Init, HoldRest]

MasterKernel /: Kernel`Start[k_MasterKernel] := start[k];

restart[k_MasterKernel] := With[{},
    k["ReadyQ"] = False;
    k["InitList"] = {};

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

MasterKernel /: Kernel`Abort[k_MasterKernel] := EventFire[k, "Warning", "Master Kernel cannot be aborted!"]

End[]
EndPackage[]