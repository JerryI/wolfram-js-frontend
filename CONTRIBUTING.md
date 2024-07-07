# How you can help this project
WLJS Notebook is modular project. 

**Please, contact @JerryI before working on code and etc.**

Here is some to-do list grouped by repos

## wolfram-js-frontend
*server, IO, UI, cells manager, render process and client app*
### Primary
- [ ] tutorials/examples for new users (no WL background) on Wolfram Language
- [ ] autotests in a format of WLJS notebook, which go though most features
- [ ] more example on differnet topics (for data-scientists, scientists, students, ...)

*Main repo is stable and there are no urget needs in refactoring*

## wljs-graphics-d3
### Primary
- [ ] `Inset` works incorrectly on `Image` and other `Graphics` objects.
- [ ] `PlotLegends` are not rendered inside a `Graphics` object (acts like a wrapper). Exported figures do not show legends.

### Secondary
- [ ] misssing implementations for `FilledCurve`, ...
- [ ] `GraphicsComplex` with many `Polygon` is too slow. Especially it can be seen on `ContourPlot`, since it produces tons of SVG paths. 
- [ ] need to override Mathematica's `Export` on graphics objects. Probably use some tricks with rendering on frontend and communicating the result over websockets to a kernel

## wljs-graphics3d-threejs
### Primary
- [ ] `AxesLabel`, and all ticks are not implemented! We need someone, who can draw text nodes ontop of 3D plot. `PlotRange` is completely absent. See [Issue](https://github.com/JerryI/wolfram-js-frontend/issues/216)
- [ ] `Text` is not implemented in the context of `Graphics3D`

### Secondary
- [ ] `RTX` feature shows incorrect faces of polygons (black triangles) on OSX (probably also depends on a browser)

## wljs-inputs
### Primary
- [ ] `TableForm` does not support styling
- [ ] `Dataset` does not support nested sets with asscoiations or other datasets inside.

## wljs-markdown
### Primary
- [ ] get rid of double backslashes from LaTeX somehow (single backslash causes problems with encoding)

## wljs-slides
### Primary
- [ ] get rid of double backslashes from LaTeX somehow (single backslash causes problems with encoding)

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
- [ ] write a fast implementation of parser/encoder of [WXF](https://github.com/JerryI/wolfram-js-frontend/issues/196) in Javascript. For now we use `ExpressionJSON` for communication, which does not use features of `NumericArray` and `ByteArray` and adds a large overhead in serializaing/deserializing on WL's and JS's sides. There is a [preliminaly work](https://github.com/xndc/uncompress) posted already.
