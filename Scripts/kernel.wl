Once[If[PacletFind["KirillBelov/Internal"] === {}, PacletInstall["KirillBelov/Internal"]]]; 
<<KirillBelov`Internal`;

Get["https://raw.githubusercontent.com/KirillBelovTest/TCPServer/main/Kernel/TCPServer.wl"]
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/WSP.wl"]

Once[If[PacletFind["KirillBelov/WebSocketHandler"] === {}, PacletInstall["KirillBelov/WebSocketHandler"]]]; 
<<KirillBelov`WebSocketHandler`;

Get["Services/JTP/JTP.wl"];
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/WSP.wl"];
Get["https://raw.githubusercontent.com/JerryI/wl-misc/main/Kernel/Events.wl"];

Needs/@{"JerryI`WolframJSFrontend`Remote`", "JerryI`WolframJSFrontend`Utils`","JerryI`WolframJSFrontend`WebObjects`", "JerryI`WolframJSFrontend`Evaluator`"}; 
    


$WSStart[port_, addr_:"127.0.0.1"] :=
Module[{wcp, ws},
    wcp = TCPServer[];
    wcp["CompleteHandler", "WebSocket"] = WebSocketPacketQ -> WebSocketPacketLength;
    wcp["MessageHandler", "WebSocket"]  = WebSocketPacketQ -> ws;

    ws = WebSocketHandler[];

    ws["MessageHandler", "Evaluate"]  = Function[True] -> evaluate;

    evaluate[cl_SocketObject, data_ByteArray] := Block[{Global`client = cl},
        ToExpression[data//ByteArrayToString];
    ];

    SocketListen[addr<>":"<>ToString[port], wcp@#&]
]
