---
env:
  - Wolfram Kernel
update: 
source: https://github.com/JerryI/wl-misc/
---
```mathematica
EventFire[ev_EventObject | _String, data_ | Empty]
```

manually fires an event provided as [EventObject](EventObject.md) or a string.

## Example
sometimes it comes handy, when you want to initialize the data
```mathematica
ev = EventObject[<|"id"->"evid", ...|>]
EventFire[ev, 1+1]
```
or with no-data provided
```mathematica
EventFire[ev]
```
or just by using text-string
```mathematica
EventFire["evid"]
```
