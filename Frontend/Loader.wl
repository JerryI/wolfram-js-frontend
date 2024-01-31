BeginPackage["JerryI`Notebook`Loader`", {"JerryI`Misc`Events`", "JerryI`Notebook`", "JerryI`WLX`WebUI`"}];
    
    Begin["`Internal`"];

    cache = <||>;

    
    save[path_String, notebook_Notebook, opts: OptionsPattern[] ] := Module[{dir = path},
        If[DirectoryQ[dir],
            dir = FileNameJoin[{dir, RandomWord[]<>".wln"}];
        ];

        cache[dir] = notebook;
        notebook["Path"] = dir;

        EventFire[OptionValue["Events"], "Loader:NewNotebook", notebook];

        Print["filepath:"]
        Print[dir];
        Print["end"];

        If[OptionValue["Temporal"],
            With[{r = Put[<| 
                "Notebook" -> Notebook`Serialize[notebook], 
                "Cells" -> ( CellObj`Serialize /@ notebook["Cells"]), 
                "serializer" -> "jsfn4" 
            |>, FileNameJoin[{Directory[], "__backups", StringTemplate["``.wln"][dir // Hash]}] ]},
                If[!StringQ[r], Echo["Loader >> Put >> error"]; Echo[r]; Return[$Failed] ];
            ];
        ,
            With[{h = checkbackups[notebook]}, If[h =!= False, DeleteFile[h] ] ];
            With[{r = Put[<| 
                "Notebook" -> Notebook`Serialize[notebook], 
                "Cells" -> ( CellObj`Serialize /@ notebook["Cells"]), 
                "serializer" -> "jsfn4" 
            |>, dir] },
                If[!StringQ[r] && (r =!= Null), Echo["Loader >> Put >> error"]; Echo[r]; Return[$Failed] ];
            ];
        ];

        notebook
    ];

    checkbackups[notebook_Notebook] := notebook["Path"] // checkbackups
    checkbackups[p_String] := With[{
        path = FileNameJoin[{Directory[], "__backups", StringTemplate["``.wln"][p // Hash]}]
    },
        If[FileExistsQ[path], path, False]
    ];

    save[notebook_Notebook, opts: OptionsPattern[] ] := With[{},
        If[ StringQ[notebook["Path"] ],
            save[notebook["Path"], notebook, opts]
        ,
            Echo["Loader >> Provide PATH!"];
            $Failed
        ]
    ];

    save[path_String, opts: OptionsPattern[] ] := With[{notebook = Notebook[]},
        Echo["Loader >> Created new notebook"];
        

        CellObj["Notebook" -> notebook, "Data" -> ""];
        save[path, notebook, opts]
    ];

    load[path_String, opts: OptionsPattern[] ] := Module[{},
        If[!FileExistsQ[path], Echo["Loader >> file noex!!!"]; Return[$Failed] ];
        If[KeyExistsQ[cache, path], 
            Echo["Loader >> cached >> restoring"];
            If[TrueQ[ cache[path]["Opened"] ],
                EventFire[OptionValue["Events"], "Loader:Error", "Notebook was already opened!"];
                While[TrueQ[ cache[path]["Opened"] ],
                    (* wow such a hack... we have to rely on sockets in order to detect if window was closed... *)
                    EventFire[OptionValue["Events"], "Loader:Error", "Closing previous connection..."];
                    EventFire[cache[path]["Socket"], "Closed", True];
                    EventRemove[ cache[path]["Socket"] ];
                ];
                
            ];

            Return[ cache[path] ];
        ];

        Echo["Loader >> loading..."];

        With[{h = checkbackups[path]}, 
            If[h =!= False, 
                If[FileDate[h, "Modification"] > FileDate[path, 	"Modification"],
                    Echo["Loader >> found a backup copy!"];
                    With[{request = CreateUUID[]},
                        EventHandler[request, {
                            "Success" -> Function[assoc,
                                EventRemove[request];
                                loadToCache[h, path, path, opts];
                                WebUISubmit[ WebUILocation[URLEncode[path] ], assoc["Client"] ];
                            ],

                            _ -> Function[assoc,
                                EventRemove[request];
                                loadToCache[path, path, path, opts];
                                WebUISubmit[ WebUILocation[URLEncode[path] ], assoc["Client"] ];
                            ]
                        }];

                        Return[<|
                            "Type" -> "PickAFile", "Callback" -> request, "Date" -> FileDate[h, "Modification"]
                        |>];
                    ];
                ,
                    Echo["Temporal copy is outdated... removing"];
                    DeleteFile[h];
                ];
            ];
        ];


        loadToCache[path, path, path, opts]


    ];

    Options[load] = {"Events"->"Blackhole"}
    Options[save] = {"Events"->"Blackhole", "Temporal"->False}
    Options[loadToCache] = {"Events"->"Blackhole", "Temporal"->False}

    loadToCache[path_String, pathcache_String, pathnotebook_String, OptionsPattern[] ] := Module[{data = Get[path]},
        Echo["Loading to cache..."];
        
        With[{notebook = Notebook`Deserialize[ data ]},
            If[FailureQ[notebook], Return[$Failed] ];

            
            notebook["Path"] = pathnotebook;
            cache[pathcache] = notebook;

            Echo["Loader >> Done!"];
            EventFire[OptionValue["Events"], "Loader:LoadNotebook", notebook];

            notebook
        ]    
    ]

    End[];
    
EndPackage[];

{JerryI`Notebook`Loader`Internal`save, JerryI`Notebook`Loader`Internal`load}