
BeginPackage["JerryI`WolframJSFrontend`Kernel`", {"JTP`"}]; 

LocalKernel::usage = "A wrapper for the local evaluator"

Begin["`Private`"]; 

link = Null;
callback = Null;
checker = Null;
asyncsocket = Null;
status = <|"signal"->"no", "text"->"Not started"|>;

ping = 0;
lastPong = Now;
pongHandler = Null;

Options[LocalKernel] = {"Link"->"WSTP", "PongHandler"->Null};

LocalKernel["JTPLink"] := asyncsocket;
LocalKernel["WSTPLink"] := link;

LocalKernel[ev_, cbk_, OptionsPattern[]] := (
    If[OptionValue["Link"] === "JTP",
        JTPSend[asyncsocket, ev[Global`SendToMaster[cbk]]]
        Print["JTPLink write"];
    ,
        LinkWrite[link, Unevaluated[ev[Global`SendToMaster[cbk]]] ];
        Print["WSTPLink write"];
    ];
);

LocalKernel["PongHandler"][cbk_] := pongHandler = cbk;

LocalKernel["Abort"][cbk_] := ( 
    LinkInterrupt[link, 3]; 
    LinkWrite[link, Unevaluated[$Aborted] ]; 
    status["signal"] = "good"; status["text"] = "Aborted";
    cbk[LocalKernel["Status"]]; 
);

LocalKernel["Status"] := status;

LocalKernel["Start"][cbk_] := Module[{},
    link = LinkLaunch[First[$CommandLine] <> " -wstp"];
    status["signal"] = "load"; status["text"] = "Starting...";
    callback = cbk;

    LinkWrite[link, Unevaluated[$HistoryLength = 0]];
    LinkWrite[link, Unevaluated[PacletDirectoryLoad[Directory[]]]];
    LinkWrite[link, Unevaluated[Get["https://raw.githubusercontent.com/JerryI/tcp-mathematica/main/JTP/JTP.wl"]]];
    LinkWrite[link, Unevaluated[Get["https://raw.githubusercontent.com/JerryI/tinyweb-mathematica/master/WSP/WSP.wl"]]];
    LinkWrite[link, Unevaluated[Needs/@{"JerryI`WolframJSFrontend`Remote`", "JerryI`WolframJSFrontend`Evaluator`"}]]; 
    
    With[{list = JerryI`WolframJSFrontend`WebObjects`list, table = JerryI`WolframJSFrontend`WebObjects`replacement},
        LinkWrite[link, Unevaluated[JerryI`WolframJSFrontend`WebObjects`list = list; JerryI`WolframJSFrontend`WebObjects`replacement = table;]]; 
    ]

    With[{packed = (List["host" -> JerryI`WolframJSFrontend`jtp["host"], "port" -> JerryI`WolframJSFrontend`jtp["port"] ])},
        LinkWrite[link, Unevaluated[Global`ConnectToMaster[packed]]]; 
    ];

    checker = SessionSubmit[ScheduledTask[LocalLinkRestart, {Quantity[10, "Seconds"], 1},  AutoRemove->True]];

    LocalKernel["Status"]      
];

LocalKernel["Started"] := (
    Print["Connected"];
    TaskRemove[checker];
    lastPong = Now;
    asyncsocket = jsocket;
    status = <|"signal"->"good", "text"->"Connected"|>;
    callback[LocalKernel["Status"]];
); 

LocalKernel["Pong"] := (
    ping = Now - lastPong;
    lastPong = Now;
    pongHandler[ping];
);

LocalLinkRestart := (
    Print["Timeout"];
    status = <|"signal"->"load", "text"->"Restarting..."|>;
    LinkClose[link];
    callback[LocalKernel["Status"]];
    SessionSubmit[ScheduledTask[LocalKernel["Start"][callback], {Quantity[2, "Seconds"], 1},  AutoRemove->True]];
);

(*RemoteKernel[pid_][ev_, cbk_, OptionsPattern[]] := Module[{},
    RemoteLinks[pid][OptionValue["Link"]]
];

StartRemoteKernel[pid_] := *)

End[];
EndPackage[];