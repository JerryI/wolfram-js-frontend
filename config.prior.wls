wconfig = <|
    "watch" -> "src",
    "merge" -> {
        "src/frontend.js",
        "src/misc.js",
        "https://raw.githubusercontent.com/JerryI/Mathematica-ThreeJS-graphics-engine/master/src/graphics3d.js"
    },
    "after" :> (
        (* copy core files *)
        CopyFile["src/core.js", "public/assets/core.js", OverwriteTarget->True];

        CopyFile["src/converter.wls", "modules/converter.wls", OverwriteTarget->True];
        Import["modules/converter.wls"];

        CopyFile["src/notebook.wls", "modules/notebook.wls", OverwriteTarget->True];
        Import["modules/notebook.wls"];

        CopyFile["src/cells.wls", "modules/cells.wls", OverwriteTarget->True];
        Import["modules/cells.wls"];

        CopyFile["src/webobjects.wls", "shared/webobjects.wls", OverwriteTarget->True];
        Import["shared/webobjects.wls"];

        (* Rollup a bundle for graphics and cells*)
        RunProcess[{"./node_modules/.bin/rollup", "--config", "rollup.config.mjs"}]//Print;

        (* To change the order of the function. Rollup puts "var core" to the bottom, which is wrong *)
        wcontent = Import["temp/bundle.js", "String"];

        (* A bug of CodeMirror *)
        wcontent = StringReplace[wcontent, "const top = typeof globalThis"->"const top0 = typeof globalThis"];

        (* Export the modified bundle *)
        Export["public/assets/notebooks/bundle.js", wcontent, "String"];
        Print["merged"];        
    )
|>