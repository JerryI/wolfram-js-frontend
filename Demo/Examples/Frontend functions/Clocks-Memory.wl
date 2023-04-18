<|"notebook" -> <|"name" -> "Incongruousness", "id" -> "sleeveless-50a3b", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"20f246d7-f66c-45de-abbb-a19a040d02e0" -> 
      <|"json" -> "[\"PlaceholderClock\"]", "date" -> 
        DateObject[{2023, 4, 9, 19, 41, 35.978533`8.308618430924584}, 
         "Instant", "Gregorian", 3.]|>|>, "path" -> "/root/wolfram-js-fronten\
d/Demo/Examples/Frontend functions/Clocks-Memory.wl", 
   "cell" -> "fd5a0793-c71a-43c2-91a2-1011a4bdb5c640b", 
   "date" -> DateObject[{2023, 4, 18, 15, 49, 32.012274`8.2578915058904}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "0c929185-77f1-4fff-806f-e3221f2926ee40b", 
    "type" -> "output", "data" -> "\ncore.PlaceholderClock = (args, env) => \
{\n\t//store the handler object in the local memory\n\tenv.local.start = new \
Date();\n\tenv.local.clock = setInterval(()=>{\n\t\tconst d = (new Date() - \
env.local.start);\n\t\tenv.element.innerHTML = d;\n\t}, 10);\n}\n//when our \
instance is about to be destoryed - clear \
timer\ncore.PlaceholderClock.destroy = (args, env) => \
{\n\twindow.clearInterval(env.local.clock);\n\tconst passed = (new Date() - \
env.local.start);\n\talert(passed+' passed');\n}", "display" -> "js", 
    "sign" -> "sleeveless-50a3b", "prev" -> Null, "next" -> Null, 
    "parent" -> "fd5a0793-c71a-43c2-91a2-1011a4bdb5c640b", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3525d659-e49d-4ecb-89ad-f31e5fe9f4e740b", "type" -> "input", 
    "data" -> "CreateFrontEndObject[PlaceholderClock[]]", 
    "display" -> "codemirror", "sign" -> "sleeveless-50a3b", 
    "prev" -> "fd5a0793-c71a-43c2-91a2-1011a4bdb5c640b", "next" -> Null, 
    "parent" -> Null, "child" -> "f85ede1e-fae4-4661-a16d-a0b70b2e388240b", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "f85ede1e-fae4-4661-a16d-a0b70b2e388240b", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"20f246d7-f66c-45de-abbb-a19a040d02e0\"]", 
    "display" -> "codemirror", "sign" -> "sleeveless-50a3b", "prev" -> Null, 
    "next" -> Null, "parent" -> "3525d659-e49d-4ecb-89ad-f31e5fe9f4e740b", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "fd5a0793-c71a-43c2-91a2-1011a4bdb5c640b", "type" -> "input", 
    "data" -> ".js\ncore.PlaceholderClock = (args, env) => {\n\t//store the \
handler object in the local memory\n\tenv.local.start = new \
Date();\n\tenv.local.clock = setInterval(()=>{\n\t\tconst d = (new Date() - \
env.local.start);\n\t\tenv.element.innerHTML = d;\n\t}, 10);\n}\n//when our \
instance is about to be destoryed - clear \
timer\ncore.PlaceholderClock.destroy = (args, env) => \
{\n\twindow.clearInterval(env.local.clock);\n\tconst passed = (new Date() - \
env.local.start);\n\talert(passed+' passed');\n}", "display" -> "codemirror", 
    "sign" -> "sleeveless-50a3b", "prev" -> Null, 
    "next" -> "3525d659-e49d-4ecb-89ad-f31e5fe9f4e740b", "parent" -> Null, 
    "child" -> "0c929185-77f1-4fff-806f-e3221f2926ee40b", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn2"|>
