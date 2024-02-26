---
env:
  - WLJS
update: false
---
Returns a clipboard data of a user as a string
```mathematica
ReadClipboard[]
```

## Example
### Simples way
This is pure WLJS function, of you want to access it from the frontend, there is one of the options to use [`FrontSubmit`](../../Dynamics/FrontSubmit.md)

```mathematica
ReadClipboard[] // Alert // FrontSubmit
```

The content of the clipboard will pop up in a window called by [Alert](Alert.md)

:::note
The data will not be transferred to Wolfram Kernel
:::
### Get the data to WL Kernel
You might use [TalkKernel](TalkKernel.md) that allows to transfer data back to the WL Kernel

```mathematica
TalkKernel[ReadClipboard[], "Print"] // FrontSubmit
```

It will call a standard `Print` function on WL Side. Instead of a `Print` you can use your own handler function.

Or use [event-generators](../../../Advanced/Events%20system/event-generators.md) system to perform data transferring as well. For that

```mathematica
EventHandler["uid", Print];
EmittKernel[ReadClipboard[], "uid"] // FrontSubmit
```

### Print the content to a new cell
Consider this example

```mathematica
textHandler[str_] := CellPrint[str];

EventHandler[InputButton["Read selected text"], Function[Null, 
  TalkKernel[Global`ReadClipboard[], "textHandler"] // FrontSubmit
]]
```