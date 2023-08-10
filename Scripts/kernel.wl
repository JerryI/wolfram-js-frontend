DeleteFile["log.txt"];

DefineOutputStreamMethod[
  "DebugWarning", {"ConstructorFunction" -> 
    Function[{name, isAppend, caller, opts}, 
     With[{state = Unique["JaBo3o"]},
      {True, state}]], 
   "CloseFunction" -> Function[state, ClearAll[state]], 
   "WriteFunction" -> 
    Function[{state, bytes},(*Since we're writing to a cell,
     we don't want that trailing newline.*)
     With[{out = bytes /. {most___, 10} :> FromCharacterCode[{most}]},
       With[{ }, 
       If[out === "", {0, state},
       

        With[{text =ByteArrayToString[out // ByteArray], uid = notebook},
            text >>> "log.txt";
        ];

        {Length@bytes, state}]]]]}
];

DefineOutputStreamMethod[
  "DebugPrint", {"ConstructorFunction" -> 
    Function[{name, isAppend, caller, opts}, 
     With[{state = Unique["JaBoo0"]},
      {True, state}]], 
   "CloseFunction" -> Function[state, ClearAll[state]], 
   "WriteFunction" -> 
    Function[{state, bytes},(*Since we're writing to a cell,
     we don't want that trailing newline.*)
     With[{out = bytes /. {most___, 10} :> FromCharacterCode[{most}]},
       With[{ }, 
       If[out === "", {0, state},
       

        With[{text =ToString[out], uid = notebook},
            text >>> "log.txt";
        ];

        {Length@bytes, state}]]]]}
];

$Messages = {OpenWrite[Method -> "DebugWarning"]};
$Output = {OpenWrite[Method -> "DebugPrint"]};


Once[If[PacletFind["JerryI/LPM"] === {}, PacletInstall["JerryI/LPM"]]]; 
<<JerryI`LPM`

PacletRepositories[{}, "Directory"->JerryI`WolframJSFrontend`root, "Passive"->True]

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

    SocketListen[StringTemplate["``:``"][addr, port], wcp@#&];

    (*CEventLoopRun[0];*)
]
