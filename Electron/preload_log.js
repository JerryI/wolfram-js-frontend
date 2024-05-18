const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
  handleLogs: (callback) => ipcRenderer.on('push-logs', callback),
  addPromt: (callback) => ipcRenderer.on('promt', callback),
  updateInfo: (callback) => ipcRenderer.on('info', callback),
  updateVersion: (callback) => ipcRenderer.on('version', callback),
  addDialog: (callback) => ipcRenderer.on('yesorno', callback),
  clear: (callback) => ipcRenderer.on('clear', callback),
  locateLogFile: () => {
    ipcRenderer.send('locate-logfile', id, data)
  },
  resolveInput: (id, data) => {
    // Send IPC event to main process to read the file.
    ipcRenderer.send('promt-resolve', id, data)
  }
})
