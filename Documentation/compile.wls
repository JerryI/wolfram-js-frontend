#!/usr/bin/env wolframscript

SetAttribute[Offload, HoldFirst]

Plotly[f_, range_, op : OptionsPattern[Plot]] := Plot[f, range, op] // Cases[#, Line[x_] :> x, All] & // ListLinePlotly[#, op] & 

TextNode /: ToString[TextNode[x_]] := x["data"];
WLNode /: ToString[WLNode[x_]] := "<Wl data={`"<>x["data"]<>"`}"<>">"<>x["src"]<>"</Wl>";

Enc[expr_] := ExportString[ExportString[expr, "ExpressionJSON", "Compact"->0], "Base64"]
(*Enc[expr_] := "\""<>Compress[expr]<>"\"";*)

compile[str_] := Module[{tokens, open, close},
open = StringPosition[str, RegularExpression["<Wl[^<|>]*>"]];
close = StringPosition[str, RegularExpression["</Wl>"]];
tokens = Join[(<|"type"->"open", "pos"-> #|>) &/@ open,
(<|"type"->"close", "pos"-> #|>) &/@ close];

tokens = Partition[SortBy[tokens, #["pos"][[1]]&],2];
tokens = Map[<|"pos"->{#[[1]]["pos"][[1]], #[[2]]["pos"][[2]]}, "src"->StringDrop[StringTake[str, #[[2]]["pos"][[1]]-1], #[[1]]["pos"][[2]]]|>&, tokens];
tokens = Map[Join[#, <|"data" -> Enc[ToExpression[StringDrop[StringDrop[#["src"],2],-2], InputForm]], "type"->"expr"|>]&, tokens];
tokens = MapIndexed[{
    If[#1["pos"][[1]] > 1 && #2[[1]] == 1, TextNode[<|"data"->StringDrop[StringTake[str, #1["pos"][[1]]-1], 0]|>], {}],
    If[#1["pos"][[1]] > 1 && #2[[1]] > 1, TextNode[<|"data"->StringDrop[StringTake[str, #1["pos"][[1]]-1], tokens[[#2[[1]] - 1]]["pos"][[2]]]|>], {}],
    WLNode[#1],

    If[#1["pos"][[2]] < StringLength[str] && #2[[1]] == Length[tokens], TextNode[<|"data"->StringDrop[str, #1["pos"][[2]]]|>], {}]    
    
  }&
, tokens] // Flatten;
StringRiffle[ToString /@ tokens, ""]
]

files = Join[FileNames["*.md", FileNameJoin[{Directory[], "docs"}], Infinity], FileNames["*.md", FileNameJoin[{Directory[], "src", "pages"}], Infinity]];
files = Select[files, StringMatchQ[Import[#, "String"], ___~~"</Wl>"~~___]&];
With[{t = Print[#], res = compile[Import[#, "String"]]},
    If[!FailureQ[res] && StringQ[res],
        Print["OK"];
        Export[#, res, "String"];
    ,
        Print["FAILED!"];
    ];     
] &/@ files;