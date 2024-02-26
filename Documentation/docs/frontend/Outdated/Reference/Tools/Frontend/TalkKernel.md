---
env:
  - WLJS
---
```mathematica
TalkKernel[object_, handler_String]
```

exports an arbitrary `object` from the frontend to Wolfram Kernel as JSON string and applies `handler` function to it.

```mathematica
TalkKernel[1+1, "Print"] // FrontSubmit
```

will evaluate `1+1` on WLJS Interpreter and will send back the result to a `Print` function evaluated on Wolfram Kernel