BeginPackage["JerryI`LPM`"]

PacletRepositories::usage = "PacletRepositories[{Github -> \"URL to the repo\", ...}] specify the wolfram packages to be synced via remote url"
Github::usage = "internal name to specify the source of the package"


Begin["`Private`"]

JerryI`LPM`Private`Version = 11


If[False,
  Echo["LPM >> Jeez, update your WL! Ok, we will find a way to fix it..."];

 
  (*Needs["PacletManager`"];
  pacletDirectoryLoad[path_String] := Module[{archive},
    archive = CreateArchive[path, FileNameJoin[{ParentDirectory[path], StringTake[path, -7]<>".zip"}], OverwriteTarget->True, CreateIntermediateDirectories -> False];
    archive = RenameFile[archive, FileNameJoin[{DirectoryName[archive], FileNameTake[archive]<>".paclet"}], OverwriteTarget->True];
    Echo["LPM >> installing fake paclet "<>archive];
    PacletInstall[archive, ForceVersionInstall -> True];
  ];*)
  
  pacletDirectoryLoad[directory_String] := 
  Module[{pacletInfo, extensions}, 
  	pacletInfo = First @ Get[FileNameJoin[{directory, "PacletInfo.wl"}]]; 
  	extensions = Association @ Rest @ FirstCase[pacletInfo["Extensions"], {"Kernel", __}]; 
  	With[{
  		root = extensions["Root"], 
  		context = extensions["Context"]
  	}, 
  		Unprotect[String];
  		Map[
  			Apply[Function[{c, f}, 
  				String /: Needs[c] := Get[FileNameJoin[{directory, root, f}]]; 
  				String /: Get[c] := Get[FileNameJoin[{directory, root, f}]]; 
  			]] @ #&
  		] @ context;
  		Protect[String];
  	]
  ];
,
  pacletDirectoryLoad = PacletDirectoryLoad
];

PacletRepositories[list_List, OptionsPattern[]] := Module[{projectDir, info, repos, cache, updated, removed, new, current, updatable},

    repos = (#-><|"key"->#|>)&/@list // Association;

    If[OptionValue["Directory"]//StringQ,
      projectDir = OptionValue["Directory"];
      If[!StringQ[projectDir], Echo["LPM >> Sorry. wrong folder!"]; Abort[]];
    ,
      projectDir = NotebookDirectory[];
      If[!StringQ[projectDir], projectDir = DirectoryName[$InputFileName]];
      If[!StringQ[projectDir], Echo["LPM >> Sorry. cannot work without project directory. Save your notebook / script first"]; Abort[]];    
    ];

    Echo["LPM >> project directory >> "<>projectDir];
    Echo["LPM >> fetching paclet infos..."];

    If[OptionValue["Passive"], 
      Echo["LPM >> PASSIVE MODE"];
      Map[pacletDirectoryLoad] @  Map[DirectoryName] @  FileNames["PacletInfo.wl", {#}, {2}]& @ FileNameJoin[{projectDir, "wl_packages"}];
      Return[Null, Module];
    ];

    If[!(NumericQ[PingTime["github.com"][[1]]] // TrueQ),
      Echo["LPM >> PASSIVE MODE. Github is not available"];
      Map[pacletDirectoryLoad] @  Map[DirectoryName] @  FileNames["PacletInfo.wl", {#}, {2}]& @ FileNameJoin[{projectDir, "wl_packages"}];
      Return[Null, Module];  
    ];

    repos = If[!AssociationQ[#], Missing[], #] &/@ FetchInfo /@ repos;

    repos = repos // DeleteMissing;

    Echo["LPM >> checking cached"];
    cache = CacheLoad[projectDir];

    If[FailureQ[PingTime["github.com"]],
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

    If[MissingQ[cache], 
      repos = InstallPaclet[projectDir] /@ repos;
    ,
      removed =  (#->cache[#])&/@ Complement[Keys[cache], Keys[repos]] // Association;
      current    =  (#->cache[#])&/@ Intersection[Keys[repos], Keys[cache]] // Association;
      new = (#->repos[#])&/@ Complement[Keys[repos], Keys[cache]] // Association;

      Echo[StringTemplate["LPM >> will be REMOVED: ``"][Length[removed]]];
      Echo[StringTemplate["LPM >> will be INSTALLED: ``"][Length[new]]];
     
      RemovePaclet[projectDir] /@ removed;
      new = InstallPaclet[projectDir] /@ new;

      updatable = Select[current, CheckUpdates];
      updated   = ((#->repos[#])&/@ Keys[updatable]) // Association;
 
      Echo[StringTemplate["LPM >> will be UPDATED: ``"][Length[updatable]]];

      repos = Join[current, InstallPaclet[projectDir] /@ updated, new];
    ];

    CacheStore[projectDir, repos];

    Map[pacletDirectoryLoad] @  Map[DirectoryName] @  FileNames["PacletInfo.wl", {#}, {2}]& @ FileNameJoin[{projectDir, "wl_packages"}];
]

Options[PacletRepositories] = {"Directory"->None, "Passive"->False}

CacheStore[dir_String, repos_Association] := Export[FileNameJoin[{dir, "wl_packages_lock.wl"}], repos]
CacheLoad[dir_String] := If[!FileExistsQ[FileNameJoin[{dir, "wl_packages_lock.wl"}]], Missing[], Import[FileNameJoin[{dir, "wl_packages_lock.wl"}]]];

CheckUpdates[a_Association] := Module[{result},
  CheckUpdates[a, a["key"][[1]]]
]

convertVersion[str_String] := ToExpression[StringReplace[str, "." -> ""]]

CheckUpdates[a_Association, Github] := Module[{new, package, now},
  package = FetchInfo[a, Github];
  If[!AssociationQ[package], Echo["LPM >> cannot check the github! skipping..."]; Return[False, Module]];
  new = package["Version"] // convertVersion;
  now = a["Version"] //convertVersion;

  Echo[StringTemplate["LPM >> installed `` remote ``"][now, new]];
  now < new
]

FetchInfo[a_Association] := Module[{result},
  FetchInfo[a, a["key"][[1]]]
]

FetchInfo[a_Association, Github] :=
Module[{new, url = a["key"][[2]], data},
    
    new = StringCases[url, RegularExpression[".com\\/(.*).git"]->"$1"]//First // Quiet;
    If[!StringQ[new], new = StringCases[url, RegularExpression[".com\\/(.*)"]->"$1"]//First];
    Echo["LPM >> fetching info by "<>new<>" on a Github..."];
    data = Check[Get["https://raw.githubusercontent.com/"<>new<>"/master/PacletInfo.wl"], $Failed];
    If[FailureQ[data],
      Echo["LPM >> ERROR cannot get "<>new<>"!"];
      Echo["LPM >> Abortting"];
      Abort[];
    ];
    Join[a, data//First, <|"git-url"->new|>]
]

InstallPaclet[dir_String][a_Association] := InstallPaclet[dir][a, a["key"][[1]]]

InstallPaclet[dir_String][a_Association, Github] := Module[{dirName, pacletPath},
    dirName = FileNameJoin[{dir, "wl_packages"}];
    If[!FileExistsQ[dirName], CreateDirectory[dirName]];


    If[MissingQ[a["git-url"]], Echo["LPM >> ERROR!!! not git-url was found"]; Abort[]];

    dirName = FileNameJoin[{dirName, StringReplace[a["Name"], "/"->"_"]}];

    If[FileExistsQ[dirName],
        Echo["LPM >> package folder "<>dirName<>" is already exists!"];
        Echo["LPM >> purging..."];
        DeleteDirectory[dirName, DeleteContents -> True];
    ];

    Echo["LPM >> fetching a zip archive from the master branch..."];    
    URLDownload["https://github.com/"<>a["git-url"]<>"/zipball/master", FileNameJoin[{dir, "___temp.zip"}]];
    
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



RemovePaclet[dir_String][a_Association] := RemovePaclet[dir][a, a["key"][[1]]]

RemovePaclet[dir_String][a_Association, Github] := Module[{dirName, pacletPath},
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