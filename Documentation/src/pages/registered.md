---
title: Registered
---

# Registered

An expression, that requires to be evaluated on WLJS frontend (some graphics usually) inside a container, will automatically be exported to the desired format on output. No extra actions from the user are needed.

## Example
`Graphics`, `Image` and other primitives created as a result of `Plot`, `Rasterize`... are __registered__ in the system. Therefore, each time they appers to be in the output cell, a dedicated frontend object will be created automatically

i.e., when you evaluate this
```mathematica
Graphics[{Point[{0,0}]}]
```

it becomes
```mathematica
Graphics[{Point[{0,0}]}] // CreateFrontEndObject
```
