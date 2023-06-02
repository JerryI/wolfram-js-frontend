<|"notebook" -> <|"name" -> "Untitled", "id" -> "kola-64954", 
   "kernel" -> LocalKernel, "objects" -> <||>, "path" -> "/Volumes/Data/Githu\
b/wolfram-js-frontend/Demo/Examples/Frontend functions/GOL-Simple.wl", 
   "cell" -> "bfbcf204-3c6e-43bf-a089-cb87d516e79c40ddf1cf8", 
   "date" -> DateObject[{2023, 4, 19, 20, 43, 10.922824`7.790909922334074}, 
     "Instant", "Gregorian", 2.]|>, 
 "cells" -> {<|"id" -> "54b1b57e-0009-41c0-afc8-ef355973d6a6df1cf8", 
    "type" -> "input", "data" -> "gameOfLife = {224, {2, {{2, 2, 2}, {2, 1, \
2}, {2, 2, 2}}}, {1, 1}};\nboard = RandomInteger[1, {40, 40}];\nDo[\n  \
MyFunction[board = CellularAutomaton[gameOfLife, board, {{0, 1}}] // Last] // \
SendToFrontEnd;\n  Pause[0.1];\n, {i,1,100}]", "display" -> "codemirror", 
    "sign" -> "kola-64954", "prev" -> 
     "cedcbe99-4dbf-45a3-8213-53adcee6d0a8df1cf8", "next" -> Null, 
    "parent" -> Null, "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6a0c0542-e89c-44e1-983d-869f19159d45cf8", "type" -> "output", 
    "data" -> "\n# GOL: Example with a simple call\nUsing frontend function", 
    "display" -> "markdown", "sign" -> "kola-64954", "prev" -> Null, 
    "next" -> Null, "parent" -> 
     "bfbcf204-3c6e-43bf-a089-cb87d516e79c40ddf1cf8", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "bc146593-4d0c-4e76-b9f3-dd4a4b98c817df1cf8", 
    "type" -> "output", "data" -> "\nWolfram Mathematica code", 
    "display" -> "markdown", "sign" -> "kola-64954", "prev" -> Null, 
    "next" -> Null, "parent" -> "cedcbe99-4dbf-45a3-8213-53adcee6d0a8df1cf8", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "bfbcf204-3c6e-43bf-a089-cb87d516e79c40ddf1cf8", 
    "type" -> "input", "data" -> 
     ".md\n# GOL: Example with a simple call\nUsing frontend function", 
    "display" -> "codemirror", "sign" -> "kola-64954", "prev" -> Null, 
    "next" -> "d8be1128-077a-4eb1-9871-95ca0f0a9579df1cf8", "parent" -> Null, 
    "child" -> "6a0c0542-e89c-44e1-983d-869f19159d45cf8", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "cedcbe99-4dbf-45a3-8213-53adcee6d0a8df1cf8", "type" -> "input", 
    "data" -> ".md\nWolfram Mathematica code", "display" -> "codemirror", 
    "sign" -> "kola-64954", "prev" -> 
     "d8be1128-077a-4eb1-9871-95ca0f0a9579df1cf8", 
    "next" -> "54b1b57e-0009-41c0-afc8-ef355973d6a6df1cf8", "parent" -> Null, 
    "child" -> "bc146593-4d0c-4e76-b9f3-dd4a4b98c817df1cf8", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "d8be1128-077a-4eb1-9871-95ca0f0a9579df1cf8", "type" -> "input", 
    "data" -> ".js\n//create js canvas\nconst canvas = \
document.createElement(\"canvas\");\ncanvas.width = 400;\ncanvas.height = \
400;\n\nlet context = canvas.getContext(\"2d\");\ncontext.fillStyle = \
\"lightgray\";\ncontext.fillRect(0, 0, 500, 500);\n\n//an array to store the \
previous state\nlet old = new Array(40);\nfor (let i = 0; i < old.length; \
i++) {\n  old[i] = new Array(40).fill(0); \n}\n\n//a function to draw on \
it\ncore.MyFunction = (args, env) => {\n  const data = interpretate(args[0], \
env);\n\n  //draw our boxes\n  for(let i=0; i<40; ++i) {\n    for (let j=0; \
j<40; ++j) {\n      //old pixels will leave blue traces\n      if (old[i][j] \
> 0) {\n        context.fillStyle = \"rgba(0,0,255,0.2)\"; \n        \
context.fillRect(i*10 + 2, j*10 + 2, 6, 6);\n      }\n      //new pixels\n    \
  if (data[i][j] > 0) {\n        context.fillStyle = \"rgba(255,0,0,0.4)\"; \
\n        context.fillRect(i*10 + 1, j*10 + 1, 8, 8);\n      } else {\n       \
 context.fillStyle = \"rgba(255,255,255,0.4)\"; \n        \
context.fillRect(i*10 + 1, j*10 + 1, 8, 8);\n      }\n      \n      //store \
the previous frame\n      old[i][j] = data[i][j];\n    }\n  }\n}\n\nreturn \
canvas", "display" -> "codemirror", "sign" -> "kola-64954", 
    "prev" -> "bfbcf204-3c6e-43bf-a089-cb87d516e79c40ddf1cf8", 
    "next" -> "cedcbe99-4dbf-45a3-8213-53adcee6d0a8df1cf8", "parent" -> Null, 
    "child" -> "fd2889f2-8e99-46a5-9714-3c6b07b8f4d4df1cf8", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "fd2889f2-8e99-46a5-9714-3c6b07b8f4d4df1cf8", 
    "type" -> "output", "data" -> "\nconst canvas = \
document.createElement(\"canvas\");\ncanvas.width = 400;\ncanvas.height = \
400;\n\nlet context = canvas.getContext(\"2d\");\ncontext.fillStyle = \
\"lightgray\";\ncontext.fillRect(0, 0, 500, 500);\n\nlet old = new \
Array(40);\nfor (let i = 0; i < old.length; i++) {\n  old[i] = new \
Array(40).fill(0); \n}\n\ncore.MyFunction = (args, env) => {\n  const data = \
interpretate(args[0], env);\n  for(let i=0; i<40; ++i) {\n    for (let j=0; \
j<40; ++j) {\n      if (old[i][j] > 0) {\n        context.fillStyle = \
\"rgba(0,0,255,0.2)\"; \n        context.fillRect(i*10 + 2, j*10 + 2, 6, \
6);\n      }\n      \n      if (data[i][j] > 0) {\n        context.fillStyle \
= \"rgba(255,0,0,0.4)\"; \n        context.fillRect(i*10 + 1, j*10 + 1, 8, \
8);\n      } else {\n        context.fillStyle = \"rgba(255,255,255,0.4)\"; \
\n        context.fillRect(i*10 + 1, j*10 + 1, 8, 8);\n      }\n\n      \
old[i][j] = data[i][j];\n\n      \n    }\n  }\n}\n\nreturn canvas", 
    "display" -> "js", "sign" -> "kola-64954", "prev" -> Null, 
    "next" -> Null, "parent" -> "d8be1128-077a-4eb1-9871-95ca0f0a9579df1cf8", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>}, 
 "serializer" -> "jsfn2"|>
