

## Direct plot via in-build functions
The easiest way

*First and the last cell*
```mathematica
data = {1,2,3,4,5,6,7};
ListLinePloty[data]
```

or define your own lcoally
*First cell*
```js
.js
core.MyVisual = function(args, env) {
  if (env.update) {
    document.getElementById(env.update).innerHTML = args[0];
    return;
  }
  env.element.innerHTML = args[0];
}
```
*Second cell*
```mathematica
CreateFrontEndObject[MyVisual[data]]
```
it will print is as a webobject directly

## Transfer via global functions
One can define all handlers directly

*First cell*
```mathematica
data = ...;
FrontEndExecute[GetMyData[data]];
SessionSubmit[UpdateMyData[data+1]];
```
> comments, this is just a wrapper
```mathematica
FrontEndExecute[sym_] := WebSocketPublish[server, sym, $notebookUID]
```
no output

*Second cell*
```js
.js
core.GetMyData = function(args, env) {
  core.myAmazingdata = args[0];
  Ploty.plot("uid", args)
}
core.UpdateMyData = function(args, env) {
  Ploty.replot('uid', args[0]);
} 
```

*Third cell*
```html
<div id="uid"></div>
```

## Transfer data via templates aka `<?wsp ?>`

*Corrponding cell*
```js
.js
Ploty.plot({data: <?wsp Export[data, "JSON"] ?>;})
```

*Third cell*
in a case if there is no output of JS one
```html
.html
<div id="uid"></div>
```

Alternative way (shitter)
*First cell*
```html
.html
<div id="uid"></div>
<script>
	Ploty.plot('uid', {data: <?wsp Export[data, "JSON"] ?>;})
</script>
```

## Transfer data via `FrontEndExecutable`

*First cell*
```mathematica
(* some computing...
exporting the data to the *)
data = ....;
StoreObject[data -> "FrontEndExecutable", "uid"]
```
```
no output, just use websockets
```
Basically, it just creates `FrontEndExectuable` object and adds in to
- `Notebook["objects"]` as a regular object
- sends in to the cell
> Actually, it can be also store only in notebook. BUT. When frotnend will ask backend for the data, it will not update it anymore. Therfore, you need to force JS to update it, i.e. call via websockets a function `DefineObject[uid]`, which manually puts

*Second cell*
```js
.js
return(Plot.data(core.FrontEndExecutable["uid"], layout, title="<?wsp title ?>"))
```

*Third cell*
in a case if there is no output in JS-type cell (can be hidden)
```html
.html
<div id="uid"></div>
```


since it is anyway now global. Even if we will restart the notebook, JS will ask backend for the missing information, if `uid` is absent in `$objects` global array.

#### Extra
Direct query to WF expressions
```js
.js
core.GetExpression('symbol', {interpretate: true})
```
Then, it looks like meta-prgramming, actually it makes a call
```js
...socket.send(`ExportSymbol[${name}, ${format}]``)
```
which makes promise and waits for the result. `format` can be `JSONExpression` or what ever, depeding weather it is necessry to interpretate it or not.

### Callbacks
see good example at https://observablehq.com/@grahampullan/interactive-curve-fitting#

```js
.js

core.GetExpression(, callback() => args.)
```

i.e. to perform a full communication between JS and Kernel
like in this example

```js
viewof pts = {
  
  const ptsList = [...initialPts];
  
  svg.on("click", (event)=> {
    const [x,y] = d3.pointer(event);
    ptsList.push({x:xScale.invert(x), y:yScale.invert(y)});
    svg.property('value', ptsList).dispatch('input');
  });
  
  svg.append("g")
    .attr("transform", `translate(0,${height - margin.bottom})`)
    .call(d3.axisBottom(xScale));

  svg.append("g")
    .attr("transform", `translate(${margin.left},0)`)
    .call(d3.axisLeft(yScale))
  
  svg.property('value', ptsList).dispatch('input');

  return svg.node();
}
```

Therefore, `onclick` kicks the Kenrel and a promise it evaluates the expression.

### 2.03.2023 Update

This works as follows
*First cell*
```mathematica
FrontEndObj[{
  {Table[i, {i,10}], Table[i^2, {i,10}]}
}, "myObject"]
```
==on reevaluate add force to upgrade. Just check the WebObjects store if it has alredy the same id==
```mathematica
UpdateFrontEndObj[]
```
==this==

*Second cell*
```mathematica
FrontEndObj[
  FrontEndOnly[
      WListPlotly[
        FrontEndRef["myObject"]
      ]
    ]
]
```

![[Screenshot 2023-03-02 at 20.40.23.png]]

It principle, one can make it in a way
> Slider, which does not use Kenrel at all! Purely on FrontEnd

See [[JS Objects]]