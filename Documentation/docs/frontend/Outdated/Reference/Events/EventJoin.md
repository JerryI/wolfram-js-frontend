---
env:
  - Wolfram Kernel
update: 
source: https://github.com/JerryI/wl-misc/
---
```mathematica
joined = EventJoin[ev1_EventObject | _String, ev2_, ...]
```

joins two or more events passed as [EventObject](EventObject.md)s or strings into a new `joined` event object. For `EventObject`s a standard Wolfram Language expression `Join` works as well

```mathematica
joined = Join[ev1_EventObject, ev2_EventObject, ...]
```

::note
Please, see the full guide on events [event-generators](../../Advanced/Events%20system/event-generators.md)
:::

:::info
It does not affect previously assigned handling functions via [EventHandler](EventHandler.md) and always [clones](EventClone.md) the original event objects (no matter how they were provided as a string or as an object)
:::
## Application
For example you want to update the state of something based on two events, that may happen independently, then

```mathematica
ev1 = EventObject[<|"id"->"evid1"|>]
ev2 = EventObject[<|"id"->"evid2"|>]

joined = Join[ev1, ev2]
```

:::tip
You do not have to clone your events before joining them, since it does it automatically keeping all other connections intact
:::

```mermaid
flowchart LR

subgraph EventObject1[EventObject]
	id=evid1
	prop1["props1"]
end

subgraph EventObject2[EventObject]
	id=evid2
	prop2["props2"]
end

subgraph EventRouter
end

subgraph EventObject3[EventObject]
	id=new
	prop3["merged props"]
end

EventObject1 --> EventRouter
EventObject2 --> EventRouter

EventRouter --Fire--> EventObject3
```
## Properties
There is a simple association wrapped inside `EventObject`. By its nature this is not a classical object in the sense of OOP, since the handler function has no access to the their properties and only `id`  field is stored in a global memory. 
### Inheritable
There is a property `"initial"`, that specifies the initial value of the data shipped when the event is fired, when you apply `Join` or `EventClone` the final initial conditions will be merged from the different event objects or just copied

```mathematica
ev1 = EventObject[<|"id"->"ev1", "initial"-><|"x"->1|>|>]
ev2 = EventObject[<|"id"->"ev1", "initial"-><|"y"->2|>|>]

Join[ev1, ev2]
```

the result will be

```mathematica
EventObject[<|"id"->"random", "initial"-><|"x"->1, "y"->2|>|>]
```
### Non-inheritable
A very useful property, that comes handy when making GUI elements `"view"`

```mathematica
EventObject[<|"id"->"evid", "view"->Graphics3D[Sphere[]]|>]
```

it acts only when the object is printed to the output cell
