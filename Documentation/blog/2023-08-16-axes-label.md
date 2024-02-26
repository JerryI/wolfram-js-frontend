---
slug: axes-label
title: Axes label and partial LaTeX support
authors: jerryi
tags: [frontend, graphics]
enableComments: true
---






Finally `Text` was implemented in [wljs-graphics-d3](https://github.com/JerryI/wljs-graphics-d3) package!



<!--truncate-->

`Text[text, pos]`, where both of them `text` and `pos` __support dynamic updates__. One can stylize it using traditional `Style` wrapper and specify `FrontSize`, `FontFamily` as well.

Supported options for graphics 

- `Axes`
- `AxesLabel`
- `FrameLabel`
- `Frame`
- `Ticks`
- `FrameTicks`
- `TicksLength`
- `TicksDirection`

None of them supports dynamic update for now ;)

Also now one can use LaTeX form for greek symbols and for sub- superscripts in the text labels or inside `Text` element like this

```mathematica
AxesLabel -> {"wavenumber (cm^{-1})", "\\alpha (cm^{-1}) "}
```

Thanks for reading!