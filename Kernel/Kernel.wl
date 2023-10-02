BeginPackage["JerryI`WolframJSFrontend`Kernel`", {"JTP`", "JerryI`WolframJSFrontend`Packages`", "KirillBelov`WebSocketHandler`", "JerryI`WolframJSFrontend`Utils`"}]; 

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
    TaskRemove[checker];
    link = Null;
    status["signal"] = "no"; status["text"] = "Closed";
    cbk[LocalKernel["Status"]]; 
);

(* tell the kernel an id of a notebook for the future fast direct communication *)
LocalKernel["AttachNotebook"][id_, path_, cbk_:Null] := ( 
    Print["attaching "<>id];
    
    If[status["signal"] == "good", 
        (* can be a bug, but it doesnt work if we use a wrapper function *)
        JTPSend[asyncsocket, Global`AttachNotebook[id, path]];
        WebSocketSend[JerryI`WolframJSFrontend`Notebook`Notebooks[id, "channel"], Global`FrontEndAssignKernelSocket[JerryI`WolframJSFrontend`$env["ws2"]]];
        Print["Kenrel now is aware about notebook id and the path to it"];
    ,
        Print["Kenrel is not ready yet to attach notebook id"];
        With[{nid = id, npath = path},
            promiseToConnect := (
                Print["promise to attach "<>nid<>"...."];
                JTPSend[asyncsocket, Global`AttachNotebook[nid, npath]];
                Print["ws send "<>nid<>"...."];
                WebSocketSend[JerryI`WolframJSFrontend`Notebook`Notebooks[nid, "channel"], Global`FrontEndAssignKernelSocket[JerryI`WolframJSFrontend`$env["ws2"]]];
                Print["Promise to connect was resolved"];    
                promiseToConnect = Null;        
            );
        ];
    ];
    If[cbk =!= Null, callback = cbk];
);

LocalKernel["Restart"][cbk_] := ( 
    LocalKernel["Start"][cbk];
);

LocalKernel["Status"] := status;

LocalKernel["Start"][cbk_, OptionsPattern[]] := Module[{},
    If[link =!= Null, LocalKernel["Exit"][Null]; Pause[1]];
    Print[First[$CommandLine]];

    (* oh God, Wolfram what did you do... *)
    link = LinkLaunch["\""<>First[$CommandLine] <> "\" -wstp"];
    
    If[FailureQ[link], Print[">> Failed! Trying legacy math process..."]; link = LinkLaunch["math -mathlink"]];
    If[FailureQ[link], Print[">> Failed! Trying math process..."]; link = LinkLaunch["math -wstp"]];
    If[FailureQ[link], Print[">> Failed! Trying wolfram process..."]; link = LinkLaunch["wolfram -wstp"]];
    If[FailureQ[link], Print[">> Failed! Trying second args of the command line..."]; link = LinkLaunch["\""<> $CommandLine[[2]] <> "\" -wstp"]];
    If[FailureQ[link], Print[">> Failed! Assumming MacOS shitty paths..."]; link = LinkLaunch["/Applications/Mathematica.app/Contents/MacOS/WolframKernel -wstp"]];
    If[FailureQ[link], Print[">> Failed! Assumming MacOS shitty paths... mb it is a wolfram engine"]; link = LinkLaunch["\"/Applications/Wolfram Engine.app/Contents/MacOS/WolframKernel\" -wstp"]];
    If[FailureQ[link], 
        Print[">> Failed! ;() It might be that the path to wolfram kernel is not correctly written in your OS"];
        status["signal"] = "bad"; status["text"] = "Failed";
        callback = cbk;
        cbk[status];
        Return[];
    ];

    status["signal"] = "load"; status["text"] = "Starting...";
    callback = cbk;
    cbk[status];

    LinkWrite[link, Unevaluated[$HistoryLength = 0]];
    LinkWrite[link, Unevaluated[PacletDirectoryLoad[Directory[]]]];

    With[{root = JerryI`WolframJSFrontend`root},
        LinkWrite[link, Unevaluated[JerryI`WolframJSFrontend`root = root]];
    ];

    With[{settings = JerryI`WolframJSFrontend`settings},
        LinkWrite[link, Unevaluated[JerryI`WolframJSFrontend`settings = settings]];
    ];

    LinkWrite[link, Unevaluated[Get["Scripts/kernel.wl"]]];

    (* loading urgent kernels *)
    With[{list = FileNameJoin[{JerryI`WolframJSFrontend`root, "Packages", #}] &/@ Includes["wlkernelstartup"]},
        LinkWrite[link, Unevaluated[Get/@list]]; 
    ];    

    With[{packed = (List["host" -> JerryI`WolframJSFrontend`jtp["host"], "port" -> JerryI`WolframJSFrontend`jtp["port"] ])},
        LinkWrite[link, Unevaluated[Global`ConnectToMaster[packed]]]; 
    ];

    With[{p = JerryI`WolframJSFrontend`$env["ws2"], h = JerryI`WolframJSFrontend`$env["host"]},
        LinkWrite[link, Unevaluated[Global`$WSStart[p, h]]]
    ];
    



    LinkWrite[link, Unevaluated[Global`ConnectToMaster[packed]]]; 

    (* loading kernels *)
    With[{list = FileNameJoin[{JerryI`WolframJSFrontend`root, "Packages", UniversalPathConverter[#]}] &/@ Includes["wlkernel"]},
        LinkWrite[link, Unevaluated[Get/@list]]; 
    ];

    (* i dunno. this is a fucking bug *)
    LinkWrite[link, Unevaluated["LoadWebObjects"//ToExpression]];

    Print["-- Link read --"];
    With[{dt = LinkRead[link]},
        Echo[dt];
        If[ToString[dt] == "$Failed",
            status["signal"] = "bad"; status["text"] = "License issue";
            LinkClose[link];
            TaskRemove[checker];
            Print[Red<>"There is a problem related to your license. Try to close other Wolfram Kernel executables."];
            Return[LocalKernel["Status"], Module];
        ];
    ];

    checker = SessionSubmit[ScheduledTask[LocalLinkRestart, {Quantity[15, "Seconds"], 1},  AutoRemove->True]];

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
    TaskRemove[checker];
    LinkClose[link];
    link = Null;
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

ptask = Null;
(* internal functions!!! called by secodnary kernel *)
LocalKernel["Started"] := Module[{},
    Print["Connected"];
    TaskRemove[checker];
    lastPong = Now;
    asyncsocket = jsocket;
    Print["asyncsocket id: "<>jsocket];
    status = <|"signal"->"good", "text"->"Connected"|>;
    callback[LocalKernel["Status"]];
    
    ptask = SessionSubmit[ScheduledTask[promiseToConnect; TaskRemove[ptask], {Quantity[3, "Seconds"], 1},  AutoRemove->True]];

]; 


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