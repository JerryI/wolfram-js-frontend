Begin["JerryI`Notebook`Loader`"];
    cache = <||>;

    Save[path_String, notebook_Notebook] := Module[{dir = path},
        If[DirectoryQ[dir],
            dir = FileNameJoin[{dir, RandomWord[]<>".wln"}];
        ];

        cache[dir] = notebook;
        notebook["Path"] = dir;


        Put[<| 
            "Notebook" -> Notebook`Serialize[notebook], 
            "Cells" -> ( CellObj`Serialize /@ notebook["Cells"]), 
            "serializer" -> "jsfn4" 
        |>, dir];

        notebook
    ];

    Save[notebook_Notebook] := With[{},
        If[ StringQ[notebook["Path"] ],
            Save[notebook["Path"], notebook]
        ,
            Echo["Loader >> Provide PATH!"];
            $Failed
        ]
    ]

    Save[path_String] := With[{notebook = Notebook[]},
        Echo["Loader >> Created new notebook"];
        CellObj["Notebook" -> notebook, "Data" -> ""];
        Save[path, notebook ]
    ]

    Load[path_String] := Module[{data},
        If[!FileExistsQ[path], Echo["Loader >> file noex!!!"]; Return[$Failed] ];
        If[KeyExistsQ[cache, path], 
            Echo["Loader >> cached >> restoring"];
            Return[ cache[path] ];
        ];

        Echo["Loader >> loading..."];
        data = Get[path];

        If[data["serializer"] =!= "jsfn4", Echo["Loader >> Unknown serializer"]; Print[data["serializer"] ]; Return[$Failed] ];

        Exit[0];
        
        notebook = Notebook`Deserialize[ data["Notebook"] ];
        notebook["Cells"] = CellObj`Deserialize[#, notebook] &/@ data["Cells"];
        Echo["Loader >> Done!"];

        notebook
    ];


End[];