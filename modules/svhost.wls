Options[ProcessStart] = {"task"->Null, "init"->{}, "prolog"->Null,"epilog"->Null, "list"->{}, "name"->"Untitled", "after"->Null};  

ProcessStart[id_, OptionsPattern[]] :=   
With[{},      
    If[!KeyExistsQ[settings["processes"], id],
        settings["processes"][id] = <||>;
        settings["processes"][id]["name"]  = OptionValue["name"];
        settings["processes"][id]["task"]  = OptionValue["task"];
        settings["processes"][id]["init"]  = OptionValue["init"];
        settings["processes"][id]["list"]  = OptionValue["list"];
        settings["processes"][id]["prolog"]   = OptionValue["prolog"];
        settings["processes"][id]["epilog"]   = OptionValue["epilog"];
        settings["processes"][id]["after"] = OptionValue["after"];

        console["log", "process `` is about to start. Generated id is ``", OptionValue["name"], id];
        settings["processes"][id]["trials"] = 0;
    ,
        console["log", "process `` is about to restart.", settings["processes"][id]["name"]];
    ];

    settings["processes"][id]["date"] = Now;

    settings["processes"][id]["pid"] = StartProcess["wolframscript"];
    WriteString[settings["processes"][id]["pid"], StringTemplate["$id = \"``\" \r\n"][id]];
    WriteString[settings["processes"][id]["pid"], StringTemplate["$kitchen = \"``\" \r\n"][List["host" -> $env["addr"], "port" -> jtp["port"] ]//Compress] ];
 
    

    WriteString[settings["processes"][id]["pid"], "Get[\"svcore/run.wls\"] \r\n"];
    ProcessUpdateStatus[id, "launching"];

    SessionSubmit[ScheduledTask[ProcessCheck[id], {Quantity[10, "Seconds"], 1},  AutoRemove->True]];

    id
];

ProcessKill[id_] := With[{},
    KillProcess[settings["processes", id, "pid"]];
    Run["ps aux | grep \"WolframKernel -wlbanner\" | awk '{print $2}' | xargs kill -9 $1"];
    ProcessUpdateStatus[id, "failed"];
    settings["processes"][id] = .;
];

ProcessCheckIn[id_, eventlistener_] := With[{},
    ProcessUpdateStatus[id, "running"];
    GasWarmer;
    console["log", "`` >> hi guys!", settings["processes"][id]["name"]];

    (* register socket id*)
    settings["processes", id, "socket"] = jsocket;

    (* connect to event listerner *)
    settings["processes", id, "listener"] = (JTPClient@@eventlistener) // JTPClientStart;

    (*grabbing the data*)

    settings["processes"][id]

];

ProcessEventEmitt[id_, type_:"submit"][cli_, data_] := With[{},
    console["log", ">> process event emitt, type: `` for ``", type, id];
    JTPClientSend[settings["processes", id, "listener"], EmittedEvent[type, cli, data]];
    Sequence[cli, data]
];

ProcessCheckOut[id_, logs_] := With[{},
    ProcessUpdateStatus[id, "finished"];
    GasColder;
    (*KillProcess[settings["processes", id, "pid"]];*)

    settings["processes", id, "listener"] // JTPClientStop;

    console["log", " `` >> ``", settings["processes", id]["name"], #]&/@Flatten[logs];

    With[{next = settings["processes"][id]["after"]},
        SessionSubmit[ScheduledTask[next // ReleaseHold, {Quantity[1, "Seconds"], 1},  AutoRemove->True]];
    ];

    settings["processes"][id] = .;
    
];

ProcessCheck[id_] := With[{},
    If[settings["processes", id, "status"] == "launching",

        console["log", "process >> received ``", ReadString[settings["processes"][id]["pid"], EndOfBuffer]];

        console["log", "process >> END OF FILE"];

        If[TrueQ[ProcessStatus[settings["processes", id, "pid"]] == "Finished"],
            PushNotification["modules/svhost/processcheck", StringTemplate["Process `` crashed. We will try to restart it"][settings["processes"][id]["name"]]];
        ,
            PushNotification["modules/svhost/processcheck", StringTemplate["Process `` is freezed. We will try to restart it"][settings["processes"][id]["name"]]];
        ];

        KillProcess[settings["processes", id, "pid"]];
        Run["ps aux | grep \"WolframKernel -wlbanner\" | awk '{print $2}' | xargs kill -9 $1"];

        
        settings["processes"][id]["trials"] =  settings["processes"][id]["trials"] + 1;
        


        If[settings["processes"][id]["trials"] > 2,
            PushNotification["modules/svhost/processcheck", StringTemplate["Process `` cannot be created for some reason. We are sorry."][settings["processes"][id]["name"]]];
            ProcessUpdateStatus[id, "failed"];
            settings["processes"][id] = .;

        ,
            ProcessStart[id];
        ];

    ]
];

RemoteEvaluator[id_][exp_, rules_, storage_, block_, callback_] := (
    JTPClientSend[settings["processes", id, "listener"], SimpleEvaluator[exp, rules, storage, block, callback ] ];
);


ProcessUpdateStatus[personal_, mess_] := With[{}, 
  settings["processes"][personal]["status"] = mess;  

  console["log", "- process broadcast"];

  WebSocketBroadcast[server,
    UpdateProcesses[
      StringJoin@@Table[ 
        With[{i = uid},
          LoadPage["assets/processtoast.wsp", {id = i, state = " immediate"}, "base"->$env["path"]]
        ]
      , {uid, settings["processes"]//Keys}]
    ]
  ];

];