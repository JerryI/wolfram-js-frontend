BeginPackage["CoffeeLiqueur`Notebook`KernelUtils`", {
  "JerryI`WLJSPM`", 
  "JerryI`Misc`Events`",
  "JerryI`Misc`Events`Promise`",
  "KirillBelov`CSockets`",
  "KirillBelov`CSockets`EventsExtension`",
  "KirillBelov`Internal`",
  "KirillBelov`TCPServer`",
  "KirillBelov`WebSocketHandler`",
  "JerryI`Misc`WLJS`Transport`"
}];

Needs["CoffeeLiqueur`Notebook`Kernel`" -> "KernelObject`"];
Needs["CoffeeLiqueur`Notebook`Evaluator`" -> "StandardEvaluator`"]

Begin["`Internal`"];

initializeKernel[parameters_][kernel_] := With[{
  wsPort = parameters["env", "ws2"], 
  spinner = Notifications`Spinner["Topic"->"Initialization of the Kernel", "Body"->"Please, wait"]
},
  Print["Init Kernel!!!"];
  EventFire[kernel, spinner, Null];

  

  (* load kernels and provide remote path *)
  With[{
    p = Import[FileNameJoin[{"wljs_packages", #}], "String"], 
    path = ToString[URLBuild[<|"Scheme" -> "http", "Domain" -> (StringTemplate["``:``"][With[{h =  parameters["env", "host"]}, If[h === "0.0.0.0", "127.0.0.1", h] ], parameters["env", "http"] ]), "Path" -> StringRiffle[Drop[FileNameSplit[#], -2], "/"]|> ], InputForm],
    dir = FileNameJoin[{Directory[], "wljs_packages", #}]
  },
    Echo[StringJoin["Loading into Kernel... ", #] ];
    Echo[kernel];
    Echo[kernel["LTPSocket"] ];
    
    With[{processed = StringReplace[p, "$RemotePackageDirectory" -> ("Internal`RemoteFS["<>path<>"]")]},
      
      KernelObject`Async[kernel,  ImportString[processed, "WL"] ](*`*);
    ];
    (*With[{u = StringJoin["Block[{System`$RemotePackageDirectory = Internal`RemoteFS[",path,"]}, Get[\"",dir,"\"] ];"]},
      Echo[u];
      KernelObject`Init[kernel,  ToExpression[ u ] ](*`*);
    ];*)
  ] &/@ WLJS`PM`Includes["kernel"];

  Echo["Starting WS link"];
  wsStartListerning[kernel,  wsPort, parameters["env", "host"] ];

  

  kernel["WebSocket"] = wsPort;

  kernel["Container"] = StandardEvaluator`Container[kernel](*`*);
  kernel["ContainerReadyQ"] = True;

  kernel["State"] = "Initialized";

  With[{hash = kernel["Hash"], s = spinner["Promise"] // First},
    KernelObject`Init[kernel,  EventFire[Internal`Kernel`Stdout[ hash ], "State", "Initialized" ]; ];
    KernelObject`Init[kernel,  EventFire[Internal`Kernel`Stdout[ s ], Resolve, True ]; ];
  ];
]

deinitializeKernel[kernel_] := With[{},
  Echo["Cleaning up..."];

  kernel["ContainerReadyQ"] = False;
  kernel["WebSocket"] = .;
]

wsStartListerning[kernel_, port_, host_] := With[{},
    
    KernelObject`Init[kernel,  (  
        (*Print["Establishing WS link..."];*)
        System`$DefaultSerializer = ExportByteArray[#, "ExpressionJSON"]&;
        Module[{Internal`Kernel`wcp, Internal`Kernel`ws},
          Internal`Kernel`wcp = TCPServer[];
          Internal`Kernel`wcp["CompleteHandler", "WebSocket"] = WebSocketPacketQ -> WebSocketPacketLength;
          
          Internal`Kernel`ws = WebSocketHandler[];
          Internal`Kernel`wcp["MessageHandler", "WebSocket"]  = WebSocketPacketQ -> Internal`Kernel`ws;

          (* configure the handler for WLJS communications *)
          Internal`Kernel`ws["MessageHandler", "Evaluate"]  = Function[True] -> WLJSTransportHandler;

          (* symbols tracking *)
          WLJSTransportHandler["AddTracking"] = Function[{symbol, name, cli, callback},
              (*Print["Add tracking... for "<>name];*)
              Experimental`ValueFunction[ Unevaluated[symbol] ] = Function[{y,x}, 
                If[FailureQ[callback[cli, x] ], 
                  Experimental`ValueFunction[ Unevaluated[symbol] ] // Unset
                ];
              ];
          , HoldFirst];

          WLJSTransportHandler["GetSymbol"] = Function[{expr, client, callback},
              (*Print["evaluating the desired symbol on the Kernel"];*)
              callback[expr // ReleaseHold];
          ];

          (*Echo[StringTemplate["starting @ ``:port ``"][Internal`Kernel`Host, port] ];*)
          SocketListen[CSocketOpen[host, port ], Internal`Kernel`wcp@#&, "SocketEventsHandler"->CSocketsClosingHandler];

          (*SocketListen[port, wcp@#&];*)
        ];
    ) ]
]

End[];

EndPackage[];

{CoffeeLiqueur`Notebook`KernelUtils`Internal`deinitializeKernel, CoffeeLiqueur`Notebook`KernelUtils`Internal`initializeKernel}
