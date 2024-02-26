---
env:
  - Wolfram Kernel
origin: https://github.com/JerryI/wljs-inputs
update: false
---
```mathematica
InputGroup[events_List | _Association] _EventObject
```
groups different [event-generators](../../Advanced/Events%20system/event-generators.md) such as [InputRange](InputRange.md), [InputButton](InputButton.md) or in general [EventObject](../Events/EventObject.md) into a new `EventObject`

:::info
Please consider to read the full guide [event-generators](../../Advanced/Events%20system/event-generators.md)
:::

## Event generation
Every-time user acts on an inner event-view from a group `events`, it will fire an event and send the data from all event objects keeping the original structure

### Association
```mathematica
group = InputGroup[<|
  "left"->InputRange[0, 10, 1, "Label"->"Range 1"],
  "right"->InputRange[0, 10, 1, "Label"->"Range 2"] 
|>]
EventHandler[group, Print];
```

On each update it generates the data for the handler function in a form
```mathematica
<|"left"->5, "right"->7|>
```

### Arrays
```mathematica
group = InputGroup[{
  InputRange[0, 10, 1, "Label"->"Range 1"],
  InputRange[0, 10, 1, "Label"->"Range 2"],
  InputText["Hi"]
}]
EventHandler[group, Print];
```

the data provided to a handler function `Print` will look like
```mathematica
{5, 7, "Hi"}
```

