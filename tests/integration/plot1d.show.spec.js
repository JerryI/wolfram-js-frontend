// @ts-check
import { test, expect } from '@playwright/test';
import {url, delay, evaluate, clearCell} from './common'

test.describe.configure({ mode: 'serial' });

test.describe('1D Plot', () => {
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

  test('Simple plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot[(*FB[*)((1)(*,*)/(*,*)(x))(*]FB*), {x,0,1}, PlotStyle->Red, Frame->True, FrameLabel->{"x-axis", "y-axis"}, FrameStyle->Directive[FontSize->14], FrameTicksStyle->Directive[FontSize->14],Epilog->{Cyan, Line[{{-10,10}, {10,10}}]}]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'plot.png']);
  });  

  test('Filling plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot[{Sin[x] + x/2, Sin[x] + x}, {x, 0, 10}, Filling -> {1 -> {2}}]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'plotfilling.png']);
  }); 

  test('Multiple filling plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot[Evaluate[Table[BesselJ[n, x], {n, 4}]], {x, 0, 10}, Filling -> Axis]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'plotmultifilling.png']);
  }); 
  
  test('Date plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'DateListPlot[Transpose[{{DateObject[{2022, 12}], DateObject[{2023, 12}], DateObject[{2024, 2}]}, {1,2,3}}]]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'dateplot.png']);
  }); 
  
  test('Legended Accumulated plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'SeedRandom[10]; ListLinePlot[Table[Accumulate[RandomReal[{-1, 1}, 250]], {3}], Filling -> Axis, PlotLegends -> {"one", "two", "three"}]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'legendedaccplot.png']);
  });   


  test('Legended BinomialDistribution plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'ListPlot[Table[{k, PDF[BinomialDistribution[50, p], k]}, {p, {0.3, 0.5, 0.8}}, {k, 0, 50}], Filling -> Axis, PlotLegends -> {0.3, 0.5, 0.8}]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'BinomialDistribution.png']);
  });
  
  test('Legended Swatch plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot[{Sin[x], Cos[x]}, {x, 0, 5}, PlotLegends -> SwatchLegend["Expressions"]]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'swatchplot.png']);
  });
  
  test('Point Legend', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'PointLegend[{Red, Green, Blue}, {"red", "green", "blue"}]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'pointlegend.png']);
  });  

  test('Legended Line plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot[{Sin[x], Cos[x]}, {x, 0, 5}, PlotLegends -> LineLegend["Expressions"]]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'lineplot.png']);
  });

  test('Legended Markdown plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot[{Sin[x], Cos[x]}, {x, 0, 5}, PlotLegends -> LineLegend[Automatic, {CellView["$\\\\sin(x)$", "Display"->"markdown"],CellView["$\\\\cos(x)$", "Display"->"markdown"]}]]', 5000, 1500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'markdownplot.png']);
  });

  test('Legended Prime Numbers', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Legended[Grid[Partition[Table[If[PrimeQ[n], Item[n, Background -> LightBlue], n], {n, 100}], 10], Frame -> All], SwatchLegend[{LightBlue}, {"prime numbers"}]]', 5000, 2000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'legendedPrime.png']);
  });

  test('Placed Swatch Legend', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot[{x,x^2}, {x,0,1}, PlotLegends->Placed[SwatchLegend[Automatic], {0.2,0.2}]]', 5000, 2000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'placedSwatch.png']);
  });  

  test('Placed Swatch Legend 2', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot[{x,x^2}, {x,0,1}, PlotLegends->Placed[SwatchLegend[Automatic], After]]', 5000, 2000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'placedSwatch2.png']);
  });   

  

  
  

});