BeginPackage["JerryI`WolframJSFrontend`Utils`"];

console::usage = "console[\"log\", message, args]"
NullQ::usage = "NullQ[x]"

Begin["`Private`"]; 

NullQ[expr_] := expr===Null;

console["log", message_, args___] := Print[StringTemplate[message][args]]
console["memory stat"] := (JerryI`WolframJSFrontend`ram = {JerryI`WolframJSFrontend`ram, Round[MemoryInUse[]/1024,1]/1024//N}//Flatten);

End[];

EndPackage[];