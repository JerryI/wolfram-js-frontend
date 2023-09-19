const { session, app, Menu, BrowserWindow, dialog, ipcMain } = require('electron')
const path = require('path')
const { platform } = require('node:process');

const zlib = require('zlib');

const { net } = require('electron')
const fs = require('fs');
const fse = require('fs-extra');

const contextMenu = require('electron-context-menu');

let wasUpdated = false;

let installationFolder;

if (app.isPackaged) {
  installationFolder = path.join(app.getPath('appData'), 'wljs-frontend');
} else {
  installationFolder = app.getAppPath();
}

const params = ["ElectronQ = True;"]

const runPath = path.join(installationFolder, 'Scripts', 'start.wls');

const workingDir = app.getPath('home');

const { exec } = require('node:child_process');
const controller = new AbortController();
const { signal } = controller;

const { shell } = require('electron')

console.log(app.isPackaged);

const getAppBasePath = () => {
  //dev
}

const currentWindow = {};
currentWindow.window = undefined
currentWindow.register = (win) => {
  currentWindow.window = win;
  const ref = win;
  win.on('close', () => {
    if (currentWindow.window == ref) currentWindow.window = undefined
  });
}
currentWindow.call = (type) => {
  if (type === 'New' || type === 'Settings') {
    if (!currentWindow.window) {
      const o = createWindow(globalURL);
      o.once('ready-to-show', () => {
        currentWindow.window.webContents.send('call', type); 
        console.log('send request to a new: '+type);
        o.show();
      });
    } else {
      currentWindow.window.webContents.send('call', type); 
      console.log('send request: '+type);
    }
  } else {
    if (!currentWindow.window) {
      dialog.showMessageBox({message: 'There is no window opened to save something'})
      return;
    }
    currentWindow.window.webContents.send('call', type); 
    console.log('send request: '+type);
  }

  
}

currentWindow.cellop = (type) => {
  currentWindow.window.webContents.send('cellop', type); 
  console.log('send request cells: '+type);
}




const createLogWindow = () => {
  const win = new BrowserWindow({
    vibrancy: "sidebar", // in my case...
    frame: true,
    titleBarStyle: 'hiddenInset',
    width: 600,
    height: 300,
    title: 'Logger',
    webPreferences: {
      preload: path.join(__dirname, 'preload.js')
    }
  });

  win.loadFile('log.html');

  return win;
}

const setHID = (mainWindow) => {
  mainWindow.webContents.session.on('select-hid-device', (event, details, callback) => {
    // Add events to handle devices being added or removed before the callback on
    // `select-hid-device` is called.
    mainWindow.webContents.session.on('hid-device-added', (event, device) => {
      console.log('hid-device-added FIRED WITH', device)
      // Optionally update details.deviceList
    })

    mainWindow.webContents.session.on('hid-device-removed', (event, device) => {
      console.log('hid-device-removed FIRED WITH', device)
      // Optionally update details.deviceList
    })

    event.preventDefault()
    if (details.deviceList && details.deviceList.length > 0) {
      callback(details.deviceList[0].deviceId)
    }
  })

  mainWindow.webContents.session.setPermissionCheckHandler((webContents, permission, requestingOrigin, details) => {
    return true
  })

  mainWindow.webContents.session.setDevicePermissionHandler((details) => {
    return true
  })
}

const createWindow = (url, focus = true, hidefirst = true) => {
    const win = new BrowserWindow({
      vibrancy: "sidebar", // in my case...
      frame: true,
      titleBarStyle: 'hiddenInset',
      width: 800,
      height: 600,
      title: 'Root',
      show: !hidefirst,
      webPreferences: {
        preload: path.join(__dirname, 'preloadMain.js')
      }
      
    });

    win.webContents.on('found-in-page', (event, result) => {
      console.log(result)
    });

    setHID(win);    

    if (focus) {
      currentWindow.register(win);
    win.on('focus', ()=>{
      currentWindow.register(win)
      console.log('focus');
    });
  }

    contextMenu({
      window: win,
      prepend: (defaultActions, parameters, browserWindow) => [
        {
          label: 'Evaluate in place',
          // Only show it when right-clicking images
          visible: parameters.selectionText.trim().length > 0,
          click: (e) => {
            win.webContents.send('context', 'Evaluate');  
            
          }
        },        
        {
          label: 'Iconize',
          // Only show it when right-clicking images
          visible: parameters.selectionText.trim().length > 0,
          click: () => {
            win.webContents.send('context', 'Iconize');  
          }
        },
        {
          label: 'Simplify',
          // Only show it when right-clicking images
          visible: parameters.selectionText.trim().length > 0,
          click: () => {
            win.webContents.send('context', 'Simplify');  
          }
        }        
      ],

      menu: (actions, props, browserWindow, dictionarySuggestions) => [
        ...dictionarySuggestions,
        actions.separator(),
        actions.cut(),
		    actions.copy(),
		    actions.paste(),
        actions.separator(),
        actions.inspect()
      ]
    });    
  
    win.loadURL(url);

    if (wasUpdated) {
      win.webContents.session.clearCache();
      wasUpdated = false;
    }

    return win;
}

let requested = false

const showMainWindow = (url, title = "Root", focusWin = true, hidefirst = true) => {
  let win;

  if (firstTime && !isMac && process.argv[1]) {
    if (process.argv[1].length > 3) {
      app.addRecentDocument(process.argv[1]);
      win = createWindow(url + '?path='+encodeURIComponent(process.argv[1]), focusWin, hidefirst);
    } else {
      win = createWindow(url, focusWin, hidefirst);
    }
  } else if (firstTime && isMac && requested) {
    win = createWindow(url + '?path='+encodeURIComponent(requested), focusWin, hidefirst); 
  } else {
    win = createWindow(url, focusWin, hidefirst);
  }

  firstTime = false;
  
  win.title = title;
  const contents = win.webContents;

  contents.setWindowOpenHandler(({ url }) => {
    console.log(url);
    const u = new URL(url);

    if (u.hostname === (new URL(globalURL)).hostname) {
      let path = u.searchParams.get('path');
      if (!path) {
        path = 'Projector';
        showMainWindow(url, path, false, false);
      } else {
        showMainWindow(url, path, true, false);
      }

      

    } else {
      shell.openExternal(url);
    }
    /*return { action: 'allow', overrideBrowserWindowOptions: {
        vibrancy: "sidebar", // in my case...
        frame: true,
        titleBarStyle: 'hiddenInset',
        width: 600,
        height: 500,
        title: 'Projector',
        webPreferences: {
          preload: path.join(__dirname, 'preloadMain.js')
        }
      } 
    };*/


    return { action: 'deny' };
  });
  
  if (hidefirst) {
    win.once('ready-to-show', () => {
      win.show()
    });
  }
}

let server;

app.on('quit', () => {
  console.log('exiting the server...');
  if (server) server?.stdin?.write(`Exit[]\n`);
  // server.stdin.end(); // EOF
  //server.kill();
})

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
})

app.on('open-file', (ev, path) => {
  ev.preventDefault();
  app.addRecentDocument(path);
  if (firstTime) {
    requested = path;
    return;
  }
  showMainWindow(globalURL + `?path=`+ encodeURIComponent(path), path, true, false);
})

app.on('activate', () => {
  // On macOS it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (BrowserWindow.getAllWindows().length === 0) {
    const o = createWindow(globalURL);
    o.once('ready-to-show', () => {
      o.show()
    });
  }
})

let sender;



const reg = new RegExp(/Open http:\/\/(?<ip>[0-9|.]*):(?<port>[0-9]*) in your browser/);

const subscribe = (server, handler = ()=>{}) => {
  let running = false;

  server.on('error', function( err ){ setTimeout(()=>{
    app.exit();
  }, 3000); throw err;  });

  server.stdout.on('data', (data) => {
    const s = data.toString();
    sender(s);
    if (!running) {
      handler(s);
      const match = reg.exec(s);
      if (match) {
        globalURL = `http://${match.groups.ip}:${match.groups.port}`
        showMainWindow(globalURL);
        running = true;
      }
    }
    
  });
  server.stderr.on('data', (data) => {
    console.log(data.toString());
    
    sender(data.toString());
    handler(data.toString());
  });  
}

const promts = {};

const makePromt = (callback, window) => {
  const id = Math.floor(Math.random()*100.0);
  promts[id] = callback;
  window.webContents.send('promt', id);  
}

const dialogYesNo = (callback, window) => {
  const id = Math.floor(Math.random()*100.0);
  promts[id] = callback;
  window.webContents.send('yesorno', id);  
}

const noscript = new RegExp('command not found');
const nofile = new RegExp('No such file or directory');
const nolicense = new RegExp('Wolfram product is not activated');

const activateWL = (server_, path, callback) => {
  subscribe(exec(`"${path}" -activate`, {cwd: workingDir}));
  setTimeout(callback, 3000);
}

const askForInstallation = (server_, window, cbk) => {
  sender('\n\n Do you have wolframscript installed?', 'magenta');
  dialogYesNo((answer) => {
    if (answer) {
      cbk()
    } else {
      shell.openExternal("https://www.wolfram.com/engine/");
      app.exit();
    }
  }, window)
}

const askForPath = (server_, window) => {
  sender('Please type the path to the Wolframscript manually in the box below', 'red');
  sender('and then - press ENTER being in the field', 'red');

  makePromt((path) => {
    server = exec(`"${path}"`, {cwd: workingDir});

    subscribe(server, (log)=>{
      if (noscript.exec(log) || nofile.exec(log)) {
        sender('FAILED Again!\n\n', 'red');
        

        askForPath(server, window);
      }

      if (nolicense.exec(log)) {
        activateWL(server, path, () => {
          server = exec(`"${path}"`, {cwd: workingDir});

          subscribe(server, (log)=>{
            if (nolicense.exec(log)) {
              sender('\nThere is some problems with your license... We are sorry ;(\n', 'red');
              setTimeout(app.exit, 4000);
            }
          });
          params.forEach((line)=>{
            server.stdin.write(line+'\n');
          });
          server.stdin.write(`Get["${runPath}"]\n`);
          // server.stdin.end(); // EOF
        });
      }
    });    

    params.forEach((line)=>{
      server.stdin.write(line+'\n');
    });
    server.stdin.write(`Get["${runPath}"]\n`);
    // server.stdin.end(); // EOF
  }, window);
}

// Behaviour on the second instance for the parent process
const gotSingleInstanceLock = app.requestSingleInstanceLock();
if (!gotSingleInstanceLock) app.quit();
else {
  app.on('second-instance', (_, argv) => {
    //User requested a second instance of the app.
    //argv has the process.argv arguments of the second instance.
    //on windows IT SENDS --allow-file-access-from-files as a second argument.!!!
    if (app.hasSingleInstanceLock()) {
      showMainWindow(globalURL + `?path=`+ encodeURIComponent(argv[2]), argv[2]);
    }
  });
}

const checkCacheReset = () => {
  if (fs.existsSync(path.join(installationFolder, '.wasupdated'))) {
    fs.unlinkSync(path.join(installationFolder, '.wasupdated'));
    session.defaultSession.clearStorageData();
    session.defaultSession.clearCache();
  
    sender('cache reset!', "red");
  }
} 

let firstTime = true;

app.whenReady().then(() => {
  const win = createLogWindow();

  ipcMain.on('search-text', (event, arg) => {
    let nextRes = arg.direction == 'next' ? true : false
    const requestId = currentWindow.window.webContents.findInPage(arg.searchText, {
        forward: true,
        findNext: nextRes,
        matchCase: false
    });
  });
  
  ipcMain.on('stop-search', (event, arg) => {
    currentWindow.window.webContents.stopFindInPage('clearSelection');
  });  

  //if there was an update to a frontend, it will remove cache.
  const cinterval = setInterval(checkCacheReset, 15000);
  setTimeout(()=>{
    clearInterval(cinterval);
  }, 60*1000*3)

  ipcMain.on('system-open', (e, path) => {
    shell.showItemInFolder(path);
  });

  ipcMain.on('promt-resolve', (e, id, val) => {
    promts[id](val);
    delete promts[id];
  });

  setTimeout(() => {
    sender = (data, color) => {
      win.webContents.send('push-logs', data+'\n', color);
    }

    win.on('close', () => {
      sender = (data) => {console.log(data)}
    });

    checkInstalled(startServer, win);
  }, 500);

  const startServer = () => {
    sender(getAppBasePath());

    sender('--- Starting Wolfram Engine ---\n', 'red');
    server = exec('wolframscript', {cwd: workingDir});

    params.forEach((line)=>{
      server.stdin.write(line+'\n');
    });
    server.stdin.write(`Get["${runPath}"]\n`);
    // server.stdin.end(); // EOF
    sender('waiting for th responce...');
    server.on("error", (err)=>{
      sender(err);
    });

    subscribe(server, (log) => {
        if (noscript.exec(log) || nofile.exec(log)) {
          sender('FAILED!\n\n', 'red');
          sender('trying different combination...\n\n', 'red');

          askForInstallation(server, win, () => {
            switch(platform) {
              case 'darwin':
                server = exec('"/Applications/WolframScript.app/Contents/MacOS/wolframscript"', {cwd: workingDir});

                params.forEach((line)=>{
                  server.stdin.write(line+'\n');
                });
                server.stdin.write(`Get["${runPath}"]\n`);
                // server.stdin.end(); // EOF
            
                subscribe(server, (log)=>{
                  if (noscript.exec(log) || nofile.exec(log)) {
                    sender('FAILED Again!\n\n', 'red');


                    askForPath(server, win);
                  }

                  if (nolicense.exec(log)) {
                    activateWL(server, "/Applications/WolframScript.app/Contents/MacOS/wolframscript", () => {
                      server = exec("/Applications/WolframScript.app/Contents/MacOS/wolframscript", {cwd: workingDir});
                    
                      subscribe(server, (log)=>{
                        if (nolicense.exec(log)) {
                          sender('\nThere is some problems with your license... We are sorry ;(\n', 'red');
                          setTimeout(app.exit, 4000);
                        }
                      });

                      params.forEach((line)=>{
                        server.stdin.write(line+'\n');
                      });
                    
                      server.stdin.write(`Get["${runPath}"]\n`);
                      // server.stdin.end(); // EOF
                    });
                  }
                });

              break;

              default:
                askForPath(server, win);
            }
          });
        }

        if (nolicense.exec(log)) {
          activateWL(server, `wolframscript`, () => {
            server = exec(`wolframscript`, {cwd: workingDir});
  
            subscribe(server, (log)=>{
              if (nolicense.exec(log)) {
                sender('\nThere is some problems with your license... We are sorry ;(\n', 'red');
                setTimeout(app.exit, 4000);
              }
            });

            params.forEach((line)=>{
              server.stdin.write(line+'\n');
            });
  
            server.stdin.write(`Get["${runPath}"]\n`);
            // server.stdin.end(); // EOF
          });
        }
    });

  };
})


const checkInstalled = (cbk, window) => {
  sender('checking the installation folder...', 'red');
  sender(app.getPath('appData'), 'green');

  const p = path.join(installationFolder, 'package.json');
  const script = path.join(installationFolder, 'Scripts', 'run.wls');
  if (fs.existsSync(script)) {
    fs.readFile(p, (err, raw) => {
      if (err) throw err;
      let data = JSON.parse(raw);
      sender('current version: ' + data["version"], 'green');

      const version = parseInt(data["version"].replaceAll(/\./gm, ''));

      const timer = setTimeout(() => {
        sender('No internet. Passive mode', 'red');
        cbk();
      }, 5000);

      const test = net.fetch('https://github.com')
      test.then((result)=>{
        if (result.status === 200) {
          clearTimeout(timer);
          const request = net.fetch('https://raw.githubusercontent.com/JerryI/wolfram-js-frontend/master/package.json')
          request.then((result)=>{
            if (result.status === 200) {
              console.log(result);
    
              result.text().then((data) => {
    
                console.log(data);
                const remote = JSON.parse(data);
                if (remote["version"]) {
                  const rersion = parseInt(remote["version"].replaceAll(/\./gm, ''));
                  if (rersion > version) {
                    sender('\nDo you want me to install a new version?', 'blue');
                    sender('-- WARNING: it will purge wl_packages and Package folders!      --', 'red');
                    sender('-- please, make a backup of your local packages if you have one --', 'red');
                    dialogYesNo((answer)=>{
                      if (answer === true) {
                        installFrontend(cbk);
                      } else {
                        cbk();
                      }
                    }, window);
                    
                    
                  } else {
                    sender('You are using the most recent one!', 'red');
                    cbk();
                  }
                } else {
                  sender('note possible to check updates', 'magenta');
                  cbk();
                }
              })
            } else {
              sender('Unable to check updates! Reason:', 'red');
              sender('status code '+result.status, 'green');
              cbk();          
            }
          },
            (rejection) => {
              sender('Unable to check updates! Reason:', 'red');
              sender(JSON.stringify(rejection), 'green');
              cbk();
            }
    
          );
        }
       }
      );


  });
  } else {
    sender('looks like it is not installed...', 'red');
    installFrontend(cbk);
  }
}



const installFrontend = (cbk) => {
  wasUpdated = true;
  sender('downloading zip to '+installationFolder+'...', 'red');

  const pathToFile = path.join(installationFolder, 'pkg.zip');

  downloadFile('https://api.github.com/repos/JerryI/wolfram-js-frontend/zipball/master', pathToFile, (file) => {
    sender('unzipping...', 'red');

    
    const extracted = path.join(installationFolder, 'extracted');
   
    if (!fs.existsSync(extracted)) {
      fs.mkdirSync(extracted);
    } else {
      fs.rmSync(extracted, { recursive: true, force: true });
      fs.mkdirSync(extracted);
    }

    const StreamZip = require('node-stream-zip');
    const zip = new StreamZip.async({ file: file });

    const count = zip.extract(null, extracted).then((res)=>{
      console.log(res);
      sender('extracted!', 'red');

      zip.close();
      fs.unlinkSync(file);

      const sub = fs.readdirSync(extracted)[0];
      sender(sub);
      //fs.unlinkSync(path.join(extracted, sub, 'main.js'));
      if (fs.existsSync(path.join(extracted, sub, '.git'))) fs.rmSync(path.join(extracted, sub, '.git'), { recursive: true, force: true });
      sender('.git was removed');

      if(fs.existsSync(path.join(installationFolder, 'Examples'))) {
        fs.rmSync(path.join(installationFolder, 'Examples'), { recursive: true, force: true });
      }
      sender('Examples was removed');
      
      sender('copying to asar folder...');
      fse.copySync(path.join(extracted, sub), installationFolder, { overwrite: true });
      sender('done!');

      const toremove = ['.thumbnails', '.settings', 'wl_packages_lock.wl'];
      const dirtoremove = ['Packages', 'wl_packages'];

      sender('removing Packages...');
      sender('removing wl_packages...');

      toremove.forEach((p) => {
          if(fs.existsSync(path.join(installationFolder, p))) {
            fs.unlinkSync(path.join(installationFolder, p));
          }
      });

      dirtoremove.forEach((p) => {
        if(fs.existsSync(path.join(installationFolder, p))) {
          fs.rmSync(path.join(installationFolder, p), { recursive: true, force: true });
        }
      });     
      
      session.defaultSession.clearStorageData();
      session.defaultSession.clearCache();

      sender('done!');

      fs.rmSync(extracted, { recursive: true, force: true });

      sender('temp folder was removed!');

      cbk();

    })
 
  });

}

function downloadFile(file_url , targetPath, cbk){
  // Save variable to know progress
  var received_bytes = 0;
  var total_bytes = 0;

  const ft = net.request(file_url);

  var out = fs.createWriteStream(targetPath);
  //req.pipe(out);

  ft.on('response', (responce) => {
      // Change the total bytes value to get progress later.
      console.log(responce.headers);
      total_bytes = parseInt(responce.headers['content-length' ]);
      console.log(total_bytes);

      responce.pipe(out);

      responce.on('data', function(chunk) {
        // Update the received bytes
        received_bytes += chunk.length;
  
        showProgress(received_bytes, total_bytes);
      });
  
      responce.on('end', function() {
        sender("File succesfully downloaded", 'green');
        

        cbk(targetPath);
      });      
  });



  ft.end()
}

function showProgress(received,total){
  var percentage = (received * 100) / total;
  sender(percentage + "% | " + received + " bytes out of " + total + " bytes.", 'red');
}

const isMac = process.platform === 'darwin'

  const template = [
    // { role: 'appMenu' }
    ...(isMac
      ? [{
          label: app.name,
          submenu: [
            { role: 'about' },
            { type: 'separator' },
            { role: 'services' },
            { type: 'separator' },
            { role: 'hide' },
            { role: 'hideOthers' },
            { role: 'unhide' },
            { type: 'separator' },
            { role: 'quit' }
          ]
        }]
      : []),
    // { role: 'fileMenu' }
    {
      label: 'File',
      submenu: [
        {
          label: 'New',
          accelerator: process.platform === 'darwin' ? 'Cmd+N' : 'Ctrl+N',
          click: async (ev) => {
            console.log(ev);
            currentWindow.call('New'); 
          }
        },
        {
          label: 'Open File',
          accelerator: process.platform === 'darwin' ? 'Cmd+O' : 'Ctrl+O',
          click: async () => {
            const promise = dialog.showOpenDialog({title: 'Open File', filters: [
              { name: 'Notebooks', extensions: ['wln'] }
            ], properties: ['openFile']});
            
            promise.then((res) => {
              if (!res.canceled) {
                app.addRecentDocument(res.filePaths[0]);
                showMainWindow(globalURL + `?path=`+ encodeURIComponent(res.filePaths[0]), res.filePaths[0]);
              }
            });
          }
        },      
        {
          label: 'Open Folder',
          
          click: async () => {
            const promise = dialog.showOpenDialog({title: 'Open Vault', properties: ['openDirectory']});
            promise.then((res) => {
              if (!res.canceled) {
                app.addRecentDocument(res.filePaths[0]);
                showMainWindow(globalURL + `?path=`+ encodeURIComponent(res.filePaths[0]), res.filePaths[0]);
              }
            });
          }
        },
        {
          label: "Open Recent",
          role: "recentdocuments",
          submenu:[
            {
              label: "Clear Recent",
              role: "clearrecentdocuments"
            }
          ]
        },
        {
          label: 'Save',
          accelerator: process.platform === 'darwin' ? 'Cmd+S' : 'Ctrl+S',
          click: async (ev) => {
            console.log(ev);
            currentWindow.call('Save'); 
          }
        },
        { type: 'separator' },
        {
          label: 'Share',
          submenu: [
            {
              label: 'HTML',
              click: async (ev) => {
                currentWindow.call('ShareHTML'); 
              }
            },

            {
              label: 'React',
              click: async (ev) => {
                currentWindow.call('ShareReact'); 
              }
            }
          ]
        },
        { type: 'separator' },        
        {
          label: 'Open Examples',
          click: async (ev) => {
            showMainWindow(globalURL + `?path=`+ encodeURIComponent(path.join(installationFolder, 'Examples')), 'Examples');
          }
        },    
        {
          label: 'Locate AppData',
          click: async (ev) => {
            console.log(ev);
            shell.showItemInFolder(installationFolder);
          }
        },             
        //win.webContents.send('context', 'Iconize');  
        isMac ? { role: 'close' } : { role: 'quit' }
      ]
    },
    // { role: 'editMenu' }
    {
      label: 'Edit',
      submenu: [
        { role: 'undo' },
        { role: 'redo' },
        { type: 'separator' },
        { role: 'cut' },
        { role: 'copy' },
        { role: 'paste' },
        { type: 'separator' },
        {
          label: 'Find',
          accelerator: process.platform === 'darwin' ? 'Cmd+F' : 'Ctrl+F',
          click: (ev) => {
            currentWindow.call('Find'); 
          }
        }, 
        { type: 'separator' },
        {
          label: 'Hide/Unhide cell',
          accelerator: process.platform === 'darwin' ? 'Cmd+2' : 'Super+2',
          click: async (ev) => {
            console.log(ev);
            currentWindow.cellop('HC'); 
          }
        }, 
        {
          label: 'Hide/Unhide upper cell',
          accelerator: process.platform === 'darwin' ? 'Cmd+1' : 'Super+1',
          click: async (ev) => {
            console.log(ev);
            currentWindow.cellop('HUC'); 
          }
        },  
        {
          label: 'Hide/Unhide down cell',
          accelerator: process.platform === 'darwin' ? 'Cmd+3' : 'Super+3',
          click: async (ev) => {
            console.log(ev);
            currentWindow.cellop('HLC'); 
          }
        },               
        { type: 'separator' },       
        ...(isMac
          ? [
              { role: 'pasteAndMatchStyle' },
              { role: 'delete' },
              { role: 'selectAll' },
              { type: 'separator' },
              {
                label: 'Speech',
                submenu: [
                  { role: 'startSpeaking' },
                  { role: 'stopSpeaking' }
                ]
              }
            ]
          : [
              { role: 'delete' },
              { type: 'separator' },
              { role: 'selectAll' }
            ])
      ]
    },
    // { role: 'windowMenu' }
    {
      label: 'Window',
      submenu: [
        { role: 'reload' },
        { role: 'forceReload' },
        { role: 'toggleDevTools' },
        { type: 'separator' },        
        { role: 'minimize' },
        { role: 'zoom' },
        ...(isMac
          ? [
              { type: 'separator' },
              { role: 'front' },
              { type: 'separator' },
              { role: 'window' }
            ]
          : [
              { role: 'close' }
            ])
      ]
    },

    {
      label: 'Evaluation',
      submenu: [
        {
          label: 'Abort',
          accelerator: process.platform === 'darwin' ? 'Cmd+.' : 'Super+.',
          click: async (ev) => {
            console.log(ev);
            currentWindow.call('Abort'); 
          }
        }, 
        
        {
          label: 'Evaluate Initializing Cells',
          accelerator: process.platform === 'darwin' ? 'Cmd+i' : 'Super+i',
          click: async (ev) => {
            console.log(ev);
            currentWindow.call('EIC'); 
          }
        },    

        {
          label: 'Evaluate All Cells',
          accelerator: process.platform === 'darwin' ? 'Cmd+a' : 'Super+a',
          click: async (ev) => {
            console.log(ev);
            currentWindow.call('EAC'); 
          }
        },    

        { type: 'separator' }, 

        {
          label: 'Kernel',
          submenu: [
            {
              label: 'Start',
              click: async (ev) => {
                console.log(ev);
                currentWindow.call('LocalKernelStart'); 
              }
            },   
            {
              label: 'Stop',
              click: async (ev) => {
                console.log(ev);
                currentWindow.call('LocalKernelExit'); 
              }
            }, 
            {
              label: 'Restart',
              click: async (ev) => {
                console.log(ev);
                currentWindow.call('LocalKernelRestart'); 
              }
            }                                  
          ]
        }
      ]
    },    

    {
      label: 'Misc',
      submenu: [
      {
        label: 'Settings',
        click: async (ev) => {
          console.log(ev);
          currentWindow.call('Settings'); 
        }
      },
      {
        role: 'help',
        label: 'Learn More',
        click: async () => {
          const { shell } = require('electron')
          await shell.openExternal('https://jerryi.github.io/wljs-docs/docs/frontend/instruction')
        }
      }
      ]
    }
  ];

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
