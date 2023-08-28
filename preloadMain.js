const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
  contextMenu: (callback) => ipcRenderer.on('context', callback)
})

