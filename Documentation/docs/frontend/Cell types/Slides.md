


One can also make presentations using WLJS Frontend. This is provided by [wljs-revealjs](https://github.com/JerryI/wljs-revealjs), that integrates [RevealJS](https://revealjs.com) and [WLX](WLX.md) language to provide components approach on making presentations as well as add interactivity and all features of frontend's cells like this

<div style={{'text-align':'center'}}>

![](../../imgs/ezgif.com-optimize-15.gif)

</div>

see full demo video [here](https://www.youtube.com/watch?si=IzYInhddG66pNUHp&v=7cEYJG7nk7U&feature=youtu.be).

:::info
Advanced tutorials are available by links [Advanced Slides Using WLX](../Advanced/Slides/intro.md) and [animations](../Advanced/Slides/animations.md) etc.
:::

## Merge slides from different cells
To merge the all slides into a single fat presentation use

```md
.slides

```

It will merge and print slides from all cells in the notebook into a single one.

:::tip
Use projector feature

![](../../Screenshot%202024-03-13%20at%2019.25.16.png)

to show slides in a separate window
:::

## Plugins
The package uses also some external plugins
- [pointer](https://github.com/burnpiro/reveal-pointer) (press `Q` to toggle)
