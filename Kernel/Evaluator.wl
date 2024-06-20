BeginPackage["JerryI`Notebook`Evaluator`", {"KirillBelov`Objects`", "JerryI`Misc`Events`", "JerryI`Notebook`Transactions`", "JerryI`Notebook`Kernel`"}]

StandardEvaluator::usage = "StandardEvaluator[opts__] creates a basic Evaluator"
(* :: Options :: *)
(* "Q" -> Function[{t_Transaction}, ...] -> Boolean *)

(* :: Upvalues :: *)
(* ReadyQ[_StandardEvaluator, _Kernel] -> True | "Error code"_String *)
(* Kernel`Submit[_StandardEvaluator, _Kernel, _Transaction] *)

StandardEvaluator`Container::usage = "a static construction used for combinning StaticEvaluators and Kernels"
(* :: usage ::                                          *)
(* StandardEvaluator[kernel_Kernel][t_Transaction]      *)

Begin["`Private`"]

init[o_] := With[{uid = CreateUUID[]},
    If[!ListQ[eList], eList = {}];
    eList = SortBy[Append[eList, o], #["Priority"]&];
    Print["Added new!"];
    Print[o];
    o
];

CreateType[StandardEvaluator, init, {"Priority"->Infinity, "InitKernel"->Identity, "Pattern"->(_), "Name"->"Untitled Static Evaluator"}]

(* static structure with a single instance or??? *)
StandardEvaluator`Container[k_(*Kernel*)] := Module[{},
    (* perform initial tuning of a Kernel *)
    #["InitKernel"][k] &/@ eList;
    StandardEvaluator`InitializedContainer[k]
]

StandardEvaluator`InitializedContainer[k_]["Kernel"] := k;

StandardEvaluator`InitializedContainer[k_(*Kernel*)][t_Transaction] := Module[{evaluator, state},
    Print["Standard Eval"];

    evaluator = t /. Flatten[{#["Pattern"] -> #} &/@ eList]; (* apply patterns like t /. {_ -> evaluator 1, _?watever -> evaluator 2} *)

    state = (StandardEvaluator`ReadyQ[evaluator, k]);
    If[!TrueQ[state], EventFire[t, "Error", state]; Return[t] ];

    StandardEvaluator`Evaluate[evaluator, k, t];
    t 
]

StandardEvaluator /: StandardEvaluator`ReadyQ[StandardEvaluator[o_(*Kernel*)] ] := True

StandardEvaluator /: StandardEvaluator`Print[evaluator_StandardEvaluator, msg_] := Echo[evaluator["Name"] <> " >> " <> ToString[msg] ]
StandardEvaluator /: StandardEvaluator`Print[evaluator_StandardEvaluator, msg_, args__] := Echo[evaluator["Name"] <> " >> " <> StringTemplate[msg // ToString][args] ]

(* Primitive Evaluator *)

primitive  = StandardEvaluator["Name" -> "Primitive Static Evaluator", "InitKernel" -> initPrimitiveEvaluator, "Priority"->(Infinity)];

    StandardEvaluator`ReadyQ[primitive, kernel_] := (
        StandardEvaluator`Print[primitive, "I am always ready"];
        True
    );

    StandardEvaluator`Evaluate[primitive, kernel_, t_] := (
        t["Evaluator"] = Internal`Kernel`Evaluator`Simple;

        StandardEvaluator`Print[primitive, "Kernel`Submit!"];
        Kernel`Submit[kernel, t];
    );

initPrimitiveEvaluator[k_] := Module[{},
    Print["Kernel init..."];
    Kernel`Init[k, 
        Print["Init primitive Kernel (Local)"];
        Internal`Kernel`Evaluator`Simple = Function[t, 
            With[{result = ToExpression[ t["Data"], InputForm ] },
                EventFire[Internal`Kernel`Stdout[ t["Hash"] ], "Result", <|"Data" -> ToString[result, InputForm] |> ];
                EventFire[Internal`Kernel`Stdout[ t["Hash"] ], "Finished", True ];
                result;
            ]
        ];
        Internal`Kernel`Evaluator`Held = Function[t, 
            With[{result = t["Data"] // ReleaseHold },
                EventFire[Internal`Kernel`Stdout[ t["Hash"] ], "Result", <|"Data" -> result |> ];
                EventFire[Internal`Kernel`Stdout[ t["Hash"] ], "Finished", True ];
                result;
            ]
        ];        
    ]
]

End[]
EndPackage[]