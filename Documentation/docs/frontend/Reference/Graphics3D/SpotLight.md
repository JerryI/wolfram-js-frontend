---
env:
  - WLJS
virtual: true
update: true
origin: https://github.com/JerryI/wljs-graphics-d3/
---
```mathematica
SpotLight[color_RGBColor, intensity_, opts___]
```

places a fake source of light in a 3D scene (see [Graphics3D](Graphics3D.md))

## Options
Those options are usually required for the correct rendering

### `"Position"`
A vector, that specifies the origin of the spot light source. __id does support dynamic updates__, i.e. can be used together with [Offload](../Dynamics/Offload.md)

### `"Target"`
A vector that stands for the direction of the light source with respect to the `"Position"`. It __also supports updates__

## Neat example
A controllable by a user spot light

```mathematica
target = {0,0,0};
handler = Function[data, target = data["position"]];
```

```mathematica
KnotData[{"TorusKnot", {3, 5}}][[1]];
Graphics3D[{ Shadows[True],
  %, 
  EventHandler[Sphere[target, 0.1], {"transform" -> handler}], 
  SpotLight[White, "Position"->{0,0,2}, "Target"->Offload[target]],
  Polygon[5{{-1,1,-1}, {1,1,-1}, {1,-1,-1}, {-1,-1,-1}}]
}, "Lighting"->None]
```