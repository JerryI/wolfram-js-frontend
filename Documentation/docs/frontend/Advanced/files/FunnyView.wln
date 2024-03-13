<|"notebook" -> <|"name" -> "Dastard", "id" -> "anteater-487a5", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"affbf6af-47d1-40ac-a85a-8a13e73fe328" -> 
      <|"json" -> "[\"RangeView\",[\"List\",0,1,0.1,0.5],[\"Rule\",\"'Event'\
\",\"'f4155644-dff4-4373-9661-60049fdd7235'\"]]", 
       "date" -> DateObject[{2023, 6, 23, 21, 15, 
          40.394862`8.35890110704972}, "Instant", "Gregorian", 3.]|>, 
     "920ee9cb-d3f3-479b-9649-ebf93dcabbfc" -> 
      <|"json" -> "[\"ListLinePlotly\",[\"Hold\",\"data\"]]", 
       "date" -> DateObject[{2023, 6, 23, 21, 15, 
          37.190118`8.323002535396078}, "Instant", "Gregorian", 3.]|>, 
     "640a21c3-980f-4f42-b57b-41137d7d0b1e" -> 
      <|"json" -> "[\"SpecialView\",[\"List\",[\"FrontEndExecutableHold\",\"'\
affbf6af-47d1-40ac-a85a-8a13e73fe328'\"],[\"FrontEndExecutableHold\",\"'920ee\
9cb-d3f3-479b-9649-ebf93dcabbfc'\"]]]", "date" -> 
        DateObject[{2023, 6, 23, 21, 15, 37.155679`8.322600181279622}, 
         "Instant", "Gregorian", 3.]|>|>, 
   "path" -> "/Volumes/Data/Github/wolfram-js-frontend/null/FunnyView.wl", 
   "cell" :> Exit[], "date" -> DateObject[{2023, 6, 23, 21, 8, 
      45.50501`8.410634191028317}, "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "891a000c-1291-43f2-8228-7d74f5a9737e", 
    "type" -> "input", "data" -> ".js\ncore.SpecialView = async (args, env) \
=> {\n  const dom = env.element;\n  const items = await interpretate(args[0], \
{...env, hold: true});\n  let distance = 0;\n\n  for (const i of \
items.reverse()) {\n    const element = document.createElement('div');\n    \
element.display = \"block\";\n    element.padding = \"1em\";\n    \
element.style.transform = `rotate(${Math.random()*45}deg)`;\n    await \
interpretate(i, {...env, element: element});\n    dom.appendChild(element);\n \
 }\n}", "display" -> "codemirror", "sign" -> "anteater-487a5", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "1cf8e842-2cbc-498b-bf68-ded18e5fce50", "type" -> "output", 
    "data" -> "\ncore.SpecialView = async (args, env) => {\n  const dom = \
env.element;\n  const items = await interpretate(args[0], {...env, hold: \
true});\n  let distance = 0;\n\n  for (const i of items.reverse()) {\n    \
const element = document.createElement('div');\n    element.display = \
\"block\";\n    element.padding = \"1em\";\n    element.style.transform = \
`rotate(${Math.random()*45}deg)`;\n    await interpretate(i, {...env, \
element: element});\n    dom.appendChild(element);\n  }\n}", 
    "display" -> "js", "sign" -> "anteater-487a5", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "e8d90023-51cc-460e-9dd1-024d8174b657", "type" -> "input", 
    "data" -> ".md\nNow lets try to apply this", "display" -> "codemirror", 
    "sign" -> "anteater-487a5", "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "9609e719-5f1a-4baa-b0f7-f099534b104f", "type" -> "output", 
    "data" -> "\nNow lets try to apply this", "display" -> "markdown", 
    "sign" -> "anteater-487a5", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "4d365f43-1adc-4ab8-85b2-2b5d2ed5e673", "type" -> "input", 
    "data" -> "slider = InputRange[0,1,0.1];\nFunction[d, data = \
Table[Sin[x]Exp[-CM6Fraction[(d CM6Superscript[x, 2]), 10]], \
{x,-6Pi,6Pi,0.1}]] // slider;\n\nslider // EventFire;\n\nplot = \
ListLinePlotly[data // Hold];\n\nSpecialView[{\n  slider // \
CreateFrontEndObject,\n  plot // CreateFrontEndObject\n}] // \
CreateFrontEndObject", "display" -> "codemirror", "sign" -> "anteater-487a5", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "fe5dcd9e-ba46-4c79-adff-ade2372858a6", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"640a21c3-980f-4f42-b57b-41137d7d0b1e\"]", 
    "display" -> "codemirror", "sign" -> "anteater-487a5", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn3"|>
