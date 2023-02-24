(* ::Package:: *)
JerryI`WolframJSFrontend`root           = ParentDirectory[DirectoryName[$InputFileName]]
JerryI`WolframJSFrontend`public         = FileNameJoin[{JerryI`WolframJSFrontend`root, "public"}]
JerryI`WolframJSFrontend`defaultvault   = FileNameJoin[{JerryI`WolframJSFrontend`root, "Demo"}]

JerryI`WolframJSFrontend`notifications = <||>;

JerryI`WolframJSFrontend`ram = 0.0;

Get["https://raw.githubusercontent.com/JerryI/tcp-mathematica/main/JTP/JTP.wl"]
Get["https://raw.githubusercontent.com/JerryI/tinyweb-mathematica/master/Tinyweb/Tinyweb.wl"]
Get["https://raw.githubusercontent.com/JerryI/tinyweb-mathematica/master/WSP/WSP.wl"]