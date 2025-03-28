// @ts-check
import { test, expect } from '@playwright/test';
import {url, delay, evaluate, clearCell} from './common'

test.describe.configure({ mode: 'serial' });




test.describe('Easy check for most basic decorators', () => {
  let page;
  test.beforeAll(async ({ browser }) => {
      const context = await browser.newContext();
      page = await context.newPage();
      page.route('**', route => route.continue());

      await page.goto(url);
      await delay(4000);
  });

  test.afterAll(async ({ browser }) => {
      browser.close;
  });

  test('1+1', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, '1+1', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', '1p1.png']);
  });  

  test('xyz', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'x y z', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'xyz.png']);
  });   

  test('Subscript decoration', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, '{Subscript[x, Subscript[y,z]], Subscript[x, "1"], Subscript["x", 1], Subscript["x", "y"]}', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Subscript.png']);
  });

  test('Indexed decoration', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Indexed[x, {1,2}]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Indexed.png']);
  });  

  
  test('Superscript decoration aka Pow', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, '{x^2, x^y^z}', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Superscript.png']);
  });  

  test('Fraction decoration', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, '{x/y, 1/2, x/y/z, "Centimeters"/"Millimeters"}', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Fraction.png']);
  });   
  
  test('Grid decoration', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Table[{x,y}, {x,10}, {y,10}] // Grid', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Grid1.png']);
  });

  test('Grid decoration with colors', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Table[RGBColor[x/10.0, y/10.0, 1.0], {x,5}, {y,5}] // Grid', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Grid2.png']);
  }); 
  
  
  test('Transpose decoration', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Transpose[x]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Transpose.png']);
  });   

  test('Conjugated transpose', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'ConjugateTranspose[x]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'ConjugateTranspose.png']);
  });  

  test('Undefined integral', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Integrate[x[y], y]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Integrate1.png']);
  });   

  test('Undefined integral with limits', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Integrate[x[y], {y, -A, B}]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Integrate2.png']);
  }); 
  
  test('Undefined integral computable', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Integrate[Sin[y], y]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Integrate3.png']);
  });   

  test('Undefined integral with limits computable', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Integrate[y^2, {y, -A, B}]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Integrate4.png']);
  });   

  test('Undefined sum', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Sum[f[x], {x, A, B}]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Sum1.png']);
  });   

  test('Undefined sum computable', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Sum[x, {x, A, B}]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Sum2.png']);
  });   

  test('Piecewise decoration', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, '(*TB[*)Piecewise[{{(*|*)_(*|*),(*|*)x > 0(*|*)},{(*|*)0(*|*),(*|*)True(*|*)}}](*|*)(*1:eJxTTMoPSmNkYGAo5gESAZmpyanlmcWpTvkVmUxAAQBzVQdd*)(*]TB*)', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'Piecewise.png']);
  });   

  test('DateObject', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, '(*VB[*)(DateObject[{2025,3,17,19,53,23.064202`8.115513415904537},"Instant","Gregorian",1.`])(*,*)(*"1:eJxTTMoPSmNiYGAo5gUSYZmp5S6pyflFiSX5RcEsQBGXxJLUYCkgQ8k3P0/B0FzBN7FIwcjAyFTB0NLK1NjKyFgJACEfD5c="*)(*]VB*)', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'now.png']);
  });  
  
  test('Quantity', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Quantity[1, "Centimeters"/"Seconds"]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'quantity.png']);
  });   

  test('Entity', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Entity["Germany", "Country"]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'entity.png']);
  });  
  
  test('Byte Array', async () => {  
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'ByteArray[{1,2}]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'bytearray.png']);
  });  

  test('Plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot[x, {x,0,1}]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'plot.png']);
  });  

  test('Sphere', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Graphics3D[Sphere[]]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'sphere.png']);
  });  
  
  test('List Play', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'ListPlay[Table[Sin[2 π 50 t], {t, 0, 1, 1./2000}]]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'listplay.png']);
  });    
  
  test('Image', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Image[Table[Clip[(x^2 - y^2)/10000.0], {x,-100,100}, {y,-100,100}],Magnification->Graphics`DPR[]]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'image.png']);
  });     
  

  test('Derivative Decoration', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'D[f[x], x]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'deriv.png']);
  });

  test('Color Function', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'ColorData[24]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'colorFunction.png']);
  });
  
  test('Summary Box ModelFit', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'SeedRandom[100]; NonlinearModelFit[Table[{x, Sin[x+RandomReal[0.1{-1,1}]]}, {x,0,10,0.1}], Sin[w x], {w}, x]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'modelFit.png']);
  });

  test('Summary Box Interpolation', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Interpolation[Table[x^2, {x,100}]]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'interpolationBox.png']);
  });

  test('Summary Box LinearLayer', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'LinearLayer[5]//Quiet', 15000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'linearyLayerNet.png']);
    await delay(5000);
  });
  
  test('Summary Box NeuralNetImageOut', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'SeedRandom[100];net = NetChain[{30, Sin, 3, Tanh, 3, LogisticSigmoid}, "Input" -> 2];nets = Table[NetInitialize[net, Method -> {"Random", "Weights" -> 3, "Biases" -> 2}, RandomSeeding -> 10], 16];row = Range[-2, 2, 0.04];coords = Tuples[row, 2];plot[net_] :=Image[Partition[net[coords], Length[row]]];Multicolumn@Table[plot[net], {net, nets}]', 15000, 3000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'NeuralNetImageOut.png']);
  
  });

  test('Dataset', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'SeedRandom[100];ExampleData[{"Dataset", "Titanic"}]', 15000, 1000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'dataset.png']);
  });  

  test('Interpetation', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Interpretation[Graphics[Disk[{0,0},1], ImageSize->100], 1]', 5000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'interpretation.png']);
  });  


  test('2B or not 2B', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'With[{data = ExampleData[{"Text", "ToBeOrNotToBe"}, "Words"]}, Take[MapIndexed[Style[#, 10 Count[Take[data, First[#2]], #]] &, data], 30]]', 15000, 2000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', '2bornot2b.png']);
  });

  test('TeXForm', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'TeXForm[Series[Sin[x], {x,0,4}]//Normal]', 8000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'texform.png']);
  });

  test('TeXForm back', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'ToExpression[TeXForm[Series[Sin[x], {x,0,4}]//Normal], TeXForm]', 8000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'texform_back.png']);
  });  

  test('TeXForm + Markdown Cells', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'CellView[StringJoin["$$\[NewLine]", TeXForm[Series[Sin[x], {x,0,7}] // Normal], "\[NewLine]$$"], "Display"->"markdown"]', 8000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'texform_markdown.png']);
  });   

  test('Geographics', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'GeoGraphics[{EdgeForm[Black], FaceForm[Red], Polygon[Entity["Country", "Italy"]]}]', 18000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'geo.png']);
  });    


});




