---
title: Execution environment WLJS 
---

# Execution environment: WLJS

It means that the function implementation is within or only makes sence on WLJS Interpreter (Javascript  engine running in your browser with WL framework). It is true for most graphics primitives, since Wolfram Kernel cannot draw anything, because it works as a backend only.

However some expessions are implemented on both sides.

:::note
WLJS expressions are also valid outside the Wolfram Language ecosystem. One can use WLJS interpreter on your website or a blog or inside a banner to animate SVG graphics, since it is just a standalone collection of Javascript libraries.
:::

The simpples way to execute them from the notebook is

```mathematica
FrontSubmit[Alert["Hi!"]]
```

where `Alert` is WLJS only function. However, if it does require a container (a DOM element to display / local memory), then use

```mathematica
TextView["Hi!"] // CreateFrontEndObject
```

where `TextView` is this kind of function. Or if a function is registered to have one, then the container will be created automatically, i.e. for instance - `Graphics` (this is seamless)

```mathematica
Graphics[Point[{0,0}]] 
```