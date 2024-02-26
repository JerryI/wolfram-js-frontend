---
env:
  - WLJS
---
Global context in Javascript engine, where all functions of [WLJS Interpreter](../../../../interpreter/intro.md) are stored.

To define a new function use

```js
core.MyFunction = async (args, env) => {
	const result = await interpretate(args[0], env);
	alert(result);
}
```

then from the frontend, one can do

```mathematica
MyFunction["Hello!"] // FrontSubmit
```

:::info
Please __see the full guide__ [scripts](../../../../interpreter/Basics/scripts.md)
:::