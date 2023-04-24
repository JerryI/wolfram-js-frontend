Properties
```js
env.numerical = true //Return a real value
env.element = document...   //Element to render
env.todom = true     //Force to render to env.element
env.update = uid    //Update the data, goes with uid
env.reactive = true    //Applies binding to all FrontEndVariable
env.variable = true    //Can be used to detect FrontEndVariables
env.allowsymbolic = true //Allow to print non-existing functions as strings
env.hold = false //Hold the innner exprs
env.forceupdate = false //Force get the executable object
env.tracking = false //chaining
env.evaluationDepth = 0; //0 means inifinity, 1,2.. etc
```

```js
FrontEndExecutables
```

We can ask for them, ==only when we need them== via websockets. And cache them
> ofc one can forcely update them using
> `DefineObject[]` sending via WS to the frontend and call a chain reaction updates

If there is no `FrontEndExecutable`, then call
```mathematica
NotebookGetObject[]
```
and return the reference
```js
promises.push();
```

## New methods
```js
core.Function = {
	default:

	update: 
}
```

## How to store JS function
use objects as well

one can write