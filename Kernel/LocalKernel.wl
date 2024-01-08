BeginPackage["JerryI`Notebook`LocalKernel`", {"JerryI`Misc`Async`", "JerryI`Misc`Events`", "JerryI`Notebook`Kernel`", "KirillBelov`Objects`", "KirillBelov`Internal`",  "KirillBelov`LTP`", "KirillBelov`TCPServer`"}]

LocalKernel::usage = ""


Begin["`Private`"]

LocalKernel[opts___] := LocalKernelObject[opts]

LocalKernel`LTPServerStart[port_:36800] := With[{},
    Echo[">> Starting local LTP server ..."];

    tcp = TCPServer[];
    tcp["CompleteHandler", "LTP"] = LTPQ -> LTPLength;
    tcp["MessageHandler", "LTP"]  = LTPQ -> LTPHandler;

    SocketListen[StringTemplate["127.0.0.1:``"][port], tcp@#&];
    LocalKernel`port = port;
]

(*  internal function that will be called by other kernel remotely *)
LocalKernel`LTPConnected[uid_String] := With[{o = Kernel`HashMap[uid]},
    Echo["LocalKernel >> local kernel link connected!"];
    o["LTPSocket"] = SocketConnect["127.0.0.1:" <> ToString[ o["Port"] ] ] // LTPTransport;

    o["ReadyQ"] = True;
    o["State"]  = "Connected";

    TaskRemove[o["WatchDog"] ];

    EventFire[o, "State", o["State"] ];
    EventFire[o, "Connected", True];
    Print["Ok!"];
]

CreateType[LocalKernelObject, Kernel, {"RootDirectory"->Directory[], "Port"->RandomInteger[{25400, 66000}], "ReadyQ"->False, "State"->"Undefined", "wolframscript" -> ("\""<>First[$CommandLine]<>"\" -wstp")}]

HeldRemotePacket /: LinkWrite[lnk_, HeldRemotePacket[p_String] ] := With[{pp = p},
    LinkWrite[lnk, Unevaluated[ pp // Uncompress // ReleaseHold ] ]
]

HoldRemotePacket[any_] := any // Hold // Compress // HeldRemotePacket
SetAttributes[HoldRemotePacket, HoldFirst]

tcpConnect[port_, o_LocalKernelObject] := With[{uid = o["Hash"], p = o["Port"], addr = "127.0.0.1:"<>ToString[port]},
    (  
        Print["Establishing LTP link..."];
        Internal`Kernel`Stdout = SocketConnect[addr] // LTPTransport;
        Module[{tcp},
            tcp = TCPServer[];
            tcp["CompleteHandler", "LTP"] = LTPQ -> LTPLength;
            tcp["MessageHandler", "LTP"]  = LTPQ -> LTPHandler;

            SocketListen[CSocketOpen["127.0.0.1", p], tcp@#&];
        ];
        Internal`Kernel`Apply[e_, t_] := e[t];
        LTPEvaluate[Internal`Kernel`Stdout, LocalKernel`LTPConnected[uid] ];
    ) // HoldRemotePacket
]

decryptor[ Hold[TextPacket[s_] ], handler_] := handler[s];
decryptor[ any_ , a_] := Print[any];

(* launch kernel *)
restart[k_LocalKernelObject] := With[{},
    LinkClose[k["Link"] ];
    k["ReadyQ"] = False;
    Close[k["LTPSocket"][[1]]];

    k["State"] = "Stopped";
    EventFire[k, "State", k["State"] ];
    
    start[k];
]

setProp[any_[sym_], assoc_] := (
    sym = Join[sym, assoc];
    Echo[ sym["State"] ];
);
SetAttributes[setProp, HoldFirst];

unlink[k_LocalKernelObject] := With[{},
    LinkClose[k["Link"] ];
    k["ReadyQ"] = False;
    Close[k["LTPSocket"][[1]]];

    k["State"] = "Stopped";
    k["Dead"] = True;
    EventFire[k, "State", k["State"] ];
    EventFire[k, "Exit", True ];
]

start[k_LocalKernelObject] := Module[{link},
    Echo[">> Starting using path: "<>k["wolframscript"] ];
    link = LinkLaunch[ k["wolframscript"] ];

    Print[k];

    EventFire[k, "State", "Checking the link"];
    EventFire[k, "State", k["State"] ];

    If[FailureQ[link], 
        EventFire[k, "Error", "Link failed. Trying legacy methods..."]; 
        link = LinkLaunch["math -mathlink"];

        If[FailureQ[link], 
            EventFire[k, "Error", "Link failed."]; 
        ];

        k["State"] = "Link failed!";
        EventFire[k, "State", k["State"] ];

        Return[$Failed];
    ];

    k["Link"] = link;
    k["State"] = "Starting";
    EventFire[k, "State", k["State"] ];
    

    k["ReadyQ"] = False;

    LinkWrite[link, Unevaluated[$HistoryLength = 0] ];
    With[{path = k["RootDirectory"]},

        LinkWrite[link, Unevaluated[ SetDirectory[path] ] ] ;
        LinkWrite[link, Unevaluated[ PacletDirectoryLoad[Directory[] ] ] ];
        LinkWrite[link, Unevaluated[ PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}] ] ] ];

        LinkWrite[link, EnterTextPacket["<<KirillBelov`CSockets`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`Objects`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`Internal`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`LTP`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`TCPServer`"] ];
        LinkWrite[link, EnterTextPacket["<<JerryI`Misc`Events`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`LTP`JerryI`Events`"] ];
    ];

    
    k["PrintTask"] = With[{kernel = k}, Looper`Submit[
        If[LinkReadyQ[kernel["Link"] ],
            decryptor[ LinkRead[kernel["Link"], Hold], Function[data,
                EventFire[k, "Print", data]
            ] ]
        ]
    , "Continuous" -> True] ];

    LinkWrite[link, tcpConnect[ LocalKernel`port, k ]  ];

    k["WatchDog"] = SetTimeout[ checkState[k], 12 * 1000];
    k
]

checkState[k_LocalKernelObject] := Module[{},
    k["State"] = "Timeout";
    EventFire[k, "Error", "Timeout"];
]

LocalKernelObject /: Kernel`Submit[k_LocalKernelObject, t_] := With[{ev = t["Evaluator"], s = Transaction`Serialize[t]},
    LinkWrite[k["Link"], Internal`Kernel`Apply[ ev, s ] ]
]

LocalKernelObject /: Kernel`Init[k_LocalKernelObject, expr_] := With[{},
    With[{
        value = expr // Once // Hold // Compress // HeldRemotePacket
    },
        LinkWrite[k["Link"], value]
    ]
]

SetAttributes[Kernel`Initialize, HoldRest]

LocalKernelObject /: Kernel`Start[k_LocalKernelObject] := start[k];
LocalKernelObject /: Kernel`Unlink[k_LocalKernelObject] := unlink[k];
LocalKernelObject /: Kernel`Restart[k_LocalKernelObject] := restart[k];

End[]
EndPackage[]