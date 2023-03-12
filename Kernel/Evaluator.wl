SetAttributes[SetFrontEndObject, HoldFirst];

FrontEndExecutableWrapper[uid_] := ImportString[JerryI`WolframJSFrontend`Evaluator`objects[uid], "ExpressionJSON"];
SetFrontEndObject[FrontEndExecutableWrapper[uid_], expr_] ^:= SetFrontEndObject[uid, expr];
SetFrontEndObject[FrontEndExecutable[uid_], expr_] ^:= SetFrontEndObject[uid, expr];

BeginPackage["JerryI`WolframJSFrontend`Evaluator`", { "WSP`"}];

(*going to be executed on the remote or local kernels*)

WolframEvaluator::usage = "WolframEvaluator[] a basic mathematica kernel, which executes the commands. Can be run on Local or on Remote kernel"
WSPEvaluator::usage = "WSPEvaluator[]"
MarkdownEvaluator::usage = "MarkdownEvaluator[]"
JSEvaluator:usage = "JSEval"
CellPrologOption::usage = "CellPrologOption[] used for overriding cell's id"

Begin["`Private`"]; 

JerryI`WolframJSFrontend`Evaluator`objects   = <||>;
(*JerryI`WolframJSFrontend`Evaluator`variables = <||>;*)


WolframEvaluator[str_String, block_, signature_][callback_] := Module[{},
  Block[{Global`$NewDefinitions = <||>, $CellUid = CreateUUID[], $NotebookID = signature, $evaluated, $out},
    Block[{
            Global`FrontEndExecutable = Global`FrontEndExecutableWrapper
          },

      $evaluated = ToExpression[str, InputForm, Hold] /. {Global`SetFrontEndObject[Global`FrontEndExecutable[uid_], expr_] :> Global`SetFrontEndObject[uid, expr]} // ReleaseHold;
      $out = $evaluated;
      If[block === True, $evaluated = Null];
    ];  

    With[{$result = $evaluated /. JerryI`WolframJSFrontend`WebObjects`replacement /. {Global`FrontEndExecutableHold -> Global`FrontEndExecutable}},
      JerryI`WolframJSFrontend`Evaluator`objects = Join[JerryI`WolframJSFrontend`Evaluator`objects, Global`$NewDefinitions];
      
      With[{$string = ToString[$result, InputForm]},
        callback[
          If[StringLength[$string] > 5000,
            With[{dumpid = CreateUUID[], len = StringLength[$string], short = StringTake[$string, 50]},
              JerryI`WolframJSFrontend`Evaluator`objects[dumpid] = $string;
              Global`$NewDefinitions[dumpid] = ExportString[Global`FrontEndTruncated[short, len], "ExpressionJSON"];

              "FrontEndExecutable[\""<>dumpid<>"\"]"
            ]
          ,
            $string
          ],

          $CellUid, 
          "codemirror",
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

(*WolframEvaluatorFast[str_String, "JSON"][callback_] := Module[{},
    Block[{
            FrontEndExecutable = Function[uid,   ImportString[JerryI`WolframJSFrontend`Evaluator`objects[uid], "ExpressionJSON"]], 
          },

      callback[ExportString[ToExpression[str], "ExpressionJSON"]]
    ]; 
];

WolframEvaluatorFast[str_String, "String"][callback_] := Module[{},
    Block[{
            FrontEndExecutable = Function[uid,   ImportString[JerryI`WolframJSFrontend`Evaluator`objects[uid], "ExpressionJSON"]], 
          },

      callback[ToString[ToExpression[str], InputForm]]
    ]; 
];*)
(* i do not need them, since the dynamics is internal  *)

CellPrologOption[expr_, "id"->uid_] := ($CellUid=uid; expr);

End[];
EndPackage[];