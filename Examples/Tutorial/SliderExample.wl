<|"notebook" -> <|"name" -> "Unconventional", "id" -> "farina-10ac6", 
   "kernel" -> LocalKernel, "objects" :> 
    Association["65343d29-969e-489b-a266-8cb5fd8f9e21" -> 
      Association["json" -> "[\"Graphics\",[\"List\",[\"RGBColor\",0,1,1],[\"\
Line\",[\"Hold\",[\"Table\",[\"List\",[\"Cos\",\"x\"],[\"Sin\",[\"Times\",\"v\
\",\"x\"]]],[\"List\",\"x\",0,[\"Times\",2,\"Pi\"],1]]]]]]", 
       "date" -> DateObject[{2023, 6, 12, 15, 0, 3.140943`7.249635043488979}, 
         "Instant", "Gregorian", 3.]], 
     "639f2b15-b4ec-4414-b3b1-9732ce4159ab" -> 
      Association["json" -> "[\"Graphics\",[\"List\",[\"RGBColor\",0,1,1],[\"\
Line\",[\"Hold\",[\"With\",[\"List\",[\"Set\",\"y\",\"v\"]],[\"Table\",[\"Lis\
t\",[\"Cos\",\"x\"],[\"Sin\",[\"Times\",\"y\",\"x\"]]],[\"List\",\"x\",0,[\"T\
imes\",2,\"Pi\"],1]]]]]]]", "date" -> DateObject[{2023, 6, 12, 15, 1, 
          41.827597`8.37403789300913}, "Instant", "Gregorian", 3.]], 
     "b2641a6f-e9b5-4441-b63a-a556bb7b3442" -> 
      Association["json" -> "[\"Graphics\",[\"List\",[\"RGBColor\",0,1,1],[\"\
Line\",[\"Hold\",[\"With\",[\"List\",[\"Set\",\"y\",\"v\"]],[\"Table\",[\"Lis\
t\",[\"Cos\",\"x\"],[\"Sin\",[\"Times\",\"y\",\"x\"]]],[\"List\",\"x\",0,[\"T\
imes\",2,\"Pi\"],1.0e-2]]]]]]]", "date" -> DateObject[{2023, 6, 12, 15, 9, 
          6.58157`7.570904492232393}, "Instant", "Gregorian", 3.]], 
     "8f14b147-aa5d-4bed-bcae-0694e74bf46b" -> 
      Association["json" -> "[\"RangeView\",[\"List\",0,6,0.5,3.0],[\"Rule\",\
\"'Event'\",\"'a10e1162-f97e-4b73-87d6-1adc98044ba2'\"]]", 
       "date" -> DateObject[{2023, 6, 12, 15, 10, 
          30.890313`8.242397289844828}, "Instant", "Gregorian", 3.]]], 
   "path" -> "/Volumes/Data/Github/wolfram-js-frontend/Examples/Tutorial/Slid\
erExample.wl", "cell" :> Exit[], 
   "date" -> DateObject[{2023, 6, 19, 16, 5, 39.652507`8.350845628986978}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "4745e2e0-1b05-428d-a199-436a1c906784a10", 
    "type" -> "input", "data" -> ".md\nTo define slider use `InputRange` \
symbol (simillar to one you have in HTML)", "display" -> "codemirror", 
    "sign" -> "farina-10ac6", "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "abfe7f91-841f-45e0-9ac8-ddb2a6ae1960a10", "type" -> "output", 
    "data" -> "\nTo define slider use `InputRange` symbol (simillar to one \
you have in HTML)", "display" -> "markdown", "sign" -> "farina-10ac6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "7c554830-72d5-418a-837b-79eb27978a30a10", "type" -> "input", 
    "data" -> "slider = InputRange[0,6, 0.5] ", "display" -> "codemirror", 
    "sign" -> "farina-10ac6", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "979b088e-fb43-43af-91d0-5b15fc7b7bbca10", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"8f14b147-aa5d-4bed-bcae-0694e74bf46b\"]", 
    "display" -> "codemirror", "sign" -> "farina-10ac6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a24df664-f06a-40b4-bfb9-49c4451cc452a10", "type" -> "input", 
    "data" -> ".md\nNow one can assign an event handler function to the event \
object `slider`", "display" -> "codemirror", "sign" -> "farina-10ac6", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "0bec7481-a119-44e3-a5cb-b64bfca90975a10", "type" -> "output", 
    "data" -> "\nNow one can assign an event handler function to the event \
object `slider`", "display" -> "markdown", "sign" -> "farina-10ac6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a7c6e62f-9439-4761-97ae-9ceb18712663a10", "type" -> "input", 
    "data" -> "Function[data, v = data] // slider", 
    "display" -> "codemirror", "sign" -> "farina-10ac6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a06737fe-7306-4faf-a02d-67cf1cd6b706a10", "type" -> "input", 
    "data" -> ".md\nLet's attach to our variable something interesting", 
    "display" -> "codemirror", "sign" -> "farina-10ac6", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "b1e8bbb3-baca-421c-87b4-ee668fe3d9c2a10", "type" -> "output", 
    "data" -> "\nLet's attach to our variable something interesting", 
    "display" -> "markdown", "sign" -> "farina-10ac6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "857c08de-6d71-4ee9-ad17-ea635e1cbd8ca10", "type" -> "input", 
    "data" -> "v = 1;", "display" -> "codemirror", "sign" -> "farina-10ac6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8983fc77-9004-491b-b0f9-c657a4ead974a10", "type" -> "input", 
    "data" -> "Graphics[{Cyan, Line[With[{y = v}, Table[{Cos[x], Sin[y x]}, \
{x,0,2$Pi$, 0.01}]] // Hold]}]", "display" -> "codemirror", 
    "sign" -> "farina-10ac6", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "945cb1b3-f0cc-462d-a919-c35af7fa4dbda10", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"b2641a6f-e9b5-4441-b63a-a556bb7b3442\"]", 
    "display" -> "codemirror", "sign" -> "farina-10ac6", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn3"|>
