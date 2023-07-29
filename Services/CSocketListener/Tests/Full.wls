PacletInstall["KirillBelov/Internal"]
<< KirillBelov`Internal`;

SetDirectory[$InputFileName // DirectoryName]
Get[FileNameJoin[{ParentDirectory[Directory[]], "Kernel", "CSocketListener.wl"}]]

PacletInstall["KirillBelov/TCPServer", ForceVersionInstall->True]
<< KirillBelov`TCPServer`;
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/WSP.wl"];


Get["https://raw.githubusercontent.com/KirillBelovTest/HTTPHandler/main/Kernel/HTTPHandler.wl"]
Get["https://raw.githubusercontent.com/KirillBelovTest/HTTPHandler/main/Kernel/Extensions.wl"]

PacletInstall["KirillBelov/WebSocketHandler", ForceVersionInstall->True]
<< KirillBelov`WebSocketHandler`;

Get["https://raw.githubusercontent.com/JerryI/wl-misc/main/Kernel/Events.wl"]
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/Hydrator.wl"]

$PublicDirectory = FileNameJoin[{Directory[], "Full"}]


Print["Staring HTTP server..."];

tcp = TCPServer[];
tcp["CompleteHandler", "HTTP"] = HTTPPacketQ -> HTTPPacketLength;
tcp["MessageHandler", "HTTP"] = HTTPPacketQ -> http;

http = HTTPHandler[];

http["MessageHandler", "Index"] = AssocMatchQ[<|"Path" -> "/"|>] -> (HypertextProcess[#, "index.wsp", "Base" -> $PublicDirectory] &)
http["MessageHandler", "WSP"] = GetFileRequestQ[{"wsp"}] -> (HypertextProcess[#, "Base" -> $PublicDirectory] &)

(* ::End::*)
httplistener =  Check[CSocketListen["127.0.0.1:8010", tcp@# &], Print["FUCK LibraryLink and Sockets! Using shitty ZMQ..."]; SocketListen["127.0.0.1:8010", tcp@# &]];

Print["Staring WS/HTTP server..."];

wcp = TCPServer[]
wcp["CompleteHandler", "WebSocket"] = WebSocketPacketQ -> WebSocketPacketLength
wcp["MessageHandler", "WebSocket"]  = WebSocketPacketQ -> ws

ws = WebSocketHandler[]

ws["MessageHandler", "Evaluate"]  = Function[True] -> evaluate

evaluate[cl: _SocketObject | _CSocket, data_ByteArray] := Block[{Global`client = cl},
    ToExpression[data//ByteArrayToString];
]

Check[CSocketListen["127.0.0.1:8020", wcp@#&], Print["FUCK LibraryLink and Sockets! Using shitty ZMQ..."]; SocketListen["127.0.0.1:8020", wcp@#&]];

SetOptions[WSPEngine, "Cache" -> False];

NotebookGetSymbol[uid_, params_][expr_] := WebSocketSend[Global`client, ExportByteArray[Global`PromiseResolve[uid, expr // ReleaseHold], "ExpressionJSON", "Compact"->0]];

NotebookAddTracking[symbol_] := With[{cli = Global`client, name = SymbolName[Unevaluated[symbol]]},
    Print["Add tracking... for "<>name];
    Experimental`ValueFunction[Unevaluated[symbol]] = Function[{y,x}, 
      If[FailureQ[
        WebSocketSend[cli, ExportByteArray[Global`FrontUpdateSymbol[name, x], "ExpressionJSON", "Compact"->0]]
      ],
        Print["tracking of "<>ToString[Unevaluated[symbol]]<>" was removed for "<>cli[[1]]];
        Unset[Experimental`ValueFunction[Unevaluated[symbol]]];
      ]
    ]
]

SetAttributes[NotebookAddTracking, HoldFirst];










data = {{0,0}}; 

EventHandler["update", Function[d,
  Print["updating data!"];
  data = Table[{x, Sin[x 100 d]}, {x, 0, 2Pi, 0.01}];
]]

Pause[1];
CEventLoopRun[0]

StringTemplate["open http://``:``/"][httplistener[[1]]["Host"], httplistener[[1]]["Port"]] // Print;
While[True, Pause[1]];

