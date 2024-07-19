Begin["JerryI`Notebook`Views`"];

{saveNotebook, loadNotebook, renameXXX, cloneXXX}               = ImportComponent["Loader.wl"];
{EmptyComponent,       EmptyScript}        = ImportComponent["Views/Empty.wlx"];
{NotebookComponent,    NotebookScript}     = ImportComponent["Views/Notebook/Notebook.wlx"];

{NotebookMessage, NotebookMessageScript}   = ImportComponent["Views/Notebook/Message.wlx"];
{NotebookFailure}                          = ImportComponent["Views/Notebook/Failure.wlx"];

(* /* view router */ *)
View[opts__] := With[{list = Association[ List[opts] ]},
    Router[ list["Path"] , list["AppEvents"] ][opts]
];

(* /* Default */ *)
Router[any_, _] := With[{},
    Print["Default router"];
    ({EmptyComponent[##], EmptyScript[##]} &)
];

(* /* Notebook */ *)
NotebookQ[path_] := FileExtension[path] === "wln";
Router[any_?NotebookQ, appevents_String] := With[{n = loadNotebook[any, "Events"->appevents]},
    Print["Notebook router"];
    Switch[n
        ,_Notebook
        ,    ({NotebookComponent[##, "Notebook"->n], NotebookScript[##]} &)
        ,_Association
        ,    ({NotebookMessage[##, "Data"->n], NotebookMessageScript[##]} &)
        ,_
        ,    (NotebookFailure[##, "Data"->n] &)
    
    ] 
];


End[];

JerryI`Notebook`Views`View