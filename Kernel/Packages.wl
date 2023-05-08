BeginPackage["JerryI`WolframJSFrontend`Packages`"];

(* 
    ::Only for MASTER kernel::
    
    Packages manager
*)

LoadPluginsConfiguration::usage = "load the system"
CheckUpdates::usage = "check updates"
InstallPackage::usage = "install by url"

Packages::usage = "storage for packages"

Begin["`Private`"]; 

$ConfigFile = FileNameJoin[{JerryI`WolframJSFrontend`root, ".packages"}];
$PackagesPath = FileNameJoin[{JerryI`WolframJSFrontend`root, "Packages"}];

listAllPackages := FileNames["package.json", $PackagesPath, 2]

absolute2Relative[path_] := FileNameSplit[DirectoryName[path]][[-1]]
relative2Absolute[path_] := FileNameJoin[{JerryI`WolframJSFrontend`root, path}]

ImportJSON[url_String] := Module[{},
    Import[url, "RawJSON"]
]; 

getJSON[package_Association] := Module[{new, json},
    new = StringCases[package["repository", "url"], RegularExpression[".com\\/(.*).git"]->"$1"]//First;
    json = ImportJSON["https://raw.githubusercontent.com/"<>new<>"/master/package.json"];
    If[AssociationQ[json],
        json,
        $Failed
    ]
]

getJSON[url_String] := Module[{new, json},
    new = StringCases[url, RegularExpression[".com\\/(.*)"]->"$1"]//First;
    json = ImportJSON["https://raw.githubusercontent.com/"<>new<>"/master/package.json"];
    If[AssociationQ[json],
        json,
        $Failed
    ]
]

Packages = <||>;

UpdateConfiguration := (
    (*Sort;*)
    Put[Packages, $ConfigFile];
)

LoadPluginsConfiguration := (
    If[FileExistsQ[$ConfigFile], Packages = Get[$ConfigFile]];
    
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

InstallMissing := Module[{},
    Print["Checking missing packages..."];
    With[{},

        If[!KeyExistsQ[Packages[#], "path"],
            Print["# needs full installation. looks it was installed by the url"];
            Packages[#] = Packages[#]["name"];
        ];

        If[!FileExistsQ[relative2Absolute[FileNameJoin[{"Packages", Packages[#]["path"], "package.json"}]]],
            Print["# the package "<>Packages[#]["name"]<>" is missing"];
            downloadAndInstall[Packages[#]];
        ];

    ] &/@ Keys[Packages];
]

getVersion[assoc_Association] := ToExpression[StringReplace[assoc["version"], "." -> ""]];

CheckUpdates := Module[{json},
    Print["Checking updates..."];
    With[{},
        json = getJSON[Packages[#]];
        If[!AssociationQ[json], Print["!!! Failed to check updates for "<>Packages[#, "name"]],
            If[getVersion[json] > getVersion[Packages[#]],
                Print[StringTemplate["`` -> `` to be updated"][Packages[#, "version"], json["version"]]];
                downloadAndInstall[json];
                Packages[#] = Join[Packages[#], json];
            ,
                Print[StringTemplate["`` -- `` is up to date"][Packages[#, "version"], json["version"]]];
            ];
        ];
    ] &/@ Keys[Packages];
]

downloadAndInstall[package_Association] := Module[{},
    new = StringCases[package["repository", "url"], RegularExpression[".com\\/(.*).git"]->"$1"]//First;
    If[!StringQ[new], Print["failed to find repo in the package.json!"]; Return[$Failed, Module]];

    If[FileExistsQ[relative2Absolute[FileNameJoin[{"Packages", package["path"]}]]],
        Print["purging an old dir"];
        DeleteDirectory[relative2Absolute[FileNameJoin[{"Packages", package["path"]}]], DeleteContents -> True];
    ];

    Print["fetching the data..."];    
    URLDownload["https://github.com/"<>new<>"/zipball/master", FileNameJoin[{JerryI`WolframJSFrontend`root, "___temp.zip"}]];
    
    Print["extracting..."];
    ExtractArchive[FileNameJoin[{JerryI`WolframJSFrontend`root, "___temp.zip"}], FileNameJoin[{JerryI`WolframJSFrontend`root, "___temp"}]];
    DeleteFile[FileNameJoin[{JerryI`WolframJSFrontend`root, "___temp.zip"}]];
    
    Print["fetching the package.json"];
    path = FileNames["package.json", FileNameJoin[{JerryI`WolframJSFrontend`root, "___temp"}], 2] // First;
    If[!FileExistsQ[path], Print["Failed to fetch by "<>path]; Return[$Failed, Module]];
    path = DirectoryName[path];

    Print["copying..."];
    CopyDirectory[path, relative2Absolute[FileNameJoin[{"Packages", package["path"]}]]];
    DeleteDirectory[FileNameJoin[{JerryI`WolframJSFrontend`root, "___temp"}], DeleteContents -> True];
    Print["finished!"];
];


End[];

EndPackage[];