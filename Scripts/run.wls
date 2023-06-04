#!/usr/bin/env wolframscript

$HistoryLength = 0
PacletDirectoryLoad[Directory[]]
Get["JerryI`WolframJSFrontend`"]
Get/@{
  "JerryI`WolframJSFrontend`Cells`", 
  "JerryI`WolframJSFrontend`Kernel`",
  "JerryI`WolframJSFrontend`Notebook`", 
  "JerryI`WolframJSFrontend`Utils`",
  "JerryI`WolframJSFrontend`Dev`", 
  "JerryI`WolframJSFrontend`WSPDynamicsExtension`",

  "JerryI`WolframJSFrontend`Packages`"
  };

$ContextAliases["jsf`"] = "JerryI`WolframJSFrontend`";

(* assign the handler for ExtendDefiniton command from the kernel to Notebook API *)
JerryI`WolframJSFrontend`ExtendDefinitions = NotebookExtendDefinitions;

(* plugins *)
LoadPluginsConfiguration;
CheckUpdates;

Includes["jsmodule"];
Includes["js"];
Includes["wlkernel"];
Includes["wl"];
Includes["styles"];
Includes["autocomplete"];

Print["getting modules..."];

Get[FileNameJoin[{jsf`root, "Packages", #}]] &/@ Includes["wl"];

Print["order"];

Print /@ PackagesOrder;

RandomWord[];

SetUpCron := (
  (* ping-pong with frontend *)
  SessionSubmit[ScheduledTask[WebSocketBroadcast[jsf`server, Global`Pong[360.0 Now[[1, -1]] / 60.0 //Round]], Quantity[3, "Seconds"]]];
  (* stats *)
  SessionSubmit[ScheduledTask[console["log", "<*Now*>"], Quantity[20, "Minutes"]]]; 
);


port = "8090";
ip = "127.0.0.1";

If[MemberQ[$ScriptCommandLine, "port"],
  port = $ScriptCommandLine[[(Position[$ScriptCommandLine, "port"]//First//First) + 1]];
];

If[MemberQ[$ScriptCommandLine, "ip"],
  ip =  $ScriptCommandLine[[(Position[$ScriptCommandLine, "ip"]//First//First) + 1]]
];

If[MemberQ[$ScriptCommandLine, "dev"],
  devmode = True;
  Print[Red<>"Dev mode is activated"];
  Print[Reset];
];

If[MemberQ[$ScriptCommandLine, "auto"],
  autostart = True;
  Print[Green<>"Autostart mode is activated"];
  Print[Reset];
];

(* file type handlers for frontened UI *)
FileTypeHandler[path_, types_] := Module[{},
  (* add the path to the server PATH variable for loading pictures from the vault *)
  jsf`server["path"] = Join[Take[jsf`server["path"], Length[jsf`server["path"]]-1], {If[DirectoryQ[path], path, DirectoryName[path] ] }];

  (* handlers *)
  (Which@@Flatten[types/.{Rule[a_,b_]:>{path//a, b}}])[path]
]

(* default templates depending of the opened path *)
NotFound[path_] := <|"view" :> LoadPage["template/views/404.wsp"] |>;
FolderWindow[wpath_] := <|"view" :> LoadPage["template/views/folder.wsp", {path = wpath}] |>;

(* association file_path -> notebook id *)
NotebookQ[path_] := (StringTake[path, -2] === "wl");

LoadNotebook[path_] := Module[{},
  <|"view":> LoadPage["template/views/editor.wsp", {notebook = $AssoticatedPath[path]}] |>
];

ImageFileQ[path_] := MemberQ[{"png", "svg", "jpg", "jpeg", "gif"}, FileExtension[path]];
ImageViewer[path_] := <|"view" :> LoadPage["template/views/image.wsp", {url = path}]  |>;

(* supported type for the UI viewer *)
SupportedTypes = {
  DirectoryQ  ->  FolderWindow,
  NotebookQ   ->  LoadNotebook,
  ImageFileQ  ->  ImageViewer,
  (True&)     ->  NotFound
}

address = ip<>":"<>port;

(* no cache, we are developers *)
If[TrueQ[devmode], WSPCache["Off"]];

jsf`jtp   =  JTPServer["host" -> ip, "port" -> 8092, "nohup"->True] // JTPServerStart;

jsf`server = WEBServer["addr" -> address, "path" -> {jsf`public, FileNameJoin[{jsf`root, "Packages"}], FileNameJoin[{jsf`root, "Assets"}], "/", {"/"}}, "socket-close" -> True];
jsf`server = jsf`server // WEBServerStart;

(*NotificationMethodRegister;*)
SetUpCron;

(* dev mode on *)
If[TrueQ[devmode], LoadBuildFile["config.build.wl"] ];

console["log", "Open http://`` in your browser", jsf`server["addr"]];

If[TrueQ[autostart], LocalKernel["Start"][Function[x, Print["Started"];]]];

While[True, LoopRun; Pause[0.3]];