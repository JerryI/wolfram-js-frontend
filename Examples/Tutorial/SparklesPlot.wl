<|"notebook" -> <|"name" -> "Resuscitator", "id" -> "paunch-4171c", 
   "kernel" -> LocalKernel, "objects" -> <||>, "path" -> "/Volumes/Data/Githu\
b/wolfram-js-frontend/Examples/Tutorial/SparklesPlot.wl", "cell" :> Exit[], 
   "date" -> DateObject[{2023, 6, 19, 16, 5, 55.999577`8.500759720677959}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "6a25401f-b5ac-45c2-a137-4c0a218adc816e1", 
    "type" -> "input", "data" -> ".md\nLet's try something fancy", 
    "display" -> "codemirror", "sign" -> "paunch-4171c", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "8a60c125-1d61-4299-ace6-8d81b6a526dd6e1", "type" -> "output", 
    "data" -> "\nLet's try something fancy", "display" -> "markdown", 
    "sign" -> "paunch-4171c", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "507508a8-037e-4132-9896-0ab1292a84976e1", "type" -> "input", 
    "data" -> ".js\nconst canvas = \
document.createElement('canvas');\ncanvas.width = 600;\ncanvas.height = \
400;\nconst context = canvas.getContext('2d');\nconst particles = \
[];\n\nfunction random (min, max) {\n  return Math.random() * (max - min) + \
min;\n}\n\nfunction convertRange( value, r1, r2 ) { \n    return ( value - \
r1[ 0 ] ) * ( r2[ 1 ] - r2[ 0 ] ) / ( r1[ 1 ] - r1[ 0 ] ) + r2[ 0 \
];\n}\n\nlet uid = 0;\nlet data = [];\n\nfunction animate() {\n  if \
(data.length > 0) {\n  for (let j=0; j<3; ++j) {\n    const it = \
Math.floor(random(0, data.length-1));\n  \n    const particle = {\n      x: \
data[it][0],\n      y: data[it][1],\n      xvel: random(-1,1),\n      yvel: \
random(-1,1),\n      color: `rgba(${random(0, 255)}, ${random(0, 255)}, \
${random(0, 255)}, 0.5)`,\n      size: 7,\n      age: 1\n    };\n  \n    \
particles.push(particle);\n    if (particles.length > 2000) {\n      \
particles.shift();\n    }\n  }\n  }\n  \n  context.clearRect(0, 0, \
canvas.width, canvas.height);\n  for (let i = 0; i < particles.length; i += \
1){\n    const p = particles[i];\n    context.beginPath();\n    \
context.arc(p.x, p.y, p.size/p.age, 0, Math.PI * 2, true);\n    \
context.fillStyle = p.color;\n    context.fill();\n    context.closePath(); \
\n    p.age += 0.1;\n    p.x += p.xvel;\n    p.y -= p.yvel;  \n  }\n\n  uid = \
window.requestAnimationFrame(animate);\n}\n\nthis.ondestroy = () => {\n  \
window.cancelAnimationFrame(uid)\n}\n\n//function definition \ncore.Spark = \
async (args, env) => {\n  //update the positions\n  const raw = await \
interpretate(args[0], env);\n  const min = [Math.min.apply(null, raw.map((e) \
=> e[0])), Math.min.apply(null, raw.map((e) => e[1]))];\n  const max = \
[Math.max.apply(null, raw.map((e) => e[0])), Math.max.apply(null, raw.map((e) \
=> e[1]))];\n\n  data = raw.map((e)=>[convertRange(e[0], [min[0], max[0]], \
[50, 550]), convertRange(e[1], [max[1], min[1]], [50, 350])]);\n  \
\n}\n\n//kickstarter\nanimate();\n\nreturn canvas;", 
    "display" -> "codemirror", "sign" -> "paunch-4171c", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "ac092ff2-cd20-4797-8beb-fc08c101fba7", "type" -> "output", 
    "data" -> "\nconst canvas = \
document.createElement('canvas');\ncanvas.width = 600;\ncanvas.height = \
400;\nconst context = canvas.getContext('2d');\nconst particles = \
[];\n\nfunction random (min, max) {\n  return Math.random() * (max - min) + \
min;\n}\n\nfunction convertRange( value, r1, r2 ) { \n    return ( value - \
r1[ 0 ] ) * ( r2[ 1 ] - r2[ 0 ] ) / ( r1[ 1 ] - r1[ 0 ] ) + r2[ 0 \
];\n}\n\nlet uid = 0;\nlet data = [];\n\nfunction animate() {\n  if \
(data.length > 0) {\n  for (let j=0; j<3; ++j) {\n    const it = \
Math.floor(random(0, data.length-1));\n  \n    const particle = {\n      x: \
data[it][0],\n      y: data[it][1],\n      xvel: random(-1,1),\n      yvel: \
random(-1,1),\n      color: `rgba(${random(0, 255)}, ${random(0, 255)}, \
${random(0, 255)}, 0.5)`,\n      size: 7,\n      age: 1\n    };\n  \n    \
particles.push(particle);\n    if (particles.length > 2000) {\n      \
particles.shift();\n    }\n  }\n  }\n  \n  context.clearRect(0, 0, \
canvas.width, canvas.height);\n  for (let i = 0; i < particles.length; i += \
1){\n    const p = particles[i];\n    context.beginPath();\n    \
context.arc(p.x, p.y, p.size/p.age, 0, Math.PI * 2, true);\n    \
context.fillStyle = p.color;\n    context.fill();\n    context.closePath(); \
\n    p.age += 0.1;\n    p.x += p.xvel;\n    p.y -= p.yvel;  \n  }\n\n  uid = \
window.requestAnimationFrame(animate);\n}\n\nthis.ondestroy = () => {\n  \
window.cancelAnimationFrame(uid)\n}\n\n//function definition \ncore.Spark = \
async (args, env) => {\n  //update the positions\n  const raw = await \
interpretate(args[0], env);\n  const min = [Math.min.apply(null, raw.map((e) \
=> e[0])), Math.min.apply(null, raw.map((e) => e[1]))];\n  const max = \
[Math.max.apply(null, raw.map((e) => e[0])), Math.max.apply(null, raw.map((e) \
=> e[1]))];\n\n  data = raw.map((e)=>[convertRange(e[0], [min[0], max[0]], \
[50, 550]), convertRange(e[1], [max[1], min[1]], [50, 350])]);\n  \
\n}\n\n//kickstarter\nanimate();\n\nreturn canvas;", "display" -> "js", 
    "sign" -> "paunch-4171c", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "af951316-867b-4f41-b8e4-74208d9200ae6e1", "type" -> "input", 
    "data" -> "SparkPlot[func_, range_] := With[{var = Extract[range,1, \
Inactivate], min = range[[2]], max = range[[3]]}, Table[{var, func}, {var, \
min, max, CM6Fraction[max-min, 200.0]}]] // FrontSubmit[Spark[#]] \
&\n\nSetAttributes[SparkPlot, HoldAll]\n\nSparkPlot[Sinc[x], {x,-10,10}]", 
    "display" -> "codemirror", "sign" -> "paunch-4171c", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn3"|>
