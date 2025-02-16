BeginPackage["CoffeeLiqueur`Notebook`Evaluator`", {"KirillBelov`Objects`", "JerryI`Misc`Events`", "CoffeeLiqueur`Notebook`Transactions`"}]

StandardEvaluator::usage = "StandardEvaluator[opts__] creates a basic Evaluator"
EvaluateTransaction;

ReadyQ;
Container::usage = "a static construction used for combinning StaticEvaluators and Kernels"
InitializedContainer;

Begin["`Private`"]

Needs["CoffeeLiqueur`Notebook`Kernel`" -> "GenericKernel`"];

init[o_] := With[{uid = CreateUUID[]},
    If[!ListQ[eList], eList = {}];
    eList = SortBy[Append[eList, o], #["Priority"]&];
    Print["Added new!"];
    Print[o];
    o
];

CreateType[StandardEvaluator, init, {"Priority"->Infinity, "InitKernel"->Identity, "Pattern"->(_), "Name"->"Untitled Static Evaluator"}]

(* static structure with a single instance or??? *)
Container[k_(*Kernel*)] := Module[{},
    (* perform initial tuning of a Kernel *)
    #["InitKernel"][k] &/@ eList;
    InitializedContainer[k]
]

InitializedContainer[k_]["Kernel"] := k;

InitializedContainer[k_(*Kernel*)][t_Transaction] := Module[{evaluator, state},
    Print["Standard Eval"];

    evaluator = t /. Flatten[{#["Pattern"] -> #} &/@ eList]; (* apply patterns like t /. {_ -> evaluator 1, _?watever -> evaluator 2} *)

    state = (ReadyQ[evaluator, k]);
    If[!TrueQ[state], EventFire[t, "Error", state]; Return[t] ];

    EvaluateTransaction[evaluator, k, t];
    t 
]

StandardEvaluator /: ReadyQ[StandardEvaluator[o_(*Kernel*)] ] := True

StandardEvaluator /: Print[evaluator_StandardEvaluator, msg_] := Echo[evaluator["Name"] <> " >> " <> ToString[msg] ]
StandardEvaluator /: Print[evaluator_StandardEvaluator, msg_, args__] := Echo[evaluator["Name"] <> " >> " <> StringTemplate[msg // ToString][args] ]

(* Primitive Evaluator *)
(*
primitive  = StandardEvaluator["Name" -> "Primitive Static Evaluator", "InitKernel" -> initPrimitiveEvaluator, "Priority"->(Infinity)];

    ReadyQ[primitive, kernel_] := (
        Print[primitive, "I am always ready"];
        True
    );

    EvaluateTransaction[primitive, kernel_, t_] := (
        t["Evaluator"] = Internal`Kernel`Evaluator`Simple;

        Print[primitive, "GenericKernel`Submit!"];
        GenericKernel`Submit[kernel, t];
    );

initPrimitiveEvaluator[k_] := Module[{},
    Print["Kernel init..."];
    GenericKernel`Init[k, 
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
*)

End[]
EndPackage[]