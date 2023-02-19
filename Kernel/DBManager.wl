BeginPackage["JerryI`WolframJSFrontend`DBManager`", {"JerryI`WolframJSFrontend`Notifications`", "JerryI`WolframJSFrontend`Utils`"}]; 

DBLoad::usage = "DBLoad[] loads the Notebooks from the last backup"

Begin["`Private`"]; 

$NotifyName = $InputFileName;

$DBFolder = FileNameJoin[{JerryI`WolframJSFrontend`root, "db"}];

DBLoad := Module[{dbbases},
  dbbases = (First@StringCases[#, RegularExpression["((.*-)(\\d*))"] :> <|"filename" -> "$1", "ver" -> ToExpression["$3"]|>] & 
    /@ Select[FileNames["*", $DBFolder], Length[StringCases[#, "default-"]] > 0 &]);

  If[Length@dbbases == 0, 
    console["log", "no db files was found. Abort..."]; 
    Exit[-1];
  ];

  dbbases = SortBy[dbbases, -#["ver"] &];

  While[TrueQ[FileExistsQ[(First@dbbases)["filename"] <> ".lock"]],
    DeleteFile[(First@dbbases)["filename"] <> ".lock"];
    console["log", "db `` crashed. skipping...", (First@dbbases)["filename"] ];
    dbbases = Drop[dbbases, 1];
  ];

  dbbases = First@dbbases;
  console["log", "openning ``", dbbases ];

  Get/@FileNames["*.mx", dbbases["filename"]];
];

(*storage*)

DBBack777 := Module[{trash, name = FileNameJoin[{$DBFolder, "default-"<>ToString[dbbases["ver"]+1]}]},
    settings["backup date"] = Now;

    console["log", "backing up..."];
    Put[FileNameJoin[{$DBFolder, name<>".lock"}]];

    While[CreateDirectory[name] === $Failed,
      console["log", "looks like it already exists.. purging"];
      DeleteDirectory[name, DeleteContents->True];
      Pause[1];
    ];

    Do[ With[{j = i /. {Hold :> Unevaluated}}, DumpSave[name <> "/" <> ToString@Extract[i, 1, HoldForm] <> ".mx", j]; console["log", ">> dump ``", name <> ToString@Extract[i, 1, HoldForm] <> ".mx"] ], {i, Hold /@ Unevaluated[{ 
        settings, 
        notebooks, 
        temp, 
        CellObj
    }]}];

    console["log", "...done!"];

    DeleteFile[FileNameJoin[{$DBFolder, name<>".lock"}]];
    dbbases["ver"] += 1;
    dbbases["filename"] = name;

    If[Length@FileNames["*", "db"] > 100, 
        console["log", "autoclean"];
        trash = First@StringCases[#, 
            RegularExpression["((.*-)(\\d*))"] :> <|"filename" -> "$1", 
                "ver" -> ToExpression["$3"]|>] & /@ FileNames["*", "db"];

        trash = SortBy[trash, #["ver"] &];
        trash = Take[trash, (Length@FileNames["*", "db"] - 100)];
        DeleteDirectory[#["filename"], DeleteContents->True]&/@trash;
    ];

    PushNotification[$NotifyName, "A system backup was created"];
];

End[];

EndPackage[];
