---
env:
  - WLJS
update: 
source: https://github.com/JerryI/wljs-graphics-d3/
---
Allows to directly set SVG attribute to a 2D graphics object
```mathematica
SVGAttribute[object_, "name"->"value"]
```

__Please see the SVG__ [docs](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute) for all possible attributes. In principle it should work with most 2D primitives, since all of them are SVG elements.
## Example
If we want a dashed line

```mathematica
Graphics[
	SVGAttribute[
		Line[{{-1,-1}, {1,1}}]
	, "stroke-dasharray"->"3"]
]
```

<Wl data={`WyJHcmFwaGljcyIsWyJTVkdBdHRyaWJ1dGUiLFsiTGluZSIsWyJMaXN0IixbIkxpc3QiLC0xLC0x
XSxbIkxpc3QiLDEsMV1dXSxbIlJ1bGUiLCInc3Ryb2tlLWRhc2hhcnJheSciLCInMyciXV0sWyJS
dWxlIiwiSW1hZ2VTaXplIiw1MDBdXQ==
`}>{`Graphics[SVGAttribute[Line[{{-1,-1}, {1,1}}], "stroke-dasharray"->"3"], ImageSize->500]`}</Wl>

