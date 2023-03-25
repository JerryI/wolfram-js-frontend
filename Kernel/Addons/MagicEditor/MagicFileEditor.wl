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

FilePrintProcessor[expr_String, signature_String, callback_] := Module[{filename},
  Print["FilePProcessor!"]; 
  callback[
      Import[FileNameJoin[{DirectoryName[JerryI`WolframJSFrontend`Notebook`Notebooks[signature]["path"]], expr}], "String"],
      CreateUUID[], 
      "fileprint",
      Null
  ];
];

FileWriteProcessor[expr_String, signature_String, callback_] := Module[{filename, filecontent, path},
  Print["FileWProcessor!"];
  filename = StringCases[expr, RegularExpression["^([a-zA-Z_0-9\\-]+)\\.([a-zA-Z_]+)"] ] //First;
  filecontent = StringDrop[StringReplace[expr, filename->""],1];
  path = FileNameJoin[{DirectoryName[JerryI`WolframJSFrontend`Notebook`Notebooks[signature]["path"]], filename}];
  WriteString[path, filecontent];
  callback[
      StringTemplate["* `` characters were written *"][StringLength[filecontent]],
      CreateUUID[], 
      "fileprint",
      Null
  ];
];

WriteFileQ[str_]      := Length[StringCases[str, RegularExpression["^([a-zA-Z_0-9\\-]+)\\.([a-zA-Z_]+)"] ] ] > 0;
PrintFileQ[str_]      := Length[StringCases[str, RegularExpression["^([a-zA-Z_0-9\\-]+)\\.([a-zA-Z_]+)\\z"] ] ] > 0;
ImageFileQ[str_]      := Length[StringCases[str, RegularExpression["^([a-zA-Z_0-9\\-]+)\\.(png|jpg|jpeg|gif|svg|webp)"] ] ] > 0;


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

JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[(WriteFileQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->FileWriteProcessor       |>)];
JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[(PrintFileQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->FilePrintProcessor       |>)];

JerryI`WolframJSFrontend`Notebook`NotebookAddEvaluator[(ImageFileQ      ->  <|"SyntaxChecker"->(True&),               "Epilog"->(#&),             "Prolog"->(#&), "Evaluator"->ImageProcessor       |>)];

End[];

EndPackage[];