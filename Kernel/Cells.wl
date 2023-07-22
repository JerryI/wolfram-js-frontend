BeginPackage["JerryI`WolframJSFrontend`Cells`", {"JerryI`WolframJSFrontend`Utils`"}];

(* 
    ::Only for MASTER kernel::
    
    Abstract cells operation package 
*)

CellObj::usage  = "class constructor"
CellList::usage = "list"

CellObjSave::usage = ""

CellListRemoveAllNextOutput::usage = ""
CellListAddNewInput::usage = ""
CellListAddNewOutput::usage = ""
CellListRemoveAccurate::usage = ""
CellListRemove::usage = ""
CellObjEvaluate::usage = ""
CellListTree::usage = ""

CellListAddNewAfter::usage = ""
CellListAddNewAfterAny::usage = ""

CellListUnpack::usage = ""
CellListUnpackLegacy::usage = ""
CellListPack::usage = ""


(*  CellObjEvaluate[CellObj[uid], evaluators]  
    
    where evaluators is a list of rules, which 
    - has a criteria to be chosen 
    - has a syntax-check function
    - has an evaluator function

    for example
    {
        MardownQ -> <|"SyntaxChecker" -> (True&), 
            "Epilog"->(#&), "Prolog"->(#&), 
            "Evaluator"->MarkdownProcessor
        |>
    }
*)


Begin["`Private`"]; 

Options[CellObj] = {
    "type" -> "input",
    "display" -> "codemirror",
    "data" -> Null,
    "props" -> <|"hidden"->False|>,
    "sign" :> CreateUUID[],
    "id" :> CreateUUID[],
    "state" -> "idle"
};

CellObj[OptionsPattern[]] := With[{cell = OptionValue["id"]}, 

	CellObj[cell]["type"    ] = OptionValue["type"    ];
    CellObj[cell]["display" ] = OptionValue["display" ];
    CellObj[cell]["data"    ] = OptionValue["data"    ];
    CellObj[cell]["props"   ] = OptionValue["props"   ];
    CellObj[cell]["sign"    ]  = OptionValue["sign"    ];
    CellObj[cell]["state"    ] = OptionValue["state"    ];

    CellObj[cell]
];

CellListPush[list_, CellObj[cell_]] := (
    CellList[list] = {CellList[list], CellObj[cell]} // Flatten;
);

CellListRemoveAllNextOutput[CellObj[cell_], list_] := Module[{pos},
    Print["removing all outputs of a cell"];
    pos = Position[CellList[list], CellObj[cell]] // Flatten // First;
    pos = pos + 1;

    While[True,
        If[pos <= Length[CellList[list]],
            If[CellList[list][[pos]]["type"] =!= "input",
                Print["removed!"];
                CellListRemove[list, CellList[list][[pos]]];
            ,
                Break[];
            ];
        ,
            Break[];    
        ];
    ];
];

CellListAddNewAfter[cell_] := With[{sign = cell["sign"]},
    CellListAddNewInput[sign, cell, CellObj["data"->"", "type"->"input", "sign"->sign]];
];

CellListAddNewAfterAny[cell_] := With[{sign = cell["sign"]},
    CellListAddNewInputAny[sign, cell, CellObj["data"->"", "type"->"input", "sign"->sign]];
];

CellListAddNewInput[list_, CellObj[cell_], CellObj[new_]] := Module[{pos},
    pos = Position[CellList[list], CellObj[cell]] // Flatten // First;

    If[pos === Length[CellList[list]],
        (* last cell in the list *)
        CellList[list] = Insert[CellList[list], CellObj[new], pos + 1];

        JerryI`WolframJSFrontend`fireEvent["AddCellAfter"][ CellObj[new], CellList[list][[pos]] ];

        Return[Null, Module];
    ];   
    pos = pos + 1;

    While[CellList[list][[pos]]["type"] === "output",
        Print["looking for the last output..., pos: "<>ToString[pos]];
        pos = pos + 1;
        If [pos > Length[CellList[list]], Break[]];
    ];

    CellList[list] = Insert[CellList[list], CellObj[new], pos];

    JerryI`WolframJSFrontend`fireEvent["AddCellAfter"][ CellObj[new], CellList[list][[pos - 1]] ];
];

CellListAddNewInputAny[list_, CellObj[cell_], CellObj[new_]] := Module[{pos},
    pos = Position[CellList[list], CellObj[cell]] // Flatten // First;

    If[pos === Length[CellList[list]],
        (* last cell in the list *)
        CellList[list] = Insert[CellList[list], CellObj[new], pos + 1];

        JerryI`WolframJSFrontend`fireEvent["AddCellAfter"][ CellObj[new], CellList[list][[pos]] ];

        Return[Null, Module];
    ];   
    pos = pos + 1;

    CellList[list] = Insert[CellList[list], CellObj[new], pos];
    
    If[CellObj[new]["type"] === "input", 
        CellObj[new]["type"] = "output";
        (* a hack to force CM to reuild the structure *)
        console["log", "rebuilding structure..."];
        JerryI`WolframJSFrontend`fireEvent["AddCellAfter"][ CellObj[new], CellList[list][[pos - 1]] ];
        JerryI`WolframJSFrontend`fireEvent["CellMorphInput"][CellObj[new]];
        CellObj[new]["type"] = "input";

        Return[Null, Module];
    ];

    
];

CellListAddNewOutput[list_, CellObj[cell_], CellObj[new_]] := Module[{pos},
    Print["Add new output"];
    Print[{list, cell, new}];
    pos = Position[CellList[list], CellObj[cell]] // Flatten // First;

    If[pos === Length[CellList[list]],
        (* last cell in the list *)
        Print["Last Cell in the list"];
        CellList[list] = Insert[CellList[list], CellObj[new], pos + 1];

        JerryI`WolframJSFrontend`fireEvent["AddCellAfter"][ CellObj[new], CellList[list][[pos]] ];

        Return[Null, Module];
    ];   
    pos = pos + 1;

    While[CellList[list][[pos]]["type"] =!= "input",
        Print["looking for the last output..., pos: "<>ToString[pos]];
        pos = pos + 1;
        If [pos > Length[CellList[list]], Break[]];
    ];

    CellList[list] = Insert[CellList[list], CellObj[new], pos];

    JerryI`WolframJSFrontend`fireEvent["AddCellAfter"][ CellObj[new], CellList[list][[pos - 1]] ];
];

CellListRemoveAccurate[CellObj[cell_]] := With[{sign = CellObj[cell]["sign"]},
    CellListRemoveAllNextOutput[CellObj[cell], sign];
    CellListRemove[sign, CellObj[cell]];
]

CellListRemove[list_, CellObj[cell_]] := (
    If[Length[CellList[list]] > 1,
        JerryI`WolframJSFrontend`fireEvent["RemovedCell"][CellObj[cell]];
        CellList[list] = Delete[CellList[list], Position[CellList[list], CellObj[cell]]//Flatten//First];

        CellObjRemove[CellObj[cell]];
    ,
        Print["Cannot remove the last cell"];
    ];
);

CellObj /:
CellObjRemove[CellObj[cell_]] := ( 
    Unset[CellObj[cell]["data"] ];
    Unset[CellObj[cell]["type"] ];
    Unset[CellObj[cell]["sign"] ];
    Unset[CellObj[cell]["props"] ];
    Unset[CellObj[cell]["display"] ];
    Unset[CellObj[cell]["state"] ];
);

CellObj /: 
CellObjSave[CellObj[cell_], content_] := (
    If[CellObj[cell]["type"] === "output",
        JerryI`WolframJSFrontend`fireEvent["CellMorphInput"][CellObj[cell]];
        CellObj[cell]["type"] = "input";
    ];

    CellObj[cell]["data"] = content;
)

CellObj /: 
CellObjEvaluate[CellObj[cell_], evaluators_] := Module[{expr, evaluator},  
    expr = CellObj[cell]["data"];
    evaluator = Which@@Flatten[ReplaceAll[evaluators, Rule[x_,y_] :> List[x[expr],y]]];
    
    
    With[{errors = evaluator["SyntaxChecker"][expr]},
        Print["Errors:"];
        Print[errors];
        If[!TrueQ[{errors}//Flatten//First],
            JerryI`WolframJSFrontend`fireEvent["CellError"][cell, errors];
            Return[$Failed, Module];
        ];
    ];

    Module[{parent},
        CellListRemoveAllNextOutput[CellObj[cell], CellObj[cell]["sign"]];

        (*will break the chain if we try to evaluate a child cell*)
        If[CellObj[cell]["type"] === "output",
            JerryI`WolframJSFrontend`fireEvent["CellMorphInput"][CellObj[cell]];
            CellObj[cell]["type"] = "input";          
        ];    

        With[{fireLocalEvent=JerryI`WolframJSFrontend`fireEvent, list = Flatten[{evaluator["Epilog"][expr]}], length = Length[Flatten[{evaluator["Epilog"][expr]}]]},
            CellObj[cell]["state"] = "pending";
            fireLocalEvent["UpdateState"][CellObj[cell] ];

            MapIndexed[(   
                Print[StringTemplate["Eval: ``"][#1]];

                evaluator["Evaluator"][#1, CellObj[cell]["sign"], Function[{result, uid, display, epilog},
                    If[result =!= "Null" && StringLength[result] > 0,
                        With[{new = CellObj["sign"->CellObj[cell]["sign"]]},

                            new["data"]     = result;
                            new["type"]     = "output";
                            new["display"]  = display;

                            epilog[new["sign"]];
                            Block[{JerryI`WolframJSFrontend`fireEvent = fireLocalEvent},
                                CellListAddNewOutput[CellObj[cell]["sign"], CellObj[cell], new];
                            ]
                        ]
                    ,
                        epilog[CellObj[cell]["sign"]];
                    ];

                    

                    If[#2[[1]] === length,
                        CellObj[cell]["state"] = "idle";
                        fireLocalEvent["UpdateState"][CellObj[cell]];
                    ];

                ]];
            )& , list];
        ];
    ];  
];

CellListPack[uid_String] := Module[{},
    <|
        "id"            -> #[[1]],
        "type"          -> #["type"],
        "data"          -> #["data"],
        "display"       -> #["display"],
        "sign"          -> #["sign"],
        "props"         -> #["props"]
    |> &/@ CellList[uid]
];

CellListUnpackLegacy[data_, first_] := Module[{},
    CellObjUnpack /@ data;

    CellList[CellObj[first]["sign"]] = {};

    CellListTreeLegacy[CellObj[first], CellObj[first]["sign"]];
    CellList[CellObj[first]["sign"]] = CellList[CellObj[first]["sign"]] // Flatten;

]

CellListUnpack[data_] := Module[{sign = data[[1]]["sign"]},
    CellList[sign] = CellObj["id"->#["id"], "data"->#["data"], "display"->#["display"], "type"->#["type"], "sign"->sign, "props"->#["props"]] &/@ data;
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
    CellObj[id]["id"] = id;
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

CellListTree[list_] := (  
    JerryI`WolframJSFrontend`fireEvent["NewCell"][#] &/@ CellList[list];
);

CellObj /:
CellListTreeLegacy[CellObj[id_], list_] := (  
    CellList[list] = {CellList[list], CellObj[id]};
    If[CellObj[id]["child"] =!= Null, CellListTreeLegacy[CellObj[id]["child"], list]];
    If[CellObj[id]["next"] =!= Null, CellListTreeLegacy[CellObj[id]["next"], list]];
);

End[];
EndPackage[];