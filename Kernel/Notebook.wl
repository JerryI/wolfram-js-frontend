
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

NotebookEventFire::usage = "internal usage"

Begin["`Private`"]; 

$ContextAliases["jsfn`"] = "JerryI`WolframJSFrontend`Notebook`";

jsfn`Notebooks = <||>;
jsfn`Processors = Null;

$NotifyName = $InputFileName;

$AssociationSocket = <||>;

Unprotect[NotebookCreate];
Unprotect[NotebookOpen];
Unprotect[NotebookEvaluate];

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
    "data" -> "1+1"
};

NotebookDefineEvaluators["Default", array_] := jsfn`Processors = array;

NotebookExtendDefinitions[defs_][sign_] := (
    jsfn`Notebooks[sign]["objects"] = Join[jsfn`Notebooks[sign]["objects"], defs];
);

NotebookCreate[OptionsPattern[]] := (
    With[{id = OptionValue["id"]},

        jsfn`Notebooks[id] = <|
            "name" -> OptionValue["name"],
            "id"   -> id,
            "kernel" -> OptionValue["kernel"],
            "objects" -> OptionValue["objects"]        
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


NotebookOpen[id_String] := (
    console["log", "generating the three of `` for ``", id, Global`client];
    $AssociationSocket[Global`client] = id;
    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookEventFire[Global`client]},
        CellObjGenerateTree[jsfn`Notebooks[id]["cell"]];
    ];
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
    ]];
];



NotebookGetObject[cellid_, uid_] := (
    WebSocketSend[Global`client, Global`FrontEndExtendDefinitions[uid, jsfn`Notebooks[CellObj[cellid]["sign"]]["objects"][uid] ]];
);

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

        WebSocketSend[addr, Global`FrontEndMoveCell[template, ExportString[obj, "JSON"] ]];
    ];
);

NotebookEventFire[addr_]["CellMorph"][cell_] := (
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

        WebSocketSend[addr, Global`FrontEndMorphCell[ExportString[obj, "JSON"] ]];
    ];
);

End[];
EndPackage[];