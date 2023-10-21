SetAttributes[FrontEndOnly, HoldFirst]

BeginPackage["JerryI`WolframJSFrontend`WebObjects`", {"JerryI`WolframJSFrontend`Colors`", "JerryI`WolframJSFrontend`Remote`", "JerryI`Misc`Events`"}];

(*
  ::Only for SECONDARY kernel::

    FrontEndObject/WebObjects package
    - creates the replacement table for all registered objects in WebObjects/... folder
    - extends the difinitions of the Kernel with a created objects as well
    - provides a direct link to communicate with frontened
*)


FHold::usage = "alias to FrontEndOnly"

CreateFrontEndObject::usage = "Create an object"

Begin["`Private`"]; 

(* create and extend the definitionsof the kernel *)
CreateFrontEndObject[expr_, $iouid_String:Null, OptionsPattern[]] := Module[{},
With[{$ouid = If[$iouid === Null, CreateUUID[], $iouid]},
  With[{sym = <|"json"->ExportString[expr, "ExpressionJSON", "Compact" -> 0], "date"->Now |>},

    If[OptionValue["Override"] || OptionValue["Type"] === "Private",
      JerryI`WolframJSFrontend`Evaluator`objects[$ouid] = sym;
    ,
      $ExtendDefinitions[$ouid, sym]; 
    ];
    
    Global`FrontEndExecutable[$ouid] 
  ]
]]

Options[CreateFrontEndObject] = {"Override"->False, "Type"->"Shared"}

JerryI`WolframJSFrontend`Extensions`RegisterFrontEndObject[sym_] := (
  Unprotect[sym];
  sym /: MakeBoxes[sym[agrs__], StandardForm] := With[{o = CreateFrontEndObject[sym[agrs]]},
    MakeBoxes[o, StandardForm]
  ];
)



End[];
EndPackage[];