A short describtion of WL and frontend functions
🚧  To be written

## Wolfram Kernel

### Plotting
Supported functions for visualising your data
#### New
 - `Plotly[expr, {var, range1, range2, step}]` - interactive plot using Plotly.js library
	 - `ImageSize` as an option to set the size of image
 - `ListPlotly[list]` (can be used with [[Frontend Object]] for dynamics)
	 - `ImageSize` as an option to set the size of image
	 - `RequestAnimationFrame[]` as an upvalue to create dynamic plots with no overhead
 - `ListLinePlotly[list]` the same
#### Native from Mathematica
- `Plot` - plot function (__minimal styling__)
	- `ImageSize` as an option to set the size of image
	- `PlotStyle` styling is possible
	- etc ???
- `ListPlot` 
- `ListLinePlot`
- some other functions, that results in `Graphics` object
- `Plot3D` - plot function for 2D functions (__minimal styling__)
- `ListLinePlot3D`
- `SphericalPlot3D`
- `ContourPlot3D`
- some other functions, that results in `Graphics3D` object

### Graphics
#### New
- none
#### Native from Mathematica
- `Line`
- `Point`
- ???

### Graphics3D
#### New
- `Emissive[]` - property fro the object to emitt light
- `IOR[]` - specify the refractive index
- `Reflectivity[]` - reflectivity of the material
- `SkyAndWater[]` - apply shader to the scene with animated ocean and sun
- subsurface scattering
- bloom control from the menu
#### Native from Mathematica
- `Line`
- `Sphere`
- `Cuboid`
- `Tetrahedron`
- `Polygon`
- `GraphicsComplex`
- `GeometricTransformation`
- etc ???

### Dynamics
- to be written

### Utils
- `NullQ`

### Frontend
#### DOM Tools
- `HTMLForm["<h1>Hi</h1>"]` - direct representation of DOM element (including JS)
- `SVGForm` - can be applied to any object and export it as SVG and embedd to a cell
- `JSRun[""]` - run a JS script in the cell
- `WebOpen[""]` - open any url in a new tab