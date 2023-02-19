BeginPackage["JerryI`WolframJSFrontend`WebObjects`"];

RegisterWebObject::usage = "RegisterWebObject register objects, which are FrontEndObjs automatically (have JS representation)"
LoadWebObjects::usage = "LoadWebObjects loads all objects into memory and makes a replacement table"

Begin["`Private`"]; 

JerryI`WolframJSFrontend`WebObjects`list = {Graphics, Graphics3D};

RegisterWebObject[sym_] := JerryI`WolframJSFrontend`WebObjects`list = {JerryI`WolframJSFrontend`WebObjects`list, sym}//Flatten;

LoadWebObjects := (
  Get/@FileNames["*.wl", FileNameJoin[{JerryI`WolframJSFrontend`root, "WebObjects"}], Infinity];

  JerryI`WolframJSFrontend`WebObjects`replacement = Table[
    With[{item = i},
      {
        Global`FrontEndObj[item[x__], $ouid_:CreateUUID[]] :> With[{}, Global`$NewDefinitions[$ouid] = ExportString[item[x], "ExpressionJSON"]; Global`FrontEndExecutable[$ouid]],
        item[x__] :> With[{$ouid = CreateUUID[]}, Global`$NewDefinitions[$ouid] = ExportString[item[x], "ExpressionJSON"]; Global`FrontEndExecutable[$ouid]]
      }
    ]
   , {i, JerryI`WolframJSFrontend`WebObjects`list}];

  JerryI`WolframJSFrontend`WebObjects`replacement = {JerryI`WolframJSFrontend`WebObjects`replacement, 
    Global`FrontEndObj[x_, $ouid_:CreateUUID[]] :> With[{}, Global`$NewDefinitions[$ouid] = ExportString[x, "ExpressionJSON"]; Global`FrontEndExecutable[$ouid]]
  } // Flatten;
);

End[];
EndPackage[];