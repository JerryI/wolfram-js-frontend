<|"notebook" -> <|"name" -> "Consomme", "id" -> "physiologically-cd98e", 
   "kernel" -> LocalKernel, "objects" -> <||>, 
   "path" -> "/root/wolfram-js-frontend/Demo/Markov.wl", 
   "cell" -> "5f667107-52f8-4d6e-9432-4a1119a8f065", 
   "date" -> DateObject[{2023, 4, 6, 22, 52, 38.84823`8.341946215092003}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "01550ff3-cc62-479a-a645-d69f40e49e07", 
    "type" -> "input", "data" -> "Do[ArrayDraw[field]//SendToFrontEnd;\nfield \
= reCalc;\nPause[0.1];\n,{i, 1, 100}]", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "dab2655a-1578-42cf-914e-4ce17a3530e8", 
    "next" -> "95c0b791-25c9-4f88-8bd2-ca87f14d6334", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "1640bf99-a579-4f3d-a8f8-e411e0eb9335", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "23ac8c94-4fe8-435a-9094-4ee8c4f0cb42", 
    "next" -> "c05ecf45-549e-44de-a983-9e7ad799e7ad", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "1934b436-238d-43f0-9d64-215bdd2cb900", "type" -> "input", 
    "data" -> "", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "636c0b9d-29a4-48a9-92c5-2d4ff70d23c2", 
    "next" -> "dab2655a-1578-42cf-914e-4ce17a3530e8", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "23ac8c94-4fe8-435a-9094-4ee8c4f0cb42", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "c3911e9d-3cf8-4132-9205-eb629cbeb856", 
    "next" -> "1640bf99-a579-4f3d-a8f8-e411e0eb9335", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "28ca49e7-acc0-47d6-9536-00211bc0913f", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "42ee1e6a-1090-4654-b4e9-b44ed617a4f6", 
    "next" -> "b701ffef-5171-4013-9494-2de25d98969c", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "2ec12449-72b6-4e71-aa55-54233dd27669", "type" -> "output", 
    "data" -> "\n# Markov Algorithm", "display" -> "markdown", 
    "sign" -> "physiologically-cd98e", "prev" -> Null, "next" -> Null, 
    "parent" -> "5f667107-52f8-4d6e-9432-4a1119a8f065", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "type" -> "input", 
    "data" -> "", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "5813e3bb-f34f-494e-aa69-d65ba8beac48", "next" -> Null, 
    "parent" -> Null, "child" -> "c598d2c3-dcda-4cae-9c04-12c7c3bfe34c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3e89c0aa-6359-49ef-83bc-66f50280c579", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "41701c2a-8cbf-4438-b79e-e4b373643715", 
    "next" -> "c3911e9d-3cf8-4132-9205-eb629cbeb856", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "41701c2a-8cbf-4438-b79e-e4b373643715", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "5c04b9aa-d918-455b-9587-af5219a5d9aa", 
    "next" -> "3e89c0aa-6359-49ef-83bc-66f50280c579", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "42ee1e6a-1090-4654-b4e9-b44ed617a4f6", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "c598d2c3-dcda-4cae-9c04-12c7c3bfe34c", 
    "next" -> "28ca49e7-acc0-47d6-9536-00211bc0913f", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "5813e3bb-f34f-494e-aa69-d65ba8beac48", "type" -> "input", 
    "data" -> "markov[\"WB -> WW\", \"BBBBBBBBBBBBBBBBBWBBBBBBBBBBBBBBB\"]", 
    "display" -> "codemirror", "sign" -> "physiologically-cd98e", 
    "prev" -> "a40c6b3f-2120-494a-afd6-f8f258fd3a80", 
    "next" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "parent" -> Null, 
    "child" -> "e746b5c1-0c37-457e-b6fd-d4d354e46936", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "5c04b9aa-d918-455b-9587-af5219a5d9aa", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "8cf21b44-5da5-4a4a-87f9-99405eabe8f4", 
    "next" -> "41701c2a-8cbf-4438-b79e-e4b373643715", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "5f667107-52f8-4d6e-9432-4a1119a8f065", "type" -> "input", 
    "data" -> ".md\n# Markov Algorithm", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", "prev" -> Null, 
    "next" -> "aefc2f0a-7e99-4ba2-9157-3fae3937e5c0", "parent" -> Null, 
    "child" -> "2ec12449-72b6-4e71-aa55-54233dd27669", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "62970ff5-00b0-4bea-947d-c26a072bb68f", "type" -> "output", 
    "data" -> "\nvar canvas = document.createElement('canvas');\nvar ctx = \
canvas.getContext(\"2d\");\n\nvar height = 100;\nvar width = 100;\n\nvar h = \
ctx.canvas.height;\nvar w = ctx.canvas.width;\n\ncore.ArrayDraw = (args, env) \
=> {\n  \n  var imgData = ctx.getImageData(0, 0, w, h);\n  var data = \
imgData.data;  // the array of RGBA values\n  var arr = interpretate(args[0], \
env);\n  \n  for(var i = 0; i < height; i++) {\n      for(var j = 0; j < \
width; j++) {\n          var s = 4 * i * w + 4 * j;  // calculate the index \
in the array\n          var x = arr[i][j];  // the RGB values\n          \
data[s] = x*250;\n          data[s + 1] = x*250;\n          data[s + 2] = \
i;\n          data[s + 3] = 255;  // fully opaque\n      }\n  }\n\n  \
ctx.putImageData(imgData, 0, 0);\n}\n\nreturn canvas;", "display" -> "js", 
    "sign" -> "physiologically-cd98e", "prev" -> Null, "next" -> Null, 
    "parent" -> "dab2655a-1578-42cf-914e-4ce17a3530e8", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "636c0b9d-29a4-48a9-92c5-2d4ff70d23c2", "type" -> "input", 
    "data" -> "\n", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "aefc2f0a-7e99-4ba2-9157-3fae3937e5c0", 
    "next" -> "1934b436-238d-43f0-9d64-215bdd2cb900", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8cf21b44-5da5-4a4a-87f9-99405eabe8f4", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "c4342e4a-9cc1-4090-b5dd-23345dd473d1", 
    "next" -> "5c04b9aa-d918-455b-9587-af5219a5d9aa", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "95c0b791-25c9-4f88-8bd2-ca87f14d6334", "type" -> "input", 
    "data" -> ".md\nNormal Markov Algorithm working on strings", 
    "display" -> "codemirror", "sign" -> "physiologically-cd98e", 
    "prev" -> "01550ff3-cc62-479a-a645-d69f40e49e07", 
    "next" -> "a40c6b3f-2120-494a-afd6-f8f258fd3a80", "parent" -> Null, 
    "child" -> "af5bb2f9-1424-4226-b8fd-470db3be0283", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "993b5dac-34eb-43f7-9e94-2ae9542d117f", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "cd7f2ce1-0217-44c2-a6ed-5e565857fc84", 
    "next" -> "a1db2062-07a0-4e89-bfe9-d62f7b240173", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a1db2062-07a0-4e89-bfe9-d62f7b240173", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "993b5dac-34eb-43f7-9e94-2ae9542d117f", 
    "next" -> "c4342e4a-9cc1-4090-b5dd-23345dd473d1", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a40c6b3f-2120-494a-afd6-f8f258fd3a80", "type" -> "input", 
    "data" -> "markov[ruleset_, text_] := \n  Module[{terminating = False, \
output = text, \n    rules = StringCases[\n      ruleset, {StartOfLine ~~ \
pattern : Except[\"\n\"] .. ~~ \n         \" \" | \"\t\" .. ~~ \"->\" ~~ \" \
\" | \"\t\" .. ~~ dot : \"\" | \".\" ~~ \n         replacement : \
Except[\"\n\"] .. ~~ EndOfLine :> {pattern, \n         replacement, dot == \
\".\"}}]}, \n   While[! terminating, terminating = True; \n    Do[If[! \
StringFreeQ[output, rule[[1]]], \n      output = StringReplace[output, \
rule[[1]] -> rule[[2]]]; \n      If[! rule[[3]], terminating = False]; \
Break[]], {rule, rules}]];\n    output];", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "95c0b791-25c9-4f88-8bd2-ca87f14d6334", 
    "next" -> "5813e3bb-f34f-494e-aa69-d65ba8beac48", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "aefc2f0a-7e99-4ba2-9157-3fae3937e5c0", "type" -> "input", 
    "data" -> "field = Table[0, {i, 100}, {j, 100}];\nfield[[50,50]] = \
1;\n\nRulePermute[x_List] := Module[{array, dump = {}},\n  array = Table[_, \
{i, 2Length[x]-1}, {j, 2Length[x]-1}];\n  array[[Length[x] ;; , Length[x] ]] \
= x;\n  Do[\n    AppendTo[dump, array];\n    array = Reverse@(Transpose@ \
array);\n  , {i,1,4}];\n\n  dump\n];\n\nrule = RulePermute[{1,0}];\nrepl = \
RulePermute[{1,1}];\n\nrulelentgh = Length[{1,0}];\n\nreCalc := (\n\nseq = \
{Table[\n  {MatchQS[x, rule[[r]]], r}\n, {r, rule//Length}], {True, False}} \
//Flatten;\n\ntestfunction = FunctionS[x, Which @@ seq ] /. {FunctionS -> \
Function, MatchQS -> MatchQ};\n\nfiltered = ArrayFilter[\n  testfunction,\n  \
field,\n  {{1,1,1},{1,1,1},{1,1,1}},\n  Padding -> None\n];\n\npos = \
Position[filtered, _?NumberQ]//RandomChoice;\n\nrp = repl[[Part[filtered, \
Sequence@@pos]]];\n\nTable[\n  If[i >= pos[[1]]-rulelentgh + 1 && i <= \
pos[[1]]+rulelentgh - 1 && j >= pos[[2]]-rulelentgh + 1 && j <= \
pos[[2]]+rulelentgh - 1,\n    With[{p = rp[[i - pos[[1]]-rulelentgh, j - \
pos[[2]]-rulelentgh]]},\n      If[p//NumberQ,\n        p, field[[i,j]]\n      \
]\n    ]\n  ,\n    field[[i,j]]\n  ]\n  \n, {i, field//Length}, {j, \
field[[1]]//Length}]\n)", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "5f667107-52f8-4d6e-9432-4a1119a8f065", 
    "next" -> "636c0b9d-29a4-48a9-92c5-2d4ff70d23c2", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "af5bb2f9-1424-4226-b8fd-470db3be0283", "type" -> "output", 
    "data" -> "\nNormal Markov Algorithm working on strings", 
    "display" -> "markdown", "sign" -> "physiologically-cd98e", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "95c0b791-25c9-4f88-8bd2-ca87f14d6334", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "b701ffef-5171-4013-9494-2de25d98969c", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "28ca49e7-acc0-47d6-9536-00211bc0913f", 
    "next" -> "cd7f2ce1-0217-44c2-a6ed-5e565857fc84", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c05ecf45-549e-44de-a983-9e7ad799e7ad", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "1640bf99-a579-4f3d-a8f8-e411e0eb9335", 
    "next" -> "de7179a7-65ef-47f3-8d13-df75bd928222", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c2f0e769-0446-4033-ac55-303e595886e2", "type" -> "output", 
    "data" -> "{{2 /. {_, _, _}, 2 /. {_, 1, _}, 2 /. {_, 1, _}}, {2 /. {_, \
_, _}, 2 /. {_, 1, 1}, 2 /. {_, _, _}}, {2 /. {_, 1, _}, 2 /. {_, 1, _}, 2 /. \
{_, _, _}}, {2 /. {_, _, _}, 2 /. {1, 1, _}, 2 /. {_, _, _}}}", 
    "display" -> "codemirror", "sign" -> "physiologically-cd98e", 
    "prev" -> "de7179a7-65ef-47f3-8d13-df75bd928222", "next" -> Null, 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c31cc90c-ca02-4f97-bd90-5af53c471e1c", "type" -> "output", 
    "data" -> "\"WBWWWWWWWWWWWWWWWWWBBBBBBBBBBBBBB\"", 
    "display" -> "codemirror", "sign" -> "physiologically-cd98e", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "5813e3bb-f34f-494e-aa69-d65ba8beac48", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c3911e9d-3cf8-4132-9205-eb629cbeb856", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "3e89c0aa-6359-49ef-83bc-66f50280c579", 
    "next" -> "23ac8c94-4fe8-435a-9094-4ee8c4f0cb42", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c4342e4a-9cc1-4090-b5dd-23345dd473d1", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "a1db2062-07a0-4e89-bfe9-d62f7b240173", 
    "next" -> "8cf21b44-5da5-4a4a-87f9-99405eabe8f4", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c598d2c3-dcda-4cae-9c04-12c7c3bfe34c", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", "prev" -> Null, 
    "next" -> "42ee1e6a-1090-4654-b4e9-b44ed617a4f6", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "cd7f2ce1-0217-44c2-a6ed-5e565857fc84", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "b701ffef-5171-4013-9494-2de25d98969c", 
    "next" -> "993b5dac-34eb-43f7-9e94-2ae9542d117f", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "dab2655a-1578-42cf-914e-4ce17a3530e8", "type" -> "input", 
    "data" -> ".js\nvar canvas = document.createElement('canvas');\nvar ctx = \
canvas.getContext(\"2d\");\n\nvar height = 100;\nvar width = 100;\n\nvar h = \
ctx.canvas.height;\nvar w = ctx.canvas.width;\n\ncore.ArrayDraw = (args, env) \
=> {\n  \n  var imgData = ctx.getImageData(0, 0, w, h);\n  var data = \
imgData.data;  // the array of RGBA values\n  var arr = interpretate(args[0], \
env);\n  \n  for(var i = 0; i < height; i++) {\n      for(var j = 0; j < \
width; j++) {\n          var s = 4 * i * w + 4 * j;  // calculate the index \
in the array\n          var x = arr[i][j];  // the RGB values\n          \
data[s] = x*250;\n          data[s + 1] = x*250;\n          data[s + 2] = \
i;\n          data[s + 3] = 255;  // fully opaque\n      }\n  }\n\n  \
ctx.putImageData(imgData, 0, 0);\n}\n\nreturn canvas;", 
    "display" -> "codemirror", "sign" -> "physiologically-cd98e", 
    "prev" -> "1934b436-238d-43f0-9d64-215bdd2cb900", 
    "next" -> "01550ff3-cc62-479a-a645-d69f40e49e07", "parent" -> Null, 
    "child" -> "62970ff5-00b0-4bea-947d-c26a072bb68f", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "de7179a7-65ef-47f3-8d13-df75bd928222", "type" -> "output", 
    "data" -> "{{Null /. {_, _, _}, Null /. {_, 1, _}, Null /. {_, 1, _}}, \
{Null /. {_, _, _}, Null /. {_, 1, 1}, Null /. {_, _, _}}, {Null /. {_, 1, \
_}, Null /. {_, 1, _}, Null /. {_, _, _}}, {Null /. {_, _, _}, Null /. {1, 1, \
_}, Null /. {_, _, _}}}", "display" -> "codemirror", 
    "sign" -> "physiologically-cd98e", 
    "prev" -> "c05ecf45-549e-44de-a983-9e7ad799e7ad", 
    "next" -> "c2f0e769-0446-4033-ac55-303e595886e2", 
    "parent" -> "3e2b4a27-d6be-45cb-9b9b-ace4c7c2af73", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "e746b5c1-0c37-457e-b6fd-d4d354e46936", "type" -> "output", 
    "data" -> "\"BBBBBBBBBBBBBBBBBWWWWWWWWWWWWWWWW\"", 
    "display" -> "codemirror", "sign" -> "physiologically-cd98e", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "5813e3bb-f34f-494e-aa69-d65ba8beac48", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn2"|>
