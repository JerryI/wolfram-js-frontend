require('dotenv').config();
import { existsSync } from 'fs';
import { join } from 'path';
import { notarize } from 'electron-notarize';

export default async function (params) {
if (process.platform !== 'darwin') {
return
}

    console.log('afterSign hook triggered', params)

    let appId = 'com.coffeeliqueur.wljs'

    let appPath = join(
        params.appOutDir,
        `${params.packager.appInfo.productFilename}.app`
    )
    if (!existsSync(appPath)) {
        console.log('skip')
        return
    }

    console.log(
        `Notarizing ${appId} found at ${appPath} with Apple ID ${process.env.APPLE_ID}`
    )

    try {
        await notarize({
            appBundleId: appId,
            appPath: appPath,
            appleId: process.env.APPLE_ID,
            appleIdPassword: process.env.APPLE_ID_PASSWORD,
            teamId: process.env.APPLE_TEAM_ID,
            tool: 'notarytool'
            
        })
    } catch (error) {
        console.error(error)
    }

    console.log(`Done notarizing ${appId}`)
}