---
env:
  - WLJS
---
```mathematica
WindowScope[name_String]
```

returns Javascript object `name` defined in the global context.
This comes handy, when you want to use effectively the data processing on JS's site and WLJS Interpreter.

See more @ [JS Integration](../../../../../interpreter/Basics/js-access.md)