---
env:
  - Wolfram Kernel
origin: https://github.com/JerryI/wljs-inputs
---
```mathematica
InputButton[label_String] _EventObject
```
creates a button component and returns [EventObject](../Events/EventObject.md).

## Event generation
On-click emits `True` to a handler function assigned



## Application
A basic GUI element

```mathematica
button = InputButton["Click me!"];
EventHandler[button, Print]
```




## Dev note
This is a wrapper over [ButtonView](ButtonView.md)