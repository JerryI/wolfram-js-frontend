(*binging to the events*)
Unprotect[NotebookCreate];
Unprotect[NotebookOpen];
Unprotect[NotebookEvaluate];

ClearAll[NotebookOpen];
ClearAll[NotebookCreate];
ClearAll[NotebookEvaluate];

Options[NotebookCreate] = {
    "name" -> "Untitled",
    "id" :> CreateUUID[],
    "evaluator" -> SimpleEvaluator,
    "kernel" -> Null,
    "objects" -> <||>,
    "variables" -> <||>,
    "ref" -> Null,
    "sandboxed" -> False,
    "data" -> "1+1",
    "pre" -> Null
};

NotebookExtendDefinitions[defs_][sign_] := ;

NotebookCreate[OptionsPattern[]] := (
    With[{id = OptionValue["id"]},

        notebooks[id] = <|
            "name" -> OptionValue["name"],
            "evaluator" -> OptionValue["evaluator"],
            "ref" -> OptionValue["ref"],
            "sandboxed" -> OptionValue["sandboxed"],
            "pre" -> OptionValue["pre"]
        |>;

        notebooks[id, "cell"] = CellObj["sign"->id, "type"->"input", "data"->OptionValue["data"]];
        id
    ]
);

NotebookRemove[id_] := (
    CellObjRemoveAllNext[notebooks[id, "cell"] ];
    CellObjRemove[notebooks[id, "cell"] ];
    
    notebooks[id] = .;
);

(*access only via websockets*)
NotebookAttach[id_, proc_, init_:Null] := Module[{pid = proc},
    If[proc === "master", 
        notebooks[id]["evaluator"] = SimpleEvaluator; 
        WebSocketSend[client, FrontEndAddKernel[pid, "sandbox"] ]; 
        PushNotification["modules/notebook", "<span class=\"badge badge-danger\">Master kernel attached</span> <p>If we die, we die</p>"]; 
        Return["master", Module] 
    ];
    With[{c = client, p = pid},
        If[proc === "Null"  ,
            pid = CreateUUID[];
            ProcessStart[pid, "name" -> "sandbox", "task" -> "svcore/sandbox.wls", "epilog"->Hold[WebSocketSend[c, FrontEndAddKernel[p, "sandbox"] ];], "prolog" -> notebooks[id]["pre"] ];
        
        ,
            JTPClientSend[settings["processes", proc, "listener"], Import["svcore/sandbox.wls"]; WebSocketSend[c, FrontEndAddKernel[proc, "sandbox"] ]; ];
        ];
    ];

    notebooks[id]["evaluator"] = RemoteEvaluator[pid];
];

EmittEvent[id_, data_] := With[{cli = client},
    (* global *)
    EmittedEvent[id, cli, data];
    ( JTPClientSend[settings["processes", #, "listener"], EmittedEvent[id, cli, data]]; ) &/@ Keys[settings["processes"]];
];

EventBind[EventObject[assoc_], handler_] ^:= (EventHandlers[assoc["id"]] = handler);
EmittedEvent[id_, cli_, data_] := EventHandlers[id][cli, data];

NotebookOpen[id_] := (
    Block[{fireEvent = CellEventFire[client]},
        CellObjGenerateTree[notebooks[id, "cell"]];
    ];
);

NotebookEvaluate[id_, cellid_] := (
    Block[{fireEvent = CellEventFire[client]},
        CellObjEvaluate[CellObj[cellid], notebooks[id, "evaluator"] ];
    ];
);

NotebookAbort[id_] := (
    Block[{fireEvent = CellEventFire[client]},
        notebooks[id, "evaluator"]["abort"];
    ];
);

NotebookOperate[cellid_, op_] := (
    Block[{fireEvent = CellEventFire[client]},
        op[CellObj[cellid]];
    ];
);

NotebookExport[id_] := Module[{content, file = notebooks[id, "name"]<>StringTake[CreateUUID[], 3]<>".html"},
    content = Block[{session = <|"Query"-><|"id"->id|>|>, commandslist = {}},
        Block[{WebSocketSend = Function[{addr, data}, commandslist={commandslist, data};], fireEvent = CellEventFire[""]},
            CellObjGenerateTree[notebooks[id, "cell"]];
        ];
        commandslist = ExportString[commandslist//Flatten, "ExpressionJSON"];

        LoadPage["notebook/export/entire.wsp", {}, "base"->"public"]
    ];

    Export["public/trashcan/"<>file, content, "String"];
    WebSocketSend[client, FrontEndJSEval[StringTemplate["downloadByURL('http://'+window.location.hostname+':'+window.location.port+'/trashcan/``', '``')"][file, file]]];
];

CellEventFire[addr_]["NewCell"][cell_] := (
    (*looks ugly actually. we do not need so much info*)
    With[
        {
            obj = <|
                        "id"->cell[[1]], 
                        "sign"->cell["sign"],
                        "type"->cell["type"],
                        "data"->If[cell["data"]//NullQ, "", ExportString[cell["data"], "String", CharacterEncoding -> "UTF8"] ],
                        "child"->If[NullQ[ cell["child"] ], "", cell["child"][[1]]],
                        "parent"->If[NullQ[ cell["parent"] ], "", cell["parent"][[1]]],
                        "next"->If[NullQ[ cell["next"] ], "", cell["next"][[1]]],
                        "prev"->If[NullQ[ cell["prev"] ], "", cell["prev"][[1]]],
                        "storage"->cell["storage"]
                    |>,
            
            template = LoadPage["public/assets/cells/"<>cell["type"]<>".wsp", {id = cell[[1]]}]
        },

        WebSocketSend[addr, FrontEndCreateCell[template, ExportString[obj, "JSON"] ]];
    ];
);

CellEventFire[addr_]["RemovedCell"][cell_] := (
    (*actually frirstly you need to check!*)
  
    With[
        {
            obj = <|
                        "id"->cell[[1]], 
                        "sign"->cell["sign"],
                        "type"->cell["type"],
                        "child"->If[NullQ[ cell["child"] ], "", cell["child"][[1]]],
                        "parent"->If[NullQ[ cell["parent"] ], "", cell["parent"][[1]]],
                        "next"->If[NullQ[ cell["next"] ], "", cell["next"][[1]]],
                        "prev"->If[NullQ[ cell["prev"] ], "", cell["prev"][[1]]]
                    |>
        },

        WebSocketSend[addr, FrontEndRemoveCell[ExportString[obj, "JSON"] ]];
    ];
);

CellEventFire[addr_]["ClearStorage"][cell_] := (
    (*actually frirstly you need to check!*)
  
    With[
        {
            obj = <|
                        "id"->cell[[1]], 
                        "storage"->Keys[cell["storage"]]
                    |>
        },

        WebSocketSend[addr, FrontEndClearStorage[ExportString[obj, "JSON"] ]];
    ];
);

CellEventFire[addr_]["CellError"][cell_, text_] := WebSocketSend[addr, FrontEndCellError[cell[[1]], text]];

CellEventFire[addr_]["CellMove"][cell_, parent_] := (
    With[
        {   template = LoadPage["public/assets/cells/input.wsp", {id = cell[[1]]}],
            obj = <|
                    "cell"-> <|
                        "id"->cell[[1]], 
                        "sign"->cell["sign"],
                        "type"->cell["type"],
                        "child"->If[NullQ[ cell["child"] ], "", cell["child"][[1]]],
                        "parent"->If[NullQ[ cell["parent"] ], "", cell["parent"][[1]]],
                        "next"->If[NullQ[ cell["next"] ], "", cell["next"][[1]]],
                        "prev"->If[NullQ[ cell["prev"] ], "", cell["prev"][[1]]]
                    |>,

                    "parent"-> <|
                        "id"->parent[[1]], 
                        "sign"->parent["sign"],
                        "type"->parent["type"],
                        "child"->If[NullQ[ parent["child"] ], "", parent["child"][[1]]],
                        "parent"->If[NullQ[ parent["parent"] ], "", parent["parent"][[1]]],
                        "next"->If[NullQ[ parent["next"] ], "", parent["next"][[1]]],
                        "prev"->If[NullQ[ parent["prev"] ], "", parent["prev"][[1]]]                        
                    |>
                |>
        },

        WebSocketSend[addr, FrontEndMoveCell[template, ExportString[obj, "JSON"] ]];
    ];
);

CellEventFire[addr_]["CellMorph"][cell_] := (
    With[
        {
            obj = <|
                    "id"->cell[[1]], 
                    "sign"->cell["sign"],
                    "type"->cell["type"],
                    "child"->If[NullQ[ cell["child"] ], "", cell["child"][[1]]],
                    "parent"->If[NullQ[ cell["parent"] ], "", cell["parent"][[1]]],
                    "next"->If[NullQ[ cell["next"] ], "", cell["next"][[1]]],
                    "prev"->If[NullQ[ cell["prev"] ], "", cell["prev"][[1]]]
                |>
        },

        WebSocketSend[addr, FrontEndMorphCell[ExportString[obj, "JSON"] ]];
    ];
);