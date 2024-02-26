---
env:
  - Wolfram Kernel
update: 
source: https://github.com/JerryI/wl-misc/
---
```mathematica
EventObject[a_Association]
```

a local representation of event entity used in [Dynamics](../../Tutorial/Dynamics.md),  [Input elements](../../Tutorial/Input%20elements.md) and [event-generators](../../Advanced/Events%20system/event-generators.md). It does provide extra feature to an event system such as listed below

:::info
The object itself does not have a constructor or destructor in terms of OOP and is not stored anywhere else, expect the expression you are working with.

__It is not mandatory to use `EventObject` construction__ to attach event handling function to it and fire an event. A user can also use plain strings. __Please see__ complete guide [event-generators](../../Advanced/Events%20system/event-generators.md) and [EventHandler](EventHandler.md) pages
:::

Usually you do not face them directly, but as a product of generators such as [`InputRange`](../Input/InputRange.md), [`InputButton`](../Input/InputButton.md) and etc.
## Properties
Each property is presented as a key in `a` association

### `id` (mandatory)
A unique identified used by a [EventHandler](EventHandler.md) to assign a handler to this event globally. If you do not want to utilize other properties other that this, please, use a plain string instead.

### `initial`
Property that contains all initial data provided by [Input elements](../../Tutorial/Input%20elements.md) for instance. It can be an atom, a list or an association. The last two are joined, when [EventJoin](EventJoin.md) is applied.

### `view`
A placeholder, which is displayed in the output cell. The value `view` will be passed to [CreateFrontEndObject](../Dynamics/CreateFrontEndObject.md) expression on output automatically.

:::warning
Once it transformed into [FrontEndExecutable](../Dynamics/Internals/FrontEndExecutable.md), the expression loses its original form of `EventObject` and cannot be used as an event entity anymore.
:::

## Methods
An event entity (represented by `EventObject` or a plain string) can be cloned, destroyed (actually only event handling function will be detached) or joined

- [`EventClone`](EventClone.md)
- [`EventJoin`](EventJoin.md)
- `Join`
- [`EventRemove`](EventRemove.md)
- `Delete`
- [`EventHandler`](EventHandler.md)

## Dev notes
The actual event entity identified by `id` key in the association is only thing, which is stored globally, once you assign a handling function kinda like this

```mathematica
EventHandler[EventObject[a_Association], handler] := EmittedEvent[a["id"]] = handler
```

Once event was fired by `id` it simply evaluates

```mathematica
EmittedEvent[id][data]
```

from the connected client via websockets, or internally using [EventFire](EventFire.md).

There is no practical case found so far, where you to store an entire `EventObject` somewhere.
