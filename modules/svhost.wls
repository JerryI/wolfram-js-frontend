Options[ProcessStart] = {"task"->Null, "init"->{}, "prolog"->Null,"epilog"->Null, "list"->{}, "name"->"Untitled", "after"->Null};  

ProcessStart[id_, OptionsPattern[]] :=   
Module[{repl},      
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

    ProcessUpdateStatus[id, "launching"];
    settings["processes"][id]["link"] = LinkLaunch[First[$CommandLine] <> " -wstp"];

    With[{uid = id},
        LinkWrite[settings["processes"][id]["link"], Unevaluated[$id = uid]];
    
    ];

    With[{packed = (List["host" -> $env["addr"], "port" -> jtp["port"] ]//Compress)},
        LinkWrite[settings["processes"][id]["link"], Unevaluated[$kitchen = packed]];
      
    ];

    LinkWrite[settings["processes"][id]["link"], Unevaluated[Get["svcore/run.wls"]]];  
  
    SessionSubmit[ScheduledTask[ProcessCheck[id], {Quantity[10, "Seconds"], 1},  AutoRemove->True]];

    id
];

ProcessKill[id_] := With[{},
    JTPClientSend[settings["processes", id, "listener"], $Die];
    
    (*now for sure kill it*)
    LinkClose[settings["processes", id, "link"]];
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

        PushNotification["modules/svhost/processcheck", StringTemplate["Process `` is freezed. We will try to restart it"][settings["processes"][id]["name"]]];

        LinkClose[settings["processes", id, "link"]];

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
    LinkWrite[settings["processes", id, "link"], Unevaluated[SimpleEvaluator[exp, rules, storage, block, callback ]] ];
);

RemoteEvaluator[id_]["abort"] := ( LinkInterrupt[settings["processes", id, "link"], 3]; LinkWrite[settings["processes", id, "link"], Unevaluated[$Aborted] ]; PushNotification["modules/svhost", "Evaluation <span class=\"badge badge-danger\">aborted</span>"]; );


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