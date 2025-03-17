// @ts-check
import { test, expect } from '@playwright/test';
import {url, delay, evaluate, clearCell} from './common'

test.describe.configure({ mode: 'serial' });

test.describe('3D Plot', () => {
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

  test('Spherical Plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, '(*SbB[*)Subscript[Y(*|*),(*|*)k_,q_](*]SbB*)[θ_, ϕ_] := SphericalHarmonicY[k,q, θ, ϕ]; SphericalPlot3D[(*SbB[*)Subscript[Y(*|*),(*|*)4,0](*]SbB*)[θ, ϕ], {θ,0,π}, {ϕ,0,2π}]', 5000, 1500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'spherical.png']);
  });  

  test('Vector plot', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'VectorPlot3D[{x, y, z}, {x, -1, 1}, {y, -1, 1}, {z, -1, 1}]', 5000, 1500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'vector.png']);
  }); 

  test('Plot3D', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot3D[Im[ArcSin[(x + I y)^4]], {x, -2, 2}, {y, -2, 2}, Mesh -> None, PlotStyle -> Directive[Yellow, Opacity[0.8]], ExclusionsStyle -> {None, Red}]', 5000, 1500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'plot3d.png']);
  }); 
  
  test('Plot3D 2', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Plot3D[Sin[Sqrt[x^2 + y^2]], {x, -6, 6}, {y, -6, 6}, PlotRange -> All, Mesh -> None, ColorFunction -> "Rainbow"]', 5000, 1000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'plot3d2.png']);
  }); 
  
  test('3D Materials', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Graphics3D[{Darker[White], Polygon[{{-2,-2,0}, {2,-2,0}, {2,2,0}, {-2,2,0}}],{ Directive[Cyan, "MaterialThickness"->1.0, "Transmission"->1.0,"Roughness"->0.13, "Ior"->2.0], Sphere[{0,0,1}, 1]}}]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'materials.png']);
  });   


  test('Glass Material', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Graphics3D[{Plot3D[Sin[x] Cos[y], {x,-10,10}, {y,-10,10}][[1]], {Graphics3D`Materials[#], Red,Sphere[{0,0,2}, 6]}}] &@ "Glass"', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'glass.png']);
  });
  
  test('Lights and shadows', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Graphics3D[{Directive["Shadows"->True], Polygon[ {{-5,5,-1}, {5,5,-1}, {5,-5,-1}, {-5,-5,-1}}], White, Cuboid[{-1,-1,-1}, {1,1,1}], Directive["Shadows"->False], PointLight[Red, {1.5075, 4.1557, 2.6129}, 100], Directive["Shadows"->True], SpotLight[Cyan, {-2.268, -2.144, 3.1635}]}, "Lighting"->None]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'imagenegate.png']);
  });
  

});