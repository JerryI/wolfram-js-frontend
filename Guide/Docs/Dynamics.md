DynamicsHow it should work

```mathematica
Dynamic[
	Module[{},
		var = x;
	];

	Ploty[var y, {x, 0, 1}]
, TrackedSymbols:>{}, Events:>{}]
```

__TrackedSymbols__ classical way
__Events__ controlled way, can bind to some functions in a way `EventBind[ev, Function]`

This block must be devided by two parts
- computable - compound expressions usually, __works on server__
- displayable - to be sent __to the client directly__
 1. string
 2. FrontEndExecutable's

Therefore for the speed, we need define a method for updates for each `FrontEndExecutable` or `FrontEndObject` like

```mathematica
Ploty := ...
Update[Ploty[], "Replace"] ^= shortcut to update the data graph
Update[Ploty[], "Append"] ^= shortcut to update the data graph
```

## Other ideas
There will be a possibillity to execute stuff on FrontEnd as well

```mathematica
FrontEndObject[ListLinePloty[data]] -> directly on frontend, i.e.
```
```js
core.ListLinePloty = function() {...need to transpose}
```

or as well one can use

```mathematica
ListLinePloty[data] :> FrontEndObject[WListPloty[data//Transpose]]
```
```js
core.WListLinePLoty = function() {...more perfomance}
```

Each object will be converted

```mathematica
FrontEndObject[func] -> FrontEndExecutable["id"] 
```

# Variants to update

## Seamless uncompiled update
- easy to use
- in principle, any object can be dynamic
- ==overhead in data transfering== (try to use [[#Optimizations to the constant data]])

Assume we have a module with

```mathematica
DynamicModule[
	Module[{},
		var = x;
	];

	FrontEndObject[ListLinePloty[var + 1]]
]
```
==Return it as a string (processed one)==

Before the evaluation one need to send it in a way like

```mathematica
DynamicModule[
	Module[{},
		var = x;
	];

	CellPrologOption[FrontEndObject[ListLinePloty[var + 1]], "id"->uid]
]
```
Then, we already know the `id` of a cell or of a frontend-object.

Use `env` variable. The general idea will be to create a module for an updates and send it in a way

```mathematica
updatable = UpdatableModule[
	Module[{},
		var = x;
	];

	(*ListLinePloty[var + 1]*)
	WebSocketPublish[ApplyAttributes[{"uid"->"id", "update"->True}, ListLinePloty[var + 1]], notebook]
]
```

One can just make a replacement 
```mathematica
FrontEndObject[x_, uid_] :> WebSocketPublish[ApplyAttributes[{"uid"->"id", "update"->True}, x]]
```
and them just send it to the kernel.
==YOU DO NOT NEED TO PASS IN TO EVALUATOR==
==IT WILL BE DONE IN EVENT HANDLER==
==Use `$NotebookID`== 

and somewhere in properties

```js
core.ListLinePloty = function(args, env) {
  if(env.update) {
    //no redrawing. just an update
    //take an id 
    env.uid...
    Ploty(uid).restyle()...
    return;
  }
}
```

### Strings and symbols

If we there is no drawable  `FrontEndObject` in the list, do not spend time on JSON expressions and etc

```mathematica
updatable = WebSocketPublish[FrontCellUpdate["id", UpdatableModule[
	Module[{},
		var = x;
	];

	
	newstringdata
]], notebook]
```

CodeMirror decorations might also work great there!
==We need to know the id==


## Reactive function
- sends only the actual data, that was changed
- ==needs the defined reactive functions in the JS memory==
- needs the API to update core.whatever

Need an extra input about the function
```mathematica
DynamicModule[
	Module[{},
		var = x;
	];

	FrontEndObject[ListLinePloty[var + 1, someother vars], Mutable:>{var}]
]
```

It reconstructs into

```mathematica
DefineRectiveFunction[ListLinePloty[# + 1, someother vars]&, "name"]
```

Then, there will be only data communication (the constant data will be ommited)

```mathematica
WebSocketPublish[RectiveFunctionPass[{var}, "name"], notebook]
```


## FrontEndVariable?  
*Let it be also something like FrontEndExecutable. we dont need a new type*
Should we 

```mathematica
WebSocketPublish[FrontEndObjectUpdate["id", ListLinePloty[var + 1, FrontEndVariable["uid"]]]
```

to save up the bandwidth in the end.


### Reactive binding to the FrontEndVariable

- no need to store reactive functions
- update the whole chain
- can be used together with the simplest scenario

One can simplify the reactive functions to this

```mathematica
WebSocketPublish[FrontEndVariableUpdate["uid", data]];
```

```js
core.Plus = function(args, env) {
	if (env.reactive) {
	  createFrontEndVariable[];
	  const link = ..;
	  addEventListener(args[0].uid, "change", ()=>
		  link.update(whatever);
	  );
	  return link;
	}
}

core.ListLinePloty = function(args, env) {
  if(env.reactive) {
    //args[0] is a FrontEndVariable[]
    addEventListener(args[0].uid, "change", ()=>
		Ploty.restyle
	);
    return;
  }
}
```

### Optimizations to the constant data

If one folllow [[#Seamless uncompiled update]], we can restyle the plot in a way to ignore the `FrontEndVariable` s passing as an argument

```js
core.ListLinePloty = function(args, env) {
  if(env.update) {
	  if (args[i][0] === 'FrontEndVariable') {
		  Plot.RemoveTraces([i-1]);
		  Plot.AddTraces()
	  }
  }
}
```

## Chaining

See [[Reactive functions]]

Collect all calls from `interpretate()` as a chain and pass to the `env` including env itself.
Therefore we can reconstruct the whole chain of updates
>it makes all cell dynamic by the default

see [[JS Objects]]

then, each function would have an option on how to deal with updates
```js
if (env.reactiveupdate) {
	
}
```

## Manual operation

If one can append the data... Well, it is impossible. Must be done manually

```mathematica
DynamicModule[
	Module[{},
		var = x;
	];

	FrontEndObject[ListLinePloty[var + 1, someother vars], "id"->myId]
, ManuallUpdate:>ExtendPlot[x]]
```

in the seprate cell one can define

```js
.js
core.ExtendPlot = function(args, env) {
	Ploty('<?wsp myId ?>').extend()
}
```


# Tradiitional reevalution

~~Not actualy about dynamics, but when you reevaluate the cell. Do not destroy it, apply~~
```mathematica
FrontEndUpdateCell[]
```

~~Add property to [[JS Objects]]~~

~~__DO NOT REMOVE CELL__~~

Compare the old data to a new one and decide, weahter only FrontEndExecutable is different.
Then decide wheater to update it quasi dynamically like in [[#Seamless uncompiled update]]

#GhostDynamicUpdate


## WSP Built-in dynamics
```mathematica
WSPDynamic[.., "uid"->, "dependencies"->{...}]
```

## Ultrafast seperate channel for individual events
