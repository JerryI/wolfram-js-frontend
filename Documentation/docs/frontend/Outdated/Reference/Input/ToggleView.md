---
env:
  - WLJS
origin: https://github.com/JerryI/wljs-inputs
needsContainer: true
---
:::note
This is an internal part of [InputToggle](InputToggle.md)
:::

```mathematica
ToggleView[initial_Boolean, opts___]
```

places a checkbox field, that can emit events to Wolfram Kernel if `"Event"` option is provided to it.

## Event generation
On-click it toggles the state and sends a new one to a handler function assigned.

## Options
### `"Event"`
Specifies an `uid` of an event-object, that will be fired on-change.
### `"Label"`
specifies a text label on the left side from the checkbox

## Application
It can be used without WLJS frontend on a web page to act as a checkbox. For instance using [WLX](../../../../wlx/install.md) 

```mathematica
var = "- none -";
uid = CreateUUID[];
EventHandler[uid, Function[d, var = ToString[d]]];

Field  = TextView[Offload[var]] // WLJS;
CHeckbox = ToggleView[False, "Event"->uid] // WLJS;

<div>
	<Field/>
	<CHeckbox/>
</div>
```


