BeginPackage["JerryI`WolframJSFrontend`WolframLanguageSupport`", {"CodeParser`"}];

Begin["Private`"];

SplitExpression[astr_] := With[{str = StringReplace[astr, "%"->"Global`$out"]},
  StringTake[str, Partition[Join[{1}, #, {StringLength[str]}], 2]] &@
   Flatten[{#1 - 1, #2 + 1} & @@@ 
     Sort@
      Cases[
       CodeParser`CodeConcreteParse[str, 
         CodeParser`SourceConvention -> "SourceCharacterIndex"][[2]], 
       LeafNode[Token`Newline, _, a_] :> Lookup[a, Source, Nothing]]]
];

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

(* assign available Evaluators to the processsors *)

WolframProcessor[expr_String, signature_String, callback_] := Module[{str = StringTrim[expr], block = False},
  Print["WolframProcessor!"];
  If[StringTake[str, -1] === ";", block = True; str = StringDrop[str, -1]];
  JerryI`WolframJSFrontend`Notebook`Notebooks[signature]["kernel"][JerryI`WolframJSFrontend`Evaluator`WolframEvaluator[str, block, signature], callback, "Link"->"WSTP"];
];    

JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[((True&)    ->  <|"SyntaxChecker"->WolframCheckSyntax,    "Epilog"->SplitExpression,  "Prolog"->(#&), "Evaluator"->WolframProcessor   |>)];

End[];

EndPackage[];