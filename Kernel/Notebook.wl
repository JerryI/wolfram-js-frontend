BeginPackage["JerryI`WolframJSFrontend`Notebook`", {"JerryI`WolframJSFrontend`Utils`", "WSP`", "Tinyweb`", "JerryI`WolframJSFrontend`Cells`", "JerryI`WolframJSFrontend`Kernel`"}]; 
(*
    ::Only for MASTER kernel::

    The central API package
    - operates with notebooks in the memory
    - operates with filesystem
    - connects websockets with Cells` and Kernel` functions 
*)

NotebookDefineEvaluators::usage = "defines the processors and languages to be used on Cells`Evaluate"
NotebookAddEvaluator::usage = "add new supported lang/tool to the cell's evaluator"

NotebookExtendDefinitions::usage = "extends the JSON objects of the notebook storage. internal command of the Evaluator"

(* 
    Functions used by the frontened, aka API 
    - they do not use the notebook id directly, but takes it from the associated websocket client's id
*)
$AssoticatedPath::usage = "an association table, it helpt to find notebook id by the path, on which it was opened by a client using NotebookPreload"
$AssociationSocket::usage = "an association table, it helps to find notebook id by the associated socket of a random client"

NotebookCreate::usage = "create an empty untitled notebook with an empty cell attached"

NotebookOpen::usage = "opens the notebook from the memory (not from the file!) and prints the cells to all associated clients"
(* it also registers the address, which did open the notebook and associate this client with a coresponding notebook ID *)

NotebookEvaluate::usage = "a wrapper for Cells`Evaluate function, which substitute the given Kernel for the evaluation"

NotebookAbort::usage = "abort"

NotebookGetObject::usage = "gets the JSON notebook object by ID and returns promise-resolve object back to the frontend"

NotebookOperate::usage = "a wrapper for CellObj methods to manipulate cells from the frontend"

NotebookKernelOperate::usage = "a wrapper for Kernel methods to manipulate kernels from the frontend"

NotebookRename::usage = "sanitize the given name, then rename a notebook and update the name in UI"

FileOperate::usage = "a wrapper for easy-file operations"

NotebookPromise::usage = "ask a server to do something... and return result as a resolved promise to the frontend"

NotebookStore::usage = "save (serialise) the notebook to a file using Cells`Pack methods"
NotebookStoreManually::usage = "altered version of the previous command"

PreloadNotebook::usage = "load into memeory (if it was not there) and updates date and path"
CreateNewNotebook::usage = "create a serialised notebook and store it on a disk"
CreateNewNotebookByPath::usage = "alternamtive version of the prev."

NotebookEmitt::usage = "send anything to the kernel (async)"

GarbageCollector::usage = "collect garbage form notebook"

(*
    Internal commands used by other packages
    must not be PUBLIC!
*)
NotebookEventFire::usage = "internal command for cell's operation events, that publish changes via websockets"
NotebookFrontEndSend::usage = "redirects the output of the remote/local kernel to the frontened with no changes"

Begin["`Private`"]; 

$ContextAliases["jsfn`"] = "JerryI`WolframJSFrontend`Notebook`";

jsfn`Notebooks = <||>;
jsfn`Processors = {};

$NotifyName = $InputFileName;

(* list of rules socket id -> notebook id *)
$AssociationSocket = <||>;

$AssoticatedPath = <||>;

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

(* define the default supported evaluators list *)
NotebookDefineEvaluators["Default", array_] := jsfn`Processors = array;

NotebookAddEvaluator[type_] := jsfn`Processors = Join[{type}, jsfn`Processors];

(* internal command used by the Evaluator from the remote/local kernel to extend the objects storage on notebook *)
NotebookExtendDefinitions[defs_][sign_] := Module[{updated = {}},
    Print["Extend definitions"];
    (* add new stuff *)
    updated = Intersection[Keys[defs], Keys[jsfn`Notebooks[sign]["objects"] ] ];
    jsfn`Notebooks[sign]["objects"] = Join[jsfn`Notebooks[sign]["objects"], defs];

    (* if some objects were updated -> force to update the cached objects on the associated clients *)
    Print["Will be updated: "<>ToString[Length[updated] ] ];
    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`UpdateFrontEndExecutable[#, defs[#]["json"] ], sign] &/@ updated;
];



(* load a notebook into memory  *)
PreloadNotebook[path_] := Module[{notebook},
  If[!MemberQ[$AssoticatedPath//Keys, path],
    notebook = Get[path];

    (* if not found or corrupted -> create a new one *)
    Switch[notebook["serializer"],
        "jsfn",
            Print["old format"];
            Print["converting..."];
            (*** deserialisation of the notebook and cells ***)
            (notebook["notebook", "objects", #] = <|"date"->Now, "json"->notebook["notebook", "objects", #]|>) &/@ Keys[notebook["notebook", "objects"]];

            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"] ] = notebook["notebook"];
            (* assiciate with a current path for further easy detection *)
            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "path"] = path;
            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "date"] = Now;
        
            (* assign the cellid of the first cell to the notebook *)
            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "cell"] = JerryI`WolframJSFrontend`Cells`setCellID[JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "cell"] ];
            
            Print[JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"] ]//InputForm//ToString ];
            JerryI`WolframJSFrontend`Cells`CellObjUnpack /@ notebook["cells"];
        
            $AssoticatedPath[path] = notebook["notebook", "id"];
            Print[$AssoticatedPath];
            Clear[notebook];
            Print["LOADED"];
        ,
        "jsfn2",
            (*** deserialisation of the notebook and cells ***)

            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"] ] = notebook["notebook"];
            (* assiciate with a current path for further easy detection *)
            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "path"] = path;
            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "date"] = Now;

            (* assign the cellid of the first cell to the notebook *)
            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "cell"] = JerryI`WolframJSFrontend`Cells`setCellID[JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "cell"] ];

            Print[JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"] ]//InputForm//ToString ];
            JerryI`WolframJSFrontend`Cells`CellObjUnpack /@ notebook["cells"];

            $AssoticatedPath[path] = notebook["notebook", "id"];
            Print[$AssoticatedPath];
            Clear[notebook];
            Print["LOADED"];
        ,
        _,
            CreateNewNotebookByPath[path];
            Print["CREATED A NEW ONE"];
            Return[Null, Module];
    ];
    
  ]
]


(* create a serialsed notebook and store it as a file *)
CreateNewNotebook[dir_] := Module[{uid = RandomWord[]<>"-"<>StringTake[CreateUUID[], 5], filename = "Untitled"},
  While[FileExistsQ[FileNameJoin[{dir, filename<>".wl"}]],
    filename = StringJoin[filename, "-New"];
  ];

  $AssoticatedPath[path] = uid;
  NotebookCreate["id"->uid, "name"->filename, "path"->FileNameJoin[{dir, filename<>".wl"}] ];
  NotebookStoreManually[uid];
  WebSocketSend[Global`client, Global`FrontEndJSEval[StringTemplate["openawindow('/index.wsp?path=``')"][FileNameJoin[{dir, filename<>".wl"}]//URLEncode ] ] ];
];

(* create a serialsed notebook and store it as a file *)
CreateNewNotebookByPath[name_] := Module[{uid = RandomWord[]<>"-"<>StringTake[CreateUUID[], 5]},
  $AssoticatedPath[name] = uid;
  NotebookCreate["id"->uid, "name"->FileBaseName[name], "path"->name ];
  NotebookStoreManually[uid];
];


(* serialise the notebook to a file *)
NotebookStore := Module[{channel = $AssociationSocket[Global`client], cells, notebook = <||>},
    cells = CellObjQuery["sign", channel];
    Print[StringTemplate["`` objects to save"][Length[cells] ] ];
    notebook["notebook"] = jsfn`Notebooks[channel];
    notebook["cells"] = CellObjPack /@ cells;
    notebook["serializer"] = "jsfn2";
    notebook["notebook", "cell"] = First[notebook["notebook", "cell"]];
    Put[notebook, jsfn`Notebooks[channel]["path"]];

    jsfn`Notebooks[channel]["date"] = Now;

    Clear[notebook];
    Print["SAVED"];
];

(* the same, but with a specified notebook ID *)
NotebookStoreManually[channel_] := Module[{cells, notebook = <||>},
    cells = CellObjQuery["sign", channel];
    Print[StringTemplate["`` objects to save"][Length[cells] ] ];
    notebook["notebook"] = jsfn`Notebooks[channel];
    notebook["cells"] = CellObjPack /@ cells;
    notebook["serializer"] = "jsfn2";
    notebook["notebook", "cell"] = First[notebook["notebook", "cell"]];
    Put[notebook, jsfn`Notebooks[channel]["path"]];

    jsfn`Notebooks[channel]["date"] = Now;

    Clear[notebook];
    Print["SAVED"];
];

(* remove a file and update UI elements via WSPDynamicExtension *)
FileOperate["Remove"][path_] := With[{channel = $AssociationSocket[Global`client]},
    DeleteFile[path];
    If[path === jsfn`Notebooks[channel]["path"] ,
        (* if it was a current notebook -> redirect to the landing page *)
        WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndJSEval["openawindow('/index.wsp')" ], channel ];
    ,
        (* just update the UI elements *)
        WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndUpdateFileList[DirectoryName[jsfn`Notebooks[channel]["path"] ] ], channel];
    ];
];

NotebookRename[name_] := Module[{channel, newname, newpath},
    channel = $AssociationSocket[Global`client];
    newname = name;
    newname = StringReplace[newname, {","->"-", "."->"-", " "->"-", "/"->"-"}];

    If[FileBaseName[jsfn`Notebooks[channel]["path"] ] === newname, Return[Null, Module] ];

    newpath = FileNameJoin[{DirectoryName[jsfn`Notebooks[channel]["path"] ], newname<>".wl"}];

    While[FileExistsQ[ newpath ],
        newname = newname <> "-One";
        newpath = FileNameJoin[{DirectoryName[jsfn`Notebooks[channel]["path"] ], newname<>".wl"}];
    ];

    RenameFile[jsfn`Notebooks[channel]["path"], newpath];

    jsfn`Notebooks[channel]["path"] = newpath;
    (* update the associated path *)
    Global`$AssociationPath[ jsfn`Notebooks[channel]["path"] ] = channel;
    
    (* update UI elements *)
    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndUpdateFileName[newname, jsfn`Notebooks[channel]["path"]], channel];
    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndUpdateFileList[DirectoryName[jsfn`Notebooks[channel]["path"] ] ], channel];
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

(* redirect *)
NotebookEmitt[symbol_] := With[{channel = $AssociationSocket[Global`client]},  jsfn`Notebooks[channel]["kernel"]["Emitt"][Hold[symbol] ] ];
SetAttributes[NotebookEmitt, HoldFirst];

NotebookAbort := With[{channel = $AssociationSocket[Global`client]},
    NotebookKernelOperate["Abort"];
    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndGlobalAbort[Null], channel];
    Print[CellObjGetAllNext[ jsfn`Notebooks[channel]["cell"] ] ];
    (#["state"]="idle") &/@ CellObjGetAllNext[ jsfn`Notebooks[channel]["cell"] ];
];

GarbageCollector[id_] := Module[{garbage},
    Print["Collection garbage!"];
    garbage = <||>;

    (* a shitty bug did not allow me to do it properly *)
    (If[Now - jsfn`Notebooks[id]["objects", #, "date"] > Quantity[40, "Seconds"], garbage[#]=True; jsfn`Notebooks[id]["objects", #] = .; ])&/@ Keys[ jsfn`Notebooks[id]["objects"] ];

    garbage = garbage//Keys;

    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndDispose[garbage], id];
    Print[StringTemplate["`` were collected"][Length[garbage]] ];
];

NotebookOpen[id_String] := (
    console["log", "generating the three of `` for ``", id, Global`client];
    $AssociationSocket[Global`client] = id;
    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookEventFire[Global`client]},
        CellObjGenerateTree[jsfn`Notebooks[id]["cell"]];
    ];
    jsfn`Notebooks[id]["kernel"]["AttachNotebook"][id];
    jsfn`Notebooks[id]["kernel"]["AttachNotebook"][id];

    SessionSubmit[ScheduledTask[Print["Collection garbage..."]; Print[GarbageCollector[id]];, {Quantity[30, "Seconds"], 1}, AutoRemove->True]]; 
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
    jsfn`Notebooks[channel]["objects"][uid]["date"] = Now;
    jsfn`Notebooks[channel]["objects"][uid]["json"]
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

(* redirect *)
NotebookFrontEndSend[channel_][expr_String] := (
    (*Print["Publish from kernel to the channel "<>channel];*)
    WebSocketPublishString[JerryI`WolframJSFrontend`server, expr, channel];
);


(* 
    Internal commands
    events on cells operations
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
                        "display"->cell["display"],
                        "state"->If[StringQ[ cell["state"] ], cell["state"], "idle"]
                    |>,
            
            template = LoadPage[FileNameJoin[{JerryI`WolframJSFrontend`public, "template", "cells", cell["type"]<>".wsp"}], {Global`id = cell[[1]]}]
        },

        WebSocketSend[addr, Global`FrontEndCreateCell[template, obj ]];
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

        WebSocketSend[addr, Global`FrontEndRemoveCell[obj ]];
    ];
);

NotebookEventFire[addr_]["UpdateState"][cell_] := (
    With[
        {
            obj = <|
                        "id"->cell[[1]], 
                        "sign"->cell["sign"],
                        "type"->cell["type"],
                        "state"->cell["state"]
                    |>
        },

        WebSocketSend[addr, Global`FrontEndUpdateCellState[obj ] ];
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

        WebSocketSend[addr, Global`FrontEndMoveCell[template, obj ]];
    ];
);

NotebookEventFire[addr_]["CellMorph"][cell_] := (Null);

End[];
EndPackage[];