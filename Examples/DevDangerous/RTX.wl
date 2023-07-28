<|"notebook" -> <|"name" -> "Bowdlerization", "id" -> "stale-c8356", 
   "kernel" -> LocalKernel, "objects" -> <||>, 
   "path" -> "/Volumes/Data/Github/wolfram-js-frontend/Examples/Dev/RTX.wl", 
   "cell" :> Exit[], "date" -> DateObject[{2023, 7, 24, 18, 37, 
      41.718903`8.372907858093264}, "Instant", "Gregorian", 2.], 
   "symbols" -> <||>, "channel" -> WebSocketChannel[
     KirillBelov`WebSocketHandler`WebSocketChannel`$21]|>, 
 "cells" -> {<|"id" -> "aa5335b4-f54e-46f5-bda8-23ce77f0d779", 
    "type" -> "input", "data" -> ".md\n## Torus Knot", 
    "display" -> "codemirror", "sign" -> "stale-c8356", 
    "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "69fdb11c-f83e-480b-8075-b7ae077ea2e0", "type" -> "output", 
    "data" -> "\n## Torus Knot", "display" -> "markdown", 
    "sign" -> "stale-c8356", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "fbb8a8ea-dada-425e-a452-1efe5df4b1e4", "type" -> "input", 
    "data" -> "KnotData[{\"TorusKnot\", {3, \
5}}][[1]];\nGraphics3D[{{Emissive[Red, 5], Sphere[{0,0,-0.1}, 0.14]}, \
{Roughness[0],Cyan, %}, {Emissive[RGBColor[{1,1,1}], 5], Sphere[{0,0,0.4}, \
0.1]}}, Lighting->None, \"RTX\"->True]", "display" -> "codemirror", 
    "sign" -> "stale-c8356", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "d4c56a05-2ff5-40c7-a9e7-b80ce701018c", "type" -> "input", 
    "data" -> ".md\n## Maze", "display" -> "codemirror", 
    "sign" -> "stale-c8356", "props" -> <|"hidden" -> True|>|>, 
   <|"id" -> "4b733e10-c797-47a7-8793-93612b55ae95", "type" -> "output", 
    "data" -> "\n## Maze", "display" -> "markdown", "sign" -> "stale-c8356", 
    "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "5db0f0cd-133d-469b-8fa1-81ebda3486e8", "type" -> "input", 
    "data" -> "showmaze = Uncompress[FromCharacterCode @@ \
ImageData[Import[\"https://i.stack.imgur.com/XVJcP.png\"], \"Byte\"]];\nprims \
= CapsuleShape @@@ Cases[showmaze, _Cylinder, Infinity];\nprims = prims /. \
{{5., 5., 5.} -> {5.5, 5., 5.}, {1., 1., 1.} -> {1., 0.5, 1.}};\nims = \
RegionImage[#, {{0.3`, 5.7`}, {0.3`, 5.7`}, {0.3`, 5.7`}}, RasterSize -> 100] \
& /@ prims;\nim = ImageApply[Max, ims];", "display" -> "codemirror", 
    "sign" -> "stale-c8356", "props" -> <|"hidden" -> False|>|>, 
   <|"id" -> "a4c93787-cdda-40ea-93db-4f347611e47c", "type" -> "input", 
    "data" -> "lighting = Table[{Emissive[RGBColor@@(RandomReal[{0,1}, 3]), \
2], Sphere[RandomReal[{1,92}, 3], RandomReal[{1,7}]]}, {i, 1, 30}];\nShow[bmr \
= ImageMesh[im, Method -> \"DualMarchingCubes\"], PlotRange -> {{0, 91}, {1, \
92}, {0, 91}}][[1]];\nGraphics3D[{lighting, Metalness[0], Roughness[0], %},  \
\"Lighting\"->None, ViewProjection->\"Perspective\", \"RTX\"->True]", 
    "display" -> "codemirror", "sign" -> "stale-c8356", 
    "props" -> <|"hidden" -> False|>|>}, "serializer" -> "jsfn3"|>
