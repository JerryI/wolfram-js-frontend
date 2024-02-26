---
env:
  - WLJS
---
```mathematica
AttachDOM[id_String]
```
attached a DOM element from the page found by `id` to the container, where this expression is evaluated

```js
core.MyFunction = async (args, env) => {
	env.element //our DOM element
}
```

from any expression placed inside a container the attached DOM element is visible from `env.element`.

:::info
Please see [containers](../../../../../interpreter/Advanced/containers.md) for more information
:::
