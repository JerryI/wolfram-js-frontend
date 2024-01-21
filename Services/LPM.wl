BeginPackage["JerryI`LPM`"]

PacletRepositories::usage = "PacletRepositories[{Github -> \"URL to the repo\", ...}] specify the wolfram packages to be synced via remote url"
Github::usage = "internal name to specify the source of the package"


Begin["`Private`"]

JerryI`LPM`Private`Version = 12
pacletDirectoryLoad = PacletDirectoryLoad

PacletRepositories[list_List, OptionsPattern[]] := Module[{projectDir, info, repos, cache, updated, removed, new, current, updatable},
    (* making key-values pairs *)
    repos = (#-><|"key"->#|>)&/@list // Association;

    (* locating project directory *)
    If[OptionValue["Directory"]//StringQ,
      projectDir = OptionValue["Directory"];
      If[!StringQ[projectDir], Echo["LPM >> Sorry. wrong folder!"]; Abort[]];
    ,
      projectDir = NotebookDirectory[];
      If[!StringQ[projectDir], projectDir = DirectoryName[$InputFileName]];
      If[!StringQ[projectDir], Echo["LPM >> Sorry. cannot work without project directory. Save your notebook / script first"]; Abort[]];    
    ];

    If[!FileExistsQ[projectDir],
      CreateDirectory[projectDir, CreateIntermediateDirectories->True];
      If[!FileExistsQ[projectDir], Echo["LPM >> Cannot create project directory by path "<>projectDir<>" !!!"]; Abort[] ];
    ];

    Echo["LPM >> project directory >> "<>projectDir];
    Echo["LPM >> fetching paclet infos..."];

    (* PASSIVE mode :: skips all checks and just loads wl_package folder *)
    If[OptionValue["Passive"], 
      Echo["LPM >> PASSIVE MODE"];
      Map[pacletDirectoryLoad] @  Map[DirectoryName] @  FileNames["PacletInfo.wl", {#}, {2}]& @ FileNameJoin[{projectDir, "wl_packages"}];
      Return[Null, Module];
    ];

    If[FailureQ[ URLFetch["https://github.com"] ],
      Echo["LPM >> ERROR! no internet connection to github.com!"];
      
      If[!MissingQ[cache], 
        Echo["LPM >> using stored data"];
        Map[pacletDirectoryLoad] @  Map[DirectoryName] @  FileNames["PacletInfo.wl", {#}, {2}]& @ FileNameJoin[{projectDir, "wl_packages"}];
        Return[Null, Module];
      ,
        Echo["LPM >> ERROR! no cache found ;()"];
        Abort[];
      ];
    ];

    (* fetching new information from Github for each repo in the list *)
    repos = If[!AssociationQ[#], Missing[], #] &/@ FetchInfo /@ repos;

    repos = repos // DeleteMissing;

    (* fetching cached data (current status of all packages in the project) *)
    Echo["LPM >> checking cached"];
    cache = CacheLoad[projectDir];



    (* if there is no cache -> *)
    If[MissingQ[cache], 
      (* nothing is installed! Install them all *)
      repos = InstallPaclet[projectDir] /@ repos;
    ,
      (* we have local versions of all packages *)
      (* we need to compare them to one, which were just loaded via internet *)

      removed =  (#->cache[#])&/@ Complement[Keys[cache], Keys[repos]] // Association;
      current    =  (#->cache[#])&/@ Intersection[Keys[repos], Keys[cache]] // Association;
      new = (#->repos[#])&/@ Complement[Keys[repos], Keys[cache]] // Association;

      Echo[StringTemplate["LPM >> will be REMOVED: ``"][Length[removed]]];
      Echo[StringTemplate["LPM >> will be INSTALLED: ``"][Length[new]]];
     
      (* remove unecessary (a user removed them) *)
      RemovePaclet[projectDir] /@ removed;
      (* install new *)
      new = InstallPaclet[projectDir] /@ new;

      (* what must be updated *)
      updatable = Select[current, CheckUpdates];
      (* will be updated *)
      updated   = ((#->repos[#])&/@ Keys[updatable]) // Association;
 
      Echo[StringTemplate["LPM >> will be UPDATED: ``"][Length[updatable]]];

      (* update our list with fresh data *)
      repos = Join[current, InstallPaclet[projectDir] /@ updated, new];
    ];

    (* update local cache file aka packages.json *)
    CacheStore[projectDir, repos];

    (* finally load dirs *)
    Map[pacletDirectoryLoad] @  Map[DirectoryName] @  FileNames["PacletInfo.wl", {#}, {2}]& @ FileNameJoin[{projectDir, "wl_packages"}];
]

Options[PacletRepositories] = {"Directory"->None, "Passive"->False}

CacheStore[dir_String, repos_Association] := Export[FileNameJoin[{dir, "wl_packages_lock.wl"}], repos]
CacheLoad[dir_String] := If[!FileExistsQ[FileNameJoin[{dir, "wl_packages_lock.wl"}]], Missing[], Import[FileNameJoin[{dir, "wl_packages_lock.wl"}]]];

CheckUpdates[a_Association] := Module[{result},
  CheckUpdates[a, a["key"]]
]

convertVersion[str_String] := ToExpression[StringReplace[str, "." -> ""]]

(* general function work for both Releases & Branches *)
CheckUpdates[a_Association, Rule[Github, _]] := Module[{package, new, now},
  (* fetch any *)
  package = FetchInfo[a];
  If[!AssociationQ[package], Echo["LPM >> cannot check the github! skipping..."]; Return[False, Module]];

  (* a feature on how we can detect on what we are looking at *)
  If[KeyExistsQ[package, "tag_name"],
    (* releases *)
    new = package["tag_name"] // convertVersion;
    now = a["tag_name"] //convertVersion;

    (* if there was no available releases before and now it appeared, there will be missmatch *)
    If[!NumericQ[now], now = -1];

    Echo[StringTemplate["LPM >> installed `` remote ``"][now, new]];
    now < new  
  ,
    (* branches *)
    new = package["Version"] // convertVersion;
    now = a["Version"] //convertVersion;
    If[!NumericQ[now], now = -1];

    Echo[StringTemplate["LPM >> installed `` remote ``"][now, new]];
    now < new  
  ]
]

(* general function to fetch information about the package *)
FetchInfo[a_Association] := Module[{result},
  FetchInfo[a, a["key"]]
]

(* for releases *)
FetchInfo[a_Association, Rule[Github, url_String]] := Module[{new, data},
  (* extracting from given url *)
  new = StringCases[url, RegularExpression[".com\\/(.*).git"]->"$1"]//First // Quiet;
    If[!StringQ[new], new = StringCases[url, RegularExpression[".com\\/(.*)"]->"$1"]//First];
    Echo["LPM >> fetching releases info by "<>new<>" on a Github..."];

  (* here we FETCH GITHUB API RESPONCE and use releases metadata *)
  data = Import["https://api.github.com/repos/"<>new<>"releases/latest", "JSON"] // Association // Quiet;

  (* if there is NO RELEASES *)
  If[!StringQ[data["zipball_url"]],
    Print["Releases are not available for now... taking a master branch"];
    (* TAKE MASTER Branch *)
    Return[FetchInfo[a, Rule[Github, Rule[url, "master"]]]];
  ];

  (* merge new and old data together *)
  Join[a, data, <|"git-url"->new|>]
]

(* for branches *)
FetchInfo[a_Association, Rule[Github, Rule[url_String, branch_String]]] :=
Module[{new, data},
  (* extracting from given url *)    
    new = StringCases[url, RegularExpression[".com\\/(.*).git"]->"$1"]//First // Quiet;
    If[!StringQ[new], new = StringCases[url, RegularExpression[".com\\/(.*)"]->"$1"]//First];
    Echo["LPM >> fetching info by "<>new<>" on a Github..."];

    (* here we FETCH PACLETINFO.WL file and use its metadata *)
    data = Check[Get["https://raw.githubusercontent.com/"<>new<>"/"<>ToLowerCase[branch]<>"/PacletInfo.wl"], $Failed];
    
    (* if failed. we just STOP *)
    If[FailureQ[data],
      Echo["LPM >> ERROR cannot get "<>new<>"!"];
      Echo["LPM >> Abortting"];
      Abort[];
    ];

    Join[a, data//First, <|"git-url"->new|>]
]

(* general function *)
InstallPaclet[dir_String][a_Association] := InstallPaclet[dir][a, a["key"]]

(* releases *)
InstallPaclet[dir_String][a_Association, Rule[Github, url_String]] := Module[{dirName, pacletPath},
    dirName = FileNameJoin[{dir, "wl_packages"}];
    If[!FileExistsQ[dirName], CreateDirectory[dirName]];

    (* check if there is no data on releases -> *)
    If[MissingQ[a["zipball_url"]], 
      (* TAKE Master branch instead *)
      Echo["LPM >> Releases are not available for now... taking a master branch"];
      Return[InstallPaclet[dir][a, Rule[Github, Rule[url, "master"]]]];
    ];

    (* make a name from the git url provided *)
    dirName = FileNameJoin[{dirName, StringReplace[a["git-url"], "/"->"_"]}];

    (* in a case of update, directory will probably be there.. cleaning it! *)
    If[FileExistsQ[dirName],
        Echo["LPM >> package folder "<>dirName<>" is already exists!"];
        Echo["LPM >> purging..."];
        DeleteDirectory[dirName, DeleteContents -> True];
    ];

    (* download release *)
    Echo["LPM >> fetching a release..."];    
    URLDownload[a["zipball_url"], FileNameJoin[{dir, "___temp.zip"}]];
    
    (* extract to temporary directory and copy *)
    Echo["LPM >> extracting..."];
    ExtractArchive[FileNameJoin[{dir, "___temp.zip"}], FileNameJoin[{dir, "___temp"}]];
    DeleteFile[FileNameJoin[{dir, "___temp.zip"}]];
    
    (* locate PacletInfo, if it is not there, this is very bad. *)
    pacletPath = FileNames["PacletInfo.wl", FileNameJoin[{dir, "___temp"}], 2] // First;

    If[!FileExistsQ[pacletPath], Echo["LPM >> FAILED!!! to fetch by "<>ToString[pacletPath]]; Abort[]];
    pacletPath = DirectoryName[pacletPath];

    Echo[StringTemplate["LPM >> copying... from `` to ``"][pacletPath, dirName]];
 
    CopyDirectory[pacletPath, dirName];
    DeleteDirectory[FileNameJoin[{dir, "___temp"}], DeleteContents -> True];
    Print["LPM >> finished!"];

    a
]

(* for branch *)
InstallPaclet[dir_String][a_Association, Rule[Github, Rule[url_String, branch_String]]] := Module[{dirName, pacletPath},
    dirName = FileNameJoin[{dir, "wl_packages"}];
    If[!FileExistsQ[dirName], CreateDirectory[dirName]];

    (* internal error, if there is no url provided *)
    If[MissingQ[a["git-url"]], Echo["LPM >> ERROR!!! not git-url was found"]; Abort[]];

    (* construct name of the folder *)
    dirName = FileNameJoin[{dirName, StringReplace[a["Name"], "/"->"_"]}];

    If[FileExistsQ[dirName],
        Echo["LPM >> package folder "<>dirName<>" is already exists!"];
        Echo["LPM >> purging..."];
        DeleteDirectory[dirName, DeleteContents -> True];
    ];

    (* download branch as zip using old API *)
    Echo["LPM >> fetching a zip archive from the master branch..."];    
    URLDownload["https://github.com/"<>a["git-url"]<>"/zipball/"<>ToLowerCase[branch], FileNameJoin[{dir, "___temp.zip"}]];
    
    Echo["LPM >> extracting..."];
    ExtractArchive[FileNameJoin[{dir, "___temp.zip"}], FileNameJoin[{dir, "___temp"}]];
    DeleteFile[FileNameJoin[{dir, "___temp.zip"}]];
    
    pacletPath = FileNames["PacletInfo.wl", FileNameJoin[{dir, "___temp"}], 2] // First;

    If[!FileExistsQ[pacletPath], Echo["LPM >> FAILED!!! to fetch by "<>ToString[pacletPath]]; Abort[]];
    pacletPath = DirectoryName[pacletPath];

    Echo[StringTemplate["LPM >> copying... from `` to ``"][pacletPath, dirName]];
 
    CopyDirectory[pacletPath, dirName];
    DeleteDirectory[FileNameJoin[{dir, "___temp"}], DeleteContents -> True];
    Print["LPM >> finished!"];

    a
]


(* general function *)
RemovePaclet[dir_String][a_Association] := RemovePaclet[dir][a, a["key"]]

(* releases *)
RemovePaclet[dir_String][a_Association, Rule[Github, url_String]] := (
  
  If[MissingQ[a["zipball_url"]], 
    Echo["LPM >> Releases are not available for now... removing master"];
    Return[RemovePaclet[dir][a, Rule[Github, Rule[url, "master"]]]];
  ];  

  dirName = FileNameJoin[{dir, "wl_packages"}];
  dirName = FileNameJoin[{dirName, StringReplace[a["git-url"], "/"->"_"]}];

  If[FileExistsQ[dirName],
      Echo["LPM >> package folder "<>dirName<>" is about to be removed"];
      Echo["LPM >> purging..."];
      DeleteDirectory[dirName, DeleteContents -> True];
  ,
      Echo["LPM >> package folder "<>dirName<>" was already removed!"];
      Echo["LPM >> UNEXPECTED BEHAVIOUR!"]; Abort[];
  ];

  a  
)

(* branches *)
RemovePaclet[dir_String][a_Association, Rule[Github, Rule[url_String, branch_String]]] := Module[{dirName, pacletPath},
    dirName = FileNameJoin[{dir, "wl_packages"}];
    dirName = FileNameJoin[{dirName, StringReplace[a["Name"], "/"->"_"]}];

    If[FileExistsQ[dirName],
        Echo["LPM >> package folder "<>dirName<>" is about to be removed"];
        Echo["LPM >> purging..."];
        DeleteDirectory[dirName, DeleteContents -> True];
    ,
        Echo["LPM >> package folder "<>dirName<>" was already removed!"];
        Echo["LPM >> UNEXPECTED BEHAVIOUR!"]; Abort[];
    ];

    a
]

End[]

EndPackage[]