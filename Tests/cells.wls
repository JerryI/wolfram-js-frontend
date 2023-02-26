#!/usr/bin/env wolframscript

$HistoryLength = 0
PacletDirectoryLoad[Directory[]]
Get["https://raw.githubusercontent.com/JerryI/tinyweb-mathematica/master/WSP/WSP.wl"]
Get["JerryI`WolframJSFrontend`Cells`"]
Get["JerryI`WolframJSFrontend`Evaluator`"]



Get["JerryI`WolframJSFrontend`Colors`"]

Print[Magenta <> "Cells and Evaluator Tests"];
Print[Reset];

eventHandler[type_][cell_] := (
    lastevent = {type, cell};
    Print[Black];
    Print[">>> "<>type<>" <<<"];
    Print["id:\t"<>cell[[1]]];
    Print["data:\t"<>cell["data"]];
    Print["type:\t"<>cell["type"]];
    Print[Reset];
);

wrapper[cmd_] := Block[
    {JerryI`WolframJSFrontend`fireEvent = eventHandler},
    ReleaseHold[cmd]
];

SetAttributes[wrapper, HoldAll];

evaluator = 
  {
    MarkdownQ ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->MarkdownProcessor  |>,
    WSPQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->WSPProcessor       |>,
    (True&)   ->  <|"SyntaxChecker"->WolframCheckSyntax,    "Epilog"->SplitExpression,  "Prolog"->(#&), "Evaluator"->WolframProcessor   |>
  };

MarkdownQ[str_] := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.md$"]]] > 0;
WSPQ[str_]      := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.(wsp|html|htm)$"]]] > 0;

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

Print["Create cell silently"];
cell = wrapper[CellObj["sign"->"0xff", "data"->"1+1", "type"->"input"]];
Print["Generate tree"];
wrapper[CellObjGenerateTree[cell ]];

If[lastevent[[1]] === "NewCell" && cell["data"] === "1+1",
  Print[Green]; Print["Passed"]; 
  ,
  Print[Green]; Print["Failed"];
  Print[lastevent]; 
  Print[cell["data"]];
  failed=True;
];

Print[Reset];


Print["Try to evaluate"];
wrapper[CellObjEvaluate[cell, evaluator]];

If[cell["child"]["data"] === "2",
  Print[Green]; Print["Passed"];
,
  Print[Red]; Print["Failed"];
  Print[cell["child"]["data"]];
  failed=True;
];
Print[Reset];

Print["Overall"];
If[failed//TrueQ, Print[Red<>"Failed"], Print[Green<>"Passed"]]; 
Print[Reset];






Print[Magneta<>"WSP Test"]; Print[Reset];

cell["data"] = ".wsp\n<div><?wsp Now ?></div>";
wrapper[CellObjEvaluate[cell, evaluator]];
Print[cell["child"]["data"]]

