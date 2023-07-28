(* ::Package:: *)

(* default paths *)
JerryI`WolframJSFrontend`root           = ParentDirectory[DirectoryName[$InputFileName // AbsoluteFileName]]
Print[JerryI`WolframJSFrontend`root ];
JerryI`WolframJSFrontend`public         = FileNameJoin[{JerryI`WolframJSFrontend`root, "public"}]
JerryI`WolframJSFrontend`defaultvault   = If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], FileNameJoin[{JerryI`WolframJSFrontend`root, "Examples"}]]

JerryI`WolframJSFrontend`$PublicDirectory = Directory[]

JerryI`WolframJSFrontend`WSKernelAddr = "127.0.0.1"

PacletInstall["KirillBelov/Objects"]
<<KirillBelov`Objects`;

Get[FileNameJoin[{JerryI`WolframJSFrontend`root, "Services","CSocketListener", "Kernel", "CSocketListener.wl"}]]

PacletInstall["KirillBelov/TCPServer"]
<<KirillBelov`TCPServer`

PacletInstall["KirillBelov/Internal"]
<<KirillBelov`Internal`;

(* did not update yet *)
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/WSP.wl"]

PacletInstall["KirillBelov/HTTPHandler"]
<<KirillBelov`HTTPHandler`
<<KirillBelov`HTTPHandler`Extensions`

PacletInstall["KirillBelov/WebSocketHandler"]
<<KirillBelov`WebSocketHandler`


Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/PageModule.wl"]
Get["https://raw.githubusercontent.com/JerryI/wl-misc/main/Kernel/Events.wl"]

Get[FileNameJoin[{JerryI`WolframJSFrontend`root, "Services","JTP", "JTP.wl"}]]
