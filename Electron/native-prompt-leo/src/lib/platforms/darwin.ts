import { spawn } from 'child_process';
import { resolve as path } from 'path';

export = function (title: string, body: string, mask: boolean, defaultText: string = ""): Promise<string | null> {
    return new Promise(resolve => {
        const nativePath = mask ? "./native/darwin/mask.scpt" : "./native/darwin/default.scpt";
        const boxSpawner = spawn("osascript", [path(__dirname, "../../../", nativePath).replace("app.asar", "app.asar.unpacked"), title, body, defaultText]);

        boxSpawner.stdout.on('data', d => {
            const data = d.toString() as string;
            if (data) resolve(data.trim().split("text returned:").pop() || null);
        })

        boxSpawner.on('exit', () => resolve(null));
    })
}