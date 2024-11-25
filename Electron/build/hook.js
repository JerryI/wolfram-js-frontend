//@ts-check
const { promises: fs } = require( 'fs' )
const log = ( ...messages ) => console.log( ...messages )

exports.default = async function( context ) {

    const troublesome_files = [
        `dist/mac-arm64/WLJS Notebook.app/Contents/Resources/app/node_modules/electron-sudo/LICENSE`,
        `dist/mac-arm64/WLJS Notebook.app/Contents/Resources/app/node_modules/electron-sudo/dist/bin/applet.app/LICENSE`,
        `dist/mac-arm64/WLJS Notebook.app/Contents/Resources/app/node_modules/electron-sudo/src/bin/applet.app/LICENSE`
    ]

    try {
        log( '\n\n🪝 afterPack hook triggered: ' )
        await Promise.all( troublesome_files.map( file => {
            log( `Deleting ${ file }` )
            return fs.rm( file )
        } ) )
        log( 'Cleaned up LICENSE files\n\n' )
        return context
    } catch( e ) {
        log( `afterPack issue: `, e )
    }

}