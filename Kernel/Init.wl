(* ::Package:: *)

(* default paths *)
JerryI`WolframJSFrontend`root           = ParentDirectory[DirectoryName[$InputFileName // AbsoluteFileName]]
Print[JerryI`WolframJSFrontend`root ];
JerryI`WolframJSFrontend`public         = FileNameJoin[{JerryI`WolframJSFrontend`root, "public"}]
JerryI`WolframJSFrontend`defaultvault   = If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], FileNameJoin[{JerryI`WolframJSFrontend`root, "Examples"}]]

JerryI`WolframJSFrontend`$PublicDirectory = Directory[]

JerryI`WolframJSFrontend`WSKernelAddr = "127.0.0.1"

Once[If[PacletFind["JerryI/LPM"] === {}, PacletInstall["JerryI/LPM"]]]; 
<<JerryI`LPM`

PacletRepositories[{
  Github -> "https://github.com/JerryI/CSocketListener",
  Github -> "https://github.com/KirillBelovTest/Objects",
  Github -> "https://github.com/KirillBelovTest/Internal",
  Github -> "https://github.com/KirillBelovTest/TCPServer",
  Github -> "https://github.com/KirillBelovTest/HTTPHandler",
  Github -> "https://github.com/JerryI/WebSocketHandler",
  Github -> "https://github.com/JerryI/wl-wsp"
}, "Directory"->JerryI`WolframJSFrontend`root]

<<KirillBelov`Objects`;
<<KirillBelov`Internal`;
<<KirillBelov`TCPServer`

<<KirillBelov`HTTPHandler`
<<KirillBelov`HTTPHandler`Extensions`
<<KirillBelov`WebSocketHandler`

<<JerryI`WSP`
<<JerryI`WSP`PageModule`

Get["https://raw.githubusercontent.com/JerryI/wl-misc/main/Kernel/Events.wl"]

Get[FileNameJoin[{JerryI`WolframJSFrontend`root, "Services","JTP", "JTP.wl"}]]
