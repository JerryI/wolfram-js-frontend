const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
  handleLogs: (callback) => ipcRenderer.on('push-logs', callback)
})