<|"notebook" -> <|"name" -> "Incongruousness", "id" -> "binnacle-2d34c", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"20f246d7-f66c-45de-abbb-a19a040d02e0" -> 
      <|"json" -> "[\"PlaceholderClock\"]", "date" -> 
        DateObject[{2023, 4, 9, 19, 41, 35.978533`8.308618430924584}, 
         "Instant", "Gregorian", 3.]|>|>, 
   "path" -> "/root/wolfram-js-frontend/Demo/Clocks-Memory.wl", 
   "cell" -> "fd5a0793-c71a-43c2-91a2-1011a4bdb5c6", 
   "date" -> DateObject[{2023, 4, 9, 19, 41, 56.713166`8.506258866242321}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "0c929185-77f1-4fff-806f-e3221f2926ee", 
    "type" -> "output", "data" -> "\ncore.PlaceholderClock = (args, env) => \
{\n\t//store the handler object in the local memory\n\tenv.local.start = new \
Date();\n\tenv.local.clock = setInterval(()=>{\n\t\tconst d = (new Date() - \
env.local.start);\n\t\tenv.element.innerHTML = d;\n\t}, 10);\n}\n//when our \
instance is about to be destoryed - clear \
timer\ncore.PlaceholderClock.destroy = (args, env) => \
{\n\twindow.clearInterval(env.local.clock);\n\tconst passed = (new Date() - \
env.local.start);\n\talert(passed+' passed');\n}", "display" -> "js", 
    "sign" -> "binnacle-2d34c", "prev" -> Null, "next" -> Null, 
    "parent" -> "fd5a0793-c71a-43c2-91a2-1011a4bdb5c6", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3525d659-e49d-4ecb-89ad-f31e5fe9f4e7", "type" -> "input", 
    "data" -> "CreateFrontEndObject[PlaceholderClock[]]", 
    "display" -> "codemirror", "sign" -> "binnacle-2d34c", 
    "prev" -> "fd5a0793-c71a-43c2-91a2-1011a4bdb5c6", "next" -> Null, 
    "parent" -> Null, "child" -> "f85ede1e-fae4-4661-a16d-a0b70b2e3882", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "f85ede1e-fae4-4661-a16d-a0b70b2e3882", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"20f246d7-f66c-45de-abbb-a19a040d02e0\"]", 
    "display" -> "codemirror", "sign" -> "binnacle-2d34c", "prev" -> Null, 
    "next" -> Null, "parent" -> "3525d659-e49d-4ecb-89ad-f31e5fe9f4e7", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "fd5a0793-c71a-43c2-91a2-1011a4bdb5c6", "type" -> "input", 
    "data" -> ".js\ncore.PlaceholderClock = (args, env) => {\n\t//store the \
handler object in the local memory\n\tenv.local.start = new \
Date();\n\tenv.local.clock = setInterval(()=>{\n\t\tconst d = (new Date() - \
env.local.start);\n\t\tenv.element.innerHTML = d;\n\t}, 10);\n}\n//when our \
instance is about to be destoryed - clear \
timer\ncore.PlaceholderClock.destroy = (args, env) => \
{\n\twindow.clearInterval(env.local.clock);\n\tconst passed = (new Date() - \
env.local.start);\n\talert(passed+' passed');\n}", "display" -> "codemirror", 
    "sign" -> "binnacle-2d34c", "prev" -> Null, 
    "next" -> "3525d659-e49d-4ecb-89ad-f31e5fe9f4e7", "parent" -> Null, 
    "child" -> "0c929185-77f1-4fff-806f-e3221f2926ee", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn2"|>
