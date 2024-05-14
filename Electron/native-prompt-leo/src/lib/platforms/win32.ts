import { spawn } from 'child_process';
import { resolve as path } from 'path';

/*
export function displayBox(title: string, body: string, defaultText: string = ""): Promise<string | null> {
    return new Promise(resolve => {
        const inDist = __dirname.endsWith("dist") || __dirname.endsWith("dist/") || __dirname.endsWith("dist\\");
        const rootPath = path(__dirname, inDist ? "../" : '../../../');
        const boxSpawner = spawn("cscript", [path(rootPath, 'native/win32/default.vbs').replace("app.asar", "app.asar.unpacked"), title, body, defaultText]);

        boxSpawner.stdout.on('data', (d: string) => {
            let data = d.toString();
            if(data.startsWith("RETURN")) data = data.slice("RETURN".length);
            if(data.startsWith("Microsoft")) return;
            data = atob(data);
            data = data.trim();
            let unproccessedText = "";
            for(let i = 0;i < data.length;i++) {
                const currentChar = data.charAt(i);
                if(currentChar === "/" && data.charAt(i + 1) === "\\") {
                    unproccessedText += "\\";
                    i++;
                }
                else if(currentChar === "\\") {
                    const charCodeEnd = data.indexOf("\\", i + 1);
                    if(charCodeEnd === -1) {
                        unproccessedText += "\\";
                        continue;
                    }
                    const charCode = parseInt(data.slice(i + 1, charCodeEnd));
                    if(Number.isNaN(charCode)) {
                        unproccessedText += "\\";
                        continue;
                    }
                    unproccessedText += String.fromCharCode(charCode);
                    i = charCodeEnd;
                }
                else unproccessedText += currentChar;
            }
            resolve(unproccessedText || null);
        })

        boxSpawner.on('exit', () => resolve(null));
    })
}
*/

export function displayBox(title: string, body: string, defaultText: string = "", okButtonLabel: string = "Ok", cancelButtonLabel: string = "Cancel"): Promise<string | null> {
    return new Promise(resolve => {
        const inDist = __dirname.endsWith("dist") || __dirname.endsWith("dist/") || __dirname.endsWith("dist\\");
        const rootPath = path(__dirname, inDist ? "../" : '../../../');
        const boxSpawner = spawn("powershell", ["-ExecutionPolicy", "Bypass", "-File", path(rootPath, 'native/win32/moreAcurateInput.ps1').replace("app.asar", "app.asar.unpacked"), title, body, defaultText, okButtonLabel || "Ok", cancelButtonLabel || "Cancel"]);

        boxSpawner.stdout.on('data', (d: string) => {
            let data = d.toString();
            if(!data.startsWith("RETURN")) return;
            data = data.slice("RETURN".length);
            data = data.trim();
            let unproccessedText = "";
            for(let i = 0;i < data.length;i++) {
                const currentChar = data.charAt(i);
                if(currentChar === "/" && data.charAt(i + 1) === "\\") {
                    unproccessedText += "\\";
                    i++;
                }
                else if(currentChar === "\\") {
                    const charCodeEnd = data.indexOf("\\", i + 1);
                    if(charCodeEnd === -1) {
                        unproccessedText += "\\";
                        continue;
                    }
                    const charCode = parseInt(data.slice(i + 1, charCodeEnd));
                    if(Number.isNaN(charCode)) {
                        unproccessedText += "\\";
                        continue;
                    }
                    unproccessedText += String.fromCharCode(charCode);
                    i = charCodeEnd;
                }
                else unproccessedText += currentChar;
            }
            resolve(unproccessedText || null);
        })

        boxSpawner.on('exit', () => resolve(null));
    })
}

export function displayMask(title: string, body: string, defaultText: string = "", okButtonLabel: string = "Ok", cancelButtonLabel: string = "Cancel"): Promise<string | null> {
    return new Promise(resolve => {
        const inDist = __dirname.endsWith("dist") || __dirname.endsWith("dist/") || __dirname.endsWith("dist\\");
        const rootPath = path(__dirname, inDist ? "../" : '../../../');
        const boxSpawner = spawn("powershell", ["-ExecutionPolicy", "Bypass", "-File", path(rootPath, 'native/win32/mask.ps1').replace("app.asar", "app.asar.unpacked"), title, body, defaultText, okButtonLabel || "Ok", cancelButtonLabel || "Cancel"]);

        boxSpawner.stdout.on('data', (d: string) => {
            let data = d.toString();
            if(!data.startsWith("RETURN")) return;
            data = data.slice("RETURN".length);
            data = data.trim();
            let unproccessedText = "";
            for(let i = 0;i < data.length;i++) {
                const currentChar = data.charAt(i);
                if(currentChar === "/" && data.charAt(i + 1) === "\\") {
                    unproccessedText += "\\";
                    i++;
                }
                else if(currentChar === "\\") {
                    const charCodeEnd = data.indexOf("\\", i + 1);
                    if(charCodeEnd === -1) {
                        unproccessedText += "\\";
                        continue;
                    }
                    const charCode = parseInt(data.slice(i + 1, charCodeEnd));
                    if(Number.isNaN(charCode)) {
                        unproccessedText += "\\";
                        continue;
                    }
                    unproccessedText += String.fromCharCode(charCode);
                    i = charCodeEnd;
                }
                else unproccessedText += currentChar;
            }
            resolve(unproccessedText || null);
        })

        boxSpawner.on('exit', () => resolve(null));
    })
}