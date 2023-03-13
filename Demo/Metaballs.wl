<|"notebook" -> <|"name" -> "Untitled", "id" -> "distort-b4d5c", 
   "kernel" -> LocalKernel, "objects" -> 
    <|"6582f3c0-00a6-45bf-9e60-23e8451bc1de" -> "[\n\t\"FrontEndTruncated\",\
\n\t\"'NBodySimulationData[<|1 -> <|\\\"Mass\\\" -> 1, \
\\\"Positio'\",\n\t249864\n]", "0b33af30-66c2-499b-a95c-bff4b696a6e8" -> "[\n\
\t\"FrontEndTruncated\",\n\t\"'NBodySimulationData[<|1 -> <|\\\"Mass\\\" -> \
1, \\\"Positio'\",\n\t3629796\n]", "c0c3c16a-d303-45d7-a900-2f693285fcda" -> 
      "[\n\t\"FrontEndTruncated\",\n\t\"'NBodySimulationData[<|1 -> \
<|\\\"Mass\\\" -> 1, \\\"Positio'\",\n\t3628864\n]", 
     "9dc4429f-b621-47b5-83d7-7ece684557a8" -> "[\n\t\"FrontEndTruncated\",\n\
\t\"'NBodySimulationData[<|1 -> <|\\\"Mass\\\" -> 1, \
\\\"Positio'\",\n\t35542195\n]", "395a21c5-df3d-4fc9-b4c4-99370bb61d9c" -> "[\
\n\t\"FrontEndTruncated\",\n\t\"'NBodySimulationData[<|1 -> <|\\\"Mass\\\" -> \
1, \\\"Positio'\",\n\t6483898\n]", "2db847a1-e987-4136-876d-80447d3d159c" -> 
      "[\n\t\"FrontEndTruncated\",\n\t\"'NBodySimulationData[<|1 -> \
<|\\\"Mass\\\" -> 1, \\\"Positio'\",\n\t209946\n]", 
     "73f1822b-29a2-4a9b-9156-b5a87934c925" -> "[\n\t\"FrontEndTruncated\",\n\
\t\"'NBodySimulationData[<|1 -> <|\\\"Mass\\\" -> 1, \
\\\"Positio'\",\n\t208286\n]", "134ce797-47f2-43fc-9bb2-04ca9864a75c" -> "[\n\
\t\"FrontEndTruncated\",\n\t\"'NBodySimulationData[<|1 -> <|\\\"Mass\\\" -> \
1, \\\"Positio'\",\n\t208285\n]", "1bb0b20a-ce30-4105-b7a3-2100effb9a27" -> "\
[\n\t\"FrontEndTruncated\",\n\t\"'NBodySimulationData[<|1 -> <|\\\"Mass\\\" \
-> 1, \\\"Positio'\",\n\t208286\n]"|>, 
   "path" -> "/Volumes/Data/Github/wolfram-js-frontend/Demo/Metaballs.wl", 
   "cell" -> "c97fcaff-e58a-4bc3-9a6c-9ef5e920fddf", 
   "date" -> DateObject[{2023, 3, 13, 19, 23, 18.350408`8.016220708979038}, 
     "Instant", "Gregorian", 1.]|>, 
 "cells" -> {<|"id" -> "12b8b86d-9687-464d-9c3f-79e50605395e", 
    "type" -> "input", "data" -> "\nEventBind[update, Function[data,\n \n  \
SendToFrontEnd[UpdateCanvas[getScaled[t]]];\n  t = t + 0.01;\n  If[t > 1.0, t \
= 0];\n]];", "display" -> "codemirror", "sign" -> "distort-b4d5c", 
    "prev" -> "5e95ca4a-722c-4578-8ab8-3514135ec9ab", 
    "next" -> "53d25766-f417-4753-9b2e-3bb76c1265ff", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "45455492-3083-4182-bfbc-a2b8426d28b5", "type" -> "output", 
    "data" -> "EventObject[<|\"id\" -> \"reCompute\"|>]", 
    "display" -> "codemirror", "sign" -> "distort-b4d5c", "prev" -> Null, 
    "next" -> Null, "parent" -> "ea1029d2-4926-4f05-a506-a3c90f4d8d5a", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "53d25766-f417-4753-9b2e-3bb76c1265ff", "type" -> "input", 
    "data" -> "\nSendToFrontEnd[UpdateCanvas[getScaled[t]]]", 
    "display" -> "codemirror", "sign" -> "distort-b4d5c", 
    "prev" -> "12b8b86d-9687-464d-9c3f-79e50605395e", 
    "next" -> "ea1029d2-4926-4f05-a506-a3c90f4d8d5a", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "5e95ca4a-722c-4578-8ab8-3514135ec9ab", "type" -> "input", 
    "data" -> "EventRemove[update];", "display" -> "codemirror", 
    "sign" -> "distort-b4d5c", "prev" -> 
     "83ff519e-72a1-4539-a9a0-7a9673c7255f", 
    "next" -> "12b8b86d-9687-464d-9c3f-79e50605395e", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "70ecb26b-e336-4e13-baeb-11299bc68b31", "type" -> "input", 
    "data" -> "update = EventObject[<|\"id\"->\"reCompute\"|>];\nupdate", 
    "display" -> "codemirror", "sign" -> "distort-b4d5c", 
    "prev" -> "c908967b-d96f-4f4b-bd74-7676068c1bb1", 
    "next" -> "83ff519e-72a1-4539-a9a0-7a9673c7255f", "parent" -> Null, 
    "child" -> "7b641838-c51d-43a2-a357-24a7b4a23dfd", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "7b641838-c51d-43a2-a357-24a7b4a23dfd", "type" -> "output", 
    "data" -> "EventObject[<|\"id\" -> \"reCompute\"|>]", 
    "display" -> "codemirror", "sign" -> "distort-b4d5c", "prev" -> Null, 
    "next" -> Null, "parent" -> "70ecb26b-e336-4e13-baeb-11299bc68b31", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "808542c4-079d-4e5a-9971-c511fa1e301d", "type" -> "output", 
    "data" -> "\n## WebGL Metaballs example", "display" -> "markdown", 
    "sign" -> "distort-b4d5c", "prev" -> Null, "next" -> Null, 
    "parent" -> "c97fcaff-e58a-4bc3-9a6c-9ef5e920fddf", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "83ff519e-72a1-4539-a9a0-7a9673c7255f", "type" -> "input", 
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
u_ball1)*distance(gl_FragCoord.xy, u_ball1)) + 1.0 / \
(distance(gl_FragCoord.xy, u_ball2)*distance(gl_FragCoord.xy, u_ball2)) + 1.0 \
/ (distance(gl_FragCoord.xy, u_ball3)*distance(gl_FragCoord.xy, u_ball3));\n  \
float t = smoothstep(0.0, 1.0, (0.04 - f) / 0.04);\n  gl_FragColor = \
vec4(cubehelixDefault(t), 1.0);\n}\n`);\n  gl.compileShader(shader);\n  \
fragmentShader= shader;\n\n}\n\nvar vertexShader;\n\n{\n  const shader = \
gl.createShader(gl.VERTEX_SHADER);\n  gl.shaderSource(shader, `\nattribute \
vec2 a_corner;\nvoid main(void) {\n  gl_Position = vec4(a_corner, 0.0, \
1.0);\n}\n`);\n  gl.compileShader(shader);\n   vertexShader = shader;\n  \
\n}\n\nvar program;\n{\n  const program0 = gl.createProgram();\n  \
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
vertexAttribPointer(a_corner, 2, gl.FLOAT, false, 0, 0);\n\ncore.UpdateCanvas \
= function(args, env) {\n  const coords = interpretate(args[0]);\n  \
gl.uniform2f(\n    u_ball1,\n    coords[0][0],\n    coords[0][1]\n  );\n  \
gl.uniform2f(\n    u_ball2,\n    coords[1][0],\n    coords[1][1]\n  );\n  \
gl.uniform2f(\n    u_ball3,\n    coords[2][0],\n    coords[2][1]\n  );\n  \
gl.drawArrays(gl.TRIANGLE_FAN, 0, 4);  \n\n  \
requestAnimationFrame(animate);\n}\n\nfunction animate() {\n  \
core.FireEvent([\"'reCompute'\", 0]);\n}\n\nconst uid = \
requestAnimationFrame(animate);\nthis.ondestroy = function() \
{cancelAnimationFrame(uid)};\n\nreturn canvas;", "display" -> "codemirror", 
    "sign" -> "distort-b4d5c", "prev" -> 
     "70ecb26b-e336-4e13-baeb-11299bc68b31", 
    "next" -> "5e95ca4a-722c-4578-8ab8-3514135ec9ab", "parent" -> Null, 
    "child" -> "b0522a19-dc41-472f-ae81-dc1375e32c39", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "b0522a19-dc41-472f-ae81-dc1375e32c39", "type" -> "output", 
    "data" -> "const canvas = document.createElement('canvas');\nvar gl = \
canvas.getContext(\"webgl\", {depth: false});\n\nvar height =300;\nvar width \
=600;\n\ncanvas.width = width;\ncanvas.height = height;\n\nvar \
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
u_ball1)*distance(gl_FragCoord.xy, u_ball1)) + 1.0 / \
(distance(gl_FragCoord.xy, u_ball2)*distance(gl_FragCoord.xy, u_ball2)) + 1.0 \
/ (distance(gl_FragCoord.xy, u_ball3)*distance(gl_FragCoord.xy, u_ball3));\n  \
float t = smoothstep(0.0, 1.0, (0.04 - f) / 0.04);\n  gl_FragColor = \
vec4(cubehelixDefault(t), 1.0);\n}\n`);\n  gl.compileShader(shader);\n  \
fragmentShader= shader;\n\n}\n\nvar vertexShader;\n\n{\n  const shader = \
gl.createShader(gl.VERTEX_SHADER);\n  gl.shaderSource(shader, `\nattribute \
vec2 a_corner;\nvoid main(void) {\n  gl_Position = vec4(a_corner, 0.0, \
1.0);\n}\n`);\n  gl.compileShader(shader);\n   vertexShader = shader;\n  \
\n}\n\nvar program;\n{\n  const program0 = gl.createProgram();\n  \
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
vertexAttribPointer(a_corner, 2, gl.FLOAT, false, 0, 0);\n\ncore.UpdateCanvas \
= function(args, env) {\n  const coords = interpretate(args[0]);\n  \
gl.uniform2f(\n    u_ball1,\n    coords[0][0],\n    coords[0][1]\n  );\n  \
gl.uniform2f(\n    u_ball2,\n    coords[1][0],\n    coords[1][1]\n  );\n  \
gl.uniform2f(\n    u_ball3,\n    coords[2][0],\n    coords[2][1]\n  );\n  \
gl.drawArrays(gl.TRIANGLE_FAN, 0, 4);  \n\n  \
requestAnimationFrame(animate);\n}\n\nfunction animate() {\n  \
core.FireEvent([\"'reCompute'\", 0]);\n}\n\nconst uid = \
requestAnimationFrame(animate);\nthis.ondestroy = function() \
{cancelAnimationFrame(uid)};\n\nreturn canvas;", "display" -> "js", 
    "sign" -> "distort-b4d5c", "prev" -> Null, "next" -> Null, 
    "parent" -> "83ff519e-72a1-4539-a9a0-7a9673c7255f", "child" -> Null, 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "bd713842-9c81-44de-99a7-0726ebf94dfb", "type" -> "output", 
    "data" -> "FrontEndExecutable[\"1bb0b20a-ce30-4105-b7a3-2100effb9a27\"]", 
    "display" -> "codemirror", "sign" -> "distort-b4d5c", "prev" -> Null, 
    "next" -> Null, "parent" -> "ccb4a456-c63f-4fc3-bd62-648a00a34c40", 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c908967b-d96f-4f4b-bd74-7676068c1bb1", "type" -> "input", 
    "data" -> "width = 600;\nheight = 300;\nt = 0;\n\ngetScaled[t_] := \
Module[{max,min, pos = data[All, \"Position\", t]},\n  max = 1.5 \
Max[pos//Flatten] {1,1};\n  min = 1.5 Min[pos//Flatten] {1,1};\n\n  ( {width, \
height}  (# - min) / (max - min))& /@ pos\n];", "display" -> "codemirror", 
    "sign" -> "distort-b4d5c", "prev" -> 
     "ccb4a456-c63f-4fc3-bd62-648a00a34c40", 
    "next" -> "70ecb26b-e336-4e13-baeb-11299bc68b31", "parent" -> Null, 
    "child" -> Null, "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "c97fcaff-e58a-4bc3-9a6c-9ef5e920fddf", "type" -> "input", 
    "data" -> ".md\n## WebGL Metaballs example", "display" -> "codemirror", 
    "sign" -> "distort-b4d5c", "prev" -> Null, 
    "next" -> "ccb4a456-c63f-4fc3-bd62-648a00a34c40", "parent" -> Null, 
    "child" -> "808542c4-079d-4e5a-9971-c511fa1e301d", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "ccb4a456-c63f-4fc3-bd62-648a00a34c40", "type" -> "input", 
    "data" -> "data  = NBodySimulation[\n  \"InverseSquare\", {\n  <|\"Mass\" \
-> 1, \"Position\" -> {0, 2}, \"Velocity\" -> {0, .5}|>,\n  <|\"Mass\" -> 1, \
\"Position\" -> {0.1, 0.4}, \"Velocity\" -> {+0.01, -.5}|>,\n  <|\"Mass\" -> \
1, \"Position\" -> {-1.1, 0.4}, \"Velocity\" -> {-0.11, -.5}|>}, 1]", 
    "display" -> "codemirror", "sign" -> "distort-b4d5c", 
    "prev" -> "c97fcaff-e58a-4bc3-9a6c-9ef5e920fddf", 
    "next" -> "c908967b-d96f-4f4b-bd74-7676068c1bb1", "parent" -> Null, 
    "child" -> "bd713842-9c81-44de-99a7-0726ebf94dfb", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "ea1029d2-4926-4f05-a506-a3c90f4d8d5a", "type" -> "input", 
    "data" -> "update", "display" -> "codemirror", "sign" -> "distort-b4d5c", 
    "prev" -> "53d25766-f417-4753-9b2e-3bb76c1265ff", "next" -> Null, 
    "parent" -> Null, "child" -> "45455492-3083-4182-bfbc-a2b8426d28b5", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn"|>
