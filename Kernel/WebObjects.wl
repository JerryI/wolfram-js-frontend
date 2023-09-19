SetAttributes[FrontEndOnly, HoldFirst]

BeginPackage["JerryI`WolframJSFrontend`WebObjects`", {"JerryI`WolframJSFrontend`Colors`", "JerryI`WolframJSFrontend`Remote`", "JerryI`Misc`Events`"}];

(*
  ::Only for SECONDARY kernel::

    FrontEndObject/WebObjects package
    - creates the replacement table for all registered objects in WebObjects/... folder
    - extends the difinitions of the Kernel with a created objects as well
    - provides a direct link to communicate with frontened
*)

RegisterWebObject::usage = "RegisterWebObject register objects, which are FrontEndExecutables by the default (have JS representation)"
LoadWebObjects::usage = "LoadWebObjects loads all objects into memory and makes a replacement table"

FHold::usage = "alias to FrontEndOnly"

CreateFrontEndObject::usage = "Create an object"

Begin["`Private`"]; 

JerryI`WolframJSFrontend`WebObjects`replacement = {};
JerryI`WolframJSFrontend`WebObjects`list = {};



(* create and extend the definitionsof the kernel *)
CreateFrontEndObject[expr_, $iouid_String:Null, OptionsPattern[]] := Module[{},
With[{$ouid = If[$iouid === Null, CreateUUID[], $iouid]},
  With[{sym = <|"json"->ExportString[expr, "ExpressionJSON", "Compact" -> 0], "date"->Now |>},

    If[OptionValue["Override"] || OptionValue["Type"] === "Private",
      JerryI`WolframJSFrontend`Evaluator`objects[$ouid] = sym;
    ,
      $ExtendDefinitions[$ouid, sym]; 
    ];
    
    Global`FrontEndExecutableHold[$ouid] 
  ]
]]

Options[CreateFrontEndObject] = {"Override"->False, "Type"->"Shared"}



SetAttributes[FHold, HoldFirst]

RegisterWebObject[sym_] := (
  JerryI`WolframJSFrontend`WebObjects`list = {
    JerryI`WolframJSFrontend`WebObjects`list, sym
  } // Flatten;
)

JerryI`WolframJSFrontend`Extensions`RegisterFrontEndObject = RegisterWebObject;
JerryI`WolframJSFrontend`Extensions`RegisterAutocomplete = Print["Not implemented!"];;

LoadWebObjects := (
  JerryI`WolframJSFrontend`WebObjects`replacement = Table[
    With[{item = i},
      {
        Global`CreateFrontEndObject[item[x__], $iouid_:Null] :> With[{$ouid = If[$iouid === Null, CreateUUID[], $iouid]}, 
          Global`$NewDefinitions[$ouid] = <|"json"->ExportString[item[x], "ExpressionJSON", "Compact" -> 0], "date"->Now |>; 
          $ExtendDefinitions[$ouid, Global`$NewDefinitions[$ouid]]; Global`FrontEndExecutable[$ouid] ],
        item[x__] :> With[{$ouid = CreateUUID[]}, 
          Global`$NewDefinitions[$ouid] = <|"json"->ExportString[item[x], "ExpressionJSON", "Compact" -> 0], "date"->Now |>; 
          $ExtendDefinitions[$ouid, Global`$NewDefinitions[$ouid]]; Global`FrontEndExecutable[$ouid] ]
      }
    ]
   , {i, JerryI`WolframJSFrontend`WebObjects`list}] // Flatten;

  Print[Blue<>"done!"]; Print[Reset];
) // Quiet;

End[];
EndPackage[];