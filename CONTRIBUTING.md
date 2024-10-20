# How you can help this project
WLJS Notebook is modular project. 

**Please, contact @JerryI before working on code and etc.**

Here is some to-do list grouped by repos

## wolfram-js-frontend
*server, IO, UI, cells manager, render process and client app*
### Primary
- [ ] Electron app auto-updater. Use Github releases to update client app automatically (probably won't work for linux)
- [ ] tutorials/examples for new users (no WL background) on Wolfram Language
- [ ] autotests in a format of WLJS notebook, which go though most features
- [ ] more example on differnet topics (for data-scientists, scientists, students, ...)

*Main repo is stable and there are no urget needs in any refactoring*

## Demonstration project
[A collection of examples](https://jerryi.github.io/wljs-demo/) showcasing WLJS Notebook for non-developers (directly exported from WLJS Notebooks).
- [ ] possibly convert to similar format of our [Blog](https://jerryi.github.io/wljs-docs/blog) (in a discussion)
- [ ] more examples on various topics

## wljs-graphics-d3
### Primary
- [ ] `Inset` works incorrectly on `Image` and other `Graphics` objects.
- [ ] `PlotLegends` are not rendered inside a `Graphics` object (acts like a wrapper). Exported figures do not show legends.

### Secondary
- [x] misssing implementations for `FilledCurve`, ...
- [ ] `GraphicsComplex` with many `Polygon` is too slow. Especially it can be seen on `ContourPlot`, since it produces tons of SVG paths. 


## wljs-graphics3d-threejs
### Primary
- [ ] `AxesLabel`, `Ticks`, does not have any effect.  `PlotRange` is absent. 
- [x] `Text` is not implemented in the context of `Graphics3D`

### Secondary
- [ ] `RTX` feature shows incorrect faces of polygons (black triangles) on OSX (probably also depends on a browser)

## wljs-inputs
### Primary
- [ ] `TableForm` does not support styling
- [ ] `Dataset` does not support nested sets with asscoiations or other datasets inside.
- [ ] `Entity` is not supported


## wljs-markdown
### Primary
- [x] get rid of double backslashes from LaTeX somehow (single backslash causes problems with encoding)

## wljs-slides
### Primary
- [x] get rid of double backslashes from LaTeX somehow (single backslash causes problems with encoding)

## wljs-video
### Primary
- [ ] video preview is extremely slow, decoding from video to a set of images is a main bottleneck.
- [ ] no sound (need to be used together with PCM streamer from wljs-audio)

## wljs-sound
### Primary
- [ ] `Sound` does not works with nested list of `SoundNote`
- [ ] `Sound[SoundNote[...]]` needs a proper syntax sugar for showing piano roll and possible note names


## Mics
- [ ] **Wolfram Language Documentation** (frontend agnostic and in a Markdown format)
- [ ] support for syntax sugar for `NeuralNetwork` package of Wolfram Language. For now it is not clear, how to clean up Mathematica's `MakeBoxes` definitons for various neural network object. There is a possibility to use wrapper function, see more in [Issue](https://github.com/JerryI/wolfram-js-frontend/issues/186).
- [x] write a fast implementation of parser/encoder of [WXF](https://github.com/JerryI/wolfram-js-frontend/issues/196) in Javascript. For now we use `ExpressionJSON` for communication, which does not use features of `NumericArray` and `ByteArray` and adds a large overhead in serializaing/deserializing on WL's and JS's sides. There is a [preliminaly work](https://github.com/xndc/uncompress) posted already.
