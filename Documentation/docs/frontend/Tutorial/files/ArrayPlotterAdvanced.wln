<|"notebook" -> <|"name" -> "Ashtray", "id" -> "preeminently-12bfc", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"canvas" -> <|"json" -> "[\"ArrayDraw\",[\"List\",[\"List\",1,0,0,0,1,1\
,1,0,0,0,0,1,1,1,0,0,0,0,0,0],[\"List\",1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1\
,1],[\"List\",0,1,0,0,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0],[\"List\",0,0,0,1,0,0,\
0,0,0,1,0,0,0,0,0,0,0,0,1,1],[\"List\",1,1,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,\
1],[\"List\",0,1,1,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,0],[\"List\",1,1,0,1,1,0,0\
,0,0,0,0,1,1,0,0,0,1,0,0,0],[\"List\",0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0\
],[\"List\",0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0],[\"List\",0,0,0,0,0,0,0,\
0,0,1,0,0,0,0,0,1,0,0,0,0],[\"List\",0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]\
,[\"List\",1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,1],[\"List\",1,1,1,0,0,0,1,0\
,0,0,1,1,1,1,0,1,1,1,1,1],[\"List\",0,1,1,0,0,0,1,0,1,1,0,0,0,0,0,0,0,0,0,1],\
[\"List\",1,1,1,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,1,1],[\"List\",0,0,1,0,0,1,0,1,\
0,0,0,0,0,0,0,0,1,1,0,0],[\"List\",1,0,1,0,0,1,0,1,0,0,0,1,0,0,0,0,0,0,0,0],[\
\"List\",0,0,0,0,0,1,0,1,1,0,0,0,0,0,0,0,1,0,0,0],[\"List\",0,1,0,0,0,1,1,0,1\
,0,1,1,1,0,0,0,0,0,0,0],[\"List\",1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1]]]"\
, "date" -> DateObject[{2023, 6, 16, 17, 50, 41.65845`8.372278084948146}, 
         "Instant", "Gregorian", 3.]|>, "canvas-auto" -> 
      <|"json" -> "[\"ArrayDraw\",[\"Hold\",\"board\"]]", 
       "date" -> DateObject[{2023, 6, 16, 17, 51, 0.379889`6.33223170754104}, 
         "Instant", "Gregorian", 3.]|>|>, "path" -> "/Volumes/Data/Github/wol\
fram-js-frontend/Demo/Experimental/ArrayPlotterAdvanced.wl", 
   "cell" :> Exit[], "date" -> DateObject[{2023, 6, 16, 17, 51, 
      48.593108`8.439149653358493}, "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "b3279548-7ebe-4b55-ac8c-71faba194098", 
    "type" -> "input", "data" -> 
     ".md\nFirstly, we need to hide all variables to the scope of a function"\
, "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "81644383-9287-4ece-b1cc-4390023b3e08", "type" -> "output", 
    "data" -> 
     "\nFirstly, we need to hide all variables to the scope of a function", 
    "display" -> "markdown", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "2a05d533-818d-4424-b513-3d392f2b0e12", "type" -> "input", 
    "data" -> ".js\n//global function\nwindow.getRandomInt = (max) => {\n  \
return Math.floor(Math.random() * max);\n}\n\ncore.ArrayDraw = async (args, \
env) => {\n  const canvas = document.createElement('canvas');\n  canvas.width \
= 300;\n  canvas.height = 300;\n  \n  //append our canvas to the provided \
DOM\n  env.element.appendChild(canvas);\n  \n  let context = \
canvas.getContext(\"2d\");\n  \n  //use local memory to store the canvas\n  \
env.local.ctx = context;\n\n  //store the data in JS\n  const innerData = \
[];\n  env.local.innerData = innerData;\n\n  const array = await \
interpretate(args[0], env);\n  \n  const width = array.length ;\n  const \
height = array[0].length;\n  \n  array.forEach((row, i) => {\n    \
row.forEach((cell, j) => {\n      if (cell < 1) return;\n\n      //add new \
data to the local store\n      innerData.push({\n        coordinates: \
[Math.floor(i * (300/width))-1, Math.floor(j * (300/height))-1, \
Math.floor((300/width)-1), Math.floor((300/height)-1)],\n        lifetime: \
1,\n      });\n\n      //limit the number of points\n      if \
(innerData.length > 30*30) innerData.shift();\n    });\n  });\n\n  \
//animation function\n  function animate() {\n    context.fillStyle = \
\"white\";\n    context.fillRect(0, 0, 300, 300);\n\n    //draw all data from \
the store and fade it based on the lifetime\n    for (let i=0; \
i<innerData.length; ++i) {\n      context.fillStyle = \
`rgba(${255/innerData[i].lifetime},0,${255 - 255/innerData[i].lifetime}, \
${1/innerData[i].lifetime}`;\n      \
context.fillRect(...innerData[i].coordinates);\n      //a rectangle gets \
older\n      innerData[i].lifetime = innerData[i].lifetime + 0.2;\n    }\n\n  \
  //sync to the browser's frame rate\n    env.local.uid = \
requestAnimationFrame(animate);\n  }\n\n  requestAnimationFrame(animate);\n}"\
, "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "268cdfba-3ec2-4bd1-a2e7-b75188b4904a", "type" -> "output", 
    "data" -> "\n//global function\nwindow.getRandomInt = (max) => {\n  \
return Math.floor(Math.random() * max);\n}\n\ncore.ArrayDraw = async (args, \
env) => {\n  const canvas = document.createElement('canvas');\n  canvas.width \
= 300;\n  canvas.height = 300;\n  \n  //append our canvas to the provided \
DOM\n  env.element.appendChild(canvas);\n  \n  let context = \
canvas.getContext(\"2d\");\n  \n  //use local memory to store the canvas\n  \
env.local.ctx = context;\n\n  //store the data in JS\n  const innerData = \
[];\n  env.local.innerData = innerData;\n\n  const array = await \
interpretate(args[0], env);\n  \n  const width = array.length ;\n  const \
height = array[0].length;\n  \n  array.forEach((row, i) => {\n    \
row.forEach((cell, j) => {\n      if (cell < 1) return;\n\n      //add new \
data to the local store\n      innerData.push({\n        coordinates: \
[Math.floor(i * (300/width))-1, Math.floor(j * (300/height))-1, \
Math.floor((300/width)-1), Math.floor((300/height)-1)],\n        lifetime: \
1,\n      });\n\n      //limit the number of points\n      if \
(innerData.length > 30*30) innerData.shift();\n    });\n  });\n\n  \
//animation function\n  function animate() {\n    context.fillStyle = \
\"white\";\n    context.fillRect(0, 0, 300, 300);\n\n    //draw all data from \
the store and fade it based on the lifetime\n    for (let i=0; \
i<innerData.length; ++i) {\n      context.fillStyle = \
`rgba(${255/innerData[i].lifetime},0,${255 - 255/innerData[i].lifetime}, \
${1/innerData[i].lifetime}`;\n      \
context.fillRect(...innerData[i].coordinates);\n      //a rectangle gets \
older\n      innerData[i].lifetime = innerData[i].lifetime + 0.2;\n    }\n\n  \
  //sync to the browser's frame rate\n    env.local.uid = \
requestAnimationFrame(animate);\n  }\n\n  requestAnimationFrame(animate);\n}"\
, "display" -> "js", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6264ae28-37c4-4cf7-a8bc-600ed0c09fd8", "type" -> "input", 
    "data" -> ".md\nNow all data is stored inside the `env.local` variable, \
which is unique for each instance.\n\nThen to call it like a proper Wolfram \
Function, we need to wrap it into", "display" -> "codemirror", 
    "sign" -> "preeminently-12bfc", "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "18ab6ccc-d999-46ce-8596-bef2705f48fb", "type" -> "output", 
    "data" -> "\nNow all data is stored inside the `env.local` variable, \
which is unique for each instance.\n\nThen to call it like a proper Wolfram \
Function, we need to wrap it into", "display" -> "markdown", 
    "sign" -> "preeminently-12bfc", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c6b0d645-73d5-4152-b50d-f7aae7612df4", "type" -> "input", 
    "data" -> "gameOfLife = {224, {2, {{2, 2, 2}, {2, 1, 2}, {2, 2, 2}}}, {1, \
1}};\nboard = RandomInteger[1, {20, \
20}];\nCreateFrontEndObject[ArrayDraw[board = \
Last[CellularAutomaton[gameOfLife, board, {{0, 1}}]]], \"canvas\"]", 
    "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6ddfe66e-873a-4fb0-8d74-bcb1c60d7d4e", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"canvas\"]", "display" -> "codemirror", 
    "sign" -> "preeminently-12bfc", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c6c13f45-6405-4aaa-aede-b085fd1781ca", "type" -> "input", 
    "data" -> ".md\nYou __can copy and paste__, since this is a proper \
frontend object.\n\nHowever, there is much more we need to do as well. ", 
    "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "6a833c75-fc8e-451b-8cf4-9c2a301a21a8", "type" -> "output", 
    "data" -> "\nYou __can copy and paste__, since this is a proper frontend \
object.\n\nHowever, there is much more we need to do as well. ", 
    "display" -> "markdown", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "adde46e1-9d29-4e25-bb56-ce874a98ac22", "type" -> "input", 
    "data" -> " ", "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6f060451-6916-43e5-b6ab-bec6c1cf205f", "type" -> "input", 
    "data" -> ".md\n## Cleanning up method\nOnce you delete this widget or \
object (i dunno how to call it), we should take care about animation loop", 
    "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "e45f8937-0bae-4392-8503-ebf36d8ea334", "type" -> "output", 
    "data" -> "\n## Cleanning up method\nOnce you delete this widget or \
object (i dunno how to call it), we should take care about animation loop", 
    "display" -> "markdown", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "4eb22dfb-2272-413b-b9cc-42a6988ac906", "type" -> "input", 
    "data" -> ".js\ncore.ArrayDraw.destroy = async (args, env) => {\n  \
//remove animation loop\n  cancelAnimationFrame(env.local.uid);\n  //make \
shure that all other nested object will do the same\n  interpretate(args[0], \
env);\n}", "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "8cd9717c-4be3-427d-8039-784aeaa3f487", "type" -> "output", 
    "data" -> "\ncore.ArrayDraw.destroy = async (args, env) => {\n  //remove \
animation loop\n  cancelAnimationFrame(env.local.uid);\n  //make shure that \
all other nested object will do the same\n  interpretate(args[0], env);\n}", 
    "display" -> "js", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "817ef267-a5e3-4db8-a677-761f9393f831", "type" -> "input", 
    "data" -> ".md\n## Update method\nThere is no need to reevaluate the cell \
in order to update the canvas, we have a special method for that", 
    "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "bea1e1b0-2148-4736-8489-50a9546bd087", "type" -> "output", 
    "data" -> "\n## Update method\nThere is no need to reevaluate the cell in \
order to update the canvas, we have a special method for that", 
    "display" -> "markdown", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9a9f8c26-d27d-40d2-b6a3-6b42a959b690", "type" -> "input", 
    "data" -> ".js\ncore.ArrayDraw.update = async (args, env) => {\n  \
//restore the context\n  let context = env.local.ctx;\n  const innerData = \
env.local.innerData;\n  //get new data\n  const array = await \
interpretate(args[0], env);\n  \n  const width = array.length ;\n  const \
height = array[0].length;\n  //update\n  array.forEach((row, i) => {\n    \
row.forEach((cell, j) => {\n      if (cell < 1) return;\n\n      //add new \
data to the local store\n      innerData.push({\n        coordinates: \
[Math.floor(i * (300/width))-1, Math.floor(j * (300/height))-1, \
Math.floor((300/width)-1), Math.floor((300/height)-1)],\n        lifetime: \
1,\n      });\n\n      //limit the number of points\n      if \
(innerData.length > 30*30) innerData.shift();\n    });\n  });\n}", 
    "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "61f5d5de-74f3-41ed-9c37-daf55187c427", "type" -> "output", 
    "data" -> "\ncore.ArrayDraw.update = async (args, env) => {\n  //restore \
the context\n  let context = env.local.ctx;\n  const innerData = \
env.local.innerData;\n  //get new data\n  const array = await \
interpretate(args[0], env);\n  \n  const width = array.length ;\n  const \
height = array[0].length;\n  //update\n  array.forEach((row, i) => {\n    \
row.forEach((cell, j) => {\n      if (cell < 1) return;\n\n      //add new \
data to the local store\n      innerData.push({\n        coordinates: \
[Math.floor(i * (300/width))-1, Math.floor(j * (300/height))-1, \
Math.floor((300/width)-1), Math.floor((300/height)-1)],\n        lifetime: \
1,\n      });\n\n      //limit the number of points\n      if \
(innerData.length > 30*30) innerData.shift();\n    });\n  });\n}", 
    "display" -> "js", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "f4b89f7e-edca-4a12-b011-6982bf5c230f", "type" -> "input", 
    "data" -> ".md\nNow we can check the result by rewritting the update \
cycle in WL in a much shorter way", "display" -> "codemirror", 
    "sign" -> "preeminently-12bfc", "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "666ec986-1196-4782-ae5f-691830d4adf9", "type" -> "output", 
    "data" -> "\nNow we can check the result by rewritting the update cycle \
in WL in a much shorter way", "display" -> "markdown", 
    "sign" -> "preeminently-12bfc", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "6adf6c30-2040-4442-bc02-14a2ec0513f7", "type" -> "input", 
    "data" -> "gameOfLife = {224, {2, {{2, 2, 2}, {2, 1, 2}, {2, 2, 2}}}, {1, \
1}};\nboard = RandomInteger[1, {20, \
20}];\nCreateFrontEndObject[ArrayDraw[Hold[board]], \"canvas-auto\"]", 
    "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "4cd2fb99-9cf5-4fe0-8889-867998af8065", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"canvas-auto\"]", 
    "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "955d6278-f856-4b1c-94d0-21ac8f02e9bd", "type" -> "input", 
    "data" -> ".md\nSo it just updates our variable `board` without thinking \
of redrawing the canvas", "display" -> "codemirror", 
    "sign" -> "preeminently-12bfc", "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "6470ee6a-e92f-4321-aa9c-86436e3e930e", "type" -> "output", 
    "data" -> "\nSo it just updates our variable `board` without thinking of \
redrawing the canvas", "display" -> "markdown", 
    "sign" -> "preeminently-12bfc", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "1517ca46-5aad-46ea-88d6-722bc0f82ffc", "type" -> "input", 
    "data" -> "Do[\n  board = Last[CellularAutomaton[gameOfLife, board, {{0, \
1}}]];\n  Pause[0.1];\n, {i, 100}]", "display" -> "codemirror", 
    "sign" -> "preeminently-12bfc", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "d24debcf-1c3b-4e9d-98d8-8a844074263e", "type" -> "input", 
    "data" -> " ", "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "70b43f9e-e063-4dd2-863e-79bd9b642d11", "type" -> "input", 
    "data" -> ".md\n## Final touch\nIt is possible to get rid of a wrapper \
`CreateFrontEndObject`, if we register the function", 
    "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "358a03cb-daf6-4b45-8b73-73a8dd26a124", "type" -> "output", 
    "data" -> "\n## Final touch\nIt is possible to get rid of a wrapper \
`CreateFrontEndObject`, if we register the function", 
    "display" -> "markdown", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "2ec54a03-d104-45c2-b6d2-50bdba27072e", "type" -> "input", 
    "data" -> "RegisterWebObject[ArrayDraw];", "display" -> "codemirror", 
    "sign" -> "preeminently-12bfc", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "7065219e-3e55-4fbb-80ef-84dabcd0465f", "type" -> "input", 
    "data" -> 
     ".md\nSince it is registered, it is possible to call it as it is", 
    "display" -> "codemirror", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "ec3eea71-0d98-4274-bec8-8176bebb252f", "type" -> "output", 
    "data" -> "\nSince it is registered, it is possible to call it as it is", 
    "display" -> "markdown", "sign" -> "preeminently-12bfc", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9f48da02-61a5-4785-9cf3-8a28adee9179", "type" -> "input", 
    "data" -> "ArrayDraw[Hold[board]]", "display" -> "codemirror", 
    "sign" -> "preeminently-12bfc", "props" -> <|"hidden" -> False|>|>}, 
 "serializer" -> "jsfn3"|>
