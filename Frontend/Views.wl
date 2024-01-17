Begin["JerryI`Notebook`Views`"];

{saveNotebook, loadNotebook}               = ImportComponent["Loader.wl"];
{EmptyComponent,       EmptyScript}        = ImportComponent["Views/Empty.wlx"];
{NotebookComponent,    NotebookScript}     = ImportComponent["Views/Notebook/Notebook.wlx"];

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
    ({NotebookComponent[##, "Notebook"->n], NotebookScript[##]} &)
];

End[];

JerryI`Notebook`Views`View