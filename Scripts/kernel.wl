Once[If[PacletFind["KirillBelov/Internal"] === {}, PacletInstall["KirillBelov/Internal"]]]; 
<<KirillBelov`Internal`;

Get["https://raw.githubusercontent.com/KirillBelovTest/TCPServer/main/Kernel/TCPServer.wl"]
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/WSP.wl"]

Once[If[PacletFind["KirillBelov/WebSocketHandler"] === {}, PacletInstall["KirillBelov/WebSocketHandler"]]]; 
<<KirillBelov`WebSocketHandler`;

Get["Services/JTP/JTP.wl"];
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/WSP.wl"];

Needs/@{"JerryI`WolframJSFrontend`Remote`", "JerryI`WolframJSFrontend`Utils`","JerryI`WolframJSFrontend`WebObjects`", "JerryI`WolframJSFrontend`Evaluator`"}; 
    
Get["https://raw.githubusercontent.com/JerryI/wl-misc/main/Kernel/Events.wl"];

$WSStart[port_] :=
Module[{wcp, ws},
    wcp = TCPServer[];
    wcp["CompleteHandler", "WebSocket"] = WebSocketPacketQ -> WebSocketPacketLength;
    wcp["MessageHandler", "WebSocket"]  = WebSocketPacketQ -> ws;

    ws = WebSocketHandler[];

    ws["MessageHandler", "Evaluate"]  = Function[True] -> evaluate;

    evaluate[cl_SocketObject, data_ByteArray] := Block[{Global`client = cl},
        ToExpression[data//ByteArrayToString];
    ];

    SocketListen[port, wcp@#&]
]
