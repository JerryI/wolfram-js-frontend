<|"notebook" -> <|"name" -> "Booking", "id" -> "thought-21e1b", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"coords" -> <|"json" -> "[\"List\",0,0,0]", 
       "date" -> DateObject[{2023, 4, 10, 17, 46, 
          19.053656`8.032553304056744}, "Instant", "Gregorian", 3.]|>, 
     "aa28bb3f-d686-4cec-901c-3b97e382b07b" -> 
      <|"json" -> "[\"Graphics3D\",[\"Sphere\",[\"FrontEndExecutableHold\",\"\
'coords'\"]]]", "date" -> DateObject[{2023, 4, 10, 17, 46, 
          19.032127`8.032062311032034}, "Instant", "Gregorian", 3.]|>, 
     "f3f8ff4f-db63-4648-8fe8-fa893f4e7e1e" -> 
      <|"json" -> "[\"WEBSlider\",\"'d8e70df3-0ada-4bec-9115-f85e651ad7a1'\",\
[\"List\",0,4,0.1]]", "date" -> DateObject[{2023, 4, 10, 17, 46, 
          19.069286`8.032909416296585}, "Instant", "Gregorian", 3.]|>, 
     "f2800669-4547-4f75-8f68-6a9e2ca73c81" -> 
      <|"json" -> "[\"WEBSlider\",\"'41315956-768c-4e6c-a164-7af364a2bdde'\",\
[\"List\",0,4,0.1]]", "date" -> DateObject[{2023, 4, 10, 17, 46, 
          59.139401`8.524451894479945}, "Instant", "Gregorian", 3.]|>|>, 
   "path" -> "/Volumes/Data/Github/wolfram-js-frontend/Demo/Examples/Frontend \
functions/Virtual-Functions.wl", 
   "cell" -> "c8c20d16-d8d6-4aeb-a9b5-d53ca1a10baecd4175", 
   "date" -> DateObject[{2023, 4, 19, 20, 43, 55.174018`8.494309586386857}, 
     "Instant", "Gregorian", 2.]|>, 
 "cells" -> {<|"id" -> "18148e67-6031-4895-86db-eb8e35af8d7b175", 
    "type" -> "output", "data" -> 
     "FrontEndExecutable[\"f2800669-4547-4f75-8f68-6a9e2ca73c81\"]", 
    "display" -> "codemirror", "sign" -> "thought-21e1b", "prev" -> Null, 
    "next" -> Null, "parent" -> "912430de-0c74-40a2-b6a8-b04761d1d7d1cd4175", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "20c5e107-c637-4a1f-90c0-b0a408389d35cd4175", "type" -> "input", 
    "data" -> 
     "Graphics3D[Sphere[FrontEndRef[FrontEndExecutable[\"coords\"]]]]", 
    "display" -> "codemirror", "sign" -> "thought-21e1b", 
    "prev" -> "88b6553d-8927-49b8-aec6-9118e7524f8ccd4175", 
    "next" -> "912430de-0c74-40a2-b6a8-b04761d1d7d1cd4175", "parent" -> Null, 
    "child" -> "6bb3ae5b-a657-4bba-99da-9cccc996e1c4cd4175", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6bb3ae5b-a657-4bba-99da-9cccc996e1c4cd4175", 
    "type" -> "output", "data" -> 
     "FrontEndExecutable[\"aa28bb3f-d686-4cec-901c-3b97e382b07b\"]", 
    "display" -> "codemirror", "sign" -> "thought-21e1b", "prev" -> Null, 
    "next" -> Null, "parent" -> "20c5e107-c637-4a1f-90c0-b0a408389d35cd4175", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "79bf7ea0-c72a-42a3-a221-f22a4703a822cd4175", 
    "type" -> "output", "data" -> "FrontEndExecutable[\"coords\"]", 
    "display" -> "codemirror", "sign" -> "thought-21e1b", "prev" -> Null, 
    "next" -> Null, "parent" -> "88b6553d-8927-49b8-aec6-9118e7524f8ccd4175", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "88b6553d-8927-49b8-aec6-9118e7524f8ccd4175", "type" -> "input", 
    "data" -> "obj = CreateFrontEndObject[{0,0,0}, \"coords\"]", 
    "display" -> "codemirror", "sign" -> "thought-21e1b", 
    "prev" -> "c8c20d16-d8d6-4aeb-a9b5-d53ca1a10baecd4175", 
    "next" -> "20c5e107-c637-4a1f-90c0-b0a408389d35cd4175", "parent" -> Null, 
    "child" -> "79bf7ea0-c72a-42a3-a221-f22a4703a822cd4175", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "912430de-0c74-40a2-b6a8-b04761d1d7d1cd4175", "type" -> "input", 
    "data" -> "slider = \
Slider[0,4,0.1];\nFunction[x,FrontEndExecutable[\"coords\"]={0,0,x};] // \
slider;\nslider", "display" -> "codemirror", "sign" -> "thought-21e1b", 
    "prev" -> "20c5e107-c637-4a1f-90c0-b0a408389d35cd4175", "next" -> Null, 
    "parent" -> Null, "child" -> "18148e67-6031-4895-86db-eb8e35af8d7b175", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c038b3d8-792d-4488-bdab-4469fd38975bcd4175", 
    "type" -> "output", "data" -> "\nTest with virtual functions", 
    "display" -> "markdown", "sign" -> "thought-21e1b", "prev" -> Null, 
    "next" -> Null, "parent" -> "c8c20d16-d8d6-4aeb-a9b5-d53ca1a10baecd4175", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c8c20d16-d8d6-4aeb-a9b5-d53ca1a10baecd4175", "type" -> "input", 
    "data" -> ".md\nTest with virtual functions", "display" -> "codemirror", 
    "sign" -> "thought-21e1b", "prev" -> Null, 
    "next" -> "88b6553d-8927-49b8-aec6-9118e7524f8ccd4175", "parent" -> Null, 
    "child" -> "c038b3d8-792d-4488-bdab-4469fd38975bcd4175", 
    "props" -> <|"hidden" -> True|>|>}, "serializer" -> "jsfn2"|>
