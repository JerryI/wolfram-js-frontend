//@ts-check
const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
  load: (callback) => ipcRenderer.on('load', callback), 
  choise: (choise) => {
    ipcRenderer.send('choise_hid', choise)
  }
})
