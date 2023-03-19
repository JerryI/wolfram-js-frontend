BeginPackage["JerryI`WolframJSFrontend`MagicFileEditor`"];

Begin["Private`"];

ImageProcessor[expr_String, signature_String, callback_] := Module[{filename},
  Print["ImageProcessor!"];
  callback[
      expr,
      CreateUUID[], 
      "image",
      Null
  ];
];


EditFileQ[str_]      := Length[StringCases[str, RegularExpression["^([a-zA-Z_0-9\-]+)\\.([a-zA-Z_]+)$"] ] ] > 0;
ImageFileQ[str_]     := Length[StringCases[str, RegularExpression["^([a-zA-Z_0-9\-]+)\\.(png|jpg|jpeg|gif|svg|webp)$"] ] ] > 0;



(* LoadFileQ[str_]      := Length[StringCases[str, RegularExpression["^([a-zA-Z_0-9\-]+)\\.([a-zA-Z_]+)\\s*>>$"] ] ] > 0; *)

(* 
    in:     file.txt
    out:    the content of the file is printed, or created if not exists

    in:     file.txt 
            hello world
    out:    overwrites the file..not output...

    in:     image.(png|jpg|whatever)
    out:    show an image in the cell
*)

JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[EditFileQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->WSPProcessor       |>];

End[];

EndPackage[];