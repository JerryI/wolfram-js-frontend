---
env:
  - Wolfram Kernel
origin: https://github.com/JerryI/wljs-inputs
---
```mathematica
InputRange[min_, max_, step_:1, initial_:(min+max)/2, opts___] _EventObject
```
creates a basic combo of a slider and numerical input field and returns [EventObject](../Events/EventObject.md).

## Event generation
Every-time user drags a slider, an event __in a form of number__ will be generated
```mathematica
slider = InputRange[0,1,0.1];
EventHandler[slider, Function[data,
	Print[StringTemplate["`` is a number"][data]]
]];
slider
```




## Options
### `"Label"`
Adds a label to a slider

```mathematica
slider = InputRange[0, 1, 0.1, "Label"->"Slider"]
```



## Applications
Control properties using knob

```mathematica
EventHandler[InputRange[0,1,0.1], Function[data, pos = data]];
% 
% // EventFire;
Graphics[Rectangle[{-1,0}, {1, Offload[pos]}]]
```



## Dev notes
This is a wrapper over a more fundamental view-component [`RangeView`](RangeView.md)