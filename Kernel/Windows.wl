BeginPackage["JerryI`Notebook`Windows`", {"JerryI`Notebook`", "JerryI`Misc`Events`", "KirillBelov`Objects`", "JerryI`Notebook`Transactions`"}]

WindowObj::usage = ""

Begin["`Private`"]

NullQ[any_] := any === Null

WindowObj`HashMap = <||>





CreateType[WindowObj, init, {"Notebook"->Null, "Display"->"codemirror", "Hash"->Null, "Data"->"", "Ref"->""}]

WindowObj /: EventHandler[n_WindowObj, opts__] := EventHandler[n["Hash"], opts] 
WindowObj /: EventFire[n_WindowObj, opts__] := EventFire[n["Hash"], opts]
WindowObj /: EventClone[n_WindowObj] := EventClone[n["Hash"] ]
WindowObj /: EventRemove[n_WindowObj, opts__] := EventRemove[n["Hash"], opts] 

init[o_] := Module[{uid = CreateUUID[]},
    Print["Init WindowObj"];

    o["Hash"] = uid;
    WindowObj`HashMap[uid] = o;
    If[!NullQ[ o["Notebook"] ],
        o["EvaluationContext"] = Join[o["Notebook"]["EvaluationContext"], <|"Notebook"->o["Notebook"]["Hash"]|>];
    ];

    o
]


WindowObj /: WindowObj`Evaluate[o_WindowObj, OptionsPattern[] ] := Module[{transaction, result = Null},
    Print["Submit WindowObj"];
    If[!NullQ[ o["Notebook"] ],

        o["State"] = "Evaluation";
        EventFire[o, "State", "Evaluation"];

        transaction = Transaction[];
        transaction["Data"] = o["Data"];
        Echo[o["Data"] ];
        transaction["EvaluationContext"] = Join[o["EvaluationContext"], <|"Ref" -> o["Ref"]|>, OptionValue["EvaluationContext"] ];

        EventHandler[transaction, {"Result" -> Function[data,
            (* AFTER, BEFORE, TYPE, PROPS can be altered using provided meta-data from the transaction *)
            result = data;
            Echo[result];
        ],
            "Finished" -> Function[Null,

                If[result["Data"] != "Null",
                    Module[{default = <|"Data" -> result["Data"], "Display" ->"codemirror"|>},
                        If[KeyExistsQ[result, "Meta"],
                            default = Join[default, Association[List[result["Meta"] ] ], <|"Hash" -> o["Hash"]|> ];
                        ];

                        Echo["!!!Default"];
                    

                        With[{tag = #, value = default[#]},
                            o[#] = value;
                        ]& /@ Keys[default];
                    ]
                ];

                EventFire[o["Hash"], "Ready", True];
                o["State"] = "Idle";
                Echo[o["Hash"] ];
                Echo["Finished!"];
                EventFire[o, "State", "Idle"];
            ],

            "Error" -> Function[error,
                o["State"] = "Idle";
                EventFire[o, "State", "Idle"];
                Echo["Error in evalaution... check syntax"];
                EventFire[o["Notebook"], "WindowError", {o, error}];
                EventFire[o, "Error", error];
            ],

            (*  any sideeffects *)
            else_String -> Function[data,
                (* extend objects space *)
                EventFire[o["Notebook"], else, data];
            ]
        }];

        (* submit *)
        o["Notebook", "Evaluator"][transaction];

    ];
    o
]

Options[WindowObj`Evaluate] = {"EvaluationContext" -> <||>}

WindowObj /: WindowObj`Serialize[n_WindowObj, OptionsPattern[] ] := Module[{props},
    props = {# -> n[#]} &/@ If[OptionValue["MetaOnly"], Complement[n["Properties"], {"EvaluationContext", "Socket","Properties","Icon","Self","Data", "Notebook", "Init", "After", "Before"}], Complement[n["Properties"], {"Socket", "EvaluationContext", "Properties","Icon","Self", "Notebook", "Init", "After", "Before"}] ];
    props = Join[props, {"Notebook" -> n["Notebook", "Hash"]}];
    props // Flatten // Association
]

Options[WindowObj`Serialize] = {"MetaOnly" -> False}

End[]
EndPackage[]