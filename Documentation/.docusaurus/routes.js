import React from 'react';
import ComponentCreator from '@docusaurus/ComponentCreator';

export default [
  {
    path: '/wljs-docs/',
    component: ComponentCreator('/wljs-docs/', 'a29'),
    routes: [
      {
        path: '/wljs-docs/',
        component: ComponentCreator('/wljs-docs/', '698'),
        routes: [
          {
            path: '/wljs-docs/tags',
            component: ComponentCreator('/wljs-docs/tags', '9d8'),
            exact: true
          },
          {
            path: '/wljs-docs/tags/excalidraw',
            component: ComponentCreator('/wljs-docs/tags/excalidraw', '57a'),
            exact: true
          },
          {
            path: '/wljs-docs/',
            component: ComponentCreator('/wljs-docs/', '786'),
            routes: [
              {
                path: '/wljs-docs/category/advanced',
                component: ComponentCreator('/wljs-docs/category/advanced', '256'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/category/cell-types',
                component: ComponentCreator('/wljs-docs/category/cell-types', '47e'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/category/exporting-formats',
                component: ComponentCreator('/wljs-docs/category/exporting-formats', '753'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/category/tutorials',
                component: ComponentCreator('/wljs-docs/category/tutorials', '1fb'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Advanced/Events system/event-generators',
                component: ComponentCreator('/wljs-docs/frontend/Advanced/Events system/event-generators', 'e7c'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Advanced/Events system/promises',
                component: ComponentCreator('/wljs-docs/frontend/Advanced/Events system/promises', '58d'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Advanced/Events system/routing',
                component: ComponentCreator('/wljs-docs/frontend/Advanced/Events system/routing', '7f5'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Advanced/Slides/animations',
                component: ComponentCreator('/wljs-docs/frontend/Advanced/Slides/animations', '599'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Advanced/Slides/components',
                component: ComponentCreator('/wljs-docs/frontend/Advanced/Slides/components', '7a3'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Advanced/Slides/embed-wl',
                component: ComponentCreator('/wljs-docs/frontend/Advanced/Slides/embed-wl', '879'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Advanced/Slides/intro',
                component: ComponentCreator('/wljs-docs/frontend/Advanced/Slides/intro', '29a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Advanced/Slides/tables',
                component: ComponentCreator('/wljs-docs/frontend/Advanced/Slides/tables', 'b06'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Cell types/Files',
                component: ComponentCreator('/wljs-docs/frontend/Cell types/Files', '1ca'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Cell types/HTML',
                component: ComponentCreator('/wljs-docs/frontend/Cell types/HTML', 'aa4'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Cell types/Javascript',
                component: ComponentCreator('/wljs-docs/frontend/Cell types/Javascript', 'fc2'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Cell types/Many more...',
                component: ComponentCreator('/wljs-docs/frontend/Cell types/Many more...', '02c'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Cell types/Markdown',
                component: ComponentCreator('/wljs-docs/frontend/Cell types/Markdown', '1db'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Cell types/Slides',
                component: ComponentCreator('/wljs-docs/frontend/Cell types/Slides', '270'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Cell types/WLX',
                component: ComponentCreator('/wljs-docs/frontend/Cell types/WLX', 'a69'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Cell types/Wolfram Language',
                component: ComponentCreator('/wljs-docs/frontend/Cell types/Wolfram Language', '2c0'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Export/HTML file',
                component: ComponentCreator('/wljs-docs/frontend/Export/HTML file', '2e5'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Export/PDF',
                component: ComponentCreator('/wljs-docs/frontend/Export/PDF', 'c03'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Expressions representation',
                component: ComponentCreator('/wljs-docs/frontend/Expressions representation', 'f50'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/Column',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/Column', 'fc4'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/Framed',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/Framed', '55d'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/Grid',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/Grid', '5dc'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/HTMLForm',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/HTMLForm', 'aa7'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/InputForm',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/InputForm', '58a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/Interpretation',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/Interpretation', '61e'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/InterpretationBox',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/InterpretationBox', '266'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/Low level/BoxBox',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/Low level/BoxBox', '653'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/Low level/ViewBox',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/Low level/ViewBox', 'cdf'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/MakeBoxes',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/MakeBoxes', 'e11'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/MatrixForm',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/MatrixForm', '790'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/Row',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/Row', '85a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/Style',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/Style', '5a4'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/SVGForm',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/SVGForm', '454'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Decorations/TableForm',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Decorations/TableForm', '19b'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Dynamics/CreateFrontEndObject',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Dynamics/CreateFrontEndObject', '931'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Dynamics/Dynamic',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Dynamics/Dynamic', 'c2f'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Dynamics/DynamicModule',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Dynamics/DynamicModule', 'ee6'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Dynamics/FrontEndVirtual',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Dynamics/FrontEndVirtual', '8b2'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Dynamics/Internals/FrontEndExecutable',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Dynamics/Internals/FrontEndExecutable', '5a7'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Dynamics/Internals/FrontEndExecutableInline',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Dynamics/Internals/FrontEndExecutableInline', 'd4a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Dynamics/Internals/FrontEndOnly',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Dynamics/Internals/FrontEndOnly', '355'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Dynamics/Internals/FrontEndRef',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Dynamics/Internals/FrontEndRef', '204'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Dynamics/Manipulate',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Dynamics/Manipulate', 'd65'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Dynamics/Offload',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Dynamics/Offload', 'c49'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/', '250'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/AbsoluteThickness',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/AbsoluteThickness', '2bd'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/Arrow',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/Arrow', '795'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/Directive',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/Directive', 'a52'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/GraphicsComplex',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/GraphicsComplex', 'd09'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/Image',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/Image', '7e4'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/Inset',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/Inset', 'ab0'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/Line',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/Line', 'b9e'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/Show',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/Show', '6f7'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/Style',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/Style', '7ce'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/SVGAttribute',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/SVGAttribute', '485'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/Text',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/Text', '803'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics/Translate',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics/Translate', '5d2'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Graphics3D/SpotLight',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Graphics3D/SpotLight', 'f5a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Inputs/EditorView',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Inputs/EditorView', '890'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Inputs/InputButton',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Inputs/InputButton', '32c'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Inputs/InputFile',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Inputs/InputFile', '84d'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Inputs/InputGroup',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Inputs/InputGroup', '351'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Inputs/InputRange',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Inputs/InputRange', 'ee4'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Inputs/InputTable',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Inputs/InputTable', 'cf5'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Inputs/InputText',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Inputs/InputText', '0fc'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Inputs/Slider',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Inputs/Slider', '5ba'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Inputs/TextView',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Inputs/TextView', 'f7f'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Misc/Async',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Misc/Async', 'd76'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Misc/Events',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Misc/Events', '266'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Misc/Language',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Misc/Language', '00c'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Misc/Promise',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Misc/Promise', '92b'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/ArrayPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/ArrayPlot', '742'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/BarChart',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/BarChart', '8f3'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/BubbleChart',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/BubbleChart', 'e71'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/ContourPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/ContourPlot', 'dc9'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/DensityPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/DensityPlot', '6c5'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/ListContourPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/ListContourPlot', '797'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/ListCurvePathPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/ListCurvePathPlot', '0b9'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/ListLinePlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/ListLinePlot', 'b52'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/ListLinePlotly',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/ListLinePlotly', '7f7'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/ListStepPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/ListStepPlot', 'c9e'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/ListVectorPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/ListVectorPlot', '1f5'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/MatrixPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/MatrixPlot', 'b2d'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/Plot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/Plot', '51a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/Plotly',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/Plotly', '322'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/RandomImage',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/RandomImage', 'ae3'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/StackedListPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/StackedListPlot', '5e5'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/StreamPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/StreamPlot', 'ac1'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/VectorPlot',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/VectorPlot', 'a43'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Reference/Plotting/VectorPlot3D',
                component: ComponentCreator('/wljs-docs/frontend/Reference/Plotting/VectorPlot3D', 'e25'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Troubleshooting',
                component: ComponentCreator('/wljs-docs/frontend/Troubleshooting', '1c8'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Tutorial/Dynamics',
                component: ComponentCreator('/wljs-docs/frontend/Tutorial/Dynamics', '75a'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Tutorial/Export notebook',
                component: ComponentCreator('/wljs-docs/frontend/Tutorial/Export notebook', '420'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Tutorial/Input elements',
                component: ComponentCreator('/wljs-docs/frontend/Tutorial/Input elements', '03e'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/frontend/Tutorial/Overview',
                component: ComponentCreator('/wljs-docs/frontend/Tutorial/Overview', 'e6b'),
                exact: true,
                sidebar: "tutorialSidebar"
              },
              {
                path: '/wljs-docs/imgs/FE data binding.excalidraw 1',
                component: ComponentCreator('/wljs-docs/imgs/FE data binding.excalidraw 1', '84f'),
                exact: true
              },
              {
                path: '/wljs-docs/imgs/feinput.gif',
                component: ComponentCreator('/wljs-docs/imgs/feinput.gif', '4e2'),
                exact: true
              },
              {
                path: '/wljs-docs/imgs/manipulate-frontend-example.excalidraw',
                component: ComponentCreator('/wljs-docs/imgs/manipulate-frontend-example.excalidraw', 'fec'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/Advanced/architecture',
                component: ComponentCreator('/wljs-docs/interpreter/Advanced/architecture', '8ed'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/Advanced/containers',
                component: ComponentCreator('/wljs-docs/interpreter/Advanced/containers', '37a'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/Advanced/meta-markers',
                component: ComponentCreator('/wljs-docs/interpreter/Advanced/meta-markers', 'dc6'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/Advanced/symbols',
                component: ComponentCreator('/wljs-docs/interpreter/Advanced/symbols', '2b5'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/Basics/graphics',
                component: ComponentCreator('/wljs-docs/interpreter/Basics/graphics', 'b26'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/Basics/js-access',
                component: ComponentCreator('/wljs-docs/interpreter/Basics/js-access', '21d'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/Basics/scripts',
                component: ComponentCreator('/wljs-docs/interpreter/Basics/scripts', '94e'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/Basics/syntax',
                component: ComponentCreator('/wljs-docs/interpreter/Basics/syntax', '336'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/Extras/implementation',
                component: ComponentCreator('/wljs-docs/interpreter/Extras/implementation', '738'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/Extras/reference',
                component: ComponentCreator('/wljs-docs/interpreter/Extras/reference', '7e0'),
                exact: true
              },
              {
                path: '/wljs-docs/interpreter/intro',
                component: ComponentCreator('/wljs-docs/interpreter/intro', 'bb2'),
                exact: true
              },
              {
                path: '/wljs-docs/Reference/Misc/Promise',
                component: ComponentCreator('/wljs-docs/Reference/Misc/Promise', 'c5c'),
                exact: true
              },
              {
                path: '/wljs-docs/',
                component: ComponentCreator('/wljs-docs/', '907'),
                exact: true,
                sidebar: "tutorialSidebar"
              }
            ]
          }
        ]
      }
    ]
  },
  {
    path: '*',
    component: ComponentCreator('*'),
  },
];
