#!/usr/bin/env wolframscript

ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

PacletDirectoryLoad[FileNameJoin[{Directory[], "wl_packages"}]];

<<KirillBelov`CSockets`
<<KirillBelov`Objects`
<<KirillBelov`Internal`
<<KirillBelov`TCPServer`

<<KirillBelov`HTTPHandler`
<<KirillBelov`HTTPHandler`Extensions`
<<KirillBelov`WebSocketHandler`

<<JerryI`Notebook`Packages`
<<JerryI`Notebook`Utils`

<<JerryI`Notebook`;
<<JerryI`Notebook`Evaluator`;

<<JerryI`WLX`
<<JerryI`WLX`Importer`

App := ImportComponent["Frontend/App.wlx"];

$ExposedDirectories = {FileNameJoin[{Directory[], "Packages"}], FileNameJoin[{Directory[], "Assets"}], Directory[], "/", ""}

$Env = <|
  "host" -> "127.0.0.1",
  "http" -> 20560,
  "ws"   -> 20561,
  "jtp"  -> 20562,
  "ws2"  -> 20563
|>;

$Server = <||>;

Print["Staring HTTP server..."];

tcp = TCPServer[];
tcp["CompleteHandler", "HTTP"] = HTTPPacketQ -> HTTPPacketLength;
tcp["MessageHandler", "HTTP"]  = HTTPPacketQ -> http;

http = HTTPHandler[];

(* serve static *)
http["MessageHandler", "File"]  = GetFileRequestQ[{"wl", "wln", "html", "css", "js", "png", "jpg", "svg", "pdf", "gif", "dmg"}] -> (
  ImportFile[#, "Base":>$PublicDirectory] &
)

$Server["HTTPHandler"] = http;

(* our app *)
App[];

(* ::End:: *)
SocketListen[CSocketOpen[$Env["host"], $Env["http"]], tcp@#&]

StringTemplate["Open http://``:`` in your browser"][$Env["host"], $Env["http"]] // Print;

While[True, Pause[0.5]];
