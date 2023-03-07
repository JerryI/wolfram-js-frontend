
BeginPackage["JerryI`WolframJSFrontend`Notebook`", {"JerryI`WolframJSFrontend`Utils`", "WSP`", "Tinyweb`", "JerryI`WolframJSFrontend`Cells`", "JerryI`WolframJSFrontend`Kernel`", "JerryI`WolframJSFrontend`Notifications`"}]; 

NotebookDefineEvaluators::usage = "NotebookDefineEvaluators[] defines the processor for languages"
NotebookExtendDefinitions::usage = "NotebookExtendDefinitions[] extends the JSON objects of the notebook"
NotebookCreate::usage = "NotebookCreate[]"
NotebookRemove::usage = "NotebookRemove[]"
NotebookAttach::usage = "NotebookAttach[] attaches to the local or remote kernel"
NotebookOpen::usage = "NotebookOpen[]"
NotebookEvaluate::usage = "NotebookEvaluate[]"
NotebookGetObject::usage = "NotebookGetObject[] gets the JSON notebook object"
NotebookOperate::usage = "NotebookOperate[] a wrapper to CellObj methods"

NotebookKernelOperate::usage = "Kernel control"

NotebookEventFire::usage = "internal usage for events"
NotebookPromise::usage = "ask a server to do something..internal"

NotebookStore::usage = "save the notebook to a file"

NotebookFrontEndSend::usage = "sends to the frotnend an expr"

NotebookEmitt::usage = "send anything to the kernel (async)"

Begin["`Private`"]; 

$ContextAliases["jsfn`"] = "JerryI`WolframJSFrontend`Notebook`";

jsfn`Notebooks = <||>;
jsfn`Processors = Null;

$NotifyName = $InputFileName;

$AssociationSocket = <||>;

Unprotect[NotebookCreate];
Unprotect[NotebookOpen];
Unprotect[NotebookEvaluate];
Unprotect[NotebookStore];

ClearAll[NotebookOpen];
ClearAll[NotebookCreate];
ClearAll[NotebookEvaluate];

Options[NotebookCreate] = {
    "name" -> "Untitled",
    "signature" -> "wsf-notebook",
    "id" :> CreateUUID[],
    "kernel" -> LocalKernel,
    "objects" -> <||>,
    "cell" -> Null,
    "data" -> "",
    "path" -> Null
};

NotebookDefineEvaluators["Default", array_] := jsfn`Processors = array;

NotebookExtendDefinitions[defs_][sign_] := Module[{updated = {}},
    Print["Extend definitions"];
    updated = Intersection[Keys[defs], Keys[jsfn`Notebooks[sign]["objects"] ] ];
    jsfn`Notebooks[sign]["objects"] = Join[jsfn`Notebooks[sign]["objects"], defs];
    Print["Will be updated: "<>ToString[Length[updated] ] ];
    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`UpdateFrontEndExecutable[#, defs[#] ], sign] &/@ updated;
];

NotebookStore := Module[{channel = $AssociationSocket[Global`client], cells, notebook = <||>},
    cells = CellObjQuery["sign", channel];
    Print[StringTemplate["`` objects to save"][Length[cells] ] ];
    notebook["notebook"] = jsfn`Notebooks[channel];
    notebook["cells"] = CellObjPack /@ cells;
    notebook["serializer"] = "jsfn";
    notebook["notebook", "cell"] = First[notebook["notebook", "cell"]];
    Put[notebook, jsfn`Notebooks[channel]["path"]];

    jsfn`Notebooks[channel]["date"] = Now;

    Clear[notebook];
    Print["SAVED"];
];

NotebookCreate[OptionsPattern[]] := (
    With[{id = OptionValue["id"]},

        jsfn`Notebooks[id] = <|
            "name" -> OptionValue["name"],
            "id"   -> id,
            "kernel" -> OptionValue["kernel"],
            "objects" -> OptionValue["objects"] ,
            "path" -> OptionValue["path"]       
        |>;

        jsfn`Notebooks[id]["cell"] = CellObj["sign"->id, "type"->"input", "data"->OptionValue["data"]];
        id
    ]
);


(*access only via websockets*)
NotebookAttach[proc_, init_:Null] := Module[{pid = proc},
    If[proc === "master", 
        jsfn`Notebooks[$AssociationSocket[Global`client]]["kernel"] = LocalKernel; 
        WebSocketSend[Global`client, Global`FrontEndAddKernel[pid] ]; 
        PushNotification[$NotifyName, "<span class=\"badge badge-danger\">Master kernel attached</span> <p>If we die, we die</p>"]; 
        Return["master", Module] 
    ];
];

NotebookEmitt[symbol_] := With[{channel = $AssociationSocket[Global`client]}, Print["Event emitt!"]; jsfn`Notebooks[channel]["kernel"]["Emitt"][Hold[symbol] ] ];
SetAttributes[NotebookEmitt, HoldFirst];

NotebookOpen[id_String] := (
    console["log", "generating the three of `` for ``", id, Global`client];
    $AssociationSocket[Global`client] = id;
    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookEventFire[Global`client]},
        CellObjGenerateTree[jsfn`Notebooks[id]["cell"]];
    ];
    jsfn`Notebooks[id]["kernel"]["AttachNotebook"][id];
    jsfn`Notebooks[id]["kernel"]["AttachNotebook"][id];
);

NotebookEvaluate[cellid_] := (
    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookEventFire[Global`client]},
        CellObjEvaluate[CellObj[cellid], jsfn`Processors];
    ];
);

NotebookKernelOperate[cmd_] := With[{channel = $AssociationSocket[Global`client]},
    jsfn`Notebooks[channel]["kernel"][cmd][Function[state,
        Print[StringTemplate["callback for `` channel"][channel]];
        WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndKernelStatus[ state ], channel];
        
        jsfn`Notebooks[channel]["kernel"]["AttachNotebook"][channel];
        jsfn`Notebooks[channel]["kernel"]["AttachNotebook"][channel];
    ]];
];


NotebookGetObject[uid_] := With[{channel = $AssociationSocket[Global`client]},
    jsfn`Notebooks[channel]["objects"][uid]
];

NotebookPromise[uid_, params_][expr_] := With[{channel = $AssociationSocket[Global`client]},
    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`PromiseResolve[uid, expr], channel];
];

NotebookOperate[cellid_, op_] := (
    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookEventFire[Global`client]},
        op[CellObj[cellid]];
    ];
);

(*
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
*)

NotebookFrontEndSend[channel_][expr_String] := With[{},
    Print["Publish from kernel to the channel "<>channel];
    WebSocketPublishString[JerryI`WolframJSFrontend`server, expr, channel];
];

NotebookEventFire[addr_]["NewCell"][cell_] := (
    (*looks ugly actually. we do not need so much info*)
    console["log", "fire event `` for ``", cell, addr];
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
                        "props"->cell["props"],
                        "display"->cell["display"]
                    |>,
            
            template = LoadPage[FileNameJoin[{JerryI`WolframJSFrontend`public, "template", "cells", cell["type"]<>".wsp"}], {Global`id = cell[[1]]}]
        },

        WebSocketSend[addr, Global`FrontEndCreateCell[template, ExportString[obj, "JSON"] ]];
    ];
);

NotebookEventFire[addr_]["RemovedCell"][cell_] := (
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

        WebSocketSend[addr, Global`FrontEndRemoveCell[ExportString[obj, "JSON"] ]];
    ];
);

NotebookEventFire[addr_]["CellError"][cell_, text_] := WebSocketSend[addr, Global`FrontEndCellError[cell[[1]], text]];

NotebookEventFire[addr_]["CellMove"][cell_, parent_] := (
    With[
        {   template = LoadPage[FileNameJoin[{JerryI`WolframJSFrontend`public, "template", "cells", cell["type"]<>".wsp"}], {Global`id = cell[[1]]}],
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

        WebSocketSend[addr, Global`FrontEndMoveCell[template, ExportString[obj, "JSON"] ]];
    ];
);

NotebookEventFire[addr_]["CellMorph"][cell_] := (Null);

End[];
EndPackage[];