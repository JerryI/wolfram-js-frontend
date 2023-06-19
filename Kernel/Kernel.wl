BeginPackage["JerryI`WolframJSFrontend`Kernel`", {"JTP`", "JerryI`WolframJSFrontend`Packages`"}]; 

(*
    ::Only for MASTER kernel::

    An abstract Kernel controller package
    - creates a local kernel
    - maintains the WSTP and JTP links
    - plays ping-pong
    - attaches the notebook (or other objects)
    - sets up the modules (can be improved)
*)

LocalKernel::usage = "A wrapper for the local evaluator and its commands"

LocalKernelPromiseResolve::usage = "for internal communication"

Begin["`Private`"]; 

link = Null;
callback = Null;
checker = Null;
asyncsocket = Null;
status = <|"signal"->"no", "text"->"Not started"|>;

ping = 0;
lastPong = Now;
pongHandler = Null;

Options[LocalKernel] = {"Link"->"WSTP", "WatchDog"->Infinity};

(* we uses subvalues to create an easy representation of it on notebooks *)
(* in general, why do not we use subvalues instead of typical OOP?! *)

(* keep the objects for the links *)
LocalKernel["JTPLink"] := asyncsocket;
LocalKernel["WSTPLink"] := link;

(* send some random command async, in our case it will be events *)
LocalKernel["Emitt"][event_] := (JTPSend[asyncsocket, event]);

(* evaluate something with a callback function as a subvalue and get the result via async link *)
(* it can be some evaluator with a data inside *)
LocalKernel[ev_, cbk_, OptionsPattern[]] := (
    If[OptionValue["Link"] === "JTP",
        JTPSend[asyncsocket, ev[Global`SendToMaster[cbk]]]
        Print["JTPLink write"];
    ,
        LinkWrite[link, Unevaluated[ev[Global`SendToMaster[cbk]]] ];
        Print["WSTPLink write"];
    ];
);

promises = <||>;

LocalKernelPromiseResolve[uid_, res_] := (
    promises[uid] = res;
);

LocalKernel["Ask"][expr_] := Module[{res}, With[{uid = CreateUUID[]},
    If[status["signal"] =!= "good", Print["Not running!"]; Return[$Failed]];

    promises[uid] = $Waiting;
    JTPSend[asyncsocket, Global`MasterResolvePromise[expr][uid]];
    While[promises[uid] === $Waiting,
        Pause[0.1];
    ];

    res = promises[uid];
    promise[uid] = .;
    res
]]

LocalKernel["PongHandler"][cbk_] := pongHandler = cbk;

LocalKernel["Abort"][cbk_] := ( 
    Print["Local kernel abort"];
    If[status["signal"] === "good",
        Print["interupt link"];
        LinkInterrupt[link, 3]; 
        Print["aborted"];
        LinkWrite[link, Unevaluated[$Aborted] ]; 
        Print["done"];
        status["signal"] = "good"; status["text"] = "Aborted";
         
    ,
        status["text"] = "Not possible";
    ];
    cbk[LocalKernel["Status"]];
);

LocalKernel["Exit"][cbk_] := ( 
    LinkClose[link]; 
    status["signal"] = "no"; status["text"] = "Closed";
    cbk[LocalKernel["Status"]]; 
);

(* tell the kernel an id of a notebook for the future fast direct communication *)
LocalKernel["AttachNotebook"][id_, path_] := ( 
    Print["attaching "<>id];
    
    If[status["signal"] == "good", 
        (* can be a bug, but it doesnt work if we use a wrapper function *)
        JTPSend[asyncsocket, Global`AttachNotebook[id, path]];
        Print["Kenrel now is aware about notebook id and the path to it"];
    ,
        Print["Kenrel is not ready yet to attach notebook id"];
    ];
);

LocalKernel["Restart"][cbk_] := ( 
    LocalLinkRestart;
);

LocalKernel["Status"] := status;

LocalKernel["Start"][cbk_, OptionsPattern[]] := Module[{},
    link = LinkLaunch[First[$CommandLine] <> " -wstp"];
    status["signal"] = "load"; status["text"] = "Starting...";
    callback = cbk;
    cbk[status];

    LinkWrite[link, Unevaluated[$HistoryLength = 0]];
    LinkWrite[link, Unevaluated[PacletDirectoryLoad[Directory[]]]];
    LinkWrite[link, Unevaluated[Get["Services/JTP/JTP.wl"]]];
    LinkWrite[link, Unevaluated[Get["Services/WSP/WSP.wl"]]];
    
    With[{root = JerryI`WolframJSFrontend`root},
        LinkWrite[link, Unevaluated[JerryI`WolframJSFrontend`root = root]];
    ];

    LinkWrite[link, Unevaluated[Needs/@{"JerryI`WolframJSFrontend`Remote`", "JerryI`WolframJSFrontend`Utils`","JerryI`WolframJSFrontend`WebObjects`", "JerryI`WolframJSFrontend`Evaluator`", "JerryI`WolframJSFrontend`Events`"}]]; 
    
    

    With[{packed = (List["host" -> JerryI`WolframJSFrontend`jtp["host"], "port" -> JerryI`WolframJSFrontend`jtp["port"] ])},
        LinkWrite[link, Unevaluated[Global`ConnectToMaster[packed]]]; 
    ];

    LinkWrite[link, Unevaluated[Global`ConnectToMaster[packed]]]; 

    (* loading kernels *)
    With[{list = FileNameJoin[{JerryI`WolframJSFrontend`root, "Packages", #}] &/@ Includes["wlkernel"]},
        LinkWrite[link, Unevaluated[Get/@list]]; 
    ];

    (* i dunno. this is a fucking bug *)
    LinkWrite[link, Unevaluated["LoadWebObjects"//ToExpression]];

    checker = SessionSubmit[ScheduledTask[LocalLinkRestart, {Quantity[10, "Seconds"], 1},  AutoRemove->True]];

    If[OptionValue["WatchDog"] =!= Infinity,
        With[{timeout = OptionValue["WatchDog"]},
            SessionSubmit[ScheduledTask[LocalLinkTimeoutCheck[timeout], OptionValue["WatchDog"]]]
        ]
    ];

    LocalKernel["Status"]      
];



LocalLinkRestart := (
    Print["Timeout"];
    status = <|"signal"->"load", "text"->"Restarting..."|>;
    LinkClose[link];
    callback[LocalKernel["Status"]];
    SessionSubmit[ScheduledTask[LocalKernel["Start"][callback], {Quantity[2, "Seconds"], 1},  AutoRemove->True]];
);

LocalLinkTimeoutCheck[timeout_] := (
    If[Now - lastPong > timeout,
        LocalKernel["Exit"][Function[s,
            status["signal"] = "bad"; status["text"] = "WatchDog Timeout";
            callback[LocalKernel["Status"]];
            SessionSubmit[ScheduledTask[LocalLinkRestart, {Quantity[2, "Seconds"], 1},  AutoRemove->True]];
        ]]
    ]
);

(* internal functions!!! called by secodnary kernel *)
LocalKernel["Started"] := (
    Print["Connected"];
    TaskRemove[checker];
    lastPong = Now;
    asyncsocket = jsocket;
    Print["asyncsocket id: "<>jsocket];
    status = <|"signal"->"good", "text"->"Connected"|>;
    callback[LocalKernel["Status"]];
); 


LocalKernel["Pong"] := (
    ping = Now - lastPong;
    lastPong = Now;
    pongHandler[ping];
);

(*RemoteKernel[pid_][ev_, cbk_, OptionsPattern[]] := Module[{},
    RemoteLinks[pid][OptionValue["Link"]]
];

StartRemoteKernel[pid_] := *)

End[];
EndPackage[];