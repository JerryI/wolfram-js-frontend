BeginPackage["JerryI`WolframJSFrontend`MermaidSupport`"];

Begin["Private`"];

MermaidQ[str_] := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.mermaid$"]]] > 0;

MermaidProcessor[expr_String, signature_String, callback_] := Module[{str = StringDrop[expr, StringLength[First[StringSplit[expr, "\n"]]] ]},
  Print["MermaidProcessor!"];
  callback[
      str,
      CreateUUID[], 
      "mermaid",
      Null
  ];
];

JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[(MermaidQ ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->MermaidProcessor  |>)];


End[];

EndPackage[];