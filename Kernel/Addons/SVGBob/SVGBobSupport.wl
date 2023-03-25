BeginPackage["JerryI`WolframJSFrontend`SVGBobSupport`"];

Begin["Private`"];

SVGBobQ[str_] := Length[StringCases[StringSplit[str, "\n"] // First, RegularExpression["^\\.svgbob$"]]] > 0;

SVGBobProcessor[expr_String, signature_String, callback_] := Module[{str = StringDrop[expr, StringLength[First[StringSplit[expr, "\n"]]] ]},
  Print["SVGBobProcessor!"];
  callback[
      str,
      CreateUUID[], 
      "svgbob",
      Null
  ];
];

JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[(SVGBobQ ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->SVGBobProcessor  |>)];


End[];

EndPackage[];