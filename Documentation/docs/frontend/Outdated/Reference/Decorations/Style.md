---
env:
  - Wolfram Kernel
update: 
origin: https://github.com/JerryI/wljs-editor/tree/main
needsContainer:
---


Styling box used as a decoration for an arbitrary Wolfram Expressions

```mathematica
Style[expr_, opts__]
```

The argument `opts` contains directives for the formatted output. The following options are supported
- `Background->RGBColor[...]` adds background to the wrapped expression

:::warning
Styling options are currently quite limited
:::
## Example

