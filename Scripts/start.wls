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
<<JerryI`Notebook`FrontendObject`;

<<JerryI`Notebook`Kernel`
<<JerryI`Notebook`LocalKernel`
<<JerryI`Notebook`MasterKernel`
<<JerryI`Misc`Async`
<<JerryI`Notebook`Transactions`

(* event system & WLJS transport *)
<<JerryI`Misc`Events`
<<JerryI`Misc`WLJS`Transport`

<<KirillBelov`CSockets`EventsExtension`

(* WLX template engine *)
<<JerryI`WLX`
<<JerryI`WLX`Importer`
<<JerryI`WLX`WLJS`

(* WebUI Toolkit *)
<<JerryI`WLX`WebUI`

LoadPluginsConfiguration["Root" -> Directory[]];
LocalKernel`LTPServerStart[];

RandomWord[];

Includes["jsmodule"];
Includes["js"];
Includes["frontend"];

(* load stuff into frontend *)
Echo["Loading packages: FRONTEND"];
Check[
  Get[FileNameJoin[{Directory[], "Packages",  UniversalPathConverter[#]}]] &/@ Includes["frontend"]
, 
  Echo["Failed to load some of the packages (see logs)"];
  Exit[0]
];  

JerryI`WLX`Importer`Private`CacheControl["Hour"];

(* Entrypoint of an app *)
App := ImportComponent["Frontend/App.wlx"];


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
App[Null];

StringTemplate["Open http://``:`` in your browser"][$Env["host"], $Env["http"]] // Print;

While[True, Pause[0.5]];
