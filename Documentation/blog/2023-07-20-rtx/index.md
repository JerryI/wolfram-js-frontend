---
slug: rtx-intro
title: Realtime path-tracing
authors: jerryi
tags: [frontend, graphics]
enableComments: true
---

![](Screenshot%20from%202023-07-20%2020-04-08.png)

There is nothing more exciting in programming than designing a graphics application. Thankfully, there is one person on Github [Garrett Johnson](https://github.com/gkjohnson), who implemented a path-tracing algorithm on top of the well-known [THREE.js](https://threejs.org) graphics engine. Moreover, it fully supports features from the original library and can be anytime flipped as a main renderer.

<!--truncate-->

I hooked up his [library](https://github.com/gkjohnson/three-gpu-pathtracer) to works as a secondary engine for `Graphics3D` function presented in [wljs-graphics3d-threejs](https://github.com/JerryI/Mathematica-ThreeJS-graphics-engine) library. Just pass an option

```mathematica
Graphics3D[%, "RTX"->True]
```

And it will bake a realtime photorealistic image. It also supports all properties used in traditional rendering, i.e. `Emissive[]`, `Metallness[]`, HDRI map and many more!

Some classical examples from Wolfram Mathematica

![](IMG_0556.png)


![](screenshot(8)%201.png)

You might recognize those examples from `Graphics3D` official documentation page. Here is some other neat pictures produced using the following code

### Metallic maze
This was taken from the discussion [here](https://mathematica.stackexchange.com/questions/191047/making-holes-from-maze-generated-graphics3d). The maze is made from many polygons, where for the surface `Metallness[1], Roughness[0]` were applied. Since it provides perfect reflection, the overall time for rendering (when the noise has gone) is relatively low.

```mathematica
showmaze = Uncompress[FromCharacterCode @@ ImageData[Import["https://i.stack.imgur.com/XVJcP.png"], "Byte"]];
prims = CapsuleShape @@@ Cases[showmaze, _Cylinder, Infinity];
prims = prims /. {{5., 5., 5.} -> {5.5, 5., 5.}, {1., 1., 1.} -> {1., 0.5, 1.}};
ims = RegionImage[#, {{0.3`, 5.7`}, {0.3`, 5.7`}, {0.3`, 5.7`}}, RasterSize -> 100] & /@ prims;
im = ImageApply[Max, ims];
```

Then, the generated mesh is lit by `lighting` arrays, which contain randomly distributed glowing spheres

```mathematica
lighting = Table[{Emissive[RGBColor@@(RandomReal[{0,1}, 3]), 2], Sphere[RandomReal[{1,92}, 3], RandomReal[{1,7}]]}, {i, 1, 30}];
Show[bmr = ImageMesh[im, Method -> "DualMarchingCubes"], PlotRange -> {{0, 91}, {1, 92}, {0, 91}}][[1]];
Graphics3D[{lighting, Metalness[0], Roughness[0], %},  "Lighting"->None, ViewProjection->"Perspective", "RTX"->True]
```


![](screenshot(12).png)

Despite the complicity of the scene, __it renders in real time__ with an acceptable amount of noise.

### Torus Knot
This is rather classical example, but uses a glossy surface using `Roughness[0]` lit by two glowing spheres

```mathematica
KnotData[{"TorusKnot", {3, 5}}][[1]];
Graphics3D[{{Emissive[Red, 5], Sphere[{0,0,-0.1}, 0.14]}, {Roughness[0],Cyan, %}, {Emissive[RGBColor[{1,1,1}], 5], Sphere[{0,0,0.4}, 0.1]}}, Lighting->None, "RTX"->True]
```

Here is the result

![](screenshot(13).png)

Looks like a dream...

## Limitations
- The dynamic scenes now are not supported, but can be added in theory according to the documentation of the path-rendering library. 
- Requires a dedicated GPU (actually with my Intel UHD integrated graphics it works, but demands an extremely long time to compile shaders to start rendering). However, iPhones, Androids can still handle not very complicated scenes.
- Safari crashes (Firefox, Chrome, Vivaldi work well)