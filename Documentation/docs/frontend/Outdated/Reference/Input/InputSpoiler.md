---
env:
  - Wolfram Kernel
origin: https://github.com/JerryI/wljs-inputs
---
```mathematica
InputSpoiler[ev_EventObject, opts___] _EventObject
```

hides an input element to a spoiler. It does not affect an event object, but changes `view` of [EventObject](../Events/EventObject.md)

## Options
### `"Label"`
specifies the label for the spoiler

