// @ts-check
import { test, expect } from '@playwright/test';
import {url, delay, evaluate, clearCell} from './common'

test.describe.configure({ mode: 'serial' });


test.describe('Graphs', () => {
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

  test('Simple graph', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Graph[{1 -> 2, 2 -> 3, 3 -> 1}]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'graph.png']);
  });  

  test('Vertex shaped graph', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Graph[{1 -> 2, 2 -> 3, 3 -> 1}, VertexShapeFunction -> "Diamond", VertexSize -> Medium]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'graphshape.png']);
  }); 
  
  test('Annotated graph', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'Graph[Table[Annotation[v, {VertexSize -> 0.2 + 0.2 Mod[v, 5], VertexStyle -> Hue[v/15, 1, 1]}], {v, 0, 14}], Table[v <-> Mod[v + 1, 15], {v, 0, 14}]]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'annotatedgraph.png']);
  }); 
  
});