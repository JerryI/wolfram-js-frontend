BeginPackage["JerryI`WolframJSFrontend`Cells`"];

CellObj::usage = "to create CellObj[\"id\"->smth]"
CellObjFindLast::usage = "CellObjFindLast"
CellObjFindFirst::usage = "CellObjFindFirst"
CellObjFindParent::usage = "CellObjFindParent"
CellObjCreateChild::usage = "CellObjCreateChild"

CellObjCreateNext::usage = "CellObjCreateNext"
CellObjCreateAfter::usage = "CellObjCreateAfter"
CellObjRemoveFull::usage = "CellObjRemoveFull"
CellObjRemove::usage = "CellObjRemove"

CellObjRemoveAllNext::usage = "CellObjRemoveAllNext"
CellObjEvaluate::usage = "CellObjEvaluate"
CellObjGenerateTree::usage = "CellObjGenerateTree"

Begin["`Private`"]; 

Options[CellObj] = {
    "type" -> "input",
    "child" -> Null,
    "parent" -> Null,
    "next" -> Null,
    "prev" -> Null,
    "display" -> "codemirror",
    "lang" -> "mathematica",
    "data" -> Null,
    "props" -> <|"hidden"->False|>,
    "sign" :> CreateUUID[],
    "id" :> CreateUUID[]
};

CellObj[OptionsPattern[]] := With[{cell = OptionValue["id"]}, 

	CellObj[cell]["type"    ] = OptionValue["type"    ];
    CellObj[cell]["child"   ] = OptionValue["child"   ];
    CellObj[cell]["parent"  ] = OptionValue["parent"  ];
    CellObj[cell]["next"    ] = OptionValue["next"    ];
    CellObj[cell]["prev"    ] = OptionValue["prev"    ];
    CellObj[cell]["display" ] = OptionValue["display" ];
    CellObj[cell]["lang"    ] = OptionValue["lang"    ];
    CellObj[cell]["data"    ] = OptionValue["data"    ];
    CellObj[cell]["props"   ] = OptionValue["props"   ];
    CellObj[cell]["sign"    ] = OptionValue["sign"    ];

    CellObj[cell]
];

CellObj /: 
CellObjFindLast[CellObj[cell_]] := (
    Module[{next = CellObj[cell]},
        While[next["next"] =!= Null, next = next["next"] ];
        next
    ]   
);

CellObj /: 
CellObjFindFirst[CellObj[cell_]] := (
    Module[{prev = CellObj[cell]},
        While[prev["prev"] =!= Null, prev = prev["prev"] ];
        next
    ]   
);

CellObj /: 
CellObjFindParent[CellObj[cell_]] := (  
    Module[{next = CellObj[cell]},
        If[cell["parent"] === Null,
            While[next["prev"] =!= Null, next = next["prev"] ];   
        ];
        next["parent"]
    ]  
);

CellObj /: 
CellObjCreateChild[CellObj[cell_], uid_:CreateUUID[]] := (  
    Module[{child = CellObj[cell]["child"], new},
        If[child =!= Null,
            new = CellObjCreateNext[child, uid];      
        ,
            new = CellObj["id"->uid];
            CellObj[cell]["child"] = new;
        ];
        new["parent"] = CellObj[cell];
        new["sign"] = CellObj[cell]["sign"];
        new
    ]  
);

CellObj /: 
CellObjCreateNext[CellObj[cell_], uid_:CreateUUID[]] := (  
    Module[{next = CellObj[cell], new = CellObj["id"->uid]},
        While[next["next"] =!= Null, next = next["next"]];
        next["next"] = new;
        new["prev"] = next;
        new["sign"] = next["sign"];

        JerryI`WolframJSFrontend`fireEvent["NewCell"][new];
        new
    ]  
);

CellObj /: 
CellObjCreateAfter[CellObj[ucell_]] := (  
    Module[{new = CellObj[], cell = ucell, parent = CellObjFindParent[CellObj[ucell]]},
        If[parent =!= Null, cell = parent[[1]]];
        
        If[CellObj[cell]["next"] =!= Null,
            CellObj[cell]["next"]["prev"] = new;
            new["next"] = CellObj[cell]["next"];
        ];
        CellObj[cell]["next"] = new;
        new["prev"] = CellObj[cell];

        new["sign"] = CellObj[cell]["sign"];
        JerryI`WolframJSFrontend`fireEvent["NewCell"][new];
        new
    ]  
);

CellObj /:
CellObjRemoveFull[CellObj[cell_]] := Module[{}, 
    Print[notebooks[CellObj[cell]["sign"], "cell"]];
    If[notebooks[CellObj[cell]["sign"], "cell"] === CellObj[cell],
        If[!NullQ[CellObj[cell]["next"]],
            CellObj[cell]["next"]["prev"] = Null;
            notebooks[CellObj[cell]["sign"], "cell"] = CellObj[cell]["next"];
            CellObjRemove[CellObj[cell]];
            Return[$Ok, Module];
        ,
            JerryI`WolframJSFrontend`fireEvent["CellError"][cell, "There must be at least one cell in the notebook"];
            Return[$Failed, Module];
        ]
    ];

    If[!NullQ[CellObj[cell]["parent"]],
        CellObj[cell]["parent"]["child"] = Null;
    ];
    
    If[!NullQ[CellObj[cell]["next"]],
        If[!NullQ[CellObj[cell]["prev"]],
            CellObj[cell]["next"]["prev"] = CellObj[cell]["prev"];
            CellObj[cell]["prev"]["next"] = CellObj[cell]["next"];
        ,
            CellObj[cell]["next"]["prev"] = Null;
        ];
    ,
        If[!NullQ[CellObj[cell]["prev"]],
            CellObj[cell]["prev"]["next"] = Null;
        ];    
    ];    

    If[!NullQ[CellObj[cell]["child"]],
        CellObjRemoveFull[CellObj[cell]["child"]];
    ];

    CellObjRemove[CellObj[cell]];
];

CellObj /:
CellObjRemove[CellObj[cell_]] := ( 
    JerryI`WolframJSFrontend`fireEvent["RemovedCell"][CellObj[cell]];
    JerryI`WolframJSFrontend`fireEvent["ClearStorage"][CellObj[cell]];

    Unset[CellObj[cell]["data"]];
    Unset[CellObj[cell]["type"]];
    Unset[CellObj[cell]["next"]];
    Unset[CellObj[cell]["prev"]];
    Unset[CellObj[cell]["parent"]];
    Unset[CellObj[cell]["sign"]];
    Unset[CellObj[cell]["props"]];
    Unset[CellObj[cell]["dump"]];
    Unset[CellObj[cell]["storage"]];

    If[CellObj[cell]["child"] =!= Null,
        CellObjRemoveAllNext[CellObj[cell]["child"]];
        CellObjRemove[CellObj[cell]["child"]];
    ];

    Unset[CellObj[cell]["child"]];
    Unset[CellObj[cell]["display"]];
);

CellObj /:
CellObjRemoveAllNext[CellObj[cell_]] := ( 
    If[CellObj[cell]["next"] =!= Null, 
        Module[{next = CellObj[cell]["next"]},
            While[next["next"] =!= Null, next = next["next"]];
            While[next =!= CellObj[cell], next = next["prev"]; CellObjRemove[next["next"]]; ];
            CellObj[cell]["next"] = Null;
        ]
    ]  
);


CellObj /: 
CellObjEvaluate[CellObj[cell_], evaluators_] := Module[{expr, evaluator},  
    expr = CellObj[cell]["data"];
    evaluator = Which@@Flatten[ReplaceAll[evaluators, Rule[x_,y_] :> List[x[expr],y]]];
    
    
    With[{errors = evaluator["SyntaxChecker"][expr]},
        If[!NullQ[errors],
            JerryI`WolframJSFrontend`fireEvent["CellError"][cell, errors];
            Return[$Failed, Module];
        ];
    ];

    Module[{parent},

        (*will break the chain if we try to evaluate a child cell*)
        If[(parent = CellObjFindParent[CellObj[cell]]) =!= Null,
            CellObjRemoveAllNext[CellObj[cell]];
            
            (*JerryI`WolframJSFrontend`fireEvent["RemovedCell"][CellObj[cell]];*)

            (*dont touch the previuos children*)
            If[CellObj[cell]["prev"] =!= Null, CellObj[cell]["prev"]["next"] = Null, parent["child"] = Null];

            (*reassign*)
            Print[StringTemplate["assign parent `` as previous cell with respect to ``"][parent[[1]], cell] ];
            CellObj[cell]["prev"] = parent;
            Print[StringTemplate["assign `` as next"][parent["next"] ] ];

            CellObj[cell]["next"] = parent["next"];

            If[parent["next"] =!= Null,
                parent["next"]["prev"]  = CellObj[cell];
            ];
            
            parent["next"] = CellObj[cell];
            
            CellObj[cell]["type"] = "input";
            CellObj[cell]["parent"] = Null;

            JerryI`WolframJSFrontend`fireEvent["CellMove"][CellObj[cell], parent];
            JerryI`WolframJSFrontend`fireEvent["CellMorph"][CellObj[cell]];

            ,

            (*if has a child*)
            If[CellObj[cell]["child"] =!= Null,
                CellObjRemoveAllNext[CellObj[cell]["child"]];
                CellObjRemove[CellObj[cell]["child"]];
                CellObj[cell]["child"] = Null;            
            ];            
        ];    


        With[{fireLocalEvent=JerryI`WolframJSFrontend`fireEvent},
            (   
                Print[StringTemplate["Eval: ``"][#]];
                fireLocalEvent["Query++"][CellObj[cell]];
                evaluator["Evaluator"][#, CellObj[cell]["sign"], Function[{result, uid, display, epilog},
                    If[result =!= "Null" && StringLength[result] > 0,
                        With[{new = CellObjCreateChild[CellObj[cell], uid]},
                            new["data"]     = result;
                            new["type"]     = "output";

                            epilog[new["sign"]];
                            fireLocalEvent["NewCell"][new];
                        ]
                    ];
                    fireLocalEvent["Query--"][CellObj[cell]];
                ]];
            )& /@ Flatten[{evaluator["Epilog"][expr]}];
        ];
    ];  
];


CellObj /: 
CellObjGenerateTree[CellObj[cell_]] := (  
    console["log", "> CellObjGenerateTree call"];
    JerryI`WolframJSFrontend`fireEvent["NewCell"][CellObj[cell]];
    
    If[CellObj[cell]["child"] =!= Null, CellObjGenerateTree[CellObj[cell]["child"]]];
    If[CellObj[cell]["next"] =!= Null, CellObjGenerateTree[CellObj[cell]["next"]]];
);

End[];
EndPackage[];