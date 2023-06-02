#!/usr/bin/env wolframscript

$HistoryLength = 0
PacletDirectoryLoad[Directory[]]

Get["JerryI`WolframJSFrontend`Cells`"]
Get["JerryI`WolframJSFrontend`Evaluator`"]



Get["JerryI`WolframJSFrontend`Colors`"]

Print[Magenta <> "Cells and Evaluator Tests"];
Print[Reset];

eventHandler[type_][data__] := (
    lastevent = {type, cell};
    Print[Blue];
    Print["> "<>type];
    Print[Black];
    Print[data//List//InputForm//ToString];
    Print["- - -"];
    Print[Reset];
);

eventHandler["UpdateState"][data_] := (
    lastevent = {type, cell};
    Print[Blue];
    Print["> UpdateState"];
    Print[Black];
    Print["id: "<>data[[1]]];
    Print["state: "<>data["state"]];
    Print["type: "<>data["type"]];
    Print["- - -"];
    Print[Reset];
);

eventHandler["NewCell"][data_] := (
    lastevent = {type, cell};
    Print[Blue];
    Print["> NewCell"];
    Print[Black];
    Print["id: "<>data[[1]]];
    Print["data: "<>data["data"]];
    Print["type: "<>data["type"]];
    Print["- - -"];
    Print[Reset];
);

eventHandler["RemovedCell"][data_] := (
    lastevent = {type, cell};
    Print[Blue];
    Print["> RemovedCell"];
    Print[Black];
    Print["id: "<>data[[1]]];
    Print["data: "<>data["data"]];
    Print["type: "<>data["type"]];
    Print["- - -"];
    Print[Reset];
);

eventHandler["AddCellAfter"][parent_, next_] := (
    lastevent = {type, cell};
    Print[Blue];
    Print["> AddCellAfter"];
    Print[Black];
    Print["new id: "<>parent[[1]]];
    Print["data: "<>parent["data"]];
    Print["type: "<>parent["type"]];
    Print["- - -"];
    Print["prev id: "<>next[[1]]];
    Print["data: "<>next["data"]];
    Print["type: "<>next["type"]];
    Print["- - -"];    
    Print[Reset];
);

wrapper[cmd_] := Block[
    {JerryI`WolframJSFrontend`fireEvent = eventHandler},
    ReleaseHold[cmd]
];

SetAttributes[wrapper, HoldAll];

evaluator = 
  {
    (True&)   ->  <|"SyntaxChecker"->WolframCheckSyntax,    "Epilog"->SplitExpression,  "Prolog"->(#&), "Evaluator"->WolframProcessor   |>
  };


SplitExpression[astr_] := With[{str = StringReplace[astr, "%"->"$$$out"]},
  StringTake[str, Partition[Join[{1}, #, {StringLength[str]}], 2]] &@
   Flatten[{#1 - 1, #2 + 1} & @@@ 
     Sort@
      Cases[
       CodeParser`CodeConcreteParse[str, 
         CodeParser`SourceConvention -> "SourceCharacterIndex"][[2]], 
       LeafNode[Token`Newline, _, a_] :> Lookup[a, Source, Nothing]]]
];

(*syntax check. credits https://github.com/njpipeorgan *)
WolframCheckSyntax[str_String] := 
    Module[{syntaxErrors = Cases[CodeParser`CodeParse[str],(ErrorNode|AbstractSyntaxErrorNode|UnterminatedGroupNode|UnterminatedCallNode)[___],Infinity]},
        If[Length[syntaxErrors]=!=0 ,
            

            Return[StringRiffle[
                TemplateApply["Syntax error `` at line `` column ``",
                    {ToString[#1],Sequence@@#3[CodeParser`Source][[1]]}
                ]&@@@syntaxErrors

            , "\n"], Module];
        ];
        Return[True, Module];
    ];

WolframProcessor[expr_String, signature_String, callback_] := Module[{str = StringTrim[expr], block = False},
  Print["WolframProcessor!"];
  If[StringTake[str, -1] === ";", block = True; str = StringDrop[str, -1]];
  WolframEvaluator[str, block, signature][callback];
];   

WSPProcessor[expr_String, signature_String, callback_] := Module[{str = StringDrop[expr, StringLength[First[StringSplit[expr, "\n"]]] ]},
  Print["WSPProcessor!"];
  WSPEvaluator[str, signature][callback];
];


JerryI`WolframJSFrontend`WebObjects`replacement = {};

(* ************************************  *)

cell = wrapper[CellObj["sign"->"ref", "data"->"1+1", "type"->"input"]]
list = wrapper[CellList["ref"]={cell}]

Print[Green];
Print["Generate tree"];
Print[Reset];

CellListTree["ref"] // wrapper;

Print[Green];
Print["Create next"];
Print[Reset];

nextcell = wrapper[CellObj["sign"->"ref", "data"->"1+3", "type"->"input"]];
CellListAddNewInput["ref", cell, nextcell]//wrapper;

Print[Green];
Print["Generate tree #2"];
Print[Reset];

CellListTree["ref"] // wrapper;

Print[Green];
Print["Remove last"];
Print[Reset];

CellListRemove["ref", nextcell]//wrapper;

Print[Green];
Print["Generate tree #3"];
Print[Reset];

CellListTree["ref"] // wrapper;

Print[Red];
Print["Evaluate"];
Print[Reset];

CellObjEvaluate[cell, evaluator] // wrapper;

Print[Green];
Print["Generate tree #4"];
Print[Reset];

CellListTree["ref"] // wrapper;


Print[Green];
Print["Create next #2"];
Print[Reset];

nextcell = wrapper[CellObj["sign"->"ref", "data"->"777-1", "type"->"input"]];
CellListAddNewInput["ref", cell, nextcell]//wrapper;

Print[Green];
Print["Generate tree #5"];
Print[Reset];

CellListTree["ref"] // wrapper;


Print[Red];
Print["Evaluate in the middle"];
Print[Reset];

CellObjEvaluate[CellList["ref"][[2]], evaluator] // wrapper;

Print[Green];
Print["Generate tree #6"];
Print[Reset];

CellListTree["ref"] // wrapper;




