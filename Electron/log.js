
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


window.electronAPI.clear(() => {
    term.clear();
    //alert('clear');
});


window.electronAPI.handleLogs((event, value, color) => {
    if (color) {
        term.writeln(color+value.replace(/(\n)/gm,"\r\n").trim()+'\x1b[0m');
    } else {
        term.writeln(value.replace(/(\n)/gm,"\r\n").trim()+'\x1b[0m');
    }
    
});

/*function runCommand(term, command) {
    if (command.length > 0) {
        clearInput(command);
        socket.send(command + '\n');
        return;
    }
}*/


window.electronAPI.addPromt((event, id, title) => {


});


window.electronAPI.addDialog((event, id, title) => {

    /*const disposable = term.onData((str) => {
        console.log(str);
    });*/
    

    const result = confirm(title);
    window.electronAPI.resolveInput(id, result);
    
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
    document.body.style.paddingTop = "0";
    logger.style.height = "auto";
    runColorMode((isDarkMode) => {
        if (isDarkMode) {
            document.body.style.background = "rgb(41, 45, 62)";
        } else {
            document.body.style.background = "rgb(255, 255, 250)";
        }
      }); 
    
  }