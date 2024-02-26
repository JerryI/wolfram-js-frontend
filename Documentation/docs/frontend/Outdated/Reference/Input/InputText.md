---
env:
  - Wolfram Kernel
origin: https://github.com/JerryI/wljs-inputs
---
```mathematica
InputText[initial_String, opts___] _EventObject
```
creates an [event-generator](../../Advanced/Events%20system/event-generators.md) for an input-text field and returns [EventObject](../Events/EventObject.md)

## Event generation
Every-time user changes the content, an event __in a form of string__ will be generated
```mathematica
"<current string>"
```

## Options
### `"Label"`
adds a label at the left side to the input text field

## Example
A simple text input

```mathematica
text = InputText["Hi"]
EventHandler[text, Print];
```

## Dev notes
This is a wrapper for [TextView](TextView.md) view-component
