---
slug: projector-intro
title: Introducing Projector! Output to a separate window
authors: jerryi
tags:
  - frontend
enableComments: true
draft: false
---
I was always wondering on how to replicate the experience from the massive software like *Origin Lab*, *Igor64*, which has more traditional way of working with data - using windows.  Being limited to a cell in the notebooks is a big limitation, well...

![](Screenshot%202023-08-29%20at%2012.58.20.png)

<!--truncate-->

On the above figure is my typical workspace. Looks messy, however being a theoretician I need to monitor multiple parameters of a model. Sliders are not really well sorted and in overall it looks messy, but it can be improved by a bit of a magic of CSS, which is available in `.html` cells. 

The trick is
![](Screenshot%202023-09-11%20at%2018.40.52.png)

when you click on the icon of windows it evaluates the input cell and outputs its content to a new window, which is associated with the current notebook. It uses all features of the frontend engine, therefore you can use dynamics as if nothing was changed.

:::warning
Before reevaluating a cell, you need to close a window. Hot reload is not supported for now
:::

Or if you are demonstrating a presentation using [wljs-revealjs](https://github.com/JerryI/wljs-revealjs/) plugin, this is the only use-case scenario for the projector feature.

But on this topic I will make a separate post.
