// @ts-check
import { test, expect } from '@playwright/test';
import {url, delay, evaluate, clearCell} from './common'

test.describe.configure({ mode: 'serial' });


test.describe('Users GUI', () => {
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

  test('Cell view', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'CellView["graph LR\nA[Text Header 3200 byte]  --> B[Binary Header 400 byte]\nB --> C1[240 byte 1-st trace header] --> T1[samples of 1-st trace]\nB --> C2[240 byte 2-st trace header] --> T2[samples of 1-st trace]\nB --> CN[240 byte n-st trace header] --> T3[samples of 1-st trace]", ImageSize->650, "Display"->"mermaid"] ', 5000, 1000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'cellview.png']);
  });  

  test('Editor view', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'EditorView[ToString[Plot[x, {x,0,1}], StandardForm]]', 5000, 1000);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'editor.png']);
  }); 
  
  test('HTML View', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'HTMLView["<h2>Hello World</h2>"]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'html.png']);
  }); 

  test('InputButton', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'InputButton[]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'InputButton.png']);
  });   

  test('InputRange', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'InputRange[0,1,0.1]', 5000, 500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'inputrange.png']);
  }); 

  test('InputGroup', async () => {
    await clearCell(page);
  
    const outputCell = await evaluate(page, 'InputGroup[{InputRange[0, 10, 1, "Label"->"Range 1"],InputRange[0, 10, 1, "Label"->"Range 2"],InputText["Hi"]}]', 5000, 1500);
    await expect(outputCell).toHaveScreenshot(['screenshorts', 'inputgroup.png']);
  });   
  
});