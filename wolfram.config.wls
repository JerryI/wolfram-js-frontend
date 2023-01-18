<|
    "watch" -> "src",
    "merge" -> {
        "src/frontend.js",
        "https://raw.githubusercontent.com/JerryI/Mathematica-ThreeJS-graphics-engine/master/src/graphics3d.js"
    },
    "after" :> (
        RunProcess[{"./node_modules/.bin/rollup", "--config", "rollup.config.mjs"}]//Print;
        wcontent = StringJoin[Import["src/core.js", "String"], Import["build/bundle.js", "String"]];


        wcontent = StringReplace[wcontent, "const top = typeof globalThis"->"const top0 = typeof globalThis"];
        Export["build/bundle.js", wcontent, "String"];
        Print["merged"];        
    )
|>