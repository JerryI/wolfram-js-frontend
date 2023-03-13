<|
    "watch" -> {"JSFrontend", "WebObjects"},
    "recipy" :> {
        (* merge and bundle the files *)
        MergeFiles[{
                "JSFrontend/frontend.js",
                "JSFrontend/graphics3d.js",
                FileNames["*.js", "WebObjects", Infinity]
            } -> "Temp/merged.js"
        ],

        (* rolling up using Node *)
        Print[Green<>"rolling up..."], Print[Reset],
        RunProcess[{"./node_modules/.bin/rollup", "--config", "rollup.config.mjs"}]["StandardError"]//Print,
        Print[Green<>"done"], Print[Reset],

        (* merge in the right sequence, because core.js is not a ~real JS module~ and needed to be added separately *)
        MergeFiles[{
                "JSFrontend/interpreter.js",
                "Temp/bundle.js",
                "JSFrontend/sockets.js"
            } -> "public/js/bundle.js",

            (* annoying bugs as a consiquence of non-strict compilation using Rollup *)
            (* chromee issue was on Firefox browsers as well as on Vivalldi *)
            (* Safari - OK, Chrome - OK, Firefox - OK, Vivaldi - OK *)

            "PostProcess" -> (StringReplace[#, {
                "const top = typeof globalThis"->"const top0 = typeof globalThis", 
                "chrome"->"chromee"
            }]&)
        ]

    }
|>