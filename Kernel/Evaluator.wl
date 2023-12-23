BeginPackage["JerryI`Notebook`Evaluator`", {"KirillBelov`Objects`", "JerryI`Misc`Events`", "JerryI`Notebook`Transactions`"}]

StaticEvaluator::usage = "StaticEvaluator[opts__] creates a basic Evaluator"
(* :: Options :: *)
(* "Q" -> Function[{t_Transaction}, ...] -> Boolean *)

(* :: Upvalues :: *)
(* ReadyQ[_StaticEvaluator, _Kernel] -> True | "Error code"_String *)
(* Submit[_StaticEvaluator, _Kernel, _Transaction] *)

StandardEvaluator::usage = "a static construction used for combinning StaticEvaluators and Kernels"
(* :: usage ::                                          *)
(* StandardEvaluator[kernel_Kernel][t_Transaction]      *)

Begin["`Private`"]

init[o_] := With[{uid = CreateUUID[]},
    If[!ListQ[eList], eList = {}];
    eList = SortBy[Append[eList, o], #["Priority"]&];
    Print["Added new!"];
    o
];

CreateType[StaticEvaluator, init, {"Priority"->Infinity, "Q"->(True&)}]

(* static structure with a single instance or??? *)
StandardEvaluator[k_(*Kernel*)][t_Transaction] := Module[{evaluator, state},
    Print["Standard Eval"];
    evaluator = With[{list = Map[With[{q = #["Q"], o = #},
        {Unevaluated[q[t]], o}
    ]&, eList] // Flatten},
        Which @@ list
    ];

    Print[evaluator];
    state = (StandardEvaluator`ReadyQ[evaluator, k]);
    Print[state];
    If[!TrueQ[state], EventFire[t, "Error", state]; Return[t]];

    StandardEvaluator`Evaluate[evaluator, k, t];
    t 
]

StandardEvaluator /: StandardEvaluator`ReadyQ[StandardEvaluator[o_(*Kernel*)]] := True


End[]
EndPackage[]