BeginPackage["JerryI`Notebook`Loader`", {"JerryI`Misc`Events`", "JerryI`Notebook`"}];
    
    Begin["`Internal`"];

    cache = <||>;

    (* Sucks. Save is in System context, I cannot use it here without specifying the context *)
    save[path_String, notebook_Notebook, opts: OptionsPattern[] ] := Module[{dir = path},
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

    save[notebook_Notebook, opts: OptionsPattern[] ] := With[{},
        If[ StringQ[notebook["Path"] ],
            save[notebook["Path"], notebook]
        ,
            Echo["Loader >> Provide PATH!"];
            $Failed
        ]
    ];

    save[path_String, opts: OptionsPattern[] ] := With[{notebook = Notebook[]},
        Echo["Loader >> Created new notebook"];
        EventFire[OptionValue["Events"], "Loader:NewNotebook", notebook];

        CellObj["Notebook" -> notebook, "Data" -> ""];
        save[path, notebook, opts]
    ];

    load[path_String, opts: OptionsPattern[] ] := Module[{data},
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
            EventFire[OptionValue["Events"], "Loader:LoadNotebook", notebook];



            notebook
        ]
    ];

    Options[load] = {"Events"->"Blackhole"}
    Options[save] = {"Events"->"Blackhole"}

    End[];
    
EndPackage[];

{JerryI`Notebook`Loader`Internal`save, JerryI`Notebook`Loader`Internal`load}