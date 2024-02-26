---
title: Support updates
---

# Support updates

One of more of the arguments provided to the expression has an update method implemented, that allows to dynamically update the controllable parameters without reevaluation.

## Example
Expression `Point` supports dynamic updates, therefore
```mathematica
p = {0,0};
Graphics[{
    PointSize[0.05], Cyan,
    Point[p // Offload]
}]
task = SetInterval[p = RandomReal[{-1,1}, 2];, 300];
SetTimeout[TaskRemove[task], 5000];
```

<Wl data={`WyJIb2xkIixbIldpdGgiLFsiTGlzdCJdLFsiQ29tcG91bmRFeHByZXNzaW9uIixbIlN0YXRpYyIs
WyJTZXQiLCJ2cCIsWyJMaXN0IiwwLDBdXV0sWyJHcmFwaGljcyIsWyJMaXN0IixbIlBvaW50U2l6
ZSIsNS4wZS0yXSxbIlJHQkNvbG9yIiwxLDAuNSwwLjddLFsiUG9pbnQiLCJ2cCJdXV0sWyJTZXQi
LCJpcCIsMF0sWyJXaGlsZSIsWyJMZXNzIiwiaXAiLDQwXSxbIkNvbXBvdW5kRXhwcmVzc2lvbiIs
WyJQYXVzZSIsMC4zXSxbIlNldCIsInZwIixbIlJhbmRvbVJlYWwiLFsiTGlzdCIsLTEsMV0sMl1d
LFsiU2V0IiwiaXAiLFsiUGx1cyIsImlwIiwxXV0sbnVsbF1dXV1d
`}>{`With[{}, Static[vp = {0,0}]; Graphics[{PointSize[0.05], RGBColor[1,0.5,0.7], Point[vp]}]; ip=0; While[ip<40, Pause[0.3]; vp = RandomReal[{-1,1}, 2]; ip=ip+1; ] ] // Hold`}</Wl>


`p` variable can be changed outside the cell and but can still influence the position of a cyan point.
