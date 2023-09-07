<|"notebook" -> <|"name" -> "Incongruousness", "id" -> "sleeveless-50a3b", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"20f246d7-f66c-45de-abbb-a19a040d02e0" -> 
      <|"json" -> "[\"PlaceholderClock\"]", "date" -> 
        DateObject[{2023, 6, 19, 15, 20, 53.150314`8.478080809284236}, 
         "Instant", "Gregorian", 3.]|>|>, "path" -> "/Volumes/Data/Github/wol\
fram-js-frontend/Examples/Advanced/Clocks-Memory.wl", 
   "cell" -> "fd5a0793-c71a-43c2-91a2-1011a4bdb5c640b", 
   "date" -> DateObject[{2023, 6, 19, 15, 20, 49.692365`8.448864642333461}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "fd5a0793-c71a-43c2-91a2-1011a4bdb5c640b", 
    "type" -> "input", "data" -> ".js\ncore.PlaceholderClock = async (args, \
env) => {\n\t//store the handler object in the local \
memory\n\tenv.local.start = new Date();\n\tenv.local.clock = \
setInterval(()=>{\n\t\tconst d = (new Date() - \
env.local.start);\n\t\tenv.element.innerHTML = d;\n\t}, 10);\n}\n//when our \
instance is about to be destoryed - clear \
timer\ncore.PlaceholderClock.destroy = (args, env) => \
{\n\twindow.clearInterval(env.local.clock);\n\tconst passed = (new Date() - \
env.local.start);\n\talert(passed+' passed');\n}", "display" -> "codemirror", 
    "sign" -> "sleeveless-50a3b", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "0c929185-77f1-4fff-806f-e3221f2926ee40b", "type" -> "output", 
    "data" -> "\ncore.PlaceholderClock = (args, env) => {\n\t//store the \
handler object in the local memory\n\tenv.local.start = new \
Date();\n\tenv.local.clock = setInterval(()=>{\n\t\tconst d = (new Date() - \
env.local.start);\n\t\tenv.element.innerHTML = d;\n\t}, 10);\n}\n//when our \
instance is about to be destoryed - clear \
timer\ncore.PlaceholderClock.destroy = (args, env) => \
{\n\twindow.clearInterval(env.local.clock);\n\tconst passed = (new Date() - \
env.local.start);\n\talert(passed+' passed');\n}", "display" -> "js", 
    "sign" -> "sleeveless-50a3b", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3525d659-e49d-4ecb-89ad-f31e5fe9f4e740b", "type" -> "input", 
    "data" -> "CreateFrontEndObject[PlaceholderClock[]]", 
    "display" -> "codemirror", "sign" -> "sleeveless-50a3b", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "f85ede1e-fae4-4661-a16d-a0b70b2e388240b", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"20f246d7-f66c-45de-abbb-a19a040d02e0\"]", 
    "display" -> "codemirror", "sign" -> "sleeveless-50a3b", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn3"|>
