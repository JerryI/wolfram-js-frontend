---
title: Needs container
---

# Needs container

An expression, that requires to be evaluated on WLJS frontend (some graphics usually) inside a container. 
Normal evaluation on the frontend's side via `FrontSubmit` will not work.

This is a usual case, when an expression __needs DOM element to display or local memory to store data__, which are available only inside containers.

This is also the case, if you need a function to support dynamic updates from the depending variable, that changes. 

## Example
Some of the functions like `Graphics` are registered in the system and will automatically aquire one, however `TextView` is not. Execution inside containers is possible via `CreateFrontEndObject`, for example

*single input cell*
```mathematica
TextView["Working..."] // CreateFrontEndObject
```

or one can give __a virtual container__ using `FrontEndVirtual`


*cell 1*
```mathematica
.html
<div id="cont"></div>
```

*cell 2*
```mathematica
FrontEndVirtual[{AttachDOM["cont"], TextView["Working..."]}] // FrontSubmit;
```