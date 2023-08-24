const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
  handleLogs: (callback) => ipcRenderer.on('push-logs', callback),
  addPromt: (callback) => ipcRenderer.on('promt', callback),
  addDialog: (callback) => ipcRenderer.on('yesorno', callback),
  resolveInput: (id, data) => {
    // Send IPC event to main process to read the file.
    ipcRenderer.send('promt-resolve', id, data)
  }
})

