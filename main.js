const { app, BrowserWindow } = require('electron')
const path = require('path')

const runPath = path.join(__dirname, 'Scripts', 'run.wls');

const { spawn } = require('node:child_process');
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

app.whenReady().then(() => {
  const win = createLogWindow();

  sender = (data) => {
    win.webContents.send('push-logs', data);
  }

  win.on('close', () => {
    sender = (data) => {console.log(data)}
  });

  let running = false;

  sender('--- Starting Wolfram Engine ---');
  server = spawn('wolframscript', ['-f', runPath]);
  server.on('error', function( err ){ setTimeout(()=>{
    app.exit();
  }, 3000); throw err;  });

  server.stdout.on('data', (data) => {
    const s = data.toString();
    if (!running) {
      const match = reg.exec(s);
      if (match) {
        showMainWindow(`http://${match.groups.ip}:${match.groups.port}`);
        running = true;
      }
    }
    sender(s);
  });
  server.stderr.on('data', (data) => {
    console.log(data.toString());
    sender(data.toString());
  });  
    //
})