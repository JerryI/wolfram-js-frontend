SetDirectory[DirectoryName[$InputFileName] // ParentDirectory]

If[PacletFind["JerryI/LPM"] === {},
    If[FailureQ[
      PacletInstall["JerryI/LPM"]
    ], 
      Print["Oh AGAIN you WOLFRAM! We wil try to use Github"];
      Get["https://raw.githubusercontent.com/JerryI/wl-localpackages/main/Kernel/LPM.wl"];
    ,
      <<JerryI`LPM`;
    ];
,
    <<JerryI`LPM`;
];


PacletRepositories[{}, "Directory"->JerryI`WolframJSFrontend`root, "Passive"->True]

<<KirillBelov`CSockets`
<<KirillBelov`Objects`
<<KirillBelov`Internal`
<<KirillBelov`TCPServer`
<<KirillBelov`WebSocketHandler`

<<JerryI`WSP`
<<JerryI`WSP`PageModule`

Get[FileNameJoin[{JerryI`WolframJSFrontend`root, "Services", "JTP", "JTP.wl"}]];

With[{dir = Directory[]},
    FrontEndDirectory[] := dir;
];

<<JerryI`Misc`Events`
<<JerryI`Misc`Async`
<<JerryI`Misc`Language`

JerryI`WolframJSFrontend`settings = If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".settings"}]], Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".settings"}]], <|"displayForm"->True, "background"->True, "autosave"->1000*60*3, "fastboot"->False|>]

Needs/@{"JerryI`WolframJSFrontend`Remote`", "JerryI`WolframJSFrontend`Utils`","JerryI`WolframJSFrontend`WebObjects`", "JerryI`WolframJSFrontend`Evaluator`"}; 


$WSStart[port_, addr_:"127.0.0.1"] :=
Module[{wcp, ws},
    wcp = TCPServer[];
    wcp["CompleteHandler", "WebSocket"] = WebSocketPacketQ -> WebSocketPacketLength;
    wcp["MessageHandler", "WebSocket"]  = WebSocketPacketQ -> ws;

    ws = WebSocketHandler[];

    ws["MessageHandler", "Evaluate"]  = Function[True] -> evaluate;

    evaluate[cl_, data_ByteArray] := Block[{Global`client = cl},
        ToExpression[data//ByteArrayToString];
    ];

    SocketListen[CSocketOpen[addr, port], wcp@#&];

    (*CEventLoopRun[0];*)
]
