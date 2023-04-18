<|"notebook" -> <|"name" -> "Shifty", "id" -> "insignia-3756c", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"myStringObj" -> <|"json" -> "\"' '\"", 
       "date" -> DateObject[{2023, 4, 11, 21, 14, 
          17.394391`7.992984212664568}, "Instant", "Gregorian", 3.]|>, 
     "8ad3f816-c989-472f-a892-2d1cb0dd23e5" -> 
      <|"json" -> "[\"WEBInputField\",\"'e07c774b-a139-49f8-a610-4908f54340cb\
'\",\"'type something'\"]", "date" -> DateObject[{2023, 4, 11, 21, 13, 
          37.748502`8.329474700965955}, "Instant", "Gregorian", 3.]|>, 
     "82d57a0f-f9b5-451c-8967-58b457fe90c7" -> 
      <|"json" -> 
        "[\"TextForm\",[\"FrontEndExecutableHold\",\"'myStringObj'\"]]", 
       "date" -> DateObject[{2023, 4, 11, 21, 13, 
          37.788232`8.329931552101646}, "Instant", "Gregorian", 3.]|>, 
     "7d6238cd-a871-45cc-8f19-9aff03bafc13" -> 
      <|"json" -> "[\"WEBInputField\",\"'9a026e2a-388f-4aca-a47f-ad6017c2c6e2\
'\",\"'type something'\"]", "date" -> DateObject[{2023, 4, 11, 21, 14, 
          7.241762`7.612419234908535}, "Instant", "Gregorian", 3.]|>, 
     "a5b79d54-7b2f-4021-b66c-65be670dcfb3" -> 
      <|"json" -> 
        "[\"TextForm\",[\"FrontEndExecutableHold\",\"'myStringObj'\"]]", 
       "date" -> DateObject[{2023, 4, 11, 21, 14, 
          12.225502`7.839841686922151}, "Instant", "Gregorian", 3.]|>, 
     "dc81f7b5-39fb-4ef7-a6db-39e2fe6e41bc" -> 
      <|"json" -> 
        "[\"TextForm\",[\"FrontEndExecutableHold\",\"'myStringObj'\"]]", 
       "date" -> DateObject[{2023, 4, 11, 21, 14, 
          19.895322`8.051325956446812}, "Instant", "Gregorian", 3.]|>, 
     "7c83ead0-8ca7-44f8-8d21-38c02f65347b" -> 
      <|"json" -> 
        "[\"TextForm\",[\"FrontEndExecutableHold\",\"'myStringObj'\"]]", 
       "date" -> DateObject[{2023, 4, 11, 21, 14, 
          55.552521`8.497278746374148}, "Instant", "Gregorian", 3.]|>|>, 
   "path" -> "/root/wolfram-js-frontend/Demo/Examples/Shifty.wl", 
   "cell" -> "99b3ae4b-eff6-47ef-baad-34bb3d22f2477cc", 
   "date" -> DateObject[{2023, 4, 11, 23, 18, 50.383907`8.454866817182825}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "0499ae06-159a-4798-bc90-563bf12434ca7cc", 
    "type" -> "input", "data" -> 
     ".md\nA bunch of handling code to reverse the string", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "7f7b10f2-e42d-4153-a53a-d854d618e69f7cc", 
    "next" -> "774bb00d-fedd-40ef-81ed-7509f472f75e7cc", "parent" -> Null, 
    "child" -> "b29709b0-b040-4ae2-b227-9d68fe83eacd7cc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "04c1ad0d-70a6-4df9-b6f4-b26e1842faf0", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"7d6238cd-a871-45cc-8f19-9aff03bafc13\"]", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", "prev" -> Null, 
    "next" -> Null, "parent" -> "db6b0947-0dd3-4635-bacd-585fc0c4e4b47cc", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "0c452527-6080-48e9-a92c-5348af6fe36b7cc", "type" -> "output", 
    "data" -> "\n# Data transfer between WL Kernel and JS Frontend\n__Some \
basics of the low-level API__", "display" -> "markdown", 
    "sign" -> "insignia-3756c", "prev" -> Null, "next" -> Null, 
    "parent" -> "99b3ae4b-eff6-47ef-baad-34bb3d22f2477cc", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "14c40103-1104-4c16-adb3-a5c63494db507cc", "type" -> "output", 
    "data" -> 
     "\nNow lets define the function on WL side to connect those two", 
    "display" -> "markdown", "sign" -> "insignia-3756c", "prev" -> Null, 
    "next" -> Null, "parent" -> "dd47712d-ef31-4b1a-b35c-0d7502a088d77cc", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "28ad5a5a-0b45-4e79-95a4-d694e3ad091a7cc", "type" -> "input", 
    "data" -> ".js\nconst input = \
document.createElement('input');\ninput.type = 'text';\n\ncore.UpdateMyString \
= (args, env) => {\n  input.value = interpretate(args[0], env);\n}\nreturn \
input", "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "2fc818ac-505f-41f9-a568-831b8d2f5e7a7cc", 
    "next" -> "dd47712d-ef31-4b1a-b35c-0d7502a088d77cc", "parent" -> Null, 
    "child" -> "97e50e9f-60e1-40b2-b5ab-8e0a849ed6297cc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "2fc818ac-505f-41f9-a568-831b8d2f5e7a7cc", "type" -> "input", 
    "data" -> ".md\nAnd we need an output cell to display the result", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "8a88a4be-60b7-499a-9278-181f1825bc7b7cc", 
    "next" -> "28ad5a5a-0b45-4e79-95a4-d694e3ad091a7cc", "parent" -> Null, 
    "child" -> "50b888fa-504e-4a31-b4be-69a361d4d3b37cc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "50b888fa-504e-4a31-b4be-69a361d4d3b37cc", "type" -> "output", 
    "data" -> "\nAnd we need an output cell to display the result", 
    "display" -> "markdown", "sign" -> "insignia-3756c", "prev" -> Null, 
    "next" -> Null, "parent" -> "2fc818ac-505f-41f9-a568-831b8d2f5e7a7cc", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "63fd42d3-b79e-496c-b756-3e49185b98b67cc", "type" -> "output", 
    "data" -> "\nAnd dynamic output form. For this case, for instance one can \
use `HTMLFrom`", "display" -> "markdown", "sign" -> "insignia-3756c", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "942a885e-372d-4438-b51d-ee12a1e164837cc", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6c82ed24-3d75-4fdc-abaf-00b8a34fe2527cc", "type" -> "output", 
    "data" -> "\nconst input = document.createElement('input');\ninput.type = \
'text';\ninput.value = 'type something';\n\ninput.addEventListener('input', \
(data)=>{\n  core.FireEvent([\"string-update\", \
'\"'+input.value+'\"']);\n})\nreturn input", "display" -> "js", 
    "sign" -> "insignia-3756c", "prev" -> Null, "next" -> Null, 
    "parent" -> "8a88a4be-60b7-499a-9278-181f1825bc7b7cc", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "774bb00d-fedd-40ef-81ed-7509f472f75e7cc", "type" -> "input", 
    "data" -> "Function[x, FrontEndExecutable[\"myStringObj\"] = x // \
StringReverse] // input;", "display" -> "codemirror", 
    "sign" -> "insignia-3756c", "prev" -> 
     "0499ae06-159a-4798-bc90-563bf12434ca7cc", 
    "next" -> "b0ab7374-2d26-4624-bc6d-c9c0845fc1597cc", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "7f7b10f2-e42d-4153-a53a-d854d618e69f7cc", "type" -> "input", 
    "data" -> "TextForm[FrontEndRef[FrontEndExecutable[\"myStringObj\"]]]", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "942a885e-372d-4438-b51d-ee12a1e164837cc", 
    "next" -> "0499ae06-159a-4798-bc90-563bf12434ca7cc", "parent" -> Null, 
    "child" -> "90b3ace7-cb60-469a-8b12-63491b929f12", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8129038d-fc4d-4047-8529-e0722702ab157cc", "type" -> "input", 
    "data" -> "ev = \
EventObject[<|\"id\"->\"string-update\"|>];\nFunction[data, \
UpdateMyString[data // StringReverse] // SendToFrontEnd] // ev;", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "dd47712d-ef31-4b1a-b35c-0d7502a088d77cc", "next" -> Null, 
    "parent" -> Null, "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "88a8372c-3628-43b3-ad57-2a9db282db807cc", "type" -> "input", 
    "data" -> "string = CreateFrontEndObject[\" \", \"myStringObj\"]", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "eba34da2-e6c9-48e7-8c79-a134479625cd7cc", 
    "next" -> "c007b434-bfc5-4e46-b4c5-a536d75ee7dd7cc", "parent" -> Null, 
    "child" -> "a0d6d001-9d8c-4380-9722-8c59e5d46a24", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8a88a4be-60b7-499a-9278-181f1825bc7b7cc", "type" -> "input", 
    "data" -> ".js\nconst input = \
document.createElement('input');\ninput.type = 'text';\ninput.value = 'type \
something';\n\ninput.addEventListener('input', (data)=>{\n  \
core.FireEvent([\"string-update\", '\"'+input.value+'\"']);\n})\nreturn \
input", "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "b0ab7374-2d26-4624-bc6d-c9c0845fc1597cc", 
    "next" -> "2fc818ac-505f-41f9-a568-831b8d2f5e7a7cc", "parent" -> Null, 
    "child" -> "6c82ed24-3d75-4fdc-abaf-00b8a34fe2527cc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "90b3ace7-cb60-469a-8b12-63491b929f12", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"7c83ead0-8ca7-44f8-8d21-38c02f65347b\"]", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", "prev" -> Null, 
    "next" -> Null, "parent" -> "7f7b10f2-e42d-4153-a53a-d854d618e69f7cc", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "942a885e-372d-4438-b51d-ee12a1e164837cc", "type" -> "input", 
    "data" -> ".md\nAnd dynamic output form. For this case, for instance one \
can use `HTMLFrom`", "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "db6b0947-0dd3-4635-bacd-585fc0c4e4b47cc", 
    "next" -> "7f7b10f2-e42d-4153-a53a-d854d618e69f7cc", "parent" -> Null, 
    "child" -> "63fd42d3-b79e-496c-b756-3e49185b98b67cc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "97e50e9f-60e1-40b2-b5ab-8e0a849ed6297cc", "type" -> "output", 
    "data" -> "\nconst input = document.createElement('input');\ninput.type = \
'text';\n\ncore.UpdateMyString = (args, env) => {\n  input.value = \
interpretate(args[0], env);\n}\nreturn input", "display" -> "js", 
    "sign" -> "insignia-3756c", "prev" -> Null, "next" -> Null, 
    "parent" -> "28ad5a5a-0b45-4e79-95a4-d694e3ad091a7cc", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9908a160-2f06-49d6-8824-979ca449af667cc", "type" -> "output", 
    "data" -> "\n## Using JS and Wolfram Languages\nThe first one gives us \
more control over the representation, however, it also requires some basic \
knowledge of web-programming.\n\nLet us create a DOM-element in a traditional \
way and bind it to the Wolfram", "display" -> "markdown", 
    "sign" -> "insignia-3756c", "prev" -> Null, "next" -> Null, 
    "parent" -> "b0ab7374-2d26-4624-bc6d-c9c0845fc1597cc", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "99b3ae4b-eff6-47ef-baad-34bb3d22f2477cc", "type" -> "input", 
    "data" -> ".md\n# Data transfer between WL Kernel and JS Frontend\n__Some \
basics of the low-level API__", "display" -> "codemirror", 
    "sign" -> "insignia-3756c", "prev" -> Null, 
    "next" -> "eba34da2-e6c9-48e7-8c79-a134479625cd7cc", "parent" -> Null, 
    "child" -> "0c452527-6080-48e9-a92c-5348af6fe36b7cc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "a0d6d001-9d8c-4380-9722-8c59e5d46a24", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"myStringObj\"]", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", "prev" -> Null, 
    "next" -> Null, "parent" -> "88a8372c-3628-43b3-ad57-2a9db282db807cc", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a52817bd-19d5-45b1-84bf-996bba7b96547cc", "type" -> "output", 
    "data" -> "\n## Using Pure Wolfram Language\nFirstly, let us create the \
frontend object, which will be accesable from both sides", 
    "display" -> "markdown", "sign" -> "insignia-3756c", "prev" -> Null, 
    "next" -> Null, "parent" -> "eba34da2-e6c9-48e7-8c79-a134479625cd7cc", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "b0ab7374-2d26-4624-bc6d-c9c0845fc1597cc", "type" -> "input", 
    "data" -> ".md\n## Using JS and Wolfram Languages\nThe first one gives us \
more control over the representation, however, it also requires some basic \
knowledge of web-programming.\n\nLet us create a DOM-element in a traditional \
way and bind it to the Wolfram", "display" -> "codemirror", 
    "sign" -> "insignia-3756c", "prev" -> 
     "774bb00d-fedd-40ef-81ed-7509f472f75e7cc", 
    "next" -> "8a88a4be-60b7-499a-9278-181f1825bc7b7cc", "parent" -> Null, 
    "child" -> "9908a160-2f06-49d6-8824-979ca449af667cc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "b29709b0-b040-4ae2-b227-9d68fe83eacd7cc", "type" -> "output", 
    "data" -> "\nA bunch of handling code to reverse the string", 
    "display" -> "markdown", "sign" -> "insignia-3756c", "prev" -> Null, 
    "next" -> Null, "parent" -> "0499ae06-159a-4798-bc90-563bf12434ca7cc", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c007b434-bfc5-4e46-b4c5-a536d75ee7dd7cc", "type" -> "input", 
    "data" -> ".md\nNow we have it, let us show how we can work with it on \
one simple example with reversing the string.\n\nFor that one need to create \
an dynamic input text form", "display" -> "codemirror", 
    "sign" -> "insignia-3756c", "prev" -> 
     "88a8372c-3628-43b3-ad57-2a9db282db807cc", 
    "next" -> "db6b0947-0dd3-4635-bacd-585fc0c4e4b47cc", "parent" -> Null, 
    "child" -> "eb3a4b2e-bd09-4936-9a76-2abfc392d8f17cc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "db6b0947-0dd3-4635-bacd-585fc0c4e4b47cc", "type" -> "input", 
    "data" -> "input = InputField[\"type something\"]", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "c007b434-bfc5-4e46-b4c5-a536d75ee7dd7cc", 
    "next" -> "942a885e-372d-4438-b51d-ee12a1e164837cc", "parent" -> Null, 
    "child" -> "04c1ad0d-70a6-4df9-b6f4-b26e1842faf0", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "dd47712d-ef31-4b1a-b35c-0d7502a088d77cc", "type" -> "input", 
    "data" -> 
     ".md\nNow lets define the function on WL side to connect those two", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "28ad5a5a-0b45-4e79-95a4-d694e3ad091a7cc", 
    "next" -> "8129038d-fc4d-4047-8529-e0722702ab157cc", "parent" -> Null, 
    "child" -> "14c40103-1104-4c16-adb3-a5c63494db507cc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "eb3a4b2e-bd09-4936-9a76-2abfc392d8f17cc", "type" -> "output", 
    "data" -> "\nNow we have it, let us show how we can work with it on one \
simple example with reversing the string.\n\nFor that one need to create an \
dynamic input text form", "display" -> "markdown", 
    "sign" -> "insignia-3756c", "prev" -> Null, "next" -> Null, 
    "parent" -> "c007b434-bfc5-4e46-b4c5-a536d75ee7dd7cc", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "eba34da2-e6c9-48e7-8c79-a134479625cd7cc", "type" -> "input", 
    "data" -> ".md\n## Using Pure Wolfram Language\nFirstly, let us create \
the frontend object, which will be accesable from both sides", 
    "display" -> "codemirror", "sign" -> "insignia-3756c", 
    "prev" -> "99b3ae4b-eff6-47ef-baad-34bb3d22f2477cc", 
    "next" -> "88a8372c-3628-43b3-ad57-2a9db282db807cc", "parent" -> Null, 
    "child" -> "a52817bd-19d5-45b1-84bf-996bba7b96547cc", 
    "props" -> <|"hidden" -> True|>|>}, "serializer" -> "jsfn2"|>
