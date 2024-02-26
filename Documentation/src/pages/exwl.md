---
title: Execution environment WL 
---

# Execution environment: Wolfram Kernel

It means that the function implementation is within or only makes sence to be evaluated on Wolfram Kernel (backend). Such functions like `Plot` or `VectorPlot3D` are higher-order expressions, that produce low-level constructions of `Graphics` primitives, for which it is already possible to display something on the frontend's side (WLJS).