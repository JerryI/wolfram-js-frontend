Begin["JerryI`Notebook`Loader`"];
    cache = <||>;

    JerryI`Notebook`Loader`Save[path_String, notebook_Notebook] := Module[{dir = path},
        If[DirectoryQ[dir],
            dir = FileNameJoin[{dir, RandomWord[]<>".wln"}];
        ];

        cache[dir] = notebook;
        notebook["Path"] = dir;

        Print["filepath:"]
        Print[dir];
        Print["end"];
        
        Put[<| 
            "Notebook" -> Notebook`Serialize[notebook], 
            "Cells" -> ( CellObj`Serialize /@ notebook["Cells"]), 
            "serializer" -> "jsfn4" 
        |>, dir] // Print;

        notebook
    ];

    JerryI`Notebook`Loader`Save[notebook_Notebook] := With[{},
        If[ StringQ[notebook["Path"] ],
            JerryI`Notebook`Loader`Save[notebook["Path"], notebook]
        ,
            Echo["Loader >> Provide PATH!"];
            $Failed
        ]
    ];

    JerryI`Notebook`Loader`Save[path_String] := With[{notebook = Notebook[]},
        Echo["Loader >> Created new notebook"];
        CellObj["Notebook" -> notebook, "Data" -> ""];
        JerryI`Notebook`Loader`Save[path, notebook ]
    ];

    Load[path_String] := Module[{data},
        If[!FileExistsQ[path], Echo["Loader >> file noex!!!"]; Return[$Failed] ];
        If[KeyExistsQ[cache, path], 
            Echo["Loader >> cached >> restoring"];
            Return[ cache[path] ];
        ];

        Echo["Loader >> loading..."];
        data = Get[path];

        If[data["serializer"] =!= "jsfn4", Echo["Loader >> Unknown serializer"]; Print[data["serializer"] ]; Return[$Failed] ];

  
        
        With[{notebook = Notebook`Deserialize[ data["Notebook"] ]},
            notebook["Cells"] = CellObj`Deserialize[#, "Notebook"->notebook] &/@ data["Cells"];
            notebook["Path"] = path;
            cache[path] = notebook;

            Echo["Loader >> Done!"];



            notebook
        ]
    ];


End[];