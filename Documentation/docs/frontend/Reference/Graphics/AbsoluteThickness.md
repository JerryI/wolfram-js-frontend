---
env:
  - WLJS
update: false
---
```mathematica
AbsoluteThickness[n_Real]
```

is used to control the visible thickness of lines used in [Graphics](Graphics.md). The displayed is not affected by scaling or zooming the plot. 

## Example
A styled [Line](Line.md) object

```mathematica
Graphics[{
  AbsoluteThickness[3],
  Cyan, 
  Line[{{0,0}, {1,1}}]
}]
```

<Wl data={`WyJHcmFwaGljcyIsWyJMaXN0IixbIkFic29sdXRlVGhpY2tuZXNzIiwzXSxbIlJHQkNvbG9yIiww
LDEsMV0sWyJMaW5lIixbIkxpc3QiLFsiTGlzdCIsMCwwXSxbIkxpc3QiLDEsMV1dXV0sWyJSdWxl
IiwiSW1hZ2VTaXplIiwzNTBdXQ==
`}>{`Graphics[{AbsoluteThickness[3],Cyan, Line[{{0, 0}, {1, 1}}]}, ImageSize->350]`}</Wl>