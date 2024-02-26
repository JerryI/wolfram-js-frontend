---
env:
  - WLJS
update: false
needsContainer: false
---
```mathematica
FrontEditorSelected["Get"]
```
returns the selected line from the input/output cell's of the last focused editor as a string.

```mathematica
FrontEditorSelected["Set", content_String]
```
replaces or inserts `content` into the last focused editor

## Application

### Insert a text by clicking button
Try to evaluate this code

```mathematica
EventHandler[InputButton["Replace selected text"], Function[Null, 
  FrontEditorSelected["Set", "Yo"] // FrontSubmit;
]]
```

and then select the text in some other cell or just drop a cursor once.

### Reading selected
This is a bit more complicated, since it involves communication back to the Wolfram Kernel

```mathematica
textHandler[str_] := CellPrint[str];

EventHandler[InputButton["Read selected text"], Function[Null, 
  TalkKernel[FrontEditorSelected["Get"], "textHandler"] // FrontSubmit
]]
```

:::tip
To transfer the data back to the Wolfram Kernel from the browser (WLJS Interpreter), use [TalkKernel](TalkKernel.md).

The data sent will be a JSON object, since this is an internal representation of any WL expression on [WLJS Interpreter](../../../../../interpreter/intro.md)
:::

Then try to select anything and press a button.
