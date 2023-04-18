<|"notebook" -> <|"name" -> "Untitled", "id" -> "nonconducting-4ab5f", 
   "kernel" -> LocalKernel, "objects" -> <||>, 
   "path" -> 
    "/root/wolfram-js-frontend/Demo/Examples/Frontend \
functions/GOL-Simple.wl", "cell" -> 
    "bfbcf204-3c6e-43bf-a089-cb87d516e79c40ddf1", 
   "date" -> DateObject[{2023, 4, 10, 16, 18, 48.920196`8.442063164447346}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "54b1b57e-0009-41c0-afc8-ef355973d6a6df1", 
    "type" -> "input", "data" -> "gameOfLife = {224, {2, {{2, 2, 2}, {2, 1, \
2}, {2, 2, 2}}}, {1, 1}};\nboard = RandomInteger[1, {40, 40}];\nDo[\n  \
MyFunction[board = CellularAutomaton[gameOfLife, board, {{0, 1}}] // Last] // \
SendToFrontEnd;\n  Pause[0.1];\n, {i,1,100}]", "display" -> "codemirror", 
    "sign" -> "nonconducting-4ab5f", 
    "prev" -> "cedcbe99-4dbf-45a3-8213-53adcee6d0a8df1", "next" -> Null, 
    "parent" -> Null, "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6a0c0542-e89c-44e1-983d-869f19159d45", "type" -> "output", 
    "data" -> "\n# GOL: Example with a simple call\nUsing frontend function", 
    "display" -> "markdown", "sign" -> "nonconducting-4ab5f", "prev" -> Null, 
    "next" -> Null, "parent" -> "bfbcf204-3c6e-43bf-a089-cb87d516e79c40ddf1", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "bc146593-4d0c-4e76-b9f3-dd4a4b98c817df1", "type" -> "output", 
    "data" -> "\nWolfram Mathematica code", "display" -> "markdown", 
    "sign" -> "nonconducting-4ab5f", "prev" -> Null, "next" -> Null, 
    "parent" -> "cedcbe99-4dbf-45a3-8213-53adcee6d0a8df1", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "bfbcf204-3c6e-43bf-a089-cb87d516e79c40ddf1", "type" -> "input", 
    "data" -> 
     ".md\n# GOL: Example with a simple call\nUsing frontend function", 
    "display" -> "codemirror", "sign" -> "nonconducting-4ab5f", 
    "prev" -> Null, "next" -> "d8be1128-077a-4eb1-9871-95ca0f0a9579df1", 
    "parent" -> Null, "child" -> "6a0c0542-e89c-44e1-983d-869f19159d45", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "cedcbe99-4dbf-45a3-8213-53adcee6d0a8df1", "type" -> "input", 
    "data" -> ".md\nWolfram Mathematica code", "display" -> "codemirror", 
    "sign" -> "nonconducting-4ab5f", 
    "prev" -> "d8be1128-077a-4eb1-9871-95ca0f0a9579df1", 
    "next" -> "54b1b57e-0009-41c0-afc8-ef355973d6a6df1", "parent" -> Null, 
    "child" -> "bc146593-4d0c-4e76-b9f3-dd4a4b98c817df1", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "d8be1128-077a-4eb1-9871-95ca0f0a9579df1", "type" -> "input", 
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
canvas", "display" -> "codemirror", "sign" -> "nonconducting-4ab5f", 
    "prev" -> "bfbcf204-3c6e-43bf-a089-cb87d516e79c40ddf1", 
    "next" -> "cedcbe99-4dbf-45a3-8213-53adcee6d0a8df1", "parent" -> Null, 
    "child" -> "fd2889f2-8e99-46a5-9714-3c6b07b8f4d4df1", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "fd2889f2-8e99-46a5-9714-3c6b07b8f4d4df1", "type" -> "output", 
    "data" -> "\nconst canvas = \
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
    "display" -> "js", "sign" -> "nonconducting-4ab5f", "prev" -> Null, 
    "next" -> Null, "parent" -> "d8be1128-077a-4eb1-9871-95ca0f0a9579df1", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>}, 
 "serializer" -> "jsfn2"|>
