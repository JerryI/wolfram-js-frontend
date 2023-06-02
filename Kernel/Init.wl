(* ::Package:: *)

(* default paths *)
JerryI`WolframJSFrontend`root           = ParentDirectory[DirectoryName[$InputFileName]]
JerryI`WolframJSFrontend`public         = FileNameJoin[{JerryI`WolframJSFrontend`root, "public"}]
JerryI`WolframJSFrontend`defaultvault   = If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], FileNameJoin[{JerryI`WolframJSFrontend`root, "Conference"}]]
 
Get["Services/JTP/JTP.wl"]
Get["Services/Tinyweb/Tinyweb.wl"]
Get["Services/WSP/WSP.wl"]