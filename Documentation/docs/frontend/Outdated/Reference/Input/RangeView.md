---
env:
  - WLJS
update: false
needsContainer: true
origin: https://github.com/JerryI/wljs-inputs
---
:::note
This is an internal (low-level) part of [InputRange](InputRange.md) 
:::

```mathematica
RangeView[{min_, max_, step_, initial_}, opts___]
```
places a view-component for [InputRange](InputRange.md) slider, that can emit events to a Wolfram Kernel if `"Event"` is provided.

## Event generation
Every-time user drags a slider, an event __in a form of a single number__ will be generated.

## Options
### `"Event"`
Specifies an `uid` of an event-object, that will be fired on-change.

### `"Label"`
A text-label placed on the left side from the slider. It has to be a text-string.

## Application
It can be used without WLJS frontend on a web page to act as a slider. For instance using [WLX](../../../../wlx/install.md) 

```mathematica
var = 0.0;
uid = CreateUUID[];
EventHandler[uid, Function[d, var = d]];
Field  = TextView[Offload[var]] // WLJS;
Slider = RangeView[{0,1,0.1,0}, "Event"->uid] // WLJS;

<div>
	<Field/>
	<Slider/>
</div>
```