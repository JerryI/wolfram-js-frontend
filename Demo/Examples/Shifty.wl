<|"notebook" -> <|"name" -> "Shifty", "id" -> "amethystine-47351", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"myStringObj" -> <|"json" -> "\"' '\"", 
       "date" -> DateObject[{2023, 4, 3, 12, 39, 
          16.503562`7.970152673857751}, "Instant", "Gregorian", 3.]|>, 
     "a744bfe9-fdb4-4fde-931c-243b10be51c6" -> 
      <|"json" -> 
        "[\"WEBInputField\",\"'4bea49f0-e306-47b0-970e-e2d452e7f9e6'\",\"''\"\
]", "date" -> DateObject[{2023, 4, 3, 12, 38, 50.963674`8.459835704512303}, 
         "Instant", "Gregorian", 3.]|>, 
     "833fc559-260a-4fc9-ac7b-ab56f0633325" -> 
      <|"json" -> 
        "[\"TextForm\",[\"FrontEndExecutableHold\",\"'myStringObj'\"]]", 
       "date" -> DateObject[{2023, 4, 3, 12, 38, 
          50.982536`8.459996410096377}, "Instant", "Gregorian", 3.]|>, 
     "8ad3f816-c989-472f-a892-2d1cb0dd23e5" -> 
      <|"json" -> "[\"WEBInputField\",\"'e07c774b-a139-49f8-a610-4908f54340cb\
'\",\"'type something'\"]", "date" -> DateObject[{2023, 4, 3, 12, 39, 
          19.474462`8.042040452701782}, "Instant", "Gregorian", 3.]|>, 
     "82d57a0f-f9b5-451c-8967-58b457fe90c7" -> 
      <|"json" -> 
        "[\"TextForm\",[\"FrontEndExecutableHold\",\"'myStringObj'\"]]", 
       "date" -> DateObject[{2023, 4, 3, 12, 39, 
          21.961721`8.094241353432293}, "Instant", "Gregorian", 3.]|>|>, 
   "path" -> "/root/wolfram-js-frontend/Demo/Shifty.wl", 
   "cell" -> "99b3ae4b-eff6-47ef-baad-34bb3d22f247", 
   "date" -> DateObject[{2023, 4, 3, 13, 1, 49.569215`8.447787017075276}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "0499ae06-159a-4798-bc90-563bf12434ca", 
    "type" -> "input", "data" -> 
     ".md\nA bunch of handling code to reverse the string", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", 
    "prev" -> "7f7b10f2-e42d-4153-a53a-d854d618e69f", 
    "next" -> "774bb00d-fedd-40ef-81ed-7509f472f75e", "parent" -> Null, 
    "child" -> "b29709b0-b040-4ae2-b227-9d68fe83eacd", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "0c452527-6080-48e9-a92c-5348af6fe36b", "type" -> "output", 
    "data" -> "\n# Data transfer between WL Kernel and JS Frontend\n__Some \
basics of the low-level API__", "display" -> "markdown", 
    "sign" -> "amethystine-47351", "prev" -> Null, "next" -> Null, 
    "parent" -> "99b3ae4b-eff6-47ef-baad-34bb3d22f247", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "14c40103-1104-4c16-adb3-a5c63494db50", "type" -> "output", 
    "data" -> 
     "\nNow lets define the function on WL side to connect those two", 
    "display" -> "markdown", "sign" -> "amethystine-47351", "prev" -> Null, 
    "next" -> Null, "parent" -> "dd47712d-ef31-4b1a-b35c-0d7502a088d7", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "28ad5a5a-0b45-4e79-95a4-d694e3ad091a", "type" -> "input", 
    "data" -> ".js\nconst input = \
document.createElement('input');\ninput.type = 'text';\n\ncore.UpdateMyString \
= (args, env) => {\n  input.value = interpretate(args[0], env);\n}\nreturn \
input", "display" -> "codemirror", "sign" -> "amethystine-47351", 
    "prev" -> "2fc818ac-505f-41f9-a568-831b8d2f5e7a", 
    "next" -> "dd47712d-ef31-4b1a-b35c-0d7502a088d7", "parent" -> Null, 
    "child" -> "97e50e9f-60e1-40b2-b5ab-8e0a849ed629", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "2fc818ac-505f-41f9-a568-831b8d2f5e7a", "type" -> "input", 
    "data" -> ".md\nAnd we need an output cell to display the result", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", 
    "prev" -> "8a88a4be-60b7-499a-9278-181f1825bc7b", 
    "next" -> "28ad5a5a-0b45-4e79-95a4-d694e3ad091a", "parent" -> Null, 
    "child" -> "50b888fa-504e-4a31-b4be-69a361d4d3b3", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "50b888fa-504e-4a31-b4be-69a361d4d3b3", "type" -> "output", 
    "data" -> "\nAnd we need an output cell to display the result", 
    "display" -> "markdown", "sign" -> "amethystine-47351", "prev" -> Null, 
    "next" -> Null, "parent" -> "2fc818ac-505f-41f9-a568-831b8d2f5e7a", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "63fd42d3-b79e-496c-b756-3e49185b98b6", "type" -> "output", 
    "data" -> "\nAnd dynamic output form. For this case, for instance one can \
use `HTMLFrom`", "display" -> "markdown", "sign" -> "amethystine-47351", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "942a885e-372d-4438-b51d-ee12a1e16483", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6c82ed24-3d75-4fdc-abaf-00b8a34fe252", "type" -> "output", 
    "data" -> "\nconst input = document.createElement('input');\ninput.type = \
'text';\ninput.value = 'type something';\n\ninput.addEventListener('input', \
(data)=>{\n  core.FireEvent([\"string-update\", \
'\"'+input.value+'\"']);\n})\nreturn input", "display" -> "js", 
    "sign" -> "amethystine-47351", "prev" -> Null, "next" -> Null, 
    "parent" -> "8a88a4be-60b7-499a-9278-181f1825bc7b", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "774bb00d-fedd-40ef-81ed-7509f472f75e", "type" -> "input", 
    "data" -> "Function[x, FrontEndExecutable[\"myStringObj\"] = x // \
StringReverse] // input;", "display" -> "codemirror", 
    "sign" -> "amethystine-47351", "prev" -> 
     "0499ae06-159a-4798-bc90-563bf12434ca", 
    "next" -> "b0ab7374-2d26-4624-bc6d-c9c0845fc159", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "7f7b10f2-e42d-4153-a53a-d854d618e69f", "type" -> "input", 
    "data" -> "TextForm[FrontEndRef[FrontEndExecutable[\"myStringObj\"]]]", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", 
    "prev" -> "942a885e-372d-4438-b51d-ee12a1e16483", 
    "next" -> "0499ae06-159a-4798-bc90-563bf12434ca", "parent" -> Null, 
    "child" -> "e2268c15-de52-48f4-8252-1c65f25fbfc6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8129038d-fc4d-4047-8529-e0722702ab15", "type" -> "input", 
    "data" -> "ev = \
EventObject[<|\"id\"->\"string-update\"|>];\nFunction[data, \
UpdateMyString[data // StringReverse] // SendToFrontEnd] // ev;", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", 
    "prev" -> "dd47712d-ef31-4b1a-b35c-0d7502a088d7", "next" -> Null, 
    "parent" -> Null, "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "88a8372c-3628-43b3-ad57-2a9db282db80", "type" -> "input", 
    "data" -> "string = CreateFrontEndObject[\" \", \"myStringObj\"]", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", 
    "prev" -> "eba34da2-e6c9-48e7-8c79-a134479625cd", 
    "next" -> "c007b434-bfc5-4e46-b4c5-a536d75ee7dd", "parent" -> Null, 
    "child" -> "946cc0cf-9958-4d77-8214-1beea2156cd5", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8a88a4be-60b7-499a-9278-181f1825bc7b", "type" -> "input", 
    "data" -> ".js\nconst input = \
document.createElement('input');\ninput.type = 'text';\ninput.value = 'type \
something';\n\ninput.addEventListener('input', (data)=>{\n  \
core.FireEvent([\"string-update\", '\"'+input.value+'\"']);\n})\nreturn \
input", "display" -> "codemirror", "sign" -> "amethystine-47351", 
    "prev" -> "b0ab7374-2d26-4624-bc6d-c9c0845fc159", 
    "next" -> "2fc818ac-505f-41f9-a568-831b8d2f5e7a", "parent" -> Null, 
    "child" -> "6c82ed24-3d75-4fdc-abaf-00b8a34fe252", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "942a885e-372d-4438-b51d-ee12a1e16483", "type" -> "input", 
    "data" -> ".md\nAnd dynamic output form. For this case, for instance one \
can use `HTMLFrom`", "display" -> "codemirror", 
    "sign" -> "amethystine-47351", "prev" -> 
     "db6b0947-0dd3-4635-bacd-585fc0c4e4b4", 
    "next" -> "7f7b10f2-e42d-4153-a53a-d854d618e69f", "parent" -> Null, 
    "child" -> "63fd42d3-b79e-496c-b756-3e49185b98b6", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "946cc0cf-9958-4d77-8214-1beea2156cd5", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"myStringObj\"]", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", "prev" -> Null, 
    "next" -> Null, "parent" -> "88a8372c-3628-43b3-ad57-2a9db282db80", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "97e50e9f-60e1-40b2-b5ab-8e0a849ed629", "type" -> "output", 
    "data" -> "\nconst input = document.createElement('input');\ninput.type = \
'text';\n\ncore.UpdateMyString = (args, env) => {\n  input.value = \
interpretate(args[0], env);\n}\nreturn input", "display" -> "js", 
    "sign" -> "amethystine-47351", "prev" -> Null, "next" -> Null, 
    "parent" -> "28ad5a5a-0b45-4e79-95a4-d694e3ad091a", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9908a160-2f06-49d6-8824-979ca449af66", "type" -> "output", 
    "data" -> "\n## Using JS and Wolfram Languages\nThe first one gives us \
more control over the representation, however, it also requires some basic \
knowledge of web-programming.\n\nLet us create a DOM-element in a traditional \
way and bind it to the Wolfram", "display" -> "markdown", 
    "sign" -> "amethystine-47351", "prev" -> Null, "next" -> Null, 
    "parent" -> "b0ab7374-2d26-4624-bc6d-c9c0845fc159", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "99b3ae4b-eff6-47ef-baad-34bb3d22f247", "type" -> "input", 
    "data" -> ".md\n# Data transfer between WL Kernel and JS Frontend\n__Some \
basics of the low-level API__", "display" -> "codemirror", 
    "sign" -> "amethystine-47351", "prev" -> Null, 
    "next" -> "eba34da2-e6c9-48e7-8c79-a134479625cd", "parent" -> Null, 
    "child" -> "0c452527-6080-48e9-a92c-5348af6fe36b", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "a52817bd-19d5-45b1-84bf-996bba7b9654", "type" -> "output", 
    "data" -> "\n## Using Pure Wolfram Language\nFirstly, let us create the \
frontend object, which will be accesable from both sides", 
    "display" -> "markdown", "sign" -> "amethystine-47351", "prev" -> Null, 
    "next" -> Null, "parent" -> "eba34da2-e6c9-48e7-8c79-a134479625cd", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a6105413-0431-447f-84f7-fea3b996fa8f", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"8ad3f816-c989-472f-a892-2d1cb0dd23e5\"]", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", "prev" -> Null, 
    "next" -> Null, "parent" -> "db6b0947-0dd3-4635-bacd-585fc0c4e4b4", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "b0ab7374-2d26-4624-bc6d-c9c0845fc159", "type" -> "input", 
    "data" -> ".md\n## Using JS and Wolfram Languages\nThe first one gives us \
more control over the representation, however, it also requires some basic \
knowledge of web-programming.\n\nLet us create a DOM-element in a traditional \
way and bind it to the Wolfram", "display" -> "codemirror", 
    "sign" -> "amethystine-47351", "prev" -> 
     "774bb00d-fedd-40ef-81ed-7509f472f75e", 
    "next" -> "8a88a4be-60b7-499a-9278-181f1825bc7b", "parent" -> Null, 
    "child" -> "9908a160-2f06-49d6-8824-979ca449af66", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "b29709b0-b040-4ae2-b227-9d68fe83eacd", "type" -> "output", 
    "data" -> "\nA bunch of handling code to reverse the string", 
    "display" -> "markdown", "sign" -> "amethystine-47351", "prev" -> Null, 
    "next" -> Null, "parent" -> "0499ae06-159a-4798-bc90-563bf12434ca", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c007b434-bfc5-4e46-b4c5-a536d75ee7dd", "type" -> "input", 
    "data" -> ".md\nNow we have it, let us show how we can work with it on \
one simple example with reversing the string.\n\nFor that one need to create \
an dynamic input text form", "display" -> "codemirror", 
    "sign" -> "amethystine-47351", "prev" -> 
     "88a8372c-3628-43b3-ad57-2a9db282db80", 
    "next" -> "db6b0947-0dd3-4635-bacd-585fc0c4e4b4", "parent" -> Null, 
    "child" -> "eb3a4b2e-bd09-4936-9a76-2abfc392d8f1", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "db6b0947-0dd3-4635-bacd-585fc0c4e4b4", "type" -> "input", 
    "data" -> "input = InputField[\"type something\"]", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", 
    "prev" -> "c007b434-bfc5-4e46-b4c5-a536d75ee7dd", 
    "next" -> "942a885e-372d-4438-b51d-ee12a1e16483", "parent" -> Null, 
    "child" -> "a6105413-0431-447f-84f7-fea3b996fa8f", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "dd47712d-ef31-4b1a-b35c-0d7502a088d7", "type" -> "input", 
    "data" -> 
     ".md\nNow lets define the function on WL side to connect those two", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", 
    "prev" -> "28ad5a5a-0b45-4e79-95a4-d694e3ad091a", 
    "next" -> "8129038d-fc4d-4047-8529-e0722702ab15", "parent" -> Null, 
    "child" -> "14c40103-1104-4c16-adb3-a5c63494db50", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "e2268c15-de52-48f4-8252-1c65f25fbfc6", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"82d57a0f-f9b5-451c-8967-58b457fe90c7\"]", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", "prev" -> Null, 
    "next" -> Null, "parent" -> "7f7b10f2-e42d-4153-a53a-d854d618e69f", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "eb3a4b2e-bd09-4936-9a76-2abfc392d8f1", "type" -> "output", 
    "data" -> "\nNow we have it, let us show how we can work with it on one \
simple example with reversing the string.\n\nFor that one need to create an \
dynamic input text form", "display" -> "markdown", 
    "sign" -> "amethystine-47351", "prev" -> Null, "next" -> Null, 
    "parent" -> "c007b434-bfc5-4e46-b4c5-a536d75ee7dd", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "eba34da2-e6c9-48e7-8c79-a134479625cd", "type" -> "input", 
    "data" -> ".md\n## Using Pure Wolfram Language\nFirstly, let us create \
the frontend object, which will be accesable from both sides", 
    "display" -> "codemirror", "sign" -> "amethystine-47351", 
    "prev" -> "99b3ae4b-eff6-47ef-baad-34bb3d22f247", 
    "next" -> "88a8372c-3628-43b3-ad57-2a9db282db80", "parent" -> Null, 
    "child" -> "a52817bd-19d5-45b1-84bf-996bba7b9654", 
    "props" -> <|"hidden" -> True|>|>}, "serializer" -> "jsfn2"|>
