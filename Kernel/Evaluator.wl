(* 
  ::Only for SECONDARY kernel::

  Default evaluators package 
  used by the remote/local Kernel

  - Wolfram Language with WebObjects` support
  - Template postprocessor
*)

(* dynamic ovveride *)
Unprotect[Dynamic]
ClearAll[Dynamic]

SetAttributes[Dynamic, HoldFirst]

SetAttributes[Offload, HoldFirst]

(* markers and instances *)

$NumberMarks = False

NotebookStore[key_] := AskMaster[Global`NotebookStoreOperate["Get", key]] // ReleaseHold
NotebookStore /: Set[NotebookStore[key_], data_] := AskMaster[Global`NotebookStoreOperate["Set", key, data // Hold]];
NotebookStore /: Keys[NotebookStore] := AskMaster[Global`NotebookStoreOperate["Keys"]];

Protect[NotebookStore]

Unprotect[Select];
Select[FrontEndInstances, MetaMarker[label_]] ^:= Module[{},
  AskMaster[Global`NotebookAskFront[FindMetaMarker[label]]]
]; 

Global`$out = Null;

(* global scope *)
SetAttributes[SetFrontEndObject, HoldFirst];
SetAttributes[FrontEndRef, HoldFirst];

(* autoconvertion of the frontend object back to the original expressions *)
FrontEndExecutableWrapper[uid_] :=  (Print["Importing string"]; ImportString[
  Function[res, If[!StringQ[res], 
                  JerryI`WolframJSFrontend`Evaluator`objects[uid] = AskMaster[Global`NotebookGetObjectForMe[uid]];
                  JerryI`WolframJSFrontend`Evaluator`objects[uid]["json"]
                  ,
                  res
    ]
  ] @ (JerryI`WolframJSFrontend`Evaluator`objects[uid]["json"])
, "ExpressionJSON"] // ReleaseHold );

FrontEndInlineExecutableWrapper[str_String] := str // Uncompress // ReleaseHold

IconizeWrapper[expr_] := expr

FrontEndRef[FrontEndExecutableWrapper[uid_]] := FrontEndExecutableHold[uid];
FrontEndRef[FrontEndExecutable[uid_]]        := FrontEndExecutableHold[uid];



(* exceptional case, when the frontened object is set *)
SetFrontEndObject[FrontEndExecutableWrapper[uid_], expr_] ^:= SetFrontEndObject[uid, expr];
Set[FrontEndExecutableWrapper[uid_], expr_] ^:= (SetFrontEndObject[uid, expr]//SendToFrontEnd);

SetFrontEndObject[FrontEndRef[uid_], expr_] ^:= SetFrontEndObject[uid, expr];
Set[FrontEndRef[uid_], expr_] ^:= (SetFrontEndObject[uid, expr]//SendToFrontEnd);

(* special post-handler, only used for upvalues *)
CM6Form[e_] := e

Unprotect[TemplateBox]
ClearAll[TemplateBox]
TemplateBox[list_List, "RowDefault"] := CM6Grid[{list}]

ToCM6Boxes[expr_] := StringReplace[(expr // ToBoxes) /. Global`$CMReplacements // ToString, {"\[NoBreak]"->"", "\[Pi]"->"$Pi$"}]

ToCM6Boxes[NoBoxes[expr_]] ^:= StringReplace[ToString[expr, InputForm], {"\[NoBreak]"->"", "\[Pi]"->"$Pi$"}]

(* iconize *)
Unprotect[Iconize]
ClearAll[Iconize]

(* unsupported tagbox *)
RowBoxToCM[x_List, y___] := StringJoin @@ (ToString[#] & /@ x)
CMGrid[x_List, y__] := CMGrid[x]
TagBoxToCM[x_, y__] := x




(* on-output convertion *)
$CMReplacements = {TemplateBox[list_, RowDefault] :> CM6Grid[{list}], RowBox -> RowBoxToCM, SqrtBox -> CM6Sqrt, FractionBox -> CM6Fraction, 
 GridBox -> CM6Grid, TagBox -> TagBoxToCM, SubscriptBox -> CM6Subscript, SuperscriptBox -> CM6Superscript}

(* on-input convertion *)
$CMExpressions = {
        Global`FrontEndExecutable -> Global`FrontEndExecutableWrapper,
        Global`FrontEndInlineExecutable -> Global`FrontEndInlineExecutableWrapper,
        Global`CM6Sqrt -> Sqrt,
        Global`CM6Fraction -> Global`CM6FractionWrapper,
        Global`CM6Grid -> Identity,
        Global`CM6Subscript -> Subscript,
        Global`CM6Superscript -> Power}

CM6FractionWrapper[x_,y_] := x/y;

Iconize[expr_] := Module[{compressed = Hold[IconizeWrapper[expr]]//Compress},
  If[StringLength[compressed] > 39400,
    Message["The given expression is too large even being compressed using gzip"];
    With[{name = "iconized-"<>StringTake[CreateUUID[], 5]<>".wl"},
      Export[name, expr];
      Hold[Get[name]]
    ]
  ,
    Global`$ignoreLongStrings = True; 
    Global`FrontEndInlineExecutable[compressed]
  ]
]

ExprObjectExport[expr_, uid_String] := CreateFrontEndObject[expr, uid]

EventObject /: MakeBoxes[EventObject[assoc_], StandardForm] := 
 With[{$ouid = CreateUUID[]}, 
  If[KeyExistsQ[assoc, "view"], 
   Global`$NewDefinitions[$ouid] = <|
     "json" -> 
      ExportString[assoc["view"], "ExpressionJSON", "Compact" -> 0], 
     "date" -> Now|>;

   $ExtendDefinitions[$ouid, Global`$NewDefinitions[$ouid]];
   "FrontEndExecutable["<>MakeBoxes[$ouid, StandardForm]<>"]", 
  (*ELSE*)
   "EventObject["<>MakeBoxes[assoc, StandardForm]<>"]"
  ]
]

BeginPackage["JerryI`WolframJSFrontend`Evaluator`", {"JerryI`WSP`"}];

(* going to be executed on the remote or local kernels *)

WolframEvaluator::usage = "WolframEvaluator[] a basic mathematica kernel, which executes the commands. Can be run on Local or on Remote kernel"
(*
  WolframEvaluator[::expression string::, ::blocks or not the output::, ::signature, i.e. notebook ID::, ::type::]
  accepts the ::callback function:: as a subvalue, which prevents it from the evaluation on the transport stage
*)
TemplateEvaluator::usage = "used for custom built cell types. uses WSP engine"
CellPrologOption::usage = "CellPrologOption[] used for overriding cell's id"


InternalGetObject::usage = "internal command"


Begin["`Private`"]; 



(* local copy of the notebook storage, which is extended by WebObjects` indirectly *)
JerryI`WolframJSFrontend`Evaluator`objects   = <||>;

InternalGetObject[uid_] := (
  JerryI`WolframJSFrontend`Evaluator`objects[uid]
)

WolframEvaluator[str_String, block_, signature_][callback_] := Module[{},
  Block[{Global`$NewDefinitions = <||>, $CellUid = CreateUUID[], $NotebookID = signature, $evaluated, Global`$ignoreLongStrings = False},

      (* convert, and replace all frontend objects with its representations (except Set) and evaluate the result *)
      $evaluated = (ToExpression[str, InputForm, Hold] /. Global`$CMExpressions // ReleaseHold);
      
      (* a shitty analogue of % symbol *)
      Global`$out = $evaluated;

      (* blocks the output if the was a command from the procesor *)
      If[block === True, $evaluated = Null]; 

    (* replaces the output with a registered WebObjects/FrontEndObjects and releases created held frontend objects *)
    With[{$result = ($evaluated // Global`CM6Form) /. JerryI`WolframJSFrontend`WebObjects`replacement /. {Global`FrontEndExecutableHold -> Global`FrontEndExecutable}},
      (* each creation of FrontEndExecutable extends the objects to $NewDefinitiions, now me merge it with the local storage *)
      JerryI`WolframJSFrontend`Evaluator`objects = Join[JerryI`WolframJSFrontend`Evaluator`objects, Global`$NewDefinitions];
      
      (* truncate the output, if it is too long and create a fake object to represent it *)
      With[{$string = $result // Global`ToCM6Boxes},

        callback[
          If[(StringLength[$string] > 5000 && !(Global`$ignoreLongStrings)) || StringLength[$string] > 39400,
            With[{dumpid = CreateUUID[], len = StringLength[$string], short = StringTake[$string, 100]},
              With[{expr = Global`ExprObjectExport[Global`FrontEndTruncated[short, len], dumpid]},
                (* keep the real data inside the local storage *)
                JerryI`WolframJSFrontend`Evaluator`objects[dumpid] = <|"json"->ExportString[$result, "ExpressionJSON"], "date"->Now|>;          

                expr /. {Global`FrontEndExecutableHold -> Global`FrontEndExecutable}    //  Global`ToCM6Boxes
              ]
            ]
          ,
            $string
          ],

          (* !not used anymore... consider to remove *)
          $CellUid, 

          (* specify the frontened renderer *)
          "codemirror",

          (* an internal message for the master kernel, which passes the created objects during the evaluation *)
          (*JerryI`WolframJSFrontend`ExtendDefinitions[Global`$NewDefinitions]*)
          Null

        ];
      ]
    ];

    
  ]
];

TemplateEvaluator[str_String, signature_, type_:String][callback_] := Module[{},
  Block[{$CellUid = CreateUUID[]},
        
    callback[
      LoadString[str],
      $CellUid, 
      type,
      Null
    ];
    
  ]
];


(* i do not need them anymore  *)

CellPrologOption[expr_, "id"->uid_] := ($CellUid=uid; expr);

End[];
EndPackage[];