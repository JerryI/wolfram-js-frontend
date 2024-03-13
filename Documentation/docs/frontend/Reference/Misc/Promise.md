```mathematica
<<JerryI`Misc`Events`Promise`
```

## `Promise`
A constructor and also representation of [`EventObject`](Reference/Misc/Events.md#`EventObject`) which __can be fired only once__ (aka resolved) and even before a corresponding handler is attached

```mathematica
Promise[] _Promise (* constructor *)
```

To resolve or reject a promise - use [`EventFire`](Reference/Misc/Events.md#`EventFire`)

```mathematica
EventFire[p_Promise, Resolve | Reject, data_]
```

## `Then`
An expression for asynchronous subscribing to promise resolution or rejection

```mathematica
Then[p_Promise | _List | _, resolve_]
Then[p_Promise | _List | _, resolve_, reject_]
```

where `resolve` and `reject` are any arbitrary functions. This is __non-blocking__ function.

:::info
The key difference between [`EventHandler`](Reference/Misc/Events.md#`EventHandler`) and [`Then`](#`Then`) is that [`Then`](#`Then`) __can even be applied to already resolved__ `Promise` object (after it was fired), which will cause an immediate evaluation of `resolve` or `reject` functions. 
:::

Being applied to a `List` of `_Promise` objects it will wait until all of them are resolved before evaluating `resolve` function.

Any Wolfram Expressions, which is not a `List` or `Promise` __counts as resolved__.

### Example
Let's try with a multiple promise events

```mathematica
p1 = Promise[];
p2 = Promise[];

SetTimeout[EventFire[p1, Resolve, Null], 1000];
SetTimeout[EventFire[p2, Resolve, Null], 1500];

Then[{p1,p2,Null}, Function[Null,
	Echo["Resolved!"];
]];
```

Here `Null` as a last element of a list was used just for demonstration purposes. It can also be any non `_Promise | _List` expression.

## `WaitAll`
A __synchronous blocking function__ to wait until a promise has resolved and returns the result

```mathematica
WaitAll[p_Promise] _
```

There is __a timeout of 5 seconds__, then `$Failed` is returned.

:::caution
Be careful while using this. Avoid to use in `SessionSubmit`, `BackgroundTask` and other interrupting the main loop subroutines. If your promise resolution does depend on TCP socket message, it will never be resolved properly, since all subroutines blocks TCP sockets and other external services.
:::
