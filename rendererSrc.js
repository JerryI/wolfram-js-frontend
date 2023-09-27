
import { Terminal } from 'xterm';
import { generate, count } from "random-words";
//const c = require('ansi-colors');
//import { FitAddon } from 'xterm-addon-fit';

const term = new Terminal({cursorBlink: true});
///const fitAddon = new FitAddon();
//term.loadAddon(fitAddon);

const logger = document.getElementById('log');

// Open the terminal in #terminal-container
term.open(logger);

term.options.fontSize = 12;
term.cols = 30;

term.options.theme.background = "rgb(0,0,0,0)";

document.getElementsByClassName('xterm-viewport')[0].style.backgroundColor = "transparent";
// Make the terminal's size and geometry fit the size of #terminal-container
//setTimeout(() =>fitAddon.fit(), 100);

logger.addEventListener("resize", (event) => {
    //fitAddon.fit();
});



window.electronAPI.handleLogs((event, value, color) => {
    if (color) {
        term.writeln(color+value.replace(/(\n)/gm,"\r\n")+'\x1b[0m');
    } else {
        term.writeln(value.replace(/(\n)/gm,"\r\n")+'\x1b[0m');
    }
    
});

const lastCommands = [];
let cursor = -1;

function pinit(runCommand) {
    /*if (term._initialized) {
        return;
    }*/
    let disposable;

    //term._initialized = true;

    term.prompt = () => {
        term.write('\r\n\x1b[1;31m$\x1b[0m ');
    };
    prompt(term);

    lastCommands.push('');
    cursor++;

    const CurrentCursor = cursor;

    disposable = term.onData(e => {
        switch (e) {
            case '\u0003': // Ctrl+C
                term.write('^C');
                prompt(term);
                break;
            case '\r': // Enter
                lastCommands.push(command);
                runCommand(term, command);
                command = '';
                break;

            case '\x1B[A':
                if (cursor > 0) {
                    cursor--;
                    
                    while(term._core.buffer.x > 2 && command.length > 0) {
                        term.write('\b \b');
                        if (command.length > 0) {
                            command = command.substr(0, command.length - 1);
                        }
                    }

                    command = lastCommands[cursor];
                    term.write(command);
                }
            break;

            case '\x1B[B':
                if (cursor + 1 < lastCommands.length) {
                    cursor++;
                    
                    while(term._core.buffer.x > 2 && command.length > 0) {
                        term.write('\b \b');
                        if (command.length > 0) {
                            command = command.substr(0, command.length - 1);
                        }
                    }

                    command = lastCommands[cursor];
                    term.write(command);
                }                
            break;

            case '\u007F': // Backspace (DEL)
                // Do not delete the prompt
                if (term._core.buffer.x > 2) {
                    term.write('\b \b');
                    if (command.length > 0) {
                        command = command.substr(0, command.length - 1);
                    }
                }
                break;
            case '\u0009':
                console.log('tabbed', output, ["dd", "ls"]);
                break;
            default:
                if (e >= String.fromCharCode(0x20) && e <= String.fromCharCode(0x7E) || e >= '\u00a0') {
                    command += e;
                    term.write(e);
                } else {
                    console.log({key: e});
                }
        }
    });

    return disposable;
}

function clearInput(command) {
    var inputLengh = command.length;
    for (var i = 0; i < inputLengh; i++) {
        term.write('\b \b');
    }
}
function prompt(term) {
    command = '';
    term.write('\r\n$ ');
}

/*function runCommand(term, command) {
    if (command.length > 0) {
        clearInput(command);
        socket.send(command + '\n');
        return;
    }
}*/


window.electronAPI.addPromt((event, id) => {
    let d;
    
    d = pinit(function (term, command) {
        if (command.length > 0) {
            clearInput(command);
            window.electronAPI.resolveInput(id, command) + '\n';
            d.dispose();
            return;
        }
    });

});


window.electronAPI.addDialog((event, id) => {

    /*const disposable = term.onData((str) => {
        console.log(str);
    });*/
    let disposable;
    term.write('\n');
    let ans = true;
    const name = generate();
    const check = (str) => {
        switch (str.key) {
            case '\x1B[D':
                ans = true;
                term.write('\r');
                term.write('\x1b[1;31m$\x1b[0m \x1b[46m yes \x1b[0m  \x1b[0m no  \x1b[0m');
            break;

            case '\x1B[C':
                ans = false;
                term.write('\r');
                term.write('\x1b[1;31m$\x1b[0m \x1b[0m yes \x1b[0m  \x1b[46m no  \x1b[0m');
            break;  
            
            case 'y':
                ans = true;
                term.write('\r');
                term.write('\x1b[1;31m$\x1b[0m \x1b[46m yes \x1b[0m  \x1b[0m no  \x1b[0m');
            break;

            case 'n':
                ans = false;
                term.write('\r');
                term.write('\x1b[1;31m$\x1b[0m \x1b[0m yes \x1b[0m  \x1b[0m no  \x1b[0m');
            break;    

            case 'н':
                ans = true;
                term.write('\r');
                term.write('\x1b[1;31m$\x1b[0m \x1b[46m yes \x1b[0m  \x1b[0m no  \x1b[0m');
            break;

            case 'т':
                ans = false;
                term.write('\r');
                term.write('\x1b[1;31m$\x1b[0m \x1b[0m yes \x1b[0m  \x1b[46m no  \x1b[0m');
            break;               
            
            case '\r':
                term.writeln(' ok!');
                term.writeln('');
                disposable.dispose();
                if (ans) window.electronAPI.resolveInput(id, true); else window.electronAPI.resolveInput(id, false);

            break;

            default:
                console.log(str);

        }
    }

    check({key: '\x1B[D'});

    disposable = term.onKey((str) => {
        check(str);
    });

    //window.electronAPI.resolveInput(id, true);
    

});

const runColorMode = (fn) => {
    if (!window.matchMedia) {
      return;
    }

    const query = window.matchMedia('(prefers-color-scheme: dark)');

    fn(query.matches);

    query.addEventListener('change', (event) => fn(event.matches));
  }

  runColorMode((isDarkMode) => {
    if (isDarkMode) {
      document.body.setAttribute('data-theme', 'dark');
    } else {
      document.body.removeAttribute('data-theme');
    }
  }); 

window.ifLinux = () => {
    if (navigator.appVersion.indexOf("X11") != -1) return true;
    if (navigator.appVersion.indexOf("Linux") != -1) return true;

    return false;
}

window.ifWin = () => {
    console.warn(navigator.appVersion);
    if (navigator.appVersion.indexOf('Win') != -1) return true;
    return false;
}

  if (ifLinux() || ifWin()) {
    document.body.style.background = "rgb(41, 45, 62)";
  }