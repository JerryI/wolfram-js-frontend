---
env:
  - Wolfram Kernel
source: https://github.com/JerryI/wl-misc/
update:
---
:::warning
This is an experimental function. It might be changed or removed in the next updates
:::

```mathematica
Assign[symbol_][ev_EventObject]
```

assigns `symbol` to be updated using data provided by `ev`. It acts as a helper to write less code for such cases

```mathematica
myVar = 0;
range = InputRange[0, 1, 0.1];
EventHandler[range, Function[data, myVar = data]];
range
```

and using the given helper function `Assign` it turns into

```mathematica
myVar = 0;
InputRange[0, 1, 0.1] // Assign[myVar]
```
