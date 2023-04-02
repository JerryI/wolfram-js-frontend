<|"notebook" -> <|"name" -> "Untitled", "id" -> "fantastical-5e97c", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"8c66969c-2bed-445d-8848-2535f177f035" -> 
      <|"json" -> "[\"FrontEndTruncated\",\"'NBodySimulationData[<|1 -> \
<|\\\"Mass\\\" -> 1, \\\"Positio'\",152308]", 
       "date" -> DateObject[{2023, 4, 2, 16, 14, 
          12.798012`7.859717498934504}, "Instant", "Gregorian", 3.]|>, 
     "1efa0e33-c0aa-4585-b347-fd29068ee5f3" -> 
      <|"json" -> "[\"FrontEndTruncated\",\"'NBodySimulationData[<|1 -> \
<|\\\"Mass\\\" -> 1, \\\"Positio'\",149016]", 
       "date" -> DateObject[{2023, 4, 2, 16, 14, 
          26.880307`8.182009206555989}, "Instant", "Gregorian", 3.]|>|>, 
   "path" -> "/root/wolfram-js-frontend/Demo/Metaballs-WebGL.wl", 
   "cell" -> "c97fcaff-e58a-4bc3-9a6c-9ef5e920fddf711", 
   "date" -> DateObject[{2023, 4, 2, 16, 14, 7.172972`7.6082741228025235}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "0f9d99c7-8598-41b2-b4b8-66e8175bb877711", 
    "type" -> "output", "data" -> "\nThen define some parameters and create \
an `EventObject` to be used for the interconnection with JS", 
    "display" -> "markdown", "sign" -> "fantastical-5e97c", "prev" -> Null, 
    "next" -> Null, "parent" -> "c8f34687-ab6b-4000-87c4-fe62a604b657711", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "12b8b86d-9687-464d-9c3f-79e50605395e711", "type" -> "input", 
    "data" -> "EventBind[update, Function[data,\n \n  \
SendToFrontEnd[UpdateCanvas[getScaled[t]]];\n  t = t + 0.01;\n  If[t > 1.0, t \
= 0;\n  (* regenerate it! *)\n  bodies  = NBodySimulation[\n    \
\"InverseSquare\", {\n    <|\"Mass\" -> 1, \"Position\" -> \
RandomReal[{-3,3},2], \"Velocity\" -> RandomReal[{-3,3},2]|>,\n    <|\"Mass\" \
-> 1, \"Position\" -> RandomReal[{-3,3},2], \"Velocity\" -> \
RandomReal[{-3,3},2]|>,\n    <|\"Mass\" -> 1, \"Position\" -> \
RandomReal[{-3,3},2], \"Velocity\" -> RandomReal[{-3,3},2]|>}, 1]  \n  \
];\n]];\n\n(* kickstarter *)\nSendToFrontEnd[UpdateCanvas[getScaled[t]]]", 
    "display" -> "codemirror", "sign" -> "fantastical-5e97c", 
    "prev" -> "18f5b016-d199-4e17-8874-b975b7b09154711", "next" -> Null, 
    "parent" -> Null, "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "18f5b016-d199-4e17-8874-b975b7b09154711", "type" -> "input", 
    "data" -> ".md\nStart the simulation", "display" -> "codemirror", 
    "sign" -> "fantastical-5e97c", "prev" -> 
     "5e95ca4a-722c-4578-8ab8-3514135ec9ab711", 
    "next" -> "12b8b86d-9687-464d-9c3f-79e50605395e711", "parent" -> Null, 
    "child" -> "78b8d595-7b10-4c5a-a16e-c38169e2c8a2711", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "247b28f5-e1e5-4cf9-b9fc-a5ece574cd7d", "type" -> "output", 
    "data" -> "const canvas = document.createElement('canvas');\nvar gl = \
canvas.getContext(\"webgl\", {depth: false});\n\nvar height =800;\nvar width \
=1000;\n\ncanvas.width = width;\ncanvas.height = height;\n\nvar \
fragmentShader;\n\n{\n  const shader = gl.createShader(gl.FRAGMENT_SHADER);\n \
 gl.shaderSource(shader, `\nprecision highp float;\nuniform vec2 \
u_ball1;\nuniform vec2 u_ball2;\nuniform vec2 u_ball3;\n\nconst float PI = \
3.14159265359;\n\n// https://github.com/d3/d3-color\nvec3 cubehelix(vec3 c) \
{\n  float a = c.y * c.z * (1.0 - c.z);\n  float cosh = cos(c.x + PI / \
2.0);\n  float sinh = sin(c.x + PI / 2.0);\n  return vec3(\n    (c.z + a * \
(1.78277 * sinh - 0.14861 * cosh)),\n    (c.z - a * (0.29227 * cosh + 0.90649 \
* sinh)),\n    (c.z + a * (1.97294 * cosh))\n  );\n}\n\n// \
https://github.com/d3/d3-scale-chromatic\nvec3 cubehelixDefault(float t) {\n  \
return cubehelix(vec3(mix(300.0 / 180.0 * PI, -240.0 / 180.0 * PI, t), 0.5, \
t));\n}\n\nvoid main(void) {\n  float f = 1.0 / (distance(gl_FragCoord.xy, \
u_ball1)) + 1.0 / (distance(gl_FragCoord.xy, u_ball2)) + 1.0 / \
(distance(gl_FragCoord.xy, u_ball3));\n  float t = smoothstep(0.0, 1.0, (0.04 \
- f) / 0.04);\n  gl_FragColor = vec4(cubehelixDefault(t), 1.0);\n}\n`);\n  \
gl.compileShader(shader);\n  fragmentShader= shader;\n\n}\n\nvar \
vertexShader;\n\n{\n  const shader = gl.createShader(gl.VERTEX_SHADER);\n  \
gl.shaderSource(shader, `\nattribute vec2 a_corner;\nvoid main(void) {\n  \
gl_Position = vec4(a_corner, 0.0, 1.0);\n}\n`);\n  \
gl.compileShader(shader);\n   vertexShader = shader;\n  \n}\n\nvar \
program;\n{\n  const program0 = gl.createProgram();\n  \
gl.attachShader(program0, vertexShader);\n  gl.attachShader(program0, \
fragmentShader);\n  gl.linkProgram(program0);\n   program = program0;\n \
\n};\n\nvar cornerBuffer;\n\n{\n  const buffer = gl.createBuffer();\n  \
gl.bindBuffer(gl.ARRAY_BUFFER, buffer);\n  gl.bufferData(gl.ARRAY_BUFFER, \
Float32Array.of(-1, -1, +1, -1, +1, +1, -1, +1), gl.STATIC_DRAW);\n  \
cornerBuffer = buffer;\n}\n\nvar a_corner = gl.getAttribLocation(program, \
\"a_corner\")\nvar u_ball1 = gl.getUniformLocation(program, \"u_ball1\")\nvar \
u_ball2 = gl.getUniformLocation(program, \"u_ball2\")\nvar u_ball3 = \
gl.getUniformLocation(program, \"u_ball3\")\n\ngl.viewport(0, 0, width, \
height);\ngl.useProgram(program);\ngl.enableVertexAttribArray(a_corner);\ngl.\
vertexAttribPointer(a_corner, 2, gl.FLOAT, false, 0, 0);\n\n//Frontend \
function, which is called by the Wolfram kernel\ncore.UpdateCanvas = \
function(args, env) {\n  const coords = interpretate(args[0]);\n  \
gl.uniform2f(\n    u_ball1,\n    coords[0][0],\n    coords[0][1]\n  );\n  \
gl.uniform2f(\n    u_ball2,\n    coords[1][0],\n    coords[1][1]\n  );\n  \
gl.uniform2f(\n    u_ball3,\n    coords[2][0],\n    coords[2][1]\n  );\n  \
gl.drawArrays(gl.TRIANGLE_FAN, 0, 4);  \n\n  \
requestAnimationFrame(animate);\n}\n\nfunction animate() {\n  \
core.FireEvent([\"'reCompute'\", 0]);\n}\n\nconst uid = \
requestAnimationFrame(animate);\nthis.ondestroy = function() \
{cancelAnimationFrame(uid)};\n\nreturn canvas;", "display" -> "js", 
    "sign" -> "fantastical-5e97c", "prev" -> Null, "next" -> Null, 
    "parent" -> "83ff519e-72a1-4539-a9a0-7a9673c7255f711", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "31ec827f-024d-4086-8941-47227c66ab84711", "type" -> "output", 
    "data" -> "\nEverything goes asynchronous, therefore, you can still \
operate with the cells. \n\nLet's define some basic 3-bodies system", 
    "display" -> "markdown", "sign" -> "fantastical-5e97c", "prev" -> Null, 
    "next" -> Null, "parent" -> "3c35153e-9feb-4714-9e27-b4f009b59a6a711", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "35991874-457f-4b48-95ad-c71f02cac5b3711", "type" -> "input", 
    "data" -> ".mermaid\nflowchart LR\n    subgraph Wolfram Kernel\n    \
subgraph Event\n        H[Handler]\n        \n    end\n    \
Calculations[/Calculations/]\n    \n\n    end\n    \n    subgraph Browser\n   \
     subgraph JS interpreter\n            definedFunction[UpdateCanvas]\n     \
       event[FireEvent]---> H[Handler]\n        end\n        definedFunction \
--> API\n        API -- each frame --> event\n        subgraph WebGL\n        \
    API\n        end\n\n    end\n    \n\n    \
H--->Calculations[/Calculations/]--WebSockets-->definedFunction", 
    "display" -> "codemirror", "sign" -> "fantastical-5e97c", 
    "prev" -> "c97fcaff-e58a-4bc3-9a6c-9ef5e920fddf711", 
    "next" -> "3c35153e-9feb-4714-9e27-b4f009b59a6a711", "parent" -> Null, 
    "child" -> "38255336-4679-4de8-95f5-10841a07bcf3711", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "38255336-4679-4de8-95f5-10841a07bcf3711", "type" -> "output", 
    "data" -> "\nflowchart LR\n    subgraph Wolfram Kernel\n    subgraph \
Event\n        H[Handler]\n        \n    end\n    \
Calculations[/Calculations/]\n    \n\n    end\n    \n    subgraph Browser\n   \
     subgraph JS interpreter\n            definedFunction[UpdateCanvas]\n     \
       event[FireEvent]---> H[Handler]\n        end\n        definedFunction \
--> API\n        API -- each frame --> event\n        subgraph WebGL\n        \
    API\n        end\n\n    end\n    \n\n    \
H--->Calculations[/Calculations/]--WebSockets-->definedFunction", 
    "display" -> "mermaid", "sign" -> "fantastical-5e97c", "prev" -> Null, 
    "next" -> Null, "parent" -> "35991874-457f-4b48-95ad-c71f02cac5b3711", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "3c35153e-9feb-4714-9e27-b4f009b59a6a711", "type" -> "input", 
    "data" -> ".md\nEverything goes asynchronous, therefore, you can still \
operate with the cells. \n\nLet's define some basic 3-bodies system", 
    "display" -> "codemirror", "sign" -> "fantastical-5e97c", 
    "prev" -> "35991874-457f-4b48-95ad-c71f02cac5b3711", 
    "next" -> "ccb4a456-c63f-4fc3-bd62-648a00a34c40711", "parent" -> Null, 
    "child" -> "31ec827f-024d-4086-8941-47227c66ab84711", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "5e95ca4a-722c-4578-8ab8-3514135ec9ab711", "type" -> "input", 
    "data" -> "EventRemove[update];", "display" -> "codemirror", 
    "sign" -> "fantastical-5e97c", "prev" -> 
     "9d549d1e-2030-4b8f-bc8c-0578c53bb9aa711", 
    "next" -> "18f5b016-d199-4e17-8874-b975b7b09154711", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "70ecb26b-e336-4e13-baeb-11299bc68b31711", "type" -> "input", 
    "data" -> ".md\nNow JS part comes with some basic shaders, which returns \
a DOM element", "display" -> "codemirror", "sign" -> "fantastical-5e97c", 
    "prev" -> "c908967b-d96f-4f4b-bd74-7676068c1bb1711", 
    "next" -> "83ff519e-72a1-4539-a9a0-7a9673c7255f711", "parent" -> Null, 
    "child" -> "e9cce823-6c14-41f4-b2c4-0753f09edd52711", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "78b8d595-7b10-4c5a-a16e-c38169e2c8a2711", "type" -> "output", 
    "data" -> "\nStart the simulation", "display" -> "markdown", 
    "sign" -> "fantastical-5e97c", "prev" -> Null, "next" -> Null, 
    "parent" -> "18f5b016-d199-4e17-8874-b975b7b09154711", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "83ff519e-72a1-4539-a9a0-7a9673c7255f711", "type" -> "input", 
    "data" -> ".js\nconst canvas = document.createElement('canvas');\nvar gl \
= canvas.getContext(\"webgl\", {depth: false});\n\nvar height = <?wsp height \
?>;\nvar width = <?wsp width ?>;\n\ncanvas.width = width;\ncanvas.height = \
height;\n\nvar fragmentShader;\n\n{\n  const shader = \
gl.createShader(gl.FRAGMENT_SHADER);\n  gl.shaderSource(shader, `\nprecision \
highp float;\nuniform vec2 u_ball1;\nuniform vec2 u_ball2;\nuniform vec2 \
u_ball3;\n\nconst float PI = 3.14159265359;\n\n// \
https://github.com/d3/d3-color\nvec3 cubehelix(vec3 c) {\n  float a = c.y * \
c.z * (1.0 - c.z);\n  float cosh = cos(c.x + PI / 2.0);\n  float sinh = \
sin(c.x + PI / 2.0);\n  return vec3(\n    (c.z + a * (1.78277 * sinh - \
0.14861 * cosh)),\n    (c.z - a * (0.29227 * cosh + 0.90649 * sinh)),\n    \
(c.z + a * (1.97294 * cosh))\n  );\n}\n\n// \
https://github.com/d3/d3-scale-chromatic\nvec3 cubehelixDefault(float t) {\n  \
return cubehelix(vec3(mix(300.0 / 180.0 * PI, -240.0 / 180.0 * PI, t), 0.5, \
t));\n}\n\nvoid main(void) {\n  float f = 1.0 / (distance(gl_FragCoord.xy, \
u_ball1)) + 1.0 / (distance(gl_FragCoord.xy, u_ball2)) + 1.0 / \
(distance(gl_FragCoord.xy, u_ball3));\n  float t = smoothstep(0.0, 1.0, (0.04 \
- f) / 0.04);\n  gl_FragColor = vec4(cubehelixDefault(t), 1.0);\n}\n`);\n  \
gl.compileShader(shader);\n  fragmentShader= shader;\n\n}\n\nvar \
vertexShader;\n\n{\n  const shader = gl.createShader(gl.VERTEX_SHADER);\n  \
gl.shaderSource(shader, `\nattribute vec2 a_corner;\nvoid main(void) {\n  \
gl_Position = vec4(a_corner, 0.0, 1.0);\n}\n`);\n  \
gl.compileShader(shader);\n   vertexShader = shader;\n  \n}\n\nvar \
program;\n{\n  const program0 = gl.createProgram();\n  \
gl.attachShader(program0, vertexShader);\n  gl.attachShader(program0, \
fragmentShader);\n  gl.linkProgram(program0);\n   program = program0;\n \
\n};\n\nvar cornerBuffer;\n\n{\n  const buffer = gl.createBuffer();\n  \
gl.bindBuffer(gl.ARRAY_BUFFER, buffer);\n  gl.bufferData(gl.ARRAY_BUFFER, \
Float32Array.of(-1, -1, +1, -1, +1, +1, -1, +1), gl.STATIC_DRAW);\n  \
cornerBuffer = buffer;\n}\n\nvar a_corner = gl.getAttribLocation(program, \
\"a_corner\")\nvar u_ball1 = gl.getUniformLocation(program, \"u_ball1\")\nvar \
u_ball2 = gl.getUniformLocation(program, \"u_ball2\")\nvar u_ball3 = \
gl.getUniformLocation(program, \"u_ball3\")\n\ngl.viewport(0, 0, width, \
height);\ngl.useProgram(program);\ngl.enableVertexAttribArray(a_corner);\ngl.\
vertexAttribPointer(a_corner, 2, gl.FLOAT, false, 0, 0);\n\n//Frontend \
function, which is called by the Wolfram kernel\ncore.UpdateCanvas = \
function(args, env) {\n  const coords = interpretate(args[0]);\n  \
gl.uniform2f(\n    u_ball1,\n    coords[0][0],\n    coords[0][1]\n  );\n  \
gl.uniform2f(\n    u_ball2,\n    coords[1][0],\n    coords[1][1]\n  );\n  \
gl.uniform2f(\n    u_ball3,\n    coords[2][0],\n    coords[2][1]\n  );\n  \
gl.drawArrays(gl.TRIANGLE_FAN, 0, 4);  \n\n  \
requestAnimationFrame(animate);\n}\n\nfunction animate() {\n  \
core.FireEvent([\"'reCompute'\", 0]);\n}\n\nconst uid = \
requestAnimationFrame(animate);\nthis.ondestroy = function() \
{cancelAnimationFrame(uid)};\n\nreturn canvas;", "display" -> "codemirror", 
    "sign" -> "fantastical-5e97c", "prev" -> 
     "70ecb26b-e336-4e13-baeb-11299bc68b31711", 
    "next" -> "9d549d1e-2030-4b8f-bc8c-0578c53bb9aa711", "parent" -> Null, 
    "child" -> "247b28f5-e1e5-4cf9-b9fc-a5ece574cd7d", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "9d549d1e-2030-4b8f-bc8c-0578c53bb9aa711", "type" -> "input", 
    "data" -> ".md\nStop the simulation", "display" -> "codemirror", 
    "sign" -> "fantastical-5e97c", "prev" -> 
     "83ff519e-72a1-4539-a9a0-7a9673c7255f711", 
    "next" -> "5e95ca4a-722c-4578-8ab8-3514135ec9ab711", "parent" -> Null, 
    "child" -> "a02ee428-e425-44ef-ac85-c7185c6242f0711", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "a02ee428-e425-44ef-ac85-c7185c6242f0711", "type" -> "output", 
    "data" -> "\nStop the simulation", "display" -> "markdown", 
    "sign" -> "fantastical-5e97c", "prev" -> Null, "next" -> Null, 
    "parent" -> "9d549d1e-2030-4b8f-bc8c-0578c53bb9aa711", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c8f34687-ab6b-4000-87c4-fe62a604b657711", "type" -> "input", 
    "data" -> ".md\nThen define some parameters and create an `EventObject` \
to be used for the interconnection with JS", "display" -> "codemirror", 
    "sign" -> "fantastical-5e97c", "prev" -> 
     "ccb4a456-c63f-4fc3-bd62-648a00a34c40711", 
    "next" -> "c908967b-d96f-4f4b-bd74-7676068c1bb1711", "parent" -> Null, 
    "child" -> "0f9d99c7-8598-41b2-b4b8-66e8175bb877711", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "c908967b-d96f-4f4b-bd74-7676068c1bb1711", "type" -> "input", 
    "data" -> "width = 1000;\nheight = 800;\nt = 0;\n\ngetScaled[t_] := \
Module[{max,min, pos = bodies[All, \"Position\", t]},\n  max = 1.5 \
Max[pos//Flatten] {1,1};\n  min = 1.5 Min[pos//Flatten] {1,1};\n\n  ( {width, \
height}  (# - min) / (max - min))& /@ pos\n];\nupdate = \
EventObject[<|\"id\"->\"reCompute\"|>];\nupdate", "display" -> "codemirror", 
    "sign" -> "fantastical-5e97c", "prev" -> 
     "c8f34687-ab6b-4000-87c4-fe62a604b657711", 
    "next" -> "70ecb26b-e336-4e13-baeb-11299bc68b31711", "parent" -> Null, 
    "child" -> "fb7ced80-8231-4d9c-92f9-cb583dd114e6", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c97fcaff-e58a-4bc3-9a6c-9ef5e920fddf711", "type" -> "input", 
    "data" -> ".md\n# WebGL Metaballs example\nShow some demonstration on how \
WebGL can interact with WL Kernel using event-based system.\nThe overall \
diagram is shown here", "display" -> "codemirror", 
    "sign" -> "fantastical-5e97c", "prev" -> Null, 
    "next" -> "35991874-457f-4b48-95ad-c71f02cac5b3711", "parent" -> Null, 
    "child" -> "d3f83f87-3ddd-4ab2-a37d-13601da6dc32711", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "ccb4a456-c63f-4fc3-bd62-648a00a34c40711", "type" -> "input", 
    "data" -> "bodies  = NBodySimulation[\n  \"InverseSquare\", {\n  \
<|\"Mass\" -> 1, \"Position\" -> {0, 2}, \"Velocity\" -> {0, .5}|>,\n  \
<|\"Mass\" -> 1, \"Position\" -> {3, 0.4}, \"Velocity\" -> {+0.01, -.5}|>,\n  \
<|\"Mass\" -> 1, \"Position\" -> {-1.1, 0.4}, \"Velocity\" -> {-2.11, \
-.5}|>}, 1]", "display" -> "codemirror", "sign" -> "fantastical-5e97c", 
    "prev" -> "3c35153e-9feb-4714-9e27-b4f009b59a6a711", 
    "next" -> "c8f34687-ab6b-4000-87c4-fe62a604b657711", "parent" -> Null, 
    "child" -> "eb566434-2fae-4bf7-a9cd-2adb0ccfbea1", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "d3f83f87-3ddd-4ab2-a37d-13601da6dc32711", "type" -> "output", 
    "data" -> "\n# WebGL Metaballs example\nShow some demonstration on how \
WebGL can interact with WL Kernel using event-based system.\nThe overall \
diagram is shown here", "display" -> "markdown", 
    "sign" -> "fantastical-5e97c", "prev" -> Null, "next" -> Null, 
    "parent" -> "c97fcaff-e58a-4bc3-9a6c-9ef5e920fddf711", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "e9cce823-6c14-41f4-b2c4-0753f09edd52711", "type" -> "output", 
    "data" -> "\nNow JS part comes with some basic shaders, which returns a \
DOM element", "display" -> "markdown", "sign" -> "fantastical-5e97c", 
    "prev" -> Null, "next" -> Null, "parent" -> 
     "70ecb26b-e336-4e13-baeb-11299bc68b31711", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "eb566434-2fae-4bf7-a9cd-2adb0ccfbea1", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"1efa0e33-c0aa-4585-b347-fd29068ee5f3\"]", 
    "display" -> "codemirror", "sign" -> "fantastical-5e97c", "prev" -> Null, 
    "next" -> Null, "parent" -> "ccb4a456-c63f-4fc3-bd62-648a00a34c40711", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "fb7ced80-8231-4d9c-92f9-cb583dd114e6", "type" -> "output", 
    "data" -> "EventObject[<|\"id\" -> \"reCompute\"|>]", 
    "display" -> "codemirror", "sign" -> "fantastical-5e97c", "prev" -> Null, 
    "next" -> Null, "parent" -> "c908967b-d96f-4f4b-bd74-7676068c1bb1711", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>}, 
 "serializer" -> "jsfn2"|>
