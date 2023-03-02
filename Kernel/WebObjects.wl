BeginPackage["JerryI`WolframJSFrontend`WebObjects`", {"JerryI`WolframJSFrontend`Colors`"}];

RegisterWebObject::usage = "RegisterWebObject register objects, which are FrontEndObjs automatically (have JS representation)"
LoadWebObjects::usage = "LoadWebObjects loads all objects into memory and makes a replacement table"

FrontEndOnly::usage = "Will not be processed outside the frontend"

Begin["`Private`"]; 

JerryI`WolframJSFrontend`WebObjects`replacement = {};
JerryI`WolframJSFrontend`WebObjects`list = {};

SetAttributes[FrontEndOnly, HoldFirst]

RegisterWebObject[sym_] := JerryI`WolframJSFrontend`WebObjects`list = {JerryI`WolframJSFrontend`WebObjects`list, sym}//Flatten;

LoadWebObjects := (
  JerryI`WolframJSFrontend`WebObjects`list = {Graphics, Graphics3D};

  Get/@FileNames["*.wl", FileNameJoin[{JerryI`WolframJSFrontend`root, "WebObjects"}], Infinity];

  JerryI`WolframJSFrontend`WebObjects`replacement = Table[
    With[{item = i},
      {
        Global`FrontEndObj[item[x__], $iouid_:CreateUUID[]] :> With[{$ouid = $iouid}, Global`$NewDefinitions[$ouid] = ExportString[item[x], "ExpressionJSON"]; Global`FrontEndExecutable[$ouid] ],
        item[x__] :> With[{$ouid = CreateUUID[]}, Global`$NewDefinitions[$ouid] = ExportString[item[x], "ExpressionJSON"]; Global`FrontEndExecutable[$ouid] ]
      }
    ]
   , {i, JerryI`WolframJSFrontend`WebObjects`list}];

  JerryI`WolframJSFrontend`WebObjects`replacement = {JerryI`WolframJSFrontend`WebObjects`replacement, 
    Global`FrontEndObj[x_, $iouid_:CreateUUID[]] :> With[{$ouid = $iouid}, Global`$NewDefinitions[$ouid] = ExportString[x, "ExpressionJSON"]; Global`FrontEndExecutable[$ouid]]
  } // Flatten;

  Print[Blue<>"done!"]; Print[Reset];
);

End[];
EndPackage[];