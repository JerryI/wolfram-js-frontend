BeginPackage["CoffeeLiqueur`ExtensionManager`"];

Repositories;
Packages;

SaveConfiguration;
InstallByURL;
Includes;

Github;

Begin["`Private`"]

$ProjectDir;

$packages;
$name2key = <||>;

Packages /: Keys[Packages] := $name2key // Keys
Packages[name_String, fields__] := $packages[ $name2key[name], fields ] 
Packages[name_String] := $packages[ $name2key[name] ] 

Packages /: KeyExistsQ[ Packages[name_String, fields__] ] := !MissingQ[ $packages[ $name2key[name], fields ] ]
Packages /: KeyExistsQ[ Packages[name_String] ] := KeyExistsQ[ $packages,  $name2key[name]  ]

Packages /: Set[ Packages[name_String, fields__], value_ ] := With[{tag = $name2key[name]},
    $packages[tag, fields] = value 
]


Includes[param_] := Includes[param] = 
Table[ 
    Table[ 
      FileNameJoin[{Packages[i, "name"], StringSplit[j, "/"]} // Flatten]
    , {j, {Packages[i, "wljs-meta", param]} // Flatten} ]
, {i, Select[Packages // Keys, (Packages[#, "enabled"] && KeyExistsQ[Packages[#, "wljs-meta"], param])&]}] // Flatten;


Repositories[list_List, OptionsPattern[] ] := Module[{projectDir, info, repos, cache, updated, removed, new, current, updatable, skipUpdates = False},
    (* making key-values pairs *)
    repos = (#-><|"key"->#|>)&/@list // Association;

    (* locating project directory *)
    If[OptionValue["Directory"]//StringQ,
      projectDir = OptionValue["Directory"];
      If[!StringQ[projectDir], Echo["WLJS::PM >> Sorry. wrong folder!"]; Abort[] ];
    ,
      projectDir = NotebookDirectory[];
      If[!StringQ[projectDir], projectDir = DirectoryName[$InputFileName] ];
      If[!StringQ[projectDir], Echo["WLJS::PM >> Sorry. cannot work without project directory. Save your notebook / script first"]; Abort[] ];    
    ];

    If[!FileExistsQ[projectDir],
      CreateDirectory[projectDir, CreateIntermediateDirectories->True];
      If[!FileExistsQ[projectDir], Echo["WLJS::PM >> Cannot create project directory by path "<>projectDir<>" !!!"]; Abort[] ];
    ];

    Echo["WLJS::PM >> project directory >> "<>projectDir];

    If[FileExistsQ[FileNameJoin[{projectDir, ".wljs_timestamp"}] ] && !OptionValue["ForceUpdates"],
      With[{time = Get[ FileNameJoin[{projectDir, ".wljs_timestamp"}] ]},
        If[Now - time < OptionValue["UpdateInterval"],
          skipUpdates = True;
          Echo[StringJoin["WLJS::PM >> last updated >> ", time // TextString] ];
        ]
      ]
    ];    

    If[OptionValue["ForceUpdates"],
      skipUpdates = False;
    ];

    If[!skipUpdates, If[FailureQ[ URLFetch["https://github.com"] ], skipUpdates = True] ];

    Echo["WLJS::PM >> fetching paclet infos..."];

    If[skipUpdates,
      Echo["WLJS::PM >> passive mode"];
      Echo["WLJS::PM >> checking cached"];
      cache = CacheLoad[projectDir];
      
      If[!MissingQ[cache], 
        Echo["WLJS::PM >> using stored data"];
        
        (* finally load dirs *)
        repos = OverlayReposMeta[projectDir, cache];
        repos = OverlayAnonymousReposMeta[projectDir, repos];

        (* update local cache file aka packages.json *)
        CacheStore[projectDir, repos];    

        $ProjectDir = projectDir;
        $packages = repos;     
        $packages = sortPackages[$packages];   

        Return[Null, Module];
      ,
        Echo["WLJS::PM >> ERROR! no cache found ;()"];
        Abort[];
      ];
    ];

    (* fetching new information from Github for each repo in the list *)
    repos = If[!AssociationQ[#], Missing[], #] &/@ FetchInfo /@ repos;

    repos = repos // DeleteMissing;

    (* fetching cached data (current status of all packages in the project) *)
    Echo["WLJS::PM >> checking cached"];
    cache = CacheLoad[projectDir];



    (* if there is no cache -> *)
    If[MissingQ[cache], 
      (* nothing is installed! Install them all *)
      repos = InstallPaclet[projectDir] /@ repos;
    ,
      (* we have local versions of all packages *)
      (* we need to compare them to one, which were just loaded via internet *)

      current    =  (#->cache[#])&/@ Intersection[Keys[repos], Keys[cache] ] // Association;
      new = (#->repos[#])&/@ Complement[Keys[repos], Keys[cache] ] // Association;

      Echo[StringTemplate["WLJS::PM >> will be INSTALLED: ``"][Length[new] ] ];

      (* install new *)
      new = InstallPaclet[projectDir] /@ new;

      (* what must be updated *)
      updatable = Select[current, CheckUpdates];
      (* will be updated *)
      updated   = ((#->repos[#])&/@ Keys[updatable]) // Association;
 
      Echo[StringTemplate["WLJS::PM >> will be UPDATED: ``"][Length[updatable] ] ];

      (* update our list with fresh data *)
      repos = Join[cache, InstallPaclet[projectDir] /@ updated, new];
    ];

    (* finally load dirs *)
    repos = OverlayReposMeta[projectDir, repos];

    repos = OverlayAnonymousReposMeta[projectDir, repos];

    (* update local cache file aka packages.json *)
    CacheStore[projectDir, repos];   

    Put[Now, FileNameJoin[{projectDir, ".wljs_timestamp"}] ]; 

    $ProjectDir = projectDir;
    $packages = repos;
    $packages = sortPackages[$packages];
]

Options[Repositories] = {"Directory"->Directory[], "ForceUpdates" -> False, "UpdateInterval" -> Quantity[3, "Days"]}

sortPackages[assoc_Association] := With[{},
    Map[
        Function[key, 
            With[{tag = $packages[key, "name"]},
                $name2key[ tag ] = key;
            ];
            key -> $packages[key] 
        ]
    ,   
        SortBy[Keys[$packages], If[KeyExistsQ[$packages[#, "wljs-meta"], "priority"], $packages[#, "wljs-meta", "priority"], If[KeyExistsQ[$packages[#, "wljs-meta"], "important"], -1000, 1] ]& ] 
    ] // Association
]

SaveConfiguration := With[{},
    CacheStore[$ProjectDir, $packages]
]

OverlayReposMeta[dir_String, repos_Association] := With[{},
   With[{data = #},
    Join[data, Import[FileNameJoin[{dir, "wljs_packages", data["name"], "package.json"}], "RawJSON"] ]
   ] &/@ repos
]

OverlayAnonymousReposMeta[dir_String, repos_Association] := With[{
    registered =  With[{data = #},
        FileNameJoin[{dir, "wljs_packages", data["name"], "package.json"}]
    ] &/@ repos // Values,

    found = FileNames["package.json", FileNameJoin[{dir, "wljs_packages"}], 2]    
},
    With[{ new = Complement[found, registered] },
        If[Length[new] =!= 0, Echo["WLJS::PM >> Found an unregistered packages! Probably created by a user outside"] ];

        Join[repos, Association @ Map[
            Function[path,
                Anonymous[path] -> Join[Import[path, "RawJSON"], <|"enabled"->True, "users"->True|>]
            ]
        , new] ]
    ]
]


CacheStore[dir_String, repos_Association] := With[{
    users = Select[repos, Function[assoc, TrueQ[assoc["users"] ] ] ],
    defaults = Select[repos, Function[assoc, !TrueQ[assoc["users"] ] ] ]
},
    Export[FileNameJoin[{dir, "wljs_packages_lock.wl"}], defaults];
    Export[FileNameJoin[{dir, "wljs_packages_users.wl"}], users];
]

CacheLoad[dir_String] := Module[{list},
    If[!FileExistsQ[FileNameJoin[{dir, "wljs_packages_lock.wl"}] ], 
        list = Missing[]
    , 
        list = Get[FileNameJoin[{dir, "wljs_packages_lock.wl"}] ];

        If[FileExistsQ[FileNameJoin[{dir, "wljs_packages_users.wl"}] ],
       
            list = Join[list, Get[FileNameJoin[{dir, "wljs_packages_users.wl"}] ] ]
        ];
    ];

    list
]

CheckUpdates[a_Association] := Module[{result},
  CheckUpdates[a, a["key"]]
]

convertVersion[str_String] := ToExpression[StringReplace[str, "." -> ""]]

(* general function work for both Releases & Branches *)
CheckUpdates[a_Association, Rule[Github, _]] := Module[{package, new, now},
  (* fetch any *)
  package = FetchInfo[a];
  If[!AssociationQ[package], Echo["WLJS::PM >> cannot check github repos! skipping..."]; Return[False, Module]];

  new = package["version"] // convertVersion;
  now = a["version"] //convertVersion;
  If[!NumericQ[now], now = -1];

  Echo[StringTemplate["WLJS::PM >> installed `` remote ``"][now, new]];
  now < new  
]

(* general function to fetch information about the package *)
FetchInfo[a_Association] := Module[{result},
  FetchInfo[a, a["key"]]
]

FetchInfo[a_Association, _Anonymous] := a

(* for releases *)
FetchInfo[a_Association, Rule[Github, url_String]] := Module[{new, data},
  (* TAKE MASTER Branch *)
  Return[FetchInfo[a, Rule[Github, Rule[url, "master"]]]];
]

(* for branches *)
FetchInfo[a_Association, Rule[Github, Rule[url_String, branch_String]]] :=
Module[{new, data},
  (* extracting from given url *)    
    new = StringCases[url, RegularExpression[".com\\/(.*).git"]->"$1"]//First // Quiet;
    If[!StringQ[new], new = StringCases[url, RegularExpression[".com\\/(.*)"]->"$1"]//First];
    Echo["WLJS::PM >> fetching info by "<>new<>" on a Github..."];

    (* here we FETCH PACLETINFO.WL file and use its metadata *)
    data = Check[Import["https://raw.githubusercontent.com/"<>new<>"/"<>ToLowerCase[branch]<>"/package.json", "RawJSON"], $Failed];
    
    (* if failed. we just STOP *)
    If[FailureQ[data],
      Echo["WLJS::PM >> ERROR cannot get "<>new<>"!"];
      Echo["WLJS::PM >> Failed"];
      Return[a];
    ];

    Join[a, data, <|"git-url"->new|>]
]

InstallByURL[url_String, cbk_:Null] := Module[{remote},
    remote = FetchInfo[<|"key" -> (Github -> url)|>];

    If[!KeyExistsQ[remote, "name"],
        Echo["WLJS::PM >> Can't load by the given url"];
        cbk[False, "Can't load by the given url"]; 
        Return[$Failed, Module];
    ];

    If[ MemberQ[Values[#["name"] &/@ $packages], remote["name"] ],
        Echo["WLJS::PM >> Already exists!"];
        cbk[False, "Already exists!"]; 
        Return[$Failed, Module] ;       
    ];

    InstallPaclet[$ProjectDir][remote];
    $packages = Join[$packages, <|(Github -> url) -> Join[remote, <|"users" -> True, "enabled" -> True|>]|>];
    $packages = sortPackages[$packages];
    CacheStore[$ProjectDir, $packages];
    
    cbk[True, "Installed. Reboot is needed"];
]

(* general function *)
InstallPaclet[dir_String][a_Association] := InstallPaclet[dir][a, a["key"]]

(* releases *)
InstallPaclet[dir_String][a_Association, Rule[Github, url_String]] := Module[{dirName, pacletPath},
    (* TAKE Master branch instead *)
    Return[InstallPaclet[dir][a, Rule[Github, Rule[url, "master"]]]];
]

(* for branch *)
InstallPaclet[dir_String][a_Association, Rule[Github, Rule[url_String, branch_String]]] := Module[{dirName, pacletPath},
    dirName = FileNameJoin[{dir, "wljs_packages"}];
    If[!FileExistsQ[dirName], CreateDirectory[dirName]];

    (* internal error, if there is no url provided *)
    If[MissingQ[a["git-url"]], Echo["WLJS::PM >> ERROR!!! not git-url was found"]; Abort[]];

    (* construct name of the folder *)
    dirName = FileNameJoin[{dirName, StringReplace[a["name"], "/"->"_"]}];

    If[FileExistsQ[dirName],
        Echo["WLJS::PM >> package folder "<>dirName<>" is already exists!"];
        Echo["WLJS::PM >> purging..."];
        DeleteDirectory[dirName, DeleteContents -> True];
    ];

    (* download branch as zip using old API *)
    Echo["WLJS::PM >> fetching a zip archive from the branch..."];    
    URLDownload["https://github.com/"<>a["git-url"]<>"/zipball/"<>ToLowerCase[branch], FileNameJoin[{dir, "___temp.zip"}]];
    
    Echo["WLJS::PM >> extracting..."];
    ExtractArchive[FileNameJoin[{dir, "___temp.zip"}], FileNameJoin[{dir, "___temp"}]];
    DeleteFile[FileNameJoin[{dir, "___temp.zip"}]];
    
    pacletPath = FileNames["package.json", FileNameJoin[{dir, "___temp"}], 2] // First;

    If[!FileExistsQ[pacletPath], Echo["WLJS::PM >> FAILED!!! to fetch by "<>ToString[pacletPath]]; Abort[]];
    pacletPath = DirectoryName[pacletPath];

    Echo[StringTemplate["WLJS::PM >> copying... from `` to ``"][pacletPath, dirName]];
 
    CopyDirectory[pacletPath, dirName];
    DeleteDirectory[FileNameJoin[{dir, "___temp"}], DeleteContents -> True];
    Print["WLJS::PM >> finished!"];

    Join[a, <|"enabled" -> True|>]
]


(* general function *)
RemovePaclet[dir_String][a_Association] := RemovePaclet[dir][a, a["key"]]

(* releases *)
RemovePaclet[dir_String][a_Association, Rule[Github, url_String]] := (
  Return[RemovePaclet[dir][a, Rule[Github, Rule[url, "master"]]]];
)

(* branches *)
RemovePaclet[dir_String][a_Association, Rule[Github, Rule[url_String, branch_String]]] := Module[{dirName, pacletPath},
    dirName = FileNameJoin[{dir, "wljs_packages"}];
    dirName = FileNameJoin[{dirName, StringReplace[a["name"], "/"->"_"]}];

    If[FileExistsQ[dirName],
        Echo["WLJS::PM >> package folder "<>dirName<>" is about to be removed"];
        Echo["WLJS::PM >> purging..."];
        DeleteDirectory[dirName, DeleteContents -> True];
    ,
        Echo["WLJS::PM >> package folder "<>dirName<>" was already removed!"];
        Echo["WLJS::PM >> UNEXPECTED BEHAVIOUR!"]; Abort[];
    ];

    a
]

End[]
EndPackage[]
