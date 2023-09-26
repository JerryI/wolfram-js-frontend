
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
        term.writeln(color+value+'\x1b[0m');
    } else {
        term.writeln(value);
    }
    
});

window.electronAPI.addPromt((event, id) => {
    let disposable;
    let Disposable;
    //term.write('\n\r');
    const entity = [];
    let cursor = 0;
    const name = generate();

    //term.write('\x1b[1;31m'+ name +'>\x1b[0m ');
    

    disposable = term.onData((str) => {
        entity.push(str);
        term.write(str);
        console.log(str);
        cursor++;
    });

    Disposable = term.onKey((str) => {
        if (str.key == '\x7F') {
            cursor--;
            entity.pop();
            term.write('\b');
        }
        if (str.key == '\r') {
            window.electronAPI.resolveInput(id, entity.join(''));
            term.write('\n\r');

            Disposable.dispose();
            disposable.dispose();
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
                term.write('\x1b[1;31m'+ name +'> \x1b[0m\x1b[46m yes \x1b[0m  no ');
            break;

            case '\x1B[C':
                ans = false;
                term.write('\r');
                term.write('\x1b[1;31m'+ name +'>  \x1b[0m yes  \x1b[46m no \x1b[0m');
            break;  
            
            case 'y':
                ans = true;
                term.write('\r');
                term.write('\x1b[1;31m'+ name +'> \x1b[0m\x1b[46m yes \x1b[0m  no ');
            break;

            case 'n':
                ans = false;
                term.write('\r');
                term.write('\x1b[1;31m'+ name +'>  \x1b[0m yes  \x1b[46m no \x1b[0m');
            break;    

            case 'н':
                ans = true;
                term.write('\r');
                term.write('\x1b[1;31m'+ name +'> \x1b[0m\x1b[46m yes \x1b[0m  no ');
            break;

            case 'т':
                ans = false;
                term.write('\r');
                term.write('\x1b[1;31m'+ name +'>  \x1b[0m yes  \x1b[46m no \x1b[0m');
            break;               
            
            case '\r':
                term.writeln('ok!');
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
