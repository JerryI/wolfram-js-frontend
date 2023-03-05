<|"notebook" -> <|"name" -> "Untitled", "id" -> "test", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"myObject" -> "[\n\t\"List\",\n\t[\n\t\t\"List\",\n\t\t[\n\t\t\t\"List\
\",\n\t\t\t1,\n\t\t\t2,\n\t\t\t3,\n\t\t\t4,\n\t\t\t5,\n\t\t\t6,\n\t\t\t7,\n\t\
\t\t8,\n\t\t\t9,\n\t\t\t10\n\t\t],\n\t\t[\n\t\t\t\"List\",\n\t\t\t1,\n\t\t\t1\
,\n\t\t\t1,\n\t\t\t1,\n\t\t\t1,\n\t\t\t1,\n\t\t\t1,\n\t\t\t1,\n\t\t\t1,\n\t\t\
\t1\n\t\t]\n\t]\n]", "5364c3b6-29bf-475f-9a08-a26c581e3938" -> "[\n\t\"FrontE\
ndOnly\",\n\t[\n\t\t\"WListPlotly\",\n\t\t[\n\t\t\t\"FrontEndExecutable\",\n\
\t\t\t\"'myObject'\"\n\t\t]\n\t]\n]", 
     "cba53aa7-6c9d-462d-8ff4-b507069ab632" -> "[\n\t\"FrontEndOnly\",\n\t[\n\
\t\t\"WListPlotly\",\n\t\t[\n\t\t\t\"FrontEndExecutable\",\n\t\t\t\"'myObject\
'\"\n\t\t]\n\t]\n]", "3ca4a1fb-0700-4969-8fd0-f9fa91a8d260" -> "[\n\t\"FrontE\
ndOnly\",\n\t[\n\t\t\"WListPlotly\",\n\t\t[\n\t\t\t\"FrontEndExecutable\",\n\
\t\t\t\"'myObject'\"\n\t\t]\n\t]\n]"|>, 
   "path" -> "/Volumes/Data/Github/wolfram-js-frontend/Demo/test.wl", 
   "cell" -> "b2ab36d4-8f61-4801-8664-929cf4afe352", 
   "date" -> DateObject[{2023, 3, 5, 14, 7, 52.596019`8.473527848564718}, 
     "Instant", "Gregorian", 1.]|>, 
 "cells" -> {<|"id" -> "0bd9e81b-0c06-419a-9033-fa19483f6929", 
    "type" -> "input", "data" -> ".md\nDynamic update from the WL Kernel", 
    "display" -> "codemirror", "sign" -> "test", 
    "prev" -> "c793a4f7-5c19-45f1-880f-98e7e42d453d", 
    "next" -> "293a9275-8d16-4b7f-aa8d-5f18b8b20a72", "parent" -> Null, 
    "child" -> "f515986e-50d9-428b-a3ef-6d70058eb905", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "198386a9-6770-4c36-b566-f27e96a63da3", "type" -> "input", 
    "data" -> ".md\nNow we created a frontend object. Then, one can use it \
directly in frontend", "display" -> "codemirror", "sign" -> "test", 
    "prev" -> "b2ab36d4-8f61-4801-8664-929cf4afe352", 
    "next" -> "c793a4f7-5c19-45f1-880f-98e7e42d453d", "parent" -> Null, 
    "child" -> "8226ced3-ae44-4566-ad24-2582e4fe0806", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "293a9275-8d16-4b7f-aa8d-5f18b8b20a72", "type" -> "input", 
    "data" -> "Do[SetFrontEndObject[FrontEndExecutable[\"myObject\"],\n  {{\n \
 Table[i, {i,10}], \n  Table[1.0+0.5Sin[i*j]//N, \
{i,10}]\n}}]//Evaluate//SendToFrontEnd; Pause[0.3];, {j, 1,10}];", 
    "display" -> "codemirror", "sign" -> "test", 
    "prev" -> "0bd9e81b-0c06-419a-9033-fa19483f6929", 
    "next" -> "46591b57-606c-4de6-8ab4-0d6f549c4878", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "46591b57-606c-4de6-8ab4-0d6f549c4878", "type" -> "input", 
    "data" -> "JerryI`WolframJSFrontend`Remote`Private`notebook", 
    "display" -> "codemirror", "sign" -> "test", 
    "prev" -> "293a9275-8d16-4b7f-aa8d-5f18b8b20a72", "next" -> Null, 
    "parent" -> Null, "child" -> "9b7fc9af-380c-4f37-a501-8cc6c4a8907a", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "5af17c7f-2f48-4640-9c92-bba465587157", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"3ca4a1fb-0700-4969-8fd0-f9fa91a8d260\"]", 
    "display" -> "codemirror", "sign" -> "test", "prev" -> Null, 
    "next" -> Null, "parent" -> "c793a4f7-5c19-45f1-880f-98e7e42d453d", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8226ced3-ae44-4566-ad24-2582e4fe0806", "type" -> "output", 
    "data" -> "\nNow we created a frontend object. Then, one can use it \
directly in frontend", "display" -> "markdown", "sign" -> "test", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "198386a9-6770-4c36-b566-f27e96a63da3", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8e16b593-6fd9-42e8-b9d5-c11bfb0a528b", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"myObject\"]", "display" -> "codemirror", 
    "sign" -> "test", "prev" -> Null, "next" -> Null, 
    "parent" -> "b2ab36d4-8f61-4801-8664-929cf4afe352", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9b7fc9af-380c-4f37-a501-8cc6c4a8907a", "type" -> "output", 
    "data" -> "\"test\"", "display" -> "codemirror", "sign" -> "test", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "46591b57-606c-4de6-8ab4-0d6f549c4878", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "b2ab36d4-8f61-4801-8664-929cf4afe352", "type" -> "input", 
    "data" -> "CreateFrontEndObject[{{\n  Table[i, {i,10}], \n  Table[i^0, \
{i,10}]\n}}, \"myObject\"]", "display" -> "codemirror", "sign" -> "test", 
    "prev" -> Null, "next" -> "198386a9-6770-4c36-b566-f27e96a63da3", 
    "parent" -> Null, "child" -> "8e16b593-6fd9-42e8-b9d5-c11bfb0a528b", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c793a4f7-5c19-45f1-880f-98e7e42d453d", "type" -> "input", 
    "data" -> "CreateFrontEndObject[FrontEndOnly[\n  WListPlotly[\n    \
FrontEndExecutable[\"myObject\"]\n  ]\n]]", "display" -> "codemirror", 
    "sign" -> "test", "prev" -> "198386a9-6770-4c36-b566-f27e96a63da3", 
    "next" -> "0bd9e81b-0c06-419a-9033-fa19483f6929", "parent" -> Null, 
    "child" -> "5af17c7f-2f48-4640-9c92-bba465587157", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "f515986e-50d9-428b-a3ef-6d70058eb905", "type" -> "output", 
    "data" -> "\nDynamic update from the WL Kernel", "display" -> "markdown", 
    "sign" -> "test", "prev" -> Null, "next" -> Null, 
    "parent" -> "0bd9e81b-0c06-419a-9033-fa19483f6929", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn"|>
