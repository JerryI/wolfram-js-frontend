BeginPackage["JerryI`WolframJSFrontend`Packages`", {"KirillBelov`HTTPHandler`Extensions`"}];

(* 
    ::Only for MASTER kernel::
    
    Packages manager
*)

LoadPluginsConfiguration::usage = "load the system"
CheckUpdates::usage = "check updates"
InstallPackage::usage = "install by url"

Packages::usage = "storage for packages"

PackagesOrder::usage = "order sorted by priority"

Includes::usage = "check for fields"

WLJSPSetRootFolder::usage = "set root folder"

Begin["`Private`"]; 

$RootFolder = Directory[]

WLJSPSetRootFolder[path_String] := $RootFolder = path;

$ConfigFile = FileNameJoin[{$RootFolder, ".packages"}];
$DefaultConfigFile = FileNameJoin[{$RootFolder, ".defaultpackages"}];
$PackagesPath = FileNameJoin[{$RootFolder, "Packages"}];

listAllPackages := FileNames["package.json", $PackagesPath, 2]

absolute2Relative[path_] := FileNameSplit[DirectoryName[path]][[-1]]
relative2Absolute[path_] := FileNameJoin[{$RootFolder, path}]

ImportJSON[url_String] := Module[{},
    Import[url, "RawJSON"]
]; 

getJSON[package_Association] := Module[{new, json},
    new = StringCases[package["repository", "url"], RegularExpression[".com\\/(.*).git"]->"$1"]//First // Quiet;
    If[!StringQ[new], new = StringCases[package["repository", "url"], RegularExpression[".com\\/(.*)"]->"$1"]//First];
    
    json = ImportJSON["https://raw.githubusercontent.com/"<>new<>"/master/package.json"];
    If[AssociationQ[json],
        json,
        $Failed
    ]
]

getJSON[url_String] := Module[{new, json},
    new = StringCases[url, RegularExpression[".com\\/(.*).git"]->"$1"]//First // Quiet;
    If[!StringQ[new], new = StringCases[url, RegularExpression[".com\\/(.*)"]->"$1"]//First];

    json = ImportJSON["https://raw.githubusercontent.com/"<>new<>"/master/package.json"];
    If[AssociationQ[json],
        json,
        $Failed
    ]
]

PackagesOrder = {};
Packages = <||>;

UpdateConfiguration := (
    (*Sort;*)
    PackagesOrder = SortBy[Keys[Packages], If[KeyExistsQ[Packages[#, "wljs-meta"], "priority"], Packages[#, "wljs-meta", "priority"], 1]&];
    Put[Packages, $ConfigFile];
)

UpdateInfo := (
    (* check the folders *)
    With[{json = ImportJSON[#]},
        Print[StringTemplate["checking the package ``..."][#]];
        If[KeyExistsQ[Packages, json["name"]],
            Print["* update meta-data from it"];
            Packages[json["name"]] = Join[Packages[json["name"]], json];
        ,
            Print[StringTemplate["+ new package `` found!"][json["name"]]];
            Packages[json["name"]] = json;
            Packages[json["name"], "enabled"] = True; 
            Packages[json["name"], "path"] = absolute2Relative[#]; 
        ]
    ]& /@ listAllPackages;
)

LoadPluginsConfiguration := (
    If[FileExistsQ[$ConfigFile], Packages = Get[$ConfigFile], Packages = Get[$DefaultConfigFile]];
    
    If[!FileExistsQ[$PackagesPath], CreateDirectory[$PackagesPath]];
    If[!FileExistsQ[$PackagesPath], Print["Failed to create directory"]; Exit[];];

    UpdateInfo;

    InstallMissing;  

    UpdateConfiguration;
)

InstallPackage[url_, cbk_:Null] := Module[{remote},
    remote = getJSON[url];
    If[remote === $Failed, cbk[False, "Can't load by the given url"]; Return[$Failed, Module]];

    If[KeyExistsQ[Packages, remote["name"]], cbk[False, "Already installed"]; Return[$Failed, Module]];
    Packages[remote["name"]] = remote;
    Packages[remote["name"]]["enabled"] = True; 

    InstallMissing;

    UpdateConfiguration;
    cbk[True, "Installed. Reboot is needed"];
]

InstallMissing := Module[{missing = False},
    Print["Checking missing packages..."];
    With[{},

        If[!KeyExistsQ[Packages[#], "path"],
            Print["# needs full installation. looks it was installed by the url"];
            Packages[#, "path"] = Packages[#]["name"];
        ];

        If[!FileExistsQ[relative2Absolute[FileNameJoin[{"Packages", Packages[#]["path"], "package.json"}]]],
            Print["# the package "<>Packages[#]["name"]<>" is missing"];
            downloadAndInstall[Packages[#]];
            missing = True;
        ];

    ] &/@ Keys[Packages];

    If[missing, UpdateInfo];
]

getVersion[assoc_Association] := ToExpression[StringReplace[assoc["version"], "." -> ""]];

CheckUpdates := Module[{json},
    Print["Checking updates..."];
    With[{},
        json = getJSON[Packages[#]];
        If[!AssociationQ[json], Print["!!! Failed to check updates for "<>Packages[#, "name"]],
            If[getVersion[json] > getVersion[Packages[#]],
                Print[StringTemplate["`` :: `` -> `` to be updated"][Packages[#, "name"], Packages[#, "version"], json["version"]]];
                downloadAndInstall[json];
                Packages[#] = Join[Packages[#], json];
            ,
                Print[StringTemplate["`` :: `` -- `` is up to date"][Packages[#, "name"], Packages[#, "version"], json["version"]]];
            ];
        ];
    ] &/@ Keys[Packages];
]

downloadAndInstall[package_Association] := Module[{},
    new = StringCases[package["repository", "url"], RegularExpression[".com\\/(.*).git"]->"$1"]//First // Quiet;
    If[!StringQ[new], new = StringCases[package["repository", "url"], RegularExpression[".com\\/(.*)"]->"$1"]//First;];

    If[!StringQ[new], Print["failed to find repo in the package.json!"]; Return[$Failed, Module]];

    If[FileExistsQ[relative2Absolute[FileNameJoin[{"Packages", package["path"]}]]],
        Print["purging an old dir"];
        DeleteDirectory[relative2Absolute[FileNameJoin[{"Packages", package["path"]}]], DeleteContents -> True];
    ];

    Print["fetching the data..."];    
    Print["url: "<>"https://github.com/"<>new<>"/zipball/master"];
    URLDownload["https://github.com/"<>new<>"/zipball/master", FileNameJoin[{$RootFolder, "___temp.zip"}]];
    
    Print["extracting..."];
    ExtractArchive[FileNameJoin[{$RootFolder, "___temp.zip"}], FileNameJoin[{$RootFolder, "___temp"}]];
    DeleteFile[FileNameJoin[{$RootFolder, "___temp.zip"}]];
    
    Print["fetching the package.json"];
    path = FileNames["package.json", FileNameJoin[{$RootFolder, "___temp"}], 2] // First;
    If[!FileExistsQ[path], Print["Failed to fetch by "<>ToString[path]]; Return[$Failed, Module]];
    path = DirectoryName[path];

    Print[StringTemplate["path to the packages json is ``"][path]];

    Print[StringTemplate["copying... from `` to ``"][path, relative2Absolute[FileNameJoin[{"Packages", package["path"]}]]]];
    CopyDirectory[path, relative2Absolute[FileNameJoin[{"Packages", package["path"]}]]];
    DeleteDirectory[FileNameJoin[{$RootFolder, "___temp"}], DeleteContents -> True];
    Print["finished!"];
];


Includes[param_] := Includes[param] = 
Table[ 
    Table[ 
      FileNameJoin[{Packages[i, "path"], j // URLPathToFileName}]
    , {j, {Packages[i, "wljs-meta", param]}//Flatten}]
, {i, Select[PackagesOrder, (Packages[#, "enabled"] && KeyExistsQ[Packages[#, "wljs-meta"], param])&]}] // Flatten;

Includes[param_, param2_] := Includes[param, param2] = 
Partition[Table[ 
    Table[ 
      {FileNameJoin[{Packages[i, "path"], j // URLPathToFileName}], Packages[i, param2]}
    , {j, {Packages[i, "wljs-meta", param]}//Flatten}]
, {i, Select[PackagesOrder, (Packages[#, "enabled"] && KeyExistsQ[Packages[#, "wljs-meta"], param])&]}] // Flatten, 2];


End[];

EndPackage[];