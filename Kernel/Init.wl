(* ::Package:: *)
JerryI`WolframJSFrontend`root           = ParentDirectory[DirectoryName[$InputFileName]]
JerryI`WolframJSFrontend`public         = FileNameJoin[{JerryI`WolframJSFrontend`root, "public"}]
JerryI`WolframJSFrontend`defaultvault   = FileNameJoin[{JerryI`WolframJSFrontend`root, "Demo"}]

JerryI`WolframJSFrontend`notifications = <||>;

JerryI`WolframJSFrontend`ram = 0.0;

Get["../tcp-mathematica/JTP/JTP.wl"]
Get["../tinyweb-mathematica/Tinyweb/Tinyweb.wl"]
Get["../tinyweb-mathematica/WSP/WSP.wl"]