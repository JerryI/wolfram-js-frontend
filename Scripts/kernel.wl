Once[If[PacletFind["KirillBelov/Objects"] === {}, PacletInstall["KirillBelov/Objects"]]]; 
<<KirillBelov`Objects`;

Get[FileNameJoin[{JerryI`WolframJSFrontend`root, "Services","CSocketListener", "Kernel", "CSocketListener.wl"}]]

(*Once[If[PacletFind["KirillBelov/TCPServer"] === {}, PacletInstall["KirillBelov/TCPServer"]]]; 
<<KirillBelov`TCPServer`;*)
Get["https://raw.githubusercontent.com/KirillBelovTest/TCPServer/main/Kernel/TCPServer.wl"]

Once[If[PacletFind["KirillBelov/Internal"] === {}, PacletInstall["KirillBelov/Internal"]]]; 
<<KirillBelov`Internal`;

(* did not update yet *)
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/WSP.wl"]

Once[If[PacletFind["KirillBelov/WebSocketHandler"] === {}, PacletInstall["KirillBelov/WebSocketHandler"]]]; 
<<KirillBelov`WebSocketHandler`;

Get[FileNameJoin[{"Services", "JTP", "JTP.wl"}]];

With[{dir = Directory[]},
    FrontEndDirectory[] := dir;
];

Get["https://raw.githubusercontent.com/JerryI/wl-misc/main/Kernel/Events.wl"];

Needs/@{"JerryI`WolframJSFrontend`Remote`", "JerryI`WolframJSFrontend`Utils`","JerryI`WolframJSFrontend`WebObjects`", "JerryI`WolframJSFrontend`Evaluator`"}; 
    


$WSStart[port_, addr_:"127.0.0.1"] :=
Module[{wcp, ws},
    wcp = TCPServer[];
    wcp["CompleteHandler", "WebSocket"] = WebSocketPacketQ -> WebSocketPacketLength;
    wcp["MessageHandler", "WebSocket"]  = WebSocketPacketQ -> ws;

    ws = WebSocketHandler[];

    ws["MessageHandler", "Evaluate"]  = Function[True] -> evaluate;

    evaluate[cl: _SocketObject | _CSocket, data_ByteArray] := Block[{Global`client = cl},
        ToExpression[data//ByteArrayToString];
    ];

    SocketListen[ToExpression[port], wcp@#&]
    (*SocketListen[ToExpression[port], wcp@#&]*)
]
