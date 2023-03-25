BeginPackage["JerryI`WolframJSFrontend`JSSupport`"];

Begin["Private`"];

JSQ[str_]       := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.(js|jsx)$"]]] > 0;


JSProcessor[expr_String, signature_String, callback_] := Module[{str = StringDrop[expr, StringLength[First[StringSplit[expr, "\n"]]] ]},
  Print["JSProcessor!"];
  JerryI`WolframJSFrontend`Notebook`Notebooks[signature]["kernel"][JerryI`WolframJSFrontend`Evaluator`TemplateEvaluator[str, signature, "js"], callback, "Link"->"WSTP"];
];

JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[(JSQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->JSProcessor       |>)];

End[];

EndPackage[];