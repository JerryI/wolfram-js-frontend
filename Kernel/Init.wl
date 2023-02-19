(* ::Package:: *)
JerryI`WolframJSFrontend`root   = ParentDirectory[DirectoryName[$InputFileName]]
JerryI`WolframJSFrontend`public = FileNameJoin[{JerryI`WolframJSFrontend`root, "public"}]
JerryI`WolframJSFrontend`temp   = FileNameJoin[{JerryI`WolframJSFrontend`root, "public", "trashcan"}]

JerryI`WolframJSFrontend`notifications = <||>;

JerryI`WolframJSFrontend`ram = 0.0;

Get["https://raw.githubusercontent.com/JerryI/tinyweb-mathematica/master/Tinyweb/Tinyweb.wl"]
Get["https://raw.githubusercontent.com/JerryI/tinyweb-mathematica/master/WSP/WSP.wl"]

Get["JerryI`WolframJSFrontend`Starter`"]
Get["JerryI`WolframJSFrontend`Notifications`"]
Get["JerryI`WolframJSFrontend`DBManager`"]
Get["JerryI`WolframJSFrontend`Utils`"]