---
internal: true
---
An invisible replacement for [FrontEndExecutable](FrontEndExecutable.md), which is not replaced by a widget in the editor and Wolfram Kernel.

## Application
Since [FrontEndExecutable](FrontEndExecutable.md) will be replaced by the underlying expression during the first evaluation, one can use a reference to it to manipulate the data behind

```mathematica
FrontEndRef["uid"] = newData
```

will update all objects with a storage ID `"uid"` on the frontend.