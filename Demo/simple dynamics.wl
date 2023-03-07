<|"notebook" -> <|"name" -> "Untitled", "id" -> "test", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"myObject" -> "[\n\t\"List\",\n\t0.0,\n\t9.983341664682815e-2,\n\t0.198\
66933079506122,\n\t0.2955202066613396,\n\t0.3894183423086505,\n\t0.4794255386\
04203,\n\t0.5646424733950355,\n\t0.6442176872376911,\n\t0.7173560908995228,\n\
\t0.7833269096274833,\n\t0.8414709848078965,\n\t0.8912073600614354,\n\t0.9320\
390859672264,\n\t0.963558185417193,\n\t0.9854497299884603,\n\t0.9974949866040\
544,\n\t0.9995736030415051,\n\t0.9916648104524686,\n\t0.9738476308781951,\n\t\
0.9463000876874145,\n\t0.9092974268256817,\n\t0.8632093666488738,\n\t0.808496\
4038195901,\n\t0.74570521217672,\n\t0.6754631805511506,\n\t0.5984721441039564\
,\n\t0.5155013718214642,\n\t0.4273798802338298,\n\t0.33498815015590466,\n\t0.\
23924932921398198,\n\t0.1411200080598672,\n\t4.158066243329049e-2,\n\t-5.8374\
143427580086e-2,\n\t-0.15774569414324865,\n\t-0.25554110202683167,\n\t-0.3507\
8322768961984,\n\t-0.44252044329485246,\n\t-0.5298361409084934,\n\t-0.6118578\
909427193,\n\t-0.6877661591839741,\n\t-0.7568024953079282,\n\t-0.818277111064\
4108,\n\t-0.8715757724135881,\n\t-0.9161659367494549,\n\t-0.9516020738895161,\
\n\t-0.977530117665097,\n\t-0.9936910036334645,\n\t-0.9999232575641008,\n\t-0\
.9961646088358406,\n\t-0.9824526126243325,\n\t-0.9589242746631385,\n\t-0.9258\
146823277321,\n\t-0.8834546557201531,\n\t-0.8322674422239008,\n\t-0.772764487\
5559871,\n\t-0.7055403255703919,\n\t-0.6312666378723208,\n\t-0.55068554259763\
76,\n\t-0.4646021794137566,\n\t-0.373876664830236,\n\t-0.27941549819892586,\n\
\t-0.18216250427209502,\n\t-8.308940281749641e-2\n]", 
     "5364c3b6-29bf-475f-9a08-a26c581e3938" -> "[\n\t\"FrontEndOnly\",\n\t[\n\
\t\t\"WListPlotly\",\n\t\t[\n\t\t\t\"FrontEndExecutable\",\n\t\t\t\"'myObject\
'\"\n\t\t]\n\t]\n]", "cba53aa7-6c9d-462d-8ff4-b507069ab632" -> "[\n\t\"FrontE\
ndOnly\",\n\t[\n\t\t\"WListPlotly\",\n\t\t[\n\t\t\t\"FrontEndExecutable\",\n\
\t\t\t\"'myObject'\"\n\t\t]\n\t]\n]", 
     "3ca4a1fb-0700-4969-8fd0-f9fa91a8d260" -> "[\n\t\"FrontEndOnly\",\n\t[\n\
\t\t\"WListPlotly\",\n\t\t[\n\t\t\t\"FrontEndExecutable\",\n\t\t\t\"'myObject\
'\"\n\t\t]\n\t]\n]", "2465cbfe-fee1-47f7-bc44-96efa8ec0740" -> "[\n\t\"FrontE\
ndOnly\",\n\t[\n\t\t\"ListLinePlotly\",\n\t\t[\n\t\t\t\"FrontEndExecutable\",\
\n\t\t\t\"'myObject'\"\n\t\t]\n\t]\n]"|>, 
   "path" -> "/Volumes/Data/Github/wolfram-js-frontend/Demo/test.wl", 
   "cell" -> "b2ab36d4-8f61-4801-8664-929cf4afe352", 
   "date" -> DateObject[{2023, 3, 5, 16, 52, 54.447227`8.48855074044659}, 
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
    "data" -> "Do[SetFrontEndObject[FrontEndExecutable[\"myObject\"],\n  \
Table[Sin[i*j]//N, {i,0, 2Pi, 0.1}]\n]//SendToFrontEnd; Pause[0.3];, {j, \
1,10}];", "display" -> "codemirror", "sign" -> "test", 
    "prev" -> "0bd9e81b-0c06-419a-9033-fa19483f6929", "next" -> Null, 
    "parent" -> Null, "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8226ced3-ae44-4566-ad24-2582e4fe0806", "type" -> "output", 
    "data" -> "\nNow we created a frontend object. Then, one can use it \
directly in frontend", "display" -> "markdown", "sign" -> "test", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "198386a9-6770-4c36-b566-f27e96a63da3", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8f9b8796-6b46-4c98-b598-5575aeb61f07", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"myObject\"]", "display" -> "codemirror", 
    "sign" -> "test", "prev" -> Null, "next" -> Null, 
    "parent" -> "b2ab36d4-8f61-4801-8664-929cf4afe352", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "ad99efd2-d966-4764-842b-038a9c1402f6", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"2465cbfe-fee1-47f7-bc44-96efa8ec0740\"]", 
    "display" -> "codemirror", "sign" -> "test", "prev" -> Null, 
    "next" -> Null, "parent" -> "c793a4f7-5c19-45f1-880f-98e7e42d453d", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "b2ab36d4-8f61-4801-8664-929cf4afe352", "type" -> "input", 
    "data" -> 
     "CreateFrontEndObject[Table[Sin[i]//N, {i,0,2Pi,0.1}], \"myObject\"]", 
    "display" -> "codemirror", "sign" -> "test", "prev" -> Null, 
    "next" -> "198386a9-6770-4c36-b566-f27e96a63da3", "parent" -> Null, 
    "child" -> "8f9b8796-6b46-4c98-b598-5575aeb61f07", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c793a4f7-5c19-45f1-880f-98e7e42d453d", "type" -> "input", 
    "data" -> "CreateFrontEndObject[FrontEndOnly[\n  \
ListLinePlotly[FrontEndExecutable[\"myObject\"]]\n]]", 
    "display" -> "codemirror", "sign" -> "test", 
    "prev" -> "198386a9-6770-4c36-b566-f27e96a63da3", 
    "next" -> "0bd9e81b-0c06-419a-9033-fa19483f6929", "parent" -> Null, 
    "child" -> "ad99efd2-d966-4764-842b-038a9c1402f6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "f515986e-50d9-428b-a3ef-6d70058eb905", "type" -> "output", 
    "data" -> "\nDynamic update from the WL Kernel", "display" -> "markdown", 
    "sign" -> "test", "prev" -> Null, "next" -> Null, 
    "parent" -> "0bd9e81b-0c06-419a-9033-fa19483f6929", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn"|>
