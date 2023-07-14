(* ::Package:: *)

(* default paths *)
JerryI`WolframJSFrontend`root           = ParentDirectory[DirectoryName[$InputFileName // AbsoluteFileName]]
Print[JerryI`WolframJSFrontend`root ];
JerryI`WolframJSFrontend`public         = FileNameJoin[{JerryI`WolframJSFrontend`root, "public"}]
JerryI`WolframJSFrontend`defaultvault   = If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], FileNameJoin[{JerryI`WolframJSFrontend`root, "Examples"}]]

JerryI`WolframJSFrontend`$PublicDirectory = Directory[]

Once[If[PacletFind["KirillBelov/Objects"] === {}, PacletInstall["https://github.com/KirillBelovTest/Objects/releases/download/v1.0.21/KirillBelov__Objects-1.0.21.paclet"]]]; 
<<KirillBelov`Objects`;

Get["https://raw.githubusercontent.com/KirillBelovTest/TCPServer/main/Kernel/TCPServer.wl"]

Once[If[PacletFind["KirillBelov/Internal"] === {}, PacletInstall["https://github.com/KirillBelovTest/Internal/releases/download/v1.0.5/KirillBelov__Internal-1.0.5.paclet"]]]; 
<<KirillBelov`Internal`;

Get["https://raw.githubusercontent.com/KirillBelovTest/TCPServer/main/Kernel/TCPServer.wl"]
Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/WSP.wl"]

Get["https://raw.githubusercontent.com/JerryI/HTTPHandler/main/Kernel/HTTPHandler.wl"]
Get["https://raw.githubusercontent.com/JerryI/HTTPHandler/main/Kernel/Extensions.wl"]
Get["https://raw.githubusercontent.com/JerryI/HTTPHandler/main/Kernel/WSPAdapter.wl"]


Once[If[PacletFind["KirillBelov/WebSocketHandler"] === {}, PacletInstall["https://github.com/KirillBelovTest/WebSocketHandler/releases/download/v1.0.10/KirillBelov__WebSocketHandler-1.0.10.paclet"]]]; 
<<KirillBelov`WebSocketHandler`;


Get["https://raw.githubusercontent.com/JerryI/wl-wsp/main/Kernel/PageModule.wl"]
Get["https://raw.githubusercontent.com/JerryI/wl-misc/main/Kernel/Events.wl"]

Get[FileNameJoin[{JerryI`WolframJSFrontend`root, "Services","JTP", "JTP.wl"}]]
