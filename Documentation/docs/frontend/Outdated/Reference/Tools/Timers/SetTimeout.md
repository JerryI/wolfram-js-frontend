---
env:
  - Wolfram Kernel
update: 
source: https://github.com/JerryI/wl-misc/
---
Creates an asynchronous task, which will be executed once after `period` (milliseconds)
```mathematica
task = SetTimeout[Print["Timeout!"], period_Number];
```

To remove the task, one can use native's Wolfram `TaskRemove`
```mathematica
TaskRemove[task]
```
