---
env:
  - Wolfram Kernel
origin: https://github.com/JerryI/wljs-inputs
---

```mathematica
InputToggle[initial_Boolean, opts___] _EventObject
```
creates a toggle (checkbox) component and returns [EventObject](../Events/EventObject.md).

## Event generation
On-click it toggles the state and sends a new one to a handler function assigned.

## Options
### `"Label"`
specifies a text label on the left side from the checkbox

## Application
A basic GUI element

```mathematica
toggle = InputToggle[True];
EventHandler[toggle, Print]
```

## Dev note
This is a wrapper over [ToggleView](ToggleView.md)
