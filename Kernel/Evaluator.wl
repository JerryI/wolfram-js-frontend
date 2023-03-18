(* 
  ::Only for SECONDARY kernel::

  Default evaluators package 
  used by the remote/local Kernel

  - Wolfram Language with WebObjects` support
  - Markdown postprocessor
  - HTML/WSP postprocessor
*)

(* global scope *)
SetAttributes[SetFrontEndObject, HoldFirst];

(* autoconvertion of the frontend object back to the original expressions *)
FrontEndExecutableWrapper[uid_] := ImportString[JerryI`WolframJSFrontend`Evaluator`objects[uid], "ExpressionJSON"];
(* exceptional case, when the frontened object is set *)
SetFrontEndObject[FrontEndExecutableWrapper[uid_], expr_] ^:= SetFrontEndObject[uid, expr];
SetFrontEndObject[FrontEndExecutable[uid_], expr_] ^:= SetFrontEndObject[uid, expr];

BeginPackage["JerryI`WolframJSFrontend`Evaluator`", { "WSP`"}];

(* going to be executed on the remote or local kernels *)

WolframEvaluator::usage = "WolframEvaluator[] a basic mathematica kernel, which executes the commands. Can be run on Local or on Remote kernel"
(*
  WolframEvaluator[::expression string::, ::blocks or not the output::, ::signature, i.e. notebook ID::]
  accepts the ::callback function:: as a subvalue, which prevents it from the evaluation on the transport stage
*)
WSPEvaluator::usage = "WSPEvaluator[]"
MarkdownEvaluator::usage = "MarkdownEvaluator[]"
JSEvaluator:usage = "JSEval"
CellPrologOption::usage = "CellPrologOption[] used for overriding cell's id"

Begin["`Private`"]; 

(* local copy of the notebook storage, which is extended by WebObjects` indirectly *)
JerryI`WolframJSFrontend`Evaluator`objects   = <||>;

WolframEvaluator[str_String, block_, signature_][callback_] := Module[{},
  Block[{Global`$NewDefinitions = <||>, $CellUid = CreateUUID[], $NotebookID = signature, $evaluated, $out},
    Block[{
            Global`FrontEndExecutable = Global`FrontEndExecutableWrapper
          },

      (* convert, and replace all frontend objects with its representations (except Set) and evaluate the result *)
      $evaluated = ToExpression[str, InputForm, Hold] /. {Global`SetFrontEndObject[Global`FrontEndExecutable[uid_], expr_] :> Global`SetFrontEndObject[uid, expr]} // ReleaseHold;
      
      (* a shitty analogue of % symbol *)
      $out = $evaluated;
      
      (* blocks the output if the was a command from the procesor *)
      If[block === True, $evaluated = Null];
    ];  

    (* replaces the output with a registered WebObjects/FrontEndObjects and releases created held frontend objects *)
    With[{$result = $evaluated /. JerryI`WolframJSFrontend`WebObjects`replacement /. {Global`FrontEndExecutableHold -> Global`FrontEndExecutable}},
      (* each creation of FrontEndExecutable extends the objects to $NewDefinitiions, now me merge it with the local storage *)
      JerryI`WolframJSFrontend`Evaluator`objects = Join[JerryI`WolframJSFrontend`Evaluator`objects, Global`$NewDefinitions];
      
      (* truncate the output, if it is too long and create a fake object to represent it *)
      With[{$string = ToString[$result, InputForm]},
        callback[
          If[StringLength[$string] > 5000,
            With[{dumpid = CreateUUID[], len = StringLength[$string], short = StringTake[$string, 50]},

              (* keep the real data inside the local storage *)
              JerryI`WolframJSFrontend`Evaluator`objects[dumpid] = $string;

              (* create a separate representation for the notebook and frontened using the same id *)
              Global`$NewDefinitions[dumpid] = ExportString[Global`FrontEndTruncated[short, len], "ExpressionJSON", "Compact" -> -1];
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

WSPEvaluator[str_String, signature_][callback_] := Module[{},
  Block[{$CellUid = CreateUUID[], $NotebookID = signature, $evaluated, $out,
          Global`FrontEndExecutable = Function[uid,   ImportString[JerryI`WolframJSFrontend`Evaluator`objects[uid], "ExpressionJSON"]]
        },
        
    callback[
      LoadString[str],
      $CellUid, 
      "html",
      Null
    ];
    
  ]
];

JSEvaluator[str_String, signature_][callback_] := Module[{},
  Block[{$CellUid = CreateUUID[], $NotebookID = signature, $evaluated, $out,
          Global`FrontEndExecutable = Function[uid,   ImportString[JerryI`WolframJSFrontend`Evaluator`objects[uid], "ExpressionJSON"]]
        },
        
    callback[
      LoadString[str],
      $CellUid, 
      "js",
      Null
    ];
    
  ]
];

MarkdownEvaluator[str_String, signature_][callback_] := Module[{},
  Block[{$CellUid = CreateUUID[], $NotebookID = signature, $evaluated, $out,
          Global`FrontEndExecutable = Function[uid,   ImportString[JerryI`WolframJSFrontend`Evaluator`objects[uid], "ExpressionJSON"]]
        },
        
    callback[
      LoadString[str],
      $CellUid, 
      "markdown",
      Null
    ];
    
  ]
];

(* i do not need them anymore  *)

CellPrologOption[expr_, "id"->uid_] := ($CellUid=uid; expr);

End[];
EndPackage[];