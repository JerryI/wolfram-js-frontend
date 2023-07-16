BeginPackage["JerryI`WolframJSFrontend`Notebook`", {"JerryI`WolframJSFrontend`Utils`", "JerryI`WSP`", "JerryI`WolframJSFrontend`Cells`", "KirillBelov`WebSocketHandler`", "JerryI`WolframJSFrontend`Kernel`", "JerryI`WolframJSFrontend`Colors`", "KirillBelov`HTTPHandler`Extensions`"}]; 
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

NotebookStoreKernelSymbol::usage = "populate symbols from kernel"
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
NotebookGetSymbol::usage = "get the symbol fromm kernel"

NotebookPromiseKernel::usage = "ask a computing kernel to do something..."

NotebookStore::usage = "save (serialise) the notebook to a file using Cells`Pack methods"
NotebookStoreManually::usage = "altered version of the previous command"

PreloadNotebook::usage = "load into memeory (if it was not there) and updates date and path"
CreateNewNotebook::usage = "create a serialised notebook and store it on a disk"
CreateNewNotebookByPath::usage = "alternamtive version of the prev."

NotebookEmitt::usage = "send anything to the kernel (async)"

NotebookPopupFire::usage = "pop up message"
NotebookEventFire::usage = "fire"

NotebookFocus::usage = "focus on a tab"

NotebookEvaluateAll::usage = ""

NExtendSingleDefinition::usage = ""

GarbageCollector::usage = "collect garbage form notebook"


NotebookExport::usage = "export to standalone html"



(*
    Internal commands used by other packages
    must not be PUBLIC!
*)
NotebookUse::usage = "adds event handlers"

NotebookFrontEndSend::usage = "redirects the output of the remote/local kernel to the frontened with no changes"
GetThumbnail::usage = "get prov"

Begin["`Private`"]; 

NotebookEventFire = Null
NotebookFakeEventFire = Null
NotebookPopupFire = Null

NotebookUse["EventFire", sym_] := NotebookEventFire = sym;
NotebookUse["FakeEventFire", sym_] := NotebookFakeEventFire = sym;
NotebookUse["PopupFire", sym_] := NotebookPopupFire = sym;

SetAttributes[NotebookUse, HoldRest]

$ContextAliases["jsfn`"] = "JerryI`WolframJSFrontend`Notebook`";

DefaultSerializer = ExportByteArray[#, "ExpressionJSON"]&

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
    WebSocketSend[jsfn`Notebooks[sign]["channel"],  Global`UpdateFrontEndExecutable[#, defs[#]["json"] ]] &/@ updated;
];

NExtendSingleDefinition[uid_, defs_][notebook_] := Module[{updated = False},
    Print["Direct definition extension"];

    updated = KeyExistsQ[jsfn`Notebooks[notebook]["objects"], uid];

    jsfn`Notebooks[notebook]["objects"][uid] = defs; 

    If[updated,
        Print["Will be updated! NExtend"];
        WebSocketSend[jsfn`Notebooks[notebook, "channel"], Global`UpdateFrontEndExecutable[uid, defs["json"] ]];  
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

            If[!KeyExistsQ[notebook["notebook"], "symbols"],
                Print["Old format. Adding symbols storage"];
                JerryI`WolframJSFrontend`Notebook`Notebooks[notebook["notebook", "id"], "symbols"] = <||>;
            ];
            

         
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
  WebSocketSend[Global`client, Global`FrontEndJSEval[StringTemplate["openawindow('/index.wsp?path=``', ``)"][FileNameJoin[{dir, filename<>".wl"}]//URLEncode, If[window, "'_blank'", "'_self'"] ] ] // DefaultSerializer ]; 
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

NotebookStoreKernelSymbol[name_, notebookid_][data_] := (
    Print["Obtained the copy of "<>name];

    jsfn`Notebooks[notebookid]["symbols", name, "data"] = data;
    jsfn`Notebooks[notebookid]["symbols", name, "date"] = Now;
);

(* serialise the notebook to a file *)
NotebookStore := Module[{channel = $AssociationSocket[Global`client], cells, notebook = <||>},
    Print[StringTemplate["`` objects to save"][Length[cells] ] ];

    Print["Checking the unstored symbols..."];
    With[{name = #, body = jsfn`Notebooks[channel]["symbols", #]},
        If[True,
            Print["update data for the symbol "<>name];
            Print["getting it from the kernel"];

            With[{c = channel},
                LinkWrite[jsfn`Notebooks[channel]["kernel"]["WSTPLink"], Unevaluated[
                    With[{d = ToExpression[name]},
                        Print["got the request"];
                        Global`SendToMaster[
                            Function[x,
                                Global`NotebookStoreKernelSymbol[name, c][d]
                            ]
                        ][Null];
                    ];
                ] ];
            ];
        ]
    ] &/@ Keys[jsfn`Notebooks[channel]["symbols"]];

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

NotebookExport["html"] := Module[{channel = $AssociationSocket[Global`client], path},
    path = FileNameJoin[{DirectoryName[jsfn`Notebooks[channel]["path"]], FileBaseName[jsfn`Notebooks[channel]["path"]]<>".html"}];
    
    tempArray["data"] = {};
    tempArray["Push", data_] := (tempArray["data"] = {tempArray["data"], data} // Flatten);

    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookFakeEventFire[tempArray]},
        CellListTree[channel];
    ];
    
    With[{uid = channel, tempArrayPointer = tempArray},
        Export[path,
            LoadPage[FileNameJoin[{"template", "export", "notebook.wsp"}], {Global`notebook = uid, Global`cells = tempArrayPointer}, "Base"->JerryI`WolframJSFrontend`public]
        , "String"]
    ];

    WebSocketSend[jsfn`Notebooks[channel]["channel"],  Global`FrontEndUpdateFileList[DirectoryName[jsfn`Notebooks[channel]["path"] ] ]];
    
];

NotebookExport["react"] := Module[{channel = $AssociationSocket[Global`client], path},
    path = FileNameJoin[{"public", "temp", "_react.html"}];
    
    tempArray["data"] = {};
    tempArray["Push", data_] := (tempArray["data"] = {tempArray["data"], data} // Flatten);

    Block[{JerryI`WolframJSFrontend`fireEvent = NotebookFakeEventFire[tempArray]},
        CellListTree[channel];
    ];
    
    With[{uid = channel, tempArrayPointer = tempArray},
        Export[path,
            LoadPage[FileNameJoin[{"template", "export", "react.wsp"}], {Global`notebook = uid, Global`cells = tempArrayPointer}, "Base"->JerryI`WolframJSFrontend`public]
        , "String"]
    ];

    WebSocketSend[jsfn`Notebooks[channel]["channel"],  Global`FrontEndJSEval["openawindow('/temp/_react.html', '_blank')" ]];
];

(* remove a file and update UI elements via WSPDynamicExtension *)
FileOperate["Remove"][urlpath_] := Module[{path}, With[{channel = $AssociationSocket[Global`client]},
    path = URLDecode[urlpath];

    DeleteFile[path];
    If[path === jsfn`Notebooks[channel]["path"] ,
        (* if it was a current notebook -> redirect to the landing page *)
        
        WebSocketSend[jsfn`Notebooks[channel]["channel"],  Global`FrontEndJSEval["openawindow('/index.wsp')" ]];
    ,
        (* just update the UI elements *)
  
        WebSocketSend[jsfn`Notebooks[channel]["channel"],  Global`FrontEndUpdateFileList[Null]];
    ];
]];

NotebookUpdateThumbnail[data_] := With[{channel = $AssociationSocket[Global`client]},
    jsfn`Notebooks[channel]["thumbnail"] = data;
];

(* clone and open a new page *)
FileOperate["Clone"][urlpath_] := Module[{new, path},
    path = URLDecode[urlpath];

    If[DirectoryQ[path],
        WebSocketSend[Global`client, Global`FrontEndJSEval["alert('Cannot clone a directory')" ] // DefaultSerializer];
        Return[Null, Module];
    ];

    new = FileNameJoin[{DirectoryName[path], FileBaseName[path]<>"-Clone."<>FileExtension[path]}];
    CopyFile[path, new];

    (* open a new page *)
    WebSocketSend[Global`client, Global`FrontEndJSEval[StringTemplate["openawindow('/index.wsp?path=``', '_blank')"][new//URLEncode ] ] // DefaultSerializer];
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
    WebSocketSend[jsfn`Notebooks[channel]["channel"],  Global`FrontEndUpdateFileName[newname, jsfn`Notebooks[channel]["path"]]];
    WebSocketSend[jsfn`Notebooks[channel]["channel"],  Global`FrontEndUpdateFileList[DirectoryName[jsfn`Notebooks[channel]["path"] ] ]];

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
    WebSocketSend[jsfn`Notebooks[channel]["channel"],  Global`FrontEndGlobalAbort[Null]]

    With[{list = CellList[$AssociationSocket[Global`client]]},
            (#["state"] = "idle") &/@ Select[list, Function[x, x["type"] === "input"]];
    ];    
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

    WebSocketSend[jsfn`Notebooks[id, "channel"], Global`FrontEndDispose[garbage]];
    Print[StringTemplate["`` were collected"][Length[garbage]] ];
];

NotebookOpen[id_String] := (
    console["log", "generating the three of `` for ``", id, Global`client];
    $AssociationSocket[Global`client] = id;

    jsfn`Notebooks[id]["channel"] = WebSocketChannel[];
    Print[jsfn`Notebooks[id]["channel"]];

    Module[{c = jsfn`Notebooks[id]["channel"]},
        Append[c, Global`client];
        c@"Serializer" = ExportByteArray[#, "ExpressionJSON"]&;
    ];

    Print["Poppulating with a stored symbols..."];
    
    If[KeyExistsQ[jsfn`Notebooks[id]["symbols", #], "data"], 
        Print["restoring... "<>#];
        WebSocketSend[Global`client, Global`FrontEndRestoreSymbol[#, jsfn`Notebooks[id]["symbols", #, "data"]] // DefaultSerializer];
    ] &/@ Keys[jsfn`Notebooks[id]["symbols"]];

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
        WebSocketSend[jsfn`Notebooks[channel]["channel"],  Global`FrontEndKernelStatus[ state ]];
        
        jsfn`Notebooks[channel]["kernel"]["AttachNotebook"][channel, DirectoryName[jsfn`Notebooks[channel]["path"]]];
    ]];
];

NotebookFocus[channel_] := (
    jsfn`Notebooks[channel]["kernel"]["AttachNotebook"][channel, DirectoryName[jsfn`Notebooks[channel]["path"]]]
);


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
    WebSocketSend[Global`client, Global`PromiseResolve[uid, expr] // DefaultSerializer];
];

NotebookPromiseDeferred[uid_, params_][helexpr_] := With[{cli = Global`client},
    LoopSubmit[Hold[Block[{Global`client = cli}, helexpr]], Function[cbk,
        WebSocketSend[Global`client, Global`PromiseResolve[uid, cbk] // DefaultSerializer];
    ]];
];

NotebookGetSymbol[uid_, params_][expr_] := Module[{}, With[{channel = $AssociationSocket[Global`client]},
    If[jsfn`Notebooks[channel]["kernel"]["Status"]["signal"] =!= "good",
        Print["Oh. Kernel is not attached. Cannot do get the symbol"];
        WebSocketSend[Global`client, Global`PromiseResolve[uid, Global`ImSorryIJustCannotDoThat] // DefaultSerializer];
        Return[$Failed, Module];
    ];

    jsfn`Notebooks[channel]["symbols"][Extract[expr, 1, ToString]] = <|"date"->Now|>;
    
    jsfn`Notebooks[channel]["kernel"]["Emitt"][Hold[ 
        With[{result = expr // ReleaseHold},
            Print["evaluating the desired symbol on the Kernel"];
            Print["promise resolve"];
            Global`SendToFrontEnd[Global`PromiseResolve[uid, result]] 
        ]
    ] ]
]];

NotebookPromiseKernel[uid_, params_][expr_] := Module[{}, With[{channel = $AssociationSocket[Global`client]},
    If[jsfn`Notebooks[channel]["kernel"]["Status"]["signal"] =!= "good",
        Print["Oh. Kernel is not attached. Cannot do the promise"];
        WebSocketSend[Global`client, Global`PromiseResolve[uid, Global`ImSorryIJustCannotDoThat] // DefaultSerializer];
        Return[$Failed, Module];
    ];
    
    jsfn`Notebooks[channel]["kernel"]["Emitt"][Hold[ 
        With[{result = expr // ReleaseHold},
            Print["side evaluating on the Kernel"];
            Print["promise resolve"];
            Global`SendToFrontEnd[Global`PromiseResolve[uid, result]] 
        ]
    ] ]
]];

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
    content = Block[{$CurrentRequest = <|"Query"-><|"id"->id|>|>, commandslist = {}},
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
    Print["String ARE NOT Allowed"];
    Exit[];
);


(* 
    Internal commands
    events on cells operations
*)



NotebookLoadModal[name_, params_List] := Block[{WSP`$publicpath = JerryI`WolframJSFrontend`public},
    LoadPage[FileNameJoin[{"template", "modals", name, "index.wsp"}], params, "Base":>JerryI`WolframJSFrontend`public]
]

NotebookLoadPage[name_, params_List] := Block[{WSP`$publicpath = JerryI`WolframJSFrontend`public},
    LoadPage[name, params, "Base":>JerryI`WolframJSFrontend`public]
]

SetAttributes[NotebookLoadPage, HoldRest];
SetAttributes[NotebookLoadModal, HoldRest];



End[];
EndPackage[];