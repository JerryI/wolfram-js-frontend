(* ::Package:: *)

(* default paths *)
JerryI`WolframJSFrontend`root           = ParentDirectory[DirectoryName[$InputFileName]]
JerryI`WolframJSFrontend`public         = FileNameJoin[{JerryI`WolframJSFrontend`root, "public"}]
JerryI`WolframJSFrontend`defaultvault   = FileNameJoin[{JerryI`WolframJSFrontend`root, "Demo"}]

Get["Services/JTP/JTP.wl"]
Get["Services/Tinyweb/Tinyweb.wl"]
Get["Services/WSP/WSP.wl"]