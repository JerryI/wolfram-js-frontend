---
env:
  - Wolfram Kernel
  - WLJS
update: 
needsContainer:
---
A unique identifier or a reference of/to the [container](../../../../interpreter/Advanced/containers.md) 

```mathematica
MetaMarker["string"]
```

Can be used together with [FrontSubmit](FrontSubmit.md), please see the tutorial [meta-markers](../../../../interpreter/Advanced/meta-markers.md) like

*cell 1*
```mathematica
Plot[Sinc[x], {x, -10, 10}, ImageSize->500, Epilog->{MetaMarker["marker"]}]
```

append content to an existing plot

*cell 2*
```mathematica
FrontSubmit[{Pink, Line[{{-5,0}, {5, 0.7}}]}, MetaMarker["marker"]]
```


