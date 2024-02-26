---
env:
  - Wolfram Kernel
---
Prevents decorations to be set
```mathematica
InputForm[expr_]
```

Typical example to reveal the `InputForm`

```mathematica
Red
Red // InputForm
```