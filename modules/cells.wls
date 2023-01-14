Options[CellObj] = {
    "type" -> "input",
    "child" -> Null,
    "parent" -> Null,
    "next" -> Null,
    "prev" -> Null,
    "display" -> Null,
    "data" -> Null,
    "storage" -> <||>,
    "sign" :> CreateUUID[]
};

CellObj[OptionsPattern[]] := With[{cell = CreateUUID[]}, 

	CellObj[cell]["type"   ] = OptionValue["type"];
    CellObj[cell]["child"  ] = OptionValue["child"];
    CellObj[cell]["parent" ] = OptionValue["parent"];
    CellObj[cell]["next"   ] = OptionValue["next"];
    CellObj[cell]["prev"   ] = OptionValue["prev"];
    CellObj[cell]["display"] = OptionValue["display"];
    CellObj[cell]["data"]    = OptionValue["data"];
    CellObj[cell]["sign"]    = OptionValue["sign"];
    CellObj[cell]["storage"]    = OptionValue["storage"];

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
CellObjCreateChild[CellObj[cell_]] := (  
    Module[{next = CellObj[cell]["child"], new = CellObj[]},
        If[next =!= Null,
            While[next["next"] =!= Null, next = next["next"] ];
            next["next"] = new;
            new["prev"] = next;        
        ,
            CellObj[cell]["child"] = new;
            new["parent"] = CellObj[cell];
            new["sign"] = CellObj[cell]["sign"];
        ];
        new
    ]  
);

CellObj /: 
CellObjCreateNext[CellObj[cell_]] := (  
    Module[{next = CellObj[cell], new = CellObj[]},
        While[next["next"] =!= Null, next = next["next"]];
        next["next"] = new;
        new["prev"] = next;
        new["sign"] = next["sign"];

        fireEvent["NewCell"][new];
        new
    ]  
);

CellObj /:
CellObjRemove[CellObj[cell_]] := ( 
    fireEvent["RemovedCell"][CellObj[cell]];
    fireEvent["ClearStorage"][CellObj[cell]];

    Unset[CellObj[cell]["data"]];
    Unset[CellObj[cell]["type"]];
    Unset[CellObj[cell]["next"]];
    Unset[CellObj[cell]["prev"]];
    Unset[CellObj[cell]["parent"]];
    Unset[CellObj[cell]["sign"]];
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


Options[CellObjEvaluate] = {
    "JSON" -> False,
    "callback" -> Null
};

CellObj /: 
CellObjEvaluate[CellObj[cell_], evaluator_, OptionsPattern[]] := (  
    Module[{exps = (*StringSplit[*){CellObj[cell]["data"]}(*, "\n"]*), parent},

        (*will break the chain if we try to evaluate a child cell*)
        If[(parent = CellObjFindParent[CellObj[cell]]) =!= Null,
            CellObjRemoveAllNext[CellObj[cell]];
            
            fireEvent["RemovedCell"][CellObj[cell]];

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

            (*fireEvent["CellMove"][CellObj[cell], parent];*)
            (*fireEvent["CellMorph"][CellObj[cell]];*)
            fireEvent["NewCell"][CellObj[cell]];

            ,

            (*if has a child*)
            If[CellObj[cell]["child"] =!= Null,
                CellObjRemoveAllNext[CellObj[cell]["child"]];
                CellObjRemove[CellObj[cell]["child"]];
                CellObj[cell]["child"] = Null;            
            ];            
        ];    



        With[{callback = OptionValue["callback"], fireLocalEvent=fireEvent},
            evaluator[#, $conversionTemplate, CellObj[cell]["storage"], Function[{result, st},
                If[result =!= "Null",

                    With[{new = CellObjCreateChild[CellObj[cell] ]},
                        new["data"] = result;
                        new["type"] = "output";
                        new["storage"] = st;

                        fireLocalEvent["NewCell"][new];
                    ]
                ]
            ] ]& /@ exps;
        ];
    ];  
);



CellObj /: 
CellObjGenerateTree[CellObj[cell_]] := (  
    fireEvent["NewCell"][CellObj[cell]];
    
    If[CellObj[cell]["child"] =!= Null, CellObjGenerateTree[CellObj[cell]["child"]]];
    If[CellObj[cell]["next"] =!= Null, CellObjGenerateTree[CellObj[cell]["next"]]];
);

Unprotect[FrontEndExecutable];
ClearAll[FrontEndExecutable];

SimpleEvaluator[exp_, rules_, storage_, callback_] := 
    Block[{$$$evaluated, $$$storage = <||>},
        Block[{FrontEndExecutable = Function[uid, ImportString[storage[uid], "ExpressionJSON"] ]},
            $$$evaluated = ToExpression[exp]
        ];

        With[{$$$result = $$$evaluated /.rules}, 
            callback@@{ToString[$$$result, InputForm], $$$storage} 
        ];   
    ];


