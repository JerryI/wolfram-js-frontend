const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('electronAPI', {
  contextMenu: (callback) => ipcRenderer.on('context', callback),
  call: (callback) => ipcRenderer.on('call', callback),
  cellop: (callback) => ipcRenderer.on('cellop', callback),

  pluginsMenu: (callback) => ipcRenderer.on('pluginsMenu', callback),
  
  openFinder: (path) => {
    ipcRenderer.send('system-open',  decodeURIComponent(path));
  },
  
  searchText: (searchText, direction) => ipcRenderer.send('search-text', { searchText, direction }),
  stopSearch: () => ipcRenderer.send('stop-search')
})

function search(direction) {
  let searched = document.getElementById("searchInput").value.trim();
  if(searched.length > 0){
      window.electronAPI.searchText(searched,direction)
  }                
  document.getElementById("searchInput").focus()
}

