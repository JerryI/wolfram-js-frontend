#!/usr/bin/env wolframscript

$HistoryLength = 0
PacletDirectoryLoad[Directory[]]

Get["JerryI`WolframJSFrontend`Cells`"]
Get["JerryI`WolframJSFrontend`Evaluator`"]
Get["JerryI`WolframJSFrontend`WebObjects`"]

eventHandler[type_][cell_] := (
    Print[">>> "<>type<>" <<<"];
    Print["id:\t"<>cell[[1]]];
    Print["data:\t"<>cell["data"]];
    Print["type:\t"<>cell["type"]];
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

JerryI`WolframJSFrontend`ExtendDefinitions[defs_] := Print[StringTemplate["extended defs by ``"][defs]];

LoadWebObjects;
Print["WebObjects example"];
cell = CellObj["data"->"Graphics3D[]", "sign"->"0xff", "type"->"input"];
wrapper[CellObjEvaluate[cell, evaluator]];

Print[];Print[];Print[];Print[];
cell = CellObj["data"->"FrontEndObj[Graphics3D[1+1], \"ahahha\"]", "sign"->"0xff", "type"->"input"];
wrapper[CellObjEvaluate[cell, evaluator]];