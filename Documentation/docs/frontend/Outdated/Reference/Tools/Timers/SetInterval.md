---
env:
  - Wolfram Kernel
update: 
source: https://github.com/JerryI/wl-misc/
---
Creates an asynchronous task, which is repeated with a `period` (milliseconds)
```mathematica
task = SetInterval[Print["Hi!"], period_Number];
```

To remove the task, one can use native's Wolfram `TaskRemove`
```mathematica
TaskRemove[task]
```
