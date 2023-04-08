<|"notebook" -> <|"name" -> "Booking", "id" -> "via-955c9", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"coords" -> <|"json" -> "[\"List\",0,0,0]", 
       "date" -> DateObject[{2023, 4, 8, 19, 11, 
          48.022846`8.434022870345043}, "Instant", "Gregorian", 3.]|>, 
     "aa28bb3f-d686-4cec-901c-3b97e382b07b" -> 
      <|"json" -> "[\"Graphics3D\",[\"Sphere\",[\"FrontEndExecutableHold\",\"\
'coords'\"]]]", "date" -> DateObject[{2023, 4, 8, 19, 11, 
          48.001724`8.433831811573423}, "Instant", "Gregorian", 3.]|>, 
     "f3f8ff4f-db63-4648-8fe8-fa893f4e7e1e" -> 
      <|"json" -> "[\"WEBSlider\",\"'d8e70df3-0ada-4bec-9115-f85e651ad7a1'\",\
[\"List\",0,4,0.1]]", "date" -> DateObject[{2023, 4, 8, 19, 14, 
          30.302402`8.234052036344336}, "Instant", "Gregorian", 3.]|>|>, 
   "path" -> "/root/wolfram-js-frontend/Demo/Virtual-Functions.wl", 
   "cell" -> "c8c20d16-d8d6-4aeb-a9b5-d53ca1a10bae", 
   "date" -> DateObject[{2023, 4, 8, 19, 14, 47.462842`8.428928715867984}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "0b88cfdb-f100-46a9-867c-05af987089b9", 
    "type" -> "output", "data" -> 
     "FrontEndExecutable[\"f3f8ff4f-db63-4648-8fe8-fa893f4e7e1e\"]", 
    "display" -> "codemirror", "sign" -> "via-955c9", "prev" -> Null, 
    "next" -> Null, "parent" -> "912430de-0c74-40a2-b6a8-b04761d1d7d1", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "20c5e107-c637-4a1f-90c0-b0a408389d35", "type" -> "input", 
    "data" -> 
     "Graphics3D[Sphere[FrontEndRef[FrontEndExecutable[\"coords\"]]]]", 
    "display" -> "codemirror", "sign" -> "via-955c9", 
    "prev" -> "88b6553d-8927-49b8-aec6-9118e7524f8c", 
    "next" -> "912430de-0c74-40a2-b6a8-b04761d1d7d1", "parent" -> Null, 
    "child" -> "6bb3ae5b-a657-4bba-99da-9cccc996e1c4", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6bb3ae5b-a657-4bba-99da-9cccc996e1c4", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"aa28bb3f-d686-4cec-901c-3b97e382b07b\"]", 
    "display" -> "codemirror", "sign" -> "via-955c9", "prev" -> Null, 
    "next" -> Null, "parent" -> "20c5e107-c637-4a1f-90c0-b0a408389d35", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "79bf7ea0-c72a-42a3-a221-f22a4703a822", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"coords\"]", "display" -> "codemirror", 
    "sign" -> "via-955c9", "prev" -> Null, "next" -> Null, 
    "parent" -> "88b6553d-8927-49b8-aec6-9118e7524f8c", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "88b6553d-8927-49b8-aec6-9118e7524f8c", "type" -> "input", 
    "data" -> "obj = CreateFrontEndObject[{0,0,0}, \"coords\"]", 
    "display" -> "codemirror", "sign" -> "via-955c9", 
    "prev" -> "c8c20d16-d8d6-4aeb-a9b5-d53ca1a10bae", 
    "next" -> "20c5e107-c637-4a1f-90c0-b0a408389d35", "parent" -> Null, 
    "child" -> "79bf7ea0-c72a-42a3-a221-f22a4703a822", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "912430de-0c74-40a2-b6a8-b04761d1d7d1", "type" -> "input", 
    "data" -> "slider = \
Slider[0,4,0.1];\nFunction[x,FrontEndExecutable[\"coords\"]={0,0,x};] // \
slider;\nslider", "display" -> "codemirror", "sign" -> "via-955c9", 
    "prev" -> "20c5e107-c637-4a1f-90c0-b0a408389d35", "next" -> Null, 
    "parent" -> Null, "child" -> "0b88cfdb-f100-46a9-867c-05af987089b9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c038b3d8-792d-4488-bdab-4469fd38975b", "type" -> "output", 
    "data" -> "\nTest with virtual functions", "display" -> "markdown", 
    "sign" -> "via-955c9", "prev" -> Null, "next" -> Null, 
    "parent" -> "c8c20d16-d8d6-4aeb-a9b5-d53ca1a10bae", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c8c20d16-d8d6-4aeb-a9b5-d53ca1a10bae", "type" -> "input", 
    "data" -> ".md\nTest with virtual functions", "display" -> "codemirror", 
    "sign" -> "via-955c9", "prev" -> Null, 
    "next" -> "88b6553d-8927-49b8-aec6-9118e7524f8c", "parent" -> Null, 
    "child" -> "c038b3d8-792d-4488-bdab-4469fd38975b", 
    "props" -> <|"hidden" -> True|>|>}, "serializer" -> "jsfn2"|>