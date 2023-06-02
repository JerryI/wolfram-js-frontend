BeginPackage["JerryI`WolframJSFrontend`WebObjects`", {"JerryI`WolframJSFrontend`Colors`", "JerryI`WolframJSFrontend`Remote`"}];

(*
  ::Only for SECONDARY kernel::

    FrontEndObject/WebObjects package
    - creates the replacement table for all registered objects in WebObjects/... folder
    - extends the difinitions of the Kernel with a created objects as well
    - provides a direct link to communicate with frontened
*)

RegisterWebObject::usage = "RegisterWebObject register objects, which are FrontEndExecutables by the default (have JS representation)"
LoadWebObjects::usage = "LoadWebObjects loads all objects into memory and makes a replacement table"

FrontEndOnly::usage = "a wrapper, where the expression will not be processed outside the frontend"

FHold::usage = "alias to FrontEndOnly"

CreateFrontEndObject::usage = "Create an object"

Begin["`Private`"]; 

JerryI`WolframJSFrontend`WebObjects`replacement = {};
JerryI`WolframJSFrontend`WebObjects`list = {};

(* create and extend the definitionsof the kernel *)
CreateFrontEndObject[expr_, $iouid_:Null] := 
With[{$ouid = If[$iouid === Null, CreateUUID[], $iouid]},
  Print["obj created!"];
  $ExtendDefinitions[$ouid, <|"json"->ExportString[expr, "ExpressionJSON", "Compact" -> -1], "date"->Now |>]; 

  Global`FrontEndExecutableHold[$ouid] 
]

SetAttributes[FrontEndOnly, HoldFirst]

SetAttributes[FHold, HoldFirst]

RegisterWebObject[sym_] := JerryI`WolframJSFrontend`WebObjects`list = {JerryI`WolframJSFrontend`WebObjects`list, sym}//Flatten;

LoadWebObjects := (
  JerryI`WolframJSFrontend`WebObjects`replacement = Table[
    With[{item = i},
      {
        Global`CreateFrontEndObject[item[x__], $iouid_:Null] :> With[{$ouid = If[$iouid === Null, CreateUUID[], $iouid]}, 
          Global`$NewDefinitions[$ouid] = <|"json"->ExportString[item[x], "ExpressionJSON", "Compact" -> -1], "date"->Now |>; 
          $ExtendDefinitions[$ouid, Global`$NewDefinitions[$ouid]]; Global`FrontEndExecutable[$ouid] ],
        item[x__] :> With[{$ouid = CreateUUID[]}, 
          Global`$NewDefinitions[$ouid] = <|"json"->ExportString[item[x], "ExpressionJSON", "Compact" -> -1], "date"->Now |>; 
          $ExtendDefinitions[$ouid, Global`$NewDefinitions[$ouid]]; Global`FrontEndExecutable[$ouid] ]
      }
    ]
   , {i, JerryI`WolframJSFrontend`WebObjects`list}] // Flatten;

  Print[Blue<>"done!"]; Print[Reset];
);

End[];
EndPackage[];