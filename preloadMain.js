const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
  contextMenu: (callback) => ipcRenderer.on('context', callback),
  call: (callback) => ipcRenderer.on('call', callback),
  
  openFinder: (path) => {
    ipcRenderer.send('system-open',  decodeURIComponent(path));
  }
})

