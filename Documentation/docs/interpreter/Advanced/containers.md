---
sidebar_position: 2
---
# Containers
The __general definition__ will be
> *an environment, where the [defined functions](symbols.md) can be executed*

:::info
All dynamic variables and graphics expressions like `Graphics`, `Graphics3D` has to be executed inside the container (even `Line`, `Point`), since it provides an identifier, local memory to the expression, that was called (for each call). 
:::


*first key feature, why we need containers*
```js
core.MyFunction = async (args, env) => {
	env.local  = {} //pointer to the local memory of the instance
	env.global = {} //pointer to the global memory of the call tree
	env //sharable memory (isolated by Lists)
}
```

Containers help to work with the data more efficiently. For example, if we plot a graph using the data that changes with the time, it order to update the graph __without reevaluation__ one can find an instance of this executed plotting function and provide a new data to it.

### Dynamic binding
*second key feature, why we need containers*
The ideas for WLJS Frontend were inspired by an amazing project [Observable](https://observablehq.com/@jerryi) - JavaScript notebook interface working in the browser, where the dynamics was polished perfectly.

In Observable all expressions are `Dynamic` in terms of Mathematica by the default. Me, as a maintainer (@JerryI) I tried to bring it as close as possible to such behaviour, leaving out lags of Mathematica's frontend and functions overhead as mush as possible.

Therefore, __all user's defined symbols are containers__, __all graphics objects should also be containers__, and all containers are dynamic by default. 

![](../../imgs/FE%20data%20binding.excalidraw%201.svg)

The change in one will cause the updates to ones, which depends on it. This behaviuor is achieved by collecting all calls of front-end functions and storing them to special handlers assigned to each object. In principle we do not even need WL Kernel to update the content, just WLJS interpreter is already enough. 

:::info
Update event propagates only to the first nearest parent
:::

:::info
Update event is fired on the instance on a container, not on the inner expressions. After that the container reevaluates itself with a method `update` applied to all nested expressions
:::

We just scratched a top of the surface, the things you can do with it are quite bigger...
