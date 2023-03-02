BeginPackage["JerryI`WolframJSFrontend`Cells`"];

CellObj::usage = "to create CellObj[\"id\"->smth]"
CellObjFindLast::usage = "CellObjFindLast"
CellObjFindFirst::usage = "CellObjFindFirst"
CellObjFindParent::usage = "CellObjFindParent"
CellObjCreateChild::usage = "CellObjCreateChild"

CellObjCreateNext::usage = "CellObjCreateNext"
CellObjCreateAfter::usage = "CellObjCreateAfter"
CellObjRemoveAccurate::usage = "CellObjRemoveAccurate"
CellObjRemove::usage = "CellObjRemove"

CellObjRemoveAllNext::usage = "CellObjRemoveAllNext"
CellObjEvaluate::usage = "CellObjEvaluate"
CellObjGenerateTree::usage = "CellObjGenerateTree"

CellObjQuery::usage = "query"
CellObjPack::usage = "pack to association"
CellObjUnpack::usage = "assotiation to cellobj"

setCellID::usage = "convert string to cellObj"

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
CellObjRemoveAccurate[CellObj[cell_]] := Module[{},

    (* check if this is a parent cell *)

    If[CellObj[cell]["child"] =!= Null,
        Print["this is a parent cell"];
        (* check next and previous  *)
        If[CellObj[cell]["prev"] =!= Null,
            If[CellObj[cell]["next"] =!= Null,
                (* reconnect *)
                CellObj[cell]["prev"]["next"] = CellObj[cell]["next"];
                CellObj[cell]["next"]["prev"] = CellObj[cell]["prev"];
            ,
                (* reconnect *)
                CellObj[cell]["prev"]["next"] = Null;
            ];
            ,
            If[CellObj[cell]["next"] =!= Null,
                (* reconnect *)
                CellObj[cell]["next"]["prev"] = Null;
            ,
                (* !exceptional case! *)
                (* the LAST CELL of the notebook *)
                Print["last cell"];
                (* remove kids *)
                CellObjRemoveAllNext[CellObj[cell]["child"] ];
                CellObjRemove[CellObj[cell]["child"] ];
                CellObj[cell]["child"] = Null;        

                (* clear the content *)
                CellObj[cell]["data"] = "";
                JerryI`WolframJSFrontend`fireEvent["UpdateCell"][CellObj[cell] ];     
                Return[Null, Module];
            ];         
        ];

        (* remove kids quite *)
        CellObjRemoveAllNext[CellObj[cell]["child"], True];
        CellObjRemove[CellObj[cell]["child"], True];
        (* remove it *)
        CellObjRemove[CellObj[cell] ];
    ,

        (* we do not know *)
        (* might be a child or a parent with no kids *)

        If[CellObj[cell]["parent"] =!= Null,
            (* 100% a child *)
            Print["this is a kid cell"];
            (* check next *)
            If[CellObj[cell]["next"] =!= Null,
                (* reconnect *)
                CellObj[cell]["next"]["prev"] = Null;
                CellObj[cell]["next"]["parent"] = CellObj[cell]["parent"];
                CellObj[cell]["parent"]["child"] = CellObj[cell]["next"];
            ,
                CellObj[cell]["parent"]["child"] = Null;
            ];         

            (* remove it *)
            CellObjRemove[CellObj[cell] ];            

        ,
            (* we do not know *)
            Print["we do not know"];
            (* check next and previous  *)
            If[CellObj[cell]["prev"] =!= Null,
                If[CellObj[cell]["next"] =!= Null,
                    (* reconnect *)
                    CellObj[cell]["prev"]["next"] = CellObj[cell]["next"];
                    CellObj[cell]["next"]["prev"] = CellObj[cell]["prev"];
                ,
                    (* reconnect *)
                    CellObj[cell]["prev"]["next"] = Null;
                ];
                ,
                If[CellObj[cell]["next"] =!= Null,
                    (* reconnect *)
                    CellObj[cell]["next"]["prev"] = Null;
                ,
                    (* !exceptional case! *)
                    (* the LAST CELL of the notebook *)      

                    (* clear the content *)
                    CellObj[cell]["data"] = "";
                    JerryI`WolframJSFrontend`fireEvent["UpdateCell"][CellObj[cell] ];     
                    Return[Null, Module];
                ];         
            ];

            (* remove it *)
            CellObjRemove[CellObj[cell] ];

        ];
    ];

];


CellObj /:
CellObjRemove[CellObj[cell_], Quite_:False] := ( 
    If[!Quite, JerryI`WolframJSFrontend`fireEvent["RemovedCell"][CellObj[cell] ] ];

    Unset[CellObj[cell]["data"] ];
    Unset[CellObj[cell]["type"] ];
    Unset[CellObj[cell]["next"] ];
    Unset[CellObj[cell]["prev"] ];
    Unset[CellObj[cell]["parent"] ];
    Unset[CellObj[cell]["sign"] ];
    Unset[CellObj[cell]["props"] ];
    Unset[CellObj[cell]["child"] ];
    Unset[CellObj[cell]["display"] ];
);


CellObj /:
CellObjRemoveAllNext[CellObj[cell_], Quite_:False] := ( 
    If[CellObj[cell]["next"] =!= Null, 
        Module[{next = CellObj[cell]["next"]},
            While[next["next"] =!= Null, next = next["next"]];
            While[next =!= CellObj[cell], next = next["prev"]; CellObjRemove[next["next"], Quite]; ];
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
                            new["display"]  = display;

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

CellObjQuery[field_, dt_] := Module[{},
    Select[(Extract[#[[1]], {1, 0}] & /@ SubValues[CellObj]), Function[x, x[field] === dt] ]//DeleteDuplicates
];

getCellID[prop_] := If[prop === Null, Null, prop[[1]]];
setCellID[prop_] := If[prop === Null, Null, CellObj[prop] ];


CellObj /: 
CellObjPack[CellObj[cell_]] := (  
    <|  "id"->cell, 
        "type"      ->  CellObj[cell]["type"], 
        "data"      ->  CellObj[cell]["data"],
        "display"   ->  CellObj[cell]["display"],
        "sign"      ->  CellObj[cell]["sign"],

        "prev"      ->  getCellID[CellObj[cell]["prev"]],
        "next"      ->  getCellID[CellObj[cell]["next"]],
        "parent"    ->  getCellID[CellObj[cell]["parent"]],

        "child"     ->  getCellID[CellObj[cell]["child"]],
        "props"     ->  CellObj[cell]["props"]
    |>
);



CellObjUnpack[assoc_] := With[{id = assoc["id"]},  
    Print["Create cell"];
    CellObj[id]["type"] = assoc["type"];
    CellObj[id]["data"] = assoc["data"];

    CellObj[id]["display"] = assoc["display"];
    CellObj[id]["sign"] = assoc["sign"];
    CellObj[id]["prev"] = setCellID[assoc["prev"]];
    CellObj[id]["next"] = setCellID[assoc["next"]];

    CellObj[id]["parent"] = setCellID[assoc["parent"]];
    CellObj[id]["child"] = setCellID[assoc["child"]];

    CellObj[id]["props"] = assoc["props"];
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