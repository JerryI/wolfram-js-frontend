<|"notebook" -> <|"name" -> "Rheumatoid", "id" -> "assets-c66fb", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"7042192c-2c6f-4e93-bc31-a23fa1f4f742" -> 
      <|"json" -> "[\"Graphics\",[\"List\",[\"RGBColor\",1,0,0],[\"PointSize\
\",0.1],[\"EventListener\",[\"Point\",[\"List\",[\"List\",0.5,0.5]]],[\"Rule\
\",\"'drag'\",\"'2eb34776-b14a-495a-81fd-388ef6a56c23'\"]],[\"RGBColor\",0,1,\
1],[\"Line\",[\"FrontEndRef\",\"'dot'\"]]]]", 
       "date" -> DateObject[{2023, 5, 13, 18, 6, 8.89086`7.701518758655695}, 
         "Instant", "Gregorian", 2.]|>, 
     "dot" -> <|"json" -> "[\"List\",[\"List\",0,0],[\"List\",0.5,0.5]]", 
       "date" -> DateObject[{2023, 5, 29, 14, 33, 
          50.109493`8.452494984163481}, "Instant", "Gregorian", 2.]|>, 
     "7b2cc566-3290-4c90-aa48-ceed3f0851ba" -> 
      <|"json" -> "[\"Graphics\",[\"List\",[\"RGBColor\",1,0,0],[\"PointSize\
\",0.1],[\"EventListener\",[\"Point\",[\"List\",[\"List\",0.5,0.5]]],[\"Rule\
\",\"'drag'\",\"'091c73f6-5ef1-430e-9a58-ac75a1c1d972'\"]],[\"RGBColor\",0,1,\
1],[\"Line\",[\"FrontEndRef\",\"'dot'\"]]]]", 
       "date" -> DateObject[{2023, 5, 13, 18, 6, 12.200765`7.83896204810779}, 
         "Instant", "Gregorian", 2.]|>, 
     "5d353865-749f-42a7-8957-ad84815c40de" -> 
      <|"json" -> "[\"Graphics\",[\"List\",[\"RGBColor\",1,0,0],[\"PointSize\
\",0.1],[\"EventListener\",[\"Point\",[\"List\",[\"List\",0.5,0.5]]],[\"Rule\
\",\"'drag'\",\"'064c6638-bde0-4b41-be84-aa5ab0ff076f'\"]],[\"RGBColor\",0,1,\
1],[\"Line\",[\"FrontEndRef\",\"'dot'\"]]]]", 
       "date" -> DateObject[{2023, 5, 13, 18, 6, 
          16.585194`7.972295540701858}, "Instant", "Gregorian", 2.]|>, 
     "df5110cb-16b9-409c-b00c-1531ccde9556" -> 
      <|"json" -> "[\"Graphics\",[\"List\",[\"RGBColor\",1,0,0],[\"PointSize\
\",0.1],[\"EventListener\",[\"Point\",[\"List\",[\"List\",0.5,0.5]]],[\"Rule\
\",\"'drag'\",\"'6fc181a8-18a9-4e6f-81fd-9ee5562b5296'\"]],[\"Line\",[\"Front\
EndRef\",\"'dot'\"]]]]", "date" -> DateObject[{2023, 5, 27, 18, 44, 
          22.822676`8.1109415480399}, "Instant", "Gregorian", 2.]|>, 
     "e20a75cc-b8e7-4647-bcb7-f401c3514935" -> 
      <|"json" -> "[\"Graphics\",[\"List\",[\"RGBColor\",1,0,0],[\"PointSize\
\",0.1],[\"EventListener\",[\"Point\",[\"List\",[\"List\",0.5,0.5]]],[\"Rule\
\",\"'drag'\",\"'1e7042bf-256d-4f91-a8ed-0f3b53abb4f5'\"]],[\"Line\",[\"Front\
EndRef\",\"'dot'\"]]]]", "date" -> DateObject[{2023, 5, 27, 18, 44, 
          30.083147`8.230898246847948}, "Instant", "Gregorian", 2.]|>, 
     "2eb3b616-9e1f-4ead-a620-7e354f97d9bb" -> 
      <|"json" -> "[\"Graphics\",[\"List\",[\"RGBColor\",1,0,0],[\"PointSize\
\",0.1],[\"EventListener\",[\"Point\",[\"List\",[\"List\",0.5,0.5]]],[\"Rule\
\",\"'drag'\",\"'16f50f97-6e21-4ba5-b902-340692c9f58f'\"]],[\"Line\",[\"Front\
EndRef\",\"'dot'\"]]]]", "date" -> DateObject[{2023, 5, 29, 14, 33, 
          50.000805`8.451551971943196}, "Instant", "Gregorian", 2.]|>|>, 
   "path" -> "/Volumes/Data/Github/wolfram-js-frontend/Demo/Easy/Interactive-\
graphics-Clone.wl", "cell" :> Exit[], 
   "date" -> DateObject[{2023, 6, 4, 12, 34, 41.833824`8.374102542920916}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "3af700ce-2c89-4a74-bb0f-20eb79c5c7e9ca0314", 
    "type" -> "input", "data" -> ".md\n# Interactive graphics\nSimple \
event-listener attached to a graphical object", "display" -> "codemirror", 
    "sign" -> "assets-c66fb", "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "60d2ae20-b4aa-4a5d-8f49-abb00c1fd2d3ca0314", 
    "type" -> "output", "data" -> "\n# Interactive graphics\nSimple \
event-listener attached to a graphical object", "display" -> "markdown", 
    "sign" -> "assets-c66fb", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "98d7f48c-bd71-4da5-b3e4-816a0104515fca0314", "type" -> "input", 
    "data" -> "\nCreateFrontEndObject[{{0,0}, {0.5,0.5}}, \
\"dot\"];\nGraphics[{\n  Red, PointSize[0.1], \n  \
EventHandler[Point[{{0.5,0.5}}], { \"drag\" -> Function[p, \
FrontEndRef[\"dot\"] = {{0,0}, p}] }],\n  Line[FrontEndRef[\"dot\"]]\n}]", 
    "display" -> "codemirror", "sign" -> "assets-c66fb", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8c63eb7f-eab7-4714-a066-66c40649e3b7ca0314", 
    "type" -> "output", "data" -> 
     "FrontEndExecutable[\"2eb3b616-9e1f-4ead-a620-7e354f97d9bb\"]", 
    "display" -> "codemirror", "sign" -> "assets-c66fb", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn3"|>
