BeginPackage["JerryI`WolframJSFrontend`WebObjects`", {"JerryI`WolframJSFrontend`Colors`"}];

RegisterWebObject::usage = "RegisterWebObject register objects, which are FrontEndObjs automatically (have JS representation)"
LoadWebObjects::usage = "LoadWebObjects loads all objects into memory and makes a replacement table"

FrontEndOnly::usage = "Will not be processed outside the frontend"

CreateFrontEndObject::usage = "Create object"

Begin["`Private`"]; 

JerryI`WolframJSFrontend`WebObjects`replacement = {};
JerryI`WolframJSFrontend`WebObjects`list = {};

CreateFrontEndObject[expr_, $iouid_:CreateUUID[]] := With[{$ouid = $iouid}, Global`$NewDefinitions[$ouid] = ExportString[expr, "ExpressionJSON"]; Global`FrontEndExecutableHold[$ouid] ]


SetAttributes[FrontEndOnly, HoldFirst]

RegisterWebObject[sym_] := JerryI`WolframJSFrontend`WebObjects`list = {JerryI`WolframJSFrontend`WebObjects`list, sym}//Flatten;

LoadWebObjects := (
  JerryI`WolframJSFrontend`WebObjects`list = {Graphics, Graphics3D};

  Get/@FileNames["*.wl", FileNameJoin[{JerryI`WolframJSFrontend`root, "WebObjects"}], Infinity];

  JerryI`WolframJSFrontend`WebObjects`replacement = Table[
    With[{item = i},
      {
        Global`CreateFrontEndObject[item[x__], $iouid_:CreateUUID[]] :> With[{$ouid = $iouid}, Global`$NewDefinitions[$ouid] = ExportString[item[x], "ExpressionJSON"]; Global`FrontEndExecutable[$ouid] ],
        item[x__] :> With[{$ouid = CreateUUID[]}, Global`$NewDefinitions[$ouid] = ExportString[item[x], "ExpressionJSON"]; Global`FrontEndExecutable[$ouid] ]
      }
    ]
   , {i, JerryI`WolframJSFrontend`WebObjects`list}] // Flatten;

  Print[Blue<>"done!"]; Print[Reset];
);

End[];
EndPackage[];