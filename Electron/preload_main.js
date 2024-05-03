const { contextBridge, ipcRenderer } = require('electron')

const { webFrame } = require('electron')

ipcRenderer.on('zoomIn', () => {
  webFrame.setZoomFactor(webFrame.getZoomFactor() * 1.5)
})

ipcRenderer.on('zoomOut', () => {
  webFrame.setZoomFactor(webFrame.getZoomFactor() / 1.5)
})


contextBridge.exposeInMainWorld('electronAPI', {

  onfocus: (callback) =>  ipcRenderer.on('focus', callback),
  onblur: (callback) => ipcRenderer.on('blur', callback),

  contextMenu: (callback) => ipcRenderer.on('context', callback),
  call: (callback) => ipcRenderer.on('call', callback),



  listener: (name, callback) => ipcRenderer.on(name, callback),

  
  cellop: (callback) => ipcRenderer.on('cellop', callback),

  pluginsMenu: (callback) => ipcRenderer.on('pluginsMenu', callback),
  
  openFinder: (path) => {
    console.log(path);
    ipcRenderer.send('system-open',  path);
  },

  topMenu: (name) => {
    console.log(name);
    ipcRenderer.send('system-menu',  name);
  },

  toggleWindowSize: () => {
    ipcRenderer.send('system-window-toggle',  {});
  },

  harptic: () => {
    ipcRenderer.send('system-harptic',  {});
  },

  enlargeWindowSizeIfneeded: () => {
    ipcRenderer.send('system-window-enlarge-if-needed',  {});
  },

  requestFileWindow: (params, cbk) => {
    ipcRenderer.invoke('system-save-something', params).then((result) => {
      cbk(result);
    });
  },

  requestFolderWindow: (params, cbk) => {
    ipcRenderer.invoke('system-open-folder-something', params).then((result) => {
      cbk(result);
    });
  },

  windowExpand: (path) => {
    console.log(path);
    ipcRenderer.send('system-window-expand',  {});
  },

  windowShrink: (path) => {
    console.log(path);
    ipcRenderer.send('system-window-shrink',  {});
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

