---
sidebar_position: 1
---
A very powerful component for visualization we have is  `canvas`. It supports WebGL renderer, i.e. one can run graphics shaders and use GPU to accelerate the rendering.

:::note
`Graphics3D` implementation also uses `canvas` to render 3D models
:::

However the tutorial is focused on the simples possible API, that uses mostly CPU, but still good enough for simple graphics






Let's try the simples approach we can have

## Preliminary steps


:::info
Javascript cell can return `string`, `Object` or DOM element, that will be shown on the output cell
:::

:::info
Inside Javascript cells all defined variables are scoped to this cell. Therefore use DOM `id`s to manipulate created elements from other cells.
:::

## Binding to Wolfram Language
The next step is to use a bridge between Wolfram Language and Javascript maintained by [WLJS interpreter](../../../../interpreter/intro.md) 



:::info
To call any JavaScript function defined in `core` context, use `FrontSubmit` expression on on the desired Wolfram Expression. There is 1:1 correspondence with respect to Wolfram Language symbols, please see [WLJS interpreter](../../../../interpreter/intro.md) for more information.
:::

:::info
`core` context basically is a synonym to `Global` in Wolfram Language. Most symbols are parts of this object.
:::

:::tip
Always apply `await interpretate` to the arguments of defined function. It converts all Wolfram expressions being passed to the function to a plain javascript types. I.e. try to do any computing using native Javascript functions to minimize an overhead.
:::

## Plotting an array of data
Before our external function could take only one pair of numbers. This is boring, let us try to create something more useful and pretty



Here it is animated without involving Wolfram Kernel, we only provide a new set of data every `0.1` seconds to the frontend.

:::danger
Working in `.js` cells, always clean up the handlers, timers using `this.ondestroy` variable. Otherwise those timers and animation loops will continue to work even after reevaluating the cell.
:::

Download this notebook via a link
__[CanvasStepByStep](../../Tutorial/files/CanvasStepByStep.wln)__

## Making a native Wolfram frontend object
There is no need in having just one canvas, we can go further and implement sort of a native function, that will behave like `Graphics`, `Plot`.

Firstly, we can utilize the property of functions executed inside [containers](../../../../interpreter/Advanced/containers.md), and place all variables to the instance's local memory



:::tip
Use `env.local` object to store any variables related to that particular call of a function. `env.local` is unique for each call, but the same for `update`, `destroy` methods. Please see [architecture](../../../../interpreter/Advanced/architecture.md).
:::

:::tip
Use `env.element` to access to a DOM element provided by an editor for the function. This you will see as an inset inside the output cell.
::: 

Now one can execute it in a normal way, where the result is a symbol-like representation to which we got used to using `Plot` functions



:::tip
Use `CreateFrontEndObject` to call JavaScript (WLJS) function inside a container
:::

### Clean-up methods
In a case if you remove a widget from the output cell, DOM elements no longer exists, therefore you need manually remove event loops and etc. Like we did in a plain `.js` cell, there is similar method 



:::note
More about methods - see [architecture](../../../../interpreter/Advanced/architecture.md)
:::

### Update methods
This is a __one of the key-features__ implemented in this project. 
:::info
In order to optimize the dynamic evaluation and updates of graphs for each expression, that implies dynamic binding to the changing symbols, there must be an `update` method defined. 
:::
You can think about it if it was an `UpValue` for a symbol, which is called when a change to the nested structure happens. The dynamic binding happens between the nearest [containerized](../../../../interpreter/Advanced/containers.md) expressions. See an explanation here [Dynamics](../../Tutorial/Dynamics.md).



As one can see, full reevaluation of the `ArrayDraw` does not happen. Since `ArrawDraw.update` is a dedicated function, we can optimize the updates leaving out all unnecessary steps (recreating DOM, drawing supplementary stuff).

It allows us to simplify the final code a lot



Now `board` automatically binds to `ArrayDraw` instance, by setting `baord` to a new value, it redraws (using `update` method) our plot.

### Final touch
There is one more thing to improve. 



:::info
Apply `RegisterWebObject` to any expression you want to be executed on frontend [WLJS interpreter](../../../../interpreter/intro.md) inside a [container](../../../../interpreter/Advanced/containers.md). 
:::

Download this notebook
__[ArrayPlotterAdvanced](../../Tutorial/files/ArrayPlotterAdvanced.wln)__

## Wrapping up into a package
If you are writing a library it is better to ship it as a package. The package system is a bit different compared to Mathematica's, since it involves at least two languages

Firstly, __clone a sample package__ into `wolfram-js-frontend/Packages` folder
```bash
cd Packages
git clone https://github.com/JerryI/wljs-template

mv wljs-template wljs-name-of-my-plugin
cd wljs-name-of-my-plugin
rm -r .git
```

Now you can work and test you future package without any troubles. Wolfram Frontend will detect a new package and load it after next startup. 

__Open `package.json` file and remove unnecessary lines in `wljs-meta`__, we only need
```js
  "wljs-meta": {
    "jsmodule": "src/kernel.js",
    "wlkernel": "src/kernel.wln",
    "autocomplete": "src/autocomplete.js"
  }
```

:::note
Usually `jsmodule` is located in `dist` directory for most plugins. However, our example does not require any building or compilation (since no external libraries involved).
:::

__Now open `src/kernel.js`__ and write our Javascript code we stored in cells
```js
const getRandomInt = (max) => {
  return Math.floor(Math.random() * max);
}

core.ArrayDraw = async (args, env) => {
  const canvas = document.createElement('canvas');
  canvas.width = 300;
  canvas.height = 300;
  
  //append our canvas to the provided DOM
  env.element.appendChild(canvas);
  
  let context = canvas.getContext("2d");
  
  //use local memory to store the canvas
  env.local.ctx = context;

  //store the data in JS
  const innerData = [];
  env.local.innerData = innerData;

  const array = await interpretate(args[0], env);
  
  const width = array.length ;
  const height = array[0].length;
  
  array.forEach((row, i) => {
    row.forEach((cell, j) => {
      if (cell < 1) return;

      //add new data to the local store
      innerData.push({
        coordinates: [Math.floor(i * (300/width))-1, Math.floor(j * (300/height))-1, Math.floor((300/width)-1), Math.floor((300/height)-1)],
        lifetime: 1,
      });

      //limit the number of points
      if (innerData.length > 30*30) innerData.shift();
    });
  });

  //animation function
  function animate() {
    context.fillStyle = "white";
    context.fillRect(0, 0, 300, 300);

    //draw all data from the store and fade it based on the lifetime
    for (let i=0; i<innerData.length; ++i) {
      context.fillStyle = `rgba(${255/innerData[i].lifetime},0,${255 - 255/innerData[i].lifetime}, ${1/innerData[i].lifetime}`;
      context.fillRect(...innerData[i].coordinates);
      //a rectangle gets older
      innerData[i].lifetime = innerData[i].lifetime + 0.2;
    }

    //sync to the browser's frame rate
    env.local.uid = requestAnimationFrame(animate);
  }

  requestAnimationFrame(animate);
}

core.ArrayDraw.destroy = async (args, env) => {
  //remove animation loop
  cancelAnimationFrame(env.local.uid);
  //make shure that all other nested object will do the same
  interpretate(args[0], env);
}

core.ArrayDraw.update = async (args, env) => {
  //restore the context
  let context = env.local.ctx;
  const innerData = env.local.innerData;
  //get new data
  const array = await interpretate(args[0], env);
  
  const width = array.length ;
  const height = array[0].length;
  //update
  array.forEach((row, i) => {
    row.forEach((cell, j) => {
      if (cell < 1) return;

      //add new data to the local store
      innerData.push({
        coordinates: [Math.floor(i * (300/width))-1, Math.floor(j * (300/height))-1, Math.floor((300/width)-1), Math.floor((300/height)-1)],
        lifetime: 1,
      });

      //limit the number of points
      if (innerData.length > 30*30) innerData.shift();
    });
  });
}
```

Now we need to register a function. __Open a file `src/wlkernel.wln`__
```mathematica
RegisterWebObject[ArrayDraw]
```

And for the final touch - __add a new line into `src/autocomplete.js`__
```js
    {
        "label": "ArrayDraw",
        "type": "keyword",
        "info": "ArrayDraw[{{...}, {...}}] draws 2D binary lists"  
    }
```

Now restart Wolfram Frontend as well as Local Kernel to see the result.
Type in any notebook 

```mathematica
ArrayDraw[Table[RandomInteger[1], {i,20}, {j,20}]]
```