---
env:
  - WLJS
virtual: true
needsContainer: true
update: true
source: https://github.com/JerryI/wljs-graphics-d3/
---
Represents an arbitrary text label placed as a [Graphics](Graphics.md) object

```mathematica
Text["String", {0,0}]
```

Supports styling such as `Style` and `Directive`, i.e.

```mathematica
Graphics[{
	Text[Style["Hello World", FontSize->14], {0,0}]
}]
```

<Wl data={`WyJHcmFwaGljcyIsWyJMaXN0IixbIlRleHQiLFsiU3R5bGUiLCInSGVsbG8gV29ybGQnIixbIlJ1
bGUiLCJGb250U2l6ZSIsMTRdXSxbIkxpc3QiLDAsMF1dXSxbIlJ1bGUiLCJJbWFnZVNpemUiLDUw
MF1d
`}>{`Graphics[{
	Text[Style["Hello World", FontSize->14], {0,0}]
}, ImageSize->500]`}</Wl>

### Styling options
The following options can be provided to [`Style`](Style.md) wrapper
- `FontSize->Number` - 10, 12, 14...
- `FontFamily->String` - this is basically an SVG attribute, please see [here](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/font-family). If you have imported any font using CSS, you can also use it. 

To change the color, just put in somewhere to the list
```mathematica
Graphics[{
	Red, Text["Hello World", {0,0}]
}]
```


<Wl data={`WyJHcmFwaGljcyIsWyJMaXN0IixbIlJHQkNvbG9yIiwxLDAsMF0sWyJUZXh0IiwiJ0hlbGxvIFdv
cmxkJyIsWyJMaXN0IiwwLDBdXV0sWyJSdWxlIiwiSW1hZ2VTaXplIiw1MDBdXQ==
`}>{`Graphics[{
	Red, Text["Hello World", {0,0}]
}, ImageSize->500]`}</Wl>

### Dynamic updates
For both the position and text content [dynamic updates](../../Tutorial/Dynamics.md) are supported

```mathematica
txt = RandomWord[];
pos = {0,0};

Graphics[{
	Red, Text[txt // Offload, pos // Offload]
}]
```

```mathematica
task = SetInterval[With[{},
	txt = RandomWord[];
	pos = RandomReal[{-1,1}, 2];
], 500];

SetTimeout[TaskRemove[task], 5000];
```

use `TaskRemove[task];` __to stop an animation__

### Math support
You can use __a limited Latex-math kinda mode__, that I implemented instead of full `Boxes` support as it was done in Mathematica, since it might slow down the system a lot

```mathematica
Text["wavenumber (cm^{-1})", {0,0}]
Text["\\alpha (cm^{-1})", {0,0}]
```

<Wl data={`WyJHcmFwaGljcyIsWyJMaXN0IixbIlRleHQiLCInd2F2ZW51bWJlciAoY21eey0xfSknIixbIkxp
c3QiLDAsMF1dLFsiVGV4dCIsIidcXGFscGhhIChjbV57LTF9KSciLFsiTGlzdCIsMCwtMC40XV1d
LFsiUnVsZSIsIkltYWdlU2l6ZSIsNTAwXV0=
`}>{`Graphics[{Text["wavenumber (cm^{-1})", {0,0}], Text["\\alpha (cm^{-1})", {0,-0.4}]}, ImageSize->500]`}</Wl>

A list of features
- most used Greek symbols like `alpha` and etc are supported
- subscript `a_1` or `a_{hi}`
- superscript `a^2` or `a^{23}`

<Wl data={`WyJHcmFwaGljcyIsWyJMaXN0IixbIlRleHQiLCInYV8xIG9yIGFfe2hpfSBhbmQgYV4yIG9yIGFe
ezIzfSciLFsiTGlzdCIsMCwwXV1dLFsiUnVsZSIsIkltYWdlU2l6ZSIsNTAwXV0=
`}>{`Graphics[{Text["a_1 or a_{hi} and a^2 or a^{23}", {0,0}]}, ImageSize->500]`}</Wl>

In principle, it will anyway ends up in HTML, therefore one can use any special symbol

```mathematica
"I will display &#10060;"
```

<Wl data={`WyJHcmFwaGljcyIsWyJMaXN0IixbIlRleHQiLCInSSB3aWxsIGRpc3BsYXkgJiMxMDA2MDsnIixb
Ikxpc3QiLDAsMF1dXSxbIlJ1bGUiLCJJbWFnZVNpemUiLDUwMF1d
`}>{`Graphics[{Text["I will display &#10060;", {0,0}]}, ImageSize->500]`}</Wl>