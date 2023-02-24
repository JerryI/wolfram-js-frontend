#!/usr/bin/env wolframscript

$HistoryLength = 0
PacletDirectoryLoad[Directory[]]

Get["https://raw.githubusercontent.com/JerryI/tcp-mathematica/main/JTP/JTP.wl"]
Get["JerryI`WolframJSFrontend`Kernel`"]
Get["JerryI`WolframJSFrontend`Colors`"]
Get["JerryI`WolframJSFrontend`WebObjects`"]

Print[Magenta <> "Local Kernel Test"];
Print[Reset];

$ContextAliases["jsf`"] = "JerryI`WolframJSFrontend`";

jsf`jtp   =  JTPServer["host" -> "127.0.0.1", "port" -> 2850, "nohup"->True] // JTPServerStart
jsf`jtp["promise"] = Null

LoadWebObjects

evalTest := (
    Print[Magenta <> "Eval test"];
    Print[Reset];
    LocalKernel[WolframEvaluator["1+1", False, "test"], TestData];
    Print["sent..."];
);

TestData[result_, uid_, display_, func_] := If[
    result === "2",
    Print[Green<>"Ok!"]; Print[Reset]; TestAsyncLink,
    Print[Red<>"Not ok: "<>ToString[result]]; Print[Reset];
];

TestAsyncLink := (
    Print[JerryI`WolframJSFrontend`Kernel`Private`asyncsocket];
    LocalKernel[WolframEvaluator["1+1", False, "test"], Print[#1]&, "Link"->"JTP"];
);

LocalKernel["Start"][Function[x, Print[Green<>"Connection is OK: "<>x["text"]]; Print[Reset]; evalTest; ] ]//Print;

LocalKernel["PongHandler"][Print];


While[True, 
    LinkRead[JerryI`WolframJSFrontend`Kernel`Private`link]//Print;
    Pause[0.1]
];