#!/usr/bin/env wolframscript

PacletSiteUpdate/@ PacletSites[]

$HistoryLength = 0
PacletDirectoryLoad[Directory[]]

Get["JerryI`WolframJSFrontend`"]
Get/@{
  "JerryI`WolframJSFrontend`Cells`", 
  "JerryI`WolframJSFrontend`Kernel`",
  "JerryI`WolframJSFrontend`Notebook`", 
  "JerryI`WolframJSFrontend`Utils`",
  "JerryI`WolframJSFrontend`Dev`", 
  "JerryI`WolframJSFrontend`Packages`"
};

$ContextAliases["jsf`"] = "JerryI`WolframJSFrontend`";

WLJSPSetRootFolder[jsf`root];

JerryI`WolframJSFrontend`$PublicDirectory = {jsf`public, FileNameJoin[{jsf`root, "Packages"}], FileNameJoin[{jsf`root, "Assets"}], Directory[]}

(* assign the handler for ExtendDefiniton command from the kernel to Notebook API *)
JerryI`WolframJSFrontend`ExtendDefinitions = NotebookExtendDefinitions;

(* plugins *)
LoadPluginsConfiguration;
CheckUpdates;

Includes["jsmodule"];
Includes["js"];
Includes["wlkernel"];
Includes["wlkernelstartup"];
Includes["wl"];
Includes["styles"];
Includes["autocomplete"];

IncludesDeliver[m_] := (StringCases[#[[2]]["url"], {RegularExpression["github\\.com/([^/]*)/([^/]*)"]-> (StringTemplate["https://cdn.jsdelivr.net/gh/``/``@master/``"]["$1","$2",StringRiffle[Drop[StringSplit[#[[1]], "/"],1], "/"] ])}]) &/@ Includes[m, "repository"] // Flatten;

Print["getting modules..."];

Get[FileNameJoin[{jsf`root, "Packages",  #}]] &/@ Includes["wl"];

Print["order"];

Print /@ PackagesOrder;

RandomWord[];

SetUpCron := (
  (* ping-pong with frontend *)
  SessionSubmit[ScheduledTask[WebSocketSend[broadcast, Global`Pong[360.0 Now[[1, -1]] / 60.0 //Round]], Quantity[3, "Seconds"]]];
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
  (* add the path to the server PATH variable for loading pictures from the vault 
  jsf`server["path"] = Join[Take[jsf`server["path"], Length[jsf`server["path"]]-1], {If[DirectoryQ[path], path, DirectoryName[path] ] }];*)

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

(* no cache, we are developers *)
If[TrueQ[devmode], WSPCache["Off"]];

jsf`jtp   =  JTPServer["host" -> ip, "port" -> 8092, "nohup"->True] // JTPServerStart;

tcp = TCPServer[];
tcp["CompleteHandler", "HTTP"] = HTTPPacketQ -> HTTPPacketLength;
tcp["MessageHandler", "HTTP"]  = HTTPPacketQ -> http;

http = HTTPHandler[];

http["MessageHandler", "Index"] = AssocMatchQ[<|"Path" -> "/"|>] -> (HypertextProcess[#, "index.wsp", "Base":>JerryI`WolframJSFrontend`$PublicDirectory]&)
http["MessageHandler", "WSP"] = GetFileRequestQ[{"wsp"}] -> (HypertextProcess[#, "Base":>JerryI`WolframJSFrontend`$PublicDirectory]&)

http["MessageHandler", "File"]  = GetFileRequestQ[{"wl", "html", "css", "js", "png", "jpg", "svg"}] -> (
  ImportFile[#, "Base":>JerryI`WolframJSFrontend`$PublicDirectory] &
)

http["MessageHandler", "Post"] = GetPOSTRequestQ[{"wsp"}] -> Composition[(HypertextProcess[#, "Base":>JerryI`WolframJSFrontend`$PublicDirectory]&), ProcessMultipart]

(* ::End:: *)

SocketListen[ip<>":"<>port, tcp@#&]

Print["Staring WS/HTTP server..."];

wcp = TCPServer[]
wcp["CompleteHandler", "WebSocket"] = WebSocketPacketQ -> WebSocketPacketLength
wcp["MessageHandler", "WebSocket"]  = WebSocketPacketQ -> ws

ws = WebSocketHandler[]

ws["MessageHandler", "Evaluate"]  = Function[True] -> evaluate

evaluate[cl_SocketObject, data_ByteArray] := Block[{Global`client = cl},
    ToExpression[data//ByteArrayToString];
]

SocketListen[ip<>":"<>ToString[ToExpression@port + 1], wcp@#&]

JerryI`WolframJSFrontend`WSKernelAddr  = ip

SetOptions[WSPEngine, "Cache"->True];

broadcast = WebSocketChannel[];
broadcast@"Serializer" = (ExportByteArray[#, "ExpressionJSON"]&);


(*NotificationMethodRegister;*)
SetUpCron;

(* dev mode on *)
If[TrueQ[devmode], LoadBuildFile["config.build.wl"] ];

console["log", "http://``:`` is used for WebSockets", ip, 8010];
console["log", "Open http://``:`` in your browser", ip, port];


If[TrueQ[autostart], LocalKernel["Start"][Function[x, Print["Started"];]]];

Print[JerryI`WolframJSFrontend`Notebook`Processors ];

While[True, LoopRun; Pause[0.3]];
