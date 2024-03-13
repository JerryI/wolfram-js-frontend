---
env:
  - WLJS
  - Wolfram Kernel
update: true
internal: true
---
An replacement [decoration](../../../Development/Decorations.md) and a reference to the frontend object aka  [container](../../../../../interpreter/Advanced/containers.md) in the shared objects storage with a corresponding id

```mathematica
FrontEndExecutable["uid"]
```

:::danger
It will not be seen in this form in the cell's editor, since this is a [decoration](../../../Development/Decorations.md) created by [CreateFrontEndObject](../CreateFrontEndObject.md) expression.
:::

It is used as a compact representation for the most graphics and other interactive objects.

See more about it in __[Decorations](../../../Development/Decorations.md) and [Executables](../../../Advanced/Frontend%20interpretation/executables.md)__