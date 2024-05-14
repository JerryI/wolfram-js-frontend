import { spawn } from 'child_process';
import { resolve as path } from 'path';

export = function (title: string, body: string, mask: boolean, defaultText: string = "", okButtonLabel?: string, cancelButtonLabel?: string): Promise<string | null> {
    return new Promise(resolve => {
        const inDist = __dirname.endsWith("dist") || __dirname.endsWith("dist/") || __dirname.endsWith("dist\\");
        const rootPath = path(__dirname, inDist ? "../" : '../../../');
        const boxSpawner = spawn("bash", [path(rootPath, "./native/linux/default.sh").replace("app.asar", "app.asar.unpacked"), title, body, defaultText, mask === true ? "--hide-text" : "", okButtonLabel ? "--ok-label=\"" + okButtonLabel + "\"" : "", cancelButtonLabel ? "--cancel-label=\"" + cancelButtonLabel + "\"" : ""]);

        boxSpawner.stdout.on('data', d => {
            const data = d.toString() as string;
            if (data) resolve(data.trim() || null);
        })

        boxSpawner.on('exit', () => resolve(null));
    })
}