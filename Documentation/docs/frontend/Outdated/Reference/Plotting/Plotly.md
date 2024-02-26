---
env:
  - Wolfram Kernel
registered: true
update: 
origin: https://github.com/JerryI/wljs-plotly
---
An alternative plotting function to [Plot](Plot.md) that uses Plotly.js
```mathematica
Plotly[expr_, {variable, min, max, step}]
```

It mimics the syntax of `Plot` and provides legend, pan/zoom features out of the box. Despite this convenience it does not rely on [Graphics](../Graphics/Graphics.md) functionality, therefore is hard to customize.

```mathematica
Plotly[Evaluate[Table[BesselJ[n, x], {n, 4}]], {x, 0, 10}]
```

<Wl data={`WyJMaXN0TGluZVBsb3RseSIsWyJMaXN0Il1d
`}>{`Plotly[Evaluate[Table[BesselJ[n, x], {n, 4}]], {x, 0, 10}]`}</Wl>

:::danger
This is still in development and has __no options for styling__
:::

## Dev notes
This is a wrapper of `Plot`, that translates kinda in hacky way the result to [`ListLinePlotly`](ListLinePlotly.md). Which is __the only high-order plotting function__ that support dynamic updates out of the box.

Credits for this adaptation to [@userrand](https://github.com/userrand)
