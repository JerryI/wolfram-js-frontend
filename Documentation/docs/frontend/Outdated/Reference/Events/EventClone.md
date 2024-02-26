---
env:
  - Wolfram Kernel
update: 
source: https://github.com/JerryI/wl-misc/
---
```mathematica
clone = EventClone[ev_EventObject | _String]
```

clones an instance of `ev` event object passed as [`EventObject`](EventObject.md) or a string with no interfering an original event handler function assigned to `ev`. 

In order to violate the thumb rule #1 
> One event-object - one handler function

you need to clone an event object to be able to assign more than 1 handler function to the event. Please see the full guide [event-generators](../../Advanced/Events%20system/event-generators.md)

## Example
Let us artificially create an event object and clone it
```mathematica
ev = EventObject[<|"id"->CreateUUID[]|>]
(* first handler *)
EventHandler[ev, Print]; 

(* second handler *)
clone = EventClone[ev];
EventHandler[clone, Print];
```

Now we can fire the first one
```mathematica
EventFire[ev, "Hi"];
```

What it does, it converts a simple `EventObject` into something like an event router, which is populated by two new event-objects

```mermaid
flowchart LR

subgraph EventObject
	id=evid
	prop1["props"]
end

subgraph EventRouter
	subgraph List
		id=new1
		id=new2
	end
	prop2["props"]
end

subgraph EventHandler1[EventHandler]
	Print1[Print]
end

subgraph EventHandler2[EventHandler]
	Print2[Print]
end

EventObject --"By id"--> EventRouter

id=new1 --"By id"-->EventHandler1
id=new2 --"By id"-->EventHandler2
```

Anything you do with `clone` will not affect the `ev`

```mathematica
Delete[clone]
```

:::info
Cloned object inherits all properties (i.e. initial data), that the original object has.
:::


