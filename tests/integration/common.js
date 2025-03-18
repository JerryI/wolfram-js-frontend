import path from 'path';

export const delay = (ms) => {
  const promise = new Promise((resolve) => {
    setTimeout(resolve, ms)
  });

  return promise;
}

const checkIfKernelAttached = async (page) => {
  await delay(1500);
  let kernelSelection = page.locator('button').filter({ hasText: 'Auto' });
  if (page.kernelQ) return;
  if (await kernelSelection.isVisible({timeout: 2000})) {
    kernelSelection.click();
    console.log('Attaching kernel');
    await delay(8000);
    page.kernelQ = true;
  } 
}

const os = process.platform;
const selectAllShortcut = os === 'darwin' ? 'Meta+A' : 'Control+A'; // macOS uses Meta (Cmd)
export const url = 'http://127.0.0.1:20560/iframe/'+encodeURIComponent(path.resolve(__dirname, 'notebook.wln'));

console.warn('Using url:'+url);

export const evaluate = async (page, input="1+1", timeout=5000, extra=500) => {
  const editor = page.locator('.cm-editor').first();
  // Click to focus
  await delay(100);
  await editor.click();
  await delay(200);
  // Type text into the editor
  await page.keyboard.type(input);
  await delay(400);
  await page.keyboard.type(' ');
  await delay(200);
  const play = page.locator('.button-cplay').first();
  play.click();

  await checkIfKernelAttached(page);
  
  await page.waitForSelector('.cout', {timeout:timeout});
  await delay(extra);
  const outputCell = page.locator('.cout').first();
  return outputCell;
}


export const clearCell = async (page, timeout=1000) => {
  let inputcell = page.locator('.cin').first();
  await inputcell.waitFor({ state: 'visible' });
  const id = await inputcell.getAttribute('id');

  const menu = page.locator('.button-cmore').first();
  menu.click();
  
  await page.locator('[id="dropdown-float"]').waitFor({ state: 'visible' });
  const clearOutputsButton = page.locator('button[data-name="RemoveCell"]').first();
  await clearOutputsButton.waitFor({ state: 'visible' }); // Ensures it appears
  await clearOutputsButton.click();

  inputcell = page.locator(`[id="${id}"]`);
  await inputcell.waitFor({ state: "detached" })
}