<|"notebook" -> <|"name" -> "Resuscitator", "id" -> "bottler-a549b", 
   "kernel" -> LocalKernel, "objects" -> <||>, "path" -> "/Volumes/Data/Githu\
b/wolfram-js-frontend/Demo/Experimental/Resuscitator.wl", "cell" :> Exit[], 
   "date" -> DateObject[{2023, 6, 10, 16, 58, 3.071639`7.239945161445781}, 
     "Instant", "Gregorian", 3.]|>, 
 "cells" -> {<|"id" -> "6a25401f-b5ac-45c2-a137-4c0a218adc81", 
    "type" -> "input", "data" -> ".md\nLet's try something fancy", 
    "display" -> "codemirror", "sign" -> "bottler-a549b", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "8a60c125-1d61-4299-ace6-8d81b6a526dd", "type" -> "output", 
    "data" -> "\nLet's try something fancy", "display" -> "markdown", 
    "sign" -> "bottler-a549b", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "507508a8-037e-4132-9896-0ab1292a8497", "type" -> "input", 
    "data" -> ".js\nconst canvas = \
document.createElement('canvas');\ncanvas.width = 600;\ncanvas.height = \
300;\nconst context = canvas.getContext('2d');\nconst particles = \
[];\n\nfunction random (min, max) {\n  return Math.random() * (max - min) + \
min;\n}\n\nlet uid;\nlet data = [];\n\nlet counter = 0;\n\nfunction animate() \
{\n  //to slow down the animation\n  counter = counter + 1;\n  if (counter < \
3) {\n    uid = window.requestAnimationFrame(animate);\n    return;\n  } else \
{\n    counter = 0;\n  };\n  \n  for (let i=0; i<data.length; ++i) {\n    \
const particle = {\n      x: data[i][0],\n      y: data[i][1],\n      xvel: \
random(-5,5),\n      yvel: random(-5,5),\n      color: `rgba(${random(0, \
255)}, ${random(0, 255)}, ${random(0, 255)}, 0.7)`,\n      size: 7,\n    };\n \
 \n    particles.push(particle);\n    if (particles.length > 2000) {\n      \
particles.shift();\n    }\n  }\n  \n  context.clearRect(0, 0, canvas.width, \
canvas.height);\n  for (let i = 0; i < particles.length; i += 1){\n    const \
p = particles[i];\n    context.fillStyle = p.color;\n    \
context.fillRect(p.x, p.y, p.size, p.size);\n    p.x += p.xvel;\n    p.y -= \
p.yvel;  \n  }\n\n  uid = \
window.requestAnimationFrame(animate);\n}\n\nthis.ondestroy = () => {\n  \
window.cancelAnimationFrame(uid)\n}\n\nfunction convertRange( value, r1, r2 ) \
{ \n    return ( value - r1[ 0 ] ) * ( r2[ 1 ] - r2[ 0 ] ) / ( r1[ 1 ] - r1[ \
0 ] ) + r2[ 0 ];\n}\n\n//function definition \ncore.Spark = async (args, env) \
=> {\n  //update the positions\n  const raw = await interpretate(args[0], \
env);\n  const min = [Math.min.apply(null, raw.map((e) => e[0])), \
Math.min.apply(null, raw.map((e) => e[1]))];\n  const max = \
[Math.max.apply(null, raw.map((e) => e[0])), Math.max.apply(null, raw.map((e) \
=> e[1]))];\n\n  console.log('minmax' + min + '  ' + max);\n\n  data = \
raw.map((e)=>[convertRange(e[0], [min[0], max[0]], [50, 550]), \
convertRange(e[1], [min[1], max[1]], [50, 250])]);\n  \n  //kickstarter\n  \
animate();\n}\n\nreturn canvas;", "display" -> "codemirror", 
    "sign" -> "bottler-a549b", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a22200a2-8d21-482d-a74c-1a93b701a22b", "type" -> "output", 
    "data" -> "\nconst canvas = \
document.createElement('canvas');\ncanvas.width = 600;\ncanvas.height = \
300;\nconst context = canvas.getContext('2d');\nconst particles = \
[];\n\nfunction random (min, max) {\n  return Math.random() * (max - min) + \
min;\n}\n\nlet uid;\nlet data = [];\n\nlet counter = 0;\n\nfunction animate() \
{\n  //to slow down the animation\n  counter = counter + 1;\n  if (counter < \
3) {\n    uid = window.requestAnimationFrame(animate);\n    return;\n  } else \
{\n    counter = 0;\n  };\n  \n  for (let i=0; i<data.length; ++i) {\n    \
const particle = {\n      x: data[i][0],\n      y: data[i][1],\n      xvel: \
random(-5,5),\n      yvel: random(-5,5),\n      color: `rgba(${random(0, \
255)}, ${random(0, 255)}, ${random(0, 255)}, 0.7)`,\n      size: 7,\n    };\n \
 \n    particles.push(particle);\n    if (particles.length > 2000) {\n      \
particles.shift();\n    }\n  }\n  \n  context.clearRect(0, 0, canvas.width, \
canvas.height);\n  for (let i = 0; i < particles.length; i += 1){\n    const \
p = particles[i];\n    context.fillStyle = p.color;\n    \
context.fillRect(p.x, p.y, p.size, p.size);\n    p.x += p.xvel;\n    p.y -= \
p.yvel;  \n  }\n\n  uid = \
window.requestAnimationFrame(animate);\n}\n\nthis.ondestroy = () => {\n  \
window.cancelAnimationFrame(uid)\n}\n\nfunction convertRange( value, r1, r2 ) \
{ \n    return ( value - r1[ 0 ] ) * ( r2[ 1 ] - r2[ 0 ] ) / ( r1[ 1 ] - r1[ \
0 ] ) + r2[ 0 ];\n}\n\n//function definition \ncore.Spark = async (args, env) \
=> {\n  //update the positions\n  const raw = await interpretate(args[0], \
env);\n  const min = [Math.min.apply(null, raw.map((e) => e[0])), \
Math.min.apply(null, raw.map((e) => e[1]))];\n  const max = \
[Math.max.apply(null, raw.map((e) => e[0])), Math.max.apply(null, raw.map((e) \
=> e[1]))];\n\n  console.log('minmax' + min + '  ' + max);\n\n  data = \
raw.map((e)=>[convertRange(e[0], [min[0], max[0]], [50, 550]), \
convertRange(e[1], [min[1], max[1]], [50, 250])]);\n  \n  //kickstarter\n  \
animate();\n}\n\nreturn canvas;", "display" -> "js", 
    "sign" -> "bottler-a549b", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "7847ae9b-1cfe-4347-ae06-b0d6c4300477", "type" -> "input", 
    "data" -> "SparkPlot[f_, range_] := Plot[f, range] // Cases[#, Line[x_] \
:> x[[;; ;;3]], All] & // (#//First) &  // FrontSubmit[Spark[#]] \
&;\n\nSparkPlot[CM6Superscript[Sin[x], 2], {x,0,10}];", 
    "display" -> "codemirror", "sign" -> "bottler-a549b", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "af951316-867b-4f41-b8e4-74208d9200ae", "type" -> "input", 
    "data" -> "", "display" -> "codemirror", "sign" -> "bottler-a549b", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn3"|>
