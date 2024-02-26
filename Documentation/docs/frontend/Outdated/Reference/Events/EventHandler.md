---
env:
  - Wolfram Kernel
source: https://github.com/JerryI/wl-misc/
update:
---
```mathematica
EventHandler[ev_EventObject | _String, handler_Function]
```

assigns an `handler` function to an event object provided as a string or [EventObject](EventObject.md). The secondary functionality is 

```mathematica
EventHandler[expr_, handlers_List]
```

to wrap an [EventListener](../Graphics/Internal/EventListener.md) or  [EventListener](../Graphics3D/EventListener.md) over an arbitrary expression and attach listeners listed in `handlers` list if an `expr` supports it.

:::warning
It does look similar to what you have in Wolfram Mathematica, but built entirely in a different way. There is no backward compatibility possible.
:::

:::info
When an event is fired it bypasses the master kernel and goes directly to your evaluating (secondary) Kernel using a dedicated WebSockets channel for the sake of performance
:::

__Please see the full guide__ on it [event-generators](../../Advanced/Events%20system/event-generators.md)
## Examples
### Attaching a handler to an arbitrary event
This is somewhat like a bread and a butter of `EventHandler`
```mathematica
button = InputButton["Pressed"];
EventHandler[button, Print];
button
```

where `button` is an [EventObject](EventObject.md). If you click on a button it will print a text.

Or one can do it using just a string
```mathematica
ButtonView["Press", "Event"->"myid"] // CreateFrontEndObject
EventHandler["myid", Print];
```

### Attaching listeners to a graphics object
Not all of expressions support listeners, but `Graphics3D` and `Graphics` do, please see their [EventListener](../Graphics3D/EventListener.md), [EventListener](../Graphics/Internal/EventListener.md)

```mathematica
p = {0,0};
Graphics[{
	White,
	EventHandler[
		Rectangle[{-2,2}, {2,-2}],
		{"mousemove"->Function[xy, p = xy]}
	],
	PointSize[0.05], Cyan,
	Point[p // Offload]
}]
```

In this example a cyan dot will follow your cursor, since there is a function attached to `mousemove` property. 

### Listening an event of an output cell
It comes handy, when you, for instance, [cloned](EventClone.md) events and need to purge the handlers before each reevaluation. There is an access to any output cell via [EvaluationCell](../Tools/Notebook/EvaluationCell.md)

```mathematica
EvaluationCell[]
```

Then, one can assign any expression to it
```mathematica
EventHandler[EvaluationCell[], {"destroy"->Print, "evaluation"->Print}];
```

One should not that those event are assigned to __the output cell__ generated after the evaluation. Therefore mostly useful will be to use `"destroy"`, while `"evaluation"` is called only if one tries to evaluate the output cell as an input cell.