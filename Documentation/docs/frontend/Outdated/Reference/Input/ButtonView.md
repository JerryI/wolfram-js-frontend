---
env:
  - WLJS
origin: https://github.com/JerryI/wljs-inputs
update: false
needsContainer: true
---
:::note
This is an internal part of [InputButton](InputButton.md)
:::

```mathematica
ButtonView[label_String, opts___]
```
places a view-component for [InputButton](InputButton.md), that can emits events to a Wolfram Kernel if `"Event"` option is provided.

## Event generation
On-click emits `True` to a handler function assigned

## Options
### `"Event"`
Specifies an `uid` of an event-object, that will be fired on-change.

## Application
It can be used without WLJS frontend on a web page. For instance using [WLX](../../../../wlx/install.md) (another [link](https://jerryi.github.io/wljs-docs/wlx/))

```mathematica
text     = "nothing";
secret   = CreateUUID[];
View     = TextView[Offload[text]] // WLJS;
Button   = ButtonView["Press me", "Event"->secret] // WLJS; 

EventHandler[secret, Function[void, text = RandomWord[]]];

<div>
    <View/>
    <Button/>
</div>
```

