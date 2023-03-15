## How it works
A web server and the half of logic runs on freeware Wolfram Engine as a __backend__
- serves the static page via library [TinyWeb & WSP](https://github.com/JerryI/tinyweb-mathematica) (hypertext preprocessor)
- stores the whole structure of the notebook
- communicates with a JS __frontend__ via websockets

CodeMirror 6 library was used to operate notebook cells inside the page, when you press `Shift-Enter` it sends the content and a command to Wolfram Engine via websockets. 

See an overview picture here
![](/docs/drawings/overview.excalidraw.svg)

#### Evaluation process
On the backend, it evaluates the result and sends it back via websockets. However, if there is a `Graphics3D` object (in future can be extended to many) it replaces it with a  special symbol `FrontEndExecutable["uid"]`, which tells to frontend, that the content can be executed in a browser. Also, web server sends a JSON representation of the content behind `FrontEndExecutable` to be parsed by JS. 

Once it arrived CodeMirror uses `Decorations` structure to detect these objects inside the code and executes the content of it via a written very primitive JS Mathematica interpreter. CodeMirror treats it as an `AtomicRange`, i.e. a single symbol containing a complex DOM element. Of course, once it was sent back to the backend the `FrontEndExecutable` will be replaced by the original function.

#### Primitive JS Interpreter
Originally it was done for the [utility](https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine) to convert Graphics3D objects to ThreeJS, because one needs to parse the internal structure, which includes almost all features of a Wolfram Language. 

By default JS script interprets everything that arrives via websockets using `interpretate(json, env)`, therefore for the creation of notebook cells it uses the Wolfram-like function `FrontEndCreateCell[]`. To define your own function, you can write it as
```js
core.List = function(args, env) {
  var copy, e, i, len, list;
  copy = Object.assign({}, env);
  list = [];
  for (i = 0, len = args.length; i < len; i++) {
    e = args[i];
    list.push(interpretate(e, copy));
  }
  return list;
};
```
The set of `Graphics3D` objects is loaded from [this](https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine) repository and extends `core` functions.

In general, it is possible to insert inside `FrontEndExecutable` anything you want to execute at a frontend side.

![](/docs/drawings/browser-side.excalidraw.svg)


