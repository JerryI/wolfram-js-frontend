:::danger
Is in development
:::

Since the interpretation of the output cells happens in JS, then we can pack all data into a single `.html` file and easily share it with other people by clicking on the icon

![](../../Screenshot%202024-03-13%20at%2019.37.13.png)

:::warning
Do not forget to save your notebook before exporting! It is important for garbage collecting
:::

## Portability 
Once exported, it can be __unpacked back to a normal notebook__ once opened using WLJS Notebook app.

### Offline computations
:::danger
To be implemented...
:::

It is possible to move the code from Wolfram Kernel onto frontend with some limitations, thus it allows to perform calculations purely on the frontends [WLJS Interpreter](https://github.com/JerryI/wljs-interpreter) with no running Wolfram Engine in the background.

