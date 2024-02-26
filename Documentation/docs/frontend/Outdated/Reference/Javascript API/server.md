---
env:
  - WLJS
---
A global object, that gives an access to sever's API (if server is available). Usually server is Wolfram Kernel connected via WebSockets protocol or HTTP/POST

## Application
### Send expression to WL Kernel
The direct messaging to a master kernel can be done via

```js
server.send('NotebookPrint["`` is the result", 1+1]')
```

or to a secondary kernel (if connected)

```js
server.kernel.socket.send('Print["2 is the result"]')
```

### Emit event
This is used in [event-generators](../../Advanced/Events%20system/event-generators.md) quite widely

*cell 1*
```mathematica
EventHandler["specialId", Function[data, Print[data]]];
```

*cell 2*
```js
.js

server.emitt('specialId', '1+1')
```

### Ask to evaluate something
If you need to evaluate some expression and get the result back use this one

```js
const result = await server.askKernel('1+1')
```

or if you need it from the master (main) kernel

```js
const result = await server.askKernel('1+1')
```