Begin["JerryI`Notebook`Views`"];

{EmptyComponent,       EmptyScript}        = ImportComponent["Views/Empty.wlx"];
{NotebookComponent,    NotebookScript}     = ImportComponent["Views/Notebook/Notebook.wlx"];

(* /* view router */ *)
View[opts__] := With[{list = Association[ List[opts] ]},
    Router[ list["Path"] ][opts]
];

Router[any_] := With[{},
    Print["Generic router"];
    ({EmptyComponent[##], EmptyScript[##]} &)
];

NotebookQ[path_] := FileExtension[path] === "wln";
Router[any_?NotebookQ] := With[{n = JerryI`Notebook`Loader`Load[any]},
    Print["Notebook router"];
    ({NotebookComponent[##, "Notebook"->n], NotebookScript[##]} &)
];

End[];

JerryI`Notebook`Views`View