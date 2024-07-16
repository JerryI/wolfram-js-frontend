BeginPackage["JerryI`Notebook`Loader`", {"JerryI`Misc`Events`", "JerryI`Misc`Events`Promise`", "JerryI`Notebook`", "JerryI`WLX`WebUI`"}];
    
    Begin["`Internal`"];

    scache = <||>;

    cache[key_] := scache[ ToLowerCase[key] ];

    cache /: Set[cache[key_], val_] := With[{l = ToLowerCase[key]},
        scache[l] = val
    ];
    cache /: Unset[cache[key_] ] := With[{l = ToLowerCase[key]},
        scache[l] = .
    ];
    cache /: KeyExistsQ[cache, key_] := With[{l = ToLowerCase[key]},
        KeyExistsQ[scache, l]
    ];

    rename[old_String, new_String] := With[{notebook = cache[old]},
        cache[new] = notebook;
        notebook["Path"] = new;
        cache[old] = .;
        Echo["Loader >> renamed."];
    ];

    rename[notebook_Notebook, new_String] := With[{path = notebook["Path"]},
        cache[path] = .;
        notebook["Path"] = new;
        cache[new] = notebook;
        Echo["Loader >> renamed."];
    ];    

    clone[notebook_Notebook, newPath_String, opts: OptionsPattern[] ] := With[{oldPath = notebook["Path"]},
        cache[oldPath] = .;
        cache[newPath] = notebook;
        notebook["Path"] = newPath;
        save[notebook, opts]
    ];
    
    save[path_String, notebook_Notebook, opts: OptionsPattern[] ] := With[{modals = OptionValue["Modals"], promise = Promise[], client = OptionValue["Client"]}, Module[{dir = path},
        If[DirectoryQ[dir],
            dir = FileNameJoin[{dir, RandomWord[]<>".wln"}];
        ];

        cache[dir] = notebook;
        notebook["Path"] = dir;

        If[OptionValue["Props"] =!= Null,
            Map[(notebook[#] = OptionValue["Props"][#]) &, Keys[OptionValue["Props"] ] ];
        ];

        EventFire[OptionValue["Events"], "Loader:NewNotebook", notebook];

        Print["filepath:"]
        Print[dir];
        Print["end"];

        If[OptionValue["Temporal"],
            With[{r = Put[<| 
                "Notebook" -> Notebook`Serialize[notebook], 
                "Cells" -> ( CellObj`Serialize /@ notebook["Cells"]), 
                "serializer" -> "jsfn4" 
            |>, makeHashPath[dir] ]},
                If[!StringQ[r] && (r =!= Null), Echo["Loader >> Put >> error"]; Echo[r]; Return[$Failed] ];
            ];

            EventFire[promise, Resolve, notebook];
        ,
            With[{h = checkbackups[notebook]}, If[h =!= False, DeleteFile[h] ] ];

            saveByPath := (
                With[{r = Put[<| 
                    "Notebook" -> Notebook`Serialize[notebook], 
                    "Cells" -> ( CellObj`Serialize /@ notebook["Cells"]), 
                    "serializer" -> "jsfn4" 
                |>, dir] },
                    If[!StringQ[r] && (r =!= Null), Echo["Loader >> Put >> error"]; Echo[r]; Return[$Failed] ];
                ];
                EventFire[promise, Resolve, notebook];
            );

            (*If[ MemberQ[FileNameSplit[dir], "Examples"] && !MissingQ[client],
                    With[{request = CreateUUID[]},
                        EventHandler[request, {
                            "Success" -> Function[assoc,
                                EventRemove[request];
                                
                                With[{
                                    p = Promise[]
                                },
                                    EventFire[modals, "RequestPathToSave", <|
                                        "Promise"->p,
                                        "Title"->"Save as",
                                        "Ext"->"wln",
                                        "Client"->assoc["Client"]
                                    |>];

                                    Then[p, Function[directory,

                                        
                                        With[{newDir = If[StringTake[dir, -3] =!= "wln",
                                            directory <> ".wln", directory
                                        ]},
                                            dir = newDir;
                                            cache[newDir] = .;
                                            cache[newDir] = notebook;
                                            notebook["Path"] = newDir;
                                            saveByPath;                                         
                                        ]


                                    ] ];
                                ];

                            ],

                            _ -> Function[assoc,
                                EventRemove[request];
                                saveByPath; 
                            ]
                        }];

                        EventFire[modals, "GenericAskTemplate", <|
                            "Callback" -> request, 
                            "Client" -> client,
                            "Title" -> "It seems you are trying to save to Examples folder, which is read-only. Save to somewhere else?", "SVGIcon" -> ""
                        |>];
                    ];                
            ,
               saveByPath; 
            ];*)

            saveByPath; 
        ];

        

        promise
    ] ];

    checkbackups[notebook_Notebook] := notebook["Path"] // checkbackups
    checkbackups[p_String] := With[{
        path = makeHashPath[p]
    },
        If[FileExistsQ[path], path, False]
    ];

    makeHashPath[path_String, secret_String:""] := FileNameJoin[{Directory[], "__backups", StringTemplate["``.wln"][{path, secret} // Hash]}]

    save[notebook_Notebook, opts: OptionsPattern[] ] := With[{},
        If[ StringQ[notebook["Path"] ],
            save[notebook["Path"], notebook, opts]
        ,
            Echo["Loader >> Provide PATH!"];
            $Failed["PATH is not provided"]
        ]
    ];

    save[path_String, opts: OptionsPattern[] ] := With[{notebook = Notebook[]},
        Echo["Loader >> Created new notebook"];
        

        CellObj["Notebook" -> notebook, "Data" -> ""];
        save[path, notebook, opts]
    ];

    load[path_String, opts: OptionsPattern[] ] := Module[{},
        If[!FileExistsQ[path], 
            Echo["Loader >> file noex!!!"]; 
            Echo[path];
            Return[$Failed["File does not exists"] ] 
        ];
        If[KeyExistsQ[cache, path], 
            Echo["Loader >> cached >> restoring"];
            If[TrueQ[ cache[path]["Opened"] ],
                EventFire[OptionValue["Events"], "Loader:Error", "Notebook was already opened!"];
                While[TrueQ[ cache[path]["Opened"] ],
                    (* wow such a hack... we have to rely on sockets in order to detect if window was closed... *)
                    EventFire[OptionValue["Events"], "Loader:Error", "Closing previous connection..."];
                    EventFire[cache[path]["Socket"], "Closed", True];
                    WebUIClose[cache[path]["Socket"] ];
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
                                WebUILocation[URLEncode[path] , assoc["Client"] ];
                            ],

                            _ -> Function[assoc,
                                EventRemove[request];
                                loadToCache[path, path, path, opts];
                                WebUILocation[URLEncode[path] , assoc["Client"] ];
                            ]
                        }];

                        Return[<|
                            "Type" -> "PickAFile", "Callback" -> request, "Original"->FileDate[path, 	"Modification"], "Date" -> FileDate[h, "Modification"]
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
    Options[save] = {"Events"->"Blackhole", "Temporal"->False, "Modals"->"Nulll", "Props"->Null}
    Options[loadToCache] = {"Events"->"Blackhole", "Temporal"->False, "Modals"->"Nulll"}

    loadToCache[path_String, pathcache_String, pathnotebook_String, OptionsPattern[] ] := Module[{data = Get[path]},
        Echo["Loading to cache..."];
        
        With[{notebook = Notebook`Deserialize[ data ]},
            If[!MatchQ[notebook, _Notebook], Return[notebook] ];

            
            notebook["Path"] = pathnotebook;
            cache[pathcache] = notebook;

            Echo["Loader >> Done!"];
            EventFire[OptionValue["Events"], "Loader:LoadNotebook", notebook];

            notebook
        ]    
    ]

    End[];
    
EndPackage[];

{JerryI`Notebook`Loader`Internal`save, JerryI`Notebook`Loader`Internal`load, JerryI`Notebook`Loader`Internal`rename, JerryI`Notebook`Loader`Internal`clone}