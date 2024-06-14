#!/usr/bin/env wolframscript

PacletDirectoryUnload /@ PacletDirectoryLoad[];

ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

Uncompress["1:eJx1T8tuwjAQDBT1wo0/6Ac0vveKKAoNCJoDZ5NugsXGtrwbBf6edawKLlzG+5rxzMfJ/TZvWZbRVKBomkms5wLfBmF1NcR0qN6lL/fbfMC0j4Q18
PM80mkmcDR8TlexK0Ug7SKnAh5f9F0aRoGi8y5wVUp5Zvb0pVTQQ96KTn/qCULtLIPlvHad2kAIt0IN+Imu1uh1fdEtkOq0seoHggVUydForuJgbJsCLgSWTj7r7d/q6gMQGWfT
Lt7KLPp4ZPq3+qz0Iv6Yddcj3gGoDVPG"];

PacletRepositories[{
  Github -> "https://github.com/KirillBelovTest/Objects" -> "master",
  Github -> "https://github.com/JerryI/Internal" -> "master",
  Github -> "https://github.com/JerryI/TCPServer" -> "master",
  Github -> "https://github.com/JerryI/HTTPHandler" -> "master",
  Github -> "https://github.com/JerryI/WebSocketHandler" -> "master",
  Github -> "https://github.com/JerryI/CSocketListener" -> "dev2024",
  Github -> "https://github.com/JerryI/wl-wlx" -> "master",
  Github -> "https://github.com/JerryI/wl-misc" -> "dev",
  Github -> "https://github.com/JerryI/wl-wljs-packages" -> "master"
}, "Directory" -> Directory[] ]

(* web-server *)
<<KirillBelov`CSockets`
<<KirillBelov`Objects`
<<KirillBelov`Internal`
<<KirillBelov`TCPServer`

<<KirillBelov`HTTPHandler`
<<KirillBelov`HTTPHandler`Extensions`
<<KirillBelov`WebSocketHandler`
<<KirillBelov`LTP`

(* notebook abstraction *)
<<JerryI`Notebook`Packages`
<<JerryI`Notebook`Utils`

<<JerryI`Notebook`;
<<JerryI`Notebook`Evaluator`;
<<JerryI`Notebook`Windows`;

<<JerryI`Notebook`AppExtensions`;

(* WLJS transport *)
<<JerryI`Misc`WLJS`Transport`

(* event system  *)
<<JerryI`Misc`Events`
<<JerryI`Misc`Events`Promise`

<<JerryI`Misc`Async`

<<JerryI`Notebook`Kernel`
<<JerryI`Notebook`LocalKernel`
<<JerryI`Notebook`MasterKernel`
<<JerryI`Notebook`Transactions`


<<KirillBelov`CSockets`EventsExtension`

(* WLX template engine *)
<<JerryI`WLX`
<<JerryI`WLX`Importer`
<<JerryI`WLX`WLJS`

(* WebUI Toolkit *)
<<JerryI`WLX`WebUI`

<<CodeParser`

(* WLJS Package manager *)
<<JerryI`WLJSPM`

WLJS`PM`Repositories[{
  Github -> "https://github.com/JerryI/wljs-editor" -> "dev",
  Github -> "https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine" -> "dev",
  Github -> "https://github.com/JerryI/wljs-sharedlib-d3" -> "master",
  Github -> "https://github.com/JerryI/wljs-sharedlib-mk" -> "master",
  Github -> "https://github.com/JerryI/wljs-graphics-d3" -> "dev",
  Github -> "https://github.com/JerryI/wljs-html-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-inputs" -> "dev",
  Github -> "https://github.com/JerryI/wljs-interpreter" -> "dev",
  Github -> "https://github.com/JerryI/wljs-js-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-markdown-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-magic-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-plotly" -> "dev",
  Github -> "https://github.com/JerryI/wljs-cells" -> "dev",
  Github -> "https://github.com/JerryI/wljs-revealjs" -> "dev",
  Github -> "https://github.com/JerryI/wljs-wlx-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-mermaid-support" -> "dev",
  Github -> "https://github.com/JerryI/wljs-snippets" -> "dev",
  Github -> "https://github.com/JerryI/wljs-alt-cell-controls" -> "dev",
  Github -> "https://github.com/JerryI/wljs-print-redirect-fix" -> "dev",
  Github -> "https://github.com/JerryI/wljs-export-html" -> "master",
  Github -> "https://github.com/JerryI/wljs-manipulate" -> "master",
  Github -> "https://github.com/JerryI/wljs-sound" -> "master"
}, "Directory" -> Directory[] ]

LocalKernel`LTPServerStart[];

RandomWord[];

WLJS`PM`Includes["js"];
WLJS`PM`Includes["frontend"];

EventHandler[AppExtensions`AppEvents // EventClone, {
 any_ :> (Echo[StringTemplate["App Event ``: ``"][any, #]]&)
}];

(* start a bit earlier, so that extensions can hook on*)
$Server = <||>;
$DefaultSerializer = ExportByteArray[#, "ExpressionJSON"]&

Print["Staring HTTP server..."];

tcp = TCPServer[];
tcp["CompleteHandler", "HTTP"] = HTTPPacketQ -> HTTPPacketLength;
tcp["MessageHandler", "HTTP"]  = HTTPPacketQ -> http;

http = HTTPHandler[];
$Server["HTTPHandler"] = http;

AppExtensions`HTTPHandler = http;

System`$Env;

$Env = <|
  "host" -> "127.0.0.1",
  "http" -> 20560,
  "ws"   -> 20559,
  "jtp"  -> 20562,
  "ws2"  -> 20563,
  "docs" -> 20540
|>;

With[{argv = Rest @ $ScriptCommandLine // Quiet},
  Echo["Command line: "];
  Echo[argv];
  MapIndexed[Function[{key, pos},
    With[{},
      If[MemberQ[Keys[$Env], key] || True,
        With[{
          value = argv[[ pos[[1]] + 1 ]]
        },
          $Env = Join[$Env, <|key -> If[NumericQ[ $Env[key] ],
            ToExpression[value],
            value
          ]|>];
        ]
      ]
    ]
  ], argv]
];

(* load stuff into frontend *)
Echo["Loading packages: FRONTEND"];

  If[FailureQ[Get[FileNameJoin[{Directory[], "wljs_packages",  UniversalPathConverter[#]}] ] ],
    Echo["Failed to load some of the packages (see logs)"];
    Exit[0]
  ] &/@ WLJS`PM`Includes["frontend"]; 

JerryI`WLX`Importer`Private`CacheControl["Hour"];

(* Entrypoint of an app *)
App         := ImportComponent["Frontend/App.wlx"];
Window      := ImportComponent["Frontend/Window.wlx"];
Settings    := ImportComponent["Frontend/Settings.wlx"];
AutoTest    := ImportComponent["Frontend/Test.wlx"];
Downloader   = ImportComponent["Frontend/Downloader.wl"];

(* Global variables *)

$ExposedDirectories = {FileNameJoin[{Directory[], "wljs_packages"}], FileNameJoin[{Directory[], "Assets"}], Directory[], "/", ""}



EventHandler[AppExtensions`AppEvents // EventClone, {
 "Notebook:Close" -> Function[notebook,
  Print["Notebook was closed"];
  (*$ExposedDirectories = ReplacePart[$ExposedDirectories, FirstPosition[$ExposedDirectories, notebook["Path"] // DirectoryName ] -> Nothing];*)
 ],
 "Loader:NewNotebook" -> Function[notebook,
  $ExposedDirectories = Append[$ExposedDirectories, notebook["Path"] // DirectoryName ];
 ],
 "Loader:LoadNotebook" -> Function[notebook,
  Echo["Load notebook and adding it to the path! >>"];
  Echo[notebook["Path"] // DirectoryName];
  $ExposedDirectories = Append[$ExposedDirectories, notebook["Path"] // DirectoryName ];
 ]
}];




ElectronQ[request_] := (KeyExistsQ[request["Headers"], "Electron"]);

(* serve static *)
http["MessageHandler", "File"]  = GetFileRequestQ[{"wl", "jpeg", "wlx", "ttf",  "otf", "woff", "woff2", "css", "js", "png", "jpg", "svg", "pdf", "gif", "dat"}] -> (
  ImportFile[#, "Base":>$ExposedDirectories] &
)

SocketListen[CSocketOpen[$Env["host"], $Env["http"]], tcp@#&]

Print["Starting HTTP server for docs..."];

dcp = TCPServer[];
dcp["CompleteHandler", "HTTP"] = HTTPPacketQ -> HTTPPacketLength;
dcp["MessageHandler", "HTTP"]  = HTTPPacketQ -> dhttp;

dhttp = HTTPHandler[];
dhttp["MessageHandler", "Index"]  = AssocMatchQ[<|"Path" -> "/"|>] -> (ImportFile["index.html", "Base"->FileNameJoin[{Directory[], "Documentation"}] ] &)
dhttp["MessageHandler", "All"]  = AssocMatchQ[<|"Method" -> "GET"|>]  -> (
  ImportFile[If[StringPart[#["Path"], -3] === "." || StringPart[#["Path"], -4] === "." || StringPart[#["Path"], -5] === ".", #, Join[#, <|"Path" -> StringJoin[#["Path"], "/index.html"]|>] ], "Base"->{FileNameJoin[{Directory[], "Documentation"}], FileNameJoin[{Directory[], "wljs_packages"}]} ] &
)

SocketListen[CSocketOpen[$Env["host"], $Env["docs"]], dcp@#&]



Print["Staring WS/HTTP server..."];

wcp = TCPServer[]
wcp["CompleteHandler", "WebSocket"] = WebSocketPacketQ -> WebSocketPacketLength
wcp["MessageHandler", "WebSocket"]  = WebSocketPacketQ -> ws

ws = WebSocketHandler[]
$Server["WebSocketHandler"] = ws;

(* configure the handler for WLJS communications *)
ws["MessageHandler", "Evaluate"]  = Function[True] -> WLJSTransportHandler


SocketListen[CSocketOpen[$Env["host"], $Env["ws"] ], wcp@#&, "SocketEventsHandler"->CSocketsClosingHandler];

(* reseved keyword for WLJS interpreter *)
SetAttributes[Offload, HoldFirst];

(* start an app *)
AutoTest["HTTPHandler"->http];
Downloader["HTTPHandler"->http];
Settings["HTTPHandler"->http, "AppEvent"->AppExtensions`AppEvents, "ExtensionTemplates"->AppExtensions`Templates]
Window["HTTPHandler"->http, "AppEvent"->AppExtensions`AppEvents, "ExtensionTemplates"->AppExtensions`Templates];
App["HTTPHandler"->http, "AppEvent"->AppExtensions`AppEvents, "ExtensionTemplates"->AppExtensions`Templates, "ExtensionSidebarIcons"->AppExtensions`SidebarIcons, "Env"->$Env];

Echo["Autotest start!"];

(* autotest *)
With[{secret = CreateUUID[]},
  With[{
          result = URLFetch[StringTemplate["http://``:``/test?token=``"][$Env["host"], $Env["http"], URLEncode[ secret ] ] ]
      },

    If[result === ToString[ Hash[secret] ],
      Echo["Autotest passed!"];
    ,
      Echo["Autotest failed!"];
      Echo[result];
      If[!TrueQ[$Env["bypasstest"] ], Exit[-1] ];
    ];
  ];
];

SetTimeout[
  StringTemplate["Open http://``:`` in your browser"][$Env["host"], $Env["http"]] // Print;
, 15000
];

SetTimeout[
  StringTemplate["Open http://``:`` in your browser"][$Env["host"], $Env["http"]] // Print;
, 10000
];

SetTimeout[
  StringTemplate["Open http://``:`` in your browser"][$Env["host"], $Env["http"]] // Print;
, 5000
];

SetTimeout[
  StringTemplate["Open http://``:`` in your browser"][$Env["host"], $Env["http"]] // Print;
, 3000
];

SetTimeout[
  StringTemplate["Open http://``:`` in your browser"][$Env["host"], $Env["http"]] // Print;
, 1000
];

Looper[];
