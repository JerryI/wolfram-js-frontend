
## `LeakyModule`
*a `Module` that cause memory leaks on purpose*

A variation of `Module`, which comes with its own garbage collector, that prevents symbols from being purged by WL 

```mathematica
LeakyModule[symbols_List, expr_, opts___] _
```
The only difference compared to traditional module-function is an optional argument
- `"Garbage" :> _List` a held symbol, that points to a list.

Then a user can manually purge them.

