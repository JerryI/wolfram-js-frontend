<|"notebook" -> <|"name" -> "Greyness", "id" -> "Sunday-96826", 
   "kernel" -> LocalKernel, "objects" :> 
    <|"bcfca83b-7ac5-4ada-ba39-14dcb0b6a224" -> 
      <|"json" -> "[\"Graphics\",[\"List\",[\"GrayLevel\",1],[\"EventListener\
\",[\"Rectangle\",[\"List\",-2,2],[\"List\",2,-2]],[\"Rule\",\"'mousemove'\",\
\"'8595b8d0-a065-483b-bd49-ed087ad97c54'\"]],[\"PointSize\",5.0e-2],[\"RGBCol\
or\",0,1,1],[\"Point\",[\"Offload\",\"p\"]]]]", 
       "date" -> DateObject[{2023, 9, 1, 21, 15, 
          3.676075`7.3179593517069845}, "Instant", "Gregorian", 2.]|>, 
     "3912b385-022c-4e07-bad9-2df30463ecf5" -> 
      <|"json" -> "[\"CustomButtonView\",[\"Rule\",\"'Label'\",\"'Woo'\"],[\"\
Rule\",\"'Event'\",\"'813960a9-7fa0-4eac-8dc6-996631996a64'\"]]", 
       "date" -> DateObject[{2023, 9, 1, 21, 43, 
          53.227682`8.478712528298766}, "Instant", "Gregorian", 2.]|>|>, 
   "path" -> "/Users/kirill/Library/CloudStorage/OneDrive-Personal/\:0414\
\:043e\:043a\:0443\:043c\:0435\:043d\:0442\:044b/\:041a\:043e\:043d\:0444\
\:0435\:0440\:0435\:043d\:0446\:0438\:0438/Romania 2023/Greyness.wl", 
   "cell" :> Exit[], "date" -> DateObject[{2023, 9, 1, 22, 0, 
      59.265964`8.52538032594834}, "Instant", "Gregorian", 2.], 
   "symbols" -> <|"p" -> <|"date" -> DateObject[{2023, 9, 1, 22, 0, 
          59.300367`8.52563235421563}, "Instant", "Gregorian", 2.], 
       "data" -> {-0.8343137254901961, 0.4092421371233455}|>|>, 
   "channel" -> WebSocketChannel[
     KirillBelov`WebSocketHandler`WebSocketChannel`$16]|>, 
 "cells" -> {<|"id" -> "362dca3a-d235-40b1-bd45-2edc40bf53e6", 
    "type" -> "input", "data" -> "p = \
{0,0};\nGraphics[{\n\tWhite,\n\tEventHandler[\n\t\tRectangle[{-2,2}, \
{2,-2}],\n\t\t{\"mousemove\"->Function[xy, p = xy]}\n\t],\n\tPointSize[0.05], \
Cyan,\n\tPoint[p // Offload]\n}]", "display" -> "codemirror", 
    "sign" -> "Sunday-96826", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "d2bfd87d-94bb-49fe-83d8-902db4acfea9", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"bcfca83b-7ac5-4ada-ba39-14dcb0b6a224\"]", 
    "display" -> "codemirror", "sign" -> "Sunday-96826", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "1f8328f2-4336-404d-97aa-3a60ee304358", "type" -> "input", 
    "data" -> "", "display" -> "codemirror", "sign" -> "Sunday-96826", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "cd353cce-13be-4a53-ae48-a8bbe8709afb", "type" -> "input", 
    "data" -> ".js\n\ncore.CustomButtonView = async (args, env) => {\n  const \
options = await core._getRules(args, env);\n  const button = \
document.createElement('input');\n  button.type = \"button\";\n  button.value \
= options.Label;\n  button.addEventListener('click', ()=>{\n    \
server.emitt(options.Event, '\"Clicked!\"');\n  });\n\n  \
env.element.appendChild(button);\n}\n\nreturn null;", 
    "display" -> "codemirror", "sign" -> "Sunday-96826", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "2d95d5b1-4d57-4b2f-b42a-09ddf287cf6f", "type" -> "output", 
    "data" -> "\n\ncore.CustomButtonView = async (args, env) => {\n  const \
options = await core._getRules(args, env);\n  const button = \
document.createElement('input');\n  button.type = \"button\";\n  button.value \
= options.Label;\n  button.addEventListener('click', ()=>{\n    \
server.emitt(options.Event, '\"Clicked!\"');\n  });\n\n  \
env.element.appendChild(button);\n}\n\nreturn null;", "display" -> "js", 
    "sign" -> "Sunday-96826", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a6de4ded-6f21-4260-b0b9-8aeac46ffe46", "type" -> "input", 
    "data" -> "CustomButton[label_] := With[{uid = CreateUUID[]},\n  \
EventObject[<|\"id\"->uid, \"initial\"->False, \
\"view\"->CustomButtonView[\"Label\"->label, \"Event\"->uid]|>]\n]", 
    "display" -> "codemirror", "sign" -> "Sunday-96826", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "ccfa88a0-b1e3-4532-9e77-1a80308f71b1", "type" -> "input", 
    "data" -> "CustomButton[\"Woo\"]", "display" -> "codemirror", 
    "sign" -> "Sunday-96826", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "7db95e3a-64fa-442c-b361-481c22774bf8", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"3912b385-022c-4e07-bad9-2df30463ecf5\"]", 
    "display" -> "codemirror", "sign" -> "Sunday-96826", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn3"|>
