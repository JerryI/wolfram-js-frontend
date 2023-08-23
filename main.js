const { app, BrowserWindow, dialog, ipcMain } = require('electron')
const path = require('path')
const { platform } = require('node:process');

const runPath = path.join(__dirname, 'Scripts', 'run.wls');
const workingDir = path.join(__dirname);

const { exec } = require('node:child_process');
const controller = new AbortController();
const { signal } = controller;


const createLogWindow = () => {
  const win = new BrowserWindow({
    vibrancy: "sidebar", // in my case...
    frame: true,
    titleBarStyle: 'hiddenInset',
    width: 600,
    height: 300,
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
      show: false
    })
  
    win.loadURL(url);
    return win;
}

const showMainWindow = (url) => {
  const win = createWindow(url);
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
  server.kill('SIGKILL');
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

const noscript = new RegExp('command not found');
const nofile = new RegExp('No such file or directory');
const nolicense = new RegExp('Wolfram product is not activated');

const activateWL = (server_, path, callback) => {
  subscribe(exec(`"${path}" -activate`, {cwd: workingDir}));
  setTimeout(callback, 3000);
}

const askForPath = (server_, window) => {
  sender('Please type the path to the Wolframscript manually in the box below');
  sender('and then - press ENTER being in the field');

  makePromt((path) => {
    server = exec(`"${path}"`, {cwd: workingDir});

    subscribe(server, (log)=>{
      if (noscript.exec(log) || nofile.exec(log)) {
        sender('FAILED Again!\n\n');
        

        askForPath(server, window);
      }

      if (nolicense.exec(log)) {
        activateWL(server, path, () => {
          server = exec(`"${path}"`, {cwd: workingDir});

          subscribe(server, (log)=>{
            if (nolicense.exec(log)) {
              sender('\nThere is some problems with your license... We are sorry ;(\n');
              setTimeout(app.exit, 4000);
            }
          });

          server.stdin.write(`Get["${runPath}"]\n`);
          server.stdin.end(); // EOF
        });
      }
    });    

    server.stdin.write(`Get["${runPath}"]\n`);
    server.stdin.end(); // EOF
  }, window);
}

app.whenReady().then(() => {
  const win = createLogWindow();

  ipcMain.on('promt-resolve', (e, id, val) => {
    promts[id](val);
    delete promts[id];
  })

  setTimeout(() => {
    sender = (data) => {
      win.webContents.send('push-logs', data);
    }

    win.on('close', () => {
      sender = (data) => {console.log(data)}
    });

    sender('--- Starting Wolfram Engine ---\n');
    server = exec('wolframscript', {cwd: workingDir});
    server.stdin.write(`Get["${runPath}"]\n`);
    server.stdin.end(); // EOF

    subscribe(server, (log) => {
        if (noscript.exec(log) || nofile.exec(log)) {
          sender('FAILED!\n\n');
          sender('trying different combination...\n\n');

          switch(platform) {
            case 'darwin':
              server = exec('"/Applications/WolframScript.app/Contents/MacOS/wolframscript"', {cwd: workingDir});
              server.stdin.write(`Get["${runPath}"]\n`);
              server.stdin.end(); // EOF
    
              subscribe(server, (log)=>{
                if (noscript.exec(log) || nofile.exec(log)) {
                  sender('FAILED Again!\n\n');
                  

                  askForPath(server, win);
                }
              });

            break;

            default:
              askForPath(server, win);
          }
        }
    });

  }, 500);
})

