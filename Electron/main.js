const { session, app, Tray, Menu, BrowserWindow, dialog, ipcMain, nativeTheme } = require('electron')
const { screen} = require('electron/main')

const path = require('path')
const { platform } = require('node:process');




const zlib = require('zlib');

const {powerMonitor } = require('electron')

const { net } = require('electron')
const fs = require('fs');
const fse = require('fs-extra');

const { powerSaveBlocker } = require('electron')

let powerSaveId;

const contextMenu = require('electron-context-menu');
const contextMenuExtensions = [];

const { exec } = require('node:child_process');
const controller = new AbortController();
const { signal } = controller;

const { shell } = require('electron')

const { PARAMS, VALUE, MicaBrowserWindow, IS_WINDOWS_11, WIN10 } = require('mica-electron');

const isWindows = process.platform === 'win32'
const isMac = process.platform === 'darwin'


let trackpadUtils = {
    onForceClick: () => {},
    triggerFeedback: () => {}
};
if (isMac) trackpadUtils = require("electron-trackpad-utils");

//all routes to important folders
let installationFolder;

//check if it is working from the repo folder of not
if (app.isPackaged) {
    installationFolder = path.join(app.getPath('appData'), 'wljs-notebook');
} else {
    installationFolder = app.getAppPath();
}

const runPath = path.join(installationFolder, 'Scripts', 'start.wls');
const workingDir = app.getPath('home');

trackpadUtils.onForceClick(() => {
	console.log("onForceClick");
});


//fetch contex menus items from wljs_packages folder

let tray;

/* extesions for contex menu */
const pluginsMenu = {};

pluginsMenu.items = [];
pluginsMenu.fetch = () => {
    if (!fs.existsSync(path.join(installationFolder, 'wljs_packages'))) return;

    fs.readdirSync(path.join(installationFolder, 'wljs_packages'), { withFileTypes: true }).filter(item => item.isDirectory()).map(item => {
        const p = path.join(installationFolder, 'wljs_packages', item.name, 'package.json');
        if (fs.existsSync(p)) {
            const package = JSON.parse(fs.readFileSync(p, 'utf8'));
            if (package["wljs-meta"]["menu"]) {
                package["wljs-meta"]["menu"].forEach(mi => {
                    const mitem = {
                        label: mi["label"],
                        click: async(ev) => {
                            console.log(ev);
                            windows.focused.call('extension', mi["event"]);
                        }
                    };

                    if (mi["accelerator"]) {
                        mitem.accelerator = isMac ? mi["accelerator"][0] : mi["accelerator"][1];
                    }

                    pluginsMenu.items.push(mitem);
                });
            }

            if (package["wljs-meta"]["contextMenu"]) {
                package["wljs-meta"]["contextMenu"].forEach(mi => {
                    const mitem = {
                        label: mi["label"],
                        event: mi["event"],
                        visible: true,
                    };

                    if (mi["visible"]) {
                        mitem.visible = mi["visible"];
                    }

                    contextMenuExtensions.push(mitem);
                });
            }
        }
    })
}


//load shortcuts
const shortcuts_table = require("./shortcuts.json");
const { spawnSync, spawn } = require('child_process');
const shortcut = (id) => {
    console.log('shortcut required');
    if (process.platform === 'darwin') return shortcuts_table[id][0]
    return shortcuts_table[id][1]
}


//build TOP MENU

const callFakeMenu = {}

const buildMenu = (opts) => {
    //default options
    const defaults = {
        footermenu: [],
        localmenu: true,
        plugins: []
    };

    const options = Object.assign({}, defaults, opts);

    const template = [
        // { role: 'appMenu' }
        ...(isMac ? [{
            label: app.name,
            submenu: [
                { role: 'about' },
                { type: 'separator' },
                { role: 'hide' },
                { role: 'hideOthers' },
                { role: 'unhide' },
                { type: 'separator' },
                ...(options.footermenu),
                { role: 'quit' }
            ]
        }] : []),
        // { role: 'fileMenu' }
        {
            label: 'File',
            submenu: [{
                    label: 'New',
                    accelerator: shortcut('new_file'),
                    click: async(ev) => {
                        console.log(ev);
                        windows.focused.call('newnotebook', true);
                    }
                },
                ...((options.localmenu) ? [{
                        label: 'Open File',
                        accelerator: shortcut('open_file'),
                        click: async() => {
                            const promise = dialog.showOpenDialog({
                                title: 'Open File',
                                filters: [
                                    { name: 'Notebooks', extensions: ['wln'] }
                                ],
                                properties: ['openFile']
                            });

                            promise.then((res) => {
                                if (!res.canceled) {
                                    app.addRecentDocument(res.filePaths[0]);
                                    create_window({url: server.url.default('local') + `/` + encodeURIComponent(res.filePaths[0]), title: res.filePaths[0]});
                                }
                            });
                        }
                    },
                    {
                        label: 'Open Folder',

                        click: async() => {
                            const promise = dialog.showOpenDialog({ title: 'Open Vault', properties: ['openDirectory'] });
                            promise.then((res) => {
                                if (!res.canceled) {
                                    app.addRecentDocument(res.filePaths[0]);
                                    create_window({url: server.url.default('local') + `/` + encodeURIComponent(res.filePaths[0]), title: res.filePaths[0]});
                                }
                            });
                        }
                    },
                    {
                        label: "Open Recent",
                        role: "recentdocuments",
                        submenu: [{
                            label: "Clear Recent",
                            role: "clearrecentdocuments"
                        }]
                    }
                ] : []),
                { type: 'separator' },
                {
                    label: 'Save',
                    accelerator: shortcut('save'),
                    click: async(ev) => {
                        console.log(ev);
                        windows.focused.call('save', true);
                    }
                },
                {
                    label: 'Save As',
                    click: async() => {
                        const promise = dialog.showSaveDialog({ title: 'Save as', properties: ['createDirectory'], filters: [
                            { name: 'Notebooks', extensions: ['wln'] }
                        ],});
                        promise.then((res) => {
                            if (!res.canceled) {
                                app.addRecentDocument(res.filePath);
                                console.log(res.filePath);
                                windows.focused.call('saveas', encodeURIComponent(res.filePath) );
                            }
                        });
                    }
                },
                /*{ type: 'separator' },
                {
                    label: 'Share',
                    submenu: [{
                            label: 'HTML',
                            click: async(ev) => {
                                windows.focused.call('share', 'HTML');
                            }
                        },

                        {
                            label: 'React',
                            click: async(ev) => {
                                windows.focused.call('share', 'React');
                            }
                        }
                    ]
                },*/
                ...((options.localmenu) ? [{ type: 'separator' },
                    {
                        label: 'Open Examples',
                        click: async(ev) => {
                            create_window({url: server.url.default('local') + `/` + encodeURIComponent(path.join(installationFolder, 'Examples')), title: 'Examples'});
                        }
                    },

                    {
                        label: 'Reopen in browser',
                        click: (ev) => {
                            server.browserMode = true;
                            shell.openExternal(windows.focused.win.webContents.getURL());
                        }
                    },
                    {
                        label: 'Locate AppData',
                        click: async(ev) => {
                            console.log(ev);
                            shell.showItemInFolder(installationFolder);
                        }
                    }
                ] : []),
                //win.webContents.send('context', 'Iconize');
                ...(isMac ? [{ role: 'close' }] : [{ type: 'separator' }, ...(options.footermenu), { role: 'quit' }])
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
                /*{ type: 'separator' },
                {
                    label: 'Find',
                    accelerator: shortcut('find'),
                    click: (ev) => {
                        windows.focused.call('Find');
                    }
                },*/
                { type: 'separator' },
                {
                    label: 'Hide/Unhide cell',
                    accelerator: shortcut('toggle_cell'),
                    click: async(ev) => {
                        console.log(ev);
                        windows.focused.call('togglecell');
                    }
                },
                {
                    label: 'Unhide All Cells',
                    click: async(ev) => {
                        console.log(ev);
                        windows.focused.call('unhideallcells', true);
                    }
                },

                { type: 'separator' },
                {
                    label: 'Delete cell',
                    accelerator: shortcut('delete_cell'),
                    click: async(ev) => {
                        console.log(ev);
                        windows.focused.call('deletecell', true);
                    }
                },
                { type: 'separator' },
                ...(isMac ? [
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
                ] : [
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
                {
                    label: 'Always on top',
                    click: async(ev) => {
                        console.log(ev);
                        if (windows.focused.win.isAlwaysOnTop()) {
                            windows.focused.win.setAlwaysOnTop(false);
                        } else {
                            windows.focused.win.setAlwaysOnTop(true);
                        }
                    }
                },
                { type: 'separator' },
                { role: 'resetZoom' },
                { role: 'zoomIn' },
                { role: 'zoomOut' },
                { type: 'separator' },
                { role: 'togglefullscreen' },
                ...(isMac ? [
                    { type: 'separator' },
                    { role: 'front' },
                    { type: 'separator' },
                    { role: 'window' }
                ] : [
                    { role: 'close' }
                ])
            ]
        },

        {
            label: 'Evaluation',
            submenu: [{
                    label: 'Abort',
                    accelerator: shortcut('abort'),
                    click: async(ev) => {
                        console.log(ev);
                        windows.focused.call('abort', true);
                    }
                },

                {
                    label: 'Evaluate Initializing Cells',
                    accelerator: shortcut('evaluate_init'),
                    click: async(ev) => {
                        console.log(ev);
                        windows.focused.call('evaluateinit', true);
                    }
                },

                {
                    label: 'Clear Output Cells',
                    accelerator: shortcut('clear_outputs'),
                    click: async(ev) => {
                        console.log(ev);
                        windows.focused.call('clearoutputs', true);
                    }
                },

                {
                    label: 'Change Kernel',
                    click: async(ev) => {
                        console.log(ev);
                        windows.focused.call('changekernel', true);
                    }
                },

                { type: 'separator' },

                {
                    label: 'Kernel',
                    submenu: [{
                            label: 'New Local Kernel',
                            click: async(ev) => {
                                console.log(ev);
                                windows.focused.call('newlocalkernel', true);
                            }
                        },
                        {
                            label: 'New Master Kernel',
                            click: async(ev) => {
                                console.log(ev);
                                windows.focused.call('newmasterkernel', true);
                            }
                        },
                        {
                            label: 'Restart',
                            click: async(ev) => {
                                console.log(ev);
                                windows.focused.call('restartkernel', true);
                            }
                        }
                    ]
                }
            ]
        },

        {
            label: 'Misc',
            submenu: [{
                    label: 'Settings',
                    click: async(ev) => {
                        console.log(ev);
                        windows.focused.call('settings', true);
                    }
                },

                { type: 'separator' },

                ...options.plugins,
                {
                    role: 'help',
                    label: 'Documentation',
                    click: async() => {
                        //const { shell } = require('electron')
                        shell.openExternal('http://127.0.0.1:20540')
                    }
                }
            ]
        }
    ];

    const menu = Menu.buildFromTemplate(template);
    Menu.setApplicationMenu(menu);
}

callFakeMenu["openFile"] = async () => {
    const promise = dialog.showOpenDialog({
        title: 'Open File',
        filters: [
            { name: 'Notebooks', extensions: ['wln'] }
        ],
        properties: ['openFile']
    });

    promise.then((res) => {
        if (!res.canceled) {
            app.addRecentDocument(res.filePaths[0]);
            create_window({url: server.url.default('local') + `/` + encodeURIComponent(res.filePaths[0]), title: res.filePaths[0]});
        }
    });
}

callFakeMenu["openFolder"] = async () => {
    const promise = dialog.showOpenDialog({ title: 'Open Vault', properties: ['openDirectory'] });
    promise.then((res) => {
        if (!res.canceled) {
            app.addRecentDocument(res.filePaths[0]);
            create_window({url: server.url.default('local') + `/` + encodeURIComponent(res.filePaths[0]), title: res.filePaths[0]});
        }
    });
}

callFakeMenu["Save"] = async () => {
    windows.focused.call('save', true);
}

callFakeMenu["SaveAs"] = async () => {
    const promise = dialog.showSaveDialog({ title: 'Save as', properties: ['createDirectory'], filters: [
        { name: 'Notebooks', extensions: ['wln'] }
    ],});
    promise.then((res) => {
        if (!res.canceled) {
            app.addRecentDocument(res.filePath);
            console.log(res.filePath);
            windows.focused.call('saveas', encodeURIComponent(res.filePath) );
        }
    });
}

callFakeMenu["OnTop"] = async(ev) => {
    console.log(ev);
    if (windows.focused.win.isAlwaysOnTop()) {
        windows.focused.win.setAlwaysOnTop(false);
    } else {
        windows.focused.win.setAlwaysOnTop(true);
    }
}

callFakeMenu["new"] = async(ev) => {
    console.log(ev);
    windows.focused.call('newnotebook', true);
}

callFakeMenu["browser"] = async(ev) => {
    server.browserMode = true;
    shell.openExternal(windows.focused.win.webContents.getURL());
}

callFakeMenu["abort"] = () => {
    windows.focused.call('abort', true);
}

callFakeMenu["clearoutputs"] = () => {
    windows.focused.call('clearoutputs', true);
}

callFakeMenu["evalInit"] = () => {
    windows.focused.call('evaluateinit', true);
}

callFakeMenu["zoomIn"] = () => {
    windows.focused.call('zoomIn', true);
}

callFakeMenu["zoomOut"] = () => {
    windows.focused.call('zoomOut', true);
}

callFakeMenu["locateExamples"] = async(ev) => {
    create_window({url: server.url.default('local') + `/` + encodeURIComponent(path.join(installationFolder, 'Examples')), title: 'Examples'});
}

callFakeMenu["locateAppData"] = async(ev) => {
    console.log(ev);
    shell.showItemInFolder(installationFolder);
}

callFakeMenu["reload"] = () => {
    windows.focused.win.webContents.reloadIgnoringCache();
}

callFakeMenu["docsx"] = () => {
    shell.openExternal('http://127.0.0.1:20540')
}
callFakeMenu["exit"] = () => {
    app.quit();
}

/* permissions for the main window, special headers */
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

    session.fromPartition("default").setPermissionRequestHandler((webContents, permission, callback) => {
        let allowedPermissions = ["audioCapture", "desktopCapture"]; // Full list here: https://developer.chrome.com/extensions/declare_permissions#manifest

        if (allowedPermissions.includes(permission)) {
            callback(true); // Approve permission request
        } else {
            console.error(
                `The application tried to request permission for '${permission}'. This permission was not whitelisted and has been blocked.`
            );

            callback(false); // Deny
        }
    });

    let currentOS;
    if (isWindows) currentOS = 'Windows';
    if (isWindows && (!IS_WINDOWS_11 || server.frontend.WindowsLegacy)) currentOS = 'WindowsLegacy';
    if (isMac) currentOS = 'OSX';
    if (!isMac && !isWindows) currentOS = 'Unix';


    session.defaultSession.webRequest.onBeforeSendHeaders((details, callback) => {
        details.requestHeaders['Electron'] = 'True';
        details.requestHeaders['AppOS'] = currentOS;
        callback({ requestHeaders: details.requestHeaders })
    });

}

const server = {
    startedQ: false,
    running: false,
    path: {
        //called via args
    },
    url: {
        self: undefined,
        local: undefined,
        default () {
            return this.local;
        }
    },

    wolfram: {
        process: undefined,
        path: 'wolframscript',
        args: []
    },

    frontend: {},


    shutdown (cbk) {
        if (server.startedQ) {
            this.startedQ = false;
            this.running = false;
            console.log(this.wolfram.process.pid);

            this.wolfram.process.kill('SIGINT');
            this.wolfram.process.stdin.write("exit\n");

            this.wolfram.process.stdin.end();
            this.wolfram.process.stdout.destroy();
            this.wolfram.process.stderr.destroy();

            this.wolfram.process.kill('SIGKILL');
            console.log('Killed?');

            if (!isWindows) {
                //bug on Unix
                kill_all(() => console.log('killed!'));
            }

            //this.wolfram.process.kill('SIGINT');
            //this.wolfram.process.stdin.write("exit\n");
        }
    }
}

/* working windows */
const windows = {
    log: {
        aliveQ: false,
        readyQ: false,
        win: undefined,

        dump: [],

        clear () {
            if (!this.readyQ || !this.aliveQ) return;
            this.win.webContents.send('clear', null);
        },

        print (data, color) {
            if (Array.isArray(this.dump)) this.dump.push(data);
            if (!this.readyQ || !this.aliveQ) {
                console.log(data);
                return;
            };


            this.win.webContents.send('push-logs', data, color);
        },

        construct(cbk = () => {}) {
            let win;

            if (isMac) {
              win = new BrowserWindow({
                vibrancy: "sidebar", // in my case...
                frame: true,
                
                titleBarStyle: 'hiddenInset',
                width: 600,
                height: 400,
                resizable: false,
                title: 'Launcher',
                webPreferences: {
                    preload: path.join(__dirname, 'preload_log.js'),
                    //webSecurity: false,
                    //nodeIntegration: true
                }
             });
            } else {
                win = new BrowserWindow({
                    vibrancy: "sidebar", // in my case...
                    frame: true,
                    autoHideMenuBar: true,
                    width: 600,
                    height: 400,
                    resizable: false,
                    title: 'Launcher',
                    webPreferences: {
                        preload: path.join(__dirname, 'preload_log.js'),
                        //webSecurity: false,
                        nodeIntegration: true
                    }
                 });


            }

            /*win.webContents.session.webRequest.onHeadersReceived((details, callback) => {
              callback({ responseHeaders: Object.assign({
                  "Content-Security-Policy": [ "default-src 'self' 'unsafe-inline'"]
              }, details.responseHeaders)})});*/

            win.loadFile(path.join(__dirname, 'log.html'));

            windows.log.win = win;
            this.aliveQ = true;

            const self = this;

            win.once('ready-to-show', () => {
                self.readyQ = true;
                cbk(win);
            });

            win.on('close', () => {
                self.destroy();
                //app.quit();
            });

            //collect and dump all logs for 2 minutes to a file
            if (Array.isArray(self.dump)) {
                setTimeout(() => {
                    fs.writeFile(path.join(installationFolder, '2minutesLog.txt'), self.dump.join('\r\n'), function(err) {
                        if (err) throw err;

                        //block it for the rest of time
                        self.dump = false;
                        self.print('Logs were dumped', "\x1b[32m");

                    });
                }, 1000 * 60 * 2);
            }

            return win;
        },

        destroy() {
            this.readyQ = false;
            this.aliveQ = false;
            //console.log('log wind destroyed');
            //windows.log.win.close();
            windows.log.win.destroy();

            //this.win = false;
        }
    },

    windows: [],

    focused: {
        win: false,
        last: [],

        add (window) {
            //if (win !== false) unshift(this.last, win);
            this.win = window;
        },
        remove(window) {
            if (this.win == window) this.win = false;
        },

        call (type, args) {
            const self = this;
            if (!self.win) {

                //special cases - open window if not shown
                if (type === 'newnotebook' || type === 'settings') {
                    new notebookWindow({url: server.url.default(), focus: true}, (window) => {
                        window.webContents.send('call', type);
                    });
                    return;
                }

                dialog.showMessageBoxSync({message: 'There is no window opened to perform your action'});
                return;
            }

            self.win.webContents.send(type, args);
        }
    }
};

const read_wl_settings = () => {
    if (!fs.existsSync(path.join(installationFolder, '_settings.wl'))) return;
    const file = fs.readFileSync(path.join(installationFolder, '_settings.wl'), 'utf8');
    console.log(file);

    const r = new RegExp(/("\w*") -> *\n* *("?[^"|>,]*"?)/gm);
    let m;

    const parse = (s) => {
        if (s == 'True') return true;
        if (s == 'False') return false;
        if (s.charAt(0) === '"') return s.slice(1,-1);
        return s;
    }

    server.frontend = {};
    while (m = r.exec(file)) {
        server.frontend[m[1].slice(1,-1)] = parse(m[2]);
    }

    console.log(server.frontend);
}

function create_window(opts, cbk = () => {}) {
        //default options
        const defaults = {
            title: 'Notebook',
            show: true,
            contextMenu: true,
            focus: false,
        };



        const options = Object.assign({}, defaults, opts);
        options.minWidth = 545;

        if ((new RegExp(/gptchat/)).exec(options.url)) {
            options.minWidth = 200;
        }

        let win;

        if (isMac) {
            win = new BrowserWindow({
                vibrancy: "sidebar", // in my case...
                frame: true,
                titleBarStyle: 'hiddenInset',
                width: 800,
                height: 600,
                minWidth: options.minWidth,
                //backgroundMaterial: 'acrylic',
                title: options.title,
                //transparent:true,
                show: options.show,
                webPreferences: {
                    preload: path.join(__dirname, 'preload_main.js')
                }

            });
        } else if (isWindows) {

            /*win = new BrowserWindow({
                width: 800,
                height: 600,
                title: options.title,
                show: options.show,
                autoHideMenuBar: true,
                titleBarOverlay: true,
                titleBarStyle: 'hidden',
                webPreferences: {
                    preload: path.join(__dirname, 'preload_main.js'),
                    enableRemoteModule: true,
                    nodeIntegration: true
                }
            });*/

            let mica = 'mica';
            if (server.frontend.WindowsLegacy) mica = false;

            win = new BrowserWindow({
                frame: true,
                autoHideMenuBar: true,
                titleBarStyle: 'hidden',
                titleBarOverlay: {
                  color: 'rgba(255, 255, 255, 0.0)',
                  symbolColor: 'rgba(128, 128, 128, 1.0)'
                },

                width: 1024,
                height: 640,
                minWidth: options.minWidth,
                backgroundMaterial: mica,
                title: options.title,
                //transparent:true,
                maximizable: true,

                show: options.show,
                webPreferences: {
                    preload: path.join(__dirname, 'preload_main.js')
                }

            });

            //win.setVibrancy('appearance-based');

            //Windows 10-11 specific settings for transparency
            /*if (IS_WINDOWS_11) {
                win.setMicaEffect();
                //win.setMicaTabbedEffect();
                ///win.setMicaAcrylicEffect();
                win.setRoundedCorner();
                win.setAutoTheme();
            } else {
                //win.setAcrylic();
                const checkTheme = () => {
                    if (!nativeTheme.shouldUseDarkColors) win.setBackgroundColor("#fff");
                    else win.setBackgroundColor("#000");
                }

                nativeTheme.on("updated", checkTheme);
                win.on('closed', () => {
                    nativeTheme.removeListener("updated", checkTheme);
                });

                checkTheme();
                //win.setRoundedCorner();
            }*/
            if (!IS_WINDOWS_11 || server.frontend.WindowsLegacy) {
                const checkTheme = () => {
                    if (!nativeTheme.shouldUseDarkColors) {
                        win.setBackgroundColor("#fff");
                        //titleBarOverlay
                    } else {
                        win.setBackgroundColor("#000");
                    }
                }

                nativeTheme.on("updated", checkTheme);
                win.on('closed', () => {
                    nativeTheme.removeListener("updated", checkTheme);
                });

                checkTheme();
            } else {
                //a bug with maximizing the window
                //https://github.com/electron/electron/issues/38743

                win.once('maximize', () => {
                    const checkTheme = () => {
                        if (!nativeTheme.shouldUseDarkColors) {
                            win.setBackgroundColor("#fff");
                            //titleBarOverlay
                        } else {
                            win.setBackgroundColor("#000");
                        }
                    }

                    nativeTheme.on("updated", checkTheme);
                    win.on('closed', () => {
                        nativeTheme.removeListener("updated", checkTheme);
                    });

                    checkTheme();
                });



            }

        } else {
            win = new BrowserWindow({
                frame: true,
                autoHideMenuBar: true,
                titleBarStyle: 'hidden',
                titleBarOverlay: true,
                width: 800,
                height: 600,
                minWidth: options.minWidth,
                title: options.title,
                //transparent:true,
                maximizable: true,

                show: options.show,
                webPreferences: {
                    preload: path.join(__dirname, 'preload_main.js')
                }

            });
        }



        //search on the page (just for debugging)
        win.webContents.on('found-in-page', (event, result) => {
            //show results when Ctrl+F pressed
            console.log(result)
        });

        //permissions of the window
        setHID(win);

        //focus window
        if (options.focus) {
            win.focus();
            windows.focused.add(win);
        }

        win.on('focus', () => {
            windows.focused.add(win);
        });

        win.uuid = uuid4();

        win.on('close', () => {
            windows.focused.remove(win);
            windows.windows.splice(windows.windows.findIndex(a => a.uuid === win.uuid) , 1);
        });

        //extend context menu
        if (options.contextMenu) {
            contextMenu({
                window: win,
                prepend: (defaultActions, parameters, browserWindow) => contextMenuExtensions.map((mi) => {
                    let visible = false;

                    switch(mi.visible) {
                        case 'selection':
                            visible =  parameters.selectionText.trim().length > 0;
                        break;
                        default:
                            visible = true;
                    };

                    const onclick = () => {
                        win.webContents.send('context', mi.event);
                    }

                    return ({
                        label: mi.label,
                        // Only show it when right-clicking images
                        visible: visible,
                        click: onclick
                    })
                })
                ,

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
        }

        if (!options.url) {
            console.error('No url is provided!');
            return;
        }



        if (options.cacheClear) {
            win.webContents.session.clearCache();
        }

        //callback when it is ready
        if (options.show) {
            cbk(win);
        } else {
            win.once('ready-to-show', () => {
                win.show();
                cbk(win);
            });
        }

        //add to the list of opened windows
        windows.windows.push(win);


        const contents = win.webContents;
        //handlers for internal links and pop-ups




        win.webContents.setWindowOpenHandler(({ url }) => {
            console.log(url);
            const u = new URL(url);



            //if it is on the same domain
            if (u.hostname === (new URL(server.url.default())).hostname) {
                create_window({url: url, show: true, parent: win});

            } else {
                //open in the default user's browser
                shell.openExternal(url);
            }

            return { action: 'deny' };
        });

        if ((new RegExp(/gptchat/)).exec(options.url)) {
            if (options.parent) {


                if (options.parent.isMaximized()) options.parent.unmaximize();

                const pos = options.parent.getPosition();
                const dims = options.parent.getSize();

                const primaryDisplay = screen.getPrimaryDisplay();
                const { width, height } = primaryDisplay.workAreaSize;
                console.warn({screen: width, parentPos: pos, parentdims:dims});


                if (pos[0]+dims[0] + 310 > width) {
                    console.warn('Contaner Overflow!');
                    if (dims[0] + 310 + 50 > width) {
                        console.warn('Resize parent');
                        options.parent.setPosition(50, pos[1], true);
                        const newwidth = width - 310 - 50;
                        options.parent.setBounds({ width: newwidth, animate: true}, true);
                        win.setBounds({ width: 300, height:dims[1], animate: true}, true);
                        win.setPosition( newwidth + 10 + 50, pos[1], true);
                    } else {
                        options.parent.setPosition(50, pos[1], true);
                        win.setBounds({ width: 300, height:dims[1], animate: true}, true);
                        win.setPosition(dims[0] + 50 + 10, pos[1], true);
                    }
                } else {
                    win.setBounds({ width: 300, height:dims[1], animate: true}, true);
                    win.setPosition(pos[0]+dims[0] + 10, pos[1], true);
                }
            } else {
                win.setBounds({ width: 300, animate: true}, true);
            }
        }

        win.loadURL(options.url);

        win.on('focus', () => {
            win.webContents.send('focus');
        });

        win.on('blur', () => {
            win.webContents.send('blur');
        });


        return win;
}




/* APP Logic */

app.on('will-quit', (e) => {
    console.log('exiting the server...');
    //e.preventDefault();
    server.shutdown();
})

app.on('before-quit', (e) => {
    console.log('aaahhh...');
    //server.shutdown();
    if (server.browserMode && process.platform !== 'darwin') {
    
        e.preventDefault();
        console.log('aaahhh...');
        tray.fireBallon()

        
    }
})

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin' && !server.browserMode) {app.quit()} else {
        if (server.browserMode) {
            console.log('aaahhh...');
            tray.fireBallon()
        }
    }
})


app.on('open-file', (ev, path) => {
    ev.preventDefault();
    app.addRecentDocument(path);
    if (!server.running) {
        server.path.requested = path;
        return;
    }

    create_window({url: server.url.default('local') + `/` + encodeURIComponent(path), title: path, show: true, focus: true});
})

app.on('activate', () => {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) {
        //const o = createWindow(globalURL);
        create_window({url: server.url.default('local'), focus: true, show: true});
    }
})


// Behaviour on the second instance for the parent process
const gotSingleInstanceLock = app.requestSingleInstanceLock();
if (!gotSingleInstanceLock) app.quit();
else {
    app.on('second-instance', (_, argv) => {
        //User requested a second instance of the app.
        //argv has the process.argv arguments of the second instance.
        //on windows IT SENDS --allow-file-access-from-files as a second argument.!!!
        if (app.hasSingleInstanceLock()) {
            windows.log.print('second instance was blocked');
            windows.log.print(argv[0]);
            windows.log.print(argv[1]);
            windows.log.print(argv[2]);

            let pos = 1;
            if (new RegExp('--').exec(argv[pos])) pos++;
            if (new RegExp('--').exec(argv[pos])) pos++;

            create_window({url: server.url.default('local') + `/` + encodeURIComponent(argv[pos]), title: argv[pos], focus: true, show: false});
        }
    });
}

//reset HTTP cache in the browser if an update flag was detected (created by WL)
const checkCacheReset = (cbk) => {
    if (fs.existsSync(path.join(installationFolder, '.wasupdated'))) {
        fs.unlinkSync(path.join(installationFolder, '.wasupdated'));
        session.defaultSession.clearStorageData();
        session.defaultSession.clearCache();

        server.wasUpdated = true;

        cbk();

        windows.log.print('HTTP Cache reset!', "\x1b[32m");
    }
}

const powerSaver = () => {
    console.log('Electron >> starting powersafe blocker');
    powerSaveId = powerSaveBlocker.start('prevent-app-suspension');

    setInterval(() => {
        //console.log('Electron >> checking power saving...');
        if (BrowserWindow.getAllWindows().length > 0) {
            if (!powerSaveBlocker.isStarted(powerSaveId)) {
                console.log('Electron >> starting powersafe blocker');
                powerSaveId = powerSaveBlocker.start('prevent-app-suspension');
            }
        } else {
            if (powerSaveBlocker.isStarted(powerSaveId)) {
                console.log('Electron >> stopping powersafe blocker');
                powerSaveBlocker.stop(powerSaveId);
            }
        }
    }, 15000);

    powerMonitor.on('suspend', () => {

    });

    powerMonitor.on('lock-screen', () => {

    })
}


/* App Ready */

app.whenReady().then(() => {
    if (!isMac) {
        if (!isWindows) {
            tray = new Tray(path.join(__dirname, 'build', '512x512.png'));
        } else {
            tray = new Tray(path.join(__dirname, 'build', '256x256_new.ico'));
        }
        //console.log(path.join(__dirname, 'build', '256x256_new.ico'));
        tray.setToolTip('Sorry, I am buzy');
        tray.setContextMenu(Menu.buildFromTemplate([
            {
              label: 'Quit', click: function () {
                server.browserMode = false;
                app.quit();
              }
            }
          ]));

        tray.fireBallon = () => {
            tray.displayBalloon({
                title: "WLJS Server",
                content: "Running in the background as a server",
                largeIcon: false
              });
              setTimeout(() => {tray.displayBalloon({
                title: "WLJS Server",
                content: "Running in the background as a server",
                largeIcon: false
              });console.log("QQQ")}, 1000);
              console.log("QQQ")
        }  

          
    }

    pluginsMenu.fetch();
    buildMenu({plugins: pluginsMenu.items});

    powerSaver();

    //make a log window and start WL
    windows.log.construct((log_window) => {
        //new promt('input', 'Do you have Wolfram Engine installed?', (answer) => console.log(answer), log_window);
        check_installed(() => check_wl(load_configuration(), () => store_configuration(() => start_server(log_window)), log_window), log_window);
    });

    read_wl_settings();

    //server.url.local = `http://127.0.0.1:20560`;
    //create_window({url: 'http://127.0.0.1:20560', show: true, focus: true, cacheClear: true});

    ipcMain.on('system-harptic', () => {
        trackpadUtils.triggerFeedback();
    });

    ipcMain.on('system-window-enlarge-if-needed', (e, p) => {
        const bonds = windows.focused.win.getBounds();
        if (bonds.width < 800) {
            windows.focused.win.setBounds({ width: 800 , animate: true}, true);
        }
    });

    ipcMain.on('system-window-toggle', (e, p) => {
        const bonds = windows.focused.win.getBounds();
        if (bonds.width < 800) {
            if (windows.focused.win.previousWidth) {
                windows.focused.win.setBounds({ width: windows.focused.win.previousWidth , animate: true}, true);
            } else {
                windows.focused.win.setBounds({ width: 800 , animate: true}, true);
            }
        } else {
            windows.focused.win.previousWidth = bonds.width;
            windows.focused.win.setBounds({ width: 600 , animate: true}, true);
        }
    });

    ipcMain.handle('system-save-something', async (event, p) => {
        const result = await dialog.showSaveDialog({ title: p.title, properties: ['createDirectory'], filters: [
            { extensions: p.extension }
        ]});

        if (!result.canceled) {
            return encodeURIComponent(result.filePath);
        } else {
            return false;
        }
    });

    ipcMain.handle('system-open-folder-something', async (event, p) => {
        const result = await dialog.showOpenDialog({ title: p.title, buttonLabel:'Set home', properties: ['openDirectory', 'createDirectory']});

        if (!result.canceled) {
            return encodeURIComponent(result.filePaths[0]);
        } else {
            return false;
        }
    });


    ipcMain.on('system-window-expand', (e, p) => {
        windows.focused.win.setBounds({ width: 800 , animate: true});
    });

    ipcMain.on('system-window-shrink', (e, p) => {
        windows.focused.win.setBounds({ width: 600 , animate: true});
    });

    //set up search on-page (any focused windows)
    ipcMain.on('search-text', (event, arg) => {
        let nextRes = arg.direction == 'next' ? true : false
        const requestId = windows.focused.win.webContents.findInPage(arg.searchText, {
            forward: true,
            findNext: nextRes,
            matchCase: false
        });
    });
    ipcMain.on('stop-search', (event, arg) => {
        windows.focused.win.webContents.stopFindInPage('clearSelection');
    });

    //system commands to open file explorers and etc
    ipcMain.on('system-open', (e, p) => {
        const dir = JSON.parse(p);
        if (dir[0].length == 0) {
            shell.showItemInFolder('/'+path.join(...dir));
        } else {
            shell.showItemInFolder(path.join(...dir));
        }
    });

    ipcMain.on('system-menu', (e, p) => {
        const menusection = p;
        callFakeMenu[menusection]();
    });


    //promts resolver
    ipcMain.on('promt-resolve', (e, id, val) => {
        promts_hash[id].resolve(val);
    });

    //purge cache if an update was detected (using a special file created by WL)


    let cinterval;
    let tmout;

    /*cinterval = setInterval(checkCacheReset(() => {
        clearInterval(cinterval);
        clearTimeout(tmout);
    }), 5000);

    tmout = setTimeout(() => {
        clearInterval(cinterval);
    }, 60 * 1000)  */
});


function start_server (window) {
    console.log('Started! app');
    // app.quit();
    if (!server.startedQ) {
        windows.log.clear();
        windows.log.print('Internal error. Wolframscript has not started');
        setTimeout(() => app.quit(), 3000);
        return;
    }

    server.wolfram.process.stdin.write(`Get["${runPath.replace(/\\/g, "\\\\")}"]\n`);

    const PACError = new RegExp(/Execution of PAC script at/);

    let url_match;
    const url_reg = new RegExp(/Open http:\/\/(?<ip>[0-9|.]*):(?<port>[0-9]*) in your browser/);

    server.wolfram.streamer = (data) => {
        const string = data.toString();
        windows.log.print(string);

        

        //listerning for a specific line in output
        url_match = url_reg.exec(string);
        if (url_match && !server.running) {
            //open a window, means server has started
            server.url.local = `http://${url_match.groups.ip}:${url_match.groups.port}`;



            console.log('Open first window');

            //open a first window. coudl be a file or second instance
            create_first_window();
            server.running = true;

            //reset to the default streamer
            server.wolfram.streamer = (data) => {
                const string = data.toString();
                windows.log.print(string);
            };

            setTimeout(() => {windows.log.destroy()}, 300);
        }

    };
    server.wolfram.errors = (data) => {
        const string = data.toString();

        //checking errors
        if (PACError.exec(string)) {
            new promt('binary', 'There might be an problem with Wolfram Engine (Execution of PAC script). If you face any further issues, try to restart frontend with no active internet connection', ()=>{}, window);
        }

        windows.log.print(string, '\x1b[46m');
    };

    server.wolfram.process.stdout.on('data', server.wolfram.streamer);
    server.wolfram.process.stderr.on('data', server.wolfram.errors);
}

//applicable only to the first time!!!
function create_first_window() {
    //we need to decide what to open!

    //Windows/Unix open a file
    if (!isMac && server.startedQ && !server.running && process.argv[1]) {
        console.log('OPEN a FILE WIN/Linux');
        if (process.argv[1].length > 3) {
            app.addRecentDocument(process.argv[1]);
            create_window({url: server.url.default() + '/' + encodeURIComponent(process.argv[1]), title: process.argv[1], show: false, focus: true, cacheClear: server.wasUpdated});
        } else  {
            create_window({url: server.url.default(), title: 'Notebook', show: false, focus: false, cacheClear: server.wasUpdated});
        }

        server.wasUpdated = false;
        return;
    }

    //Mac
    if (isMac && server.startedQ && !server.running && server.path.requested) {
        console.log('OPEN a FILE OSX');
        app.addRecentDocument(server.path.requested);
        create_window({url: server.url.default() + '/' + encodeURIComponent(server.path.requested), title: server.path.requested, show: false, focus: true, cacheClear: server.wasUpdated});
        server.path.requested = undefined;

        server.wasUpdated = false;
        return;
    }

    //nothing... just regular start

    console.log('Regular start. Open default url');
    create_window({url: server.url.default(), title: 'Notebook', show: true, focus: false});
    server.wasUpdated = false;
}

const prompt = require('./native-prompt-leo/')

const promts_hash = {}
class promt {
    constructor(type = 'binary', title, cbk, window) {
        this.uuid = uuid4();

        switch(type) {
            case 'binary':
                window.webContents.send('yesorno', this.uuid, title);
                this.promise = (result) => cbk(result)
            break;

            case 'input':
                prompt('Action needed', title).then((result) => {
                    cbk(result)
                });
            break;
        }

        promts_hash[this.uuid] = this;
    }

    resolve(value) {
        this.promise(value);
        delete promts_hash[this.uuid];
    }
}

function store_configuration(cbk) {
    const opts = {
        wolfram: server.wolfram
    };

    fs.writeFile(path.join(installationFolder, 'configuration.ini'), JSON.stringify(opts), function(err) {
        if (err) throw err;
    });

    cbk();
}

function load_configuration() {
    if (!fs.existsSync(path.join(installationFolder, 'configuration.ini'))) return undefined;
    return JSON.parse(fs.readFileSync(path.join(installationFolder, 'configuration.ini'), 'utf8'));
}

//checking if there is working Wolfram Kernel.
function check_wl (configuration, cbk, window) {
    if (configuration) server.wolfram = {...server.wolfram, ...configuration.wolfram};

    windows.log.print("");
    windows.log.print("Starting wolframscript by path: " + server.wolfram.path);
    let program;

    try{
        console.log('TRY');
        program = spawn(server.wolfram.path, server.wolfram.args, { cwd: workingDir });
    } catch (err) {
        windows.log.clear();
        windows.log.print(err);
        console.log(err);
        //windows.log.print('Do you have Wolfram Engine installed?', '\x1b[42m');
        new promt('binary', 'Do you have Wolfram Engine installed?', (answer) => {
            if (answer) {
                windows.log.print("");
                windows.log.print('Please, locate an executable called `wolframscript` or `WolframKernel`', '\x1b[44m');

                setTimeout(() => {
                    const promise = dialog.showOpenDialog({ title: 'Locate wolframscript', properties: ['openFile', 'showHiddenFiles', 'treatPackageAsDirectory', 'dontAddToRecent']});
                    promise.then((res) => {
                        if (!res.canceled) {
                            server.wolfram.path = res.filePaths[0];
                            console.log(res.filePaths);
                            windows.log.clear();
                            check_wl(undefined, cbk, window);
                        } else {
                            windows.log.clear();
                            check_wl(undefined, cbk, window);
                        }
                    });
                }, 2000);

            } else {
                install_wl(window);
            }
        }, window);
        return;
    }

    //error
    program.on('error', function(err) {
        windows.log.print("");
        windows.log.print("Cannot execute a given process", '\x1b[46m');
        windows.log.print(String(err));

        setTimeout(() => {
            windows.log.clear();
            windows.log.print(err);
            console.log(err);
            //windows.log.print('Do you have Wolfram Engine installed?', '\x1b[42m');
            new promt('binary', 'Do you have Wolfram Engine installed?', (answer) => {
                if (answer) {
                    windows.log.print("");
                    windows.log.print('Please, locate an executable called `wolframscript` or `WolframKernel`', '\x1b[44m');

                    setTimeout(() => {
                        const promise = dialog.showOpenDialog({ title: 'Locate wolframscript', properties: ['openFile', 'showHiddenFiles', 'treatPackageAsDirectory', 'dontAddToRecent']});
                        promise.then((res) => {
                            if (!res.canceled) {
                                server.wolfram.path = res.filePaths[0];
                                console.log(res.filePaths);
                                windows.log.clear();
                                check_wl(undefined, cbk, window);
                            } else {
                                windows.log.clear();
                                check_wl(undefined, cbk, window);
                            }
                        });
                    }, 2000);

                } else {
                    install_wl(window);
                }
            }, window);
            return;
        }, 2000);

    });

    let _nohup = false;

    //for debugging only
    /*program.stderr.on('data', (data) => {
        windows.log.print(data.toString());
    });

    program.stdout.on('data', (data) => {
        windows.log.print(data.toString());
    }); */

    program.stderr.once('data', (data) => {
        console.warn(data.toString());
        if (_nohup) return;
        _nohup = true;

        windows.log.print("");

        //TROUBLESHOOTING
        if (default_error_handling(()=>{
            //If managed
            //Wolframscript started
            server.wolfram.process = program;
            server.running = false;
            server.startedQ = true;
            windows.log.clear();
            cbk();
        },
        () => {
            //if failed
            windows.log.clear();

            program.stdin.end();
            program.stdout.destroy();
            program.stderr.destroy();

            program.kill('SIGKILL');
            kill_all(() => console.log('killed!'));
            check_wl(undefined, cbk, window);
        }, data.toString(), program, window)) return;

        //if we did not manage to fix issues...
        windows.log.print(data.toString(), '\x1b[46m');
        windows.log.print("");

        //this is a sign that the command was not found
        setTimeout(() => {
            windows.log.clear();
            check_wl(undefined, cbk, window);

        }, 3000);
    });



    program.stdout.once('data', (data) => {
        //this is ok. wolframscript now is running
        if (_nohup) return;
        _nohup = true;

        const s = data.toString();

        windows.log.print("");

        //TROUBLESHOOTING
        if (default_error_handling(()=>{
            //If managed
            //Wolframscript started
            windows.log.clear();
            server.wolfram.process = program;
            server.running = false;
            server.startedQ = true;
            cbk();
        },
        () => {
            //if failed

            program.stdin.end();
            program.stdout.destroy();
            program.stderr.destroy();


            program.kill('SIGKILL');
            kill_all(() => console.log('killed!'));
            windows.log.clear();
            check_wl(undefined, cbk, window);
        }, s, program, window)) return;

        //If OK
        //Wolframscript started
        if (new RegExp('Wolfram Language').exec(s)) {
            windows.log.print(s);
            server.wolfram.process = program;
            server.running = false;
            server.startedQ = true;
            windows.log.clear();
            cbk();
            return;
        }


        windows.log.print("");
        windows.log.print(s);

        //wait for more output
        program.stdout.once('data', (data) => {
            //If OK
            //Wolframscript started
            if (new RegExp('Wolfram Language').exec(data.toString())) {
                windows.log.print(data.toString());
                server.wolfram.process = program;
                server.running = false;
                server.startedQ = true;
                cbk();
                return;
            }

            //if not
            windows.log.print("");
            windows.log.print(data.toString());
            windows.log.print("");
            windows.log.print("No reply. Restart in 5 sec", '\x1b[46m');

            setTimeout(()=>{

                program.stdin.end();
                program.stdout.destroy();
                program.stderr.destroy();


                program.kill('SIGKILL');
                kill_all(() => console.log('killed!'));
                windows.log.clear();
                check_wl(undefined, cbk, window);
            }, 5000);
        });
    });

}

function default_error_handling(success, reject, s, program, window) {
    //1# activation issues
    if (new RegExp('Wolfram product is not activated').exec(s)) {
        windows.log.print("Automatic activation in 3 seconds...", '\x1b[44m');
        setTimeout(() => {
            server.wolfram.args.push('-activate');
            windows.log.clear();
            reject();
        }, 3000);
        return true;
    }

    //on success of activation
    if (new RegExp('activated').exec(s)) {
        server.wolfram.args.pop();
        windows.log.clear();
        reject();
        return true;
    }


    //#2 Too many running Kernels
    if (new RegExp('The Wolfram Engine could not be activated using your Wolfram ID').exec(s)) {
        windows.log.print("It seems you have some Wolfram Kernels running in the background or on another machine. Due to the Wolfram licensing limitations it is not allowed to run more than 2. WLJS Notebook requires exactly 2 to run locally.", '\x1b[44m');
        windows.log.print("");

        //windows.log.print('Should we try to kill other processes?', '\x1b[42m');
        new promt('binary','Should we try to kill other Wolfram processes?', (answer) => {
            if (!answer) {
                kill_all(() => {
                    windows.log.clear();
                    reject();
                }, window);
            } else {
                windows.log.clear();
                reject();
            }
        }, window);
        return true;
    }


    //#3 Activation
    if (new RegExp('The Wolfram Engine requires one-time').exec(s)) {
        //windows.log.print('Do you have a developer license from Wolfram?', '\x1b[42m');

        new promt('binary', 'Do you have a developer license activated?', (answer) => {
            if (!answer) {
                windows.log.clear();
                windows.log.print('Please get the license from Wolfram website. A window will open shortly...', '\x1b[42m');
                shell.openExternal("https://www.wolfram.com/engine/free-license/");
                setTimeout(() => {
                    windows.log.clear();
                    activate_wl(program, success, () => {
                        //if rejected
                        windows.log.clear();
                        reject();
                    }, window);
                }, 3000);

            } else {
                windows.log.clear();
                activate_wl(program, success, () => {
                    //if rejected
                    windows.log.clear();
                    reject();
                }, window);
            }
        }, window);

        return true;
    }

    return false;
}

function kill_all(cbk, window) {

    switch(process.platform) {
        case 'win32':
            exec('taskkill /F /IM WolframKernel.exe /T');
        break;
        default: // Linux + Darwin
            exec('pkill -9 -f Wolfram');
        break;
    }

    //windows.log.print('probably killed');
    setTimeout(cbk, 2000);
}


function activate_wl(program, success, rejection, window) {
    windows.log.clear();


    //answer checkers
    const check = (string) => {
        //keep going...
        if (string.trim().length == 0) return false;

        if (new RegExp('Incorrect').exec(string)) {
            //windows.log.print('Incorrect');
            setTimeout(rejection, 3000);
            //stop
            return true;
        }

        if (new RegExp('Wolfram Language').exec(string)) {
            //windows.log.print('Success!');
            success();
            return true;
        }

        //continue
        return false;
    }


    windows.log.print('Please, enter your Wolfram ID (usually - your email):', '\x1b[42m');

    new promt('input', 'Wolfram ID', (result) => {
        program.stdin.write(result.trim());
        program.stdin.write('\n');

        windows.log.clear();
        windows.log.print('Please, enter your password', '\x1b[42m');
        new promt('input', 'Password', (result) => {
            program.stdin.write(result.trim());
            program.stdin.write('\n');

            let _nohup = false;

            program.stderr.once('data', (data) => {
                if (_nohup) return;
                _nohup = true;

                windows.log.print(data.toString());
                if (check(data.toString())) return;

                windows.log.print('please, wait...');

                program.stderr.once('data', (data) => {
                    windows.log.print(data.toString());
                    if (check(data.toString())) return;
                    //timeout to retry

                    program.stdin.end();
                    program.stdout.destroy();
                    program.stderr.destroy();


                    program.kill('SIGKILL');
                    kill_all(() => console.log('killed!'));
                    setTimeout(rejection, 3000);
                });
            });

            program.stdout.once('data', (data) => {
                if (_nohup) return;
                _nohup = true;

                windows.log.print(data.toString());
                if (check(data.toString())) return;

                windows.log.print('please, wait...');

                program.stdout.once('data', (data) => {
                    windows.log.print(data.toString());
                    if (check(data.toString())) return;
                    //timeout to retry
                    program.kill('SIGKILL');
                    kill_all(() => console.log('killed!'));
                    setTimeout(rejection, 3000);
                });
            });
        }, window);
    }, window);
}

function install_wl(window) {
    windows.log.clear();
    windows.log.print("Please download and install Wolfram Engine manually. A windows will open shortly. A feature for auto-installation is not supported for now.");
    windows.log.print("");
    windows.log.print("Recommended version is 13.0.1", '\x1b[42m');
    setTimeout(() => {
        shell.openExternal("https://www.wolfram.com/engine/");
        app.quit();
    }, 3000);
}

function check_installed (cbk, window) {
    windows.log.print('checking the installation folder...', '\x1b[32m');
    windows.log.print(installationFolder, '\x1b[32m');

    const package = path.join(installationFolder, 'package.json');
    const script = path.join(installationFolder, 'Scripts', 'start.wls');

    //if it is already installed
    if (fs.existsSync(script)) {
        fs.readFile(package, (err, raw) => {
            if (err) {
                windows.log.print('Cannot read '+package+'!');
                throw err;
            }

            let data = JSON.parse(raw);
            windows.log.print("");
            windows.log.print('Current version: ' + data["version"], '\x1b[34m');
            const version = parseInt(data["version"].replaceAll(/\./gm, ''));

            //watchdog for internet connection
            const watchdog = setTimeout(() => {
                windows.log.print('No internet connection! Skipping update checks...', '\x1b[32m');
                cbk();
            }, 5000);

            const repo = server.frontend.UpdatesChannelRepo ||  'JerryI/wolfram-js-frontend';
            const branch = server.frontend.UpdatesChannelBranch ||  'updates';

            console.log([repo, branch]);
            //app.exit(-1);

            //check internet
            const test = net.fetch('https://github.com');
            test.then((result) => {
                if (result.status === 200) {
                    clearTimeout(watchdog);

                    //check the official version


                    const request = net.fetch('https://raw.githubusercontent.com/'+repo+'/'+branch+'/package.json');
                    request.then((result) => {
                        if (result.status === 200) {
                            console.log(result);

                            result.text().then((data) => {

                                console.log(data);
                                const remote = JSON.parse(data);
                                if (remote["version"]) {
                                    const rersion = parseInt(remote["version"].replaceAll(/\./gm, ''));
                                    if (rersion > version) {
                                        windows.log.print('A new version is available. Should we install it?', '\x1b[44m');
                                        windows.log.print(':: warning :: it will clean up `wl_packages`, `wljs_packages` and `Examples` folders', '\x1b[32m');

                                        new promt('binary', 'A new version is available. Should we install it?', (answer) => {
                                            if (answer) {
                                                install_frontend(cbk, window);
                                            } else {
                                                cbk();
                                            }
                                        }, window);


                                    } else {
                                        windows.log.print('You are using the latest release', '\x1b[32m');
                                        cbk();
                                    }
                                } else {
                                    windows.log.print('Unable to check updates!', '\x1b[42m');
                                    windows.log.print('skipping...', '\x1b[32m');
                                    cbk();
                                }
                            })
                        } else {
                            windows.log.print('Unable to check updates!', '\x1b[32m');
                            windows.log.print('status code ' + result.status, '\x1b[34m');
                            windows.log.print('skipping...', '\x1b[32m');
                            cbk();
                        }
                    },
                    (rejection) => {
                        windows.log.print('Unable to check updates! Reason:', '\x1b[32m');
                        windows.log.print(JSON.stringify(rejection), '\x1b[34m');
                        windows.log.print('skipping...', '\x1b[32m');
                        cbk();
                    });

                } else {
                    windows.log.print('Failed! using ' + repo + ' and branch ' + branch, '\x1b[32m');
                }
            });
        });

        return;
    }

    windows.log.print('System folder is empty! Starting installation...', '\x1b[32m');
    install_frontend(cbk, window);
}


function install_frontend(cbk, window) {
    //watchdog for internet connection
    const watchdog = setTimeout(() => {
        windows.log.print('No internet connection! Using shipped version...', '\x1b[32m');
        install_shipped(cbk, window);
    }, 5000);

    //check internet
    const test = net.fetch('https://github.com');
    test.then((result) => {
     if (result.status === 200) {
        clearTimeout(watchdog);

        //set the flag to reset cache of the HTTP client
        server.wasUpdated = true;

        windows.log.clear();
        windows.log.print('Downloading .zip archive to ' + installationFolder + '...', '\x1b[32m');

        //path to zip
        const pathToFile = path.join(installationFolder, 'pkg.zip');

        const repo = server.frontend.UpdatesChannelRepo ||  'JerryI/wolfram-js-frontend';
        const branch = server.frontend.UpdatesChannelBranch ||  'updates';

        downloadFile('https://api.github.com/repos/'+repo+'/zipball/'+branch, pathToFile, (file) => {
            windows.log.print('Unzipping...', '\x1b[32m');

            const extracted = path.join(installationFolder, '__extracted');

            if (!fs.existsSync(extracted)) {
                fs.mkdirSync(extracted);
            } else {
                fs.rmSync(extracted, { recursive: true, force: true });
                fs.mkdirSync(extracted);
            }

            const StreamZip = require('node-stream-zip');
            const zip = new StreamZip.async({ file: file });

            zip.extract(null, extracted).then((res) => {
                windows.log.print(res);
                windows.log.print('Extracted', '\x1b[32m');

                //remove zip archive
                zip.close();
                fs.unlinkSync(file);

                //read extracted folder
                const sub = fs.readdirSync(extracted)[0];
                windows.log.print(sub);

                //git rid of .git folder
                //fs.unlinkSync(path.join(extracted, sub, 'main.js'));
                if (fs.existsSync(path.join(extracted, sub, '.git'))) fs.rmSync(path.join(extracted, sub, '.git'), { recursive: true, force: true });
                windows.log.print('`.git` was removed');

                //remove examples from the previous build
                if (fs.existsSync(path.join(installationFolder, 'Examples'))) {
                    //fs.rmSync(path.join(installationFolder, 'Examples'), { recursive: true, force: true });
                    //windows.log.print('`Examples` was removed');
                }


                windows.log.print('Copying new data...');
                fse.copySync(path.join(extracted, sub), installationFolder, { overwrite: true });
                windows.log.print('Done');

                //remove specific files
                const toremove = ['.thumbnails', 'LPM.wl', 'main.js', 'wl_packages_lock.wl', 'wljs_packages_lock.wl', 'wljs_packages_users.wl', '.wl_timestamp', '.wljs_timestamp'];
                const dirtoremove = ['wljs_packages', 'wl_packages'];

                //windows.log.print('removing Packages...');
                //windows.log.print('removing wl_packages...');

                toremove.forEach((p) => {
                    if (fs.existsSync(path.join(installationFolder, p))) {
                        fs.unlinkSync(path.join(installationFolder, p));
                    }
                });

                dirtoremove.forEach((p) => {
                    if (fs.existsSync(path.join(installationFolder, p))) {
                        fs.rmSync(path.join(installationFolder, p), { recursive: true, force: true });
                    }
                });

                //resetting cache
                windows.log.print('Cache reset');
                session.defaultSession.clearStorageData();
                session.defaultSession.clearCache();

                windows.log.print('Done');

                fs.rmSync(extracted, { recursive: true, force: true });

                windows.log.print('Temporal folders were cleaned up');

                cbk();

            })
        });
     }
    });
}


//in a case of a powerful firewall or apocalipse
const install_shipped = (cbk, window) => {

    windows.log.print('Copying to installation folder of a shipped package...');
    const sub = path.join(app.getAppPath(), 'shipped');
    windows.log.print(sub);

    fse.copySync(sub, installationFolder, { overwrite: true });
    windows.log.print('');
    windows.log.print('Done!');
    cbk();
}

function downloadFile(file_url, targetPath, cbk) {
    // Save variable to know progress
    var received_bytes = 0;
    var total_bytes = 0;

    const showProgress = (received, total) => {
        windows.log.print("+ | " + received, '\x1b[32m');
    }

    const ft = net.request(file_url);

    var out = fs.createWriteStream(targetPath);
    //req.pipe(out);

    ft.on('response', (responce) => {
        // Change the total bytes value to get progress later.
        console.log(responce.headers);
        //total_bytes = parseInt(responce.headers.get('Content-Length'));
        //console.log(total_bytes);

        responce.pipe(out);

        responce.on('data', function(chunk) {
            // Update the received bytes
            received_bytes += chunk.length;

            showProgress(received_bytes);
        });

        responce.on('end', function() {
            windows.log.print("File succesfully downloaded", '\x1b[34m');
            cbk(targetPath);
        });
    });



    ft.end()
}


/* uuid v4 generator */
var uuid4 = () => {
    var h=['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'];
    var k=['x','x','x','x','x','x','x','x','-','x','x','x','x','-','4','x','x','x','-','y','x','x','x','-','x','x','x','x','x','x','x','x','x','x','x','x'];
    var u='',i=0,rb=Math.random()*0xffffffff|0;
    while(i++<36) {
        var c=k[i-1],r=rb&0xf,v=c=='x'?r:(r&0x3|0x8);
        u+=(c=='-'||c=='4')?c:h[v];rb=i%8==0?Math.random()*0xffffffff|0:rb>>4
    }
    return u
}

var unshift = (array, value) => {
    array.unshift(value);
    array.length = Math.min(array.length, 5);
    return array;
}
