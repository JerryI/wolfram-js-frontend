---
sidebar_position: 7
draft: true
---





From the first sight, it feels similar, however there are some key difference compared to the way how you work with Mathematica's frontend and WLJS.

:::caution
Not even 20% of the functions of Mathematica's frontend were implemented. It is not possible in general due to obvious reasons (paid software, a large team and many years of development process). However, there is no aim to do that. WLJS is a modular system.
:::

## UI & Cells operation
Mathematica is a desktop application (QT-like native built), while WLJS Frontend __is a web-based__ since it runs a web-server to which you connect using any modern browser or special client's app.

WLJS Frontend __is decoupled from the computing (secondary) Wolfram Kernel__. Whatever happens to the secondary Kernel, __it will not lead to the data loss or crash__.

Cell's __structure is flat__ and only groups a list of cells into pairs *input* + *n-output*, while in Mathematica Notebooks it is fully nested.

## Mathematical input
The goal is to make it as close as possible to Mathematica. Most functions are recreated and shortcuts are preserved


<div style={{ width: '50%', float: 'left', clear: 'left' }}>

![](../../imgs/Screenshot%202023-07-06%20at%2018.00.15.png)

</div>

<div style={{ width: '50%', float: 'right', clear: 'right' }}>



</div>

There are less complexity involved in an expression representation compared to Mathematica (see more @ [Expressions representation](Outdated/Expressions%20representation.md)).

:::warning
Navigation between mathematical expressions is currently in development. It does require a mouse pointer to move the cursor inside the inner blocks.
:::

## Input elements
`Slider` and most Mathematica's input elements are replaced with [wljs-inputs](https://github.com/JerryI/wljs-inputs) and event-based approach. Please see [Dynamics](Outdated/Tutorial/Dynamics.md) and [event-generators](Outdated/Advanced/Events%20system/event-generators.md) for more information.
## Greek symbols and etc
Use commands `ESC` + `a` (for $\alpha$ symbol)  and pick up a macro from the autocomplete menu.

## Boxes
Some of the boxes are implemented, so you can enjoy syntax sugar of Mathematica.

## Dynamics
There is such thing as `Dynamic` and `DynamicModule` in WLJS Frontend compared to Mathematica. The dynamic binding happens between a specific expressions (__if they support__) and does not cause a full reevaluation - see [Dynamics](Outdated/Tutorial/Dynamics.md).

It has some its own pros and cons
- `Plot`, `ListLintPlot` __cannot be used directly in dynamic evaluation__, instead [Line](Outdated/Reference/Graphics/Line.md) and other primitives combined with [Offload](Outdated/Reference/Dynamics/Offload.md) must be used. Or one can take advantage of modularity and use [ListLinePlotly](Outdated/Reference/Plotting/ListLinePlotly.md) from the completely different library, that natively supports dynamic updates;
- in general `Line`, `Point` perform faster than in Mathematica;
- dedicated `update` methods for each function gives to a user more flexibility to tune the performance;
- having event-based approach for sliders and other interactive elements allows to construct more complicated pipelines and handle the data efficiently


