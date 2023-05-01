(* 
  ::Only for SECONDARY kernel::

  Default evaluators package 
  used by the remote/local Kernel

  - Wolfram Language with WebObjects` support
  - Template postprocessor
*)

Global`$out = Null;

(* global scope *)
SetAttributes[SetFrontEndObject, HoldFirst];
SetAttributes[FrontEndRef, HoldFirst];

(* autoconvertion of the frontend object back to the original expressions *)
FrontEndExecutableWrapper[uid_] :=  (Print["Importing string"]; ImportString[
  Function[res, If[!StringQ[res], 
                  JerryI`WolframJSFrontend`Evaluator`objects[uid] = AskMaster[Global`NotebookGetObjectForMe[uid]];
                  JerryI`WolframJSFrontend`Evaluator`objects[uid]["json"]
                  ,
                  res
    ]
  ] @ (JerryI`WolframJSFrontend`Evaluator`objects[uid]["json"])
, "ExpressionJSON"] // ReleaseHold );

FrontEndRef[FrontEndExecutableWrapper[uid_]] := FrontEndExecutableHold[uid];
FrontEndRef[FrontEndExecutable[uid_]]        := FrontEndExecutableHold[uid];



(* exceptional case, when the frontened object is set *)
SetFrontEndObject[FrontEndExecutableWrapper[uid_], expr_] ^:= SetFrontEndObject[uid, expr];
Set[FrontEndExecutableWrapper[uid_], expr_] ^:= (SetFrontEndObject[uid, expr]//SendToFrontEnd);

SetFrontEndObject[FrontEndRef[uid_], expr_] ^:= SetFrontEndObject[uid, expr];
Set[FrontEndRef[uid_], expr_] ^:= (SetFrontEndObject[uid, expr]//SendToFrontEnd);

(* special post-handler, only used for upvalues *)
CM6Form[e_] := e

(* iconize *)
Unprotect[Iconize]
ClearAll[Iconize]

(* unsupported tagbox *)
RowBoxToCM[x_List, y___] := StringJoin @@ (ToString[#] & /@ x)
CMGrid[x_List, y__] := CMGrid[x]
TagBoxToCM[x_, y__] := x

(* on-output convertion *)
$CMReplacements = {RowBox -> RowBoxToCM, SqrtBox -> CM6Sqrt, FractionBox -> CM6Fraction, 
 GridBox -> CM6Grid, TagBox -> TagBoxToCM, SubscriptBox -> CM6Subscript, SuperscriptBox -> CM6Superscript}

(* on-input convertion *)
$CMExpressions = {
        Global`FrontEndExecutable -> Global`FrontEndExecutableWrapper,
        Global`CM6Sqrt -> Sqrt,
        Global`CM6Fraction -> Global`CM6FractionWrapper,
        Global`CM6Grid -> Identity,
        Global`CM6Subscript -> Subscript,
        Global`CM6Superscript -> Power}

CM6FractionWrapper[x_,y_] := x/y;

Iconize[expr_] := CreateFrontEndObject[IconizeWrapper[expr], CreateUUID[]]

BeginPackage["JerryI`WolframJSFrontend`Evaluator`", {"WSP`"}];

(* going to be executed on the remote or local kernels *)

WolframEvaluator::usage = "WolframEvaluator[] a basic mathematica kernel, which executes the commands. Can be run on Local or on Remote kernel"
(*
  WolframEvaluator[::expression string::, ::blocks or not the output::, ::signature, i.e. notebook ID::, ::type::]
  accepts the ::callback function:: as a subvalue, which prevents it from the evaluation on the transport stage
*)
TemplateEvaluator::usage = "used for custom built cell types. uses WSP engine"
CellPrologOption::usage = "CellPrologOption[] used for overriding cell's id"

Begin["`Private`"]; 

(* local copy of the notebook storage, which is extended by WebObjects` indirectly *)
JerryI`WolframJSFrontend`Evaluator`objects   = <||>;

WolframEvaluator[str_String, block_, signature_][callback_] := Module[{},
  Block[{Global`$NewDefinitions = <||>, $CellUid = CreateUUID[], $NotebookID = signature, $evaluated},
    Block[{
            
          },

      (* convert, and replace all frontend objects with its representations (except Set) and evaluate the result *)
      $evaluated = (ToExpression[str, InputForm, Hold] /. Global`$CMExpressions // ReleaseHold) /. {Global`IconizeWrapper -> Identity};
      
      (* a shitty analogue of % symbol *)
      Global`$out = $evaluated;
      
      (* blocks the output if the was a command from the procesor *)
      If[block === True, $evaluated = Null];
    ];  

    (* replaces the output with a registered WebObjects/FrontEndObjects and releases created held frontend objects *)
    With[{$result = ($evaluated // Global`CM6Form) /. JerryI`WolframJSFrontend`WebObjects`replacement /. {Global`FrontEndExecutableHold -> Global`FrontEndExecutable}},
      (* each creation of FrontEndExecutable extends the objects to $NewDefinitiions, now me merge it with the local storage *)
      JerryI`WolframJSFrontend`Evaluator`objects = Join[JerryI`WolframJSFrontend`Evaluator`objects, Global`$NewDefinitions];
      
      (* truncate the output, if it is too long and create a fake object to represent it *)
      With[{$string = StringReplace[($result // ToBoxes) /. Global`$CMReplacements // ToString, "\[NoBreak]"->""]},
        callback[
          If[StringLength[$string] > 5000,
            With[{dumpid = CreateUUID[], len = StringLength[$string], short = StringTake[$string, 50]},

              (* keep the real data inside the local storage *)
              JerryI`WolframJSFrontend`Evaluator`objects[dumpid] = $string;

              (* create a separate representation for the notebook and frontened using the same id *)
              Global`$NewDefinitions[dumpid] = <|"json"->ExportString[Global`FrontEndTruncated[short, len], "ExpressionJSON", "Compact" -> -1], "date"->Now |>;
              "FrontEndExecutable[\""<>dumpid<>"\"]"
            ]
          ,
            $string
          ],

          (* !not used anymore... consider to remove *)
          $CellUid, 

          (* specify the frontened renderer *)
          "codemirror",

          (* an internal message for the master kernel, which passes the created objects during the evaluation *)
          JerryI`WolframJSFrontend`ExtendDefinitions[Global`$NewDefinitions]

        ];
      ]
    ];

    
  ]
];

TemplateEvaluator[str_String, signature_, type_:String][callback_] := Module[{},
  Block[{$CellUid = CreateUUID[]},
        
    callback[
      LoadString[str],
      $CellUid, 
      type,
      Null
    ];
    
  ]
];


(* i do not need them anymore  *)

CellPrologOption[expr_, "id"->uid_] := ($CellUid=uid; expr);

End[];
EndPackage[];