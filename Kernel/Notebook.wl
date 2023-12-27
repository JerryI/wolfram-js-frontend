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
    Print["Init"];
    o["Hash"] = uid;
    Print["Hash"];
    Notebook`HashMap[uid] = o;
    Print["CellObj"];
    o
]

Notebook`HashMap = <||>;
CreateType[Notebook, initNotebook, {"Evaluator"->Nothing, "Objects"-><||>, "Cells"->{}}]

Notebook /: EventHandler[n_Notebook, opts__] := EventHandler[n["Hash"], opts] 
Notebook /: EventFire[n_Notebook, opts__] := EventFire[n["Hash"], opts]
Notebook /: EventRemove[n_Notebook, opts__] := EventRemove[n["Hash"], opts] 


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
CellObj /: EventRemove[n_CellObj, opts__] := EventRemove[n["Hash"], opts] 

Notebook /: CellObj`FindCell[n_Notebook, pattern__] := With[{
    position = SequencePosition[n["Cells"], {pattern} ] // First // First
},
    n["Cells"][[position]]
]

CellObj`Serialize[n_CellObj, OptionsPattern[]] := Module[{props},
    props = {# -> n[#]} &/@ If[OptionValue["OnlyMeta"], Complement[n["Properties"], {"Properties","Icon","Self","Data", "Notebook", "Init", "After", "Before"}], Complement[n["Properties"], {"Properties","Icon","Self", "Notebook", "Init", "After", "Before"}]];
    props = Join[props, {"Notebook" -> n["Notebook", "Hash"]}];
    props // Flatten // Association
]

Options[CellObj`Serialize] = {"OnlyMeta" -> False}

OutputCellQ[o_CellObj] := o["Type"] === "Output"
InputCellQ[o_CellObj] := o["Type"] === "Input"

CellObj /: CellObj`Evaluate[o_CellObj] := Module[{transaction},
    Print["Submit cellobj"];
    If[!NullQ[ o["Notebook"] ],

        o["State"] = "Evaluation";
        EventFire[o, "State", "Evaluation"];

        transaction = Transaction[];
        transaction["Data"] = o["Data"];
        transaction["Ref"] = o;

        EventHandler[transaction, {"Result" -> Function[data,
            (* AFTER, BEFORE, TYPE, PROPS can be altered using provided meta-data from the transaction *)
            
            CellObj["Data"->data["Data"], "Notebook"->o["Notebook"], "After"->Sequence[o, ___?OutputCellQ], "Display"->"codemirror", "Type"->"Output"(*"" data["Meta"]*)]
        ],
            "Finish" -> Function[Null,
                o["State"] = "Idle";
                EventFire[o, "State", "Idle"];
            ],

            "Error" -> Function[error,
                o["State"] = "Idle";
                EventFire[o, "State", "Idle"];
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
    If[!NullQ[ o["Notebook"] ],
        If[o["Type"] === "Output", 
            (* delete just this one *)
            EventFire[o, "Destroy", o];
            EventFire[o["Notebook"], "Destroy Cell", o];

            o["Notebook"]["Cells"] = o["Notebook"]["Cells"] /. {o -> Nothing}; 
            CellObj`HashMap[o["Hash"] ] = .; 
        ,
            (* else if Input -> remove all next output cells *)
            With[{list = SequenceCases[o["Notebook"]["Cells"], {o, ___?OutputCellQ}] // First},
                Delete /@ (Drop[list, 1] // Reverse);
                EventFire[o, "Destroy", o];
                EventFire[o["Notebook"], "Destroy Cell", o];

                o["Notebook"]["Cells"] = o["Notebook"]["Cells"] /. {o -> Nothing};
                CellObj`HashMap[o["Hash"] ] = .; 
            ]
        ]
    ,
        CellObj`HashMap[o["Hash"] ] = .; 
    ];
]

End[]
EndPackage[]