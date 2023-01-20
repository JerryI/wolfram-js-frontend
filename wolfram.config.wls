<|
    "watch" -> "src",
    "merge" -> {
        "src/frontend.js",
        "https://raw.githubusercontent.com/JerryI/Mathematica-ThreeJS-graphics-engine/master/src/graphics3d.js"
    },
    "after" :> (
        (* Rollup to a bundle *)
        RunProcess[{"./node_modules/.bin/rollup", "--config", "rollup.config.mjs"}]//Print;

        (* To change the order of the function. Rollup puts "var core" to the bottom, which is wrong *)
        wcontent = StringJoin[Import["src/core.js", "String"], Import["build/bundle.js", "String"]];

        (* A bug of CodeMirror *)
        wcontent = StringReplace[wcontent, "const top = typeof globalThis"->"const top0 = typeof globalThis"];

        (* Export the modified bundle *)
        Export["build/bundle.js", wcontent, "String"];
        Print["merged"];        
    )
|>