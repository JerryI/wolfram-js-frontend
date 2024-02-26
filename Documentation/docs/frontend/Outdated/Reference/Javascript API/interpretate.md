---
env:
  - WLJS
---
An access to [WLJS Interpreter](../../../../interpreter/intro.md), that can evaluate arbitrary Wolfram Expressions `expr` in a form of `ExpressionJSON`  and providing `env` object to all nested expressions  

```js
async interpretate(expr, env)
```

an example

```js
const result = await interpretate(['Plus',1,1], {});
alert(result);
```

:::info
Please __see the full guide__ [scripts](../../../../interpreter/Basics/scripts.md)
:::