const { app, BrowserWindow, dialog, ipcMain } = require('electron')
const path = require('path')
const { platform } = require('node:process');

const { net } = require('electron')
const fs = require('fs');

const runPath = path.join(__dirname, 'Scripts', 'start.wls');
const workingDir = path.join(__dirname);

const { exec } = require('node:child_process');
const controller = new AbortController();
const { signal } = controller;

const { shell } = require('electron')

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
  })

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
      show: false
    })
  
    win.loadURL(url);
    return win;
}

const showMainWindow = (url) => {
  const win = createWindow(url);
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

  app.on('activate', () => {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) {
      const o = createWindow(url);
      o.once('ready-to-show', () => {
        o.show()
      });
    }
  })
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
        showMainWindow(`http://${match.groups.ip}:${match.groups.port}`);
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

    checkInstalled(startServer);
  }, 500);

  const startServer = () => {
    sender('--- Starting Wolfram Engine ---\n', 'red');
    server = exec('woldframscript', {cwd: workingDir});
    server.stdin.write(`Get["${runPath}"]\n`);
    // server.stdin.end(); // EOF

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


const checkInstalled = (cbk) => {
  sender('checking the installation folder...', 'red');
  sender(app.getAppPath('appData'), 'green');

  const p = path.join(app.getAppPath('appData'), 'package.json');
  if (fs.existsSync(p)) {
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
                    sender('updating...', 'red');
                    installFrontend(cbk);
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
