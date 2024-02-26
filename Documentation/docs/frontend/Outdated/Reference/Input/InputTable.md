---
env:
  - Wolfram Kernel
origin: https://github.com/JerryI/wljs-inputs
---
```mathematica
InputTable[list_List, opts___]
```
it places a sort of small Excel-like table editor for `list` provided. This is a great solution for a large tables, since it does support lazy loading from a server

:::warning
`list` has to be a 2D list of numbers
:::

## Event generation
Every-time user changes the cell's data, the events comes as transactions in a form of

```mathematica
{"Typeof", row, col, oldData, newData}
```

try this example

```mathematica
list = Table[i j, {i,5}, {j,5}];
EventHandler[InputTable[list], Print]
```

### Transaction helper
if you don't want to mess with them, there is a helper function `InputTable~EventHelper`, that updates the list using those transitions

```mathematica
InputTable`EventHelper[list_List] _Function
```

It will mutate the given symbol `list` according to the transactions. One has to initialize it on the corresponding list and use the resulting generated symbol in your [EventHandler](../Events/EventHandler.md) function like in the example below

```mathematica
list = Table[i j, {i,5}, {j,5}];
handler = InputTable`EventHelper[list];
textstr = "";
EventHandler[InputTable[list, "Height"->150], Function[data, 
  handler[data];
  textstr = ToString[list // MatrixForm, StandardForm];
]]

EditorView[textstr // Offload] // CreateFrontEndObject
```

the result should look like this

![](../../../../imgs/ezgif.com-optimize-7-2%201.gif)

:::tip
If you want to __just view__ your data, do not apply `EventHandler` 

```mathematica
list = Table[i j, {i,5}, {j,5}];
InputTable[list]
```

your symbol `list` will not be affected. 
:::

## Options
### `"Height"`
specifies the max-height of the table widget. The default value is `400` px.

:::tip
If you have a large list of rows, project the cell to a new window with a bigger `"Height"`
value. It will bring similar experience to Excel-like programs. 
:::

## Dev notes
A [handsontable](https://handsontable.com) engine is used as the cells manager. 