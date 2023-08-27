const { app, Menu, BrowserWindow, dialog, ipcMain } = require('electron')
const path = require('path')
const { platform } = require('node:process');

const zlib = require('zlib');

const { net } = require('electron')
const fs = require('fs');
const fse = require('fs-extra');


let wasUpdated = false;

let installationFolder;

if (app.isPackaged) {
  installationFolder = path.join(app.getPath('appData'), 'wljs-frontend');
} else {
  installationFolder = app.getAppPath();
}

const runPath = path.join(installationFolder, 'Scripts', 'start.wls');

const workingDir = app.getPath('home');

const { exec } = require('node:child_process');
const controller = new AbortController();
const { signal } = controller;

const { shell } = require('electron')

console.log(app.isPackaged);

const getAppBasePath = () => {
  //dev
if (process.env.RUN_ENV === 'development') return './'

if (!process.platform || !['win32', 'darwin'].includes(process.platform)) {
  console.error(`Unsupported OS: ${process.platform}`)
  return './'
}
  //prod
if (process.platform === 'darwin') {
  console.log('Mac OS detected')
  return `/Users/${process.env.USER}/Library/Application\ Support/wolfram-js-frontend/`
} else if (process.platform === 'win32') {
  console.log('Windows OS detected')
  return `${process.env.LOCALAPPDATA}\\wolfram-js-frontend\\`
}
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

const createWindow = (url) => {
    const win = new BrowserWindow({
      vibrancy: "sidebar", // in my case...
      frame: true,
      titleBarStyle: 'hiddenInset',
      width: 800,
      height: 600,
      title: 'Root',
      show: false,
      
    })
  
    win.loadURL(url);

    if (wasUpdated) {
      win.webContents.session.clearCache();
      wasUpdated = false;
    }

    return win;
}

const showMainWindow = (url, title = "Root") => {
  const win = createWindow(url);
  win.title = title;
  const contents = win.webContents;

  contents.setWindowOpenHandler(({ url }) => {
    console.log(url);

    return { action: 'allow', overrideBrowserWindowOptions: {
      vibrancy: "sidebar", // in my case...
      frame: true,
      titleBarStyle: 'hiddenInset',
      width: 600,
      height: 500,
      title: 'Projector'
      

    } };
  });
  

  win.once('ready-to-show', () => {
    win.show()
  });
}

let server;

app.on('quit', () => {
  console.log('exiting the server...');
  server.stdin.write(`Exit[]\n`);
  // server.stdin.end(); // EOF
  //server.kill();
})

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit()
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

          server.stdin.write(`Get["${runPath}"]\n`);
          // server.stdin.end(); // EOF
        });
      }
    });    

    server.stdin.write(`Get["${runPath}"]\n`);
    // server.stdin.end(); // EOF
  }, window);
}

app.whenReady().then(() => {



  const win = createLogWindow();

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


      
      sender('copying to asar folder...');
      fse.copySync(path.join(extracted, sub), installationFolder, { overwrite: true });
      sender('done!');

      const toremove = ['.packages', 'wl_packages_lock.wl'];
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
        label: 'Open File',
        click: async () => {
          const promise = dialog.showOpenDialog({title: 'Open File', properties: ['openFile']});
          promise.then((res) => {
            if (!res.canceled) {
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
              showMainWindow(globalURL + `?path=`+ encodeURIComponent(res.filePaths[0]), res.filePaths[0]);
            }
          });
        }
      },
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
  // { role: 'viewMenu' }
  {
    label: 'View',
    submenu: [
      { role: 'reload' },
      { role: 'forceReload' },
      { role: 'toggleDevTools' },
      { type: 'separator' },
      { role: 'resetZoom' },
      { role: 'zoomIn' },
      { role: 'zoomOut' },
      { type: 'separator' },
      { role: 'togglefullscreen' }
    ]
  },
  // { role: 'windowMenu' }
  {
    label: 'Window',
    submenu: [
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
    role: 'help',
    submenu: [
      {
        label: 'Learn More',
        click: async () => {
          const { shell } = require('electron')
          await shell.openExternal('https://electronjs.org')
        }
      }
    ]
  }
]

const menu = Menu.buildFromTemplate(template)
Menu.setApplicationMenu(menu)
