---
env:
  - WLJS
update: true
needsContainer: true
source: https://github.com/JerryI/wljs-inputs/
registered: false
---
:::note
This is an internal part of [InputText](InputText.md)
:::

```mathematica
TextView[initial_String, opts___]
```

places a general view-component for text, that can emits events to a Wolfram Kernel if `"Event"` option is provided or react and display the given text

It does serve two functions
- input
- output

for the first one
## Event generation
Every-time user changes the content, an event __in a form of string__ will be generated
```mathematica
"<current string>"
```

## Options
### `"Event"`
Specifies an `uid` of an event-object, that will be fired on-change.

### `"Label"`
adds a label at the left side to the input text field

## Application
### User's input & output
It can be used without WLJS frontend on a web page to act as a slider. For instance using [WLX](../../../../wlx/install.md) 

```mathematica
var = "Hello World!";
uid = CreateUUID[];

EventHandler[uid, Function[d, var = StringReverse[d]]];

InputElement  = TextView[var, "Event"->uid] // WLJS;
Output = TextView[Offload[var]] // WLJS;

<div>
	<InputElement/>
	<Output/>
</div>
```




