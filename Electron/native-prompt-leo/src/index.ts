import checkPlatform from './lib/platform-check';
import { win32, linux, darwin } from './lib/platforms';

const platform = checkPlatform();

type Options = {
    defaultText?: string,
    mask?: boolean,
    okButtonLabel?: string,
    cancelButtonLabel?: string
}

export = async function (title: string, body: string, options: Options = {}): Promise<string | null> {
    const defaultText: string = options.defaultText || "";
    const okButtonLabel = options.okButtonLabel || null;
    const cancelButtonLabel = options.cancelButtonLabel || null;
    
    switch (platform) {
        case 'win32': {
            if (options.mask) return await win32.displayMask(title, body, defaultText, okButtonLabel, cancelButtonLabel);
            else return await win32.displayBox(title, body, defaultText, okButtonLabel, cancelButtonLabel);
        }
        case 'linux': return await linux(title, body, options.mask, defaultText, okButtonLabel, cancelButtonLabel);
        case 'darwin': return await darwin(title, body, options.mask, defaultText);
    }
}