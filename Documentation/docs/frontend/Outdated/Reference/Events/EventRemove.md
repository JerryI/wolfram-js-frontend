---
env:
  - Wolfram Kernel
update: 
source: https://github.com/JerryI/wl-misc/
---
```mathematica
EventRemove[ev_EventObject | String]
```

removes a handler function from event object `ev` previously assigned using [EventHandler](EventHandler.md) expression. Native Wolfram Language `Delete` also works 

```mathematica
Delete[ev_EventObject]
```

:::note
It does not affect the object itself, since [EventObject](EventObject.md) is not stored anywhere
:::





