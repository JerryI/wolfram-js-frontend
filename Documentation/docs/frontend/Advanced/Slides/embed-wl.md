---
sidebar_position: 3
---

# Code highlighting

Since it support WLX syntax as well, one can combine the copied text from the normal Wolfram Language cell into a [EditorView](../../Reference/Inputs/EditorView.md) component

*prototype*
```jsx
.wlx
CodeInset[str_String] := With[{Fe = EditorView[str] // CreateFrontEndObject},
  <div style="text-align: left;"><Fe/></div>
]
```

Then somewhere on your slide
```md
.slide

# Input cell inside a slide

<CodeInset>
(*SbB[*)Subscript[B(*|*),(*|*)k_, q_](*]SbB*)[coords_] := Sum[ 
  
  With[{\\[Theta] = ToSphericalCoordinates[c][[2]], \\[Phi] = ToSphericalCoordinates[c][[3]]},
    (*SpB[*)Power[(-1)(*|*),(*|*)q](*]SpB*) (*SbB[*)Subscript[a(*|*),(*|*)k](*]SbB*)[Norm[c]] (*SqB[*)Sqrt[(*FB[*)((4Pi)(*,*)/(*,*)(2k + 1))(*]FB*)](*]SqB*) SphericalHarmonicY[k,-q, \\[Theta], \\[Phi]]
  ]
  
, {c, coords}]
</CodeInset>

```

:::info
There is no need in writing `(*funny comments*)` and etc. manually, this is a representation of cell's elements (Boxes) from a normal WL editor. __Just copy the text from it__  (input/output cell)
:::

The result will look like this

![](../../../imgs/Screenshot%202023-11-02%20at%2010.18.16.png)

