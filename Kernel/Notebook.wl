BeginPackage["JerryI`Notebook`", {"JerryI`Misc`Events`", "KirillBelov`Objects`", "JerryI`Notebook`Transactions`"}]

Notebook::usage = "Notebook[opts__] _Notebook creates an notebook object."
(* :: opts ::                       *)
(* "Evaluator" ->                   *)

(* :: Events ::                     *)
(* "New Cell" -> CellObj            *)
(* "Destroy Cell" -> CellObj        *)
(* _else redirected from Transaction*)

CellObj::usage = "CellObj[opts__] _CellObj creates a new cell"
(* :: opts ::                       *)
(* "Notebook" ->      _Notebook     *)
(* "Type" ->          "Input"       *)
(* "Display" ->     "codemirror"    *)
(* "UID" ->     Null | _String      *)
(* "State" ->       "Idle"          *)
(* "Data"   ->         _String      *)
(* "After"  ->    Null | _CellObj   *)
(* "Before"  ->   Null | _CellObj   *)
(* "Props"   ->   <||>              *)

(* :: UpValues :: *)
(* CellObj`Evaluate[o_CellObj]  *)
(* Delete[o_CellObj]  *)

(* :: Events ::                     *)
(* "Destroy" -> CellObj             *)
(* "State" -> _                     *)
(* "Error" -> _                     *)

OutputCellQ::usage = "Apply on a CellObj to determine the type"
InputCellQ::usage = "Apply on a CellObj to determine the type"



Begin["`Private`"]

NullQ[any_] := any === Null

Unprotect[Notebook]
ClearAll[Notebook]

Unprotect[CellObj]
ClearAll[CellObj]

initNotebook[o_] := With[{uid = CreateUUID[]},
    o["Hash"] = uid;
    Notebook`HashMap[uid] = o;
    o
]

Notebook`HashMap = <||>;
CreateType[Notebook, initNotebook, {"FrontendObjects"-><||>, "Cells"->{}}]

Notebook /: EventHandler[n_Notebook, opts__] := EventHandler[n["Hash"], opts] 
Notebook /: EventFire[n_Notebook, opts__] := EventFire[n["Hash"], opts]
Notebook /: EventClone[n_Notebook] := EventClone[n["Hash"]]
Notebook /: EventRemove[n_Notebook, opts__] := EventRemove[n["Hash"], opts] 

Notebook`Serialize[n_Notebook] := Module[{props},
    props = {# -> n[#]} &/@ Complement[n["Properties"], {"Hash", "WebSocketQ", "Evaluator", "Cells", "Properties","Icon","Self", "Init", "Kernel"}];
    props // Flatten // Association
]

Notebook`Deserialize[n_Association] := With[{notebook = Notebook[]},
    (notebook[#] = n[#]) &/@ Complement[Keys[n], {"Hash"}]; 
    notebook
]

Notebook`Sockets = <||>;
Notebook /: Notebook`Sockets`Assign[n_Notebook, value_] := (
    Notebook`Sockets[value] = n;
    n["Client"] = value;
)

(*
    (Notebook <-> Cells) merged
    Notebook -> Evaluator --> Processors
             -> Evaluator --> Kernel

    ALL OF THEM CAN GENERATE EVENTS      
*)


initCell[o_] := Module[{uid = CreateUUID[]},
    Print["Init cellobj"];

    o["Hash"] = uid;
    CellObj`HashMap[uid] = o;

    (* if notebook is specified -> insert it into the cells list and fire event *)

    (* After or Before can be a sequence pattern ! *)

    If[!NullQ[ o["Notebook"] ],
        If[!TrueQ[NullQ[ o["After"]] ],
            With[{position = SequencePosition[o["Notebook", "Cells"], {o["After"]} ] // First // Last},
                o["Notebook", "Cells"] = Insert[o["Notebook", "Cells"],  o, position + 1];
            ];
        ,
            If[!TrueQ[NullQ[ o["Before"] ]],
                With[{position = SequencePosition[o["Notebook", "Cells"], {o["Before"]} ] // First // First},
                    o["Notebook", "Cells"] = Insert[o["Notebook", "Cells"],  o, position];
                ];
            ,
                (* as the last one *)
                o["Notebook", "Cells"] = Append[o["Notebook", "Cells"],  o];
            ];
        ];

        EventFire[o["Notebook"], "New Cell", o]; 
    ];
    o
]

CellObj`HashMap = <||>;
CreateType[CellObj, initCell, {"Notebook"->Null, "UID"->Null, "Data"->"", "State"->"Idle", "Props"-><||>, "Display"->"codemirror", "Type"->"Input", "After"->Null, "Before"->Null}]

CellObj /: EventHandler[n_CellObj, opts__] := EventHandler[n["Hash"], opts] 
CellObj /: EventFire[n_CellObj, opts__] := EventFire[n["Hash"], opts]
CellObj /: EventClone[n_CellObj] := EventClone[n["Hash"] ]
CellObj /: EventRemove[n_CellObj, opts__] := EventRemove[n["Hash"], opts] 

Notebook /: CellObj`FindCell[n_Notebook, pattern__] := With[{
    position = SequencePosition[n["Cells"], {pattern} ] // First // First
},
    n["Cells"][[position]]
]

CellObj`Serialize[n_CellObj, OptionsPattern[]] := Module[{props},
    props = {# -> n[#]} &/@ If[OptionValue["MetaOnly"], Complement[n["Properties"], {"Properties","Icon","Self","Data", "Notebook", "Init", "After", "Before"}], Complement[n["Properties"], {"Properties","Icon","Self", "Notebook", "Init", "After", "Before"}] ];
    props = Join[props, {"Notebook" -> n["Notebook", "Hash"]}];
    props // Flatten // Association
]

CellObj`Deserialize[assoc_Association, opts___] := With[{cell = CellObj[], list = Association[opts]},
    (cell[#] = assoc[#]) &/@ Complement[Keys[assoc], {"Hash"}];
    (cell[#] = list[#])  &/@ Keys[list];
    cell
]

Options[CellObj`Serialize] = {"MetaOnly" -> False}

OutputCellQ[o_CellObj] := o["Type"] === "Output"
InputCellQ[o_CellObj] := o["Type"] === "Input"

CellObj`SelectCells[list_List, pattern__] := With[{seq = SequencePosition[list, List[pattern] ] // Flatten},
    If[Length[seq] =!= 0,
        list[[ seq[[1]]+1 ;; seq[[2]] ]]
    ,
        {}
    ]
];

CellObj /: CellObj`Evaluate[o_CellObj] := Module[{transaction},
    Print["Submit cellobj"];
    If[!NullQ[ o["Notebook"] ],

        o["State"] = "Evaluation";
        EventFire[o, "State", "Evaluation"];

        transaction = Transaction[];
        transaction["Data"] = o["Data"];
        transaction["Ref"] = o;

        (* find any output cell after *)
        With[{seq = SequencePosition[o["Notebook", "Cells"], {Sequence[o, __?OutputCellQ]}] // Flatten},
            If[Length[seq] =!= 0,
                Delete /@ (o["Notebook", "Cells"][[ seq[[1]]+1 ;; seq[[2]] ]])
            ];
        ];



        EventHandler[transaction, {"Result" -> Function[data,
            (* AFTER, BEFORE, TYPE, PROPS can be altered using provided meta-data from the transaction *)

            If[data["Data"] != "Null",
                If[KeyExistsQ[data, "Meta"],
                    CellObj["Data"->data["Data"], "Notebook"->o["Notebook"], data["Meta"], "After"->Sequence[o, ___?OutputCellQ], "Display"->"codemirror", "Type"->"Output"(*"" data["Meta"]*)]
                ,
                    CellObj["Data"->data["Data"], "Notebook"->o["Notebook"], "After"->Sequence[o, ___?OutputCellQ], "Display"->"codemirror", "Type"->"Output"(*"" data["Meta"]*)]
                ]
            ];
        ],
            "Finished" -> Function[Null,
                o["State"] = "Idle";
                Echo["Finished!"];
                EventFire[o, "State", "Idle"];
            ],

            "Error" -> Function[error,
                o["State"] = "Idle";
                EventFire[o, "State", "Idle"];
                Echo["Error in evalaution... check syntax"];
                EventFire[o["Notebook"], "CellError", {o, error}];
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

CellObj /: Delete[o_CellObj] := Module[{},
    Print[">> delete cell"];
    If[!NullQ[ o["Notebook"] ],
        If[o["Type"] === "Output", 
            (* delete just this one *)
            EventFire[o, "Destroy", o];
            EventFire[o["Notebook"], "Remove Cell", o];
            With[{n = o["Notebook"]},
                n["Cells"] = n["Cells"] /. {o -> Nothing};
            ];
            CellObj`HashMap[o["Hash"] ] = .; 
        ,
            (* else if Input -> remove all next output cells *)
            With[{list = SequenceCases[o["Notebook"]["Cells"], {o, ___?OutputCellQ}] // First, n = o["Notebook"]},
                Delete /@ (Drop[list, 1] // Reverse);
                EventFire[o, "Destroy", o];
                EventFire[o["Notebook"], "Remove Cell", o];

                n["Cells"] = n["Cells"] /. {o -> Nothing};
                CellObj`HashMap[o["Hash"] ] = .; 
            ]
        ]
    ,
        CellObj`HashMap[o["Hash"] ] = .; 
    ];
]

End[]
EndPackage[]