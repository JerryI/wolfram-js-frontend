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

NotebookStore /: Unset[NotebookStore[key_]] := AskMaster[Global`NotebookStoreOperate["Unset", key]];

Protect[NotebookStore]




(*Unprotect[Select];
Select[FrontEndInstances, MetaMarker[label_]] ^:= Module[{},
  AskMaster[Global`NotebookAskFront[FindMetaMarker[label]]]
]; *)

Global`$out = Null;

(* global scope *)
SetAttributes[SetFrontEndObject, HoldFirst];
SetAttributes[FrontEndRef, HoldFirst];


FrontEndViewWrapper[expr_, _] := expr;

(* autoconvertion of the frontend object back to the original expressions *)

FrontEndInlineExecutableWrapper[str_String] := str // Uncompress // ReleaseHold

IconizeWrapper[expr_] := expr

FrontEndRef[FrontEndExecutableWrapper[uid_]] := FrontEndExecutableHold[uid];
FrontEndRef[FrontEndExecutable[uid_]]        := FrontEndExecutableHold[uid];

(* exceptional case, when the frontened object is set *)
SetFrontEndObject[FrontEndExecutableWrapper[uid_], expr_] ^:= SetFrontEndObject[uid, expr];
Set[FrontEndExecutableWrapper[uid_], expr_] ^:= (SetFrontEndObject[uid, expr]//SendToFrontEnd);

SetFrontEndObject[FrontEndRef[uid_], expr_] ^:= SetFrontEndObject[uid, expr];
Set[FrontEndRef[uid_], expr_] ^:= (SetFrontEndObject[uid, expr]//SendToFrontEnd);

(* just for the backward compatibillity *)
ToCM6Boxes[expr_] := ToString[expr, StandardForm];
ToCM6Boxes[NoBoxes[expr_]] ^:= StringReplace[ToString[expr, InputForm], {"\[NoBreak]"->"", "\[Pi]"->"$Pi$"}]

If[!TrueQ[JerryI`WolframJSFrontend`settings["displayForm"]],
  ToCM6Boxes[expr_] := StringReplace[ToString[expr, InputForm], {"\[NoBreak]"->"", "\[Pi]"->"$Pi$"}]
];

(* some buggy replacements, that cannot be threated differently. FUCK WOLFRAM cuz you cannot control Boxes on Graphics and Image *)
JerryI`WolframJSFrontend`Evaluator`replacements = {};
JerryI`WolframJSFrontend`Evaluator`replacementsAfter = {};

JerryI`WolframJSFrontend`Evaluator`KeepExpression[item_, OptionsPattern[]] := With[{},
  If[OptionValue["Epilog"],
    JerryI`WolframJSFrontend`Evaluator`replacementsAfter = {JerryI`WolframJSFrontend`Evaluator`replacementsAfter,
      {
        Global`CreateFrontEndObject[item[x__], $iouid_:Null] :> With[{$ouid = If[$iouid === Null, CreateUUID[], $iouid]}, 
          Global`$NewDefinitions[$ouid] = <|"json"->ExportString[item[x], "ExpressionJSON", "Compact" -> 0], "date"->Now |>; 
          $ExtendDefinitions[$ouid, Global`$NewDefinitions[$ouid]]; MakeBoxes[Global`FrontEndExecutable[$ouid], StandardForm] ],
        item[x__] :> With[{$ouid = CreateUUID[]}, 
          Global`$NewDefinitions[$ouid] = <|"json"->ExportString[item[x], "ExpressionJSON", "Compact" -> 0], "date"->Now |>; 
          $ExtendDefinitions[$ouid, Global`$NewDefinitions[$ouid]]; MakeBoxes[Global`FrontEndExecutable[$ouid], StandardForm] ]
      }} // Flatten
  ,
    JerryI`WolframJSFrontend`Evaluator`replacements = {JerryI`WolframJSFrontend`Evaluator`replacements,
      {
        Global`CreateFrontEndObject[item[x__], $iouid_:Null] :> With[{$ouid = If[$iouid === Null, CreateUUID[], $iouid]}, 
          Global`$NewDefinitions[$ouid] = <|"json"->ExportString[item[x], "ExpressionJSON", "Compact" -> 0], "date"->Now |>; 
          $ExtendDefinitions[$ouid, Global`$NewDefinitions[$ouid]]; Global`FrontEndExecutable[$ouid] ],
        item[x__] :> With[{$ouid = CreateUUID[]}, 
          Global`$NewDefinitions[$ouid] = <|"json"->ExportString[item[x], "ExpressionJSON", "Compact" -> 0], "date"->Now |>; 
          $ExtendDefinitions[$ouid, Global`$NewDefinitions[$ouid]]; Global`FrontEndExecutable[$ouid] ]
      }} // Flatten
  ]
]

Options[JerryI`WolframJSFrontend`Evaluator`KeepExpression] = {"Epilog"->False}


RowBoxFlatten[x_List, y___] := StringJoin @@ (ToString[#] & /@ x)


Unprotect[ToString]
ToString[expr_, StandardForm] := StringReplace[(expr /. JerryI`WolframJSFrontend`Evaluator`replacements // ToBoxes) /. JerryI`WolframJSFrontend`Evaluator`replacementsAfter /. {RowBox->RowBoxFlatten} // ToString, {"\[NoBreak]"->""}]

(*disable standard form*)
If[!JerryI`WolframJSFrontend`settings["displayForm"],
  Print["StandardForm is disabled!"];
  ToString[expr_, StandardForm] := StringReplace[ToString[(expr /. JerryI`WolframJSFrontend`Evaluator`replacements), InputForm], {"\[NoBreak]"->""}]
];

(*CMCrawler[a_[args__], StandardForm] := With[{args = (CMCrawler[#, StandardForm] &/@ List[args])}, CMCrawler[a, StandardForm]@@x]
CMCrawler[a_, StandardForm] := a
CMCrawler[a_] := CMCrawler[a, StandardForm]*)




JerryI`WolframJSFrontend`Evaluator`legacyFixReplacements = {}

ExpressionMaker[rule_Rule, StandardForm] := JerryI`WolframJSFrontend`Evaluator`legacyFixReplacements = {JerryI`WolframJSFrontend`Evaluator`legacyFixReplacements, rule} // Flatten;

SetAttributes[CMCrawler, HoldFirst]

(* iconize *)
Unprotect[Iconize]
ClearAll[Iconize]

Iconize[expr_] := Module[{compressed = Hold[IconizeWrapper[expr]]//Compress},
  If[StringLength[compressed] > 3,
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

Unprotect[EvaluationCell];
ClearAll[EvaluationCell];

Unprotect[ParentCell];
ClearAll[ParentCell];

Unprotect[CellPrint];
ClearAll[CellPrint];

CellPrintInContext[callback_][expr_String, OptionsPattern[]] := With[{uid = CreateUUID[]}, Module[{parent},
  callback[
    expr, 
    uid, 
    "codemirror", 
    Null
  ];

  Return[CellObj[uid], Module];
]]



CellObj /: ParentCell[CellObj[uid_String]] := With[{nid = JerryI`WolframJSFrontend`Remote`Private`notebook},
  JerryI`WolframJSFrontend`Remote`Private`MasterSubmit[CellListFindFirstInputBefore[nid, CellObj[uid]]]
]

CellObj /: Delete[CellObj[uid_String]] := With[{nid = JerryI`WolframJSFrontend`Remote`Private`notebook}, 
  JerryI`WolframJSFrontend`Remote`Private`MasterSubmit[NotebookOperate[nid][uid, CellListRemoveAccurate]]
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




WolframEvaluator[str_String, block_, signature_][callback_] := With[{$CellUid = CreateUUID[]},
 
  Block[{
        Global`$NewDefinitions = <||>, 
        Global`$PostEval = Null, 
        EvaluationCell = Function[Null, Global`CellObj[$CellUid]], 
        Global`$NotebookID = signature, $evaluated, 
        Global`$ignoreLongStrings = False
      },

      (* convert, and replace all frontend objects with its representations (except Set) and evaluate the result *)
     
      $evaluated = ToExpression[str, InputForm, Hold] ;
     
      $evaluated = $evaluated /. JerryI`WolframJSFrontend`Evaluator`legacyFixReplacements /. {CellPrint -> Global`CellPrintInContext[callback]};
   
      $evaluated = $evaluated // ReleaseHold;

      (* a shitty analogue of % symbol *)
      Global`$out = $evaluated;

      (* blocks the output if the was a command from the procesor *)
      If[block === True, $evaluated = Null]; 

    (* replaces the output with a registered WebObjects/FrontEndObjects and releases created held frontend objects *)
    With[{$string = ToString[$evaluated, StandardForm]},

      (* each creation of FrontEndExecutable extends the objects to $NewDefinitiions, now me merge it with the local storage *)
      JerryI`WolframJSFrontend`Evaluator`objects = Join[JerryI`WolframJSFrontend`Evaluator`objects, Global`$NewDefinitions];
      
      (* truncate the output, if it is too long and create a fake object to represent it *)
      With[{},

        callback[
          If[(StringLength[$string] > 2^14 && !(Global`$ignoreLongStrings)) || StringLength[$string] > 2^16,
            With[{dumpid = CreateUUID[], len = StringLength[$string], short = StringTake[$string, 100]},
              With[{expr = Global`ExprObjectExport[Global`FrontEndTruncated[short, len], dumpid]},
                (* keep the real data inside the local storage *)
                JerryI`WolframJSFrontend`Evaluator`objects[dumpid] = <|"json"->ExportString[$evaluated, "ExpressionJSON"], "date"->Now|>;          

                "FrontEndExecutable[\""<>dumpid<>"\"]"
              ]
            ]
          ,
            $string
          ],

          (* used to track event of a cell *)
          $CellUid, 

          (* specify the frontened renderer *)
          "codemirror",

          (* an internal message for the master kernel, which passes the created objects during the evaluation *)
          (*JerryI`WolframJSFrontend`ExtendDefinitions[Global`$NewDefinitions]*)
          Global`$PostEval

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