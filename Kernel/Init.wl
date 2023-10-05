(* ::Package:: *)

(* default paths *)
JerryI`WolframJSFrontend`root           = ParentDirectory[DirectoryName[$InputFileName // AbsoluteFileName]]
Print[JerryI`WolframJSFrontend`root ];
JerryI`WolframJSFrontend`public         = FileNameJoin[{JerryI`WolframJSFrontend`root, "public"}]
JerryI`WolframJSFrontend`defaultvault   = If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".lastpath"}]], FileNameJoin[{JerryI`WolframJSFrontend`root, "Examples"}]]

JerryI`WolframJSFrontend`defaulttheme = If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".theme"}]], Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".theme"}]], "system"]

JerryI`WolframJSFrontend`css = If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".gcss"}]], Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".gcss"}]], "
  --font-size-small: small;
  --font-size-medium: medium;
  --font-size-large: large;
  --font-size-x-large: x-large;
  --font-size-xx-large: xx-large;
  --font-size-x-small: x-small;
  
  --editor-key-meta: #404740;
  --editor-key-keyword: #708;
  --editor-key-atom: #219;
  --editor-key-literal: #164;
  --editor-key-string: #a11;
  --editor-key-escape: #e40;
  --editor-key-variable: #00f;
  --editor-local-variable: #30a;
  --editor-key-type: #085;
  --editor-key-class: #167;
  --editor-special-variable: #256;
  --editor-key-property: #00c;
  --editor-key-comment: #940;
  --editor-key-invalid: #f00;
  
  --editor-outline: #696969;  
  "]

JerryI`WolframJSFrontend`settings = If[FileExistsQ[FileNameJoin[{JerryI`WolframJSFrontend`root, ".settings"}]], Get[FileNameJoin[{JerryI`WolframJSFrontend`root, ".settings"}]], <|"displayForm"->True, "background"->True, "autosave"->1000*60*3, "fastboot"->False|>]

JerryI`WolframJSFrontend`$PublicDirectory = Directory[]

JerryI`WolframJSFrontend`WSKernelAddr = "127.0.0.1"

PacletInstall["JerryI/LPM"]

<<JerryI`LPM`

Echo["LPM version: "<>ToString[JerryI`LPM`Private`Version]];

If[TimeConstrained[URLFetch["https://github.com"], 10] === $Aborted || TrueQ[JerryI`WolframJSFrontend`settings["fastboot"]],

  Print["No internet connection or fastboot..."];
  PacletRepositories[{}, "Directory"->JerryI`WolframJSFrontend`root, "Passive"->True]  
,

 PacletRepositories[{
  Github -> "https://github.com/JerryI/CSocketListener",
  Github -> "https://github.com/KirillBelovTest/Objects",
  Github -> "https://github.com/KirillBelovTest/Internal",
  Github -> "https://github.com/KirillBelovTest/TCPServer",
  Github -> "https://github.com/KirillBelovTest/HTTPHandler",
  Github -> "https://github.com/KirillBelovTest/WebSocketHandler",
  Github -> "https://github.com/JerryI/wl-wsp",
  Github -> "https://github.com/JerryI/wl-misc"
}, "Directory"->JerryI`WolframJSFrontend`root]
];

<<KirillBelov`CSockets`
<<KirillBelov`Objects`
<<KirillBelov`Internal`
<<KirillBelov`TCPServer`

<<KirillBelov`HTTPHandler`
<<KirillBelov`HTTPHandler`Extensions`
<<KirillBelov`WebSocketHandler`

<<JerryI`WSP`
<<JerryI`WSP`PageModule`

Get[FileNameJoin[{JerryI`WolframJSFrontend`root, "Services","JTP", "JTP.wl"}]]
