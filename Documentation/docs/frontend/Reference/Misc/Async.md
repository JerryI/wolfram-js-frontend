
## `SetTimeout`
Spawns an asynchronous task (a wrapper over `SchelduleTask`), that evaluates an expression once
```mathematica
SetTimeout[expr_, interval_Real] _TaskObject
```
A symbol has `HoldFirst` attribute. An `interval` is in __milliseconds__. To cancel it, use
```mathematica
CancelTimeout[_TaskObject]
```


## `SetInterval`
Spawns an asynchronous task (a wrapper over `SchelduleTask`), that evaluates an expression every `interval` __milliseconds__
```mathematica
SetInterval[expr_, interval_Real] _TaskObject
```
A symbol has `HoldFirst` attribute. To cancel this task use

```mathematica
TaskRemove[_TaskObject]
```
or

```mathematica
CancelInterval[_TaskObject]
```


