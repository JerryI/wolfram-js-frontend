<|"notebook" -> <|"name" -> "Deductible", "id" -> "brat-3cdc9", 
   "kernel" -> LocalKernel, "objects" :> Association[], 
   "path" -> "/Volumes/Data/Github/wolfram-js-frontend/Demo/Experimental/Canv\
asStepByStep.wl", "cell" :> Exit[], 
   "date" -> DateObject[{2023, 6, 16, 16, 39, 38.988223`8.34350842021874}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "e30400c1-b720-4bb2-9fc2-77baf9d4744b", 
    "type" -> "input", "data" -> 
     ".md\nFirstly one need to create an empty canvas", 
    "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "4b419354-d55e-4b4f-9974-5d5f92584b97", "type" -> "output", 
    "data" -> "\nFirstly one need to create an empty canvas", 
    "display" -> "markdown", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "e5f6c673-26d8-4427-98b3-94b6ee5714dc", "type" -> "input", 
    "data" -> ".js\nconst canvas = \
document.createElement('canvas');\ncanvas.width = 300;\ncanvas.height = \
300;\n//an id to find our canvas later\ncanvas.id = 'our-canvas';\n\nreturn \
canvas;", "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9c7daa50-2c49-472a-b670-8f3062ec797b", "type" -> "output", 
    "data" -> "\nconst canvas = \
document.createElement('canvas');\ncanvas.width = 300;\ncanvas.height = \
300;\ncanvas.id = 'our-canvas';\n\nreturn canvas;", "display" -> "js", 
    "sign" -> "brat-3cdc9", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "7942eb00-3e50-4a6e-9539-ffdcdd217d22", "type" -> "input", 
    "data" -> ".md\nNow we can try to draw something on it", 
    "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "896f2cfd-00c6-479f-8823-007e02856e29", "type" -> "output", 
    "data" -> "\nNow we can try to draw something on it", 
    "display" -> "markdown", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "db016ad4-2fa5-48b1-a7b6-b809c50d2139", "type" -> "input", 
    "data" -> ".js\n//get our canvas from the previous cell\nconst canvas = \
document.getElementById('our-canvas'); \nlet context = \
canvas.getContext(\"2d\");\n\ncontext.fillStyle = \
\"lightgray\";\ncontext.fillRect(0, 0, 300, 300);", 
    "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3aeae873-7cd7-47fb-8d68-977926768cb0", "type" -> "output", 
    "data" -> "\n\nconst canvas = document.getElementById('our-canvas');\nlet \
context = canvas.getContext(\"2d\");\ncontext.fillStyle = \
\"lightgray\";\ncontext.fillRect(0, 0, 500, 500);", "display" -> "js", 
    "sign" -> "brat-3cdc9", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "530ecfb5-2334-44dc-9ae3-287e3743fb14", "type" -> "input", 
    "data" -> ".md\nHowever, it can be automated using Wolfram Language", 
    "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "ead38f61-dfb9-4d0d-a90e-3d2fd48f7b8b", "type" -> "output", 
    "data" -> "\nHowever, it can be automated using Wolfram Language", 
    "display" -> "markdown", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "42df8945-91fa-47bb-a11f-070c6f45cf09", "type" -> "input", 
    "data" -> ".js\nconst canvas = document.createElement('canvas');\nlet \
context = canvas.getContext(\"2d\");\ncanvas.width = 300;\ncanvas.height = \
300;\n\n//some helper function\nfunction getRandomInt(max) {\n  return \
Math.floor(Math.random() * max);\n}\n\ncore.CanvasDraw = async (args, env) => \
{\n  const position = await interpretate(args[0], env);\n\n  //draw a \
rectangles with random color\n  context.fillStyle = \
`rgba(${getRandomInt(255)}, ${getRandomInt(255)}, ${getRandomInt(255)}, \
0.3)`;\n  context.fillRect(position[0]-6, position[1]-6, \
12,12);\n}\n\ncore.ClearCanvas = () => {\n  context.fillStyle = \"white\";\n  \
context.fillRect(0, 0, 300, 300);\n}\n\nreturn canvas;", 
    "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "0208d014-3fea-4bc9-b690-7fa6a28cfb5f", "type" -> "output", 
    "data" -> "\nconst canvas = document.createElement('canvas');\nlet \
context = canvas.getContext(\"2d\");\ncanvas.width = 300;\ncanvas.height = \
300;\n\nfunction getRandomInt(max) {\n  return Math.floor(Math.random() * \
max);\n}\n\ncore.CanvasDraw = async (args, env) => {\n  const position = \
await interpretate(args[0], env);\n  context.fillStyle = \
`rgba(${getRandomInt(255)}, ${getRandomInt(255)}, ${getRandomInt(255)}, \
0.3)`;\n  context.fillRect(position[0]-6, position[1]-6, \
12,12);\n}\n\ncore.ClearCanvas = () => {\n  context.fillStyle = \"white\";\n  \
context.fillRect(0, 0, 300, 300);\n}\n\nreturn canvas;", "display" -> "js", 
    "sign" -> "brat-3cdc9", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8a164671-697b-4519-88f5-845ac945c194", "type" -> "input", 
    "data" -> ".md\nCall our defined function from WL", 
    "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "c3b595c0-dff2-4878-a117-e43030a12223", "type" -> "output", 
    "data" -> "\nCall our defined function from WL", "display" -> "markdown", 
    "sign" -> "brat-3cdc9", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6ffd468f-a936-4d29-9a05-f66fdaa84d76", "type" -> "input", 
    "data" -> "ClearCanvas // FrontSubmit\nDo[CanvasDraw[RandomReal[{0,300}, \
2]] // FrontSubmit, {i, 1,100}];", "display" -> "codemirror", 
    "sign" -> "brat-3cdc9", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "7e33b167-3abb-4e74-bcc5-e6275cd99c10", "type" -> "input", 
    "data" -> " ", "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "30e034da-933c-4894-8fb9-1db2b0516bd4", "type" -> "input", 
    "data" -> ".md\n## Ploting an array of data\nLet's extend our nice \
function to do more", "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "33374e20-364d-4c84-9dad-53fed964c53a", "type" -> "output", 
    "data" -> "\n## Ploting an array of data\nLet's extend our nice function \
to do more", "display" -> "markdown", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "24055580-2856-4466-968b-e5cc417ae749", "type" -> "input", 
    "data" -> ".js\nconst canvas = document.createElement('canvas');\nlet \
context = canvas.getContext(\"2d\");\ncanvas.width = 300;\ncanvas.height = \
300;\n\nlet uid;\n\nfunction getRandomInt(max) {\n  return \
Math.floor(Math.random() * max);\n}\n\n//store the data in JS\nlet innerData \
= [];\n\ncore.ArrayDraw = async (args, env) => {\n  const array = await \
interpretate(args[0], env);\n  const width = array.length ;\n  const height = \
array[0].length ;\n  \n  array.forEach((row, i) => {\n    row.forEach((cell, \
j) => {\n      if (cell < 1) return;\n\n      //add new data to the local \
store\n      innerData.push({\n        coordinates: [Math.floor(i * \
(300/width))-1, Math.floor(j * (300/height))-1, Math.floor((300/width)-1), \
Math.floor((300/height)-1)],\n        lifetime: 1,\n      });\n\n      \
//limit the number of points\n      if (innerData.length > 30*30) \
innerData.shift();\n    });\n  });\n}\n\n//animation function\nfunction \
animate() {\n  context.fillStyle = \"white\";\n  context.fillRect(0, 0, 300, \
300);\n\n  //draw all data from the store and fade it based on the lifetime\n \
 for (let i=0; i<innerData.length; ++i) {\n    context.fillStyle = \
`rgba(${255/innerData[i].lifetime},0,${255 - 255/innerData[i].lifetime}, \
${1/innerData[i].lifetime}`;\n    \
context.fillRect(...innerData[i].coordinates);\n    //a rectangle gets \
older\n    innerData[i].lifetime = innerData[i].lifetime + 0.2;\n  }\n\n  \
//sync to the browser's frame rate\n  uid = \
requestAnimationFrame(animate);\n}\n\n//clean up the handler\nthis.ondestroy \
= () => \
cancelAnimationFrame(uid);\n\n//kickstarter\nrequestAnimationFrame(animate);\
\n\nreturn canvas;", "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c52744b2-c03b-4648-9601-0a26508e89c2", "type" -> "output", 
    "data" -> "\nconst canvas = document.createElement('canvas');\nlet \
context = canvas.getContext(\"2d\");\ncanvas.width = 300;\ncanvas.height = \
300;\n\nlet uid;\n\nfunction getRandomInt(max) {\n  return \
Math.floor(Math.random() * max);\n}\n\n//store the data in JS\nlet innerData \
= [];\n\ncore.ArrayDraw = async (args, env) => {\n  const array = await \
interpretate(args[0], env);\n  const width = array.length ;\n  const height = \
array[0].length ;\n  \n  array.forEach((row, i) => {\n    row.forEach((cell, \
j) => {\n      if (cell < 1) return;\n      \n      innerData.push({\n        \
coordinates: [Math.floor(i * (300/width))-1, Math.floor(j * (300/height))-1, \
Math.floor((300/width)-1), Math.floor((300/height)-1)],\n        lifetime: \
1,\n      });\n\n      if (innerData.length > 30*30) innerData.shift();\n    \
});\n  });\n}\n\nfunction animate() {\n  context.fillStyle = \"white\";\n  \
context.fillRect(0, 0, 300, 300);\n  \n  for (let i=0; i<innerData.length; \
++i) {\n    context.fillStyle = `rgba(${255/innerData[i].lifetime},0,${255 - \
255/innerData[i].lifetime}, ${1/innerData[i].lifetime}`;\n    \
context.fillRect(...innerData[i].coordinates);\n    innerData[i].lifetime = \
innerData[i].lifetime + 0.2;\n  }\n\n  uid = \
requestAnimationFrame(animate);\n}\n\nthis.ondestroy = () => \
cancelAnimationFrame(uid);\nrequestAnimationFrame(animate);\n\nreturn \
canvas;", "display" -> "js", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "39fbbf77-5dc7-49e1-add6-6cd99c29b579", "type" -> "input", 
    "data" -> ".md\nNow there is no need in animating manually, JS takes it. \
We can provide any data as an array.\n\nGame of Life might be an interesing \
example to try", "display" -> "codemirror", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "3ab6dcbf-ea9c-4ced-87bc-d96b7cf41456", "type" -> "output", 
    "data" -> "\nNow there is no need in animating manually, JS takes it. We \
can provide any data as an array.\n\nGame of Life might be an interesing \
example to try", "display" -> "markdown", "sign" -> "brat-3cdc9", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3ec53440-e051-4c41-9318-1648ee4ff532", "type" -> "input", 
    "data" -> "gameOfLife = {224, {2, {{2, 2, 2}, {2, 1, 2}, {2, 2, 2}}}, {1, \
1}};\nboard = RandomInteger[1, {20, 20}];\nDo[\n  ArrayDraw[board = \
Last[CellularAutomaton[gameOfLife, board, {{0, 1}}]]] // FrontSubmit; \n  \
Pause[0.1]\n, {i, 1, 100}];", "display" -> "codemirror", 
    "sign" -> "brat-3cdc9", "props" -> <|"hidden" -> False|>|>}, 
 "serializer" -> "jsfn3"|>
