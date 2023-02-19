JerryI`WolframJSFrontend`Evaluator`objects   = <||>;
(*JerryI`WolframJSFrontend`Evaluator`variables = <||>;*)

WolframEvaluator[str_String, block_, signature_][callback_] := Module[{},
  Block[{$NewDefinitions = <||>, $CellUid = CreateUUID[], $NotebookID = signature, $evaluated, $out},
    Block[{
            FrontEndExecutable = Function[uid,   ImportString[JerryI`WolframJSFrontend`Evaluator`objects[uid], "ExpressionJSON"]], 
          },

      $evaluated = ToExpression[str];
      $out = $evaluated;
      If[block === True, $evaluated = Null];
    ];  

    With[$result = $evaluated /. JerryI`WolframJSFrontend`WebObjects`replacement,
      JerryI`WolframJSFrontend`Evaluator`objects = Join[JerryI`WolframJSFrontend`Evaluator`objects, $NewDefinitions];
      
      With[{$string = ToString[$result, InputForm]},
        callback[
          If[StringLength[$string] > 5000,
            With[{dumpid = CreateUUID[], len = StringLength[$string], short = StringTake[$string, 50]},
              JerryI`WolframJSFrontend`Evaluator`objects[dumpid] = $string;
              $NewDefinitions[dumpid] = ExportString[FrontEndTruncated[short, len], "ExpressionJSON"];

              "FrontEndExecutable[\""<>dumpid<>"\"]"
            ]
          ,
            $string
          ],

          $CellUid, 
          "codemirror",
          NotebookExtendDefinitions[$NewDefinitions]

        ];
      ]
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