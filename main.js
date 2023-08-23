const { app, BrowserWindow } = require('electron')

const createWindow = () => {
    const win = new BrowserWindow({
      vibrancy: "sidebar", // in my case...
      frame: true,
      titleBarStyle: 'hiddenInset',
      width: 800,
      height: 600
    })
  
    win.loadURL('http://localhost:8090');
  }

app.whenReady().then(() => {
    createWindow()
  })