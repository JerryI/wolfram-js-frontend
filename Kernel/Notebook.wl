BeginPackage["JerryI`WolframJSFrontend`Notebook`", {"JerryI`WolframJSFrontend`Utils`", "WSP`", "Tinyweb`", "JerryI`WolframJSFrontend`Cells`", "JerryI`WolframJSFrontend`Kernel`", "JerryI`WolframJSFrontend`Colors`"}]; 
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


NotebookGarbagePut::usage = "collect garbage"

NotebookLoadPage::usage = "load modal windows"
NotebookLoadModal::usage = "load modal windows"
NotebookUpdateThumbnail::usage = "provide html thumbnail"
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
NotebookGetObjectForMe::usage = "gets ...the same"

NotebookOperate::usage = "a wrapper for CellObj methods to manipulate cells from the frontend"

NotebookKernelOperate::usage = "a wrapper for Kernel methods to manipulate kernels from the frontend"

NotebookRename::usage = "sanitize the given name, then rename a notebook and update the name in UI"

FileOperate::usage = "a wrapper for easy-file operations"

NotebookPromise::usage = "ask a server to do something... and return result as a resolved promise to the frontend"
NotebookPromiseDeferred::usage = "the same"

NotebookPromiseKernel::usage = "ask a computing kernel to do something..."

NotebookStore::usage = "save (serialise) the notebook to a file using Cells`Pack methods"
NotebookStoreManually::usage = "altered version of the previous command"

PreloadNotebook::usage = "load into memeory (if it was not there) and updates date and path"
CreateNewNotebook::usage = "create a serialised notebook and store it on a disk"
CreateNewNotebookByPath::usage = "alternamtive version of the prev."

NotebookEmitt::usage = "send anything to the kernel (async)"

NotebookEvaluateAll::usage = ""

NExtendSingleDefinition::usage = ""

GarbageCollector::usage = "collect garbage form notebook"


NotebookExport::usage = "export to standalone html"


NotebookPopupFire::usage = "generate pop-up message using templates and send to the frontened"
(*
    Internal commands used by other packages
    must not be PUBLIC!
*)
NotebookEventFire::usage = "internal command for cell's operation events, that publish changes via websockets"
NotebookFrontEndSend::usage = "redirects the output of the remote/local kernel to the frontened with no changes"
NotebookFakeEventFire::usage = "fake event fire for the standalone"

GetThumbnail::usage = "get prov"

Begin["`Private`"]; 

$ContextAliases["jsfn`"] = "JerryI`WolframJSFrontend`Notebook`";

jsfn`Notebooks = <||>;
jsfn`Processors = {{},{},{}};

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

NotebookAddEvaluator[type_] := jsfn`Processors[[2]] = Join[{type}, jsfn`Processors[[2]]];
NotebookAddEvaluator[type_, "HighestPriority"] := jsfn`Processors[[1]] = Join[{type}, jsfn`Processors[[1]]];
NotebookAddEvaluator[type_, "LowestPriority"] := jsfn`Processors[[3]] = Join[{type}, jsfn`Processors[[3]]];

(* internal command used by the Evaluator from the remote/local kernel to extend the objects storage on notebook *)
NotebookExtendDefinitions[defs_][sign_] := Module[{updated = {}},
    Print["Extend definitions with "];
    Print[defs//InputForm//ToString];
    Print["Endl"];
    (* add new stuff *)
    updated = Intersection[Keys[defs], Keys[jsfn`Notebooks[sign]["objects"] ] ];
    jsfn`Notebooks[sign]["objects"] = Join[jsfn`Notebooks[sign]["objects"], defs];

    (* if some objects were updated -> force to update the cached objects on the associated clients *)
    Print["Will be updated: "<>ToString[Length[updated] ] ];
    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`UpdateFrontEndExecutable[#, defs[#]["json"] ], sign] &/@ updated;
];

NExtendSingleDefinition[uid_, defs_][notebook_] := Module[{updated = False},
    Print["Direct definition extension"];

    updated = KeyExistsQ[jsfn`Notebooks[notebook]["objects"], uid];

    jsfn`Notebooks[notebook]["objects"][uid] = defs; 

    If[updated,
        Print["Will be updated!"];
        WebSocketPublish[JerryI`WolframJSFrontend`server, Global`UpdateFrontEndExecutable[uid, defs["json"] ], sign];  
    ];  
]


(* load a notebook into memory  *)
PreloadNotebook[path_] := Module[{notebook, oldsign, newsign, regenerated = False, postfix},

  notebook = Get[path]; 

  (* remember the last path *)
  JerryI`WolframJSFrontend`defaultvault = If[DirectoryQ[path], path, DirectoryName[path]];
  Put[JerryI`WolframJSFrontend`defaultvault, FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]];

  (* if doent match - remove from the Association can be a copied by user *)
  If[MemberQ[$AssoticatedPath//Keys, path],
    If[notebook["notebook", "path"] =!= path, $AssoticatedPath[path] = .]
  ];

  If[!MemberQ[$AssoticatedPath//Keys, path],
    (* if not here - load *)
    Print["Not there. loading into memeory..."];

    (* if not found or corrupted -> create a new one *)
    Switch[notebook["serializer"],
        "jsfn3",
            (*** deserialisation of the notebook and cells ***)

            (* make sure that if this is a copy of an old one -> regenrate an ID in DB *)
            If[notebook["notebook", "path"] =!= path,
            
                Print["Seems to be cloned or renamed"];
                Print["Regenerating the inner ID..."];

                oldsign = notebook["notebook", "id"];
                newsign = RandomWord[]<>"-"<>StringTake[CreateUUID[], 5];
                notebook["notebook", "id"] = newsign;
                Print["New name "<>notebook["notebook", "id"]<>" instead of "<>oldsign];

                postfix = StringTake[CreateUUID[], 3];

                notebook["cells"] = Module[{cell = #},
                    cell["sign"] = newsign;
                    cell["id"] = cell["id"]<>postfix;

                    cell

                ] &/@ notebook["cells"];
                Print["done"];
                regenerated = True;
            ];

            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"] ] = notebook["notebook"];
            (* assiciate with a current path for further easy detection *)
            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "path"] = path;
            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "date"] = Now;

            Print[JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"] ]//InputForm//ToString ];
            CellListUnpack[notebook["cells"]];

            $AssoticatedPath[path] = notebook["notebook", "id"];
            Print[$AssoticatedPath];
            Clear[notebook];
            Print["LOADED"];

            If[regenerated, (*force to save if it was regenerated*) NotebookStoreManually[$AssoticatedPath[path]]];
        ,    
        "jsfn2",
            (*** convert from legacy format ***)

            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"] ] = notebook["notebook"];
            (* assiciate with a current path for further easy detection *)
            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "path"] = path;
            JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "date"] = Now;

            (* assign the cellid of the first cell to the notebook *)

            
            Print[JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"] ]//InputForm//ToString ];
            
            CellListUnpackLegacy[notebook["cells"], notebook["notebook", "cell"]];

            $AssoticatedPath[path] = notebook["notebook", "id"];
            Print[$AssoticatedPath];
            Clear[notebook];
            Print["LOADED"];

            If[regenerated, (*force to save if it was regenerated*) NotebookStoreManually[$AssoticatedPath[path]]];
        ,
        _,
            (* we do not know wtf is this. lets just create a notebook by the given path *)
            CreateNewNotebookByPath[path];
            Print["CREATED A NEW ONE"];
            Return[Null, Module];
    ];
    
  ]
]


(* create a serialsed notebook and store it as a file *)
CreateNewNotebook[dir_, window_:False] := Module[{uid = RandomWord[]<>"-"<>StringTake[CreateUUID[], 5], filename = (RandomWord[]//Capitalize)},
  While[FileExistsQ[FileNameJoin[{dir, filename<>".wl"}]],
    filename = StringJoin[filename, "-New"];
  ];

  $AssoticatedPath[path] = uid;
  NotebookCreate["id"->uid, "name"->filename, "path"->FileNameJoin[{dir, filename<>".wl"}] ];
  NotebookStoreManually[uid];
  WebSocketSend[Global`client, Global`FrontEndJSEval[StringTemplate["openawindow('/index.wsp?path=``', ``)"][FileNameJoin[{dir, filename<>".wl"}]//URLEncode, If[window, "'_blank'", "'_self'"] ] ] ];
];

(* create a serialsed notebook and store it as a file *)
CreateNewNotebookByPath[name_] := Module[{uid = RandomWord[]<>"-"<>StringTake[CreateUUID[], 5]},
  $AssoticatedPath[name] = uid;
  NotebookCreate["id"->uid, "name"->FileBaseName[name], "path"->name ];
  NotebookStoreManually[uid];
];

jsfn`Thumbnails = <||>;
If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".thumbnails"}]],
    jsfn`Thumbnails = Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".thumbnails"}]];
]

SaveThumbnails := (
    Put[jsfn`Thumbnails, FileNameJoin[{JerryI`WolframJSFrontend`root, ".thumbnails"}]];
)

GetThumbnail[path_] := 
If[KeyExistsQ[jsfn`Thumbnails, path],
    jsfn`Thumbnails[path]
,
    {"..."}    
]

AddThumbnail[id_] := Module[{list = CellList[id], pos = 1, data = {}, back},
    If[!ListQ[list], Return[$Failed, Module]];
    
    data = Select[list, (#["type"]==="input")&];
    data = Take[data, Min[4, Length[data]]];

    data = {#["data"]//StringLength, #["data"]} &/@ data;
    data[[All,1]] = Accumulate[data[[All,1]]];

    back = data//First;

    data = Select[data, (#[[1]] < 500 + 200) &];

    If[Length[data] == 0, data = {back}];

    If[StringLength[data[[-1, 2]]] - (data[[-1, 1]] - 500) > 0, 
        data[[-1, 2]] = StringTake[data[[-1, 2]], Min[StringLength[data[[-1, 2]]], StringLength[data[[-1, 2]]] - (data[[-1, 1]] - 500)]];
        data[[-1, 2]] = data[[-1, 2]] <> " ...";
    ];


    jsfn`Thumbnails[jsfn`Notebooks[id]["path"]] = data[[All,2]];
];

(* serialise the notebook to a file *)
NotebookStore := Module[{channel = $AssociationSocket[Global`client], cells, notebook = <||>},
    Print[StringTemplate["`` objects to save"][Length[cells] ] ];
    notebook["notebook"] = jsfn`Notebooks[channel];
    notebook["cells"] = CellListPack[channel];
    notebook["serializer"] = "jsfn3";
    
    Put[notebook, jsfn`Notebooks[channel]["path"]];

    jsfn`Notebooks[channel]["date"] = Now;

    Clear[notebook];
    Print["SAVED"];

    (* generate privew *)
    AddThumbnail[channel];
    SaveThumbnails;

];

(* the same, but with a specified notebook ID *)
NotebookStoreManually[channel_] := Module[{cells, notebook = <||>},
    Print[StringTemplate["`` objects to save"][Length[cells] ] ];
    notebook["notebook"] = jsfn`Notebooks[channel];
    notebook["cells"] = CellListPack[channel];
    notebook["serializer"] = "jsfn3";

    Put[notebook, jsfn`Notebooks[channel]["path"]];

    jsfn`Notebooks[channel]["date"] = Now;

    Clear[notebook];
    Print["SAVED"];
];

NotebookExport := Module[{channel = $AssociationSocket[Global`client], path},
    path = FileNameJoin[{DirectoryName[jsfn`Notebooks[channel]["path"]], FileBaseName[jsfn`Notebooks[channel]["path"]]<>".html"}];
    
    tempArray["data"] = {};
    tempArray["Push", data_] := (tempArray["data"] = {tempArray["data"], data} // Flatten);

    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookFakeEventFire[tempArray]},
        CellObjGenerateTree[jsfn`Notebooks[channel]["cell"]];
    ];
    
    With[{uid = channel, tempArrayPointer = tempArray},
        Export[path,
            LoadPage[FileNameJoin[{"public", "template", "export", "notebook.wsp"}], {Global`notebook = uid, Global`cells = tempArrayPointer}, "base"->JerryI`WolframJSFrontend`root]
        , "String"]
    ];

    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndUpdateFileList[DirectoryName[jsfn`Notebooks[channel]["path"] ] ], channel];
];

(* remove a file and update UI elements via WSPDynamicExtension *)
FileOperate["Remove"][urlpath_] := Module[{path}, With[{channel = $AssociationSocket[Global`client]},
    path = URLDecode[urlpath];

    DeleteFile[path];
    If[path === jsfn`Notebooks[channel]["path"] ,
        (* if it was a current notebook -> redirect to the landing page *)
        WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndJSEval["openawindow('/index.wsp')" ], channel ];
    ,
        (* just update the UI elements *)
        WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndUpdateFileList[DirectoryName[jsfn`Notebooks[channel]["path"] ] ], channel];
    ];
]];

NotebookUpdateThumbnail[data_] := With[{channel = $AssociationSocket[Global`client]},
    jsfn`Notebooks[channel]["thumbnail"] = data;
];

(* clone and open a new page *)
FileOperate["Clone"][urlpath_] := Module[{new, path},
    path = URLDecode[urlpath];

    If[DirectoryQ[path],
        WebSocketSend[Global`client, Global`FrontEndJSEval["alert('Cannot clone a directory')" ]];
        Return[Null, Module];
    ];

    new = FileNameJoin[{DirectoryName[path], FileBaseName[path]<>"-Clone."<>FileExtension[path]}];
    CopyFile[path, new];

    (* open a new page *)
    WebSocketSend[Global`client, Global`FrontEndJSEval[StringTemplate["openawindow('/index.wsp?path=``', '_blank')"][new//URLEncode ] ] ];
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

    NotebookStoreManually[channel];
];

NotebookCreate[OptionsPattern[]] := (
    With[{id = OptionValue["id"]},

        jsfn`Notebooks[id] = <|
            "name" -> OptionValue["name"],
            "id"   -> id,
            "kernel" -> OptionValue["kernel"],
            "objects" -> OptionValue["objects"] ,
            "path" -> OptionValue["path"],
            "cell" :> Exit[] (* to catch old ones *)       
        |>;

        CellList[id] = { CellObj["sign"->id, "type"->"input", "data"->OptionValue["data"]] };
        id
    ]
);

(* redirect *)
NotebookEmitt[symbol_] := With[{channel = $AssociationSocket[Global`client]},  jsfn`Notebooks[channel]["kernel"]["Emitt"][Hold[symbol] ] ];
NotebookEmitt[symbol_, notebook_] := With[{channel = notebook},  jsfn`Notebooks[channel]["kernel"]["Emitt"][Hold[symbol] ] ];
SetAttributes[NotebookEmitt, HoldFirst];

NotebookAbort := With[{channel = $AssociationSocket[Global`client]},
    NotebookKernelOperate["Abort"];
    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndGlobalAbort[Null], channel];
    Print[CellObjGetAllNext[ jsfn`Notebooks[channel]["cell"] ] ];
    (#["state"]="idle") &/@ CellObjGetAllNext[ jsfn`Notebooks[channel]["cell"] ];
];



NotebookGarbagePut[id_] := With[{channel = $AssociationSocket[Global`client]},
    Print["Garbage collected: "<>id];
    jsfn`Notebooks[channel]["objects"][id] = .;
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
        CellListTree[id];
    ];
    jsfn`Notebooks[id]["kernel"]["AttachNotebook"][id, DirectoryName[jsfn`Notebooks[id]["path"]]];

    
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
        
        jsfn`Notebooks[channel]["kernel"]["AttachNotebook"][channel, DirectoryName[jsfn`Notebooks[channel]["path"]]];
    ]];
];


NotebookGetObject[uid_] := Module[{obj}, With[{channel = $AssociationSocket[Global`client]},
    If[!KeyExistsQ[jsfn`Notebooks[channel]["objects"], uid],
        Print["we did not find an object "<>uid<>" at the master kernel. failed"];
        Return[$Failed];
    ];
    Print[StringTemplate["getting object `` with data inside \n `` \n"][uid, jsfn`Notebooks[channel]["objects"][uid]//Compress]];

    jsfn`Notebooks[channel]["objects"][uid]["date"] = Now;
    jsfn`Notebooks[channel]["objects"][uid]["json"]
]];

NotebookGetObjectForMe[uid_][id_] := (
    Print["getting uid object "<>uid<>" for notebook "<>id];
 
    jsfn`Notebooks[id]["objects"][uid]
);


NotebookPromise[uid_, params_][expr_] := With[{},
    WebSocketSend[Global`client, Global`PromiseResolve[uid, expr]];
];

NotebookPromiseDeferred[uid_, params_][helexpr_] := With[{cli = Global`client},
    LoopSubmit[Hold[Block[{Global`client = cli}, helexpr]], Function[cbk,
        WebSocketSend[cli, Global`PromiseResolve[uid, cbk]]
    ]];
];

NotebookPromiseKernel[uid_, params_][expr_] := With[{channel = $AssociationSocket[Global`client]},

    jsfn`Notebooks[channel]["kernel"]["Emitt"][Hold[ 
        With[{result = expr // ReleaseHold},
            Print["side evaluating on the Kernel"];
            Global`SendToFrontEnd[Global`PromiseResolve[uid, result]] 
        ]
    ] ]
];

NotebookOperate[cellid_, op_] := (
    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookEventFire[Global`client]},
        op[CellObj[cellid]];
    ];
);

NotebookOperate[cellid_, op_, arg_] := (
    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookEventFire[Global`client]},
        op[CellObj[cellid], arg];
    ];
);

NotebookEvaluateAll := With[{list = CellList[$AssociationSocket[Global`client]]},
    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookEventFire[Global`client]},
        CellObjEvaluate[#, jsfn`Processors] &/@ Select[list, Function[x, x["type"] === "input"]];
    ];
];

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
                        "props"->cell["props"],
                        "display"->cell["display"],
                        "state"->If[StringQ[ cell["state"] ], cell["state"], "idle"]
                    |>,
            
            template = LoadPage[FileNameJoin[{JerryI`WolframJSFrontend`public, "template", "cells", cell["type"]<>".wsp"}], {Global`id = cell[[1]]}]
        },

        WebSocketSend[addr, Global`FrontEndCreateCell[template, obj ]];
    ];
);

NotebookLoadModal[name_, params_List] := Block[{WSP`$publicpath = JerryI`WolframJSFrontend`public},
    LoadPage[FileNameJoin[{"template", "modals", name, "index.wsp"}], params]
]

NotebookLoadPage[name_, params_List] := Block[{WSP`$publicpath = JerryI`WolframJSFrontend`public},
    LoadPage[name, params]
]

SetAttributes[NotebookLoadPage, HoldRest];
SetAttributes[NotebookLoadModal, HoldRest];



NotebookEventFire[addr_]["RemovedCell"][cell_] := (
    (*actually frirstly you need to check!*)
  
    With[
        {
            obj = <|
                        "id"->cell[[1]], 
                        "sign"->cell["sign"],
                        "type"->cell["type"]
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

NotebookEventFire[addr_]["AddCellAfter"][next_, parent_] := (
    Print["Add cell after"];
    (*looks ugly actually. we do not need so much info*)
    console["log", "fire event `` for ``", next, addr];
    With[
        {
            obj = <|
                        "id"->next[[1]], 
                        "sign"->next["sign"],
                        "type"->next["type"],
                        "data"->If[next["data"]//NullQ, "", ExportString[next["data"], "String", CharacterEncoding -> "UTF8"] ],
                        "props"->next["props"],
                        "display"->next["display"],
                        "state"->If[StringQ[ next["state"] ], next["state"], "idle"],
                        "after"-> <|
                            "id"->parent[[1]], 
                            "sign"->parent["sign"],
                            "type"->parent["type"]                           
                        |>
                    |>,
            
            template = LoadPage[FileNameJoin[{JerryI`WolframJSFrontend`public, "template", "cells", next["type"]<>".wsp"}], {Global`id = next[[1]]}]
        },

        WebSocketSend[addr, Global`FrontEndCreateCell[template, obj ]];
    ];
);

NotebookEventFire[addr_]["CellMorphInput"][cell_] := (
    (*looks ugly actually. we do not need so much info*)
    console["log", "fire event `` for ``", cell, addr];
    With[
        {
            obj = <|
                        "id"->cell[[1]], 
                        "sign"->cell["sign"],
                        "type"->cell["type"]
                    |>,
            
            template = LoadPage[FileNameJoin[{JerryI`WolframJSFrontend`public, "template", "cells", "input.wsp"}], {Global`id = cell[[1]]}]
        },

        WebSocketSend[addr, Global`FrontEndCellMorphInput[template, obj ]];
    ];
);

NotebookEventFire[addr_]["CellError"][cell_, text_] := Module[{template},
    Print[Red<>"ERROR"];
    Print[Reset];

    With[{t = text},
        template = LoadPage[FileNameJoin[{JerryI`WolframJSFrontend`public, "template", "popup", "error.wsp"}], {Global`id = cell, Global`from = "Wolfram Evaluator", Global`message = t}];
    ];

    WebSocketSend[addr, Global`FrontEndPopUp[template, text//ToString]];
];

NotebookEventFire[addr_]["Warning"][text_] := Module[{template},
    With[{t = text},
        template = LoadPage[FileNameJoin[{JerryI`WolframJSFrontend`public, "template", "popup", "warning.wsp"}], {Global`id = CreateUUID[], Global`from = "Wolfram Evaluator", Global`message = t}];
    ];
    Print[Yellow<>"Warning"];
    Print[Reset];
    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndPopUp[template, text//ToString], addr];
];

NotebookPopupFire[name_, text_] := Module[{template},
    With[{t = text},
        template = LoadPage[FileNameJoin[{JerryI`WolframJSFrontend`public, "template", "popup", name<>".wsp"}], {Global`id = CreateUUID[], Global`from = "JS Console", Global`message = t}];
    ];
    Print[Blue<>"loopback"];
    Print[Reset];
    WebSocketSend[Global`client, Global`FrontEndPopUp[template, text//ToString]];
];


NotebookEventFire[addr_]["Print"][text_] := Module[{template},
    With[{t = text},
        template = LoadPage[FileNameJoin[{JerryI`WolframJSFrontend`public, "template", "popup", "print.wsp"}], {Global`id = CreateUUID[], Global`from = "Wolfram Evaluator", Global`message = t}];
    ];
    Print[Green<>"Print"];
    Print[Reset];
    WebSocketPublish[JerryI`WolframJSFrontend`server, Global`FrontEndPopUp[template, text//ToString], addr];
];

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

        WebSocketSend[addr, Global`FrontEndMorpCell[template, obj ]];
    ];
);

NotebookEventFire[addr_]["CellMorph"][cell_] := (Null);

(* fake events for forming standalone app *)

NotebookFakeEventFire[array_]["NewCell"][cell_] := (
    (*looks ugly actually. we do not need so much info*)
    console["log", "fire event `` for ``", cell, array];
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

        array["Push", Global`FrontEndCreateCell[template, obj ]];
    ];
);

End[];
EndPackage[];