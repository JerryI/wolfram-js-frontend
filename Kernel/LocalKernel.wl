BeginPackage["JerryI`Notebook`LocalKernel`", {"JerryI`Misc`Async`", "JerryI`Misc`Events`", "JerryI`Misc`Events`Promise`", "JerryI`Notebook`Kernel`", "KirillBelov`Objects`", "KirillBelov`Internal`",  "KirillBelov`LTP`", "KirillBelov`TCPServer`", "KirillBelov`CSockets`"}]

LocalKernel::usage = ""


Begin["`Private`"]

LocalKernel[opts___] := LocalKernelObject[opts]

LocalKernel`LTPServerStart[port_:36800] := With[{},
    Echo[">> Starting local LTP server ..."];

    tcp = TCPServer[];
    tcp["CompleteHandler", "LTP"] = LTPQ -> LTPLength;
    tcp["MessageHandler", "LTP"]  = LTPQ -> LTPHandler;

    SocketListen[SocketOpen[ StringTemplate["127.0.0.1:``"][port] ], tcp@#&];
    LocalKernel`port = port;
]

(*  internal function that will be called by other kernel remotely *)
LocalKernel`LTPConnected[uid_String] := With[{o = Kernel`HashMap[uid]},
    Echo["LocalKernel >> local kernel link connected!"];
    o["LTPSocket"] = SocketConnect[ "127.0.0.1:"<>ToString[o["Port"] ] ] // LTPTransport;

    o["ReadyQ"] = True;
    o["State"]  = "Connected";

    o["HeartBeat"] = heartBeat[o];

    TaskRemove[o["WatchDog"] ];

    EventFire[o, "State", o["State"] ];
    EventFire[o, "Connected", "Please wait until initialization is complete!"];
    Print["Ok!"];
]

CreateType[LocalKernelObject, Kernel, {"RootDirectory"->Directory[], "InitList"-> {}, "Host"->"127.0.0.1", "Port"->36808, "ReadyQ"->False, "State"->"Undefined", "wolframscript" -> ("\""<>First[$CommandLine]<>"\" -wstp")}]

heartBeat[k_] := Module[{ok = True, orig}, With[{secret = CreateUUID[]},
    EventHandler[secret, {_ -> Function[Null, ok = True]}];

    SetInterval[
        If[!ok,
            orig = k["State"];
            EventFire[k, "State", k["State"] ];
        ,
            If[k["ReadyQ"],
                EventFire[k, "State", k["State"] ];
            ];
        ];
        ok = False;
        LTPEvaluate[k["LTPSocket"], Internal`Kernel`Ping[secret] ];
        
    , 8000]
] ]

HeldRemotePacket /: LinkWrite[lnk_, HeldRemotePacket[p_String] ] := With[{pp = p},
    LinkWrite[lnk, Unevaluated[ pp // Uncompress // ReleaseHold ] ]
]

HoldRemotePacket[any_] := any // Hold // Compress // HeldRemotePacket
SetAttributes[HoldRemotePacket, HoldFirst]

tcpConnect[port_, o_LocalKernelObject] := With[{host = o["Host"], uid = o["Hash"], p = o["Port"], addr = "127.0.0.1:"<>ToString[port]},
    (  
        Print["Establishing LTP link... using "<>addr];
        Internal`Kernel`Host = host;
        
        Internal`Kernel`Stdout = CSocketConnect[addr] // LTPTransport;
        Print["Establishing starting LTP server for backlink... using "<>(StringTemplate["127.0.0.1:``"][p])];
        Module[{tcp},
            tcp = TCPServer[];
     
            tcp["CompleteHandler", "LTP"] = LTPQ -> LTPLength;
            tcp["MessageHandler", "LTP"]  = LTPQ -> LTPHandler;

            SocketListen[CSocketOpen["127.0.0.1:"<>ToString[p] ], tcp@#&];
            
        ];

        Internal`Kernel`Apply[e_, t_] := e[t];
        Internal`Kernel`Type = "LocalKernel";
        Internal`Kernel`Hash = uid;

        Internal`Kernel`Ping[secret_] := EventFire[Internal`Kernel`Stdout[secret], "Pong", True];

        Unprotect[FileNameJoin];
        FileNameJoin[{Internal`RemoteFS[url_], any__}] := With[{split = FileNameJoin[{any}] // FileNameSplit},
          URLBuild[{url, split} // Flatten] // Internal`RemoteFS
        ];

        Protect[FileNameJoin];   
        
           

        Internal`RemoteFS /: Get[Internal`RemoteFS[url_] ] := Get[url];   
        Internal`RemoteFS /: StringTake[Internal`RemoteFS[url_], n_] := StringTake[url,n]; 
        Internal`RemoteFS /: Import[Internal`RemoteFS[url_], w_] := Import[url, w];

        LTPEvaluate[Internal`Kernel`Stdout, LocalKernel`LTPConnected[uid] ];
    ) // HoldRemotePacket
]

decryptor[ Hold[TextPacket[s_] ], print_, error_] := print[s];
decryptor[ Hold[ReturnPacket[Null] ], __ ] := Null;
decryptor[ Hold[OutputStream[__] ], __ ] := Null;
decryptor[ any_ , a__] := Print[any];

decryptor[ Hold[MessagePacket[symbol_, type_] ], print_, error_ ] := error[StringTemplate["``::``"][symbol, type] ]

(* launch kernel *)
restart[k_LocalKernelObject] := With[{},
    k["InitList"] = {};

    LinkClose[k["Link"] ];
    TaskRemove[k["HeartBeat"] ];
    k["ReadyQ"] = False;
    Close[k["LTPSocket"][[1]]];

    k["State"] = "Stopped";
    EventFire[k, "State", k["State"] ];
    
    
    SetTimeout[start[k], 1500];
]

setProp[any_[sym_], assoc_] := (
    sym = Join[sym, assoc];
    Echo[ sym["State"] ];
);
SetAttributes[setProp, HoldFirst];

unlink[k_LocalKernelObject] := With[{},
    k["InitList"] = {};
    LinkClose[k["Link"] ];
    TaskRemove[k["HeartBeat"] ];
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

    k["Dead"] = False;

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
        LinkWrite[link, Unevaluated[ PacletDirectoryUnload /@ PacletDirectoryLoad[]; ] ];
        LinkWrite[link, Unevaluated[ SetDirectory[path] ] ] ;
        LinkWrite[link, Unevaluated[ Set[Internal`Kernel`RootDirectory, path] ] ];
        LinkWrite[link, Unevaluated[ PacletDirectoryLoad[Directory[] ] ] ];
        LinkWrite[link, Unevaluated[ PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}] ] ] ];

        LinkWrite[link, EnterTextPacket["<<KirillBelov`CSockets`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`Objects`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`Internal`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`LTP`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`TCPServer`"] ];
        LinkWrite[link, EnterTextPacket["<<JerryI`Misc`Events`"] ];
        LinkWrite[link, EnterTextPacket["<<JerryI`Misc`Async`"] ];
        LinkWrite[link, EnterTextPacket["<<JerryI`Misc`Language`"] ];
        LinkWrite[link, EnterTextPacket["<<JerryI`Misc`Events`Promise`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`WebSocketHandler`"] ];
        LinkWrite[link, EnterTextPacket["<<JerryI`Misc`WLJS`Transport`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`CSockets`EventsExtension`"] ];
        LinkWrite[link, EnterTextPacket["<<KirillBelov`LTP`JerryI`Events`"] ];

        (* unknown bug, doesn't work in initialization ... *)
        LinkWrite[link, EnterTextPacket["Unprotect[Interpretation, InterpretationBox]"] ];

        LinkWrite[link, Unevaluated[ Get[FileNameJoin[{Directory[], "LPM.wl"}] ] ] ];
    ];

    
    k["PrintTask"] = With[{kernel = k}, Looper`Submit[
        If[LinkReadyQ[kernel["Link"] ],
            decryptor[ LinkRead[kernel["Link"], Hold], 
                Function[data,
                    EventFire[k, "Print", data]
                ],
                Function[data,
                    EventFire[k, "Warning", data]
                ]
            ]
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
    LinkWrite[k["Link"], EnterExpressionPacket[ Internal`Kernel`Apply[ ev, s ] ] // Unevaluated  ]
]

LocalKernelObject /: Kernel`Async[k_LocalKernelObject, expr_] := With[{},
    LTPEvaluate[k["LTPSocket"], expr]
]

Kernel`Stdout[k_LocalKernelObject][any_] := k["LTPSocket"][any]

SetAttributes[Kernel`Async, HoldRest]

LocalKernelObject /: Kernel`Init[k_LocalKernelObject, expr_, OptionsPattern[] ] := With[{once = OptionValue["Once"], tracker = OptionValue["TrackingProgress"]},
    If[!once,
        With[{
                value = expr // Hold // Compress // HeldRemotePacket
            },
                Echo["LocalKernel Init >> Normal"];
                tracker["Start"];
                LinkWrite[k["Link"], value];
                With[{promise = Promise[]},
                    Then[promise, Function[Null,
                        tracker["End"];
                    ] ];

                    With[{s = promise // First},
                        LinkWrite[k["Link"], Unevaluated[EventFire[Internal`Kernel`Stdout[ s ], Resolve, "Ok" ];] ];
                    ];
                ];
                
        ];    
    , 
        If[!MemberQ[k["InitList"], Hash[expr // Hold] ] ,
            Echo["LocalKernel Init >> Once"];
            EventFire[k, "Info", "Initialization has started. Please, wait a bit..."];
            With[{
                value = expr // Hold // Compress // HeldRemotePacket
            },
                tracker["Start"];
                LinkWrite[k["Link"], value];
                With[{promise = Promise[]},
                    Then[promise, Function[Null,
                        tracker["End"];
                    ] ];

                    With[{s = promise // First},
                        LinkWrite[k["Link"], Unevaluated[EventFire[Internal`Kernel`Stdout[ s ], Resolve, "Ok" ];] ];
                    ];
                ];
            ];

            k["InitList"] = Append[k["InitList"], Hash[expr // Hold] ];
        ,
            Echo["LocalKernel Init >> Already initialized..."];
        ];
    ];
]

Options[Kernel`Init] = {"Once" -> False, "TrackingProgress"->Null}

SetAttributes[Kernel`Init, HoldRest]

LocalKernelObject /: Kernel`Start[k_LocalKernelObject] := start[k];
LocalKernelObject /: Kernel`Unlink[k_LocalKernelObject] := unlink[k];
LocalKernelObject /: Kernel`Restart[k_LocalKernelObject] := restart[k];

LocalKernelObject /: Kernel`Abort[k_LocalKernelObject] := With[{},
    LinkInterrupt[k["Link"], 3]; 
    Print["localkernel >> aborted"];
    LinkWrite[k["Link"], Unevaluated[$Aborted] ];     
];

End[]
EndPackage[]