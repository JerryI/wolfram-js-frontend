#!/usr/bin/env wolframscript

ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

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

(* LocalPackage Manager *)
Get[FileNameJoin[{Directory[], "Services", "LPM.wl"}] ]

LoadPluginsConfiguration["Root" -> Directory[]];
LocalKernel`LTPServerStart[];

RandomWord[];

Includes["jsmodule"];
Includes["js"];
Includes["frontend"];

EventHandler[AppExtensions`AppEvents // EventClone, {
 any_ :> (Echo[StringTemplate["App Event ``: ``"][any, #]]&)
}];

(* load stuff into frontend *)
Echo["Loading packages: FRONTEND"];

  If[FailureQ[Get[FileNameJoin[{Directory[], "Packages",  UniversalPathConverter[#]}] ] ],
    Echo["Failed to load some of the packages (see logs)"];
    Exit[0]
  ] &/@ Includes["frontend"]; 

JerryI`WLX`Importer`Private`CacheControl["Hour"];

(* Entrypoint of an app *)
App      := ImportComponent["Frontend/App.wlx"];
AutoTest := ImportComponent["Frontend/Test.wlx"];

(* Global variables *)

$ExposedDirectories = {FileNameJoin[{Directory[], "Packages"}], FileNameJoin[{Directory[], "Assets"}], Directory[], "/", ""}

$Env = <|
  "host" -> "127.0.0.1",
  "http" -> 20560,
  "ws"   -> 20559,
  "jtp"  -> 20562,
  "ws2"  -> 20563
|>;

$Server = <||>;
$DefaultSerializer = ExportByteArray[#, "ExpressionJSON"]&

Print["Staring HTTP server..."];

tcp = TCPServer[];
tcp["CompleteHandler", "HTTP"] = HTTPPacketQ -> HTTPPacketLength;
tcp["MessageHandler", "HTTP"]  = HTTPPacketQ -> http;

http = HTTPHandler[];
$Server["HTTPHandler"] = http;

ElectronQ[request_] := (KeyExistsQ[request["Headers"], "Electron"]);

(* serve static *)
http["MessageHandler", "File"]  = GetFileRequestQ[{"wl", "html", "woff", "css", "js", "png", "jpg", "svg", "pdf", "gif", "dmg"}] -> (
  ImportFile[#, "Base":>$ExposedDirectories] &
)

SocketListen[CSocketOpen[$Env["host"], $Env["http"]], tcp@#&]

Print["Staring WS/HTTP server..."];

wcp = TCPServer[]
wcp["CompleteHandler", "WebSocket"] = WebSocketPacketQ -> WebSocketPacketLength
wcp["MessageHandler", "WebSocket"]  = WebSocketPacketQ -> ws

ws = WebSocketHandler[]
$Server["WebSocketHandler"] = ws;

(* configure the handler for WLJS communications *)
ws["MessageHandler", "Evaluate"]  = Function[True] -> WLJSTransportHandler

(* symbols tracking 
WLJSTransportHandler["AddTracking"] = Function[{symbol, name, cli, callback},
    Print["Add tracking... for "<>name];
    Experimental`ValueFunction[Unevaluated[symbol]] = Function[{y,x}, callback[cli, x]];
, HoldFirst]

WLJSTransportHandler["GetSymbol"] = Function[{expr, client, callback},
    Print["evaluating the desired symbol on the Kernel"];
    callback[expr // ReleaseHold];
]
*)

SocketListen[CSocketOpen[$Env["host"], $Env["ws"]], wcp@#&];

(* reseved keyword for WLJS interpreter *)
SetAttributes[Offload, HoldFirst];

(* start an app *)
AutoTest["HTTPHandler"->http];
App["HTTPHandler"->http, "AppEvent"->AppExtensions`AppEvents, "ExtensionTemplates"->AppExtensions`Templates];

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
      Exit[-1];
    ];
  ];
];

StringTemplate["Open http://``:`` in your browser"][$Env["host"], $Env["http"]] // Print;

Looper[];
