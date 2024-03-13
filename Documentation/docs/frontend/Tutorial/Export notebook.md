---
sidebar_position: 9
---

Since all magic happens inside the browser using plain Javascript, it is extremely easy to export notebook to a standalone [HTML file](../Export/HTML%20file.md) or even [React component](../Export/React%20component.md) to embed it on website (blog).

:::danger
Due to the caching issues, please use __hard reload__ on a webpage, when you open an HTML file. Usually `Shift+Win+R`
:::

:::note
In theory since Wolfram Language interpreter also runs in browser, it is possible to implement sort of compiler to run some lightweight calculations on [WLJS](../../../interpreter/intro.md).
:::

To export you notebook using specific procedure - click on a top bar

<div style={{width: '100%',  margin: 'auto', left: 0, right: 0, display: 'block', background: 'white' }}>

![](../../imgs/Screenshot%202023-06-10%20at%2014.56.41.png)

</div>

`Share` button. Basically this is how cells were embedded into the documentation you are reading right now (see [React component](../Export/React%20component.md)).